Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab3FFH2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:28:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2304 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3FFH2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:28:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 06 Jun 2013 00:27:46 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>
CC: <gnurou@gmail.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] ARM: tegra: add basic SecureOS support
Date: Thu, 6 Jun 2013 16:28:07 +0900
Message-ID: <1370503687-17767-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boot loaders on some Tegra devices can be unlocked but do not let the
system operate without SecureOS. SecureOS prevents access to some
registers and requires the operating system to perform certain
operations through Secure Monitor Calls instead of directly accessing
the hardware.

This patch introduces basic SecureOS support for Tegra. SecureOS support
can be enabled by adding a "nvidia,secure-os" property to the "chosen"
node of the device tree.

Currently, only the bringup of secondary CPUs is performed by SMCs, but
more operations will be added later.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/devicetree/bindings/arm/tegra.txt |  8 +++
 arch/arm/configs/tegra_defconfig                |  1 +
 arch/arm/mach-tegra/Kconfig                     | 11 ++++
 arch/arm/mach-tegra/Makefile                    |  2 +
 arch/arm/mach-tegra/common.c                    |  2 +
 arch/arm/mach-tegra/reset.c                     | 30 +++++++----
 arch/arm/mach-tegra/secureos.c                  | 70 +++++++++++++++++++++++++
 arch/arm/mach-tegra/secureos.h                  | 31 +++++++++++
 8 files changed, 145 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm/mach-tegra/secureos.c
 create mode 100644 arch/arm/mach-tegra/secureos.h

diff --git a/Documentation/devicetree/bindings/arm/tegra.txt b/Documentation/devicetree/bindings/arm/tegra.txt
index ed9c853..b543091 100644
--- a/Documentation/devicetree/bindings/arm/tegra.txt
+++ b/Documentation/devicetree/bindings/arm/tegra.txt
@@ -32,3 +32,11 @@ board-specific compatible values:
   nvidia,whistler
   toradex,colibri_t20-512
   toradex,iris
+
+Global properties
+-------------------------------------------
+
+The following properties can be specified into the "chosen" root
+node:
+
+  nvidia,secure-os: enable SecureOS.
diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index f7ba3161..f6ed0f5 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -28,6 +28,7 @@ CONFIG_ARCH_TEGRA_3x_SOC=y
 CONFIG_ARCH_TEGRA_114_SOC=y
 CONFIG_TEGRA_PCI=y
 CONFIG_TEGRA_EMC_SCALING_ENABLE=y
+CONFIG_TEGRA_SECUREOS=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
 CONFIG_AEABI=y
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 84d72fc..acb5d0a 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -87,4 +87,15 @@ config TEGRA_AHB
 config TEGRA_EMC_SCALING_ENABLE
 	bool "Enable scaling the memory frequency"
 
+config TEGRA_SECUREOS
+	bool "Enable SecureOS support"
+	help
+	  Support for Tegra devices which bootloader sets up a
+	  SecureOS environment. This will use Secure Monitor Calls
+	  instead of directly accessing the hardware for some protected
+	  operations.
+
+	  SecureOS support is enabled by declaring a "nvidia,secure-os"
+	  property into the "chosen" node of the device tree.
+
 endmenu
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index d011f0a..3adafe6 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -37,3 +37,5 @@ endif
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-harmony-pcie.o
 
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-paz00.o
+
+obj-$(CONFIG_TEGRA_SECUREOS)		+= secureos.o
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 9f852c6..b7eea02 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -37,6 +37,7 @@
 #include "sleep.h"
 #include "pm.h"
 #include "reset.h"
+#include "secureos.h"
 
 /*
  * Storage for debug-macro.S's state.
@@ -97,6 +98,7 @@ static void __init tegra_init_cache(void)
 
 void __init tegra_init_early(void)
 {
+	tegra_init_secureos();
 	tegra_cpu_reset_handler_init();
 	tegra_apb_io_init();
 	tegra_init_fuse();
diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
index 1ac434e..4b9ebf9 100644
--- a/arch/arm/mach-tegra/reset.c
+++ b/arch/arm/mach-tegra/reset.c
@@ -21,38 +21,32 @@
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
+#include <asm/firmware.h>
 
 #include "iomap.h"
 #include "irammap.h"
 #include "reset.h"
 #include "sleep.h"
 #include "fuse.h"
+#include "secureos.h"
 
 #define TEGRA_IRAM_RESET_BASE (TEGRA_IRAM_BASE + \
 				TEGRA_IRAM_RESET_HANDLER_OFFSET)
 
 static bool is_enabled;
 
-static void __init tegra_cpu_reset_handler_enable(void)
+static void __init tegra_cpu_reset_handler_set(const u32 reset_address)
 {
-	void __iomem *iram_base = IO_ADDRESS(TEGRA_IRAM_RESET_BASE);
 	void __iomem *evp_cpu_reset =
 		IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE + 0x100);
 	void __iomem *sb_ctrl = IO_ADDRESS(TEGRA_SB_BASE);
 	u32 reg;
 
-	BUG_ON(is_enabled);
-	BUG_ON(tegra_cpu_reset_handler_size > TEGRA_IRAM_RESET_HANDLER_SIZE);
-
-	memcpy(iram_base, (void *)__tegra_cpu_reset_handler_start,
-			tegra_cpu_reset_handler_size);
-
 	/*
 	 * NOTE: This must be the one and only write to the EVP CPU reset
 	 *       vector in the entire system.
 	 */
