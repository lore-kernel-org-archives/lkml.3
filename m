Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3GAKht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:37:49 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:60057 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3GAKhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:37:47 -0400
Date: Mon, 1 Jul 2013 12:37:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm changes for v3.11
Message-ID: <20130701103741.GA18231@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

   HEAD: 4f4319a02a6108be3e65b9d44d1b7f5e8f520535 x86/ioremap: Correct function name output

Misc improvements:

 - Fix /proc/mtrr reporting
 - Fix ioremap printout
 - Remove the unused pvclock fixmap entry on 32-bit
 - misc cleanups

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86/ioremap: Correct function name output

Jan Beulich (1):
      ix86: Don't waste fixmap entries

Yinghai Lu (1):
      x86: Fix /proc/mtrr with base/size more than 44bits

Zhang Yanfei (2):
      x86_64: Correct phys_addr in cleanup_highmap comment
      x86/mm: Drop unneeded include <asm/*pgtable, page*_types.h>


 arch/x86/boot/compressed/head_64.S |  2 --
 arch/x86/include/asm/fixmap.h      |  2 +-
 arch/x86/kernel/cpu/mtrr/generic.c | 21 +++++++++++----------
 arch/x86/kernel/cpu/mtrr/main.c    | 16 +++++++++-------
 arch/x86/mm/init_64.c              |  2 +-
 arch/x86/mm/ioremap.c              |  8 ++++----
 6 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 16f24e6..06e71c2 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -27,8 +27,6 @@
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
-#include <asm/pgtable_types.h>
-#include <asm/page_types.h>
 #include <asm/boot.h>
 #include <asm/msr.h>
 #include <asm/processor-flags.h>
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 0dc7d9e..e846225 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -81,11 +81,11 @@ enum fixed_addresses {
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
 	VVAR_PAGE,
 	VSYSCALL_HPET,
-#endif
 #ifdef CONFIG_PARAVIRT_CLOCK
 	PVCLOCK_FIXMAP_BEGIN,
 	PVCLOCK_FIXMAP_END = PVCLOCK_FIXMAP_BEGIN+PVCLOCK_VSYSCALL_NR_PAGES-1,
 #endif
+#endif
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index fa72a39..3982357 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -510,8 +510,9 @@ generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 			     unsigned long *size, mtrr_type *type)
 {
-	unsigned int mask_lo, mask_hi, base_lo, base_hi;
-	unsigned int tmp, hi;
+	u32 mask_lo, mask_hi, base_lo, base_hi;
+	unsigned int hi;
+	u64 tmp, mask;
 
 	/*
 	 * get_mtrr doesn't need to update mtrr_state, also it could be called
@@ -532,18 +533,18 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 	rdmsr(MTRRphysBase_MSR(reg), base_lo, base_hi);
 
 	/* Work out the shifted address mask: */
-	tmp = mask_hi << (32 - PAGE_SHIFT) | mask_lo >> PAGE_SHIFT;
-	mask_lo = size_or_mask | tmp;
+	tmp = (u64)mask_hi << (32 - PAGE_SHIFT) | mask_lo >> PAGE_SHIFT;
+	mask = size_or_mask | tmp;
 
 	/* Expand tmp with high bits to all 1s: */
-	hi = fls(tmp);
+	hi = fls64(tmp);
 	if (hi > 0) {
-		tmp |= ~((1<<(hi - 1)) - 1);
+		tmp |= ~((1ULL<<(hi - 1)) - 1);
 
-		if (tmp != mask_lo) {
+		if (tmp != mask) {
 			printk(KERN_WARNING "mtrr: your BIOS has configured an incorrect mask, fixing it.\n");
 			add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
-			mask_lo = tmp;
+			mask = tmp;
 		}
 	}
 
@@ -551,8 +552,8 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 	 * This works correctly if size is a power of two, i.e. a
 	 * contiguous range:
 	 */
-	*size = -mask_lo;
-	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
+	*size = -mask;
+	*base = (u64)base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
 	*type = base_lo & 0xff;
 
 out_put_cpu:
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 726bf96..ca22b73 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -305,7 +305,8 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 		return -EINVAL;
 	}
 
