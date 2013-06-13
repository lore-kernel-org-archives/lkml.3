Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab3FMJNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:13:43 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7032 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758475Ab3FMJNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:13:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 13 Jun 2013 02:11:51 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Jassi Brar <jassisinghbrar@gmail.com>
CC: <gnurou@gmail.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 1/3] ARM: tegra: basic support for Trusted Foundations
Date: Thu, 13 Jun 2013 18:12:23 +0900
Message-ID: <1371114745-24710-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371114745-24710-1-git-send-email-acourbot@nvidia.com>
References: <1371114745-24710-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic support for booting secondary processors on Tegra devices
using the Trusted Foundations secure monitor.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/devicetree/bindings/arm/tegra.txt    | 11 +++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/arm/configs/tegra_defconfig                   |  1 +
 arch/arm/mach-tegra/Kconfig                        | 14 ++++++
 arch/arm/mach-tegra/Makefile                       |  3 ++
 arch/arm/mach-tegra/common.c                       |  2 +
 arch/arm/mach-tegra/firmware.c                     | 40 +++++++++++++++++
 arch/arm/mach-tegra/firmware.h                     | 19 ++++++++
 arch/arm/mach-tegra/trusted_foundations.c          | 51 ++++++++++++++++++++++
 9 files changed, 142 insertions(+)
 create mode 100644 arch/arm/mach-tegra/firmware.c
 create mode 100644 arch/arm/mach-tegra/firmware.h
 create mode 100644 arch/arm/mach-tegra/trusted_foundations.c

diff --git a/Documentation/devicetree/bindings/arm/tegra.txt b/Documentation/devicetree/bindings/arm/tegra.txt
index ed9c853..d59bc19 100644
--- a/Documentation/devicetree/bindings/arm/tegra.txt
+++ b/Documentation/devicetree/bindings/arm/tegra.txt
@@ -32,3 +32,14 @@ board-specific compatible values:
   nvidia,whistler
   toradex,colibri_t20-512
   toradex,iris
