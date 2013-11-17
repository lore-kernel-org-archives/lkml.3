Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3KQIuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 03:50:55 -0500
Received: from gnurou.org ([207.192.72.5]:53755 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab3KQIus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 03:50:48 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] ARM: move firmware_ops to drivers/firmware
Date: Sun, 17 Nov 2013 17:49:29 +0900
Message-Id: <1384678169-28228-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM tree includes a firmware_ops interface that is designed to
implement support for simple, TrustZone-based firmwares but could
also cover other use-cases. It has been suggested that this
interface might be useful to other architectures (e.g. arm64) and
that it should be moved out of arch/arm.

This patch takes care of this by performing the following:
* Move the ARM firmware interface into drivers/firmware/ and rename
  it to platform_firmware,
* Update its documentation accordingly,
* Update the only user of the API to date (Exynos secure firmware
  support) to use the new API.

The ARM architecture's Kconfig now needs to include the Kconfig of
drivers/firmware, which will result in an empty menu for most platforms
that don't make use of any firmware. To avoid this, a new invisible
ARCH_SUPPORTS_FIRMWARE configuration variable is also defined for ARM,
that should explicitly be set by platforms that support firmware so that
the firmware menu is included.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/arm/firmware.txt               | 88 ---------------------------
 Documentation/firmware/platform_firmware.txt | 89 ++++++++++++++++++++++++++++
 arch/arm/Kconfig                             |  9 +++
 arch/arm/common/Makefile                     |  2 -
 arch/arm/common/firmware.c                   | 18 ------
 arch/arm/include/asm/firmware.h              | 66 ---------------------
 arch/arm/mach-exynos/Makefile                |  2 +-
 arch/arm/mach-exynos/firmware.c              |  7 +--
 arch/arm/mach-exynos/platsmp.c               | 10 ++--
 drivers/firmware/Kconfig                     |  8 +++
 drivers/firmware/Makefile                    |  1 +
 drivers/firmware/platform_firmware.c         | 17 ++++++
 include/linux/platform_firmware.h            | 69 +++++++++++++++++++++
 13 files changed, 203 insertions(+), 183 deletions(-)
 delete mode 100644 Documentation/arm/firmware.txt
 create mode 100644 Documentation/firmware/platform_firmware.txt
 delete mode 100644 arch/arm/common/firmware.c
 delete mode 100644 arch/arm/include/asm/firmware.h
 create mode 100644 drivers/firmware/platform_firmware.c
 create mode 100644 include/linux/platform_firmware.h

