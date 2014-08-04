Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaHDMTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:19:41 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:37367 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaHDMTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:19:39 -0400
Date: Mon, 4 Aug 2014 14:19:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm changes for v3.17
Message-ID: <20140804121934.GA26950@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

   # HEAD: a5102476a24bce364b74f1110005542a2c964103 x86/mm: Set TLB flush tunable to sane value (33)

The main change in this cycle is the rework of the TLB range flushing 
code, to simplify, fix and consolidate the code. By Dave Hansen.

  out-of-topic modifications in x86-mm-for-linus:
  -------------------------------------------------
  include/linux/mm_types.h           # d17d8f9: x86/mm: Add tracepoints for TLB f
  include/trace/events/tlb.h         # d17d8f9: x86/mm: Add tracepoints for TLB f

 Thanks,

	Ingo

------------------>
Dave Hansen (7):
      x86/mm: Clean up the TLB flushing code
      x86/mm: Rip out complicated, out-of-date, buggy TLB flushing
      x86/mm: Fix missed global TLB flush stat
      x86/mm: Unify remote INVLPG code
      x86/mm: Add tracepoints for TLB flushes
      x86/mm: New tunable for single vs full TLB flush
      x86/mm: Set TLB flush tunable to sane value (33)

Jiri Kosina (1):
      x86/smep: Be more informative when signalling an SMEP fault


 Documentation/x86/tlb.txt          |  75 +++++++++++++++++++++++++++
 arch/x86/include/asm/mmu_context.h |   6 +++
 arch/x86/include/asm/processor.h   |   1 -
 arch/x86/kernel/cpu/amd.c          |   7 ---
 arch/x86/kernel/cpu/common.c       |  13 +----
 arch/x86/kernel/cpu/intel.c        |  26 ----------
 arch/x86/mm/fault.c                |   6 +++
 arch/x86/mm/init.c                 |   7 +++
 arch/x86/mm/tlb.c                  | 103 ++++++++++++++++++-------------------
 include/linux/mm_types.h           |   8 +++
 include/trace/events/tlb.h         |  40 ++++++++++++++
 11 files changed, 193 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/x86/tlb.txt
 create mode 100644 include/trace/events/tlb.h

