Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab3LKMhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:37:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:36392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab3LKMhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:37:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450496975"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v0 01/71] perf: Disable all pmus on unthrottling and rescheduling
Date: Wed, 11 Dec 2013 14:36:13 +0200
Message-Id: <1386765443-26966-2-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, only one pmu in a context gets disabled during unthrottling
and event_sched_{out,in}, however, events in one context may belong to
different pmus, which results in pmus being reprogrammed while they are
still enabled. This patch temporarily disables pmus that correspond to
each event in the context while these events are being modified.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 403b781..d656cd6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1396,6 +1396,9 @@ event_sched_out(struct perf_event *event,
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
 		return;
 
+	if (event->pmu != ctx->pmu)
+		perf_pmu_disable(event->pmu);
+
 	event->state = PERF_EVENT_STATE_INACTIVE;
 	if (event->pending_disable) {
 		event->pending_disable = 0;
@@ -1412,6 +1415,9 @@ event_sched_out(struct perf_event *event,
 		ctx->nr_freq--;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
+
+	if (event->pmu != ctx->pmu)
+		perf_pmu_enable(event->pmu);
 }
 
 static void
@@ -1652,6 +1658,7 @@ event_sched_in(struct perf_event *event,
 		 struct perf_event_context *ctx)
 {
 	u64 tstamp = perf_event_time(event);
+	int ret = 0;
 
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
@@ -1674,10 +1681,14 @@ event_sched_in(struct perf_event *event,
 	 */
 	smp_wmb();
 
+	if (event->pmu != ctx->pmu)
+		perf_pmu_disable(event->pmu);
+
 	if (event->pmu->add(event, PERF_EF_START)) {
 		event->state = PERF_EVENT_STATE_INACTIVE;
 		event->oncpu = -1;
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out;
 	}
 
 	event->tstamp_running += tstamp - event->tstamp_stopped;
@@ -1693,7 +1704,11 @@ event_sched_in(struct perf_event *event,
 	if (event->attr.exclusive)
 		cpuctx->exclusive = 1;
 
-	return 0;
+out:
+	if (event->pmu != ctx->pmu)
+		perf_pmu_enable(event->pmu);
+
+	return ret;
 }
 
 static int
@@ -2743,6 +2758,9 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 		if (!event_filter_match(event))
 			continue;
 
+		if (ctx->pmu != event->pmu)
+			perf_pmu_disable(event->pmu);
+
 		hwc = &event->hw;
 
 		if (hwc->interrupts == MAX_INTERRUPTS) {
@@ -2752,7 +2770,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 		}
 
 		if (!event->attr.freq || !event->attr.sample_freq)
-			continue;
+			goto next;
 
 		/*
 		 * stop the event and update event->count
@@ -2774,6 +2792,9 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 			perf_adjust_period(event, period, delta, false);
 
 		event->pmu->start(event, delta > 0 ? PERF_EF_RELOAD : 0);
+	next:
+		if (ctx->pmu != event->pmu)
+			perf_pmu_enable(event->pmu);
 	}
 
 	perf_pmu_enable(ctx->pmu);
-- 
1.8.5.1