diff --git a/Documentation/arm/firmware.txt b/Documentation/arm/firmware.txt
deleted file mode 100644
index c2e468f..0000000
--- a/Documentation/arm/firmware.txt
+++ /dev/null
@@ -1,88 +0,0 @@
-Interface for registering and calling firmware-specific operations for ARM.
-----
-Written by Tomasz Figa <t.figa@samsung.com>
-
-Some boards are running with secure firmware running in TrustZone secure
-world, which changes the way some things have to be initialized. This makes
-a need to provide an interface for such platforms to specify available firmware
-operations and call them when needed.
-
-Firmware operations can be specified using struct firmware_ops
-
-	struct firmware_ops {
-		/*
-		* Enters CPU idle mode
-		*/
-		int (*do_idle)(void);
-		/*
-		* Sets boot address of specified physical CPU
-		*/
-		int (*set_cpu_boot_addr)(int cpu, unsigned long boot_addr);
-		/*
-		* Boots specified physical CPU
-		*/
-		int (*cpu_boot)(int cpu);
-		/*
-		* Initializes L2 cache
-		*/
-		int (*l2x0_init)(void);
-	};
-
-and then registered with register_firmware_ops function
-
-	void register_firmware_ops(const struct firmware_ops *ops)
-
-the ops pointer must be non-NULL.
-
-There is a default, empty set of operations provided, so there is no need to
-set anything if platform does not require firmware operations.
-
-To call a firmware operation, a helper macro is provided
-
-	#define call_firmware_op(op, ...)				\
-		((firmware_ops->op) ? firmware_ops->op(__VA_ARGS__) : (-ENOSYS))
-
-the macro checks if the operation is provided and calls it or otherwise returns
--ENOSYS to signal that given operation is not available (for example, to allow
-fallback to legacy operation).
-
-Example of registering firmware operations:
-
-	/* board file */
-
-	static int platformX_do_idle(void)
-	{
-		/* tell platformX firmware to enter idle */
-		return 0;
-	}
-
-	static int platformX_cpu_boot(int i)
-	{
-		/* tell platformX firmware to boot CPU i */
-		return 0;
-	}
-
-	static const struct firmware_ops platformX_firmware_ops = {
-		.do_idle        = exynos_do_idle,
-		.cpu_boot       = exynos_cpu_boot,
-		/* other operations not available on platformX */
-	};
-
-	/* init_early callback of machine descriptor */
-	static void __init board_init_early(void)
-	{
-		register_firmware_ops(&platformX_firmware_ops);
-	}
-
-Example of using a firmware operation:
-
-	/* some platform code, e.g. SMP initialization */
-
-	__raw_writel(virt_to_phys(exynos4_secondary_startup),
-		CPU1_BOOT_REG);
-
-	/* Call Exynos specific smc call */
-	if (call_firmware_op(cpu_boot, cpu) == -ENOSYS)
-		cpu_boot_legacy(...); /* Try legacy way */
-
-	gic_raise_softirq(cpumask_of(cpu), 1);
diff --git a/Documentation/firmware/platform_firmware.txt b/Documentation/firmware/platform_firmware.txt
new file mode 100644
index 0000000..db2a3e7
--- /dev/null
+++ b/Documentation/firmware/platform_firmware.txt
@@ -0,0 +1,89 @@
+Interface for registering and calling firmware-specific operations.
+----
+Written by Tomasz Figa <t.figa@samsung.com>
+
+Some boards are running with secure firmware running in secure world, which
+changes the way some things have to be initialized. This makes a need to provide
+an interface for such platforms to specify available firmware operations and
+call them when needed.
+
+Firmware operations can be specified using struct platform_firmware_ops
+
+	struct platform_firmware_ops {
+		/*
+		* Enters CPU idle mode
+		*/
+		int (*do_idle)(void);
+		/*
+		* Sets boot address of specified physical CPU
+		*/
+		int (*set_cpu_boot_addr)(int cpu, unsigned long boot_addr);
+		/*
+		* Boots specified physical CPU
+		*/
+		int (*cpu_boot)(int cpu);
+		/*
+		* Initializes L2 cache
+		*/
+		int (*l2x0_init)(void);
+	};
+
+and then registered with register_platform_firmware_ops function
+
+void register_platform_firmware_ops(const struct platform_firmware_ops *ops)
+
+the ops pointer must be non-NULL.
+
+There is a default, empty set of operations provided, so there is no need to
+set anything if platform does not require firmware operations.
+
+To call a firmware operation, a helper macro is provided
+
+	#define call_platform_firmware_op(op, ...)				\
+		((platform_firmware_ops->op) ?
+		platform_firmware_ops->op(__VA_ARGS__) : (-ENOSYS))
+
+the macro checks if the operation is provided and calls it or otherwise returns
+-ENOSYS to signal that given operation is not available (for example, to allow
+fallback to legacy operation).
+
+Example of registering firmware operations:
+
+	/* board file */
+
+	static int platformX_do_idle(void)
+	{
+		/* tell platformX firmware to enter idle */
+		return 0;
+	}
+
+	static int platformX_cpu_boot(int i)
+	{
+		/* tell platformX firmware to boot CPU i */
+		return 0;
+	}
+
+	static const struct platform_firmware_ops platformX_firmware_ops = {
+		.do_idle        = exynos_do_idle,
+		.cpu_boot       = exynos_cpu_boot,
+		/* other operations not available on platformX */
+	};
+
+	/* init_early callback of machine descriptor */
+	static void __init board_init_early(void)
+	{
+		register_platform_firmware_ops(&platformX_firmware_ops);
+	}
+
+Example of using a firmware operation:
+
+	/* some platform code, e.g. SMP initialization */
+
+	__raw_writel(virt_to_phys(exynos4_secondary_startup),
+		CPU1_BOOT_REG);
+
+	/* Call Exynos specific smc call */
+	if (call_platform_firmware_op(cpu_boot, cpu) == -ENOSYS)
+		cpu_boot_legacy(...); /* Try legacy way */
+
+	gic_raise_softirq(cpumask_of(cpu), 1);
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index cc68e6d..9026af0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -218,6 +218,9 @@ config NEED_RET_TO_USER
 config ARCH_MTD_XIP
 	bool
 
+config ARCH_SUPPORTS_FIRMWARE
+	bool
+
 config VECTORS_BASE
 	hex
 	default 0xffff0000 if MMU || CPU_HIGH_VECTOR
@@ -806,6 +809,8 @@ config ARCH_EXYNOS
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_SPARSEMEM_ENABLE
+	select ARCH_SUPPORTS_FIRMWARE
+	select EXYNOS_FIRMWARE
 	select ARM_GIC
 	select COMMON_CLK
 	select CPU_V7
