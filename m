Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbaCFDyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 22:54:50 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:13911 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbaCFDy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 22:54:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiAEAKzwF1Ol5H4JgWdsb2JhbABahkxSuh2Dc4ExDgEBFiYogiYBBSMECwFGEAgdAiYCAlcQCYd5rhagaxeBKY0oB4JvgUkEiF6FaoYKg2uVbCg
From: Alistair Popple <alistair@popple.id.au>
To: benh@kernel.crashing.org
Cc: Alistair Popple <alistair@popple.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 5/5] powerpc: Added PCI MSI support using the HSTA module
Date: Thu,  6 Mar 2014 14:52:28 +1100
Message-Id: <1394077948-8395-6-git-send-email-alistair@popple.id.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394077948-8395-1-git-send-email-alistair@popple.id.au>
References: <1394077948-8395-1-git-send-email-alistair@popple.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PPC476GTR SoC supports message signalled interrupts (MSI) by writing
to special addresses within the High Speed Transfer Assist (HSTA) module.

This patch adds support for PCI MSI with a new system device. The DMA
window is also updated to allow access to the entire 42-bit address range
to allow PCI devices write access to the HSTA module.

Signed-off-by: Alistair Popple <alistair@popple.id.au>
---
 .../devicetree/bindings/powerpc/4xx/hsta.txt       |  19 ++
 arch/powerpc/boot/dts/akebono.dts                  |  46 ++++-
 arch/powerpc/boot/treeboot-akebono.c               |  15 --
 arch/powerpc/platforms/44x/Kconfig                 |   2 +
 arch/powerpc/sysdev/Kconfig                        |   6 +
 arch/powerpc/sysdev/Makefile                       |   1 +
 arch/powerpc/sysdev/ppc4xx_hsta_msi.c              | 215 +++++++++++++++++++++
 arch/powerpc/sysdev/ppc4xx_pci.c                   |   8 +-
 8 files changed, 287 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/powerpc/4xx/hsta.txt
 create mode 100644 arch/powerpc/sysdev/ppc4xx_hsta_msi.c

diff --git a/Documentation/devicetree/bindings/powerpc/4xx/hsta.txt b/Documentation/devicetree/bindings/powerpc/4xx/hsta.txt
new file mode 100644
index 0000000..c737c83
--- /dev/null
+++ b/Documentation/devicetree/bindings/powerpc/4xx/hsta.txt
@@ -0,0 +1,19 @@
+
+ppc476gtr High Speed Serial Assist (HSTA) node
+==============================================
+
+The 476gtr SoC contains a high speed serial assist module attached
+between the plb4 and plb6 system buses to provide high speed data
+transfer between memory and system peripherals as well as support for
+PCI message signalled interrupts.
+
+Currently only the MSI support is used by Linux using the following
+device tree entries:
+
+Require properties:
+- compatible		: "ibm,476gtr-hsta-msi", "ibm,hsta-msi"
+- reg			: register mapping for the HSTA MSI space
+- interrupt-parent	: parent controller for mapping interrupts
+- interrupts		: ordered interrupt mapping for each MSI in the register
+			  space. The first interrupt should be associated with a
+			  register offset of 0x00, the second to 0x10, etc.
diff --git a/arch/powerpc/boot/dts/akebono.dts b/arch/powerpc/boot/dts/akebono.dts
index 96ac13b..f92ecfe 100644
--- a/arch/powerpc/boot/dts/akebono.dts
+++ b/arch/powerpc/boot/dts/akebono.dts
@@ -82,6 +82,28 @@
 		ranges;
 		clock-frequency = <200000000>; // 200Mhz
 
