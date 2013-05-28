Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974Ab3E1M76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:59:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50018 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab3E1M75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:59:57 -0400
Date: Tue, 28 May 2013 05:59:14 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-62b8563979273424d6ebe9201e34d1acc133ad4f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1364991694-5876-3-git-send-email-eranian@google.com>
References: <1364991694-5876-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Add sysfs entry to adjust multiplexing interval per PMU
Git-Commit-ID: 62b8563979273424d6ebe9201e34d1acc133ad4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62b8563979273424d6ebe9201e34d1acc133ad4f
Gitweb:     http://git.kernel.org/tip/62b8563979273424d6ebe9201e34d1acc133ad4f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 3 Apr 2013 14:21:34 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:13:51 +0200

perf: Add sysfs entry to adjust multiplexing interval per PMU

This patch adds /sys/device/xxx/perf_event_mux_interval_ms to ajust
the multiplexing interval per PMU. The unit is milliseconds. Value has
to be >= 1.

In the 4th version, we renamed the sysfs file to be more consistent
with the other /proc/sys/kernel entries for perf_events.

In the 5th version, we handle the reprogramming of the hrtimer using
hrtimer_forward_now(). That way, we sync up to new timer value quickly
(suggested by Jiri Olsa).

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/r/1364991694-5876-3-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 63 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 72138d7..6fddac1 100644
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
index 97bfac7..53d1b30 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -723,13 +723,21 @@ static void __perf_cpu_hrtimer_init(struct perf_cpu_context *cpuctx, int cpu)
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
@@ -6001,9 +6009,56 @@ type_show(struct device *dev, struct device_attribute *attr, char *page)
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
