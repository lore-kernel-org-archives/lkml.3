Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3LPMSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:18:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:26503 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab3LPMSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:18:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,494,1384329600"; 
   d="scan'208";a="452942943"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH] perf: Disable all pmus on unthrottling and rescheduling
Date: Mon, 16 Dec 2013 14:17:36 +0200
Message-Id: <1387196256-8030-1-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, only one pmu in a context gets disabled during unthrottling
and event_sched_{out,in}, however, events in one context may belong to
different pmus, which results in pmus being reprogrammed while they are
still enabled. This patch temporarily disables pmus that correspond to
each event in the context while these events are being modified.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/events/core.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 403b781..8826fb1 100644
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
-- 
1.8.5.1

