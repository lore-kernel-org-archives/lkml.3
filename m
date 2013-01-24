Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3AXLRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:17:31 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16528 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3AXLMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:12:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 24 Jan 2013 03:10:25 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Jason Cooper <jason@lakedaemon.net>,
        Shawn Guo <shawn.guo@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Kukjin Kim <kgene.kim@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [v4 6/6] ARM: tegra: Add initial support for Tegra114 SoC.
Date: Thu, 24 Jan 2013 13:10:26 +0200
Message-ID: <1359025829-22306-7-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359025829-22306-1-git-send-email-hdoyu@nvidia.com>
References: <1359025829-22306-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new Tegra 114 SoC support.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig             |   10 +++++++
 arch/arm/mach-tegra/Makefile            |    1 +
 arch/arm/mach-tegra/board-dt-tegra114.c |   48 +++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/common.c            |    1 +
 4 files changed, 60 insertions(+)
 create mode 100644 arch/arm/mach-tegra/board-dt-tegra114.c

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index abc688f..eada60f 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -45,6 +45,16 @@ config ARCH_TEGRA_3x_SOC
 	  Support for NVIDIA Tegra T30 processor family, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
 
+config ARCH_TEGRA_114_SOC
+	bool "Enable support for Tegra114 family"
+	select ARM_GIC
+	select CPU_V7
+	select ARM_L1_CACHE_SHIFT_6
+	select ARM_ARCH_TIMER
+	help
+	  Support for NVIDIA Tegra T114 processor family, based on the
+	  ARM CortexA15MP CPU
+
 config TEGRA_PCI
 	bool "PCI Express support"
 	depends on ARCH_TEGRA_2x_SOC
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 432f2a5..e1eaf30 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_TEGRA_PCI)			+= pcie.o
 
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-dt-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
+obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= board-dt-tegra114.o
 
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-harmony-pcie.o
 
diff --git a/arch/arm/mach-tegra/board-dt-tegra114.c b/arch/arm/mach-tegra/board-dt-tegra114.c
new file mode 100644
index 0000000..3ed17ce
--- /dev/null
+++ b/arch/arm/mach-tegra/board-dt-tegra114.c
@@ -0,0 +1,48 @@
+/*
+ * NVIDIA Tegra114 device tree board support
+ *
+ * Copyright (C) 2013 NVIDIA Corporation
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/clocksource.h>
+
+#include <asm/mach/arch.h>
+#include <asm/hardware/gic.h>
+
+#include "board.h"
+#include "common.h"
+
+static void __init tegra114_dt_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char * const tegra114_dt_board_compat[] = {
+	"nvidia,tegra114",
+	NULL,
+};
+
+DT_MACHINE_START(TEGRA114_DT, "NVIDIA Tegra114 (Flattened Device Tree)")
+	.smp		= smp_ops(tegra_smp_ops),
+	.map_io		= tegra_map_common_io,
+	.init_early	= tegra30_init_early,
+	.init_irq	= tegra_dt_init_irq,
+	.handle_irq	= gic_handle_irq,
+	.init_time	= clocksource_of_init,
+	.init_machine	= tegra114_dt_init,
+	.init_late	= tegra_init_late,
+	.restart	= tegra_assert_system_reset,
+	.dt_compat	= tegra114_dt_board_compat,
+MACHINE_END
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 87dd69c..2f13513 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -59,6 +59,7 @@ u32 tegra_uart_config[4] = {
 
 #ifdef CONFIG_OF
 static const struct of_device_id tegra_dt_irq_match[] __initconst = {
+	{ .compatible = "arm,cortex-a15-gic", .data = gic_of_init },
 	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init },
 	{ }
 };
-- 
1.7.9.5

