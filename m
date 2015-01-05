Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbbAEMUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:20:02 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44322 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbbAEMTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:19:24 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-11-54aa814ab0bc
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
Subject: [PATCH v11 8/9] ARM: EXYNOS: Add support for non-secure L2X0 resume
Date: Mon, 05 Jan 2015 13:19:07 +0100
Message-id: <1420460348-20302-9-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xK7pejatCDDb8lbP4O+kYu8Wj+Y+Z
	LXoXXGWz+Hp4BaPF2aY37BbbO2ewW0z5s5zJYtPja6wWl3fNYbOYvaSfxWLG+X1MFrcv81qc
	276FxWLtkbvsFkuvX2SyePPjLJPFqeuf2SxW7frDaLH/ipeDsMeaeWsYPVqae9g8fv+axOjx
	7eskFo/Lfb1MHou+Z3nsnHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx/Eb25k8Pm+SC+CN4rJJ
	Sc3JLEst0rdL4Mro/65WMEWw4syq1ywNjP95uxg5OSQETCQWPepnhbDFJC7cW8/WxcjFISSw
	lFFi7/9XzBBOH5NE/9uDTCBVbAKGEl1vu9hAbBEBN4l/6w6BdTALTGOR2HTkPDNIQljAR2JV
	83Mwm0VAVeLVnAWMIDavgIfE7nXX2CHWyUn8f7kCbCingKfE0r37wOJCQDVnbq1ln8DIu4CR
	YRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSFx82cG4+JjVIUYBDkYlHl6PEytDhFgTy4or
	cw8xSnAwK4nwvkpfFSLEm5JYWZValB9fVJqTWnyIkYmDU6qB0SeuMT74p/YUibz9u259nP87
	/5rATmMGkYfLpA6K+nrm37Hnuz/v74tLB2yWlcZ0LX8bOG/HzD3KopU3fn/71mQoflS/7WBW
	lerd0xMzOTMebS97OS2UP+ry0/3Lc2dm1sjXSfrxzkq2kZl0ovXYuYV+j0X2FWzkqwmJOWVp
	855Dd+GXuDtCa5RYijMSDbWYi4oTAY9ovQZpAgAA
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