diff --git a/Documentation/x86/tlb.txt b/Documentation/x86/tlb.txt
new file mode 100644
index 0000000..2b3a82e
--- /dev/null
+++ b/Documentation/x86/tlb.txt
@@ -0,0 +1,75 @@
+When the kernel unmaps or modified the attributes of a range of
+memory, it has two choices:
+ 1. Flush the entire TLB with a two-instruction sequence.  This is
+    a quick operation, but it causes collateral damage: TLB entries
+    from areas other than the one we are trying to flush will be
+    destroyed and must be refilled later, at some cost.
+ 2. Use the invlpg instruction to invalidate a single page at a
+    time.  This could potentialy cost many more instructions, but
+    it is a much more precise operation, causing no collateral
+    damage to other TLB entries.
+
+Which method to do depends on a few things:
+ 1. The size of the flush being performed.  A flush of the entire
+    address space is obviously better performed by flushing the
+    entire TLB than doing 2^48/PAGE_SIZE individual flushes.
+ 2. The contents of the TLB.  If the TLB is empty, then there will
+    be no collateral damage caused by doing the global flush, and
+    all of the individual flush will have ended up being wasted
+    work.
+ 3. The size of the TLB.  The larger the TLB, the more collateral
+    damage we do with a full flush.  So, the larger the TLB, the
+    more attrative an individual flush looks.  Data and
+    instructions have separate TLBs, as do different page sizes.
+ 4. The microarchitecture.  The TLB has become a multi-level
+    cache on modern CPUs, and the global flushes have become more
+    expensive relative to single-page flushes.
+
+There is obviously no way the kernel can know all these things,
+especially the contents of the TLB during a given flush.  The
+sizes of the flush will vary greatly depending on the workload as
+well.  There is essentially no "right" point to choose.
+
+You may be doing too many individual invalidations if you see the
+invlpg instruction (or instructions _near_ it) show up high in
+profiles.  If you believe that individual invalidations being
+called too often, you can lower the tunable:
+
+	/sys/debug/kernel/x86/tlb_single_page_flush_ceiling
+
+This will cause us to do the global flush for more cases.
+Lowering it to 0 will disable the use of the individual flushes.
+Setting it to 1 is a very conservative setting and it should
+never need to be 0 under normal circumstances.
+
+Despite the fact that a single individual flush on x86 is
+guaranteed to flush a full 2MB [1], hugetlbfs always uses the full
+flushes.  THP is treated exactly the same as normal memory.
+
+You might see invlpg inside of flush_tlb_mm_range() show up in
+profiles, or you can use the trace_tlb_flush() tracepoints. to
+determine how long the flush operations are taking.
+
+Essentially, you are balancing the cycles you spend doing invlpg
+with the cycles that you spend refilling the TLB later.
+
+You can measure how expensive TLB refills are by using
+performance counters and 'perf stat', like this:
+
+perf stat -e
+	cpu/event=0x8,umask=0x84,name=dtlb_load_misses_walk_duration/,
+	cpu/event=0x8,umask=0x82,name=dtlb_load_misses_walk_completed/,
+	cpu/event=0x49,umask=0x4,name=dtlb_store_misses_walk_duration/,
+	cpu/event=0x49,umask=0x2,name=dtlb_store_misses_walk_completed/,
+	cpu/event=0x85,umask=0x4,name=itlb_misses_walk_duration/,
+	cpu/event=0x85,umask=0x2,name=itlb_misses_walk_completed/
+
+That works on an IvyBridge-era CPU (i5-3320M).  Different CPUs
+may have differently-named counters, but they should at least
+be there in some form.  You can use pmu-tools 'ocperf list'
+(https://github.com/andikleen/pmu-tools) to find the right
+counters for a given CPU.
+
+1. A footnote in Intel's SDM "4.10.4.2 Recommended Invalidation"
+   says: "One execution of INVLPG is sufficient even for a page
+   with size greater than 4 KBytes."
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index be12c53..166af2a 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -3,6 +3,10 @@
 
 #include <asm/desc.h>
 #include <linux/atomic.h>
+#include <linux/mm_types.h>
+
+#include <trace/events/tlb.h>
+
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
@@ -44,6 +48,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 
 		/* Re-load page tables */
 		load_cr3(next->pgd);
+		trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
 
 		/* Stop flush ipis for the previous mm */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
@@ -71,6 +76,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			 * to make sure to use no freed page tables.
 			 */
 			load_cr3(next->pgd);
+			trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
 			load_LDT_nolock(&next->context);
 		}
 	}
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a4ea023..43d61da 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -72,7 +72,6 @@ extern u16 __read_mostly tlb_lld_4k[NR_INFO];
 extern u16 __read_mostly tlb_lld_2m[NR_INFO];
 extern u16 __read_mostly tlb_lld_4m[NR_INFO];
 extern u16 __read_mostly tlb_lld_1g[NR_INFO];
-extern s8  __read_mostly tlb_flushall_shift;
 
 /*
  *  CPU type and hardware bug flags. Kept separately for each CPU.
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ce8b8ff..a1a53d0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -741,11 +741,6 @@ static unsigned int amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 }
 #endif
 
-static void cpu_set_tlb_flushall_shift(struct cpuinfo_x86 *c)
-{
-	tlb_flushall_shift = 6;
-}
-
 static void cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
 {
 	u32 ebx, eax, ecx, edx;
@@ -793,8 +788,6 @@ static void cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
 		tlb_lli_2m[ENTRIES] = eax & mask;
 
 	tlb_lli_4m[ENTRIES] = tlb_lli_2m[ENTRIES] >> 1;
-
-	cpu_set_tlb_flushall_shift(c);
 }
 
 static const struct cpu_dev amd_cpu_dev = {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2cbbf88..2c17820 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -480,26 +480,17 @@ u16 __read_mostly tlb_lld_2m[NR_INFO];
 u16 __read_mostly tlb_lld_4m[NR_INFO];
 u16 __read_mostly tlb_lld_1g[NR_INFO];
 
-/*
- * tlb_flushall_shift shows the balance point in replacing cr3 write
- * with multiple 'invlpg'. It will do this replacement when
- *   flush_tlb_lines <= active_lines/2^tlb_flushall_shift.
- * If tlb_flushall_shift is -1, means the replacement will be disabled.
- */
-s8  __read_mostly tlb_flushall_shift = -1;
-
 void cpu_detect_tlb(struct cpuinfo_x86 *c)
 {
 	if (this_cpu->c_detect_tlb)
 		this_cpu->c_detect_tlb(c);
 
 	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n"
-		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d, 1GB %d\n"
-		"tlb_flushall_shift: %d\n",
+		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d, 1GB %d\n",
 		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
 		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
 		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES],
