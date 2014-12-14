Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaLNTqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 14:46:37 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60811 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaLNTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 14:46:31 -0500
Date: Sun, 14 Dec 2014 20:46:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20141214194624.GA4498@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: 0e58af4e1d2166e9e33375a0f121e4867010d4f8 x86/tls: Disallow unusual TLS segments

Misc fixes (mainly Andy's TLS fixes), plus a cleanup.

  out-of-topic modifications in x86-urgent-for-linus:
  -----------------------------------------------------
  MAINTAINERS                        # f0905c5a32ce: MAINTAINERS: Add me as x86 V

 Thanks,

	Ingo

------------------>
Andy Lutomirski (4):
      x86_64, switch_to(): Load TLS descriptors before switching DS and ES
      MAINTAINERS: Add me as x86 VDSO submaintainer
      x86/tls: Validate TLS entries to protect espfix
      x86/tls: Disallow unusual TLS segments

Borislav Petkov (2):
      x86/asm: Guard against building the 32/64-bit versions of the asm-offsets*.c file directly
      x86/asm: Unify segment selector defines

Luis R. Rodriguez (1):
      x86/doc: Update documentation after file shuffling

Xishi Qiu (2):
      x86/mm: Fix zone ranges boot printout
      x86/mm: Use min() instead of min_t() in the e820 printout code


 Documentation/x86/entry_64.txt   |   7 ++-
 MAINTAINERS                      |   7 +++
 arch/x86/include/asm/dma.h       |   2 +-
 arch/x86/include/asm/segment.h   |  30 ++++--------
 arch/x86/kernel/asm-offsets_32.c |   4 ++
 arch/x86/kernel/asm-offsets_64.c |   4 ++
 arch/x86/kernel/e820.c           |   4 +-
 arch/x86/kernel/process_64.c     | 101 ++++++++++++++++++++++++++++-----------
 arch/x86/kernel/tls.c            |  45 +++++++++++++++++
 arch/x86/mm/init.c               |   4 +-
 10 files changed, 152 insertions(+), 56 deletions(-)

diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
index bc7226ef5055..4a1c5c2dc5a9 100644
--- a/Documentation/x86/entry_64.txt
+++ b/Documentation/x86/entry_64.txt
@@ -7,9 +7,12 @@ http://lkml.kernel.org/r/<20110529191055.GC9835%40elte.hu>
 The x86 architecture has quite a few different ways to jump into
 kernel code.  Most of these entry points are registered in
 arch/x86/kernel/traps.c and implemented in arch/x86/kernel/entry_64.S
-and arch/x86/ia32/ia32entry.S.
+for 64-bit, arch/x86/kernel/entry_32.S for 32-bit and finally
+arch/x86/ia32/ia32entry.S which implements the 32-bit compatibility
+syscall entry points and thus provides for 32-bit processes the
+ability to execute syscalls when running on 64-bit kernels.
 
-The IDT vector assignments are listed in arch/x86/include/irq_vectors.h.
+The IDT vector assignments are listed in arch/x86/include/asm/irq_vectors.h.
 
 Some of these entries are:
 
diff --git a/MAINTAINERS b/MAINTAINERS
index c444907ccd69..7a54fa88018a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10295,6 +10295,13 @@ L:	linux-edac@vger.kernel.org
 S:	Maintained
 F:	arch/x86/kernel/cpu/mcheck/*
 
+X86 VDSO
+M:	Andy Lutomirski <luto@amacapital.net>
+L:	linux-kernel@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
+S:	Maintained
+F:	arch/x86/vdso/
+
 XC2028/3028 TUNER DRIVER
 M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
diff --git a/arch/x86/include/asm/dma.h b/arch/x86/include/asm/dma.h
index 0bdb0c54d9a1..fe884e18fa6e 100644
--- a/arch/x86/include/asm/dma.h
+++ b/arch/x86/include/asm/dma.h
@@ -70,7 +70,7 @@
 #define MAX_DMA_CHANNELS	8
 
 /* 16MB ISA DMA zone */
-#define MAX_DMA_PFN   ((16 * 1024 * 1024) >> PAGE_SHIFT)
+#define MAX_DMA_PFN   ((16UL * 1024 * 1024) >> PAGE_SHIFT)
 
 /* 4GB broken PCI/AGP hardware bus master zone */
 #define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024) >> PAGE_SHIFT)
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 6f1c3a8a33ab..db257a58571f 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -23,6 +23,15 @@
 #define GDT_ENTRY_BOOT_TSS	(GDT_ENTRY_BOOT_CS + 2)
 #define __BOOT_TSS		(GDT_ENTRY_BOOT_TSS * 8)
 
+#define SEGMENT_RPL_MASK	0x3 /*
+				     * Bottom two bits of selector give the ring
+				     * privilege level
+				     */
+#define SEGMENT_TI_MASK		0x4 /* Bit 2 is table indicator (LDT/GDT) */
+#define USER_RPL		0x3 /* User mode is privilege level 3 */
+#define SEGMENT_LDT		0x4 /* LDT segment has TI set... */
+#define SEGMENT_GDT		0x0 /* ... GDT has it cleared */
+
 #ifdef CONFIG_X86_32
 /*
  * The layout of the per-CPU GDT under Linux:
@@ -125,16 +134,6 @@
 #define PNP_TS1    (GDT_ENTRY_PNPBIOS_TS1 * 8)	/* transfer data segment */
 #define PNP_TS2    (GDT_ENTRY_PNPBIOS_TS2 * 8)	/* another data segment */
 
-/* Bottom two bits of selector give the ring privilege level */
-#define SEGMENT_RPL_MASK	0x3
-/* Bit 2 is table indicator (LDT/GDT) */
-#define SEGMENT_TI_MASK		0x4
-
-/* User mode is privilege level 3 */
-#define USER_RPL		0x3
-/* LDT segment has TI set, GDT has it cleared */
-#define SEGMENT_LDT		0x4
-#define SEGMENT_GDT		0x0
 
 /*
  * Matching rules for certain types of segments.
@@ -192,17 +191,6 @@
 #define get_kernel_rpl()  0
 #endif
 
-/* User mode is privilege level 3 */
-#define USER_RPL		0x3
-/* LDT segment has TI set, GDT has it cleared */
-#define SEGMENT_LDT		0x4
-#define SEGMENT_GDT		0x0
-
-/* Bottom two bits of selector give the ring privilege level */
-#define SEGMENT_RPL_MASK	0x3
-/* Bit 2 is table indicator (LDT/GDT) */
-#define SEGMENT_TI_MASK		0x4
-
 #define IDT_ENTRIES 256
 #define NUM_EXCEPTION_VECTORS 32
 /* Bitmask of exception vectors which push an error code on the stack */
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index d67c4be3e8b1..3b3b9d33ac1d 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -1,3 +1,7 @@
+#ifndef __LINUX_KBUILD_H
+# error "Please do not build this file directly, build asm-offsets.c instead"
+#endif
+
 #include <asm/ucontext.h>
 
 #include <linux/lguest.h>
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index e7c798b354fa..4c0c596dfb95 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -1,3 +1,7 @@
+#ifndef __LINUX_KBUILD_H
+# error "Please do not build this file directly, build asm-offsets.c instead"
+#endif
+
 #include <asm/ia32.h>
 
 #define __SYSCALL_64(nr, sym, compat) [nr] = 1,
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 49f886481615..dd2f07ae9d0c 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1114,8 +1114,8 @@ void __init memblock_find_dma_reserve(void)
 	 * at first, and assume boot_mem will not take below MAX_DMA_PFN
 	 */
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
-		start_pfn = min_t(unsigned long, start_pfn, MAX_DMA_PFN);
-		end_pfn = min_t(unsigned long, end_pfn, MAX_DMA_PFN);
+		start_pfn = min(start_pfn, MAX_DMA_PFN);
+		end_pfn = min(end_pfn, MAX_DMA_PFN);
 		nr_pages += end_pfn - start_pfn;
 	}
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3ed4a68d4013..5a2c02913af3 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -283,24 +283,9 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	fpu = switch_fpu_prepare(prev_p, next_p, cpu);
 
