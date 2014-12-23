Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbaLWKt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:49:28 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62246 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaLWKsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:48:53 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-9e-5499489108dc
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        khilman@linaro.org
Subject: [PATCH v10 7/8] ARM: EXYNOS: Add support for non-secure L2X0 resume
Date: Tue, 23 Dec 2014 11:48:35 +0100
Message-id: <1419331716-8972-8-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xa7oTPWaGGLyYwm/xd9IxdotH8x8z
	W/QuuMpm8fXwCkaLs01v2C22d85gt5jyZzmTxabH11gtLu+aw2Yxe0k/i8WM8/uYLG5f5rU4
	t30Li8XaI3fZLZZev8hk8ebHWSaLU9c/s1ms2vWH0WL/FS8HYY8189YwerQ097B5/P41idHj
	29dJLB6X+3qZPBZ9z/LYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj+M3tjN5fN4kF8AbxWWT
	kpqTWZZapG+XwJXR/12tYIpgxZlVr1kaGP/zdjFycEgImEjMf27excgJZIpJXLi3nq2LkYtD
	SGApo0TPrrtMEE4fk8S9vrMsIFVsAoYSXW+72EBsEQE3iX/rDoF1MAtMY5HYdOQ8M0hCWMBH
	4uDGyUwgNouAqsTLxnXMINt4BdwlTq7NgNgmJ/H/5QqwEk4BD4mTizaD2UJAJdueHmSZwMi7
	gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZITHzZwbj4mNUhRgEORiUe3pPvZ4QIsSaW
	FVfmHmKU4GBWEuF9KT4zRIg3JbGyKrUoP76oNCe1+BAjEwenVANj87MAB5f2w7EHk9nllrk4
	+DQL53Mc3ZnlnOTxaYnjx93XC0tqXjHah1925Z+ftdFeh7+z5G/W8dK7bldVy7xzLHmzJzto
	fGXtvVso05q6wtVYxGRJ6V2WGTXJO9uCwkwTd/N6lM/fdajsmmvzadVNIsd6m6pfmJ/k8dh2
	UfZwbPHVu9+C1ZRYijMSDbWYi4oTAS2YHJxnAgAA
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
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
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

