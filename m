Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3LSJOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:14:24 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56884 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3LSJKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:10:33 -0500
Subject: [PATCH -tip v6 22/22] [RFC] kprobes/x86: Add emergency recovery
 process for bad kprobes
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 19 Dec 2013 09:04:48 +0000
Message-ID: <20131219090447.14309.72127.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
References: <20131219090353.14309.15496.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an emergency int3 recovery code for the kprobes on the
functions which will be used while single-step and must
not be probed. Most of such functions are blacklisted,
but the fixed blacklists can be outdated and in that case
it will cause an unexpected kernel panic.
For avoiding such trouble, this introduces an emergency
recovery routine, which is mostly copied from text_poke,
but optimized for one-byte recovery.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/fixmap.h        |    7 +++--
 arch/x86/include/asm/kprobes.h       |    1 +
 arch/x86/include/asm/paravirt.h      |    7 +++--
 arch/x86/include/asm/processor.h     |    2 +
 arch/x86/include/asm/special_insns.h |    4 +--
 arch/x86/include/asm/tlbflush.h      |    6 ++--
 arch/x86/kernel/kprobes/core.c       |   49 ++++++++++++++++++++++++++++++++--
 arch/x86/lguest/boot.c               |    1 +
 arch/x86/mm/pgtable.c                |    3 ++
 include/linux/kprobes.h              |    9 ++++++
 kernel/kprobes.c                     |    5 ++-
 11 files changed, 77 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index e846225..1cd14b3 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -117,6 +117,9 @@ enum fixed_addresses {
 #endif
 	FIX_TEXT_POKE1,	/* reserve 2 pages for text_poke() */
 	FIX_TEXT_POKE0, /* first page is last, because allocation is backward */
+#ifdef CONFIG_KPROBES
+	FIX_KPROBE_FIXUP,	/* For emergency int3 recovery */
+#endif
 #ifdef	CONFIG_X86_INTEL_MID
 	FIX_LNW_VRTC,
 #endif
@@ -168,8 +171,8 @@ void native_set_fixmap(enum fixed_addresses idx,
 		       phys_addr_t phys, pgprot_t flags);
 
 #ifndef CONFIG_PARAVIRT
-static inline void __set_fixmap(enum fixed_addresses idx,
-				phys_addr_t phys, pgprot_t flags)
+static nokprobe_inline void __set_fixmap(enum fixed_addresses idx,
+					 phys_addr_t phys, pgprot_t flags)
 {
 	native_set_fixmap(idx, phys, flags);
 }
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 53cdfb2..451514e 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -78,6 +78,7 @@ struct arch_specific_insn {
 	 */
 	int boostable;
 	bool if_modifier;
+	phys_addr_t	paddr; /* Physical address of probed page */
 };
 
 struct arch_optimized_insn {
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 401f350..ec3adf9 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -341,7 +341,7 @@ static inline void arch_exit_mmap(struct mm_struct *mm)
 	PVOP_VCALL1(pv_mmu_ops.exit_mmap, mm);
 }
 
-static inline void __flush_tlb(void)
+static nokprobe_inline void __flush_tlb(void)
 {
 	PVOP_VCALL0(pv_mmu_ops.flush_tlb_user);
 }
@@ -704,8 +704,9 @@ static inline void arch_flush_lazy_mmu_mode(void)
 	PVOP_VCALL0(pv_mmu_ops.lazy_mode.flush);
 }
 
-static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
-				phys_addr_t phys, pgprot_t flags)
+static nokprobe_inline
+void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
+		  phys_addr_t phys, pgprot_t flags)
 {
 	pv_mmu_ops.set_fixmap(idx, phys, flags);
 }
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b7845a1..4a9aa85 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -694,7 +694,7 @@ static inline void cpu_relax(void)
 }
 
 /* Stop speculative execution and prefetching of modified code. */