-	/*
-	 * Reload esp0, LDT and the page table pointer:
-	 */
+	/* Reload esp0 and ss1. */
 	load_sp0(tss, next);
 
-	/*
-	 * Switch DS and ES.
-	 * This won't pick up thread selector changes, but I guess that is ok.
-	 */
-	savesegment(es, prev->es);
-	if (unlikely(next->es | prev->es))
-		loadsegment(es, next->es);
-
-	savesegment(ds, prev->ds);
-	if (unlikely(next->ds | prev->ds))
-		loadsegment(ds, next->ds);
-
-
 	/* We must save %fs and %gs before load_TLS() because
 	 * %fs and %gs may be cleared by load_TLS().
 	 *
@@ -309,41 +294,101 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	savesegment(fs, fsindex);
 	savesegment(gs, gsindex);
 
+	/*
+	 * Load TLS before restoring any segments so that segment loads
+	 * reference the correct GDT entries.
+	 */
 	load_TLS(next, cpu);
 
 	/*
-	 * Leave lazy mode, flushing any hypercalls made here.
-	 * This must be done before restoring TLS segments so
-	 * the GDT and LDT are properly updated, and must be
-	 * done before math_state_restore, so the TS bit is up
-	 * to date.
+	 * Leave lazy mode, flushing any hypercalls made here.  This
+	 * must be done after loading TLS entries in the GDT but before
+	 * loading segments that might reference them, and and it must
+	 * be done before math_state_restore, so the TS bit is up to
+	 * date.
 	 */
 	arch_end_context_switch(next_p);
 