@@ -2256,6 +2261,10 @@ source "net/Kconfig"
 
 source "drivers/Kconfig"
 
+if ARCH_SUPPORTS_FIRMWARE
+source "drivers/firmware/Kconfig"
+endif
+
 source "fs/Kconfig"
 
 source "arch/arm/Kconfig.debug"
diff --git a/arch/arm/common/Makefile b/arch/arm/common/Makefile
index 4bdc416..f98a991 100644
--- a/arch/arm/common/Makefile
+++ b/arch/arm/common/Makefile
@@ -2,8 +2,6 @@
 # Makefile for the linux kernel.
 #
 
-obj-y				+= firmware.o
-
 obj-$(CONFIG_ICST)		+= icst.o
 obj-$(CONFIG_SA1111)		+= sa1111.o
 obj-$(CONFIG_DMABOUNCE)		+= dmabounce.o
diff --git a/arch/arm/common/firmware.c b/arch/arm/common/firmware.c
deleted file mode 100644
index 27ddccb..0000000
--- a/arch/arm/common/firmware.c
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * Copyright (C) 2012 Samsung Electronics.
- * Kyungmin Park <kyungmin.park@samsung.com>
- * Tomasz Figa <t.figa@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/suspend.h>
-
-#include <asm/firmware.h>
-
-static const struct firmware_ops default_firmware_ops;
-
-const struct firmware_ops *firmware_ops = &default_firmware_ops;
diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
deleted file mode 100644
index 1563130..0000000
--- a/arch/arm/include/asm/firmware.h
+++ /dev/null
@@ -1,66 +0,0 @@
-/*
- * Copyright (C) 2012 Samsung Electronics.
- * Kyungmin Park <kyungmin.park@samsung.com>
- * Tomasz Figa <t.figa@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __ASM_ARM_FIRMWARE_H
-#define __ASM_ARM_FIRMWARE_H
-
-#include <linux/bug.h>
-
-/*
- * struct firmware_ops
- *
- * A structure to specify available firmware operations.
- *
- * A filled up structure can be registered with register_firmware_ops().
- */
-struct firmware_ops {
-	/*
-	 * Enters CPU idle mode
-	 */
-	int (*do_idle)(void);
-	/*
-	 * Sets boot address of specified physical CPU
-	 */
-	int (*set_cpu_boot_addr)(int cpu, unsigned long boot_addr);
-	/*
-	 * Boots specified physical CPU
-	 */
-	int (*cpu_boot)(int cpu);
-	/*
-	 * Initializes L2 cache
-	 */
-	int (*l2x0_init)(void);
-};
-
-/* Global pointer for current firmware_ops structure, can't be NULL. */
-extern const struct firmware_ops *firmware_ops;
-
-/*
- * call_firmware_op(op, ...)
- *
- * Checks if firmware operation is present and calls it,
- * otherwise returns -ENOSYS
- */
-#define call_firmware_op(op, ...)					\
-	((firmware_ops->op) ? firmware_ops->op(__VA_ARGS__) : (-ENOSYS))
-
-/*
- * register_firmware_ops(ops)
- *
- * A function to register platform firmware_ops struct.
- */
-static inline void register_firmware_ops(const struct firmware_ops *ops)
-{
-	BUG_ON(!ops);
-
-	firmware_ops = ops;
-}
-
-#endif
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 8930b66..7132d03 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
 
 obj-$(CONFIG_ARCH_EXYNOS)	+= exynos-smc.o
-obj-$(CONFIG_ARCH_EXYNOS)	+= firmware.o
+obj-$(CONFIG_EXYNOS_FIRMWARE)	+= firmware.o
 
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 932129e..6dc4938 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -13,8 +13,7 @@
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-
-#include <asm/firmware.h>
+#include <linux/platform_firmware.h>
 
 #include <mach/map.h>
 
@@ -40,7 +39,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 	return 0;
 }
 
