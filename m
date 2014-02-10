Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaBJRpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:45:15 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63596 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673AbaBJRpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:45:03 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: will.deacon@arm.com, dave.martin@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 5/7] perf: kill pmu::hrtimer_interval_ms
Date: Mon, 10 Feb 2014 17:44:22 +0000
Message-Id: <1392054264-23570-6-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hrtimers affecting a pmu live in perf_cpu_context, which may be
shared by multiple pmus. As such it does not make sense for the pmu to
track the interval, which is a property of the shared context.

This patch removes pmu::hrtimer_interval_ms, and reworks all existing
users to use perf_cpu_context::hrtimer_interval instead. No pmu
implementations currently override the default hrtimer_interval_ms
statically, so we don't lose any existing implementation-specific
intervals (which could themselves be problematic if two pmus had
different hrtimer_interval_ms values).

While we're in the area we also replace uses of
ns_to_ktime(NSEC_PER_MSEC * $x) with ms_to_ktime($x), which does the
same thing.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/perf_event.h |  1 -
 kernel/events/core.c       | 24 +++++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index df3d34a..7794a39 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -180,7 +180,6 @@ struct pmu {
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
 	int				task_ctx_nr;
-	int				hrtimer_interval_ms;
 
 	/*
 	 * Fully disable/enable this PMU, can be used to protect from the PMI
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 13ede70..710c3fe 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -816,14 +816,11 @@ static void __perf_cpu_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
 		return;
 
 	/*
-	 * check default is sane, if not set then force to
-	 * default interval (1/tick)
+	 * Set sane default interval (1/tick)
 	 */
-	timer = pmu->hrtimer_interval_ms;
-	if (timer < 1)
-		timer = pmu->hrtimer_interval_ms = PERF_CPU_HRTIMER;
+	timer = PERF_CPU_HRTIMER;
 
-	cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
+	cpuctx->hrtimer_interval = ms_to_ktime(timer);
 
 	hrtimer_init(hr, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
 	hr->function = perf_cpu_hrtimer_handler;
@@ -6346,14 +6343,21 @@ type_show(struct device *dev, struct device_attribute *attr, char *page)
 }
 static DEVICE_ATTR_RO(type);
 
+static int get_pmu_hrtimer_interval(struct pmu *pmu)
+{
+	struct perf_cpu_context *cpu_ctx = this_cpu_ptr(pmu->pmu_cpu_context);
+	return ktime_to_ms(cpu_ctx->hrtimer_interval);
+}
+
 static ssize_t
 perf_event_mux_interval_ms_show(struct device *dev,
 				struct device_attribute *attr,
 				char *page)
 {
 	struct pmu *pmu = dev_get_drvdata(dev);
+	int interval_ms = get_pmu_hrtimer_interval(pmu);
 
-	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->hrtimer_interval_ms);
+	return snprintf(page, PAGE_SIZE-1, "%d\n", interval_ms);
 }
 
 static ssize_t
@@ -6372,16 +6376,14 @@ perf_event_mux_interval_ms_store(struct device *dev,
 		return -EINVAL;
 
 	/* same value, noting to do */
-	if (timer == pmu->hrtimer_interval_ms)
+	if (timer == get_pmu_hrtimer_interval(pmu))
 		return count;
 
-	pmu->hrtimer_interval_ms = timer;
-
 	/* update all cpuctx for this PMU */
 	for_each_possible_cpu(cpu) {
 		struct perf_cpu_context *cpuctx;
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
-		cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
+		cpuctx->hrtimer_interval = ms_to_ktime(timer);
 
 		if (hrtimer_active(&cpuctx->hrtimer))
 			hrtimer_forward_now(&cpuctx->hrtimer, cpuctx->hrtimer_interval);
-- 
1.8.1.1