+	/* Switch DS and ES.
+	 *
+	 * Reading them only returns the selectors, but writing them (if
+	 * nonzero) loads the full descriptor from the GDT or LDT.  The
+	 * LDT for next is loaded in switch_mm, and the GDT is loaded
+	 * above.
+	 *
+	 * We therefore need to write new values to the segment
+	 * registers on every context switch unless both the new and old
+	 * values are zero.
+	 *
+	 * Note that we don't need to do anything for CS and SS, as
+	 * those are saved and restored as part of pt_regs.
+	 */
+	savesegment(es, prev->es);
+	if (unlikely(next->es | prev->es))
+		loadsegment(es, next->es);
+
+	savesegment(ds, prev->ds);
+	if (unlikely(next->ds | prev->ds))
+		loadsegment(ds, next->ds);
+
 	/*
 	 * Switch FS and GS.
 	 *
-	 * Segment register != 0 always requires a reload.  Also
-	 * reload when it has changed.  When prev process used 64bit
-	 * base always reload to avoid an information leak.
+	 * These are even more complicated than FS and GS: they have
+	 * 64-bit bases are that controlled by arch_prctl.  Those bases
+	 * only differ from the values in the GDT or LDT if the selector
+	 * is 0.
+	 *
+	 * Loading the segment register resets the hidden base part of
+	 * the register to 0 or the value from the GDT / LDT.  If the
+	 * next base address zero, writing 0 to the segment register is
+	 * much faster than using wrmsr to explicitly zero the base.
+	 *
+	 * The thread_struct.fs and thread_struct.gs values are 0
+	 * if the fs and gs bases respectively are not overridden
+	 * from the values implied by fsindex and gsindex.  They
+	 * are nonzero, and store the nonzero base addresses, if
+	 * the bases are overridden.
+	 *
+	 * (fs != 0 && fsindex != 0) || (gs != 0 && gsindex != 0) should
+	 * be impossible.
+	 *
+	 * Therefore we need to reload the segment registers if either
+	 * the old or new selector is nonzero, and we need to override
+	 * the base address if next thread expects it to be overridden.
+	 *
+	 * This code is unnecessarily slow in the case where the old and
+	 * new indexes are zero and the new base is nonzero -- it will
+	 * unnecessarily write 0 to the selector before writing the new
+	 * base address.
+	 *
+	 * Note: This all depends on arch_prctl being the only way that
+	 * user code can override the segment base.  Once wrfsbase and
+	 * wrgsbase are enabled, most of this code will need to change.
 	 */
 	if (unlikely(fsindex | next->fsindex | prev->fs)) {
 		loadsegment(fs, next->fsindex);
+
 		/*
-		 * Check if the user used a selector != 0; if yes
-		 *  clear 64bit base, since overloaded base is always
-		 *  mapped to the Null selector
+		 * If user code wrote a nonzero value to FS, then it also
+		 * cleared the overridden base address.
+		 *
+		 * XXX: if user code wrote 0 to FS and cleared the base
+		 * address itself, we won't notice and we'll incorrectly
+		 * restore the prior base address next time we reschdule
+		 * the process.
 		 */
 		if (fsindex)
 			prev->fs = 0;
 	}