-static inline void sync_core(void)
+static nokprobe_inline void sync_core(void)
 {
 	int tmp;
 
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 645cad2..80ec151 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -42,14 +42,14 @@ static inline void native_write_cr2(unsigned long val)
 	asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
 }
 
-static inline unsigned long native_read_cr3(void)
+static nokprobe_inline unsigned long native_read_cr3(void)
 {
 	unsigned long val;
 	asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m" (__force_order));
 	return val;
 }
 
-static inline void native_write_cr3(unsigned long val)
+static nokprobe_inline void native_write_cr3(unsigned long val)
 {
 	asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
 }
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index e6d90ba..576d491 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -15,7 +15,7 @@
 #define __flush_tlb_single(addr) __native_flush_tlb_single(addr)
 #endif
 
-static inline void __native_flush_tlb(void)
+static nokprobe_inline void __native_flush_tlb(void)
 {
 	native_write_cr3(native_read_cr3());
 }
@@ -91,7 +91,7 @@ static inline void __flush_tlb_one(unsigned long addr)
  * directly.  All global TLB flushes need to either call this, or to bump the
  * vm statistics themselves.
  */
-static inline void __flush_tlb_up(void)
+static nokprobe_inline void __flush_tlb_up(void)
 {
 	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
 	__flush_tlb();
@@ -108,7 +108,7 @@ static inline void flush_tlb(void)
 	__flush_tlb_up();
 }
 
-static inline void local_flush_tlb(void)
+static nokprobe_inline void local_flush_tlb(void)
 {
 	__flush_tlb_up();
 }
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 6b4d9bd..8633116 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -51,12 +51,14 @@
 #include <linux/ftrace.h>
 
 #include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/debugreg.h>
+#include <asm/fixmap.h>
 
 #include "common.h"
 
