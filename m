Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058Ab3DCMW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:22:28 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:43374 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761939Ab3DCMWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:22:23 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v6 2/2] perf: add sysfs entry to adjust multiplexing interval per PMU
Date: Wed,  3 Apr 2013 14:21:34 +0200
Message-Id: <1364991694-5876-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364991694-5876-1-git-send-email-eranian@google.com>
References: <1364991694-5876-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds /sys/device/xxx/perf_event_mux_interval_ms to ajust the
multiplexing interval per PMU. The unit is milliseconds. Value
has to be >= 1.

In the 4th version, we renamed the sysfs file to be more
consistent with the other /proc/sys/kernel entries for
perf_events.

In the 5th version, we handle the reprogramming of the
hrtimer using hrtimer_forward_now(). That way, we sync
up to new timer value quickly (suggested by Jiri Olsa).

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |    1 +
 kernel/events/core.c       |   63 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 72e3dc3..8ca53e4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -194,6 +194,7 @@ struct pmu {
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
 	int				task_ctx_nr;
+	int				hrtimer_interval_ms;
 
 	/*
 	 * Fully disable/enable this PMU, can be used to protect from the PMI
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d22f408..2ccafb0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -707,13 +707,21 @@ static void __perf_cpu_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
 {
 	struct hrtimer *hr = &cpuctx->hrtimer;
 	struct pmu *pmu = cpuctx->ctx.pmu;
+	int timer;
 
 	/* no multiplexing needed for SW PMU */
 	if (pmu->task_ctx_nr == perf_sw_context)
 		return;
 
-	cpuctx->hrtimer_interval =
-		ns_to_ktime(NSEC_PER_MSEC * PERF_CPU_HRTIMER);
+	/*
+	 * check default is sane, if not set then force to
+	 * default interval (1/tick)
+	 */
+	timer = pmu->hrtimer_interval_ms;
+	if (timer < 1)
+		timer = pmu->hrtimer_interval_ms = PERF_CPU_HRTIMER;
+
+	cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
 
 	hrtimer_init(hr, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
 	hr->function = perf_cpu_hrtimer_handler;
@@ -6030,9 +6038,56 @@ type_show(struct device *dev, struct device_attribute *attr, char *page)
 	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->type);
 }
 
+static ssize_t
+perf_event_mux_interval_ms_show(struct device *dev,
+				struct device_attribute *attr,
+				char *page)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->hrtimer_interval_ms);
+}
+
+static ssize_t
+perf_event_mux_interval_ms_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+	int timer, cpu, ret;
+
+	ret = kstrtoint(buf, 0, &timer);
+	if (ret)
+		return ret;
+
+	if (timer < 1)
+		return -EINVAL;
+
+	/* same value, noting to do */
+	if (timer == pmu->hrtimer_interval_ms)
+		return count;
+
+	pmu->hrtimer_interval_ms = timer;
+
+	/* update all cpuctx for this PMU */
+	for_each_possible_cpu(cpu) {
+		struct perf_cpu_context *cpuctx;
+		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
+		cpuctx->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
+
+		if (hrtimer_active(&cpuctx->hrtimer))
+			hrtimer_forward_now(&cpuctx->hrtimer, cpuctx->hrtimer_interval);
+	}
+
+	return count;
+}
+
+#define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
+
 static struct device_attribute pmu_dev_attrs[] = {
-       __ATTR_RO(type),
-       __ATTR_NULL,
+	__ATTR_RO(type),
+	__ATTR_RW(perf_event_mux_interval_ms),
+	__ATTR_NULL,
 };
 
 static int pmu_bus_running;
-- 
1.7.9.5

