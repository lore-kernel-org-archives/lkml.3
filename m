Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaF3Cxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 22:53:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:12169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbaF3Cxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 22:53:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="555058176"
Message-ID: <53B0D139.6010401@linux.intel.com>
Date: Mon, 30 Jun 2014 10:53:45 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Adam Williamson <awilliam@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 1/3] X86 platform: New Intel Atom SOC power management,
 controller driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Power Management Controller (PMC) controls many of the power
management features present in the Atom SoC. This driver provides
a native power off function via PMC PCI IO port.

On some ACPI hardware-reduced platforms(e.g. ASUS-T100), ACPI sleep
registers are not valid so that (*pm_power_off)() is not hooked by
acpi_power_off(). The power off function in this driver is installed
only when pm_power_off is NULL.

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Signed-off-by: Lejun Zhu <lejun.zhu@linux.intel.com>
---
 arch/x86/Kconfig                |    4 ++
 arch/x86/include/asm/pmc_atom.h |   31 ++++++++++++
 arch/x86/kernel/Makefile        |    1 +
 arch/x86/kernel/pmc_atom.c      |  104 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 140 insertions(+)
 create mode 100644 arch/x86/include/asm/pmc_atom.h
 create mode 100644 arch/x86/kernel/pmc_atom.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..6295a21 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2403,6 +2403,10 @@ config IOSF_MBI
 	default m
 	depends on PCI
 +config PMC_ATOM
+	def_bool y
+        depends on PCI
+
 source "net/Kconfig"
  source "drivers/Kconfig"
diff --git a/arch/x86/include/asm/pmc_atom.h b/arch/x86/include/asm/pmc_atom.h
new file mode 100644
index 0000000..03a2769
--- /dev/null
+++ b/arch/x86/include/asm/pmc_atom.h
@@ -0,0 +1,31 @@
+/*
+ * Intel Atom SOC Power Management Controller Header File
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef PMC_ATOM_H
+#define PMC_ATOM_H
+
+/* ValleyView Power Control Unit PCI Device ID */
+#define	PCI_DEVICE_ID_VLV_PMC	0x0F1C
+
+/* PMC I/O Registers */
+#define	ACPI_BASE_ADDR_OFFSET	0x40
+#define	ACPI_BASE_ADDR_MASK	0xFFFFFE00
+#define	ACPI_MMIO_REG_LEN	0x100
+
+#define	PM1_CNT			0x4
+#define	SLEEP_TYPE_MASK		0xFFFFECFF
+#define	SLEEP_TYPE_S5		0x1C00
+#define	SLEEP_ENABLE		0x2000
+#endif /* PMC_ATOM_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 047f9ff..bde3993 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_EFI)			+= sysfb_efi.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
 obj-$(CONFIG_IOSF_MBI)			+= iosf_mbi.o
+obj-$(CONFIG_PMC_ATOM)			+= pmc_atom.o
  ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
new file mode 100644
index 0000000..9eb79f6
--- /dev/null
+++ b/arch/x86/kernel/pmc_atom.c
@@ -0,0 +1,104 @@
+/*
+ * Intel Atom SOC Power Management Controller Driver
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/io.h>
+
+#include <asm/pmc_atom.h>
+
+static u32 acpi_base_addr;
+
+static void pmc_power_off(void)
+{
+	u16	pm1_cnt_port;
+	u32	pm1_cnt_value;
+
+	pr_info("Preparing to enter system sleep state S5\n");
+
+	pm1_cnt_port = acpi_base_addr + PM1_CNT;
+
+	pm1_cnt_value = inl(pm1_cnt_port);
+	pm1_cnt_value &= SLEEP_TYPE_MASK;
+	pm1_cnt_value |= SLEEP_TYPE_S5;
+	pm1_cnt_value |= SLEEP_ENABLE;
+
+	outl(pm1_cnt_value, pm1_cnt_port);
+}
+
+static int pmc_setup_dev(struct pci_dev *pdev)
+{
+	/* Obtain ACPI base address */
+	pci_read_config_dword(pdev, ACPI_BASE_ADDR_OFFSET, &acpi_base_addr);
+	acpi_base_addr &= ACPI_BASE_ADDR_MASK;
+
+	/* Install power off function */
+	if (acpi_base_addr != 0 && pm_power_off == NULL)
+		pm_power_off = pmc_power_off;
+
+	return 0;
+}
+
+/*
+ * Data for PCI driver interface
+ *
+ * This data only exists for exporting the supported
+ * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
+ * register a pci_driver, because lpc_ich will register
+ * a driver on the same PCI id.
+ */
+static const struct pci_device_id pmc_pci_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_VLV_PMC) },
+	{ 0, },
+};
+
+MODULE_DEVICE_TABLE(pci, pmc_pci_ids);
+
+static int __init pmc_atom_init(void)
+{
+	int err = -ENODEV;
+	struct pci_dev *pdev = NULL;
+	const struct pci_device_id *ent;
+
+	/* We look for our device - PCU PMC
+	 * we assume that there is max. one device.
+	 *
+	 * We can't use plain pci_driver mechanism,
+	 * as the device is really a multiple function device,
+	 * main driver that binds to the pci_device is lpc_ich
+	 * and have to find & bind to the device this way.
+	 */
+	for_each_pci_dev(pdev) {
+		ent = pci_match_id(pmc_pci_ids, pdev);
+		if (ent) {
+			err = pmc_setup_dev(pdev);
+			goto out;
+		}
+	}
+	/* Device not found. */
+out:
+	return err;
+}
+
+module_init(pmc_atom_init);
+/* no module_exit, this driver shouldn't be unloaded */
+
+MODULE_AUTHOR("Aubrey Li <aubrey.li@linux.intel.com>");
+MODULE_DESCRIPTION("Intel Atom SOC Power Management Controller Interface");
+MODULE_LICENSE("GPL v2");
-- 
1.7.10.4