-	if (base & size_or_mask || size & size_or_mask) {
+	if ((base | (base + size - 1)) >>
+	    (boot_cpu_data.x86_phys_bits - PAGE_SHIFT)) {
 		pr_warning("mtrr: base or size exceeds the MTRR width\n");
 		return -EINVAL;
 	}
@@ -583,6 +584,7 @@ static struct syscore_ops mtrr_syscore_ops = {
 
 int __initdata changed_by_mtrr_cleanup;
 
+#define SIZE_OR_MASK_BITS(n)  (~((1ULL << ((n) - PAGE_SHIFT)) - 1))
 /**
  * mtrr_bp_init - initialize mtrrs on the boot CPU
  *
@@ -600,7 +602,7 @@ void __init mtrr_bp_init(void)
 
 	if (cpu_has_mtrr) {
 		mtrr_if = &generic_mtrr_ops;
-		size_or_mask = 0xff000000;			/* 36 bits */
+		size_or_mask = SIZE_OR_MASK_BITS(36);
 		size_and_mask = 0x00f00000;
 		phys_addr = 36;
 
@@ -619,7 +621,7 @@ void __init mtrr_bp_init(void)
 			     boot_cpu_data.x86_mask == 0x4))
 				phys_addr = 36;
 
-			size_or_mask = ~((1ULL << (phys_addr - PAGE_SHIFT)) - 1);
+			size_or_mask = SIZE_OR_MASK_BITS(phys_addr);
 			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
 		} else if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR &&
 			   boot_cpu_data.x86 == 6) {
@@ -627,7 +629,7 @@ void __init mtrr_bp_init(void)
 			 * VIA C* family have Intel style MTRRs,
 			 * but don't support PAE
 			 */
-			size_or_mask = 0xfff00000;		/* 32 bits */
+			size_or_mask = SIZE_OR_MASK_BITS(32);
 			size_and_mask = 0;
 			phys_addr = 32;
 		}
@@ -637,21 +639,21 @@ void __init mtrr_bp_init(void)
 			if (cpu_has_k6_mtrr) {
 				/* Pre-Athlon (K6) AMD CPU MTRRs */
 				mtrr_if = mtrr_ops[X86_VENDOR_AMD];
-				size_or_mask = 0xfff00000;	/* 32 bits */
+				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
 			}
 			break;
 		case X86_VENDOR_CENTAUR:
 			if (cpu_has_centaur_mcr) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CENTAUR];
-				size_or_mask = 0xfff00000;	/* 32 bits */
+				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
 			}
 			break;
 		case X86_VENDOR_CYRIX:
 			if (cpu_has_cyrix_arr) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CYRIX];
-				size_or_mask = 0xfff00000;	/* 32 bits */
+				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
 			}
 			break;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index bb00c46..b3940b6 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -368,7 +368,7 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
  *
  *   from __START_KERNEL_map to __START_KERNEL_map + size (== _end-_text)
  *
- * phys_addr holds the negative offset to the kernel, which is added
+ * phys_base holds the negative offset to the kernel, which is added
  * to the compile time generated pmds. This results in invalid pmds up
  * to the point where we hit the physaddr 0 mapping.
  *
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 9a1e658..0215e2c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -501,15 +501,15 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 	}
 
 	if (slot < 0) {
-		printk(KERN_INFO "early_iomap(%08llx, %08lx) not found slot\n",
-			 (u64)phys_addr, size);
+		printk(KERN_INFO "%s(%08llx, %08lx) not found slot\n",
+		       __func__, (u64)phys_addr, size);
 		WARN_ON(1);
 		return NULL;
 	}
 
 	if (early_ioremap_debug) {
-		printk(KERN_INFO "early_ioremap(%08llx, %08lx) [%d] => ",
-		       (u64)phys_addr, size, slot);
+		printk(KERN_INFO "%s(%08llx, %08lx) [%d] => ",
+		       __func__, (u64)phys_addr, size, slot);
 		dump_stack();
 	}
 
