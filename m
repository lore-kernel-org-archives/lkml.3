Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaG0Jq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 05:46:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:35932 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaG0Jqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 05:46:51 -0400
Date: Sun, 27 Jul 2014 11:46:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] perf fixes for 3.16
Message-ID: <alpine.DEB.2.10.1407271137050.23352@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

A bunch of fixes for perf and kprobes:
  * Revert a commit, which caused a perf group regression
  * Silence dmesg spam
  * Fix kprobe probing errors on ia64 and ppc64
  * Filter kprobe faults from userspace
  * Lockdep fix for perf exit path
  * Prevent perf #GP in KVM guest
  * Correct perf event and filters

Thanks,

	tglx

------------------>
Andy Lutomirski (1):
      kprobes/x86: Don't try to resolve kprobe faults from userspace

David Rientjes (1):
      perf/x86/intel: Avoid spamming kernel log for BTS buffer failure

Kan Liang (1):
      perf/x86/intel: Protect LBR and extra_regs against KVM lying

Masami Hiramatsu (1):
      kprobes: Fix "Failed to find blacklist" probing errors on ia64 and ppc64

Peter Zijlstra (2):
      perf: Revert ("perf: Always destroy groups on exit")
      perf: Fix lockdep warning on process exit

Stephane Eranian (1):
      perf/x86/intel/uncore: Fix SNB-EP/IVT Cbox filter mappings

Vince Weaver (1):
      perf/x86/intel: Use proper dTLB-load-misses event on IvyBridge


 arch/x86/kernel/cpu/perf_event.c              |  3 ++
 arch/x86/kernel/cpu/perf_event.h              | 12 +++--
 arch/x86/kernel/cpu/perf_event_intel.c        | 69 ++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c     |  6 ++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 11 +++--
 arch/x86/kernel/kprobes/core.c                |  3 ++
 kernel/events/core.c                          | 32 ++++++++++++-
 kernel/kprobes.c                              | 14 ++++--
 8 files changed, 130 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2bdfbff..2879ecd 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -118,6 +118,9 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 			continue;
 		if (event->attr.config1 & ~er->valid_mask)
 			return -EINVAL;
+		/* Check if the extra msrs can be safely accessed*/
+		if (!er->extra_msr_access)
+			return -ENXIO;
 
 		reg->idx = er->idx;
 		reg->config = event->attr.config1;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..8ade931 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -295,14 +295,16 @@ struct extra_reg {
 	u64			config_mask;
 	u64			valid_mask;
 	int			idx;  /* per_xxx->regs[] reg index */
+	bool			extra_msr_access;
 };
 
 #define EVENT_EXTRA_REG(e, ms, m, vm, i) {	\
-	.event = (e),		\
-	.msr = (ms),		\
-	.config_mask = (m),	\
-	.valid_mask = (vm),	\
-	.idx = EXTRA_REG_##i,	\
+	.event = (e),			\
+	.msr = (ms),			\
+	.config_mask = (m),		\
+	.valid_mask = (vm),		\
+	.idx = EXTRA_REG_##i,		\
+	.extra_msr_access = true,	\
 	}
 
 #define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 07846d7..2502d0d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2182,6 +2182,41 @@ static void intel_snb_check_microcode(void)
 	}
 }
 
