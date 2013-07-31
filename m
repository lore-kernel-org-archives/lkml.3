Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab3GaI5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:57:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282Ab3GaI5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:57:36 -0400
Date: Wed, 31 Jul 2013 01:56:58 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-d84153d6c96f61aa06429586284639f32debf03e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1374539466-4799-8-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-8-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Implement finer grained full dynticks kick
Git-Commit-ID: d84153d6c96f61aa06429586284639f32debf03e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 01:57:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d84153d6c96f61aa06429586284639f32debf03e
Gitweb:     http://git.kernel.org/tip/d84153d6c96f61aa06429586284639f32debf03e
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 23 Jul 2013 02:31:05 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Jul 2013 22:29:15 +0200

perf: Implement finer grained full dynticks kick

Currently the full dynticks subsystem keep the
tick alive as long as there are perf events running.

This prevents the tick from being stopped as long as features
such that the lockup detectors are running. As a temporary fix,
the lockup detector is disabled by default when full dynticks
is built but this is not a long term viable solution.

To fix this, only keep the tick alive when an event configured
with a frequency rather than a period is running on the CPU,
or when an event throttles on the CPU.

These are the only purposes of the perf tick, especially now that
the rotation of flexible events is handled from a seperate hrtimer.
The tick can be shutdown the rest of the time.

Original-patch-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1374539466-4799-8-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3fe385a..916cf1f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -870,12 +870,8 @@ static void perf_pmu_rotate_start(struct pmu *pmu)
 
 	WARN_ON(!irqs_disabled());
 
-	if (list_empty(&cpuctx->rotation_list)) {
-		int was_empty = list_empty(head);
+	if (list_empty(&cpuctx->rotation_list))
 		list_add(&cpuctx->rotation_list, head);
-		if (was_empty)
-			tick_nohz_full_kick();
-	}
 }
 
 static void get_ctx(struct perf_event_context *ctx)
@@ -1875,6 +1871,9 @@ static int  __perf_install_in_context(void *info)
 	perf_pmu_enable(cpuctx->ctx.pmu);
 	perf_ctx_unlock(cpuctx, task_ctx);
 
+	if (atomic_read(&__get_cpu_var(perf_freq_events)))
+		tick_nohz_full_kick();
+
 	return 0;
 }
 
@@ -2812,10 +2811,11 @@ done:
 #ifdef CONFIG_NO_HZ_FULL
 bool perf_event_can_stop_tick(void)
 {
-	if (list_empty(&__get_cpu_var(rotation_list)))
-		return true;
-	else
+	if (atomic_read(&__get_cpu_var(perf_freq_events)) ||
+	    __this_cpu_read(perf_throttled_count))
 		return false;
+	else
+		return true;
 }
 #endif
 
@@ -5202,6 +5202,7 @@ static int __perf_event_overflow(struct perf_event *event,
 			__this_cpu_inc(perf_throttled_count);
 			hwc->interrupts = MAX_INTERRUPTS;
 			perf_log_throttle(event, 0);
+			tick_nohz_full_kick();
 			ret = 1;
 		}
 	}
