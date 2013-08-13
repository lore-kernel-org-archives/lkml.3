Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3HMCbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:31:10 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8993 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab3HMCaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:30:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 Aug 2013 19:30:21 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Joseph Lo <josephl@nvidia.com>, Jassi Brar <jassisinghbrar@gmail.com>
CC: <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 2/5] ARM: tegra: add support for Trusted Foundations
Date: Tue, 13 Aug 2013 11:29:49 +0900
Message-ID: <1376360992-1508-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376360992-1508-1-git-send-email-acourbot@nvidia.com>
References: <1376360992-1508-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the firmware operations for Trusted Foundations if the device
tree indicates it is active on the device.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/devicetree/bindings/arm/tegra.txt |  5 +++
 arch/arm/mach-tegra/Kconfig                     |  1 +
 arch/arm/mach-tegra/Makefile                    |  1 +
 arch/arm/mach-tegra/common.c                    |  2 ++
 arch/arm/mach-tegra/firmware.c                  | 41 +++++++++++++++++++++++++
 arch/arm/mach-tegra/firmware.h                  | 19 ++++++++++++
 6 files changed, 69 insertions(+)
 create mode 100644 arch/arm/mach-tegra/firmware.c
 create mode 100644 arch/arm/mach-tegra/firmware.h

diff --git a/Documentation/devicetree/bindings/arm/tegra.txt b/Documentation/devicetree/bindings/arm/tegra.txt
index ed9c853..5423f51 100644
--- a/Documentation/devicetree/bindings/arm/tegra.txt
+++ b/Documentation/devicetree/bindings/arm/tegra.txt
@@ -32,3 +32,8 @@ board-specific compatible values:
   nvidia,whistler
   toradex,colibri_t20-512
   toradex,iris
+
+Trusted Foundations
+-------------------------------------------
+Tegra supports the Trusted Foundation secure monitor. See the
+"tl,trusted-foundations" binding for more details.
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index ef3a8da..b6b7c44 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -2,6 +2,7 @@ config ARCH_TEGRA
 	bool "NVIDIA Tegra" if ARCH_MULTI_V7
 	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select CLKSRC_OF
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 98b184e..5ae9afb 100644
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
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 94a119a..6794536 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -39,6 +39,7 @@
 #include "sleep.h"
 #include "pm.h"
 #include "reset.h"
+#include "firmware.h"
 
 /*
  * Storage for debug-macro.S's state.
@@ -99,6 +100,7 @@ static void __init tegra_init_cache(void)
 
 void __init tegra_init_early(void)
 {
+	tegra_init_firmware();
 	tegra_cpu_reset_handler_init();
 	tegra_apb_io_init();
 	tegra_init_fuse();
diff --git a/arch/arm/mach-tegra/firmware.c b/arch/arm/mach-tegra/firmware.c
new file mode 100644
index 0000000..4ad9af6
--- /dev/null
+++ b/arch/arm/mach-tegra/firmware.c
@@ -0,0 +1,41 @@
+/*
+ * Firmware/Secure monitor support for Tegra CPUs
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
+#include <linux/of.h>
+#include <asm/trusted_foundations.h>
+
+void __init tegra_init_firmware(void)
+{
+	struct device_node *node;
+
+	if (!of_have_populated_dt())
+		return;
+
+	node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
+	if (node) {
+		const char *tf_version;
+		int err;
+
+		err = of_property_read_string(node, "version", &tf_version);
+		if (err != 0) {
+			pr_crit("Cannot read Trusted Foundation version: %d\n",
+				err);
+			BUG();
+		} else {
+			register_trusted_foundations(tf_version);
+		}
+	}
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
-- 
1.8.3.4

