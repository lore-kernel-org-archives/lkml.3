Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab3JaPAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:00:11 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36150 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3JaPAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:00:08 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: [PATCH v4 4/4] perf,x86: add RAPL hrtimer support
Date: Thu, 31 Oct 2013 15:59:42 +0100
Message-Id: <1383231582-15856-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383231582-15856-1-git-send-email-eranian@google.com>
References: <1383231582-15856-1-git-send-email-eranian@google.com>
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
 1 file changed, 70 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index e2b719b..23f2aff 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -92,11 +92,13 @@ static struct kobj_attribute format_attr_##_var =		\
 
 struct rapl_pmu {
 	spinlock_t	lock;
-	atomic_t	refcnt;
 	int		hw_unit;  /* 1/2^hw_unit Joule */
-	int		phys_id;
-	int		n_active; /* number of active events */
+	struct hrtimer	hrtimer;
 	struct list_head active_list;
+	ktime_t		timer_interval; /* in ktime_t unit */
+	int		n_active; /* number of active events */
+	int		phys_id;
+	atomic_t	refcnt;
 };
 
 static struct pmu rapl_pmu_class;
@@ -161,6 +163,47 @@ static u64 rapl_event_update(struct perf_event *event)
 	return new_raw_count;
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
+static enum hrtimer_restart rapl_hrtimer_handle(struct hrtimer *hrtimer)
+{
+	struct rapl_pmu *pmu = container_of(hrtimer, struct rapl_pmu, hrtimer);
+	struct perf_event *event;
+	unsigned long flags;
+
+	if (!pmu->n_active)
+		return HRTIMER_NORESTART;
+
+	spin_lock_irqsave(&pmu->lock, flags);
+
+	list_for_each_entry(event, &pmu->active_list, active_entry) {
+		rapl_event_update(event);
+	}
+
+	spin_unlock_irqrestore(&pmu->lock, flags);
+
+	hrtimer_forward_now(&pmu->hrtimer, pmu->timer_interval);
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
 static void __rapl_pmu_event_start(struct rapl_pmu *pmu,
 				   struct perf_event *event)
 {
@@ -174,6 +217,8 @@ static void __rapl_pmu_event_start(struct rapl_pmu *pmu,
 	local64_set(&event->hw.prev_count, rapl_read_counter(event));
 
 	pmu->n_active++;
+	if (pmu->n_active == 1)
+		rapl_start_hrtimer(pmu);
 }
 
 static void rapl_pmu_event_start(struct perf_event *event, int mode)
@@ -198,6 +243,8 @@ static void rapl_pmu_event_stop(struct perf_event *event, int mode)
 	if (!(hwc->state & PERF_HES_STOPPED)) {
 		WARN_ON_ONCE(pmu->n_active <= 0);
 		pmu->n_active--;
+		if (pmu->n_active == 0)
+			rapl_stop_hrtimer(pmu);
 
 		list_del(&event->active_entry);
 
@@ -439,6 +486,7 @@ static int rapl_cpu_prepare(int cpu)
 {
 	struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
 	int phys_id = topology_physical_package_id(cpu);
+	u64 ms;
 
 	if (pmu)
 		return 0;
@@ -464,6 +512,20 @@ static int rapl_cpu_prepare(int cpu)
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
@@ -625,6 +687,7 @@ static int __init rapl_pmu_init(void)
 		}
 		rapl_cpu_prepare(cpu);
 		cpumask_set_cpu(cpu, &rapl_cpu_mask);
+		rapl_hrtimer_init(per_cpu(rapl_pmu, cpu));
 	}
 
 	perf_cpu_notifier(rapl_cpu_notifier);
@@ -640,9 +703,11 @@ static int __init rapl_pmu_init(void)
 
 	pr_info("RAPL PMU detected, hw unit 2^-%d Joules,"
 		" API unit is 2^-32 Joules,"
-		" %d fixed counters\n",
+		" %d fixed counters"
+		" %llu ms ovfl timer\n",
 		pmu->hw_unit,
-		hweight32(rapl_cntr_mask));
+		hweight32(rapl_cntr_mask),
+		ktime_to_ms(pmu->timer_interval));
 
 	put_online_cpus();
 
-- 
1.7.9.5

