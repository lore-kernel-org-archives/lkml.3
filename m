Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbaHZOSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:18:49 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38843 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667AbaHZOSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:18:13 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-12-53fc97215a6d
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v4 6/7] ARM: EXYNOS: Add support for non-secure L2X0 resume
Date: Tue, 26 Aug 2014 16:17:59 +0200
Message-id: <1409062680-15906-7-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
In-reply-to: <1409062680-15906-1-git-send-email-t.figa@samsung.com>
References: <1409062680-15906-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xK7qK0/8EG2z8ymvxaP5jZoveBVfZ
	LLZ3zmC3mPJnOZPFpsfXWC0u75rDZjF7ST+LxYzz+5gsbl/mtTi3fQuLxdojd9ktXvetYbZY
	P+M1i8WqXX8YLfZf8XLg92hp7mHz+PZ1EovH5b5eJo9F37M8ds66y+5x59oeNo/NS+o9+ras
	YvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGWevvmIvWCFe8eHdLvYGxn3CXYwcHBICJhKX
	vgd1MXICmWISF+6tZ+ti5OIQEljKKLF300YWCKePSWLJ5yVMIFVsAmoSnxsesYHYIgKqEp/b
	FrCD2MwCB5gl2lcGgNjCAt4Sfz90MIPYLEA1hz79BqvhFXCS+HphASPENjmJVRv3gc3kFHCW
	2POlD6xeCKjmyf597BMYeRcwMqxiFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAnnrzsYlx6z
	OsQowMGoxMP7IO13sBBrYllxZe4hRgkOZiUR3h9Jf4KFeFMSK6tSi/Lji0pzUosPMTJxcEo1
	MHbaK/VdnJF+4YNlS9j54oSYYsPLXz8ZLK3rcQyY/4tnT+m6gAft33OXTqmxrF+4r3RtaWuZ
	3mNTlQ3fliat+RhrOC9fSMPKZ8+ygKl8TyoDTv3zku/Zod+c1v3uirzznRQ1PiFLns9GS4/f
	0Vze1j7t6bwF259VnjxtKKDpzHzx1qfPMxaduKDEUpyRaKjFXFScCAA5HtbBRQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Exynos SoCs it is necessary to resume operation of L2C early in
assembly code, because otherwise certain systems will crash. This patch
adds necessary code to non-secure resume handler.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/common.h   |  1 +
 arch/arm/mach-exynos/firmware.c |  4 +++-
 arch/arm/mach-exynos/sleep.S    | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index c218200..e88c0f9 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -113,6 +113,7 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
 
 extern u32 cp15_save_diag;
 extern u32 cp15_save_power;
+extern unsigned long l2x0_regs_phys;
 
 extern void __iomem *sysram_ns_base_addr;
 extern void __iomem *sysram_base_addr;
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 554b350..71bcfbd 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -102,7 +102,9 @@ static int exynos_suspend(void)
 	writel(EXYNOS_SLEEP_MAGIC, sysram_ns_base_addr + EXYNOS_BOOT_FLAG);
 	writel(virt_to_phys(exynos_cpu_resume_ns),
 		sysram_ns_base_addr + EXYNOS_BOOT_ADDR);
-
+#ifdef CONFIG_CACHE_L2X0
+	l2x0_regs_phys = virt_to_phys(&l2x0_saved_regs);
+#endif
 	return cpu_suspend(0, exynos_cpu_suspend);
 }
 
diff --git a/arch/arm/mach-exynos/sleep.S b/arch/arm/mach-exynos/sleep.S
index e3c3730..b8ce8f0 100644
--- a/arch/arm/mach-exynos/sleep.S
+++ b/arch/arm/mach-exynos/sleep.S
@@ -16,6 +16,8 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include <asm/hardware/cache-l2x0.h>
 #include "smc.h"
 
 #define CPU_MASK	0xff0ffff0
@@ -74,6 +76,40 @@ ENTRY(exynos_cpu_resume_ns)
 	mov	r0, #SMC_CMD_C15RESUME
 	dsb
 	smc	#0
+#ifdef CONFIG_CACHE_L2X0
+	adr	r0, l2x0_regs_phys
+	ldr	r0, [r0]
+	cmp	r0, #0
+	beq	skip_l2x0
+
+	ldr	r1, [r0, #L2X0_R_PHY_BASE]
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
+	adr	r0, l2x0_regs_phys
+	ldr	r0, [r0]
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
@@ -83,3 +119,8 @@ cp15_save_diag:
 	.globl cp15_save_power
 cp15_save_power:
 	.long	0	@ cp15 power control
+#ifdef CONFIG_CACHE_L2X0
+	.globl l2x0_regs_phys
+l2x0_regs_phys:
+	.long	0	@ phys address of l2x0 save struct
+#endif /* CONFIG_CACHE_L2X0 */
-- 
2.0.4

