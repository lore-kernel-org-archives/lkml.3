Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3J1K3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:29:00 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8273 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab3J1K24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:28:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 28 Oct 2013 03:24:01 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v9 1/5] ARM: add basic support for Trusted Foundations
Date: Mon, 28 Oct 2013 19:28:34 +0900
Message-ID: <1382956118-12495-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382956118-12495-1-git-send-email-acourbot@nvidia.com>
References: <1382956118-12495-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
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
 .../arm/firmware/tl,trusted-foundations.txt        | 20 ++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/arm/Kconfig                                   |  2 +
 arch/arm/Makefile                                  |  1 +
 arch/arm/firmware/Kconfig                          | 28 ++++++++
 arch/arm/firmware/Makefile                         |  1 +
 arch/arm/firmware/trusted_foundations.c            | 79 ++++++++++++++++++++++
 arch/arm/include/asm/trusted_foundations.h         | 67 ++++++++++++++++++
 8 files changed, 199 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
 create mode 100644 arch/arm/firmware/Kconfig
 create mode 100644 arch/arm/firmware/Makefile
 create mode 100644 arch/arm/firmware/trusted_foundations.c
 create mode 100644 arch/arm/include/asm/trusted_foundations.h

diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
new file mode 100644
index 0000000..2ec75c9
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
@@ -0,0 +1,20 @@
+Trusted Foundations
+-------------------
+
+Boards that use the Trusted Foundations secure monitor can signal its
+presence by declaring a node compatible with "tl,trusted-foundations"
+under the /firmware/ node
+
+Required properties:
+- compatible : "tl,trusted-foundations"
+- version-major : major version number of Trusted Foundations firmware
+- version-minor: minor version number of Trusted Foundations firmware
+
+Example:
+	firmware {
+		trusted-foundations {
+			compatible = "tl,trusted-foundations";
+			version-major = <2>;
+			version-minor = <8>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 2956800..a374eaa 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -66,6 +66,7 @@ ste	ST-Ericsson
 stericsson	ST-Ericsson
 toumaz	Toumaz
 ti	Texas Instruments
+tl	Trusted Logic
 toshiba	Toshiba Corporation
 v3	V3 Semiconductor
 via	VIA Technologies, Inc.
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ad6fb6..bf14cec 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1076,6 +1076,8 @@ config ARM_TIMER_SP804
 	select CLKSRC_MMIO
 	select CLKSRC_OF if OF
 
+source "arch/arm/firmware/Kconfig"
+
 source arch/arm/mm/Kconfig
 
 config ARM_NR_BANKS
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index db50b62..f9a8e93 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -268,6 +268,7 @@ core-$(CONFIG_KVM_ARM_HOST) 	+= arch/arm/kvm/
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
index 0000000..fe063d5
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
+static void __naked tf_generic_smc(u32 type, u32 arg1, u32 arg2)
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
+		: "r" (type), "r" (arg1), "r" (arg2)
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
+	/*
+	 * we are not using version information for now since currently
+	 * supported SMCs are compatible with all TF releases
+	 */
+	register_firmware_ops(&trusted_foundations_ops);
+}
+
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
diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h
new file mode 100644
index 0000000..3bd36e2
--- /dev/null
+++ b/arch/arm/include/asm/trusted_foundations.h
@@ -0,0 +1,67 @@
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
+#include <linux/printk.h>
+#include <linux/bug.h>
+#include <linux/of.h>
+
+struct trusted_foundations_platform_data {
+	unsigned int version_major;
+	unsigned int version_minor;
+};
+
+#if IS_ENABLED(CONFIG_TRUSTED_FOUNDATIONS)
+
+void register_trusted_foundations(struct trusted_foundations_platform_data *pd);
+void of_register_trusted_foundations(void);
+
+#else /* CONFIG_TRUSTED_FOUNDATIONS */
+
+static inline void register_trusted_foundations(
+				   struct trusted_foundations_platform_data *pd)
+{
+	/*
+	 * If we try to register TF, this means the system needs it to continue.
+	 * Its absence if thus a fatal error.
+	 */
+	panic("No support for Trusted Foundations, stopping...\n");
+}
+
+static inline void of_register_trusted_foundations(void)
+{
+	/*
+	 * If we find the target should enable TF but does not support it,
+	 * fail as the system won't be able to do much anyway
+	 */
+	if (of_find_compatible_node(NULL, NULL, "tl,trusted-foundations"))
+		register_trusted_foundations(NULL);
+}
+#endif /* CONFIG_TRUSTED_FOUNDATIONS */
+
+#endif
-- 
1.8.4.1