@@ -372,6 +374,17 @@ int __copy_instruction(u8 *dest, u8 *src)
 static int arch_copy_kprobe(struct kprobe *p)
 {
 	int ret;
+	struct page *page;
+
+	/* Save physical page address for emergency recovery */
+	if (!core_kernel_text((unsigned long)p->addr))
+		page = vmalloc_to_page(p->addr);
+	else
+		page = virt_to_page(p->addr);
+
+	if (!page)
+		return -EINVAL;
+	p->ainsn.paddr = page_to_phys(page);
 
 	/* Copy an instruction with recovering if other optprobe modifies it.*/
 	ret = __copy_instruction(p->ainsn.insn, p->addr);
@@ -527,6 +540,32 @@ static void setup_singlestep(struct kprobe *p, struct pt_regs *regs,
 }
 NOKPROBE_SYMBOL(setup_singlestep);
 
+/* Use arch_spinlock because this is used in very sensitive area */
+static arch_spinlock_t kprobe_emerge_lock =
+	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+
+/* To recover original instruction inside exception handler */
+static int emergency_int3_recovery(struct kprobe *p)
+{
+	kprobe_opcode_t *vaddr;
+
+	arch_spin_lock(&kprobe_emerge_lock);
+
+	/* local irq is already disabled by int3 */
+	set_fixmap(FIX_KPROBE_FIXUP, p->ainsn.paddr);
+	vaddr = (kprobe_opcode_t *)fix_to_virt(FIX_KPROBE_FIXUP);
+	vaddr += (unsigned long)p->addr & ~PAGE_MASK;
+	*vaddr = p->opcode;
+	clear_fixmap(FIX_KPROBE_FIXUP);
+	/* This skips local tlb flush since the text is not reclaimed */
+	sync_core();
+
+	arch_spin_unlock(&kprobe_emerge_lock);
+
+	return (*p->addr == BREAKPOINT_INSTRUCTION) ? -1 : 0;
+}
+NOKPROBE_SYMBOL(emergency_int3_recovery);
+
 /*
  * We have reentered the kprobe_handler(), since another probe was hit while
  * within the handler. We save the original kprobes variables and just single
@@ -544,10 +583,14 @@ static int reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 	case KPROBE_HIT_SS:
 		/* A probe has been hit in the codepath leading up to, or just
 		 * after, single-stepping of a probed instruction. This entire
-		 * codepath should strictly reside in .kprobes.text section.
-		 * Raise a BUG or we'll continue in an endless reentering loop
-		 * and eventually a stack overflow.
+		 * codepath should be strictly listed on the blacklist.
+		 * Try to recover the original instruction.
 		 */
+		if (!emergency_int3_recovery(p)) {
+			p->flags |= KPROBE_FLAG_BAD | KPROBE_FLAG_GONE;
+			regs->ip = (unsigned long)p->addr;
+			break;
+		}
 		printk(KERN_WARNING "Unrecoverable kprobe detected at %p.\n",
 		       p->addr);
 		dump_kprobe(p);
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index bdf8532..90a48ae 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -789,6 +789,7 @@ static void lguest_flush_tlb_user(void)
 {
 	lazy_hcall1(LHCALL_FLUSH_TLB, 0);
 }
+NOKPROBE_SYMBOL(lguest_flush_tlb_user);
 
 /*
  * This is called when the kernel page tables have changed.  That's not very
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index c96314a..75f6ac4 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -1,5 +1,6 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
+#include <linux/kprobes.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/tlb.h>
@@ -468,9 +469,11 @@ void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
 	set_pte_vaddr(address, pte);
 	fixmaps_set++;
 }
+NOKPROBE_SYMBOL(__native_set_fixmap);
 
 void native_set_fixmap(enum fixed_addresses idx, phys_addr_t phys,
 		       pgprot_t flags)
 {
 	__native_set_fixmap(idx, pfn_pte(phys >> PAGE_SHIFT, flags));
 }
+NOKPROBE_SYMBOL(native_set_fixmap);
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index e81bced..45ca3aa 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -128,6 +128,7 @@ struct kprobe {
 				   * this flag is only for optimized_kprobe.
 				   */
 #define KPROBE_FLAG_FTRACE	8 /* probe is using ftrace */
+#define KPROBE_FLAG_BAD		16	/* probe is on the bad path */
 
 /* Has this kprobe gone ? */
 static inline int kprobe_gone(struct kprobe *p)
@@ -147,12 +148,18 @@ static inline int kprobe_optimized(struct kprobe *p)
 	return p->flags & KPROBE_FLAG_OPTIMIZED;
 }
 
-/* Is this kprobe uses ftrace ? */
+/* Is this kprobe on a bad path (and removed) ? */
 static inline int kprobe_ftrace(struct kprobe *p)
 {
 	return p->flags & KPROBE_FLAG_FTRACE;
 }
 
+/* Is this kprobe uses ftrace ? */
+static inline int kprobe_badpath(struct kprobe *p)
+{
+	return p->flags & KPROBE_FLAG_BAD;
+}
+
 /*
  * Special probe type that uses setjmp-longjmp type tricks to resume
  * execution at a specified entry with a matching prototype corresponding
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index abdede5..c762155 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2244,11 +2244,12 @@ static void report_probe(struct seq_file *pi, struct kprobe *p,
 
 	if (!pp)
 		pp = p;
-	seq_printf(pi, "%s%s%s%s\n",
+	seq_printf(pi, "%s%s%s%s%s\n",
 		(kprobe_gone(p) ? "[GONE]" : ""),
 		((kprobe_disabled(p) && !kprobe_gone(p)) ?  "[DISABLED]" : ""),
 		(kprobe_optimized(pp) ? "[OPTIMIZED]" : ""),
-		(kprobe_ftrace(pp) ? "[FTRACE]" : ""));
+		(kprobe_ftrace(pp) ? "[FTRACE]" : ""),
+		(kprobe_badpath(pp) ? "[BAD]" : ""));
 }
 
 static void *kprobe_seq_start(struct seq_file *f, loff_t *pos)