+
+Optional nodes
+-------------------------------------------
+
+Trusted Foundations:
+Boards using the Trusted Foundations secure monitor should signal its
+presence by declaring a node compatible with "tl,trusted-foundations":
+
+	firmware {
+		compatible = "tl,trusted-foundations";
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 6931c43..c21e1e9 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -58,6 +58,7 @@ st	STMicroelectronics
 ste	ST-Ericsson
 stericsson	ST-Ericsson
 ti	Texas Instruments
+tl	Trusted Logic
 toshiba	Toshiba Corporation
 via	VIA Technologies, Inc.
 wlf	Wolfson Microelectronics
diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 4de3bce..3bf158a 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -28,6 +28,7 @@ CONFIG_ARCH_TEGRA_3x_SOC=y
 CONFIG_ARCH_TEGRA_114_SOC=y
 CONFIG_TEGRA_PCI=y
 CONFIG_TEGRA_EMC_SCALING_ENABLE=y
+CONFIG_TEGRA_TRUSTED_FOUNDATIONS=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
 CONFIG_AEABI=y
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 84d72fc..055f496 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -87,4 +87,18 @@ config TEGRA_AHB
 config TEGRA_EMC_SCALING_ENABLE
 	bool "Enable scaling the memory frequency"
 
+config TEGRA_TRUSTED_FOUNDATIONS
+	bool "Trusted Foundations secure monitor support"
+	help
+	  Many Tegra devices are booted with the Trusted Foundations secure
+	  monitor active, requiring some core operations to be performed by
+	  the secure monitor instead of the kernel.
+
+	  This option allows the kernel to invoke the secure monitor when
+	  required on devices using Trusted Foundations.
+
+	  Devices using Trusted Foundations should pass a device tree containing
+	  a node compatible with "tl,trusted-foundations" to signal the presence
+	  of the secure monitor.
+
 endmenu
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index d011f0a..9fdc004 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -12,6 +12,7 @@ obj-y					+= pm.o
 obj-y					+= reset.o
 obj-y					+= reset-handler.o
 obj-y					+= sleep.o
+obj-y					+= firmware.o
 obj-y					+= tegra.o
 obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra20_speedo.o
@@ -37,3 +38,5 @@ endif
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-harmony-pcie.o
 
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-paz00.o
+
+obj-$(CONFIG_TEGRA_TRUSTED_FOUNDATIONS)	+= trusted_foundations.o
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 9f852c6..4796bb0 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -37,6 +37,7 @@
 #include "sleep.h"
 #include "pm.h"
 #include "reset.h"
+#include "firmware.h"
 
 /*
  * Storage for debug-macro.S's state.
@@ -97,6 +98,7 @@ static void __init tegra_init_cache(void)
 
 void __init tegra_init_early(void)
 {
+	tegra_init_firmware();
 	tegra_cpu_reset_handler_init();
 	tegra_apb_io_init();
 	tegra_init_fuse();
diff --git a/arch/arm/mach-tegra/firmware.c b/arch/arm/mach-tegra/firmware.c
new file mode 100644
index 0000000..ea861ca
--- /dev/null
+++ b/arch/arm/mach-tegra/firmware.c
@@ -0,0 +1,40 @@
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
+#include <linux/printk.h>
+#include <linux/kconfig.h>
+#include <linux/of.h>
+#include <asm/firmware.h>
+
+#if IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS)
+extern const struct firmware_ops tegra_trusted_foundations_ops;
+#endif
+
+void __init tegra_init_firmware(void)
+{
+	struct device_node *node;
+
+	if (!of_have_populated_dt())
+		return;
+
+	node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
+	if (node && !IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS))
+		pr_warn("Trusted Foundations detected but support missing!\n");
+#if IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS)
+	else if (node)
+		register_firmware_ops(&tegra_trusted_foundations_ops);
+#endif
+}
diff --git a/arch/arm/mach-tegra/firmware.h b/arch/arm/mach-tegra/firmware.h
new file mode 100644
index 0000000..77c62fb
--- /dev/null
+++ b/arch/arm/mach-tegra/firmware.h
@@ -0,0 +1,19 @@
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
+#ifndef __TEGRA_FIRMWARE_H
+#define __TEGRA_FIRMWARE_H
+
+void tegra_init_firmware(void);
+
+#endif
diff --git a/arch/arm/mach-tegra/trusted_foundations.c b/arch/arm/mach-tegra/trusted_foundations.c
new file mode 100644
index 0000000..411044f
--- /dev/null
+++ b/arch/arm/mach-tegra/trusted_foundations.c
@@ -0,0 +1,51 @@
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
+#define TF_SET_CPU_BOOT_ADDR_SMC 0xfffff200
+
+static void __attribute__((naked)) tegra_tf_generic_smc(u32 type, u32 subtype,
+							u32 arg)
+{
+	asm volatile(
+		".arch_extension	sec\n\t"
+		"stmfd	sp!, {r3 - r11, lr}\n\t"
+		__asmeq("%0", "r0")
+		__asmeq("%1", "r1")
+		__asmeq("%2", "r2")
+		"mov	r3, #0\n\t"
+		"mov	r4, #0\n\t"
+		"smc	#0\n\t"
+		"ldmfd	sp!, {r3 - r11, pc}"
+		:
+		: "r" (type), "r" (subtype), "r" (arg)
+		: "memory");
+}
+
+static int tegra_tf_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
+{
+	tegra_tf_generic_smc(TF_SET_CPU_BOOT_ADDR_SMC, boot_addr, 0);
+
+	return 0;
+}
+
+const struct firmware_ops tegra_trusted_foundations_ops = {
+	.set_cpu_boot_addr = tegra_tf_set_cpu_boot_addr,
+};
-- 
1.8.3

