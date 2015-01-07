Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbbAGLbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:31:12 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10344 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbbAGLai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:30:38 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-f0-54ad18dc77b1
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
Subject: [PATCH v12 7/9] ARM: EXYNOS: Add .write_sec outer cache callback for
 L2C-310
Date: Wed, 07 Jan 2015 12:30:22 +0100
Message-id: <1420630224-8887-8-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1420630224-8887-1-git-send-email-m.szyprowski@samsung.com>
References: <1420630224-8887-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xq7p3JNaGGHw7pGnxd9IxdotH8x8z
	W/QuuMpm8fXwCkaLs01v2C22d85gt5jyZzmTxabH11gtLu+aw2Yxe0k/i8WM8/uYLG5f5rU4
	t30Li8XaI3fZLZZev8hk8ebHWSaLU9c/s1ms2vWH0WL/FS8HYY8189YwerQ097B5/P41idHj
	29dJLB6X+3qZPBZ9z/LYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj+M3tjN5fN4kF8AbxWWT
	kpqTWZZapG+XwJXRuFOlYK94RdOC1ewNjOuEuxg5OSQETCS2vHjECmGLSVy4t56ti5GLQ0hg
	KaNEz45+dginj0nifOcnFpAqNgFDia63XWwgtoiAm8S/dYfAOpgFprFIbDpynhkkISwQLnF8
	5mR2EJtFQFViUf9NsBW8Au4SO862MUKsk5P4/3IFE4jNKeAhcef8MjBbCKhmwcSVbBMYeRcw
	MqxiFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECImLrzsYlx6zOsQowMGoxMOrMHlNiBBrYllx
	Ze4hRgkOZiUR3je/gEK8KYmVValF+fFFpTmpxYcYmTg4pRoYt/g17g9afCJj6eaozo4HK/k6
	JBz2l32sX59et+v3trQf24V2XBP7VtW11/J/d5/WfF/lsg0/94oe5/n+XtlMWH4235PlmewB
	78J41k5Nunsg/B/XJeGVszwyWo7NaVG5uivvtuXPtxFJrk4pX0InB+7gPKa8VO3rNoO1vh8E
	grUFu7Ofdzt/UWIpzkg01GIuKk4EAM7M9ztpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Exynos4 SoCs equipped with an L2C-310 cache controller and running under
secure firmware require certain registers of aforementioned IP to be
accessed only from secure mode. This means that SMC calls are required
for certain register writes. To handle this, an implementation of
.write_sec and .configure callbacks is provided by this patch.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
[added comment and reworked unconditional call to SMC_CMD_L2X0INVALL]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-exynos/firmware.c | 50 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 766f57d2f029..4791a3cc00f9 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -17,6 +17,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/firmware.h>
+#include <asm/hardware/cache-l2x0.h>
 #include <asm/suspend.h>
 
 #include <mach/map.h>
@@ -136,6 +137,43 @@ static const struct firmware_ops exynos_firmware_ops = {
 	.resume			= IS_ENABLED(CONFIG_EXYNOS_CPU_SUSPEND) ? exynos_resume : NULL,
 };
 
+static void exynos_l2_write_sec(unsigned long val, unsigned reg)
+{
+	static int l2cache_enabled;
+
+	switch (reg) {
+	case L2X0_CTRL:
+		if (val & L2X0_CTRL_EN) {
+			/*
+			 * Before the cache can be enabled, due to firmware
+			 * design, SMC_CMD_L2X0INVALL must be called.
+			 */
+			if (!l2cache_enabled) {
+				exynos_smc(SMC_CMD_L2X0INVALL, 0, 0, 0);
+				l2cache_enabled = 1;
+			}
+		} else {
+			l2cache_enabled = 0;
+		}
+		exynos_smc(SMC_CMD_L2X0CTRL, val, 0, 0);
+		break;
+
+	case L2X0_DEBUG_CTRL:
+		exynos_smc(SMC_CMD_L2X0DEBUG, val, 0, 0);
+		break;
+
+	default:
+		WARN_ONCE(1, "%s: ignoring write to reg 0x%x\n", __func__, reg);
+	}
+}
+
+static void exynos_l2_configure(const struct l2x0_regs *regs)
+{
+	exynos_smc(SMC_CMD_L2X0SETUP1, regs->tag_latency, regs->data_latency,
+		   regs->prefetch_ctrl);
+	exynos_smc(SMC_CMD_L2X0SETUP2, regs->pwr_ctrl, regs->aux_ctrl, 0);
+}
+
 void __init exynos_firmware_init(void)
 {
 	struct device_node *nd;
@@ -155,4 +193,16 @@ void __init exynos_firmware_init(void)
 	pr_info("Running under secure firmware.\n");
 
 	register_firmware_ops(&exynos_firmware_ops);
+
+	/*
+	 * Exynos 4 SoCs (based on Cortex A9 and equipped with L2C-310),
+	 * running under secure firmware, require certain registers of L2
+	 * cache controller to be written in secure mode. Here .write_sec
+	 * callback is provided to perform necessary SMC calls.
+	 */
+	if (IS_ENABLED(CONFIG_CACHE_L2X0) &&
+	    read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
+		outer_cache.write_sec = exynos_l2_write_sec;
+		outer_cache.configure = exynos_l2_configure;
+	}
 }
-- 
1.9.2