+/*
+ * Under certain circumstances, access certain MSR may cause #GP.
+ * The function tests if the input MSR can be safely accessed.
+ */
+static bool check_msr(unsigned long msr, u64 mask)
+{
+	u64 val_old, val_new, val_tmp;
+
+	/*
+	 * Read the current value, change it and read it back to see if it
+	 * matches, this is needed to detect certain hardware emulators
+	 * (qemu/kvm) that don't trap on the MSR access and always return 0s.
+	 */
+	if (rdmsrl_safe(msr, &val_old))
+		return false;
+
+	/*
+	 * Only change the bits which can be updated by wrmsrl.
+	 */
+	val_tmp = val_old ^ mask;
+	if (wrmsrl_safe(msr, val_tmp) ||
+	    rdmsrl_safe(msr, &val_new))
+		return false;
+
+	if (val_new != val_tmp)
+		return false;
+
+	/* Here it's sure that the MSR can be safely accessed.
+	 * Restore the old value and return.
+	 */
+	wrmsrl(msr, val_old);
+
+	return true;
+}
+
 static __init void intel_sandybridge_quirk(void)
 {
 	x86_pmu.check_microcode = intel_snb_check_microcode;
@@ -2271,7 +2306,8 @@ __init int intel_pmu_init(void)
 	union cpuid10_ebx ebx;
 	struct event_constraint *c;
 	unsigned int unused;
-	int version;
+	struct extra_reg *er;
+	int version, i;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		switch (boot_cpu_data.x86) {
@@ -2474,6 +2510,9 @@ __init int intel_pmu_init(void)
 	case 62: /* IvyBridge EP */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		/* dTLB-load-misses on IVB is different than SNB */
+		hw_cache_event_ids[C(DTLB)][C(OP_READ)][C(RESULT_MISS)] = 0x8108; /* DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK */
+
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
 		       sizeof(hw_cache_extra_regs));
 
@@ -2574,6 +2613,34 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/*
+	 * Access LBR MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support LBR MSR
+	 * Check all LBT MSR here.
+	 * Disable LBR access if any LBR MSRs can not be accessed.
+	 */
+	if (x86_pmu.lbr_nr && !check_msr(x86_pmu.lbr_tos, 0x3UL))
+		x86_pmu.lbr_nr = 0;
+	for (i = 0; i < x86_pmu.lbr_nr; i++) {
+		if (!(check_msr(x86_pmu.lbr_from + i, 0xffffUL) &&
+		      check_msr(x86_pmu.lbr_to + i, 0xffffUL)))
+			x86_pmu.lbr_nr = 0;
+	}
+
+	/*
+	 * Access extra MSR may cause #GP under certain circumstances.
+	 * E.g. KVM doesn't support offcore event
+	 * Check all extra_regs here.
+	 */
+	if (x86_pmu.extra_regs) {
+		for (er = x86_pmu.extra_regs; er->msr; er++) {
+			er->extra_msr_access = check_msr(er->msr, 0x1ffUL);
+			/* Disable LBR select mapping */
+			if ((er->idx == EXTRA_REG_LBR) && !er->extra_msr_access)
+				x86_pmu.lbr_sel_map = NULL;
+		}
+	}
+
 	/* Support full width counters using alternative MSR range */
 	if (x86_pmu.intel_cap.full_width_write) {
 		x86_pmu.max_period = x86_pmu.cntval_mask;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 980970c..696ade3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -311,9 +311,11 @@ static int alloc_bts_buffer(int cpu)
 	if (!x86_pmu.bts)
 		return 0;
 
-	buffer = kzalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL, node);
-	if (unlikely(!buffer))
+	buffer = kzalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL | __GFP_NOWARN, node);
+	if (unlikely(!buffer)) {
+		WARN_ONCE(1, "%s: BTS buffer allocation failure\n", __func__);
 		return -ENOMEM;
+	}
 
 	max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
 	thresh = max / 16;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 65bbbea..ae6552a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -550,16 +550,16 @@ static struct extra_reg snbep_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x8),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x8),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x4135, 0xffff, 0xc),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x4335, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4135, 0xffff, 0xa),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4335, 0xffff, 0xa),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4435, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4835, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4a35, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x5035, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0136, 0xffff, 0x8),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0336, 0xffff, 0x8),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0xc),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0xa),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0xa),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4436, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4836, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4a36, 0xffff, 0x2),
@@ -1222,6 +1222,7 @@ static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
 				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x1031, 0x10ff, 0x2),
+
 	SNBEP_CBO_EVENT_EXTRA_REG(0x1134, 0xffff, 0x4),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x5134, 0xffff, 0xc),
