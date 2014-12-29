Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaL2Raj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:30:39 -0500
Received: from outbound-smtp03.blacknight.com ([81.17.249.16]:38413 "EHLO
	outbound-smtp03.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364AbaL2Rag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:30:36 -0500
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dvhart@infradead.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH 2/2] platform/x86: Add Intel Galileo platform specific setup
Date: Mon, 29 Dec 2014 17:23:03 +0000
Message-Id: <1419873783-5161-3-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Galileo Gen1 and Gen2 boot to Linux from EFI and grub with IMR
registers enabled around the compressed kernel image and boot params data
structure.

The purpose of the IMRs around the compressed kernel and boot params data
structure is to ensure that no spurious data writes from any agent within
the Quark system can corrupt the kernel/boot-params data during boot.

The kernel needs to tear-down the IMRs placed around the compressed kernel
image and boot-params data structure since the EFI memory map marks the two
regions of memory as usable memory and the kernel will happily reuse these
memory regions. Without tearing down the boot-time IMRs drivers run the
significant risk of violating one of the stale IMRs since dma_alloc_coherent
can hand addresses to DMA capable south cluster peripherals such as the SD,
Ethernet, USB host/device, which will then cause an IMR access violation
when a DMA read/write occurs to the address ranges in question.

Since the Quark EFI bringup code configures the system to reset on an IMR
violation, this means that common operations such as mouting an SD based
root filesystem, communicating with a USB device or sending Ethernet traffic
can cause an immediate system reset.

IMR usage during system boot on Galileo is detailed in
Quark_SecureBoot_PRM_330234_001.pdf. This document details each IMR used
during the boot process and the data being protected by that IMR. The kernel
needs tidy-up IMRs used during the boot process to ensure an IMR violation
doesn't cause a system reset.

This platform code does two things.

Firstly it tears down the boot-time IMRs used to protect the compressed
kernel image and boot params data structure.

Secondly it sets up an IMR around the kernel's text section from &_sinittext
- &_text ensuring that on the CPU in non-SMM mode can read/write this
address range. A spurious DMA write to the kernel's .text section will
then cause an IMR violation and system reset, consistent with the current
Galileo BSP behaviour.

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 drivers/platform/x86/Kconfig         |  15 +++
 drivers/platform/x86/Makefile        |   1 +
 drivers/platform/x86/intel_galileo.c | 175 +++++++++++++++++++++++++++++++++++
 3 files changed, 191 insertions(+)
 create mode 100644 drivers/platform/x86/intel_galileo.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 638e7970..e384dcd 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -804,6 +804,21 @@ config INTEL_OAKTRAIL
 	  enable/disable the Camera, WiFi, BT etc. devices. If in doubt, say Y
 	  here; it will only load on supported platforms.
 
+config INTEL_GALILEO
+	bool "Intel Galileo Platform Support"
+	depends on X86_32 && PCI
+	select IOSF_MBI
+	select IMR
+	---help---
+	  Intel Galileo platform support. This code is used to tear-down
+	  BIOS and Grub Isolated Memory Regions used during bootup.
+	  This sanitises the IMR memory map to agree with the EFI/e820
+	  memory map, without this code your IMR memory map will conflict
+	  with the EFI memory map and it's highly likely DMA accesses initiated
+	  by Ethernet, SD and/or USB will result in a system reset.
+
+	  If in doubt, say Y here, the code will only run on a Galileo Gen1/Gen2
+
 config SAMSUNG_Q10
 	tristate "Samsung Q10 Extras"
 	depends on ACPI
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index f82232b..a0c013d 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_SAMSUNG_LAPTOP)	+= samsung-laptop.o
 obj-$(CONFIG_MXM_WMI)		+= mxm-wmi.o
 obj-$(CONFIG_INTEL_MID_POWER_BUTTON)	+= intel_mid_powerbtn.o
 obj-$(CONFIG_INTEL_OAKTRAIL)	+= intel_oaktrail.o
+obj-$(CONFIG_INTEL_GALILEO)	+= intel_galileo.o
 obj-$(CONFIG_SAMSUNG_Q10)	+= samsung-q10.o
 obj-$(CONFIG_APPLE_GMUX)	+= apple-gmux.o
 obj-$(CONFIG_INTEL_RST)		+= intel-rst.o
