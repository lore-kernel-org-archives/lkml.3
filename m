Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbaKRU4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:56:38 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53952 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaKRU4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:56:36 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Rob Clark <robdclark@gmail.com>
Subject: [PATCH] ARM: vfp: Silence mvfr0 unused variable warning
Date: Tue, 18 Nov 2014 12:56:31 -0800
Message-Id: <1416344191-20484-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell reports that commit 3f4c9f8f0a20 ("ARM: 8197/1:
vfp: Fix VFPv3 hwcap detection on CPUID based cpus") introduced an
unused variable warning.

arch/arm/vfp/vfpmodule.c: In function 'vfp_init':
arch/arm/vfp/vfpmodule.c:725:6: warning: unused variable 'mvfr0'
[-Wunused-variable]
  u32 mvfr0;

Silence this warning by using IS_ENABLED instead of ifdefs.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

If you apply and use git show -b you can see that most of the diff
is indentation.

 arch/arm/vfp/vfpmodule.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 5002d002f6e3..216cd78f64aa 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -752,30 +752,30 @@ static int __init vfp_init(void)
 		 * precision floating point operations. Only check
 		 * for NEON if the hardware has the MVFR registers.
 		 */
-#ifdef CONFIG_NEON
-		if ((fmrx(MVFR1) & 0x000fff00) == 0x00011100)
+		if (IS_ENABLED(CONFIG_NEON) &&
+		   (fmrx(MVFR1) & 0x000fff00) == 0x00011100)
 			elf_hwcap |= HWCAP_NEON;
-#endif
-#ifdef CONFIG_VFPv3
-		mvfr0 = fmrx(MVFR0);
-		if (((mvfr0 & MVFR0_DP_MASK) >> MVFR0_DP_BIT) == 0x2 ||
-		    ((mvfr0 & MVFR0_SP_MASK) >> MVFR0_SP_BIT) == 0x2) {
-			elf_hwcap |= HWCAP_VFPv3;
-			/*
-			 * Check for VFPv3 D16 and VFPv4 D16.  CPUs in
-			 * this configuration only have 16 x 64bit
-			 * registers.
-			 */
-			if ((mvfr0 & MVFR0_A_SIMD_MASK) == 1)
-				/* also v4-D16 */
-				elf_hwcap |= HWCAP_VFPv3D16;
-			else
-				elf_hwcap |= HWCAP_VFPD32;
-		}
 
-		if ((fmrx(MVFR1) & 0xf0000000) == 0x10000000)
-			elf_hwcap |= HWCAP_VFPv4;
-#endif
+		if (IS_ENABLED(CONFIG_VFPv3)) {
+			mvfr0 = fmrx(MVFR0);
+			if (((mvfr0 & MVFR0_DP_MASK) >> MVFR0_DP_BIT) == 0x2 ||
+			    ((mvfr0 & MVFR0_SP_MASK) >> MVFR0_SP_BIT) == 0x2) {
+				elf_hwcap |= HWCAP_VFPv3;
+				/*
+				 * Check for VFPv3 D16 and VFPv4 D16.  CPUs in
+				 * this configuration only have 16 x 64bit
+				 * registers.
+				 */
+				if ((mvfr0 & MVFR0_A_SIMD_MASK) == 1)
+					/* also v4-D16 */
+					elf_hwcap |= HWCAP_VFPv3D16;
+				else
+					elf_hwcap |= HWCAP_VFPD32;
+			}
+
+			if ((fmrx(MVFR1) & 0xf0000000) == 0x10000000)
+				elf_hwcap |= HWCAP_VFPv4;
+		}
 	/* Extract the architecture version on pre-cpuid scheme */
 	} else {
 		if (vfpsid & FPSID_NODOUBLE) {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

