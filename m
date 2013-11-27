Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3K0OeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:34:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3K0OeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:34:02 -0500
Date: Wed, 27 Nov 2013 06:33:23 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-65661f96d3b32f4b28fef26d21be81d7e173b965@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, maria.n.dimakopoulou@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        maria.n.dimakopoulou@gmail.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1384275531-10892-5-git-send-email-eranian@google.com>
References: <1384275531-10892-5-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Add RAPL hrtimer support
Git-Commit-ID: 65661f96d3b32f4b28fef26d21be81d7e173b965
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:33:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65661f96d3b32f4b28fef26d21be81d7e173b965
Gitweb:     http://git.kernel.org/tip/65661f96d3b32f4b28fef26d21be81d7e173b965
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 12 Nov 2013 17:58:51 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 15:31:23 +0100

perf/x86: Add RAPL hrtimer support

The RAPL PMU counters do not interrupt on overflow.
Therefore, the kernel needs to poll the counters
to avoid missing an overflow. This patch adds
the hrtimer code to do this.

The timer interval is calculated at boot time
based on the power unit used by the HW.

There is one hrtimer per-cpu to handle the case
of multiple simultaneous use across cores on
the same package + hotplug CPU.

Thanks to Maria Dimakopoulou for her contributions
to this patch especially on the math aspects.

Signed-off-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
[ Applied 32-bit build fix. ]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: zheng.z.yan@intel.com
Cc: bp@alien8.de
Cc: maria.n.dimakopoulou@gmail.com
Link: http://lkml.kernel.org/r/1384275531-10892-5-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c | 74 ++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index cfcd386..bf8e4a7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -96,6 +96,8 @@ struct rapl_pmu {
 	int		 n_active; /* number of active events */
 	struct list_head active_list;
 	struct pmu	 *pmu; /* pointer to rapl_pmu_class */
+	ktime_t		 timer_interval; /* in ktime_t unit */
+	struct hrtimer   hrtimer;
 };
 
 static struct pmu rapl_pmu_class;
@@ -158,6 +160,48 @@ again:
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
+	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
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
+	hrtimer_forward_now(hrtimer, pmu->timer_interval);
+
+	return HRTIMER_RESTART;
+}
+
+static void rapl_hrtimer_init(struct rapl_pmu *pmu)
+{
+	struct hrtimer *hr = &pmu->hrtimer;
+
+	hrtimer_init(hr, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hr->function = rapl_hrtimer_handle;
+}
+
 static void __rapl_pmu_event_start(struct rapl_pmu *pmu,
 				   struct perf_event *event)
 {
@@ -171,6 +215,8 @@ static void __rapl_pmu_event_start(struct rapl_pmu *pmu,
 	local64_set(&event->hw.prev_count, rapl_read_counter(event));
 
 	pmu->n_active++;
+	if (pmu->n_active == 1)
+		rapl_start_hrtimer(pmu);
 }
 
 static void rapl_pmu_event_start(struct perf_event *event, int mode)
@@ -195,6 +241,8 @@ static void rapl_pmu_event_stop(struct perf_event *event, int mode)
 	if (!(hwc->state & PERF_HES_STOPPED)) {
 		WARN_ON_ONCE(pmu->n_active <= 0);
 		pmu->n_active--;
+		if (pmu->n_active == 0)
+			rapl_stop_hrtimer(pmu);
 
 		list_del(&event->active_entry);
 
@@ -423,6 +471,9 @@ static void rapl_cpu_exit(int cpu)
 	 */
 	if (target >= 0)
 		perf_pmu_migrate_context(pmu->pmu, cpu, target);
+
+	/* cancel overflow polling timer for CPU */
+	rapl_stop_hrtimer(pmu);
 }
 
 static void rapl_cpu_init(int cpu)
@@ -442,6 +493,7 @@ static int rapl_cpu_prepare(int cpu)
 {
 	struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
 	int phys_id = topology_physical_package_id(cpu);
+	u64 ms;
 
 	if (pmu)
 		return 0;
@@ -466,6 +518,22 @@ static int rapl_cpu_prepare(int cpu)
 	pmu->hw_unit = (pmu->hw_unit >> 8) & 0x1FULL;
 	pmu->pmu = &rapl_pmu_class;
 
+	/*
+	 * use reference of 200W for scaling the timeout
+	 * to avoid missing counter overflows.
+	 * 200W = 200 Joules/sec
+	 * divide interval by 2 to avoid lockstep (2 * 100)
+	 * if hw unit is 32, then we use 2 ms 1/200/2
+	 */
+	if (pmu->hw_unit < 32)
+		ms = (1000 / (2 * 100)) * (1ULL << (32 - pmu->hw_unit - 1));
+	else
+		ms = 2;
+
+	pmu->timer_interval = ms_to_ktime(ms);
+
+	rapl_hrtimer_init(pmu);
+
 	/* set RAPL pmu for this cpu for now */
 	per_cpu(rapl_pmu, cpu) = pmu;
 	per_cpu(rapl_pmu_to_free, cpu) = NULL;
@@ -580,9 +648,11 @@ static int __init rapl_pmu_init(void)
 
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
 
