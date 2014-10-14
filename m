Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaJNNtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:49:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39822 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbaJNNtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:49:04 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Rob Clark <robdclark@gmail.com>
Subject: [PATCH v2 2/3] ARM: vfp: Fix VFPv3 hwcap detection on CPUID based cpus
Date: Tue, 14 Oct 2014 06:48:58 -0700
Message-Id: <1413294539-22069-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1413294539-22069-1-git-send-email-sboyd@codeaurora.org>
References: <1413294539-22069-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subarchitecture field in the fpsid register is 7 bits wide on
ARM CPUs using the CPUID identification scheme, spanning bits 22
to 16. The topmost bit is used to designate that the
subarchitecture designer is not ARM when it is set to 1. On
non-CPUID scheme CPUs the subarchitecture field is only 4 bits
wide and the higher bits are used to indicate no double precision
support (bit 20) and the FTSMX/FLDMX format (bits 21-22).

The VFP support code only looks at bits 19-16 to determine the
VFP version. On Qualcomm's processors (Krait and Scorpion) we
should see that we have HWCAP_VFPv3 but we don't because bit 22
is set to 1 to indicate that the subarchitecture is not
implemented by ARM and the rest of the bits are left as 0 because
this is the first subarchitecture that Qualcomm has designed.
Unfortunately we can't just widen the FPSID subarchitecture
bitmask to consider all the bits on a CPUID scheme because there
may be CPUs without the CPUID scheme that have VFP without double
precision support and then the version would be a very wrong and
large number. Instead, update the version detection logic to
consider if the CPU is using the CPUID scheme.

If the CPU is using CPUID scheme, use the MVFR registers to
determine what version of VFP is supported. We already do this
for VFPv4, so do something similar for VFPv3 and look for single
or double precision support in MVFR0. Otherwise fall back to
using FPSID to detect VFP suppport on non-CPUID scheme CPUs. We
know that VFPv3 is only present in CPUs that have support for the
CPUID scheme so this should be equivalent.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/include/asm/vfp.h |  5 +++
 arch/arm/vfp/vfpmodule.c   | 93 ++++++++++++++++++++++++++--------------------
 2 files changed, 57 insertions(+), 41 deletions(-)

diff --git a/arch/arm/include/asm/vfp.h b/arch/arm/include/asm/vfp.h
index f4ab34fd4f72..ee5f3084243c 100644
--- a/arch/arm/include/asm/vfp.h
+++ b/arch/arm/include/asm/vfp.h
@@ -22,6 +22,7 @@
 #define FPSID_NODOUBLE		(1<<20)
 #define FPSID_ARCH_BIT		(16)
 #define FPSID_ARCH_MASK		(0xF  << FPSID_ARCH_BIT)
+#define FPSID_CPUID_ARCH_MASK	(0x7F  << FPSID_ARCH_BIT)
 #define FPSID_PART_BIT		(8)
 #define FPSID_PART_MASK		(0xFF << FPSID_PART_BIT)
 #define FPSID_VARIANT_BIT	(4)
@@ -75,6 +76,10 @@
 /* MVFR0 bits */
 #define MVFR0_A_SIMD_BIT	(0)
 #define MVFR0_A_SIMD_MASK	(0xf << MVFR0_A_SIMD_BIT)
