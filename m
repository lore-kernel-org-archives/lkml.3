Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3LRKcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:32:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3LRKcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:32:22 -0500
Date: Wed, 18 Dec 2013 02:31:41 -0800
From: tip-bot for Alexander Shishkin <tipbot@zytor.com>
Message-ID: <tip-443772776c69ac9293d66b4d69fd9af16299cc2a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, efault@gmx.de, peterz@infradead.org,
        alexander.shishkin@linux.intel.com, fweisbec@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        efault@gmx.de, alexander.shishkin@linux.intel.com, fweisbec@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1387196256-8030-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1387196256-8030-1-git-send-email-alexander.shishkin@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Disable all pmus on unthrottling and rescheduling
Git-Commit-ID: 443772776c69ac9293d66b4d69fd9af16299cc2a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:31:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  443772776c69ac9293d66b4d69fd9af16299cc2a
Gitweb:     http://git.kernel.org/tip/443772776c69ac9293d66b4d69fd9af16299cc2a
Author:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
AuthorDate: Mon, 16 Dec 2013 14:17:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:04:00 +0100

perf: Disable all pmus on unthrottling and rescheduling

Currently, only one PMU in a context gets disabled during unthrottling
and event_sched_{out,in}(), however, events in one context may belong to
different pmus, which results in PMUs being reprogrammed while they are
still enabled.

This means that mixed PMU use [which is rare in itself] resulted in
potentially completely unreliable results: corrupted events, bogus
results, etc.

This patch temporarily disables PMUs that correspond to
each event in the context while these events are being modified.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: http://lkml.kernel.org/r/1387196256-8030-1-git-send-email-alexander.shishkin@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 72348dc..f574401 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1396,6 +1396,8 @@ event_sched_out(struct perf_event *event,
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
 		return;
 
+	perf_pmu_disable(event->pmu);
+
 	event->state = PERF_EVENT_STATE_INACTIVE;
 	if (event->pending_disable) {
 		event->pending_disable = 0;
@@ -1412,6 +1414,8 @@ event_sched_out(struct perf_event *event,
 		ctx->nr_freq--;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
+
+	perf_pmu_enable(event->pmu);
 }
 
 static void
@@ -1652,6 +1656,7 @@ event_sched_in(struct perf_event *event,
 		 struct perf_event_context *ctx)
 {
 	u64 tstamp = perf_event_time(event);
+	int ret = 0;
 
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
@@ -1674,10 +1679,13 @@ event_sched_in(struct perf_event *event,
 	 */
 	smp_wmb();
 
+	perf_pmu_disable(event->pmu);
+
 	if (event->pmu->add(event, PERF_EF_START)) {
 		event->state = PERF_EVENT_STATE_INACTIVE;
 		event->oncpu = -1;
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out;
 	}
 
 	event->tstamp_running += tstamp - event->tstamp_stopped;
@@ -1693,7 +1701,10 @@ event_sched_in(struct perf_event *event,
 	if (event->attr.exclusive)
 		cpuctx->exclusive = 1;
 
-	return 0;
+out:
+	perf_pmu_enable(event->pmu);
+
+	return ret;
 }
 
 static int
@@ -2743,6 +2754,8 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 		if (!event_filter_match(event))
 			continue;
 
+		perf_pmu_disable(event->pmu);
+
 		hwc = &event->hw;
 
 		if (hwc->interrupts == MAX_INTERRUPTS) {
@@ -2752,7 +2765,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 		}
 
 		if (!event->attr.freq || !event->attr.sample_freq)
-			continue;
+			goto next;
 
 		/*
 		 * stop the event and update event->count
@@ -2774,6 +2787,8 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 			perf_adjust_period(event, period, delta, false);
 
 		event->pmu->start(event, delta > 0 ? PERF_EF_RELOAD : 0);
+	next:
+		perf_pmu_enable(event->pmu);
 	}
 
 	perf_pmu_enable(ctx->pmu);
