Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113AbaGXNBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:01:42 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:64538 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759092AbaGXNBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:01:40 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 05/19] ARM64 / ACPI: Make PCI optional for ACPI on ARM64
Date: Thu, 24 Jul 2014 21:00:11 +0800
Message-Id: <1406206825-15590-6-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As PCI for ARM64 is not ready, so introduce some stub functions
to make PCI optional for ACPI, and make ACPI core run without
CONFIG_PCI on ARM64.

Since ACPI on X86 and IA64 depends on PCI and this patch only makes
PCI optinal for ARM64, it will not break anything on X86 and IA64.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/pci.h |   11 +++++++++++
 drivers/acpi/Makefile        |    2 +-
 drivers/acpi/internal.h      |    5 +++++
 include/linux/pci.h          |   37 +++++++++++++++++++++++++++----------
 4 files changed, 44 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm64/include/asm/pci.h

diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
new file mode 100644
index 0000000..250cd24
--- /dev/null
+++ b/arch/arm64/include/asm/pci.h
@@ -0,0 +1,11 @@
+#ifndef __ASM_PCI_H
+#define __ASM_PCI_H
+#ifdef __KERNEL__
+
+/*
+ * PCI address space differs from physical memory address space
+ */
+#define PCI_DMA_BUS_IS_PHYS	(0)
+
+#endif  /* __KERNEL__ */
+#endif  /* __ASM_PCI_H */
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 505d4d7..8e9bbe6 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -39,7 +39,7 @@ acpi-y				+= processor_core.o
 acpi-$(CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC) += processor_pdc.o
 acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
-acpi-y				+= pci_root.o pci_link.o pci_irq.o
+acpi-$(CONFIG_PCI)		+= pci_root.o pci_link.o pci_irq.o
 acpi-y				+= acpi_lpss.o
 acpi-y				+= acpi_platform.o
 acpi-y				+= acpi_pnp.o
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 4c5cf77..e1e6487 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -26,8 +26,13 @@
 acpi_status acpi_os_initialize1(void);
 int init_acpi_device_notify(void);
 int acpi_scan_init(void);
+#ifdef CONFIG_PCI
 void acpi_pci_root_init(void);
 void acpi_pci_link_init(void);
+#else
+static inline void acpi_pci_root_init(void) {}
+static inline void acpi_pci_link_init(void) {}
+#endif
 void acpi_processor_init(void);
 void acpi_platform_init(void);
 void acpi_pnp_init(void);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 466bcd1..27d7354 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -558,15 +558,6 @@ struct pci_ops {
 	int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
 };
 
-/*
- * ACPI needs to be able to access PCI config space before we've done a
- * PCI bus scan and created pci_bus structures.
- */
-int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
-		 int reg, int len, u32 *val);
-int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
-		  int reg, int len, u32 val);
-
 struct pci_bus_region {
 	dma_addr_t start;
 	dma_addr_t end;
@@ -1293,6 +1284,16 @@ typedef int (*arch_set_vga_state_t)(struct pci_dev *pdev, bool decode,
 		      unsigned int command_bits, u32 flags);
 void pci_register_set_vga_state(arch_set_vga_state_t func);
 
+/*
+ * ACPI needs to be able to access PCI config space before we've done a
+ * PCI bus scan and created pci_bus structures.
+ */
+int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
+		 int reg, int len, u32 *val);
+int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
+		  int reg, int len, u32 val);
+void pcibios_penalize_isa_irq(int irq, int active);
+
 #else /* CONFIG_PCI is not enabled */
 
 /*
@@ -1394,6 +1395,23 @@ static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
 						unsigned int devfn)
 { return NULL; }
 
+static inline struct pci_bus *pci_find_bus(int domain, int busnr)
+{ return NULL; }
+
+static inline int pci_bus_write_config_byte(struct pci_bus *bus,
+				unsigned int devfn, int where, u8 val)
+{ return -ENODEV; }
+
+static inline int raw_pci_read(unsigned int domain, unsigned int bus,
+			unsigned int devfn, int reg, int len, u32 *val)
+{ return -EINVAL; }
+
+static inline int raw_pci_write(unsigned int domain, unsigned int bus,
+			unsigned int devfn, int reg, int len, u32 val)
+{ return -EINVAL; }
+
+static inline void pcibios_penalize_isa_irq(int irq, int active) { }
+
 static inline int pci_domain_nr(struct pci_bus *bus) { return 0; }
 static inline struct pci_dev *pci_dev_get(struct pci_dev *dev) { return NULL; }
 
@@ -1597,7 +1615,6 @@ int pcibios_set_pcie_reset_state(struct pci_dev *dev,
 				 enum pcie_reset_state state);
 int pcibios_add_device(struct pci_dev *dev);
 void pcibios_release_device(struct pci_dev *dev);
-void pcibios_penalize_isa_irq(int irq, int active);
 
 #ifdef CONFIG_HIBERNATE_CALLBACKS
 extern struct dev_pm_ops pcibios_pm_ops;
-- 
1.7.9.5

