Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbaLIMbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:31:45 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53500 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbaLIMbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:31:43 -0500
Date: Tue, 9 Dec 2014 13:31:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm tree changes for v3.19
Message-ID: <20141209123138.GA29062@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   # HEAD: 3736708f034ae1e8c62789ed737e8b90d5b40210 x86: Replace seq_printf() with seq_puts()

Misc changes:

 - context switch micro-optimization
 - debug printout micro-optimization
 - comment enhancements and typo fix

 Thanks,

	Ingo

------------------>
Andy Lutomirski (2):
      sched/x86_64: Don't save flags on context switch
      sched/x86: Add a comment clarifying LDT context switching

Nicholas Mc Guire (1):
      x86/asm: Fix typo in arch/x86/kernel/asm_offset_64.c

Rasmus Villemoes (1):
      x86: Replace seq_printf() with seq_puts()


 arch/x86/include/asm/mmu_context.h | 11 ++++++++++-
 arch/x86/include/asm/switch_to.h   | 12 ++++++++----
 arch/x86/kernel/asm-offsets_64.c   |  1 -
 arch/x86/kernel/cpu/proc.c         | 10 +++++-----
 arch/x86/kernel/irq.c              | 30 +++++++++++++++---------------
 arch/x86/mm/pat.c                  |  2 +-
 arch/x86/platform/uv/tlb_uv.c      | 26 ++++++++++++--------------
 7 files changed, 51 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 166af2a8e865..04478103df37 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -53,7 +53,16 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		/* Stop flush ipis for the previous mm */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 
-		/* Load the LDT, if the LDT is different: */
+		/*
+		 * Load the LDT, if the LDT is different.
+		 *
+		 * It's possible leave_mm(prev) has been called.  If so,
+		 * then prev->context.ldt could be out of sync with the
+		 * LDT descriptor or the LDT register.  This can only happen
+		 * if prev->context.ldt is non-null, since we never free
+		 * an LDT.  But LDTs can't be shared across mms, so
+		 * prev->context.ldt won't be equal to next->context.ldt.
+		 */
 		if (unlikely(prev->context.ldt != next->context.ldt))
 			load_LDT_nolock(&next->context);
 	}
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index d7f3b3b78ac3..751bf4b7bf11 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -79,12 +79,12 @@ do {									\
 #else /* CONFIG_X86_32 */
 
 /* frame pointer must be last for get_wchan */
-#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
-#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
+#define SAVE_CONTEXT    "pushq %%rbp ; movq %%rsi,%%rbp\n\t"
+#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp\t"
 
 #define __EXTRA_CLOBBER  \
 	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
-	  "r12", "r13", "r14", "r15"
+	  "r12", "r13", "r14", "r15", "flags"
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 #define __switch_canary							  \
@@ -100,7 +100,11 @@ do {									\
 #define __switch_canary_iparam
 #endif	/* CC_STACKPROTECTOR */
 
-/* Save restore flags to clear handle leaking NT */
+/*
+ * There is no need to save or restore flags, because flags are always
+ * clean in kernel mode, with the possible exception of IOPL.  Kernel IOPL
+ * has no effect.
+ */
 #define switch_to(prev, next, last) \
 	asm volatile(SAVE_CONTEXT					  \
 	     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index e7c798b354fa..4f9359f36bb7 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -48,7 +48,6 @@ int main(void)
 
 #define ENTRY(entry) OFFSET(pt_regs_ ## entry, pt_regs, entry)
 	ENTRY(bx);
-	ENTRY(bx);
 	ENTRY(cx);
 	ENTRY(dx);
 	ENTRY(sp);
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 5433658e598d..e7d8c7608471 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -72,7 +72,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	if (c->x86_mask || c->cpuid_level >= 0)
 		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
 	else
-		seq_printf(m, "stepping\t: unknown\n");
+		seq_puts(m, "stepping\t: unknown\n");
 	if (c->microcode)
 		seq_printf(m, "microcode\t: 0x%x\n", c->microcode);
 
@@ -92,12 +92,12 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	show_cpuinfo_core(m, c, cpu);
 	show_cpuinfo_misc(m, c);
 
-	seq_printf(m, "flags\t\t:");
+	seq_puts(m, "flags\t\t:");
 	for (i = 0; i < 32*NCAPINTS; i++)
 		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
 
-	seq_printf(m, "\nbugs\t\t:");
+	seq_puts(m, "\nbugs\t\t:");
 	for (i = 0; i < 32*NBUGINTS; i++) {
 		unsigned int bug_bit = 32*NCAPINTS + i;
 
@@ -118,7 +118,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
 		   c->x86_phys_bits, c->x86_virt_bits);
 
-	seq_printf(m, "power management:");
+	seq_puts(m, "power management:");
 	for (i = 0; i < 32; i++) {
 		if (c->x86_power & (1 << i)) {
 			if (i < ARRAY_SIZE(x86_power_flags) &&
@@ -131,7 +131,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		}
 	}
 
-	seq_printf(m, "\n\n");
+	seq_puts(m, "\n\n");
 
 	return 0;
 }
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 922d28581024..6307a0f0cf17 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -59,78 +59,78 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	seq_printf(p, "%*s: ", prec, "NMI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->__nmi_count);
-	seq_printf(p, "  Non-maskable interrupts\n");
+	seq_puts(p, "  Non-maskable interrupts\n");
 #ifdef CONFIG_X86_LOCAL_APIC
 	seq_printf(p, "%*s: ", prec, "LOC");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
-	seq_printf(p, "  Local timer interrupts\n");
+	seq_puts(p, "  Local timer interrupts\n");
 
 	seq_printf(p, "%*s: ", prec, "SPU");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
-	seq_printf(p, "  Spurious interrupts\n");
+	seq_puts(p, "  Spurious interrupts\n");
 	seq_printf(p, "%*s: ", prec, "PMI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
-	seq_printf(p, "  Performance monitoring interrupts\n");
+	seq_puts(p, "  Performance monitoring interrupts\n");
 	seq_printf(p, "%*s: ", prec, "IWI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_irq_work_irqs);
-	seq_printf(p, "  IRQ work interrupts\n");
+	seq_puts(p, "  IRQ work interrupts\n");
 	seq_printf(p, "%*s: ", prec, "RTR");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->icr_read_retry_count);
-	seq_printf(p, "  APIC ICR read retries\n");
+	seq_puts(p, "  APIC ICR read retries\n");
 #endif
 	if (x86_platform_ipi_callback) {
 		seq_printf(p, "%*s: ", prec, "PLT");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", irq_stats(j)->x86_platform_ipis);
-		seq_printf(p, "  Platform interrupts\n");
+		seq_puts(p, "  Platform interrupts\n");
 	}
 #ifdef CONFIG_SMP
 	seq_printf(p, "%*s: ", prec, "RES");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_resched_count);
-	seq_printf(p, "  Rescheduling interrupts\n");
+	seq_puts(p, "  Rescheduling interrupts\n");
 	seq_printf(p, "%*s: ", prec, "CAL");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count -
 					irq_stats(j)->irq_tlb_count);
-	seq_printf(p, "  Function call interrupts\n");
+	seq_puts(p, "  Function call interrupts\n");
 	seq_printf(p, "%*s: ", prec, "TLB");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_tlb_count);
-	seq_printf(p, "  TLB shootdowns\n");
+	seq_puts(p, "  TLB shootdowns\n");
 #endif
 #ifdef CONFIG_X86_THERMAL_VECTOR
 	seq_printf(p, "%*s: ", prec, "TRM");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_thermal_count);
-	seq_printf(p, "  Thermal event interrupts\n");
+	seq_puts(p, "  Thermal event interrupts\n");
 #endif
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	seq_printf(p, "%*s: ", prec, "THR");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_threshold_count);
-	seq_printf(p, "  Threshold APIC interrupts\n");
+	seq_puts(p, "  Threshold APIC interrupts\n");
 #endif
 #ifdef CONFIG_X86_MCE
 	seq_printf(p, "%*s: ", prec, "MCE");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", per_cpu(mce_exception_count, j));
