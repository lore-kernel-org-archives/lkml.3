Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab3HPSs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:48:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab3HPSsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:48:21 -0400
Date: Fri, 16 Aug 2013 11:47:46 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-948b26b6ddd08a57cb95ebb0dc96fde2edd5c383@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1375460996-16329-3-git-send-email-fweisbec@gmail.com>
References: <1375460996-16329-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Account freq events globally
Git-Commit-ID: 948b26b6ddd08a57cb95ebb0dc96fde2edd5c383
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Aug 2013 11:47:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  948b26b6ddd08a57cb95ebb0dc96fde2edd5c383
Gitweb:     http://git.kernel.org/tip/948b26b6ddd08a57cb95ebb0dc96fde2edd5c383
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 2 Aug 2013 18:29:55 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Aug 2013 17:55:51 +0200

perf: Account freq events globally

Freq events may not always be affine to a particular CPU. As such,
account_event_cpu() may crash if we account per cpu a freq event
that has event->cpu == -1.

To solve this, lets account freq events globally. In practice
this doesn't change much the picture because perf tools create
per-task perf events with one event per CPU by default. Profiling a
single CPU is usually a corner case so there is no much point in
optimizing things that way.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1375460996-16329-3-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e82e700..2e675e8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -141,11 +141,11 @@ enum event_type_t {
 struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
-static DEFINE_PER_CPU(atomic_t, perf_freq_events);
 
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
+static atomic_t nr_freq_events __read_mostly;
 
 static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
@@ -1871,9 +1871,6 @@ static int  __perf_install_in_context(void *info)
 	perf_pmu_enable(cpuctx->ctx.pmu);
 	perf_ctx_unlock(cpuctx, task_ctx);
 
-	if (atomic_read(&__get_cpu_var(perf_freq_events)))
-		tick_nohz_full_kick();
-
 	return 0;
 }
 
@@ -2811,7 +2808,7 @@ done:
 #ifdef CONFIG_NO_HZ_FULL
 bool perf_event_can_stop_tick(void)
 {
-	if (atomic_read(&__get_cpu_var(perf_freq_events)) ||
+	if (atomic_read(&nr_freq_events) ||
 	    __this_cpu_read(perf_throttled_count))
 		return false;
 	else
@@ -3140,9 +3137,6 @@ static void unaccount_event_cpu(struct perf_event *event, int cpu)
 	}
 	if (is_cgroup_event(event))
 		atomic_dec(&per_cpu(perf_cgroup_events, cpu));
-
-	if (event->attr.freq)
-		atomic_dec(&per_cpu(perf_freq_events, cpu));
 }
 
 static void unaccount_event(struct perf_event *event)
@@ -3158,6 +3152,8 @@ static void unaccount_event(struct perf_event *event)
 		atomic_dec(&nr_comm_events);
 	if (event->attr.task)
 		atomic_dec(&nr_task_events);
+	if (event->attr.freq)
+		atomic_dec(&nr_freq_events);
 	if (is_cgroup_event(event))
 		static_key_slow_dec_deferred(&perf_sched_events);
 	if (has_branch_stack(event))
@@ -6489,9 +6485,6 @@ static void account_event_cpu(struct perf_event *event, int cpu)
 	}
 	if (is_cgroup_event(event))
 		atomic_inc(&per_cpu(perf_cgroup_events, cpu));
-
-	if (event->attr.freq)
-		atomic_inc(&per_cpu(perf_freq_events, cpu));
 }
 
 static void account_event(struct perf_event *event)
@@ -6507,6 +6500,10 @@ static void account_event(struct perf_event *event)
 		atomic_inc(&nr_comm_events);
 	if (event->attr.task)
 		atomic_inc(&nr_task_events);
+	if (event->attr.freq) {
+		if (atomic_inc_return(&nr_freq_events) == 1)
+			tick_nohz_full_kick_all();
+	}
 	if (has_branch_stack(event))
 		static_key_slow_inc(&perf_sched_events.key);
 	if (is_cgroup_event(event))
