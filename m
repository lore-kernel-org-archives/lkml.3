Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbaIRVoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:44:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36122 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaIRVnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:43:17 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 2/3] ARM: vfp: fix VFPv3 hwcap detection on non-ARM vfp implementations
Date: Thu, 18 Sep 2014 14:43:11 -0700
Message-Id: <1411076592-6157-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
References: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subarchitecture field in the fpsid register is 7 bits wide.
The topmost bit is used to designate that the subarchitecture
designer is not ARM. We use this field to determine which VFP
version is supported by the CPU. Since the topmost bit is ignored
with the current mask we detect non-ARM subarchitectures as
supporting only HWCAP_VFP. In Qualcomm's processors (Krait and
Scorpion) it should see that we have HWCAP_VFPv3 but it doesn't.

Use the proper width for the mask and then check to see if the
implementor is 0x51 (Qualcomm). If so, indicate that the vfp
architecture is compatible with VFPv3 architecture or later with
common VFP subarchitecture v3.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/include/asm/cputype.h | 1 +
 arch/arm/include/asm/vfp.h     | 2 +-
 arch/arm/vfp/vfpmodule.c       | 7 +++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
index 8c2b7321a478..a8329a5fd9b1 100644
--- a/arch/arm/include/asm/cputype.h
+++ b/arch/arm/include/asm/cputype.h
@@ -60,6 +60,7 @@
 	((mpidr >> (MPIDR_LEVEL_BITS * level)) & MPIDR_LEVEL_MASK)
 
 #define ARM_CPU_IMP_ARM			0x41
+#define ARM_CPU_IMP_QCOM		0x51
 #define ARM_CPU_IMP_INTEL		0x69
 
 #define ARM_CPU_PART_ARM1136		0xB360
diff --git a/arch/arm/include/asm/vfp.h b/arch/arm/include/asm/vfp.h
index f4ab34fd4f72..76d3f6907cce 100644
--- a/arch/arm/include/asm/vfp.h
+++ b/arch/arm/include/asm/vfp.h
@@ -21,7 +21,7 @@
 #define FPSID_FORMAT_MASK	(0x3  << FPSID_FORMAT_BIT)
 #define FPSID_NODOUBLE		(1<<20)
 #define FPSID_ARCH_BIT		(16)
-#define FPSID_ARCH_MASK		(0xF  << FPSID_ARCH_BIT)
+#define FPSID_ARCH_MASK		(0x7F  << FPSID_ARCH_BIT)
 #define FPSID_PART_BIT		(8)
 #define FPSID_PART_MASK		(0xFF << FPSID_PART_BIT)
 #define FPSID_VARIANT_BIT	(4)
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 2f37e1d6cb45..e6bd8d99e916 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -746,6 +746,13 @@ static int __init vfp_init(void)
 		hotcpu_notifier(vfp_hotplug, 0);
 
 		VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;  /* Extract the architecture version */
+
+		/*
+		 * Qualcomm implementations are VFPv3 architecture or later
+		 * with common VFP subarchitecture v3
+		 */
+		if (ARM_CPU_IMP_QCOM == ((vfpsid & FPSID_IMPLEMENTER_MASK) >> FPSID_IMPLEMENTER_BIT))
+			VFP_arch = 4;
 		pr_cont("implementor %02x architecture %d part %02x variant %x rev %x\n",
 			(vfpsid & FPSID_IMPLEMENTER_MASK) >> FPSID_IMPLEMENTER_BIT,
 			(vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