-		tlb_lld_1g[ENTRIES], tlb_flushall_shift);
+		tlb_lld_1g[ENTRIES]);
 }
 
 void detect_ht(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index a800290..cd61755 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -634,31 +634,6 @@ static void intel_tlb_lookup(const unsigned char desc)
 	}
 }
 
-static void intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
-{
-	switch ((c->x86 << 8) + c->x86_model) {
-	case 0x60f: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
-	case 0x616: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
-	case 0x617: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
-	case 0x61d: /* six-core 45 nm xeon "Dunnington" */
-		tlb_flushall_shift = -1;
-		break;
-	case 0x63a: /* Ivybridge */
-		tlb_flushall_shift = 2;
-		break;
-	case 0x61a: /* 45 nm nehalem, "Bloomfield" */
-	case 0x61e: /* 45 nm nehalem, "Lynnfield" */
-	case 0x625: /* 32 nm nehalem, "Clarkdale" */
-	case 0x62c: /* 32 nm nehalem, "Gulftown" */
-	case 0x62e: /* 45 nm nehalem-ex, "Beckton" */
-	case 0x62f: /* 32 nm Xeon E7 */
-	case 0x62a: /* SandyBridge */
-	case 0x62d: /* SandyBridge, "Romely-EP" */
-	default:
-		tlb_flushall_shift = 6;
-	}
-}
-
 static void intel_detect_tlb(struct cpuinfo_x86 *c)
 {
 	int i, j, n;
@@ -683,7 +658,6 @@ static void intel_detect_tlb(struct cpuinfo_x86 *c)
 		for (j = 1 ; j < 16 ; j++)
 			intel_tlb_lookup(desc[j]);
 	}
-	intel_tlb_flushall_shift_set(c);
 }
 
 static const struct cpu_dev intel_cpu_dev = {
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 858b47b..9de4cdb 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -575,6 +575,8 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 
 static const char nx_warning[] = KERN_CRIT
 "kernel tried to execute NX-protected page - exploit attempt? (uid: %d)\n";
+static const char smep_warning[] = KERN_CRIT
+"unable to execute userspace code (SMEP?) (uid: %d)\n";
 
 static void
 show_fault_oops(struct pt_regs *regs, unsigned long error_code,
@@ -595,6 +597,10 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 
 		if (pte && pte_present(*pte) && !pte_exec(*pte))
 			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
+		if (pte && pte_present(*pte) && pte_exec(*pte) &&
+				(pgd_flags(*pgd) & _PAGE_USER) &&
+				(read_cr4() & X86_CR4_SMEP))
+			printk(smep_warning, from_kuid(&init_user_ns, current_uid()));
 	}
 
 	printk(KERN_ALERT "BUG: unable to handle kernel ");
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index f971306..66dba36 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -18,6 +18,13 @@
 #include <asm/dma.h>		/* for MAX_DMA_PFN */
 #include <asm/microcode.h>
 
+/*
+ * We need to define the tracepoints somewhere, and tlb.c
+ * is only compied when SMP=y.
+ */
+#define CREATE_TRACE_POINTS
+#include <trace/events/tlb.h>
+
 #include "mm_internal.h"
 
 static unsigned long __initdata pgt_buf_start;
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index dd8dda1..1fe3398 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -49,6 +49,7 @@ void leave_mm(int cpu)
 	if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
 		cpumask_clear_cpu(cpu, mm_cpumask(active_mm));
 		load_cr3(swapper_pg_dir);
+		trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
 	}
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -102,20 +103,24 @@ static void flush_tlb_func(void *info)
 
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
+	if (!f->flush_end)
+		f->flush_end = f->flush_start + PAGE_SIZE;
 
 	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
