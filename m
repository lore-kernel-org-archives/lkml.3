Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaKQLtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:49:50 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26275 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaKQLsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:48:43 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-34-5469e0974d6b
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
Subject: [PATCH v9 6/7] ARM: EXYNOS: Add support for non-secure L2X0 resume
Date: Mon, 17 Nov 2014 12:48:28 +0100
Message-id: <1416224909-4290-7-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1416224909-4290-1-git-send-email-m.szyprowski@samsung.com>
References: <1416224909-4290-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xK7rTH2SGGDRtULT4O+kYu8Wj+Y+Z
	LXoXXGWzONv0ht1ie+cMdospf5YzWWx6fI3V4vKuOWwWs5f0s1jMOL+PyeL2ZV6Lc9u3sFis
	PXKX3WLp9YtMFqeuf2azWLXrD6PF/iteDoIea+atYfRoae5h8/j9axKjx7evk1g8Lvf1Mnks
	+p7lsXPWXXaPO9f2sHlsXlLvceVEE6tH35ZVjB6fN8kF8ERx2aSk5mSWpRbp2yVwZSz78ZW9
	oEOionvCLNYGxlaRLkZODgkBE4nnDSfZIGwxiQv31gPZXBxCAksZJZpWr2OCcPqYJE4f+sUK
	UsUmYCjR9bYLrENEwE3i37pDYB3MAp+ZJS49WgNWJCzgLXHi12RGEJtFQFXiedNRsDivgLvE
	lo+boNbJSfx/uYIJxOYU8JD49v0AUJwDaJu7ROsjzgmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YW
	l+al6yXn525ihAT+1x2MS49ZHWIU4GBU4uE9UJQZIsSaWFZcmXuIUYKDWUmEN+YiUIg3JbGy
	KrUoP76oNCe1+BAjEwenVAOj4OPWWl6hGQmNZheWbc44aai39I+ooui/ABapj911c8+dv7vP
	8mxGNZ+4T80kD9+fDi9Xvm8uOTdTue3JwVw9FdZTt242pb3nnbWzovpCx6Jnixm25UqVLRLI
	l9BcvUH6UGTZKbnKxQ7TPnUp9N5Zpi3mX5ZftX+J0xt3y4De1XKlM725jAWUWIozEg21mIuK
	EwHZpXtNWgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

On Exynos SoCs it is necessary to resume operation of L2C early in
assembly code, because otherwise certain systems will crash. This patch
adds necessary code to non-secure resume handler.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
[rewrote the code accessing l2x0_saved_regs, rebased onto v3.18-rc3]
Sigend-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-exynos/Makefile |  1 +
 arch/arm/mach-exynos/sleep.S  | 48 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/smc.h    |  4 ++++
 3 files changed, 53 insertions(+)

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 27ae6144679c..45bef21a3b66 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -21,6 +21,7 @@ CFLAGS_hotplug.o		+= -march=armv7-a
 
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
+AFLAGS_sleep.o			:=-Wa,-march=armv7-a$(plus_sec)
 
 obj-$(CONFIG_EXYNOS5420_MCPM)	+= mcpm-exynos.o
 CFLAGS_mcpm-exynos.o		+= -march=armv7-a
diff --git a/arch/arm/mach-exynos/sleep.S b/arch/arm/mach-exynos/sleep.S
index 108a45f4bb62..5aa6b4de9274 100644
--- a/arch/arm/mach-exynos/sleep.S
+++ b/arch/arm/mach-exynos/sleep.S
@@ -16,6 +16,9 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include <asm/hardware/cache-l2x0.h>
+#include "smc.h"
 
 #define CPU_MASK	0xff0ffff0
 #define CPU_CORTEX_A9	0x410fc090
@@ -55,3 +58,48 @@ ENTRY(exynos_cpu_resume)
 #endif
 	b	cpu_resume
 ENDPROC(exynos_cpu_resume)
+
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
+
+#ifdef CONFIG_CACHE_L2X0
+	.align
+1:	.long	l2x0_saved_regs - .
+#endif /* CONFIG_CACHE_L2X0 */
diff --git a/arch/arm/mach-exynos/smc.h b/arch/arm/mach-exynos/smc.h
index 13a1dc8ecbf2..f7b82f9c1e21 100644
--- a/arch/arm/mach-exynos/smc.h
+++ b/arch/arm/mach-exynos/smc.h
@@ -26,6 +26,10 @@
 #define SMC_CMD_L2X0INVALL	(-24)
 #define SMC_CMD_L2X0DEBUG	(-25)
 
+#ifndef __ASSEMBLY__
+
 extern void exynos_smc(u32 cmd, u32 arg1, u32 arg2, u32 arg3);
 
+#endif /* __ASSEMBLY__ */
+
 #endif
-- 
1.9.2

