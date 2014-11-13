Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbaKMNSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:18:33 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27097 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbaKMNS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:18:27 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-d8-5464afa10e14
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org, tony@atomide.com,
        drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v8 6/7] ARM: EXYNOS: Add support for non-secure L2X0 resume
Date: Thu, 13 Nov 2014 14:18:13 +0100
Message-id: <1415884694-5868-7-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
References: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xy7oL16eEGDy/zWbxd9IxdotH8x8z
	W/QuuMpmcbbpDbvF9s4Z7BZT/ixnstj0+BqrxeVdc9gsZi/pZ7GYcX4fk8Xty7wW57ZvYbFY
	e+Quu8XS6xeZLE5d/8xmsWrXH0aL/Ve8HAQ91sxbw+jR0tzD5vH71yRGj29fJ7F4XO7rZfJY
	9D3LY+esu+wed67tYfPYvKTe48qJJlaPvi2rGD0+b5IL4InisklJzcksSy3St0vgynh//xdz
	wV6Bigsn7jM1MG7i7WLk5JAQMJHo+7SEFcIWk7hwbz1bFyMXh5DAUkaJrRNWMEE4fUwSTxs2
	MYFUsQkYSnS97WIDsUUE3CT+rTsE1sEs8JlZ4tKjNWCjhAW8JWZ87WYGsVkEVCVeTP0D1sAr
	4C6x4sAkZoh1chL/X64AG8op4CHxZf0fsF4hoJr2XYcZJzDyLmBkWMUomlqaXFCclJ5rqFec
	mFtcmpeul5yfu4kREvpfdjAuPmZ1iFGAg1GJh/cDd0qIEGtiWXFl7iFGCQ5mJRHeNyuBQrwp
	iZVVqUX58UWlOanFhxiZODilGhjnF1kdj9g94/WnrttcS+ZPsF/w9cDV88tmXtV/dftawP6M
	5HvOZr5ydVwFxjx8XeUPjt9Z+v3bV8elJ91WOF8QvVniz7T16nWjOVsTlxkqOzFN1rvXIdx/
	7JXEsTCtea4Op96p7eDp+/tOt255UVTYdMHfOws8DH6z7uMz1lm/eobzXC6vvzJhSizFGYmG
	WsxFxYkAd9QhBFsCAAA=
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

