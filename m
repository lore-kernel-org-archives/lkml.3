Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaJ0LGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:06:11 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31377 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaJ0LGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:06:01 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-70-544e27178df5
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v6 6/7] ARM: EXYNOS: Add support for non-secure L2X0 resume
Date: Mon, 27 Oct 2014 12:05:49 +0100
Message-id: <1414407950-3029-7-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
References: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xK7ri6n4hBh/2qVk8mv+Y2aJ3wVU2
	i7NNb9gttnfOYLeY8mc5k8Wmx9dYLS7vmsNmMXtJP4vFjPP7mCxuX+a1OLd9C4vF2iN32S2W
	Xr/IZPG6bw2zxapdfxgt9l/xchDwWDNvDaNHS3MPm8e3r5NYPC739TJ5LPqe5bFz1l12jzvX
	9rB5bF5S79G3ZRWjx/Eb25k8Pm+SC+CO4rJJSc3JLEst0rdL4Mp4f/8Xc8FegYoLJ+4zNTBu
	4u1i5OSQEDCR+LN3DyuELSZx4d56ti5GLg4hgaWMEs+3drBDOH1MEtPv7WYGqWITMJToetvF
	BmKLCGRL/Pg2mQWkiFlgFbPElAPrwEYJC3hL/L+1DqiBg4NFQFXizx0OkDCvgLvEm9s/obbJ
	Sfx/uYIJxOYU8JCY3DITzBYCqln1YS/jBEbeBYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNz
	NzFCgvzLDsbFx6wOMQpwMCrx8O6Y5hsixJpYVlyZe4hRgoNZSYTX8SdQiDclsbIqtSg/vqg0
	J7X4ECMTB6dUAyOvSbz4b9Ftyufmv7iwIrorQcfCRHfZx9k7DTaf1eD+wjYvmrGjMe/UUXXO
	ix6T/xnMOlvY6bZsVcrBjW1tChfj5s9vKEvc+eKrht/xFyU7VR9/Wb1TXuvYjxThcH7ZTYyd
	7xhZ9i2v7ZVkKE49vCvt6uMM7n1rfrGn/34uZr1e/XdR+e117T1KLMUZiYZazEXFiQB168r/
	UAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

On Exynos SoCs it is necessary to resume operation of L2C early in
assembly code, because otherwise certain systems will crash. This patch
adds necessary code to non-secure resume handler.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
[rewrote the code accessing l2x0_saved_regs]
Sigend-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-exynos/sleep.S | 46 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm/mach-exynos/sleep.S b/arch/arm/mach-exynos/sleep.S
index e3c373082bbe..31d25834b9c4 100644
--- a/arch/arm/mach-exynos/sleep.S
+++ b/arch/arm/mach-exynos/sleep.S
@@ -16,6 +16,8 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include <asm/hardware/cache-l2x0.h>
 #include "smc.h"
 
 #define CPU_MASK	0xff0ffff0
@@ -74,6 +76,45 @@ ENTRY(exynos_cpu_resume_ns)
 	mov	r0, #SMC_CMD_C15RESUME
 	dsb
 	smc	#0
+#ifdef CONFIG_CACHE_L2X0
+	adr	r0, 1f
+	ldr	r2, [r0]
+	add	r0, r2, r0
+
+	/* Check that the address has been initialised. */
+	ldr	r1, [r0, #L2X0_R_PHY_BASE]
+	teq	r1, #0
+	beq	skip_l2x0
+
+	/* Check if controller has been enabled. */
+	ldr	r2, [r1, #L2X0_CTRL]
+	tst	r2, #0x1
+	bne	skip_l2x0
+
+	ldr	r1, [r0, #L2X0_R_TAG_LATENCY]
+	ldr	r2, [r0, #L2X0_R_DATA_LATENCY]
+	ldr	r3, [r0, #L2X0_R_PREFETCH_CTRL]
+	mov	r0, #SMC_CMD_L2X0SETUP1
+	smc	#0
+
+	/* Reload saved regs pointer because smc corrupts registers. */
+	adr	r0, 1f
+	ldr	r2, [r0]
+	add	r0, r2, r0
+
+	ldr	r1, [r0, #L2X0_R_PWR_CTRL]
+	ldr	r2, [r0, #L2X0_R_AUX_CTRL]
+	mov	r0, #SMC_CMD_L2X0SETUP2
+	smc	#0
+
+	mov	r0, #SMC_CMD_L2X0INVALL
+	smc	#0
+
+	mov	r1, #1
+	mov	r0, #SMC_CMD_L2X0CTRL
+	smc	#0
+skip_l2x0:
+#endif /* CONFIG_CACHE_L2X0 */
 skip_cp15:
 	b	cpu_resume
 ENDPROC(exynos_cpu_resume_ns)
@@ -83,3 +124,8 @@ cp15_save_diag:
 	.globl cp15_save_power
 cp15_save_power:
 	.long	0	@ cp15 power control
+
+#ifdef CONFIG_CACHE_L2X0
+	.align
+1:	.long	l2x0_saved_regs - .
+#endif /* CONFIG_CACHE_L2X0 */
-- 
1.9.2

