Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaCJXeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 19:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbaCJXeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 19:34:07 -0400
Date: Mon, 10 Mar 2014 19:32:22 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Subject: [PATCH] x86: Remove CONFIG_X86_OOSTORE
Message-ID: <20140310233222.GA1798@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Stefani Seibold <stefani@seibold.net>,
	Andy Lutomirski <luto@amacapital.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
	Martin Runge <Martin.Runge@rohde-schwarz.com>
References: <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
 <531DD35A.5060202@linux.intel.com>
 <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>
 <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>
 <1394481804.980.9.camel@wall-e.seibold.net>
 <531E1B53.5090205@linux.intel.com>
 <CA+55aFyxbuhPKgB=U8R5C5T_iKVvju-oQDS4kHz6McW45B+1bA@mail.gmail.com>
 <CA+55aFwuVYds=ssv755WKBvux1ru6fcDLGi+ORSFyU8xYP7+=w@mail.gmail.com>
 <20140310215111.GA27749@redhat.com>
 <531E43B8.7090302@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531E43B8.7090302@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was an optimization that made memcpy type benchmarks a little faster
on ancient (Circa 1998) IDT Winchip CPUs.  In real-life workloads, it
wasn't even noticable, and I doubt anyone is running benchmarks on 16 year old
silicon any more.

Given this code has likely seen very little use over the last decade, let's just remove it.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index c026cca5602c..f3aaf231b4e5 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -341,10 +341,6 @@ config X86_USE_3DNOW
 	def_bool y
 	depends on (MCYRIXIII || MK7 || MGEODE_LX) && !UML
 
-config X86_OOSTORE
-	def_bool y
-	depends on (MWINCHIP3D || MWINCHIPC6) && MTRR
-
 #
 # P6_NOPs are a relatively minor optimization that require a family >=
 # 6 processor, except that it is broken on certain VIA chips.
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 04a48903b2eb..69bbb4845020 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -85,11 +85,7 @@
 #else
 # define smp_rmb()	barrier()
 #endif
-#ifdef CONFIG_X86_OOSTORE
-# define smp_wmb() 	wmb()
-#else
-# define smp_wmb()	barrier()
-#endif
+#define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
 #else /* !SMP */
@@ -100,7 +96,7 @@
 #define set_mb(var, value) do { var = value; barrier(); } while (0)
 #endif /* SMP */
 
-#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
+#if defined(CONFIG_X86_PPRO_FENCE)
 
 /*
  * For either of these options x86 doesn't have a strong TSO memory
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 34f69cb9350a..91d9c69a629e 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -237,7 +237,7 @@ memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
 
 static inline void flush_write_buffers(void)
 {
-#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
+#if defined(CONFIG_X86_PPRO_FENCE)
 	asm volatile("lock; addl $0,0(%%esp)": : :"memory");
 #endif
 }
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index bf156ded74b5..0f62f5482d91 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -26,10 +26,9 @@
 # define LOCK_PTR_REG "D"
 #endif
 
-#if defined(CONFIG_X86_32) && \
-	(defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE))
+#if defined(CONFIG_X86_32) && (defined(CONFIG_X86_PPRO_FENCE))
 /*
- * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
+ * On PPro SMP, we use a locked operation to unlock
  * (PPro errata 66, 92)
  */
 # define UNLOCK_LOCK_PREFIX LOCK_PREFIX
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 8779edab684e..d8fba5c15fbd 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -8,236 +8,6 @@
 
 #include "cpu.h"
 