-	writel(TEGRA_IRAM_RESET_BASE + tegra_cpu_reset_handler_offset,
-			evp_cpu_reset);
+	writel(reset_address, evp_cpu_reset);
 	wmb();
 	reg = readl(evp_cpu_reset);
 
@@ -66,6 +60,22 @@ static void __init tegra_cpu_reset_handler_enable(void)
 		writel(reg, sb_ctrl);
 		wmb();
 	}
+}
+
+static void __init tegra_cpu_reset_handler_enable(void)
+{
+	void __iomem *iram_base = IO_ADDRESS(TEGRA_IRAM_RESET_BASE);
+	const u32 reset_address = TEGRA_IRAM_RESET_BASE +
+						tegra_cpu_reset_handler_offset;
+
+	BUG_ON(is_enabled);
+	BUG_ON(tegra_cpu_reset_handler_size > TEGRA_IRAM_RESET_HANDLER_SIZE);
+
+	memcpy(iram_base, (void *)__tegra_cpu_reset_handler_start,
+			tegra_cpu_reset_handler_size);
+
+	if (call_firmware_op(set_cpu_boot_addr, 0, reset_address) == -ENOSYS)
+		tegra_cpu_reset_handler_set(reset_address);
 
 	is_enabled = true;
 }
diff --git a/arch/arm/mach-tegra/secureos.c b/arch/arm/mach-tegra/secureos.c
new file mode 100644
index 0000000..44c3514
--- /dev/null
+++ b/arch/arm/mach-tegra/secureos.c
@@ -0,0 +1,70 @@
+/*
+ * SecureOS support for Tegra CPUs
+ *
+ * Copyright (c) 2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/of.h>
+#include <asm/firmware.h>
+
+static int __attribute__((used)) __tegra_smc_stack[10];
+
+/*
+ * With EABI, subtype and arg already end up in r0, r1 and r2 as they are
+ * function arguments, but we prefer to play safe here and explicitly move
+ * these values into the expected registers anyway. mov instructions without
+ * any side-effect are turned into nops by the assembler, which limits
+ * overhead.
+ */
+static void tegra_generic_smc(u32 type, u32 subtype, u32 arg)
+{
+	asm volatile(
+		".arch_extension	sec\n\t"
+		"ldr	r3, =__tegra_smc_stack\n\t"
+		"stmia	r3, {r4-r12, lr}\n\t"
+		"mov	r0, %[type]\n\t"
+		"mov	r1, %[subtype]\n\t"
+		"mov	r2, %[arg]\n\t"
+		"mov	r3, #0\n\t"
+		"mov	r4, #0\n\t"
+		"dsb\n\t"
+		"smc	#0\n\t"
+		"ldr	r3, =__tegra_smc_stack\n\t"
+		"ldmia	r3, {r4-r12, lr}"
+			:
+			: [type]    "r" (type),
+			  [subtype] "r" (subtype),
+			  [arg]     "r" (arg)
+			: "r0", "r1", "r2", "r3", "r4", "memory");
+}
+
+static int tegra_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
+{
+	tegra_generic_smc(0xfffff200, boot_addr, 0);
+
+	return 0;
+}
+
+static const struct firmware_ops tegra_firmware_ops = {
+	.set_cpu_boot_addr = tegra_set_cpu_boot_addr,
+};
+
+void __init tegra_init_secureos(void)
+{
+	struct device_node *node = of_find_node_by_path("/chosen");
+
+	if (node && of_property_read_bool(node, "nvidia,secure-os"))
+		register_firmware_ops(&tegra_firmware_ops);
+}
diff --git a/arch/arm/mach-tegra/secureos.h b/arch/arm/mach-tegra/secureos.h
new file mode 100644
index 0000000..5388cc5
--- /dev/null
+++ b/arch/arm/mach-tegra/secureos.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2013, NVIDIA Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __TEGRA_SECUREOS_H
+#define __TEGRA_SECUREOS_H
+
+#ifdef CONFIG_TEGRA_SECUREOS
+
+#include <linux/types.h>
+
+void tegra_init_secureos(void);
+
+#else
+
+static inline void tegra_init_secureos(void)
+{
+}
+
+#endif
+
+#endif
-- 
1.8.3

