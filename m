Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998AbaGQQj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:39:58 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64283 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934646AbaGQQjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:39:55 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c8-53c7fc58b201
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, santosh.shilimkar@ti.com, tony@atomide.com,
        drake@endlessm.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 6/7] ARM: EXYNOS: Add support for non-secure L2X0 resume
Date: Thu, 17 Jul 2014 18:39:01 +0200
Message-id: <1405615142-21426-7-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1405615142-21426-1-git-send-email-t.figa@samsung.com>
References: <1405615142-21426-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xq7oRf44HG6zZLWDxaP5jZoveBVfZ
	LLZ3zmC3mPJnOZPFpsfXWC0u75rDZjF7ST+LxYzz+5gsbl/mtTi3fQuLxdojd9ktXvetYbZY
	P+M1i8WqXX8YLfZf8XLg92hp7mHz+PZ1EovH5b5eJo9F37M8ds66y+5x59oeNo/NS+o9+ras
	YvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGX3PXzIXrBerOPqxk7GB8YJQFyMnh4SAicSP
	X0eZIGwxiQv31rN1MXJxCAksZZRYO+kvK4TTxyQx+XMfG0gVm4CaxOeGR2C2iICqxOe2Bewg
	RcwCB5glLmx6wAKSEBbwltiw4TlYEQtQ0YTue2BxXgEnieur2pgh1slJ9G57A2ZzCjhLzN3/
	GKxeCKhmS9sCpgmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihIT0lx2Mi49ZHWIU
	4GBU4uHt/HwsWIg1say4MvcQowQHs5IIb/b948FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGEXd
	P59ZcqZ2Tzh/392nRj7LLnvVPtv6WuR5jw9T9NlFr69/s9nW6lgtcJS/d+WjpKnqbpOV+5qm
	7b1WrVrLvfXlAuuz26/xhnDFdM/zWCz7oe3bzobDpzW2X3nDGL44q0Xqc+hnE9dJh9O/vk+T
	vHJw5jLmDewWBZyRmeGVzDMY5txftyt1S6wSS3FGoqEWc1FxIgAFMjiSRwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Exynos SoCs it is necessary to resume operation of L2C early in
assembly code, because otherwise certain systems will crash. This patch
adds necessary code to non-secure resume handler.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/common.h   |  1 +
 arch/arm/mach-exynos/firmware.c |  2 ++
 arch/arm/mach-exynos/sleep.S    | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index a3f3061..2540827 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -113,6 +113,7 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
 
 extern u32 cp15_save_diag;
 extern u32 cp15_save_power;
+extern unsigned long l2x0_regs_phys;
 
 extern void __iomem *sysram_ns_base_addr;
 extern void __iomem *sysram_base_addr;
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 554b350..09131d3 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -103,6 +103,8 @@ static int exynos_suspend(void)
 	writel(virt_to_phys(exynos_cpu_resume_ns),
 		sysram_ns_base_addr + EXYNOS_BOOT_ADDR);
 
+	l2x0_regs_phys = virt_to_phys(&l2x0_saved_regs);
+
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
1.9.3

