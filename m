Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3HMCaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:30:23 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3955 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab3HMCaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:30:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 12 Aug 2013 19:28:22 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Joseph Lo <josephl@nvidia.com>, Jassi Brar <jassisinghbrar@gmail.com>
CC: <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 1/5] ARM: add basic Trusted Foundations support
Date: Tue, 13 Aug 2013 11:29:48 +0900
Message-ID: <1376360992-1508-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376360992-1508-1-git-send-email-acourbot@nvidia.com>
References: <1376360992-1508-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trusted Foundations is a TrustZone-based secure monitor for ARM that
can be invoked  using a consistent smc-based API on all supported
platforms. This patch adds initial basic support for Trusted
Foundations using the ARM firmware API. Current features are limited
to the ability to boot secondary processors.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../arm/firmware/tl,trusted-foundations.txt        | 16 ++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/arm/Kconfig                                   |  2 +
 arch/arm/Makefile                                  |  1 +
 arch/arm/firmware/Kconfig                          | 22 ++++++++
 arch/arm/firmware/Makefile                         |  1 +
 arch/arm/firmware/trusted_foundations.c            | 58 ++++++++++++++++++++++
 arch/arm/include/asm/trusted_foundations.h         | 36 ++++++++++++++
 8 files changed, 137 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
 create mode 100644 arch/arm/firmware/Kconfig
 create mode 100644 arch/arm/firmware/Makefile
 create mode 100644 arch/arm/firmware/trusted_foundations.c
 create mode 100644 arch/arm/include/asm/trusted_foundations.h

diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
new file mode 100644
index 0000000..2609f78
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
@@ -0,0 +1,16 @@
+Trusted Foundations
+
+Boards that use the Trusted Foundations secure monitor can signal its
+presence by declaring a node compatible with "tl,trusted-foundations"
+(the name and location of the node does not matter).
+
+Required properties:
+- compatible : "tl,trusted-foundations"
+- version : Must contain the version number string of the Trusted Foundation
+	firmware.
+
+Example:
+	firmware {
+		compatible = "tl,trusted-foundations";
+		version = "02.08";
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
index 0000000..ad0eb6c
--- /dev/null
+++ b/arch/arm/firmware/Kconfig
@@ -0,0 +1,22 @@
+config ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
+	bool
+
+menu "Firmware options"
+	depends on ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
+
+config TRUSTED_FOUNDATIONS
+	bool "Trusted Foundations secure monitor support"
+	depends on ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
+	help
+	  Some devices are booted with the Trusted Foundations secure monitor
+	  active, requiring some core operations to be performed by the secure
+	  monitor instead of the kernel.
+
+	  This option allows the kernel to invoke the secure monitor whenever
+	  required on devices using Trusted Foundations.
+
+	  Devices using Trusted Foundations should pass a device tree containing
+	  a node compatible with "tl,trusted-foundations" to signal the presence
+	  of the secure monitor.
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
index 0000000..051482d
--- /dev/null
+++ b/arch/arm/firmware/trusted_foundations.c
@@ -0,0 +1,58 @@
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
+
+#define TF_SET_CPU_BOOT_ADDR_SMC 0xfffff200
+
+static void __attribute__((naked)) tf_generic_smc(u32 type, u32 subtype,
+							u32 arg)
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
+void register_trusted_foundations(const char *version)
+{
+	/* we are not using version information for now since currently
+	 * supported SMCs are compatible with all TF releases */
+	register_firmware_ops(&trusted_foundations_ops);
+}
diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h
new file mode 100644
index 0000000..d187905
--- /dev/null
+++ b/arch/arm/include/asm/trusted_foundations.h
@@ -0,0 +1,36 @@
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
+#ifndef __ASM_ARM_TRUSTED_FOUNDATIONS_H
+#define __ASM_ARM_TRUSTED_FOUNDATIONS_H
+
+#include <linux/kconfig.h>
+#include <linux/printk.h>
+#include <asm/bug.h>
+
+#if IS_ENABLED(CONFIG_TRUSTED_FOUNDATIONS)
+
+void register_trusted_foundations(const char *version);
+
+#else
+
+static inline void register_trusted_foundations(const char *version)
+{
+	pr_crit("No support for Trusted Foundations, stopping...\n");
+	BUG();
+}
+
+#endif /* IS_ENABLED(CONFIG_TRUSTED_FOUNDATIONS) */
+
+#endif
-- 
1.8.3.4