-#ifdef CONFIG_X86_OOSTORE
-
-static u32 power2(u32 x)
-{
-	u32 s = 1;
-
-	while (s <= x)
-		s <<= 1;
-
-	return s >>= 1;
-}
-
-
-/*
- * Set up an actual MCR
- */
-static void centaur_mcr_insert(int reg, u32 base, u32 size, int key)
-{
-	u32 lo, hi;
-
-	hi = base & ~0xFFF;
-	lo = ~(size-1);		/* Size is a power of 2 so this makes a mask */
-	lo &= ~0xFFF;		/* Remove the ctrl value bits */
-	lo |= key;		/* Attribute we wish to set */
-	wrmsr(reg+MSR_IDT_MCR0, lo, hi);
-	mtrr_centaur_report_mcr(reg, lo, hi);	/* Tell the mtrr driver */
-}
-
-/*
- * Figure what we can cover with MCR's
- *
- * Shortcut: We know you can't put 4Gig of RAM on a winchip
- */
-static u32 ramtop(void)
-{
-	u32 clip = 0xFFFFFFFFUL;
-	u32 top = 0;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		unsigned long start, end;
-
-		if (e820.map[i].addr > 0xFFFFFFFFUL)
-			continue;
-		/*
-		 * Don't MCR over reserved space. Ignore the ISA hole
-		 * we frob around that catastrophe already
-		 */
-		if (e820.map[i].type == E820_RESERVED) {
-			if (e820.map[i].addr >= 0x100000UL &&
-			    e820.map[i].addr < clip)
-				clip = e820.map[i].addr;
-			continue;
-		}
-		start = e820.map[i].addr;
-		end = e820.map[i].addr + e820.map[i].size;
-		if (start >= end)
-			continue;
-		if (end > top)
-			top = end;
-	}
-	/*
-	 * Everything below 'top' should be RAM except for the ISA hole.
-	 * Because of the limited MCR's we want to map NV/ACPI into our
-	 * MCR range for gunk in RAM
-	 *
-	 * Clip might cause us to MCR insufficient RAM but that is an
-	 * acceptable failure mode and should only bite obscure boxes with
-	 * a VESA hole at 15Mb
-	 *
-	 * The second case Clip sometimes kicks in is when the EBDA is marked
-	 * as reserved. Again we fail safe with reasonable results
-	 */
-	if (top > clip)
-		top = clip;
-
-	return top;
-}
-
-/*
- * Compute a set of MCR's to give maximum coverage
- */
-static int centaur_mcr_compute(int nr, int key)
-{
-	u32 mem = ramtop();
-	u32 root = power2(mem);
-	u32 base = root;
-	u32 top = root;
-	u32 floor = 0;
-	int ct = 0;
-
-	while (ct < nr) {
-		u32 fspace = 0;
-		u32 high;
-		u32 low;
-
-		/*
-		 * Find the largest block we will fill going upwards
-		 */
-		high = power2(mem-top);
-
-		/*
-		 * Find the largest block we will fill going downwards
-		 */
-		low = base/2;
-
-		/*
-		 * Don't fill below 1Mb going downwards as there
-		 * is an ISA hole in the way.
-		 */
-		if (base <= 1024*1024)
-			low = 0;
-
-		/*
-		 * See how much space we could cover by filling below
-		 * the ISA hole
-		 */
-
-		if (floor == 0)
-			fspace = 512*1024;
-		else if (floor == 512*1024)
-			fspace = 128*1024;
-
-		/* And forget ROM space */
-
-		/*
-		 * Now install the largest coverage we get
-		 */
-		if (fspace > high && fspace > low) {
-			centaur_mcr_insert(ct, floor, fspace, key);
-			floor += fspace;
-		} else if (high > low) {
-			centaur_mcr_insert(ct, top, high, key);
-			top += high;
-		} else if (low > 0) {
-			base -= low;
-			centaur_mcr_insert(ct, base, low, key);
-		} else
-			break;
-		ct++;
-	}
-	/*
-	 * We loaded ct values. We now need to set the mask. The caller
-	 * must do this bit.
-	 */
-	return ct;
-}
-
-static void centaur_create_optimal_mcr(void)
-{
-	int used;
-	int i;
-
-	/*
-	 * Allocate up to 6 mcrs to mark as much of ram as possible
-	 * as write combining and weak write ordered.
-	 *
-	 * To experiment with: Linux never uses stack operations for
-	 * mmio spaces so we could globally enable stack operation wc
-	 *
-	 * Load the registers with type 31 - full write combining, all
-	 * writes weakly ordered.
-	 */
-	used = centaur_mcr_compute(6, 31);
-
-	/*
-	 * Wipe unused MCRs
-	 */
-	for (i = used; i < 8; i++)
-		wrmsr(MSR_IDT_MCR0+i, 0, 0);
-}
-
-static void winchip2_create_optimal_mcr(void)
-{
-	u32 lo, hi;
-	int used;
-	int i;
-
-	/*
-	 * Allocate up to 6 mcrs to mark as much of ram as possible
-	 * as write combining, weak store ordered.
-	 *
-	 * Load the registers with type 25
-	 *	8	-	weak write ordering
-	 *	16	-	weak read ordering
-	 *	1	-	write combining
-	 */
-	used = centaur_mcr_compute(6, 25);
-
-	/*
-	 * Mark the registers we are using.
-	 */
-	rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
-	for (i = 0; i < used; i++)
-		lo |= 1<<(9+i);
-	wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
-
-	/*
-	 * Wipe unused MCRs
-	 */
-
-	for (i = used; i < 8; i++)
-		wrmsr(MSR_IDT_MCR0+i, 0, 0);
-}
-
-/*
- * Handle the MCR key on the Winchip 2.
- */
-static void winchip2_unprotect_mcr(void)
-{
-	u32 lo, hi;
-	u32 key;
-
-	rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
-	lo &= ~0x1C0;	/* blank bits 8-6 */
-	key = (lo>>17) & 7;
-	lo |= key<<6;	/* replace with unlock key */
-	wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
-}
-
-static void winchip2_protect_mcr(void)
-{
-	u32 lo, hi;
-
-	rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
-	lo &= ~0x1C0;	/* blank bits 8-6 */
-	wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
-}
-#endif /* CONFIG_X86_OOSTORE */
-
 #define ACE_PRESENT	(1 << 6)
 #define ACE_ENABLED	(1 << 7)
 #define ACE_FCR		(1 << 28)	/* MSR_VIA_FCR */