-	seq_printf(p, "  Machine check exceptions\n");
+	seq_puts(p, "  Machine check exceptions\n");
 	seq_printf(p, "%*s: ", prec, "MCP");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
-	seq_printf(p, "  Machine check polls\n");
+	seq_puts(p, "  Machine check polls\n");
 #endif
 #if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
 	seq_printf(p, "%*s: ", prec, "THR");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
-	seq_printf(p, "  Hypervisor callback interrupts\n");
+	seq_puts(p, "  Hypervisor callback interrupts\n");
 #endif
 	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 657438858e83..c7eddbe6a612 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -824,7 +824,7 @@ static void *memtype_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	if (*pos == 0) {
 		++*pos;
-		seq_printf(seq, "PAT memtype list:\n");
+		seq_puts(seq, "PAT memtype list:\n");
 	}
 
 	return memtype_get_idx(*pos);
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 3968d67d366b..ab4062c5953c 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1367,20 +1367,18 @@ static int ptc_seq_show(struct seq_file *file, void *data)
 
 	cpu = *(loff_t *)data;
 	if (!cpu) {
-		seq_printf(file,
-		 "# cpu bauoff sent stime self locals remotes ncpus localhub ");
-		seq_printf(file,
-			"remotehub numuvhubs numuvhubs16 numuvhubs8 ");
-		seq_printf(file,
-			"numuvhubs4 numuvhubs2 numuvhubs1 dto snacks retries ");
-		seq_printf(file,
-			"rok resetp resett giveup sto bz throt disable ");
-		seq_printf(file,
-			"enable wars warshw warwaits enters ipidis plugged ");
-		seq_printf(file,
-			"ipiover glim cong swack recv rtime all one mult ");
-		seq_printf(file,
-			"none retry canc nocan reset rcan\n");
+		seq_puts(file,
+			 "# cpu bauoff sent stime self locals remotes ncpus localhub ");
+		seq_puts(file, "remotehub numuvhubs numuvhubs16 numuvhubs8 ");
+		seq_puts(file,
+			 "numuvhubs4 numuvhubs2 numuvhubs1 dto snacks retries ");
+		seq_puts(file,
+			 "rok resetp resett giveup sto bz throt disable ");
+		seq_puts(file,
+			 "enable wars warshw warwaits enters ipidis plugged ");
+		seq_puts(file,
+			 "ipiover glim cong swack recv rtime all one mult ");
+		seq_puts(file, "none retry canc nocan reset rcan\n");
 	}
 	if (cpu < num_possible_cpus() && cpu_online(cpu)) {
 		bcp = &per_cpu(bau_control, cpu);
