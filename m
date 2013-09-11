Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3IKF00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:26:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3IKE5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:25 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0DeAtXFmbtoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NKIvMLOSVOQA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=8g_Uae-q20W9xVnRYXIA:9 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=5mKDLLHZsG8yLKFC:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042911.925866030@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [118/251] x86: Fix /proc/mtrr with base/size more than 44bits
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0118-x86-Fix-proc-mtrr-with-base-size-more-than-44bits.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

[ Upstream commit d5c78673b1b28467354c2c30c3d4f003666ff385 ]

On one sytem that mtrr range is more then 44bits, in dmesg we have
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-through
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 [000080000000-0000FFFFFFFF] mask 3FFF80000000 uncachable
[    0.000000]   1 [380000000000-38FFFFFFFFFF] mask 3F0000000000 uncachable
[    0.000000]   2 [000099000000-000099FFFFFF] mask 3FFFFF000000 write-through
[    0.000000]   3 [00009A000000-00009AFFFFFF] mask 3FFFFF000000 write-through
[    0.000000]   4 [381FFA000000-381FFBFFFFFF] mask 3FFFFE000000 write-through
[    0.000000]   5 [381FFC000000-381FFC0FFFFF] mask 3FFFFFF00000 write-through
[    0.000000]   6 [0000AD000000-0000ADFFFFFF] mask 3FFFFF000000 write-through
[    0.000000]   7 [0000BD000000-0000BDFFFFFF] mask 3FFFFF000000 write-through
[    0.000000]   8 disabled
[    0.000000]   9 disabled

but /proc/mtrr report wrong:
reg00: base=0x080000000 ( 2048MB), size= 2048MB, count=1: uncachable
reg01: base=0x80000000000 (8388608MB), size=1048576MB, count=1: uncachable
reg02: base=0x099000000 ( 2448MB), size=   16MB, count=1: write-through
reg03: base=0x09a000000 ( 2464MB), size=   16MB, count=1: write-through
reg04: base=0x81ffa000000 (8519584MB), size=   32MB, count=1: write-through
reg05: base=0x81ffc000000 (8519616MB), size=    1MB, count=1: write-through
reg06: base=0x0ad000000 ( 2768MB), size=   16MB, count=1: write-through
reg07: base=0x0bd000000 ( 3024MB), size=   16MB, count=1: write-through
reg08: base=0x09b000000 ( 2480MB), size=   16MB, count=1: write-combining

so bit 44 and bit 45 get cut off.

We have problems in arch/x86/kernel/cpu/mtrr/generic.c::generic_get_mtrr().
1. for base, we miss cast base_lo to 64bit before shifting.
Fix that by adding u64 casting.

2. for size, it only can handle 44 bits aka 32bits + page_shift
Fix that with 64bit mask instead of 32bit mask_lo, then range could be
more than 44bits.
At the same time, we need to update size_or_mask for old cpus that does
support cpuid 0x80000008 to get phys_addr. Need to set high 32bits
to all 1s, otherwise will not get correct size for them.

Also fix mtrr_add_page: it should check base and (base + size - 1)
instead of base and size, as base and size could be small but
base + size could bigger enough to be out of boundary. We can
use boot_cpu_data.x86_phys_bits directly to avoid size_or_mask.

So When are we going to have size more than 44bits? that is 16TiB.

after patch we have right ouput:
reg00: base=0x080000000 ( 2048MB), size= 2048MB, count=1: uncachable
reg01: base=0x380000000000 (58720256MB), size=1048576MB, count=1: uncachable
reg02: base=0x099000000 ( 2448MB), size=   16MB, count=1: write-through
reg03: base=0x09a000000 ( 2464MB), size=   16MB, count=1: write-through
reg04: base=0x381ffa000000 (58851232MB), size=   32MB, count=1: write-through
reg05: base=0x381ffc000000 (58851264MB), size=    1MB, count=1: write-through
reg06: base=0x0ad000000 ( 2768MB), size=   16MB, count=1: write-through
reg07: base=0x0bd000000 ( 3024MB), size=   16MB, count=1: write-through
reg08: base=0x09b000000 ( 2480MB), size=   16MB, count=1: write-combining

-v2: simply checking in mtrr_add_page according to hpa.

[ hpa: This probably wants to go into -stable only after having sat in
  mainline for a bit.  It is not a regression. ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371162815-29931-1-git-send-email-yinghai@kernel.org
Cc: <stable@vger.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/mtrr/generic.c |   21 +++++++++++----------
 arch/x86/kernel/cpu/mtrr/main.c    |   16 +++++++++-------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index e9fe907..5ac2152 100644
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
 			add_taint(TAINT_FIRMWARE_WORKAROUND);
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
index 6b96110..87f918e 100644
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
-- 
1.7.10.4


