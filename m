Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaKQLuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:50:13 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26275 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaKQLsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:48:41 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-17-5469e0965977
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
Subject: [PATCH v9 5/7] ARM: EXYNOS: Add .write_sec outer cache callback for
 L2C-310
Date: Mon, 17 Nov 2014 12:48:27 +0100
Message-id: <1416224909-4290-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1416224909-4290-1-git-send-email-m.szyprowski@samsung.com>
References: <1416224909-4290-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xK7rTHmSGGHy6ZmDxd9IxdotH8x8z
	W/QuuMpmcbbpDbvF9s4Z7BZT/ixnstj0+BqrxeVdc9gsZi/pZ7GYcX4fk8Xty7wW57ZvYbFY
	e+Quu8XS6xeZLE5d/8xmsWrXH0aL/Ve8HAQ91sxbw+jR0tzD5vH71yRGj29fJ7F4XO7rZfJY
	9D3LY+esu+wed67tYfPYvKTe48qJJlaPvi2rGD0+b5IL4InisklJzcksSy3St0vgyth6Wahg
	tXjFpZmPGRsYZwp3MXJySAiYSMxZtJgFwhaTuHBvPVsXIxeHkMBSRonPO3awQjh9TBJ3p/ez
	g1SxCRhKdL3tYgOxRQTcJP6tOwTWwSzwmVni0qM1rCAJYYEwiVn9r5hBbBYBVYmljxYxdTFy
	cPAKuEu87PCD2CYn8f/lCiYQm1PAQ+Lb9wNsICVCQCWtjzgnMPIuYGRYxSiaWppcUJyUnmuo
	V5yYW1yal66XnJ+7iRES9F92MC4+ZnWIUYCDUYmHV+JAZogQa2JZcWXuIUYJDmYlEd6Yi0Ah
	3pTEyqrUovz4otKc1OJDjEwcnFINjP4TzxxzcWcWX2ehtXTzAZ75ET7WbUt598QGC3jP/zDz
	6sb0fRHfDCYfMXljL/k+YF85m+C5mrRJiZ77k/btdG0TjJnEVcFZnGcmK735S4zh/5jC8O9P
	X0lvcJur6nSioUcyyT/tD9f7m7Untj34GOu9dwtvRtfCOh+/jdt7WlMDDzbkSq/vUWIpzkg0
	1GIuKk4EAMBD/S1YAgAA
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
[added comment and reworked unconditional call to SMC_CMD_L2X0INVALL,
 rebased onto v3.18-rc3]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-exynos/firmware.c | 51 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index e8797bb78871..27ec360b5a87 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -14,7 +14,9 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 
+#include <asm/cputype.h>
 #include <asm/firmware.h>
+#include <asm/hardware/cache-l2x0.h>
 
 #include <mach/map.h>
 
@@ -75,6 +77,43 @@ static const struct firmware_ops exynos_firmware_ops = {
 	.cpu_boot		= exynos_cpu_boot,
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
+			regs->prefetch_ctrl);
+	exynos_smc(SMC_CMD_L2X0SETUP2, regs->pwr_ctrl, regs->aux_ctrl, 0);
+}
+
 void __init exynos_firmware_init(void)
 {
 	struct device_node *nd;
@@ -94,4 +133,16 @@ void __init exynos_firmware_init(void)
 	pr_info("Running under secure firmware.\n");
 
 	register_firmware_ops(&exynos_firmware_ops);
+
+	/*
+	 * Exynos 4 SoCs (based on Cortex A9 and equipped with L2C-310),
+	 * running under secure firmware, require certain registers of L2
+	 * cache controller to be written in secure mode. Here .write_sec
+	 * callback is provided to perform necessary SMC calls.
+	 */
+	if (IS_ENABLED(CONFIG_CACHE_L2X0)
+	    && read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
+		outer_cache.write_sec = exynos_l2_write_sec;
+		outer_cache.configure = exynos_l2_configure;
+	}
 }
-- 
1.9.2