+#define MVFR0_SP_BIT		(4)
+#define MVFR0_SP_MASK		(0xf << MVFR0_SP_BIT)
+#define MVFR0_DP_BIT		(8)
+#define MVFR0_DP_MASK		(0xf << MVFR0_DP_BIT)
 
 /* Bit patterns for decoding the packaged operation descriptors */
 #define VFPOPDESC_LENGTH_BIT	(9)
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 2f37e1d6cb45..f901242dee98 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -722,6 +722,7 @@ static int __init vfp_init(void)
 {
 	unsigned int vfpsid;
 	unsigned int cpu_arch = cpu_architecture();
+	u32 mvfr0;
 
 	if (cpu_arch >= CPU_ARCH_ARMv6)
 		on_each_cpu(vfp_enable, NULL, 1);
@@ -738,63 +739,73 @@ static int __init vfp_init(void)
 	vfp_vector = vfp_null_entry;
 
 	pr_info("VFP support v0.3: ");
-	if (VFP_arch)
+	if (VFP_arch) {
 		pr_cont("not present\n");
-	else if (vfpsid & FPSID_NODOUBLE) {
-		pr_cont("no double precision support\n");
-	} else {
-		hotcpu_notifier(vfp_hotplug, 0);
-
-		VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;  /* Extract the architecture version */
-		pr_cont("implementor %02x architecture %d part %02x variant %x rev %x\n",
-			(vfpsid & FPSID_IMPLEMENTER_MASK) >> FPSID_IMPLEMENTER_BIT,
-			(vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT,
-			(vfpsid & FPSID_PART_MASK) >> FPSID_PART_BIT,
-			(vfpsid & FPSID_VARIANT_MASK) >> FPSID_VARIANT_BIT,
-			(vfpsid & FPSID_REV_MASK) >> FPSID_REV_BIT);
-
-		vfp_vector = vfp_support_entry;
-
-		thread_register_notifier(&vfp_notifier_block);
-		vfp_pm_init();
-
+		return 0;
+	/* Extract the arhitecture on CPUID scheme */
+	} else if ((read_cpuid_id() & 0x000f0000) == 0x000f0000) {
+		VFP_arch = vfpsid & FPSID_CPUID_ARCH_MASK;
+		VFP_arch >>= FPSID_ARCH_BIT;
 		/*
-		 * We detected VFP, and the support code is
-		 * in place; report VFP support to userspace.
+		 * Check for the presence of the Advanced SIMD
+		 * load/store instructions, integer and single
+		 * precision floating point operations. Only check
+		 * for NEON if the hardware has the MVFR registers.
 		 */
-		elf_hwcap |= HWCAP_VFP;
+#ifdef CONFIG_NEON
+		if ((fmrx(MVFR1) & 0x000fff00) == 0x00011100)
+			elf_hwcap |= HWCAP_NEON;
+#endif
 #ifdef CONFIG_VFPv3
-		if (VFP_arch >= 2) {
+		mvfr0 = fmrx(MVFR0);
+		if (((mvfr0 & MVFR0_DP_MASK) >> MVFR0_DP_BIT) == 0x2 ||
+		    ((mvfr0 & MVFR0_SP_MASK) >> MVFR0_SP_BIT) == 0x2) {
 			elf_hwcap |= HWCAP_VFPv3;
-
 			/*
 			 * Check for VFPv3 D16 and VFPv4 D16.  CPUs in
 			 * this configuration only have 16 x 64bit
 			 * registers.
 			 */
-			if (((fmrx(MVFR0) & MVFR0_A_SIMD_MASK)) == 1)
-				elf_hwcap |= HWCAP_VFPv3D16; /* also v4-D16 */
+			if ((mvfr0 & MVFR0_A_SIMD_MASK) == 1)
+				/* also v4-D16 */
+				elf_hwcap |= HWCAP_VFPv3D16;
 			else
 				elf_hwcap |= HWCAP_VFPD32;
 		}
+
+		if ((fmrx(MVFR1) & 0xf0000000) == 0x10000000)
+			elf_hwcap |= HWCAP_VFPv4;
 #endif
-		/*
-		 * Check for the presence of the Advanced SIMD
-		 * load/store instructions, integer and single
-		 * precision floating point operations. Only check
-		 * for NEON if the hardware has the MVFR registers.
-		 */
-		if ((read_cpuid_id() & 0x000f0000) == 0x000f0000) {
-#ifdef CONFIG_NEON
-			if ((fmrx(MVFR1) & 0x000fff00) == 0x00011100)
-				elf_hwcap |= HWCAP_NEON;
-#endif
-#ifdef CONFIG_VFPv3
-			if ((fmrx(MVFR1) & 0xf0000000) == 0x10000000)
-				elf_hwcap |= HWCAP_VFPv4;
-#endif
+	/* Extract the architecture version on pre-cpuid scheme */
+	} else {
+		if (vfpsid & FPSID_NODOUBLE) {
+			pr_cont("no double precision support\n");
+			return 0;
 		}
+
+		VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;
 	}
+
+	hotcpu_notifier(vfp_hotplug, 0);
+
+	vfp_vector = vfp_support_entry;
+
+	thread_register_notifier(&vfp_notifier_block);
+	vfp_pm_init();
+
+	/*
+	 * We detected VFP, and the support code is
+	 * in place; report VFP support to userspace.
+	 */
+	elf_hwcap |= HWCAP_VFP;
+
+	pr_cont("implementor %02x architecture %d part %02x variant %x rev %x\n",
+		(vfpsid & FPSID_IMPLEMENTER_MASK) >> FPSID_IMPLEMENTER_BIT,
+		VFP_arch,
+		(vfpsid & FPSID_PART_MASK) >> FPSID_PART_BIT,
+		(vfpsid & FPSID_VARIANT_MASK) >> FPSID_VARIANT_BIT,
+		(vfpsid & FPSID_REV_MASK) >> FPSID_REV_BIT);
+
 	return 0;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