@@ -1245,7 +1246,7 @@ static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(0x8335, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0136, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0336, 0xffff, 0x10),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x2336, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x2136, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x2336, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0x18),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0x18),
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 7596df6..67e6d19 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -574,6 +574,9 @@ int kprobe_int3_handler(struct pt_regs *regs)
 	struct kprobe *p;
 	struct kprobe_ctlblk *kcb;
 
+	if (user_mode_vm(regs))
+		return 0;
+
 	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
 	/*
 	 * We don't want to be preempted for the entire
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0c95f0..6b17ac1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7458,7 +7458,19 @@ __perf_event_exit_task(struct perf_event *child_event,
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	perf_remove_from_context(child_event, true);
+	/*
+	 * Do not destroy the 'original' grouping; because of the context
+	 * switch optimization the original events could've ended up in a
+	 * random child task.
+	 *
+	 * If we were to destroy the original group, all group related
+	 * operations would cease to function properly after this random
+	 * child dies.
+	 *
+	 * Do destroy all inherited groups, we don't care about those
+	 * and being thorough is better.
+	 */
+	perf_remove_from_context(child_event, !!child_event->parent);
 
 	/*
 	 * It can happen that the parent exits first, and has events
@@ -7474,7 +7486,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event *child_event, *next;
-	struct perf_event_context *child_ctx;
+	struct perf_event_context *child_ctx, *parent_ctx;
 	unsigned long flags;
 
 	if (likely(!child->perf_event_ctxp[ctxn])) {
@@ -7499,6 +7511,15 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	raw_spin_lock(&child_ctx->lock);
 	task_ctx_sched_out(child_ctx);
 	child->perf_event_ctxp[ctxn] = NULL;
+
+	/*
+	 * In order to avoid freeing: child_ctx->parent_ctx->task
+	 * under perf_event_context::lock, grab another reference.
+	 */
+	parent_ctx = child_ctx->parent_ctx;
+	if (parent_ctx)
+		get_ctx(parent_ctx);
+
 	/*
 	 * If this context is a clone; unclone it so it can't get
 	 * swapped to another process while we're removing all
@@ -7509,6 +7530,13 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	raw_spin_unlock_irqrestore(&child_ctx->lock, flags);
 
 	/*
+	 * Now that we no longer hold perf_event_context::lock, drop
+	 * our extra child_ctx->parent_ctx reference.
+	 */
+	if (parent_ctx)
+		put_ctx(parent_ctx);
+
+	/*
 	 * Report the task dead after unscheduling the events so that we
 	 * won't get any samples after PERF_RECORD_EXIT. We can however still
 	 * get a few PERF_RECORD_READ events.
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3214289..734e9a7 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2037,19 +2037,23 @@ static int __init populate_kprobe_blacklist(unsigned long *start,
 {
 	unsigned long *iter;
 	struct kprobe_blacklist_entry *ent;
-	unsigned long offset = 0, size = 0;
+	unsigned long entry, offset = 0, size = 0;
 
 	for (iter = start; iter < end; iter++) {
-		if (!kallsyms_lookup_size_offset(*iter, &size, &offset)) {
-			pr_err("Failed to find blacklist %p\n", (void *)*iter);
+		entry = arch_deref_entry_point((void *)*iter);
+
+		if (!kernel_text_address(entry) ||
+		    !kallsyms_lookup_size_offset(entry, &size, &offset)) {
+			pr_err("Failed to find blacklist at %p\n",
+				(void *)entry);
 			continue;
 		}
 
 		ent = kmalloc(sizeof(*ent), GFP_KERNEL);
 		if (!ent)
 			return -ENOMEM;
-		ent->start_addr = *iter;
-		ent->end_addr = *iter + size;
+		ent->start_addr = entry;
+		ent->end_addr = entry + size;
 		INIT_LIST_HEAD(&ent->list);
 		list_add_tail(&ent->list, &kprobe_blacklist);
 	}
