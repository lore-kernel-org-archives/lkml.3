Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3JGQKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:10:00 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:41415 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab3JGQJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:09:51 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com
Subject: [PATCH v1 2/2] perf,x86: add RAPL hrtimer support
Date: Mon,  7 Oct 2013 18:09:17 +0200
Message-Id: <1381162158-24329-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381162158-24329-1-git-send-email-eranian@google.com>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RAPL PMU counters do not interrupt on overflow.
Therefore, the kernel needs to poll the counters
to avoid missing an overflow. This patch adds
the hrtimer code to do this.

The timer internval is calculated at boot time
based on the power unit used by the HW.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c |   75 +++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index f59dbd4..6294d62 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -54,6 +54,8 @@ struct rapl_pmu {
 	int		hw_unit;  /* 1/2^hw_unit Joule */
 	int		phys_id;
 	int		n_active; /* number of active events */
+	ktime_t		timer_interval; /* in ktime_t unit */
+	struct hrtimer	hrtimer;
 	unsigned long active_mask[BITS_TO_LONGS(RAPL_IDX_MAX)];
 	struct perf_event *events[RAPL_IDX_MAX];
 };
@@ -82,6 +84,18 @@ static inline u64 rapl_scale(u64 v)
 	return v << (32 - __get_cpu_var(rapl_pmu)->hw_unit);
 }
 
+static void rapl_start_hrtimer(struct rapl_pmu *pmu)
+{
+	__hrtimer_start_range_ns(&pmu->hrtimer,
+			pmu->timer_interval, 0,
+			HRTIMER_MODE_REL_PINNED, 0);
+}
+
+static void rapl_stop_hrtimer(struct rapl_pmu *pmu)
+{
+	hrtimer_cancel(&pmu->hrtimer);
+}
+
 static u64 rapl_event_update(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -115,6 +129,38 @@ static u64 rapl_event_update(struct perf_event *event)
 	return new_raw_count;
 }
 
+static enum hrtimer_restart rapl_hrtimer_handle(struct hrtimer *hrtimer)
+{
+	struct rapl_pmu *pmu = container_of(hrtimer, struct rapl_pmu, hrtimer);
+	unsigned long flags;
+	int i;
+
+	if (!pmu->n_active)
+		return HRTIMER_NORESTART;
+
+	local_irq_save(flags);
+
+	for_each_set_bit(i, pmu->active_mask, RAPL_IDX_MAX) {
+		rapl_event_update(pmu->events[i]);
+	}
+
+	local_irq_restore(flags);
+
+	hrtimer_forward_now(&pmu->hrtimer, pmu->timer_interval);
+
+
+	return HRTIMER_RESTART;
+}
+
+static void rapl_hrtimer_init(struct rapl_pmu *pmu)
+{
+	hrtimer_init(&pmu->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	pmu->hrtimer.function = rapl_hrtimer_handle;
+}
+
+
+
+
 static void rapl_pmu_event_start(struct perf_event *event, int flags)
 {
 	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
@@ -127,6 +173,8 @@ static void rapl_pmu_event_start(struct perf_event *event, int flags)
 	local64_set(&event->hw.prev_count, rapl_read_counter(event));
 
 	pmu->n_active++;
+	if (pmu->n_active == 1)
+		rapl_start_hrtimer(pmu);
 }
 
 static int rapl_pmu_event_add(struct perf_event *event, int flags)
@@ -158,6 +206,9 @@ static void rapl_pmu_event_stop(struct perf_event *event, int flags)
 	if (__test_and_clear_bit(hwc->idx, pmu->active_mask)) {
 		WARN_ON_ONCE(pmu->n_active <= 0);
 		pmu->n_active--;
+		if (pmu->n_active == 0)
+			rapl_stop_hrtimer(pmu);
+
 		pmu->events[hwc->idx] = NULL;
 		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
 		hwc->state |= PERF_HES_STOPPED;
@@ -394,6 +445,7 @@ static int rapl_cpu_prepare(int cpu)
 {
 	struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
 	int phys_id = topology_physical_package_id(cpu);
+	u64 ms;
 
 	if (pmu)
 		return 0;
@@ -415,6 +467,20 @@ static int rapl_cpu_prepare(int cpu)
 	rdmsrl(MSR_RAPL_POWER_UNIT, pmu->hw_unit);
 	pmu->hw_unit = (pmu->hw_unit >> 8) & 0x1FULL;
 
+	/*
+	 * use reference of 200W for scaling the timeout
+	 * to avoid missing counter overflows.
+	 * 200W = 200 Joules/sec
+	 * divide interval by 2 to avoid lockstep (2 * 100)
+	 * if hw unit is 32, then we use 2 ms 1/200/2
+	 */
+	if (pmu->hw_unit < 32)
+		ms = 1000 * (1ULL << (32 - pmu->hw_unit - 1)) / (2 * 100);
+	else
+		ms = 2;
+
+	pmu->timer_interval = ms_to_ktime(ms);
+
 	/* set RAPL pmu for this cpu for now */
 	per_cpu(rapl_pmu_kfree, cpu) = NULL;
 	per_cpu(rapl_pmu, cpu) = pmu;
@@ -559,6 +625,7 @@ static int __init rapl_pmu_init(void)
 		}
 		rapl_cpu_prepare(cpu);
 		cpumask_set_cpu(cpu, &rapl_cpu_mask);
+		rapl_hrtimer_init(per_cpu(rapl_pmu, cpu));
 	}
 
 	perf_cpu_notifier(rapl_cpu_notifier);
@@ -567,11 +634,13 @@ static int __init rapl_pmu_init(void)
 	WARN_ON(ret);
 
 	pmu = __get_cpu_var(rapl_pmu);
-	pr_info("RAPL PMU detected, hw unit 2^-%d Joules, "
+	pr_info("RAPL PMU detected, hw unit 2^-%d Joules,"
 		" API unit is 2^-32 Joules,"
-		" %d fixed counters\n",
+		" %d fixed counters,",
+		" %Lu ms ovfl timer\n",
 		pmu->hw_unit,
-		hweight32(rapl_cntr_mask));
+		hweight32(rapl_cntr_mask),
+		ktime_to_ms(pmu->timer_interval));
 
 	put_online_cpus();
 
-- 
1.7.9.5

