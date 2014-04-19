Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaDSKl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 06:41:59 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:39998 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaDSKl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 06:41:56 -0400
Date: Sat, 19 Apr 2014 12:41:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140419104149.GA4224@gmail.com>
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

   # HEAD: 24223657806a0ebd0ae5c9caaf7b021091889cf2 perf/x86/intel: Use rdmsrl_safe() when initializing RAPL PMU

Two kernel side fixes:

 - an Intel uncore PMU driver potential crash fix
 - a kprobes/perf-call-graph interaction fix

 Thanks,

	Ingo

------------------>
Masami Hiramatsu (1):
      kprobes/x86: Fix page-fault handling logic

Venkatesh Srinivas (1):
      perf/x86/intel: Use rdmsrl_safe() when initializing RAPL PMU


 arch/x86/kernel/cpu/perf_event_intel_rapl.c | 12 +++++++++---
 arch/x86/kernel/kprobes/core.c              | 16 +++++++---------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 4b9a9e9..7c87424 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -535,6 +535,7 @@ static int rapl_cpu_prepare(int cpu)
 	struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
 	int phys_id = topology_physical_package_id(cpu);
 	u64 ms;
+	u64 msr_rapl_power_unit_bits;
 
 	if (pmu)
 		return 0;
@@ -542,6 +543,9 @@ static int rapl_cpu_prepare(int cpu)
 	if (phys_id < 0)
 		return -1;
 
+	if (!rdmsrl_safe(MSR_RAPL_POWER_UNIT, &msr_rapl_power_unit_bits))
+		return -1;
+
 	pmu = kzalloc_node(sizeof(*pmu), GFP_KERNEL, cpu_to_node(cpu));
 	if (!pmu)
 		return -1;
@@ -555,8 +559,7 @@ static int rapl_cpu_prepare(int cpu)
 	 *
 	 * we cache in local PMU instance
 	 */
-	rdmsrl(MSR_RAPL_POWER_UNIT, pmu->hw_unit);
-	pmu->hw_unit = (pmu->hw_unit >> 8) & 0x1FULL;
+	pmu->hw_unit = (msr_rapl_power_unit_bits >> 8) & 0x1FULL;
 	pmu->pmu = &rapl_pmu_class;
 
 	/*
@@ -677,7 +680,9 @@ static int __init rapl_pmu_init(void)
 	cpu_notifier_register_begin();
 
 	for_each_online_cpu(cpu) {
-		rapl_cpu_prepare(cpu);
+		ret = rapl_cpu_prepare(cpu);
+		if (ret)
+			goto out;
 		rapl_cpu_init(cpu);
 	}
 
@@ -700,6 +705,7 @@ static int __init rapl_pmu_init(void)
 		hweight32(rapl_cntr_mask),
 		ktime_to_ms(pmu->timer_interval));
 
+out:
 	cpu_notifier_register_done();
 
 	return 0;
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 79a3f96..61b17dc 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -897,9 +897,10 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
-	switch (kcb->kprobe_status) {
-	case KPROBE_HIT_SS:
-	case KPROBE_REENTER:
+	if (unlikely(regs->ip == (unsigned long)cur->ainsn.insn)) {
+		/* This must happen on single-stepping */
+		WARN_ON(kcb->kprobe_status != KPROBE_HIT_SS &&
+			kcb->kprobe_status != KPROBE_REENTER);
 		/*
 		 * We are here because the instruction being single
 		 * stepped caused a page fault. We reset the current
@@ -914,9 +915,8 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		else
 			reset_current_kprobe();
 		preempt_enable_no_resched();
-		break;
-	case KPROBE_HIT_ACTIVE:
-	case KPROBE_HIT_SSDONE:
+	} else if (kcb->kprobe_status == KPROBE_HIT_ACTIVE ||
+		   kcb->kprobe_status == KPROBE_HIT_SSDONE) {
 		/*
 		 * We increment the nmissed count for accounting,
 		 * we can also use npre/npostfault count for accounting
@@ -945,10 +945,8 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		 * fixup routine could not handle it,
 		 * Let do_page_fault() fix it.
 		 */
-		break;
-	default:
-		break;
 	}
+
 	return 0;
 }
 