@@ -362,20 +132,6 @@ static void init_centaur(struct cpuinfo_x86 *c)
 			fcr_clr = DPDC;
 			printk(KERN_NOTICE "Disabling bugged TSC.\n");
 			clear_cpu_cap(c, X86_FEATURE_TSC);
-#ifdef CONFIG_X86_OOSTORE
-			centaur_create_optimal_mcr();
-			/*
-			 * Enable:
-			 *	write combining on non-stack, non-string
-			 *	write combining on string, all types
-			 *	weak write ordering
-			 *
-			 * The C6 original lacks weak read order
-			 *
-			 * Note 0x120 is write only on Winchip 1
-			 */
-			wrmsr(MSR_IDT_MCR_CTRL, 0x01F0001F, 0);
-#endif
 			break;
 		case 8:
 			switch (c->x86_mask) {
@@ -392,40 +148,12 @@ static void init_centaur(struct cpuinfo_x86 *c)
 			fcr_set = ECX8|DSMC|DTLOCK|EMMX|EBRPRED|ERETSTK|
 				  E2MMX|EAMD3D;
 			fcr_clr = DPDC;
-#ifdef CONFIG_X86_OOSTORE
-			winchip2_unprotect_mcr();
-			winchip2_create_optimal_mcr();
-			rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
-			/*
-			 * Enable:
-			 *	write combining on non-stack, non-string
-			 *	write combining on string, all types
-			 *	weak write ordering
-			 */
-			lo |= 31;
-			wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
-			winchip2_protect_mcr();
-#endif
 			break;
 		case 9:
 			name = "3";
 			fcr_set = ECX8|DSMC|DTLOCK|EMMX|EBRPRED|ERETSTK|
 				  E2MMX|EAMD3D;
 			fcr_clr = DPDC;
-#ifdef CONFIG_X86_OOSTORE
-			winchip2_unprotect_mcr();
-			winchip2_create_optimal_mcr();
-			rdmsr(MSR_IDT_MCR_CTRL, lo, hi);
-			/*
-			 * Enable:
-			 *	write combining on non-stack, non-string
-			 *	write combining on string, all types
-			 *	weak write ordering
-			 */
-			lo |= 31;
-			wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
-			winchip2_protect_mcr();
-#endif
 			break;
 		default:
 			name = "??";
diff --git a/arch/x86/um/asm/barrier.h b/arch/x86/um/asm/barrier.h
index 7d01b8c56c00..cc04e67bfd05 100644
--- a/arch/x86/um/asm/barrier.h
+++ b/arch/x86/um/asm/barrier.h
@@ -40,11 +40,7 @@
 #define smp_rmb()	barrier()
 #endif /* CONFIG_X86_PPRO_FENCE */
 
-#ifdef CONFIG_X86_OOSTORE
-#define smp_wmb()	wmb()
-#else /* CONFIG_X86_OOSTORE */
 #define smp_wmb()	barrier()
-#endif /* CONFIG_X86_OOSTORE */
 
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