diff --git a/drivers/platform/x86/intel_galileo.c b/drivers/platform/x86/intel_galileo.c
new file mode 100644
index 0000000..2a555aa
--- /dev/null
+++ b/drivers/platform/x86/intel_galileo.c
@@ -0,0 +1,175 @@
+/*
+ * intel_galileo.c - Intel Galileo platform support.
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ * Copyright(c) 2014 Bryan O'Donoghue <pure.logic@nexus-software.ie>
+ *
+ * This platform code provides an entry point to do Galileo specific
+ * setup. Critically IMRs are policed to ensure the EFI provided memory
+ * map informing the kernel of it's available memory is consistent with
+ * the IMR lock-down
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
+#include <asm-generic/sections.h>
+#include <asm/imr.h>
+#include <asm/intel-quark.h>
+#include <linux/dmi.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
+enum {
+	GALILEO_UNKNOWN = 0,
+	GALILEO_QRK_GEN1,
+	GALILEO_QRK_GEN2,
+};
+
+static struct dmi_system_id galileo_baseboards[] = {
+	{
+		.ident = "Galileo",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
+			DMI_MATCH(DMI_BOARD_NAME, "Galileo"),
+		},
+		.driver_data = (void *)GALILEO_QRK_GEN1,
+	},
+	{
+		.ident = "GalileoGen2",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
+			DMI_MATCH(DMI_BOARD_NAME, "GalileoGen2"),
+		},
+		.driver_data = (void *)GALILEO_QRK_GEN2,
+	},
+	{}
+};
+
+#ifdef DEBUG
+#define SANITY "IMR : sanity error "
+
+/**
+ * intel_galileo_imr_sanity
+ * Verify IMR sanity with some simple tests to verify
+ * overlap, zero sized allocations
+ *
+ * @base: Physical base address of the kernel text section
+ * @size: Extent of kernel memory to be covered from &_text to &_sinittext
+ * @return: none
+ */
+static void __init
+intel_galileo_imr_sanity(unsigned long base, unsigned long size)
+{
+	/* Test zero zero */
+	if (imr_add(0, 0, 0, 0, true) == 0)
+		pr_err(SANITY "zero sized IMR @ 0x00000000\n");
+
+	/* Test overlap */
+	if (imr_add(base, size, IMR_NON_SMM, IMR_NON_SMM, true) == 0)
+		pr_err(SANITY "overlapped IMR @ (0x%08lx - 0x%08lx)\n",
+		       base, base + size);
+
+	/* Try overlap - IMR_ALIGN */
+	base = base + size - IMR_ALIGN;
+	if (imr_add(base, size, IMR_NON_SMM, IMR_NON_SMM, true) == 0)
+		pr_err(SANITY "overlapped IMR @ (0x%08lx - 0x%08lx)\n",
+		       base, base + size);
+}
+#endif
+
+/**
+ * intel_galileo_imr_init
+ *
+ * Tear down IMRs used during bootup. BIOS and Grub
+ * both setup IMRs around compressed kernel, initrd memory
+ * that need to be removed before the kernel hands out one
+ * of the IMR encased addresses to a downstream DMA agent
+ * such as the SD or Ethernet. IMRs on Galileo are setup to
+ * immediately reset the system on violation - so if you're
+ * running a root filesystem from SD - you'll need the IMRs
+ * torn down or you'll find seemingly random resets when using
+ * your filesystem.
+ */
+static void __init intel_galileo_imr_init(void)
+{
+	unsigned long base  = virt_to_phys(&_text);
+	unsigned long size = virt_to_phys(&_sinittext) - base - IMR_ALIGN;
+	int i, ret;
+
+	/* Tear down all existing unlocked IMRs */
+	for (i = 0; i <= QUARK_X1000_IMR_NUM; i++)
+		imr_del(i, 0, 0);
+
+	/*
+	 * Setup an IMR around the physical extent of the kernel
+	 * Non-SMM mode core read/write from/to kernel physical region.
+	 * IMR locked.
+	 */
+	ret = imr_add(base, size, IMR_NON_SMM, IMR_NON_SMM, true);
+	if (ret)
+		pr_err("Unable to setup IMR for kernel: (%p - %p)\n",
+			&_text, &__init_begin);
+	else
+		pr_info("IMR protect kernel memory: %ldk (%p - %p)\n",
+			size >> 10, &_text, &__init_begin);
+#ifdef DEBUG
+	intel_galileo_imr_sanity(base, size);
+#endif
+}
+
+/**
+ * intel_galileo_init
+ *
+ * Identify a Galileo Gen1 or Gen2. If found run code to sanitise the
+ * kernel memory space of IMRs that are inconsistent with the EFI memory map.
+ */
+static int __init intel_galileo_init(void)
+{
+	int ret = 0, type = GALILEO_UNKNOWN;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	const struct dmi_system_id *system_id;
+
+	if (!cpu_is_quark(c))
+		return -ENODEV;
+
+	system_id = dmi_first_match(galileo_baseboards);
+
+	/* BIOS releases 0.7.5 and 0.8.0 do not provide DMI strings */
+	if (system_id != NULL) {
+		type = (int)system_id->driver_data;
+	} else {
+		pr_info("Galileo Gen1 BIOS version <= 0.8.0\n");
+		type = GALILEO_QRK_GEN1;
+	}
+
+	switch (type) {
+	case GALILEO_QRK_GEN1:
+	case GALILEO_QRK_GEN2:
+		intel_galileo_imr_init();
+		break;
+	default:
+		ret = -ENODEV;
+	}
+
+	return ret;
+}
+
+static void __exit intel_galileo_exit(void)
+{
+}
+
+module_init(intel_galileo_init);
+module_exit(intel_galileo_exit);
+
+MODULE_AUTHOR("Bryan O'Donoghue <pure.logic@nexus-software.ie>");
+MODULE_DESCRIPTION("Intel Galileo platform driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

