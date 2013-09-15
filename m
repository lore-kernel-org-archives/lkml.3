Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3IOJu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 05:50:57 -0400
Received: from gnurou.org ([207.192.72.5]:40438 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab3IOJue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 05:50:34 -0400
From: Alexandre Courbot <acourbot@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: gnurou@gmail.com, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v6 1/5] ARM: add basic support for Trusted Foundations
Date: Sun, 15 Sep 2013 18:40:24 +0900
Message-Id: <1379238028-7960-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379238028-7960-1-git-send-email-acourbot@nvidia.com>
References: <1379238028-7960-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trusted Foundations is a TrustZone-based secure monitor for ARM that
can be invoked using the same SMC-based API on all supported
platforms. This patch adds initial basic support for Trusted
Foundations using the ARM firmware API. Current features are limited
to the ability to boot secondary processors.

Note: The API followed by Trusted Foundations does *not* follow the SMC
calling conventions. It has nothing to do with PSCI neither and is only
relevant to devices that use Trusted Foundations (like most Tegra-based
retail devices).

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
 .../arm/firmware/tl,trusted-foundations.txt        | 17 +++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/arm/Kconfig                                   |  2 +
 arch/arm/Makefile                                  |  1 +
 arch/arm/firmware/Kconfig                          | 28 ++++++++
 arch/arm/firmware/Makefile                         |  1 +
 arch/arm/firmware/trusted_foundations.c            | 79 ++++++++++++++++++++++
 arch/arm/include/asm/trusted_foundations.h         | 70 +++++++++++++++++++
 8 files changed, 199 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
 create mode 100644 arch/arm/firmware/Kconfig
 create mode 100644 arch/arm/firmware/Makefile
 create mode 100644 arch/arm/firmware/trusted_foundations.c
 create mode 100644 arch/arm/include/asm/trusted_foundations.h

diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
new file mode 100644
index 0000000..3954bbd
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
@@ -0,0 +1,17 @@
+Trusted Foundations
+
+Boards that use the Trusted Foundations secure monitor can signal its
+presence by declaring a node compatible with "tl,trusted-foundations"
+under the root node.
+
+Required properties:
+- compatible : "tl,trusted-foundations"
+- version-major : major version number of Trusted Foundations firmware
+- version-minor: minor version number of Trusted Foundations firmware
+
+Example:
+	firmware {
+		compatible = "tl,trusted-foundations";
+		version-major = <2>;
+		version-minor = <8>;
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 366ce9b..20d61f3 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -63,6 +63,7 @@ ste	ST-Ericsson
 stericsson	ST-Ericsson
 toumaz	Toumaz
 ti	Texas Instruments
+tl	Trusted Logic
 toshiba	Toshiba Corporation
 v3	V3 Semiconductor
 via	VIA Technologies, Inc.
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 43594d5..7fbe800 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1074,6 +1074,8 @@ config ARM_TIMER_SP804
 	select CLKSRC_MMIO
 	select CLKSRC_OF if OF
 
+source "arch/arm/firmware/Kconfig"
+
 source arch/arm/mm/Kconfig
 
 config ARM_NR_BANKS
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 6fd2cea..a48de17 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -267,6 +267,7 @@ core-$(CONFIG_KVM_ARM_HOST) 	+= arch/arm/kvm/
 core-y				+= arch/arm/kernel/ arch/arm/mm/ arch/arm/common/
 core-y				+= arch/arm/net/
 core-y				+= arch/arm/crypto/
+core-y				+= arch/arm/firmware/
 core-y				+= $(machdirs) $(platdirs)
 
 drivers-$(CONFIG_OPROFILE)      += arch/arm/oprofile/
diff --git a/arch/arm/firmware/Kconfig b/arch/arm/firmware/Kconfig
new file mode 100644
index 0000000..bb00ccf
--- /dev/null
+++ b/arch/arm/firmware/Kconfig
@@ -0,0 +1,28 @@
+config ARCH_SUPPORTS_FIRMWARE
+	bool
+
+config ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
+	bool
+	select ARCH_SUPPORTS_FIRMWARE
+
+menu "Firmware options"
+	depends on ARCH_SUPPORTS_FIRMWARE
+
+config TRUSTED_FOUNDATIONS
+	bool "Trusted Foundations secure monitor support"
+	depends on ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
+	help
+	  Some devices (including most Tegra-based consumer devices on the
+	  market) are booted with the Trusted Foundations secure monitor
+	  active, requiring some core operations to be performed by the secure
+	  monitor instead of the kernel.
+
+	  This option allows the kernel to invoke the secure monitor whenever
+	  required on devices using Trusted Foundations. See
+	  arch/arm/include/asm/trusted_foundations.h or the
+	  tl,trusted-foundations device tree binding documentation for details
+	  on how to use it.
+
+	  Say n if you don't know what this is about.
+
+endmenu
diff --git a/arch/arm/firmware/Makefile b/arch/arm/firmware/Makefile
new file mode 100644
index 0000000..a71f165
--- /dev/null
+++ b/arch/arm/firmware/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_TRUSTED_FOUNDATIONS)	+= trusted_foundations.o
diff --git a/arch/arm/firmware/trusted_foundations.c b/arch/arm/firmware/trusted_foundations.c
new file mode 100644
index 0000000..9382270
--- /dev/null
+++ b/arch/arm/firmware/trusted_foundations.c
@@ -0,0 +1,79 @@
+/*
+ * Trusted Foundations support for ARM CPUs
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
+#include <asm/trusted_foundations.h>
+
+#define TF_SET_CPU_BOOT_ADDR_SMC 0xfffff200
+
+static void __naked tf_generic_smc(u32 type, u32 subtype, u32 arg)
+{
+	asm volatile(
+		".arch_extension	sec\n\t"
+		"stmfd	sp!, {r4 - r11, lr}\n\t"
+		__asmeq("%0", "r0")
+		__asmeq("%1", "r1")
+		__asmeq("%2", "r2")
+		"mov	r3, #0\n\t"
+		"mov	r4, #0\n\t"
+		"smc	#0\n\t"
+		"ldmfd	sp!, {r4 - r11, pc}"
+		:
+		: "r" (type), "r" (subtype), "r" (arg)
+		: "memory");
+}
+
+static int tf_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
+{
+	tf_generic_smc(TF_SET_CPU_BOOT_ADDR_SMC, boot_addr, 0);
+
+	return 0;
+}
+
+static const struct firmware_ops trusted_foundations_ops = {
+	.set_cpu_boot_addr = tf_set_cpu_boot_addr,
+};
+
+void register_trusted_foundations(struct trusted_foundations_platform_data *pd)
+{
+	/* we are not using version information for now since currently
+	 * supported SMCs are compatible with all TF releases */
+	register_firmware_ops(&trusted_foundations_ops);
+}
+
+#if IS_ENABLED(CONFIG_OF)
+void of_register_trusted_foundations(void)
+{
+	struct device_node *node;
+	struct trusted_foundations_platform_data pdata;
+	int err;
+
+	node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
+	if (!node)
+		return;
+
+	err = of_property_read_u32(node, "version-major", &pdata.version_major);
+	if (err != 0)
+		panic("Trusted Foundation: missing version-major property\n");
+	err = of_property_read_u32(node, "version-minor", &pdata.version_minor);
+	if (err != 0)
+		panic("Trusted Foundation: missing version-minor property\n");
+	register_trusted_foundations(&pdata);
+}
+#endif /* CONFIG_OF */
diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h
new file mode 100644
index 0000000..921da58
--- /dev/null
+++ b/arch/arm/include/asm/trusted_foundations.h
@@ -0,0 +1,70 @@
+/*
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
+/*
+ * Support for the Trusted Foundations secure monitor.
+ *
+ * Trusted Foundation comes active on some ARM consumer devices (most
+ * Tegra-based devices sold on the market are concerned). Such devices can only
+ * perform some basic operations, like setting the CPU reset vector, through
+ * SMC calls to the secure monitor. The calls are completely specific to
+ * Trusted Foundations, and do *not* follow the SMC calling convention or the
+ * PSCI standard.
+ */
+
+#ifndef __ASM_ARM_TRUSTED_FOUNDATIONS_H
+#define __ASM_ARM_TRUSTED_FOUNDATIONS_H
+
+#include <linux/kconfig.h>
+
+struct trusted_foundations_platform_data {
+	unsigned int version_major;
+	unsigned int version_minor;
+};
+
+#if IS_ENABLED(CONFIG_TRUSTED_FOUNDATIONS)
+void register_trusted_foundations(struct trusted_foundations_platform_data *pd);
+#if IS_ENABLED(CONFIG_OF)
+void of_register_trusted_foundations(void);
+#endif
+
+#else /* CONFIG_TRUSTED_FOUNDATIONS */
+
+#include <linux/printk.h>
+#include <linux/of.h>
+#include <asm/bug.h>
+
+static inline void register_trusted_foundations(
+				   struct trusted_foundations_platform_data *pd)
+{
+	panic("No support for Trusted Foundations, stopping...\n");
+}
+
+#if IS_ENABLED(CONFIG_OF)
+static inline void of_register_trusted_foundations(void)
+{
+	/* If we find the target should enable TF but does not support it,
+	 * fail as the system won't be able to do much anyway */
+	if (of_find_compatible_node(NULL, NULL, "tl,trusted-foundations"))
+		register_trusted_foundations(NULL);
+}
+#else
+static inline void of_register_trusted_foundations(void)
+{
+}
+#endif /* CONFIG_OF */
+
+#endif /* CONFIG_TRUSTED_FOUNDATIONS */
+
+#endif
-- 
1.8.4