-		if (f->flush_end == TLB_FLUSH_ALL)
+		if (f->flush_end == TLB_FLUSH_ALL) {
 			local_flush_tlb();
-		else if (!f->flush_end)
-			__flush_tlb_single(f->flush_start);
-		else {
+			trace_tlb_flush(TLB_REMOTE_SHOOTDOWN, TLB_FLUSH_ALL);
+		} else {
 			unsigned long addr;
+			unsigned long nr_pages =
+				f->flush_end - f->flush_start / PAGE_SIZE;
 			addr = f->flush_start;
 			while (addr < f->flush_end) {
 				__flush_tlb_single(addr);
 				addr += PAGE_SIZE;
 			}
+			trace_tlb_flush(TLB_REMOTE_SHOOTDOWN, nr_pages);
 		}
 	} else
 		leave_mm(smp_processor_id());
@@ -153,46 +158,45 @@ void flush_tlb_current_task(void)
 
 	count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 	local_flush_tlb();
+	trace_tlb_flush(TLB_LOCAL_SHOOTDOWN, TLB_FLUSH_ALL);
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
 		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
 	preempt_enable();
 }
 
+/*
+ * See Documentation/x86/tlb.txt for details.  We choose 33
+ * because it is large enough to cover the vast majority (at
+ * least 95%) of allocations, and is small enough that we are
+ * confident it will not cause too much overhead.  Each single
+ * flush is about 100 ns, so this caps the maximum overhead at
+ * _about_ 3,000 ns.
+ *
+ * This is in units of pages.
+ */
+unsigned long tlb_single_page_flush_ceiling = 33;
+
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned long vmflag)
 {
 	unsigned long addr;
-	unsigned act_entries, tlb_entries = 0;
-	unsigned long nr_base_pages;
+	/* do a global flush by default */
+	unsigned long base_pages_to_flush = TLB_FLUSH_ALL;
 
 	preempt_disable();
 	if (current->active_mm != mm)
-		goto flush_all;
+		goto out;
 
 	if (!current->mm) {
 		leave_mm(smp_processor_id());
-		goto flush_all;
+		goto out;
 	}
 
-	if (end == TLB_FLUSH_ALL || tlb_flushall_shift == -1
-					|| vmflag & VM_HUGETLB) {
-		local_flush_tlb();
-		goto flush_all;
-	}
-
-	/* In modern CPU, last level tlb used for both data/ins */
-	if (vmflag & VM_EXEC)
-		tlb_entries = tlb_lli_4k[ENTRIES];
-	else
-		tlb_entries = tlb_lld_4k[ENTRIES];
+	if ((end != TLB_FLUSH_ALL) && !(vmflag & VM_HUGETLB))
+		base_pages_to_flush = (end - start) >> PAGE_SHIFT;
 
-	/* Assume all of TLB entries was occupied by this task */
-	act_entries = tlb_entries >> tlb_flushall_shift;
-	act_entries = mm->total_vm > act_entries ? act_entries : mm->total_vm;
-	nr_base_pages = (end - start) >> PAGE_SHIFT;
-
-	/* tlb_flushall_shift is on balance point, details in commit log */
-	if (nr_base_pages > act_entries) {
+	if (base_pages_to_flush > tlb_single_page_flush_ceiling) {
+		base_pages_to_flush = TLB_FLUSH_ALL;
 		count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
 	} else {
@@ -201,17 +205,15 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 			count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ONE);
 			__flush_tlb_single(addr);
 		}
-
-		if (cpumask_any_but(mm_cpumask(mm),
-				smp_processor_id()) < nr_cpu_ids)
-			flush_tlb_others(mm_cpumask(mm), mm, start, end);
-		preempt_enable();
-		return;
 	}
-
-flush_all:
+	trace_tlb_flush(TLB_LOCAL_MM_SHOOTDOWN, base_pages_to_flush);
+out:
+	if (base_pages_to_flush == TLB_FLUSH_ALL) {
+		start = 0UL;
+		end = TLB_FLUSH_ALL;
+	}
 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(mm_cpumask(mm), mm, 0UL, TLB_FLUSH_ALL);
+		flush_tlb_others(mm_cpumask(mm), mm, start, end);
 	preempt_enable();
 }
 
@@ -260,32 +262,26 @@ static void do_kernel_range_flush(void *info)
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
-	unsigned act_entries;
-	struct flush_tlb_info info;
-
-	/* In modern CPU, last level tlb used for both data/ins */
-	act_entries = tlb_lld_4k[ENTRIES];
 
 	/* Balance as user space task's flush, a bit conservative */