+		HSTA0: hsta@310000e0000 {
+			compatible = "ibm,476gtr-hsta-msi", "ibm,hsta-msi";
+			reg = <0x310 0x000e0000 0x0 0xf0>;
+			interrupt-parent = <&MPIC>;
+			interrupts = <108 0
+				      109 0
+				      110 0
+				      111 0
+				      112 0
+				      113 0
+				      114 0
+				      115 0
+				      116 0
+				      117 0
+				      118 0
+				      119 0
+				      120 0
+				      121 0
+				      122 0
+				      123 0>;
+		};
+
 		MAL0: mcmal {
 			compatible = "ibm,mcmal-476gtr", "ibm,mcmal2";
 			dcr-reg = <0xc0000000 0x062>;
@@ -242,8 +264,10 @@
 			ranges = <0x02000000 0x00000000 0x80000000 0x00000110 0x80000000 0x0 0x80000000
 			          0x01000000 0x0        0x0        0x00000140 0x0        0x0 0x00010000>;
 
-			/* Inbound starting at 0 to memsize filled in by zImage */
-			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x0>;
+			/* Inbound starting at 0x0 to 0x40000000000. In order to use MSI
+			 * PCI devices must be able to write to the HSTA module.
+			 */
+			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x400 0x0>;
 
 			/* This drives busses 0 to 0xf */
 			bus-range = <0x0 0xf>;
@@ -280,8 +304,10 @@
 			ranges = <0x02000000 0x00000000 0x80000000 0x00000210 0x80000000 0x0 0x80000000
 			          0x01000000 0x0        0x0        0x00000240 0x0        0x0 0x00010000>;
 
-			/* Inbound starting at 0 to memsize filled in by zImage */
-			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x0>;
+			/* Inbound starting at 0x0 to 0x40000000000. In order to use MSI
+			 * PCI devices must be able to write to the HSTA module.
+			 */
+			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x400 0x0>;
 
 			/* This drives busses 0 to 0xf */
 			bus-range = <0x0 0xf>;
@@ -318,8 +344,10 @@
 			ranges = <0x02000000 0x00000000 0x80000000 0x00000190 0x80000000 0x0 0x80000000
 			          0x01000000 0x0        0x0        0x000001c0 0x0        0x0 0x00010000>;
 
-			/* Inbound starting at 0 to memsize filled in by zImage */
-			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x0>;
+			/* Inbound starting at 0x0 to 0x40000000000. In order to use MSI
+			 * PCI devices must be able to write to the HSTA module.
+			 */
+			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x400 0x0>;
 
 			/* This drives busses 0 to 0xf */
 			bus-range = <0x0 0xf>;
@@ -356,8 +384,10 @@
 			ranges = <0x02000000 0x00000000 0x80000000 0x00000290 0x80000000 0x0 0x80000000
 			          0x01000000 0x0        0x0        0x000002c0 0x0        0x0 0x00010000>;
 
-			/* Inbound starting at 0 to memsize filled in by zImage */
-			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x0>;
+			/* Inbound starting at 0x0 to 0x40000000000. In order to use MSI
+			 * PCI devices must be able to write to the HSTA module.
+			 */
+			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x400 0x0>;
 
 			/* This drives busses 0 to 0xf */
 			bus-range = <0x0 0xf>;
diff --git a/arch/powerpc/boot/treeboot-akebono.c b/arch/powerpc/boot/treeboot-akebono.c
index 070a20f..b73174c 100644
--- a/arch/powerpc/boot/treeboot-akebono.c
+++ b/arch/powerpc/boot/treeboot-akebono.c
@@ -75,24 +75,9 @@ static void ibm_akebono_fixups(void)
 {
 	void *emac;
 	u32 reg;
-	void *devp = finddevice("/");
-	u32 dma_ranges[7];
 
 	dt_fixup_memory(0x0ULL,  ibm_akebono_memsize);
 
-	while ((devp = find_node_by_devtype(devp, "pci"))) {
-		if (getprop(devp, "dma-ranges", dma_ranges,
-			    sizeof(dma_ranges)) < 0) {
-			printf("%s: Failed to get dma-ranges\r\n", __func__);
-			continue;
-		}
-
-		dma_ranges[5] = ibm_akebono_memsize >> 32;
-		dma_ranges[6] = ibm_akebono_memsize & 0xffffffffUL;
-
-		setprop(devp, "dma-ranges", dma_ranges, sizeof(dma_ranges));
-	}
-
 	/* Fixup the SD timeout frequency */
 	mtdcrx(CCTL0_MCO4, 0x1);
 
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index b0202d8..8beec7d 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -206,6 +206,8 @@ config AKEBONO
 	select SWIOTLB
 	select 476FPE
 	select PPC4xx_PCI_EXPRESS
+	select PCI_MSI
+	select PPC4xx_HSTA_MSI
 	select I2C
 	select I2C_IBM_IIC
 	select NETDEVICES
diff --git a/arch/powerpc/sysdev/Kconfig b/arch/powerpc/sysdev/Kconfig
index 7baa70d..a19332a 100644
--- a/arch/powerpc/sysdev/Kconfig
+++ b/arch/powerpc/sysdev/Kconfig
@@ -7,6 +7,12 @@ config PPC4xx_PCI_EXPRESS
 	depends on PCI && 4xx
 	default n
 
+config PPC4xx_HSTA_MSI
+	bool
+	depends on PCI_MSI
+	depends on PCI && 4xx
+	default n
+
 config PPC4xx_MSI
 	bool
 	depends on PCI_MSI
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index afbcc37..f7cb2a1 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_OF_RTC)		+= of_rtc.o
 ifeq ($(CONFIG_PCI),y)
 obj-$(CONFIG_4xx)		+= ppc4xx_pci.o
 endif
+obj-$(CONFIG_PPC4xx_HSTA_MSI)	+= ppc4xx_hsta_msi.o
 obj-$(CONFIG_PPC4xx_MSI)	+= ppc4xx_msi.o
 obj-$(CONFIG_PPC4xx_CPM)	+= ppc4xx_cpm.o
 obj-$(CONFIG_PPC4xx_GPIO)	+= ppc4xx_gpio.o
diff --git a/arch/powerpc/sysdev/ppc4xx_hsta_msi.c b/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
new file mode 100644
index 0000000..11c8884
--- /dev/null
+++ b/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
@@ -0,0 +1,215 @@
+/*
+ * MSI support for PPC4xx SoCs using High Speed Transfer Assist (HSTA) for
+ * generation of the interrupt.
+ *
+ * Copyright © 2013 Alistair Popple <alistair@popple.id.au> IBM Corporation
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/msi.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/pci.h>
+#include <linux/semaphore.h>
+#include <asm/msi_bitmap.h>
+
+struct ppc4xx_hsta_msi {
+	struct device *dev;
+
+	/* The ioremapped HSTA MSI IO space */
+	u32 __iomem *data;
+
+	/* Physical address of HSTA MSI IO space */
+	u64 address;
+	struct msi_bitmap bmp;
+
+	/* An array mapping offsets to hardware IRQs */
+	int *irq_map;
+
+	/* Number of hwirqs supported */
+	int irq_count;
+};
+static struct ppc4xx_hsta_msi ppc4xx_hsta_msi;
+
+static int hsta_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	struct msi_msg msg;
+	struct msi_desc *entry;
+	int irq, hwirq;
+	u64 addr;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		irq = msi_bitmap_alloc_hwirqs(&ppc4xx_hsta_msi.bmp, 1);
+		if (irq < 0) {
+			pr_debug("%s: Failed to allocate msi interrupt\n",
+				 __func__);
+			return irq;
+		}
+
+		hwirq = ppc4xx_hsta_msi.irq_map[irq];
+		if (hwirq == NO_IRQ) {
+			pr_err("%s: Failed mapping irq %d\n", __func__, irq);
+			return -EINVAL;
+		}
+
+		/*
+		 * HSTA generates interrupts on writes to 128-bit aligned
+		 * addresses.
+		 */
+		addr = ppc4xx_hsta_msi.address + irq*0x10;
+		msg.address_hi = upper_32_bits(addr);
+		msg.address_lo = lower_32_bits(addr);
+
+		/* Data is not used by the HSTA. */
+		msg.data = 0;
+
+		pr_debug("%s: Setup irq %d (0x%0llx)\n", __func__, hwirq,
+			 (((u64) msg.address_hi) << 32) | msg.address_lo);
+
+		if (irq_set_msi_desc(hwirq, entry)) {
+			pr_err(
+			"%s: Invalid hwirq %d specified in device tree\n",
+			__func__, hwirq);
+			msi_bitmap_free_hwirqs(&ppc4xx_hsta_msi.bmp, irq, 1);
+			return -EINVAL;
+		}
+		write_msi_msg(hwirq, &msg);
+	}
+
+	return 0;
+}
+
+static int hsta_find_hwirq_offset(int hwirq)
+{
+	int irq;
+
+	/* Find the offset given the hwirq */
+	for (irq = 0; irq < ppc4xx_hsta_msi.irq_count; irq++)
+		if (ppc4xx_hsta_msi.irq_map[irq] == hwirq)
+			return irq;
+
+	return -EINVAL;
+}
+
+static void hsta_teardown_msi_irqs(struct pci_dev *dev)
+{
+	struct msi_desc *entry;
+	int irq;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		if (entry->irq == NO_IRQ)
+			continue;
+
+		irq = hsta_find_hwirq_offset(entry->irq);
+
+		/* entry->irq should always be in irq_map */
+		BUG_ON(irq < 0);
+		irq_set_msi_desc(entry->irq, NULL);
+		msi_bitmap_free_hwirqs(&ppc4xx_hsta_msi.bmp, irq, 1);
+		pr_debug("%s: Teardown IRQ %u (index %u)\n", __func__,
+			 entry->irq, irq);
+	}
+}
+
+static int hsta_msi_check_device(struct pci_dev *pdev, int nvec, int type)
+{
+	/* We don't support MSI-X */
+	if (type == PCI_CAP_ID_MSIX) {
+		pr_debug("%s: MSI-X not supported.\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hsta_msi_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *mem;
+	int irq, ret, irq_count;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (IS_ERR(mem)) {
+		dev_err(dev, "Unable to get mmio space\n");
+		return -EINVAL;
+	}
+
+	irq_count = of_irq_count(dev->of_node);
+	if (!irq_count) {
+		dev_err(dev, "Unable to find IRQ range\n");
+		return -EINVAL;
+	}
+
+	ppc4xx_hsta_msi.dev = dev;
+	ppc4xx_hsta_msi.address = mem->start;
+	ppc4xx_hsta_msi.data = ioremap(mem->start, resource_size(mem));
+	ppc4xx_hsta_msi.irq_count = irq_count;
+	if (IS_ERR(ppc4xx_hsta_msi.data)) {
+		dev_err(dev, "Unable to map memory\n");
+		return -ENOMEM;
+	}
+
+	ret = msi_bitmap_alloc(&ppc4xx_hsta_msi.bmp, irq_count, dev->of_node);
+	if (ret)
+		goto out;
+
+	ppc4xx_hsta_msi.irq_map = kmalloc(sizeof(int) * irq_count, GFP_KERNEL);
+	if (IS_ERR(ppc4xx_hsta_msi.irq_map)) {
+		ret = -ENOMEM;
+		goto out1;
+	}
+
+	/* Setup a mapping from irq offsets to hardware irq numbers */
+	for (irq = 0; irq < irq_count; irq++) {
+		ppc4xx_hsta_msi.irq_map[irq] =
+			irq_of_parse_and_map(dev->of_node, irq);
+		if (ppc4xx_hsta_msi.irq_map[irq] == NO_IRQ) {
+			dev_err(dev, "Unable to map IRQ\n");
+			ret = -EINVAL;
+			goto out2;
+		}
+	}
+
+	ppc_md.setup_msi_irqs = hsta_setup_msi_irqs;
+	ppc_md.teardown_msi_irqs = hsta_teardown_msi_irqs;
+	ppc_md.msi_check_device = hsta_msi_check_device;
+	return 0;
+
+out2:
+	kfree(ppc4xx_hsta_msi.irq_map);
+
+out1:
+	msi_bitmap_free(&ppc4xx_hsta_msi.bmp);
+
+out:
+	iounmap(ppc4xx_hsta_msi.data);
+	return ret;
+}
+
+static const struct of_device_id hsta_msi_ids[] = {
+	{
+		.compatible = "ibm,hsta-msi",
+	},
+	{}
+};
+
+static struct platform_driver hsta_msi_driver = {
+	.probe = hsta_msi_probe,
+	.driver = {
+		.name = "hsta-msi",
+		.owner = THIS_MODULE,
+		.of_match_table = hsta_msi_ids,
+	},
+};
+
+static int hsta_msi_init(void)
+{
+	return platform_driver_register(&hsta_msi_driver);
+}
+subsys_initcall(hsta_msi_init);
diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
index 54ec1d5..7cc3acc 100644
--- a/arch/powerpc/sysdev/ppc4xx_pci.c
+++ b/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -176,8 +176,12 @@ static int __init ppc4xx_parse_dma_ranges(struct pci_controller *hose,
 		return -ENXIO;
 	}
 
-	/* Check that we are fully contained within 32 bits space */
-	if (res->end > 0xffffffff) {
+	/* Check that we are fully contained within 32 bits space if we are not
+	 * running on a 460sx or 476fpe which have 64 bit bus addresses.
+	 */
+	if (res->end > 0xffffffff &&
+	    !(of_device_is_compatible(hose->dn, "ibm,plb-pciex-460sx")
+	      || of_device_is_compatible(hose->dn, "ibm,plb-pciex-476fpe"))) {
 		printk(KERN_ERR "%s: dma-ranges outside of 32 bits space\n",
 		       hose->dn->full_name);
 		return -ENXIO;
-- 
1.8.3.2

