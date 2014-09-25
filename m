Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaIYDit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 23:38:49 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56434 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaIYDir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 23:38:47 -0400
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, tglx@linutronix.de, hpa@zytor.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86, MCE, AMD: detect the threshold at the initialization period
Date: Thu, 25 Sep 2014 11:38:09 +0800
Message-Id: <1411616289-28684-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ADM64 APM Volume 2 (9.3.2 Error-Reporting Register Banks)documents
that the size of threshold counter is implementation-dependent, and
the implementations with less than 16 bits fill the most significant
unimplemented bits with zeros. So THRESHOLD_MAX should be detected
at the initialization period rather than a constant.

On the other hand, Error Counter (ERRCT) is bits 47:32, and accordingly
MASK_ERR_COUNT_HI should be 0x0000FFFF instead of 0x00000FFF.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   60 ++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 5d4999f..c6552d2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -33,8 +33,10 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 
+static u32 threshold_max;
+
 #define NR_BLOCKS         9
-#define THRESHOLD_MAX     0xFFF
+#define THRESHOLD_MAX     threshold_max
 #define INT_TYPE_APIC     0x00020000
 #define MASK_VALID_HI     0x80000000
 #define MASK_CNTP_HI      0x40000000
@@ -43,7 +45,7 @@
 #define MASK_COUNT_EN_HI  0x00080000
 #define MASK_INT_TYPE_HI  0x00060000
 #define MASK_OVERFLOW_HI  0x00010000
-#define MASK_ERR_COUNT_HI 0x00000FFF
+#define MASK_ERR_COUNT_HI 0x0000FFFF
 #define MASK_BLKPTR_LO    0xFF000000
 #define MCG_XBLK_ADDR     0xC0000400
 
@@ -135,6 +137,54 @@ static int lvt_off_valid(struct threshold_block *b, int apic, u32 lo, u32 hi)
 	return 1;
 };
 
+static u32 get_threshold(int bank, int block)
+{
+	u64 cap;
+	u32 low = 0, high = 0, old_high = 0, address = 0;
+
+	rdmsrl(MSR_IA32_MCG_CAP, cap);
+	if (bank < 0 || bank >= (cap & MCG_BANKCNT_MASK))
+		return 0;
+
+	if (block < 0 || block >= NR_BLOCKS)
+		return 0;
+
+	address = MSR_IA32_MCx_MISC(bank);
+	rdmsr_safe(address, &low, &high);
+
+	if (block != 0) {
+		address = (low & MASK_BLKPTR_LO) >> 21;
+		if (!address)
+			return 0;
+
+		address = address + MCG_XBLK_ADDR + block - 1;
+		rdmsr_safe(address, &low, &high);
+	}
+
+	if (!(high & MASK_VALID_HI))
+		return 0;
+
+	if (!(high & MASK_CNTP_HI)  ||
+		(high & MASK_LOCKED_HI))
+		return 0;
+
+	/* read original value and save it for restoring */
+	old_high = high;
+
+	/*
+	 * write all 1s to ERR_COUNT field and then reread it for getting
+	 * the maximum of threshold
+	 */
+	high = (high & ~MASK_ERR_COUNT_HI) | MASK_ERR_COUNT_HI;
+	wrmsr_safe(address, low, high);
+	rdmsr_safe(address, &low, &high);
+
+	/* restore the original value */
+	wrmsr_safe(address, low, old_high);
+
+	return high & MASK_ERR_COUNT_HI;
+}
+
 /*
  * Called via smp_call_function_single(), must be called with correct
  * cpu affinity.
@@ -214,6 +264,12 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 	unsigned int bank, block;
 	int offset = -1;
 
+	/*
+	 * bank 4 supports APIC LVT interrupts implicitly since forever.
+	 * So we can use bank4 for detecting the threshold.
+	 */
+	threshold_max = get_threshold(4, 0);
+
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			if (block == 0)
-- 
1.7.10.4