-	if (end == TLB_FLUSH_ALL || tlb_flushall_shift == -1 ||
-		(end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift)
-
+	if (end == TLB_FLUSH_ALL ||
+	    (end - start) > tlb_single_page_flush_ceiling * PAGE_SIZE) {
 		on_each_cpu(do_flush_tlb_all, NULL, 1);
-	else {
+	} else {
+		struct flush_tlb_info info;
 		info.flush_start = start;
 		info.flush_end = end;
 		on_each_cpu(do_kernel_range_flush, &info, 1);
 	}
 }
 
-#ifdef CONFIG_DEBUG_TLBFLUSH
 static ssize_t tlbflush_read_file(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "%hd\n", tlb_flushall_shift);
+	len = sprintf(buf, "%ld\n", tlb_single_page_flush_ceiling);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -294,20 +290,20 @@ static ssize_t tlbflush_write_file(struct file *file,
 {
 	char buf[32];
 	ssize_t len;
-	s8 shift;
+	int ceiling;
 
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
 
 	buf[len] = '\0';
-	if (kstrtos8(buf, 0, &shift))
+	if (kstrtoint(buf, 0, &ceiling))
 		return -EINVAL;
 
-	if (shift < -1 || shift >= BITS_PER_LONG)
+	if (ceiling < 0)
 		return -EINVAL;
 
-	tlb_flushall_shift = shift;
+	tlb_single_page_flush_ceiling = ceiling;
 	return count;
 }
 
@@ -317,11 +313,10 @@ static const struct file_operations fops_tlbflush = {
 	.llseek = default_llseek,
 };
 
-static int __init create_tlb_flushall_shift(void)
+static int __init create_tlb_single_page_flush_ceiling(void)
 {
-	debugfs_create_file("tlb_flushall_shift", S_IRUSR | S_IWUSR,
+	debugfs_create_file("tlb_single_page_flush_ceiling", S_IRUSR | S_IWUSR,
 			    arch_debugfs_dir, NULL, &fops_tlbflush);
 	return 0;
 }
-late_initcall(create_tlb_flushall_shift);
-#endif
+late_initcall(create_tlb_single_page_flush_ceiling);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 96c5750..796deac 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -516,4 +516,12 @@ struct vm_special_mapping
 	struct page **pages;
 };
 
+enum tlb_flush_reason {
+	TLB_FLUSH_ON_TASK_SWITCH,
+	TLB_REMOTE_SHOOTDOWN,
+	TLB_LOCAL_SHOOTDOWN,
+	TLB_LOCAL_MM_SHOOTDOWN,
+	NR_TLB_FLUSH_REASONS,
+};
+
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/include/trace/events/tlb.h b/include/trace/events/tlb.h
new file mode 100644
index 0000000..13391d2
--- /dev/null
+++ b/include/trace/events/tlb.h
@@ -0,0 +1,40 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM tlb
+
+#if !defined(_TRACE_TLB_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TLB_H
+
+#include <linux/mm_types.h>
+#include <linux/tracepoint.h>
+
+#define TLB_FLUSH_REASON	\
+	{ TLB_FLUSH_ON_TASK_SWITCH,	"flush on task switch" },	\
+	{ TLB_REMOTE_SHOOTDOWN,		"remote shootdown" },		\
+	{ TLB_LOCAL_SHOOTDOWN,		"local shootdown" },		\
+	{ TLB_LOCAL_MM_SHOOTDOWN,	"local mm shootdown" }
+
+TRACE_EVENT(tlb_flush,
+
+	TP_PROTO(int reason, unsigned long pages),
+	TP_ARGS(reason, pages),
+
+	TP_STRUCT__entry(
+		__field(	  int, reason)
+		__field(unsigned long,  pages)
+	),
+
+	TP_fast_assign(
+		__entry->reason = reason;
+		__entry->pages  = pages;
+	),
+
+	TP_printk("pages:%ld reason:%s (%d)",
+		__entry->pages,
+		__print_symbolic(__entry->reason, TLB_FLUSH_REASON),
+		__entry->reason)
+);
+
+#endif /* _TRACE_TLB_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
