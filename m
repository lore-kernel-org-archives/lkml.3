Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbaJNW6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:58:08 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51360 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632AbaJNW6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:58:02 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
Date: Tue, 14 Oct 2014 15:57:39 -0700
Message-Id: <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1413323611.git.luto@amacapital.net>
References: <cover.1413323611.git.luto@amacapital.net>
In-Reply-To: <cover.1413323611.git.luto@amacapital.net>
References: <cover.1413323611.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently allow any process to use rdpmc.  This significantly
weakens the protection offered by PR_TSC_DISABLED, and it could be
helpful to users attempting to exploit timing attacks.

Since we can't enable access to individual counters, use a very
coarse heuristic to limit access to rdpmc: allow access only when
a perf_event is mmapped.  This protects seccomp sandboxes.

There is plenty of room to further tighen these restrictions.  For
example, on x86, *all* perf_event mappings set cap_user_rdpmc.  This
should probably be changed to only apply to perf_events that are
accessible using rdpmc.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/mmu.h         |  2 ++
 arch/x86/include/asm/mmu_context.h | 19 ++++++++++++
 arch/x86/kernel/cpu/perf_event.c   | 60 +++++++++++++++++++++++++++++---------
 3 files changed, 67 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index 876e74e8eec7..2e5e4925a63f 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -19,6 +19,8 @@ typedef struct {
 
 	struct mutex lock;
 	void __user *vdso;
+
+	atomic_t perf_mmap_count;	/* number of mmapped perf_events */
 } mm_context_t;
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 04478103df37..10239af45a9d 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -19,6 +19,21 @@ static inline void paravirt_activate_mm(struct mm_struct *prev,
 }
 #endif	/* !CONFIG_PARAVIRT */
 
+#ifdef CONFIG_PERF_EVENTS
+extern struct static_key rdpmc_enabled;
+
+static inline void load_mm_cr4(struct mm_struct *mm)
+{
+	if (static_key_true(&rdpmc_enabled) &&
+	    atomic_read(&mm->context.perf_mmap_count))
+		cr4_set(X86_CR4_PCE);
+	else
+		cr4_clear(X86_CR4_PCE);
+}
+#else
+static inline void load_mm_cr4(struct mm_struct *mm) {}
+#endif
+
 /*
  * Used for LDT copy/destruction.
  */
@@ -53,6 +68,9 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		/* Stop flush ipis for the previous mm */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 
+		/* Load per-mm CR4 state */
+		load_mm_cr4(next);
+
 		/*
 		 * Load the LDT, if the LDT is different.
 		 *
@@ -86,6 +104,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			 */
 			load_cr3(next->pgd);
 			trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
+			load_mm_cr4(next);
 			load_LDT_nolock(&next->context);
 		}
 	}
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2401593df4a3..7d42cf60f3b3 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -31,6 +31,7 @@
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/alternative.h>
+#include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
 #include <asm/timer.h>
 #include <asm/desc.h>
@@ -44,6 +45,8 @@ DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.enabled = 1,
 };
 
+struct static_key rdpmc_enabled = STATIC_KEY_INIT_TRUE;
+
 u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -133,6 +136,7 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 
 static atomic_t active_events;
 static DEFINE_MUTEX(pmc_reserve_mutex);
+static DEFINE_MUTEX(rdpmc_enable_mutex);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
@@ -1326,8 +1330,6 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 		break;
 
 	case CPU_STARTING:
-		if (x86_pmu.attr_rdpmc)
-			cr4_set(X86_CR4_PCE);
 		if (x86_pmu.cpu_starting)
 			x86_pmu.cpu_starting(cpu);
 		break;
@@ -1806,6 +1808,27 @@ static int x86_pmu_event_init(struct perf_event *event)
 	return err;
 }
 
+static void refresh_pce(void *ignored)
+{
+	if (current->mm)
+		load_mm_cr4(current->mm);
+}
+
+static void x86_pmu_event_mapped(struct perf_event *event)
+{
+	if (atomic_inc_return(&current->mm->context.perf_mmap_count) == 1)
+		on_each_cpu_mask(mm_cpumask(current->mm), refresh_pce, NULL, 1);
+}
+
+static void x86_pmu_event_unmapped(struct perf_event *event)
+{
+	if (!current->mm)
+		return;
+
+	if (atomic_dec_and_test(&current->mm->context.perf_mmap_count))
+		on_each_cpu_mask(mm_cpumask(current->mm), refresh_pce, NULL, 1);
+}
+
 static int x86_pmu_event_idx(struct perf_event *event)
 {
 	int idx = event->hw.idx;
@@ -1828,16 +1851,6 @@ static ssize_t get_attr_rdpmc(struct device *cdev,
 	return snprintf(buf, 40, "%d\n", x86_pmu.attr_rdpmc);
 }
 
-static void change_rdpmc(void *info)
-{
-	bool enable = !!(unsigned long)info;
-
-	if (enable)
-		cr4_set(X86_CR4_PCE);
-	else
-		cr4_clear(X86_CR4_PCE);
-}
-
 static ssize_t set_attr_rdpmc(struct device *cdev,
 			      struct device_attribute *attr,
 			      const char *buf, size_t count)
@@ -1852,10 +1865,26 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 	if (x86_pmu.attr_rdpmc_broken)
 		return -ENOTSUPP;
 
+	mutex_lock(&rdpmc_enable_mutex);
 	if (!!val != !!x86_pmu.attr_rdpmc) {
-		x86_pmu.attr_rdpmc = !!val;
-		on_each_cpu(change_rdpmc, (void *)val, 1);
+		if (val) {
+			static_key_slow_inc(&rdpmc_enabled);
+			on_each_cpu(refresh_pce, NULL, 1);
+			smp_wmb();
+			x86_pmu.attr_rdpmc = 1;
+		} else {
+			/*
+			 * This direction can race against existing
+			 * rdpmc-capable mappings.  Try our best regardless.
+			 */
+			x86_pmu.attr_rdpmc = 0;
+			smp_wmb();
+			static_key_slow_dec(&rdpmc_enabled);
+			WARN_ON(static_key_true(&rdpmc_enabled));
+			on_each_cpu(refresh_pce, NULL, 1);
+		}
 	}
+	mutex_unlock(&rdpmc_enable_mutex);
 
 	return count;
 }
@@ -1899,6 +1928,9 @@ static struct pmu pmu = {
 
 	.event_init		= x86_pmu_event_init,
 
+	.event_mapped		= x86_pmu_event_mapped,
+	.event_unmapped		= x86_pmu_event_unmapped,
+
 	.add			= x86_pmu_add,
 	.del			= x86_pmu_del,
 	.start			= x86_pmu_start,
-- 
1.9.3

