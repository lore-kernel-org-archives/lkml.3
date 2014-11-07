Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaKGN2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:28:54 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58294 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaKGN2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:28:19 -0500
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, bhelgaas@google.com,
        Liviu.Dudau@arm.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rjw@rjwysocki.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [RFC PATCH 3/4] arm64, acpi, pci: Add arch specific functions for mmconfig driver.
Date: Fri,  7 Nov 2014 14:27:55 +0100
Message-Id: <1415366876-30811-4-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These calls allow to map/unmap PCI config space ranges (which are specified in
MMCFG ACPI table).

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 arch/arm64/Kconfig           |  3 ++
 arch/arm64/kernel/Makefile   |  1 +
 arch/arm64/kernel/mmconfig.c | 69 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)
 create mode 100644 arch/arm64/kernel/mmconfig.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index aee6a60..f2bcb58 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -186,6 +186,9 @@ config PCI_DOMAINS_GENERIC
 config PCI_SYSCALL
 	def_bool PCI
 
+config PCI_MMCONFIG
+	def_bool PCI && ACPI
+
 source "drivers/pci/Kconfig"
 source "drivers/pci/pcie/Kconfig"
 source "drivers/pci/hotplug/Kconfig"
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index f48e3f7..ec576e6 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -32,6 +32,7 @@ arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
 arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
 arm64-obj-$(CONFIG_PCI)			+= pci.o
 arm64-obj-$(CONFIG_ACPI)		+= acpi.o
+arm64-obj-$(CONFIG_PCI_MMCONFIG)		+= mmconfig.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/mmconfig.c b/arch/arm64/kernel/mmconfig.c
new file mode 100644
index 0000000..b0ca0ec
--- /dev/null
+++ b/arch/arm64/kernel/mmconfig.c
@@ -0,0 +1,69 @@
+/*
+ * mmconfig.c - Low-level direct PCI config space access via MMCONFIG
+ *
+ * This is an ARM64 version that allows the mmconfig space to be mapped.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/mmconfig.h>
+
+#define PREFIX "PCI: "
+
+static void __iomem *mcfg_ioremap(struct pci_mmcfg_region *cfg)
+{
+	void __iomem *addr;
+	u64 start, size;
+	int num_buses;
+
+	start = cfg->address + PCI_MMCFG_BUS_OFFSET(cfg->start_bus);
+	num_buses = cfg->end_bus - cfg->start_bus + 1;
+	size = PCI_MMCFG_BUS_OFFSET(num_buses);
+	addr = ioremap_nocache(start, size);
+	if (addr)
+		addr -= PCI_MMCFG_BUS_OFFSET(cfg->start_bus);
+	return addr;
+}
+
+int __init pci_mmcfg_arch_init(void)
+{
+	struct pci_mmcfg_region *cfg;
+
+	list_for_each_entry(cfg, &pci_mmcfg_list, list)
+		if (pci_mmcfg_arch_map(cfg)) {
+			pci_mmcfg_arch_free();
+			return 0;
+		}
+
+	return 1;
+}
+
+void __init pci_mmcfg_arch_free(void)
+{
+	struct pci_mmcfg_region *cfg;
+
+	list_for_each_entry(cfg, &pci_mmcfg_list, list)
+		pci_mmcfg_arch_unmap(cfg);
+}
+
+int pci_mmcfg_arch_map(struct pci_mmcfg_region *cfg)
+{
+	cfg->virt = mcfg_ioremap(cfg);
+	if (!cfg->virt) {
+		pr_err(PREFIX "can't map MMCONFIG at %pR\n", &cfg->res);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void pci_mmcfg_arch_unmap(struct pci_mmcfg_region *cfg)
+{
+	if (cfg && cfg->virt) {
+		iounmap(cfg->virt + PCI_MMCFG_BUS_OFFSET(cfg->start_bus));
+		cfg->virt = NULL;
+	}
+}
-- 
1.9.1