-	/* when next process has a 64bit base use it */
 	if (next->fs)
 		wrmsrl(MSR_FS_BASE, next->fs);
 	prev->fsindex = fsindex;
 
 	if (unlikely(gsindex | next->gsindex | prev->gs)) {
 		load_gs_index(next->gsindex);
+
+		/* This works (and fails) the same way as fsindex above. */
 		if (gsindex)
 			prev->gs = 0;
 	}
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index f7fec09e3e3a..3e551eee87b9 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -27,6 +27,43 @@ static int get_free_idx(void)
 	return -ESRCH;
 }
 
+static bool tls_desc_okay(const struct user_desc *info)
+{
+	if (LDT_empty(info))
+		return true;
+
+	/*
+	 * espfix is required for 16-bit data segments, but espfix
+	 * only works for LDT segments.
+	 */
+	if (!info->seg_32bit)
+		return false;
+
+	/* Only allow data segments in the TLS array. */
+	if (info->contents > 1)
+		return false;
+
+	/*
+	 * Non-present segments with DPL 3 present an interesting attack
+	 * surface.  The kernel should handle such segments correctly,
+	 * but TLS is very difficult to protect in a sandbox, so prevent
+	 * such segments from being created.
+	 *
+	 * If userspace needs to remove a TLS entry, it can still delete
+	 * it outright.
+	 */
+	if (info->seg_not_present)
+		return false;
+
+#ifdef CONFIG_X86_64
+	/* The L bit makes no sense for data. */
+	if (info->lm)
+		return false;
+#endif
+
+	return true;
+}
+
 static void set_tls_desc(struct task_struct *p, int idx,
 			 const struct user_desc *info, int n)
 {
@@ -66,6 +103,9 @@ int do_set_thread_area(struct task_struct *p, int idx,
 	if (copy_from_user(&info, u_info, sizeof(info)))
 		return -EFAULT;
 
+	if (!tls_desc_okay(&info))
+		return -EINVAL;
+
 	if (idx == -1)
 		idx = info.entry_number;
 
@@ -192,6 +232,7 @@ int regset_tls_set(struct task_struct *target, const struct user_regset *regset,
 {
 	struct user_desc infobuf[GDT_ENTRY_TLS_ENTRIES];
 	const struct user_desc *info;
+	int i;
 
 	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
@@ -205,6 +246,10 @@ int regset_tls_set(struct task_struct *target, const struct user_regset *regset,
 	else
 		info = infobuf;
 
+	for (i = 0; i < count / sizeof(struct user_desc); i++)
+		if (!tls_desc_okay(info + i))
+			return -EINVAL;
+
 	set_tls_desc(target,
 		     GDT_ENTRY_TLS_MIN + (pos / sizeof(struct user_desc)),
 		     info, count / sizeof(struct user_desc));
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 66dba36f2343..07244aa6609e 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -674,10 +674,10 @@ void __init zone_sizes_init(void)
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 
 #ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA]		= MAX_DMA_PFN;
+	max_zone_pfns[ZONE_DMA]		= min(MAX_DMA_PFN, max_low_pfn);
 #endif
 #ifdef CONFIG_ZONE_DMA32
-	max_zone_pfns[ZONE_DMA32]	= MAX_DMA32_PFN;
+	max_zone_pfns[ZONE_DMA32]	= min(MAX_DMA32_PFN, max_low_pfn);
 #endif
 	max_zone_pfns[ZONE_NORMAL]	= max_low_pfn;
 #ifdef CONFIG_HIGHMEM
