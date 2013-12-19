Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3LSQwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:52:50 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33818 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3LSQws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:52:48 -0500
Date: Thu, 19 Dec 2013 17:52:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20131219165242.GA30019@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 189b84fb54490ae24111124346a8e63f8e019385 perf: Document the new transaction sample type

An ABI documentation fix, and a mixed-PMU perf-info-corruption fix.

 Thanks,

	Ingo

------------------>
Alexander Shishkin (1):
      perf: Disable all pmus on unthrottling and rescheduling

Vince Weaver (1):
      perf: Document the new transaction sample type


 include/uapi/linux/perf_event.h |  1 +
 kernel/events/core.c            | 21 ++++++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e1802d6..959d454 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -679,6 +679,7 @@ enum perf_event_type {
 	 *
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
+	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
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
