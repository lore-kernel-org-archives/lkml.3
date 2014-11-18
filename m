Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaKRS5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:57:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43270 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbaKRS52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:57:28 -0500
Message-ID: <546B9696.4030703@codeaurora.org>
Date: Tue, 18 Nov 2014 10:57:26 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King <linux@arm.linux.org.uk>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Rob Clark <robdclark@gmail.com>
Subject: Re: linux-next: build warning after merge of the arm tree
References: <20141118192507.39f68bb7@canb.auug.org.au>
In-Reply-To: <20141118192507.39f68bb7@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 12:25 AM, Stephen Rothwell wrote:
> Hi Russell,
>
> After merging the arm tree, today's linux-next build (arm defconfig)
> produced this warning:
>
> arch/arm/vfp/vfpmodule.c: In function 'vfp_init':
> arch/arm/vfp/vfpmodule.c:725:6: warning: unused variable 'mvfr0' [-Wunused-variable]
>   u32 mvfr0;
>       ^
>
> Introduced by commit 3f4c9f8f0a20 ("ARM: 8197/1: vfp: Fix VFPv3 hwcap
> detection on CPUID based cpus").
>

Urgh, I thought I fixed that but I guess I only took care of not
assigning it unless we actually need it. Well we can do the #ifdef
thing, or move to IS_ENABLED. Here's both options.

---8<----

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



or

---8<----

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 5002d002f6e3..19a9338117bd 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -722,7 +722,9 @@ static int __init vfp_init(void)
 {
 	unsigned int vfpsid;
 	unsigned int cpu_arch = cpu_architecture();
+#ifdef CONFIG_VFPv3
 	u32 mvfr0;
+#endif
 
 	if (cpu_arch >= CPU_ARCH_ARMv6)
 		on_each_cpu(vfp_enable, NULL, 1);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