-static const struct firmware_ops exynos_firmware_ops = {
+static const struct platform_firmware_ops exynos_firmware_ops = {
 	.do_idle		= exynos_do_idle,
 	.set_cpu_boot_addr	= exynos_set_cpu_boot_addr,
 	.cpu_boot		= exynos_cpu_boot,
@@ -64,5 +63,5 @@ void __init exynos_firmware_init(void)
 
 	pr_info("Running under secure firmware.\n");
 
-	register_firmware_ops(&exynos_firmware_ops);
+	register_platform_firmware_ops(&exynos_firmware_ops);
 }
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 58b43e6..132d21c 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -20,11 +20,11 @@
 #include <linux/jiffies.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/platform_firmware.h>
 
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
 #include <asm/smp_scu.h>
-#include <asm/firmware.h>
 
 #include <mach/hardware.h>
 #include <mach/regs-clock.h>
@@ -150,10 +150,11 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 		 * Try to set boot address using firmware first
 		 * and fall back to boot register if it fails.
 		 */
-		if (call_firmware_op(set_cpu_boot_addr, phys_cpu, boot_addr))
+		if (call_platform_firmware_op(set_cpu_boot_addr, phys_cpu,
+					      boot_addr))
 			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
 
-		call_firmware_op(cpu_boot, phys_cpu);
+		call_platform_firmware_op(cpu_boot, phys_cpu);
 
 		arch_send_wakeup_ipi_mask(cpumask_of(cpu));
 
@@ -225,7 +226,8 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
 		phys_cpu = cpu_logical_map(i);
 		boot_addr = virt_to_phys(exynos4_secondary_startup);
 
-		if (call_firmware_op(set_cpu_boot_addr, phys_cpu, boot_addr))
+		if (call_platform_firmware_op(set_cpu_boot_addr, phys_cpu,
+					      boot_addr))
 			__raw_writel(boot_addr, cpu_boot_reg(phys_cpu));
 	}
 }
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 0747872..1fb9da6 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -129,6 +129,14 @@ config ISCSI_IBFT
 	  detect iSCSI boot parameters dynamically during system boot, say Y.
 	  Otherwise, say N.
 
+config PLATFORM_FIRMWARE
+	bool
+
+config EXYNOS_FIRMWARE
+	bool "Support for Exynos secure firmware"
+	select PLATFORM_FIRMWARE
+	depends on ARM && ARCH_EXYNOS
+
 source "drivers/firmware/google/Kconfig"
 source "drivers/firmware/efi/Kconfig"
 
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 299fad6..9cd2231 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
+obj-$(CONFIG_PLATFORM_FIRMWARE) += platform_firmware.o
 
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
 obj-$(CONFIG_EFI)		+= efi/
diff --git a/drivers/firmware/platform_firmware.c b/drivers/firmware/platform_firmware.c
new file mode 100644
index 0000000..1644df2
--- /dev/null
+++ b/drivers/firmware/platform_firmware.c
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2012 Samsung Electronics.
+ * Kyungmin Park <kyungmin.park@samsung.com>
+ * Tomasz Figa <t.figa@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/suspend.h>
+#include <linux/platform_firmware.h>
+
+static const struct platform_firmware_ops default_ops;
+
+const struct platform_firmware_ops *platform_firmware_ops = &default_ops;
diff --git a/include/linux/platform_firmware.h b/include/linux/platform_firmware.h
new file mode 100644
index 0000000..601e3fd
--- /dev/null
+++ b/include/linux/platform_firmware.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2012 Samsung Electronics.
+ * Kyungmin Park <kyungmin.park@samsung.com>
+ * Tomasz Figa <t.figa@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _PLATFORM_FIRMWARE_H
+#define _PLATFORM_FIRMWARE_H
+
+#include <linux/bug.h>
+
+/*
+ * struct platform_firmware_ops
+ *
+ * A structure to specify available firmware operations.
+ *
+ * A filled up structure can be registered with
+ * register_platform_firmware_ops().
+ */
+struct platform_firmware_ops {
+	/*
+	 * Enters CPU idle mode
+	 */
+	int (*do_idle)(void);
+	/*
+	 * Sets boot address of specified physical CPU
+	 */
+	int (*set_cpu_boot_addr)(int cpu, unsigned long boot_addr);
+	/*
+	 * Boots specified physical CPU
+	 */
+	int (*cpu_boot)(int cpu);
+	/*
+	 * Initializes L2 cache
+	 */
+	int (*l2x0_init)(void);
+};
+
+/* Global pointer for current firmware_ops structure, can't be NULL. */
+extern const struct platform_firmware_ops *platform_firmware_ops;
+
+/*
+ * call_platform_firmware_op(op, ...)
+ *
+ * Checks if firmware operation is present and calls it,
+ * otherwise returns -ENOSYS
+ */
+#define call_platform_firmware_op(op, ...)				\
+	((platform_firmware_ops->op) ?					\
+	platform_firmware_ops->op(__VA_ARGS__) : (-ENOSYS))
+
+/*
+ * register_platform_firmware_ops(ops)
+ *
+ * A function to register platform firmware_ops struct.
+ */
+static inline
+void register_platform_firmware_ops(const struct platform_firmware_ops *ops)
+{
+	BUG_ON(!ops);
+
+	platform_firmware_ops = ops;
+}
+
+#endif
-- 
1.8.4.2

