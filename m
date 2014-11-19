Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbaKSQFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:05:46 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56949 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbaKSQFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:05:41 -0500
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, bhelgaas@google.com,
        lorenzo.pieralisi@arm.com, wangyijing@huawei.com, arnd@arndb.de,
        hanjun.guo@linaro.org, Liviu.Dudau@arm.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rjw@rjwysocki.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH 5/6] x86, acpi, pci: mmconfig_64.c becomes default implementation for arch agnostic low-level direct PCI config space accessors via MMCONFIG.
Date: Wed, 19 Nov 2014 17:04:50 +0100
Message-Id: <1416413091-13452-6-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that x86 32bits machines still have its own low-level direct
PCI config space accessors.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 arch/x86/pci/Makefile      |   5 +-
 arch/x86/pci/mmconfig_64.c | 152 ---------------------------------------------
 drivers/acpi/mmconfig.c    | 134 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 138 insertions(+), 153 deletions(-)
 delete mode 100644 arch/x86/pci/mmconfig_64.c

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 5c6fc35..35c765b 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -1,7 +1,10 @@
 obj-y				:= i386.o init.o
 
 obj-$(CONFIG_PCI_BIOS)		+= pcbios.o
-obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_$(BITS).o direct.o mmconfig-shared.o
+obj-$(CONFIG_PCI_MMCONFIG)	+= direct.o mmconfig-shared.o
+ifeq ($(BITS),32)
+obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_32.o
+endif
 obj-$(CONFIG_PCI_DIRECT)	+= direct.o
 obj-$(CONFIG_PCI_OLPC)		+= olpc.o
 obj-$(CONFIG_PCI_XEN)		+= xen.o
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
deleted file mode 100644
index ff2c50c..0000000
--- a/arch/x86/pci/mmconfig_64.c
+++ /dev/null
@@ -1,152 +0,0 @@
-/*
- * mmconfig.c - Low-level direct PCI config space access via MMCONFIG
- *
- * This is an 64bit optimized version that always keeps the full mmconfig
- * space mapped. This allows lockless config space operation.
- */
-
-#include <linux/pci.h>
-#include <linux/init.h>
-#include <linux/acpi.h>
-#include <linux/bitmap.h>
-#include <linux/rcupdate.h>
-#include <linux/mmconfig.h>
-#include <asm/e820.h>
-#include <asm/pci_x86.h>
-
-#define PREFIX "PCI: "
-
-static char __iomem *pci_dev_base(unsigned int seg, unsigned int bus, unsigned int devfn)
-{
-	struct pci_mmcfg_region *cfg = pci_mmconfig_lookup(seg, bus);
-
-	if (cfg && cfg->virt)
-		return cfg->virt + (PCI_MMCFG_BUS_OFFSET(bus) | (devfn << 12));
-	return NULL;
-}
-
-int pci_mmcfg_read(unsigned int seg, unsigned int bus,
-			  unsigned int devfn, int reg, int len, u32 *value)
-{
-	char __iomem *addr;
-
-	/* Why do we have this when nobody checks it. How about a BUG()!? -AK */
-	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095))) {
-err:		*value = -1;
-		return -EINVAL;
-	}
-
-	rcu_read_lock();
-	addr = pci_dev_base(seg, bus, devfn);
-	if (!addr) {
-		rcu_read_unlock();
-		goto err;
-	}
-
-	switch (len) {
-	case 1:
-		*value = mmio_config_readb(addr + reg);
-		break;
-	case 2:
-		*value = mmio_config_readw(addr + reg);
-		break;
-	case 4:
-		*value = mmio_config_readl(addr + reg);
-		break;
-	}
-	rcu_read_unlock();
-
-	return 0;
-}
-
-int pci_mmcfg_write(unsigned int seg, unsigned int bus,
-			   unsigned int devfn, int reg, int len, u32 value)
-{
-	char __iomem *addr;
-
-	/* Why do we have this when nobody checks it. How about a BUG()!? -AK */
-	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095)))
-		return -EINVAL;
-
-	rcu_read_lock();
-	addr = pci_dev_base(seg, bus, devfn);
-	if (!addr) {
-		rcu_read_unlock();
-		return -EINVAL;
-	}
-
-	switch (len) {
-	case 1:
-		mmio_config_writeb(addr + reg, value);
-		break;
-	case 2:
-		mmio_config_writew(addr + reg, value);
-		break;
-	case 4:
-		mmio_config_writel(addr + reg, value);
-		break;
-	}
-	rcu_read_unlock();
-
-	return 0;
-}
-
-const struct pci_raw_ops pci_mmcfg = {
-	.read =		pci_mmcfg_read,
-	.write =	pci_mmcfg_write,
-};
-
-static void __iomem *mcfg_ioremap(struct pci_mmcfg_region *cfg)
-{
-	void __iomem *addr;
-	u64 start, size;
-	int num_buses;
-
-	start = cfg->address + PCI_MMCFG_BUS_OFFSET(cfg->start_bus);
-	num_buses = cfg->end_bus - cfg->start_bus + 1;
-	size = PCI_MMCFG_BUS_OFFSET(num_buses);
-	addr = ioremap_nocache(start, size);
-	if (addr)
-		addr -= PCI_MMCFG_BUS_OFFSET(cfg->start_bus);
-	return addr;
-}
-
-int __init pci_mmcfg_arch_init(void)
-{
-	struct pci_mmcfg_region *cfg;
-
-	list_for_each_entry(cfg, &pci_mmcfg_list, list)
-		if (pci_mmcfg_arch_map(cfg)) {
-			pci_mmcfg_arch_free();
-			return 0;
-		}
-
-	return 1;
-}
-
-void __init pci_mmcfg_arch_free(void)
-{
-	struct pci_mmcfg_region *cfg;
-
-	list_for_each_entry(cfg, &pci_mmcfg_list, list)
-		pci_mmcfg_arch_unmap(cfg);
-}
-
-int pci_mmcfg_arch_map(struct pci_mmcfg_region *cfg)
-{
-	cfg->virt = mcfg_ioremap(cfg);
-	if (!cfg->virt) {
-		pr_err(PREFIX "can't map MMCONFIG at %pR\n", &cfg->res);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-void pci_mmcfg_arch_unmap(struct pci_mmcfg_region *cfg)
-{
-	if (cfg && cfg->virt) {
-		iounmap(cfg->virt + PCI_MMCFG_BUS_OFFSET(cfg->start_bus));
-		cfg->virt = NULL;
-	}
-}
diff --git a/drivers/acpi/mmconfig.c b/drivers/acpi/mmconfig.c
index d62dccda..c0ad05f 100644
--- a/drivers/acpi/mmconfig.c
+++ b/drivers/acpi/mmconfig.c
@@ -12,14 +12,148 @@
 
 #include <linux/mutex.h>
 #include <linux/rculist.h>
+#include <linux/pci.h>
 #include <linux/mmconfig.h>
 
+#include <asm/pci.h>
+
 #define PREFIX "PCI: "
 
 static DEFINE_MUTEX(pci_mmcfg_lock);
 
 LIST_HEAD(pci_mmcfg_list);
 
+static char __iomem *pci_dev_base(unsigned int seg, unsigned int bus,
+				  unsigned int devfn)
+{
+	struct pci_mmcfg_region *cfg = pci_mmconfig_lookup(seg, bus);
+
+	if (cfg && cfg->virt)
+		return cfg->virt + (PCI_MMCFG_BUS_OFFSET(bus) | (devfn << 12));
+	return NULL;
+}
+
+int __weak pci_mmcfg_read(unsigned int seg, unsigned int bus,
+			  unsigned int devfn, int reg, int len, u32 *value)
+{
+	char __iomem *addr;
+
+	/* Why do we have this when nobody checks it. How about a BUG()!? -AK */
+	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095))) {
+err:		*value = -1;
+		return -EINVAL;
+	}
+
+	rcu_read_lock();
+	addr = pci_dev_base(seg, bus, devfn);
+	if (!addr) {
+		rcu_read_unlock();
+		goto err;
+	}
+
+	switch (len) {
+	case 1:
+		*value = mmio_config_readb(addr + reg);
+		break;
+	case 2:
+		*value = mmio_config_readw(addr + reg);
+		break;
+	case 4:
+		*value = mmio_config_readl(addr + reg);
+		break;
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
+int __weak pci_mmcfg_write(unsigned int seg, unsigned int bus,
+			   unsigned int devfn, int reg, int len, u32 value)
+{
+	char __iomem *addr;
+
+	/* Why do we have this when nobody checks it. How about a BUG()!? -AK */
+	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095)))
+		return -EINVAL;
+
+	rcu_read_lock();
+	addr = pci_dev_base(seg, bus, devfn);
+	if (!addr) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	switch (len) {
+	case 1:
+		mmio_config_writeb(addr + reg, value);
+		break;
+	case 2:
+		mmio_config_writew(addr + reg, value);
+		break;
+	case 4:
+		mmio_config_writel(addr + reg, value);
+		break;
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
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
+int __init __weak pci_mmcfg_arch_init(void)
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
+void __init __weak pci_mmcfg_arch_free(void)
+{
+	struct pci_mmcfg_region *cfg;
+
+	list_for_each_entry(cfg, &pci_mmcfg_list, list)
+		pci_mmcfg_arch_unmap(cfg);
+}
+
+int __weak pci_mmcfg_arch_map(struct pci_mmcfg_region *cfg)
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
+void __weak pci_mmcfg_arch_unmap(struct pci_mmcfg_region *cfg)
+{
+	if (cfg && cfg->virt) {
+		iounmap(cfg->virt + PCI_MMCFG_BUS_OFFSET(cfg->start_bus));
+		cfg->virt = NULL;
+	}
+}
+
 static void __init pci_mmconfig_remove(struct pci_mmcfg_region *cfg)
 {
 	if (cfg->res.parent)
-- 
1.9.1

