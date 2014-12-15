Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaLOOdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:33:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:44497 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaLOOdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:33:17 -0500
Date: Mon, 15 Dec 2014 15:33:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT pull] irq domain arm updates for 3.19
Message-ID: <alpine.DEB.2.11.1412151525310.16494@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-irqdomain-arm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-irqdomain-arm-for-linus

This set of changes make use of hierarchical irqdomains to provide:

 - MSI/ITS support for GICv3
 - MSI support for GICv2m
 - Interrupt polarity extender for GICv1

Marc has come more cleanups for the existing extension hooks of GIC in
the pipeline, but they are going to be 3.20 material.

Thanks,

	tglx

------------------>
Jason Cooper (1):
      irqchip: gic: Remove warning by including linux/irqdomain.h

Marc Zyngier (16):
      arm64: PCI/MSI: Use asm-generic/msi.h
      irqchip: GICv3: Convert to domain hierarchy
      irqchip: GICv3: rework redistributor structure
      irqchip: GICv3: ITS command queue
      irqchip: GICv3: ITS: irqchip implementation
      irqchip: GICv3: ITS: LPI allocator
      irqchip: GICv3: ITS: tables allocators
      irqchip: GICv3: ITS: device allocation and configuration
      irqchip: GICv3: ITS: MSI support
      irqchip: GICv3: ITS: DT probing and initialization
      irqchip: GICv3: ITS: plug ITS init into main GICv3 code
      irqchip: GICv3: ITS: enable compilation of the ITS driver
      irqchip: GICv3: Binding updates for ITS
      irqchip: gicv3-its: Fix domain free in multi-MSI case
      irqchip: gicv3-its: Move some alloc/free code to activate/deactivate
      irqchip: gicv3-its: Fix ITT allocation

Suravee Suthikulpanit (2):
      irqchip: gic-v2m: Add support for ARM GICv2m MSI(-X) doorbell
      irqchip: gic-v2m: Add DT bindings for GICv2m

Yingjoe Chen (3):
      irqchip: gic: Support hierarchy irq domain.
      irqchip: mtk-sysirq: Add sysirq interrupt polarity support
      irqchip: mtk-sysirq: dt-bindings: Add bindings for mediatek sysirq


 Documentation/devicetree/bindings/arm/gic-v3.txt   |   39 +
 Documentation/devicetree/bindings/arm/gic.txt      |   53 +
 .../bindings/arm/mediatek/mediatek,sysirq.txt      |   28 +
 arch/arm64/Kconfig                                 |    2 +
 arch/arm64/include/asm/Kbuild                      |    1 +
 drivers/irqchip/Kconfig                            |   12 +
 drivers/irqchip/Makefile                           |    3 +
 drivers/irqchip/irq-gic-v2m.c                      |  333 +++++
 drivers/irqchip/irq-gic-v3-its.c                   | 1425 ++++++++++++++++++++
 drivers/irqchip/irq-gic-v3.c                       |  156 ++-
 drivers/irqchip/irq-gic.c                          |   81 +-
 drivers/irqchip/irq-mtk-sysirq.c                   |  163 +++
 include/linux/irqchip/arm-gic-v3.h                 |  128 ++
 include/linux/irqchip/arm-gic.h                    |    4 +
 14 files changed, 2364 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic-v3-its.c
 create mode 100644 drivers/irqchip/irq-mtk-sysirq.c

diff --git a/Documentation/devicetree/bindings/arm/gic-v3.txt b/Documentation/devicetree/bindings/arm/gic-v3.txt
index 33cd05e6c125..ddfade40ac59 100644
--- a/Documentation/devicetree/bindings/arm/gic-v3.txt
+++ b/Documentation/devicetree/bindings/arm/gic-v3.txt
@@ -49,11 +49,29 @@ Optional
   occupied by the redistributors. Required if more than one such
   region is present.
 
+Sub-nodes:
+
+GICv3 has one or more Interrupt Translation Services (ITS) that are
+used to route Message Signalled Interrupts (MSI) to the CPUs.
+
+These nodes must have the following properties:
+- compatible : Should at least contain  "arm,gic-v3-its".
+- msi-controller : Boolean property. Identifies the node as an MSI controller
+- reg: Specifies the base physical address and size of the ITS
+  registers.
+
+The main GIC node must contain the appropriate #address-cells,
+#size-cells and ranges properties for the reg property of all ITS
+nodes.
+
 Examples:
 
 	gic: interrupt-controller@2cf00000 {
 		compatible = "arm,gic-v3";
 		#interrupt-cells = <3>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
 		interrupt-controller;
 		reg = <0x0 0x2f000000 0 0x10000>,	// GICD
 		      <0x0 0x2f100000 0 0x200000>,	// GICR
@@ -61,11 +79,20 @@ Examples:
 		      <0x0 0x2c010000 0 0x2000>,	// GICH
 		      <0x0 0x2c020000 0 0x2000>;	// GICV
 		interrupts = <1 9 4>;
+
+		gic-its@2c200000 {
+			compatible = "arm,gic-v3-its";
+			msi-controller;
+			reg = <0x0 0x2c200000 0 0x200000>;
+		};
 	};
 
 	gic: interrupt-controller@2c010000 {
 		compatible = "arm,gic-v3";
 		#interrupt-cells = <3>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
 		interrupt-controller;
 		redistributor-stride = <0x0 0x40000>;	// 256kB stride
 		#redistributor-regions = <2>;
@@ -76,4 +103,16 @@ Examples:
 		      <0x0 0x2c060000 0 0x2000>,	// GICH
 		      <0x0 0x2c080000 0 0x2000>;	// GICV
 		interrupts = <1 9 4>;
+
+		gic-its@2c200000 {
+			compatible = "arm,gic-v3-its";
+			msi-controller;
+			reg = <0x0 0x2c200000 0 0x200000>;
+		};
+
+		gic-its@2c400000 {
+			compatible = "arm,gic-v3-its";
+			msi-controller;
+			reg = <0x0 0x2c400000 0 0x200000>;
+		};
 	};
diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index c7d2fa156678..375147e5a5fb 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -96,3 +96,56 @@ Example:
 		      <0x2c006000 0x2000>;
 		interrupts = <1 9 0xf04>;
 	};
+
+
+* GICv2m extension for MSI/MSI-x support (Optional)
+
+Certain revisions of GIC-400 supports MSI/MSI-x via V2M register frame(s).
+This is enabled by specifying v2m sub-node(s).
+
+Required properties:
+
+- compatible	    : The value here should contain "arm,gic-v2m-frame".
+
+- msi-controller    : Identifies the node as an MSI controller.
+
+- reg		    : GICv2m MSI interface register base and size
+
+Optional properties:
+
+- arm,msi-base-spi  : When the MSI_TYPER register contains an incorrect
+  		      value, this property should contain the SPI base of
+		      the MSI frame, overriding the HW value.
+
+- arm,msi-num-spis  : When the MSI_TYPER register contains an incorrect
+  		      value, this property should contain the number of
+		      SPIs assigned to the frame, overriding the HW value.
+
+Example:
+
+	interrupt-controller@e1101000 {
+		compatible = "arm,gic-400";
+		#interrupt-cells = <3>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		interrupt-controller;
+		interrupts = <1 8 0xf04>;
+		ranges = <0 0 0 0xe1100000 0 0x100000>;
+		reg = <0x0 0xe1110000 0 0x01000>,
+		      <0x0 0xe112f000 0 0x02000>,
+		      <0x0 0xe1140000 0 0x10000>,
+		      <0x0 0xe1160000 0 0x10000>;
+		v2m0: v2m@0x8000 {
+			compatible = "arm,gic-v2m-frame";
+			msi-controller;
+			reg = <0x0 0x80000 0 0x1000>;
+		};
+
+		....
+
+		v2mN: v2m@0x9000 {
+			compatible = "arm,gic-v2m-frame";
+			msi-controller;
+			reg = <0x0 0x90000 0 0x1000>;
+		};
+	};
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
new file mode 100644
index 000000000000..d680b07ec6e8
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
@@ -0,0 +1,28 @@
+Mediatek 65xx/81xx sysirq
+
+Mediatek SOCs sysirq support controllable irq inverter for each GIC SPI
+interrupt.
+
+Required properties:
+- compatible: should be one of:
+	"mediatek,mt8135-sysirq"
+	"mediatek,mt8127-sysirq"
+	"mediatek,mt6589-sysirq"
+	"mediatek,mt6582-sysirq"
+	"mediatek,mt6577-sysirq"
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Use the same format as specified by GIC in
+  Documentation/devicetree/bindings/arm/gic.txt
+- interrupt-parent: phandle of irq parent for sysirq. The parent must
+  use the same interrupt-cells format as GIC.
+- reg: Physical base address of the intpol registers and length of memory
+  mapped region.
+
+Example:
+	sysirq: interrupt-controller@10200100 {
+		compatible = "mediatek,mt6589-sysirq", "mediatek,mt6577-sysirq";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		interrupt-parent = <&gic>;
+		reg = <0 0x10200100 0 0x1c>;
+	};
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ac9afde76dea..e06e1a99eafa 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -12,7 +12,9 @@ config ARM64
 	select ARM_ARCH_TIMER
 	select ARM_GIC
 	select AUDIT_ARCH_COMPAT_GENERIC
+	select ARM_GIC_V2M if PCI_MSI
 	select ARM_GIC_V3
+	select ARM_GIC_V3_ITS if PCI_MSI
 	select BUILDTIME_EXTABLE_SORT
 	select CLONE_BACKWARDS
 	select COMMON_CLK
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index dc770bd4f5a5..e315bd833c10 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -28,6 +28,7 @@ generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
+generic-y += msi.h
 generic-y += mutex.h
 generic-y += pci.h
 generic-y += pci-bridge.h
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b21f12f1766d..e72e23960632 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -5,8 +5,15 @@ config IRQCHIP
 config ARM_GIC
 	bool
 	select IRQ_DOMAIN
+	select IRQ_DOMAIN_HIERARCHY
 	select MULTI_IRQ_HANDLER
 
+config ARM_GIC_V2M
+	bool
+	depends on ARM_GIC
+	depends on PCI && PCI_MSI
+	select PCI_MSI_IRQ_DOMAIN
+
 config GIC_NON_BANKED
 	bool
 
@@ -14,6 +21,11 @@ config ARM_GIC_V3
 	bool
 	select IRQ_DOMAIN
 	select MULTI_IRQ_HANDLER
+	select IRQ_DOMAIN_HIERARCHY
+
+config ARM_GIC_V3_ITS
+	bool
+	select PCI_MSI_IRQ_DOMAIN
 
 config ARM_NVIC
 	bool
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 173bb5fa2cc9..983634d61b25 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -19,7 +19,9 @@ obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi-nmi.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o irq-gic-common.o
+obj-$(CONFIG_ARM_GIC_V2M)		+= irq-gic-v2m.o
 obj-$(CONFIG_ARM_GIC_V3)		+= irq-gic-v3.o irq-gic-common.o
+obj-$(CONFIG_ARM_GIC_V3_ITS)		+= irq-gic-v3-its.o
 obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
 obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
 obj-$(CONFIG_ATMEL_AIC_IRQ)		+= irq-atmel-aic-common.o irq-atmel-aic.o
@@ -38,3 +40,4 @@ obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
 obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o \
 					   irq-bcm7120-l2.o
 obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
+obj-$(CONFIG_ARCH_MEDIATEK)		+= irq-mtk-sysirq.o
diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
new file mode 100644
index 000000000000..fdf706555d72
--- /dev/null
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -0,0 +1,333 @@
+/*
+ * ARM GIC v2m MSI(-X) support
+ * Support for Message Signaled Interrupts for systems that
+ * implement ARM Generic Interrupt Controller: GICv2m.
+ *
+ * Copyright (C) 2014 Advanced Micro Devices, Inc.
+ * Authors: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
+ *	    Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>
+ *	    Brandon Anderson <brandon.anderson@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt) "GICv2m: " fmt
+
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/kernel.h>
+#include <linux/of_address.h>
+#include <linux/of_pci.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+/*
+* MSI_TYPER:
+*     [31:26] Reserved
+*     [25:16] lowest SPI assigned to MSI
+*     [15:10] Reserved
+*     [9:0]   Numer of SPIs assigned to MSI
+*/
+#define V2M_MSI_TYPER		       0x008
+#define V2M_MSI_TYPER_BASE_SHIFT       16
+#define V2M_MSI_TYPER_BASE_MASK	       0x3FF
+#define V2M_MSI_TYPER_NUM_MASK	       0x3FF
+#define V2M_MSI_SETSPI_NS	       0x040
+#define V2M_MIN_SPI		       32
+#define V2M_MAX_SPI		       1019
+
+#define V2M_MSI_TYPER_BASE_SPI(x)      \
+	       (((x) >> V2M_MSI_TYPER_BASE_SHIFT) & V2M_MSI_TYPER_BASE_MASK)
+
+#define V2M_MSI_TYPER_NUM_SPI(x)       ((x) & V2M_MSI_TYPER_NUM_MASK)
+
+struct v2m_data {
+	spinlock_t msi_cnt_lock;
+	struct msi_controller mchip;
+	struct resource res;	/* GICv2m resource */
+	void __iomem *base;	/* GICv2m virt address */
+	u32 spi_start;		/* The SPI number that MSIs start */
+	u32 nr_spis;		/* The number of SPIs for MSIs */
+	unsigned long *bm;	/* MSI vector bitmap */
+	struct irq_domain *domain;
+};
+
+static void gicv2m_mask_msi_irq(struct irq_data *d)
+{
+	pci_msi_mask_irq(d);
+	irq_chip_mask_parent(d);
+}
+
+static void gicv2m_unmask_msi_irq(struct irq_data *d)
+{
+	pci_msi_unmask_irq(d);
+	irq_chip_unmask_parent(d);
+}
+
+static struct irq_chip gicv2m_msi_irq_chip = {
+	.name			= "MSI",
+	.irq_mask		= gicv2m_mask_msi_irq,
+	.irq_unmask		= gicv2m_unmask_msi_irq,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_write_msi_msg	= pci_msi_domain_write_msg,
+};
+
+static struct msi_domain_info gicv2m_msi_domain_info = {
+	.flags	= (MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
+		   MSI_FLAG_PCI_MSIX),
+	.chip	= &gicv2m_msi_irq_chip,
+};
+
+static int gicv2m_set_affinity(struct irq_data *irq_data,
+			       const struct cpumask *mask, bool force)
+{
+	int ret;
+
+	ret = irq_chip_set_affinity_parent(irq_data, mask, force);
+	if (ret == IRQ_SET_MASK_OK)
+		ret = IRQ_SET_MASK_OK_DONE;
+
+	return ret;
+}
+
+static void gicv2m_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	struct v2m_data *v2m = irq_data_get_irq_chip_data(data);
+	phys_addr_t addr = v2m->res.start + V2M_MSI_SETSPI_NS;
+
+	msg->address_hi = (u32) (addr >> 32);
+	msg->address_lo = (u32) (addr);
+	msg->data = data->hwirq;
+}
+
+static struct irq_chip gicv2m_irq_chip = {
+	.name			= "GICv2m",
+	.irq_mask		= irq_chip_mask_parent,
+	.irq_unmask		= irq_chip_unmask_parent,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_set_affinity	= gicv2m_set_affinity,
+	.irq_compose_msi_msg	= gicv2m_compose_msi_msg,
+};
+
+static int gicv2m_irq_gic_domain_alloc(struct irq_domain *domain,
+				       unsigned int virq,
+				       irq_hw_number_t hwirq)
+{
+	struct of_phandle_args args;
+	struct irq_data *d;
+	int err;
+
+	args.np = domain->parent->of_node;
+	args.args_count = 3;
+	args.args[0] = 0;
+	args.args[1] = hwirq - 32;
+	args.args[2] = IRQ_TYPE_EDGE_RISING;
+
+	err = irq_domain_alloc_irqs_parent(domain, virq, 1, &args);
+	if (err)
+		return err;
+
+	/* Configure the interrupt line to be edge */
+	d = irq_domain_get_irq_data(domain->parent, virq);
+	d->chip->irq_set_type(d, IRQ_TYPE_EDGE_RISING);
+	return 0;
+}
+
+static void gicv2m_unalloc_msi(struct v2m_data *v2m, unsigned int hwirq)
+{
+	int pos;
+
+	pos = hwirq - v2m->spi_start;
+	if (pos < 0 || pos >= v2m->nr_spis) {
+		pr_err("Failed to teardown msi. Invalid hwirq %d\n", hwirq);
+		return;
+	}
+
+	spin_lock(&v2m->msi_cnt_lock);
+	__clear_bit(pos, v2m->bm);
+	spin_unlock(&v2m->msi_cnt_lock);
+}
+
+static int gicv2m_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				   unsigned int nr_irqs, void *args)
+{
+	struct v2m_data *v2m = domain->host_data;
+	int hwirq, offset, err = 0;
+
+	spin_lock(&v2m->msi_cnt_lock);
+	offset = find_first_zero_bit(v2m->bm, v2m->nr_spis);
+	if (offset < v2m->nr_spis)
+		__set_bit(offset, v2m->bm);
+	else
+		err = -ENOSPC;
+	spin_unlock(&v2m->msi_cnt_lock);
+
+	if (err)
+		return err;
+
+	hwirq = v2m->spi_start + offset;
+
+	err = gicv2m_irq_gic_domain_alloc(domain, virq, hwirq);
+	if (err) {
+		gicv2m_unalloc_msi(v2m, hwirq);
+		return err;
+	}
+
+	irq_domain_set_hwirq_and_chip(domain, virq, hwirq,
+				      &gicv2m_irq_chip, v2m);
+
+	return 0;
+}
+
+static void gicv2m_irq_domain_free(struct irq_domain *domain,
+				   unsigned int virq, unsigned int nr_irqs)
+{
+	struct irq_data *d = irq_domain_get_irq_data(domain, virq);
+	struct v2m_data *v2m = irq_data_get_irq_chip_data(d);
+
+	BUG_ON(nr_irqs != 1);
+	gicv2m_unalloc_msi(v2m, d->hwirq);
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static const struct irq_domain_ops gicv2m_domain_ops = {
+	.alloc			= gicv2m_irq_domain_alloc,
+	.free			= gicv2m_irq_domain_free,
+};
+
+static bool is_msi_spi_valid(u32 base, u32 num)
+{
+	if (base < V2M_MIN_SPI) {
+		pr_err("Invalid MSI base SPI (base:%u)\n", base);
+		return false;
+	}
+
+	if ((num == 0) || (base + num > V2M_MAX_SPI)) {
+		pr_err("Number of SPIs (%u) exceed maximum (%u)\n",
+		       num, V2M_MAX_SPI - V2M_MIN_SPI + 1);
+		return false;
+	}
+
+	return true;
+}
+
+static int __init gicv2m_init_one(struct device_node *node,
+				  struct irq_domain *parent)
+{
+	int ret;
+	struct v2m_data *v2m;
+
+	v2m = kzalloc(sizeof(struct v2m_data), GFP_KERNEL);
+	if (!v2m) {
+		pr_err("Failed to allocate struct v2m_data.\n");
+		return -ENOMEM;
+	}
+
+	ret = of_address_to_resource(node, 0, &v2m->res);
+	if (ret) {
+		pr_err("Failed to allocate v2m resource.\n");
+		goto err_free_v2m;
+	}
+
+	v2m->base = ioremap(v2m->res.start, resource_size(&v2m->res));
+	if (!v2m->base) {
+		pr_err("Failed to map GICv2m resource\n");
+		ret = -ENOMEM;
+		goto err_free_v2m;
+	}
+
+	if (!of_property_read_u32(node, "arm,msi-base-spi", &v2m->spi_start) &&
+	    !of_property_read_u32(node, "arm,msi-num-spis", &v2m->nr_spis)) {
+		pr_info("Overriding V2M MSI_TYPER (base:%u, num:%u)\n",
+			v2m->spi_start, v2m->nr_spis);
+	} else {
+		u32 typer = readl_relaxed(v2m->base + V2M_MSI_TYPER);
+
+		v2m->spi_start = V2M_MSI_TYPER_BASE_SPI(typer);
+		v2m->nr_spis = V2M_MSI_TYPER_NUM_SPI(typer);
+	}
+
+	if (!is_msi_spi_valid(v2m->spi_start, v2m->nr_spis)) {
+		ret = -EINVAL;
+		goto err_iounmap;
+	}
+
+	v2m->bm = kzalloc(sizeof(long) * BITS_TO_LONGS(v2m->nr_spis),
+			  GFP_KERNEL);
+	if (!v2m->bm) {
+		ret = -ENOMEM;
+		goto err_iounmap;
+	}
+
+	v2m->domain = irq_domain_add_tree(NULL, &gicv2m_domain_ops, v2m);
+	if (!v2m->domain) {
+		pr_err("Failed to create GICv2m domain\n");
+		ret = -ENOMEM;
+		goto err_free_bm;
+	}
+
+	v2m->domain->parent = parent;
+	v2m->mchip.of_node = node;
+	v2m->mchip.domain = pci_msi_create_irq_domain(node,
+						      &gicv2m_msi_domain_info,
+						      v2m->domain);
+	if (!v2m->mchip.domain) {
+		pr_err("Failed to create MSI domain\n");
+		ret = -ENOMEM;
+		goto err_free_domains;
+	}
+
+	spin_lock_init(&v2m->msi_cnt_lock);
+
+	ret = of_pci_msi_chip_add(&v2m->mchip);
+	if (ret) {
+		pr_err("Failed to add msi_chip.\n");
+		goto err_free_domains;
+	}
+
+	pr_info("Node %s: range[%#lx:%#lx], SPI[%d:%d]\n", node->name,
+		(unsigned long)v2m->res.start, (unsigned long)v2m->res.end,
+		v2m->spi_start, (v2m->spi_start + v2m->nr_spis));
+
+	return 0;
+
+err_free_domains:
+	if (v2m->mchip.domain)
+		irq_domain_remove(v2m->mchip.domain);
+	if (v2m->domain)
+		irq_domain_remove(v2m->domain);
+err_free_bm:
+	kfree(v2m->bm);
+err_iounmap:
+	iounmap(v2m->base);
+err_free_v2m:
+	kfree(v2m);
+	return ret;
+}
+
+static struct of_device_id gicv2m_device_id[] = {
+	{	.compatible	= "arm,gic-v2m-frame",	},
+	{},
+};
+
+int __init gicv2m_of_init(struct device_node *node, struct irq_domain *parent)
+{
+	int ret = 0;
+	struct device_node *child;
+
+	for (child = of_find_matching_node(node, gicv2m_device_id); child;
+	     child = of_find_matching_node(child, gicv2m_device_id)) {
+		if (!of_find_property(child, "msi-controller", NULL))
+			continue;
+
+		ret = gicv2m_init_one(child, parent);
+		if (ret) {
+			of_node_put(node);
+			break;
+		}
+	}
+
+	return ret;
+}
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
new file mode 100644
index 000000000000..86e4684adeb1
--- /dev/null
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -0,0 +1,1425 @@
+/*
+ * Copyright (C) 2013, 2014 ARM Limited, All Rights Reserved.
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/bitmap.h>
+#include <linux/cpu.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/log2.h>
+#include <linux/mm.h>
+#include <linux/msi.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_pci.h>
+#include <linux/of_platform.h>
+#include <linux/percpu.h>
+#include <linux/slab.h>
+
+#include <linux/irqchip/arm-gic-v3.h>
+
+#include <asm/cacheflush.h>
+#include <asm/cputype.h>
+#include <asm/exception.h>
+
+#include "irqchip.h"
+
+#define ITS_FLAGS_CMDQ_NEEDS_FLUSHING		(1 << 0)
+
+#define RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING	(1 << 0)
+
+/*
+ * Collection structure - just an ID, and a redistributor address to
+ * ping. We use one per CPU as a bag of interrupts assigned to this
+ * CPU.
+ */
+struct its_collection {
+	u64			target_address;
+	u16			col_id;
+};
+
+/*
+ * The ITS structure - contains most of the infrastructure, with the
+ * msi_controller, the command queue, the collections, and the list of
+ * devices writing to it.
+ */
+struct its_node {
+	raw_spinlock_t		lock;
+	struct list_head	entry;
+	struct msi_controller	msi_chip;
+	struct irq_domain	*domain;
+	void __iomem		*base;
+	unsigned long		phys_base;
+	struct its_cmd_block	*cmd_base;
+	struct its_cmd_block	*cmd_write;
+	void			*tables[GITS_BASER_NR_REGS];
+	struct its_collection	*collections;
+	struct list_head	its_device_list;
+	u64			flags;
+	u32			ite_size;
+};
+
+#define ITS_ITT_ALIGN		SZ_256
+
+/*
+ * The ITS view of a device - belongs to an ITS, a collection, owns an
+ * interrupt translation table, and a list of interrupts.
+ */
+struct its_device {
+	struct list_head	entry;
+	struct its_node		*its;
+	struct its_collection	*collection;
+	void			*itt;
+	unsigned long		*lpi_map;
+	irq_hw_number_t		lpi_base;
+	int			nr_lpis;
+	u32			nr_ites;
+	u32			device_id;
+};
+
+static LIST_HEAD(its_nodes);
+static DEFINE_SPINLOCK(its_lock);
+static struct device_node *gic_root_node;
+static struct rdists *gic_rdists;
+
+#define gic_data_rdist()		(raw_cpu_ptr(gic_rdists->rdist))
+#define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
+
+/*
+ * ITS command descriptors - parameters to be encoded in a command
+ * block.
+ */
+struct its_cmd_desc {
+	union {
+		struct {
+			struct its_device *dev;
+			u32 event_id;
+		} its_inv_cmd;
+
+		struct {
+			struct its_device *dev;
+			u32 event_id;
+		} its_int_cmd;
+
+		struct {
+			struct its_device *dev;
+			int valid;
+		} its_mapd_cmd;
+
+		struct {
+			struct its_collection *col;
+			int valid;
+		} its_mapc_cmd;
+
+		struct {
+			struct its_device *dev;
+			u32 phys_id;
+			u32 event_id;
+		} its_mapvi_cmd;
+
+		struct {
+			struct its_device *dev;
+			struct its_collection *col;
+			u32 id;
+		} its_movi_cmd;
+
+		struct {
+			struct its_device *dev;
+			u32 event_id;
+		} its_discard_cmd;
+
+		struct {
+			struct its_collection *col;
+		} its_invall_cmd;
+	};
+};
+
+/*
+ * The ITS command block, which is what the ITS actually parses.
+ */
+struct its_cmd_block {
+	u64	raw_cmd[4];
+};
+
+#define ITS_CMD_QUEUE_SZ		SZ_64K
+#define ITS_CMD_QUEUE_NR_ENTRIES	(ITS_CMD_QUEUE_SZ / sizeof(struct its_cmd_block))
+
+typedef struct its_collection *(*its_cmd_builder_t)(struct its_cmd_block *,
+						    struct its_cmd_desc *);
+
+static void its_encode_cmd(struct its_cmd_block *cmd, u8 cmd_nr)
+{
+	cmd->raw_cmd[0] &= ~0xffUL;
+	cmd->raw_cmd[0] |= cmd_nr;
+}
+
+static void its_encode_devid(struct its_cmd_block *cmd, u32 devid)
+{
+	cmd->raw_cmd[0] &= ~(0xffffUL << 32);
+	cmd->raw_cmd[0] |= ((u64)devid) << 32;
+}
+
+static void its_encode_event_id(struct its_cmd_block *cmd, u32 id)
+{
+	cmd->raw_cmd[1] &= ~0xffffffffUL;
+	cmd->raw_cmd[1] |= id;
+}
+
+static void its_encode_phys_id(struct its_cmd_block *cmd, u32 phys_id)
+{
+	cmd->raw_cmd[1] &= 0xffffffffUL;
+	cmd->raw_cmd[1] |= ((u64)phys_id) << 32;
+}
+
+static void its_encode_size(struct its_cmd_block *cmd, u8 size)
+{
+	cmd->raw_cmd[1] &= ~0x1fUL;
+	cmd->raw_cmd[1] |= size & 0x1f;
+}
+
+static void its_encode_itt(struct its_cmd_block *cmd, u64 itt_addr)
+{
+	cmd->raw_cmd[2] &= ~0xffffffffffffUL;
+	cmd->raw_cmd[2] |= itt_addr & 0xffffffffff00UL;
+}
+
+static void its_encode_valid(struct its_cmd_block *cmd, int valid)
+{
+	cmd->raw_cmd[2] &= ~(1UL << 63);
+	cmd->raw_cmd[2] |= ((u64)!!valid) << 63;
+}
+
+static void its_encode_target(struct its_cmd_block *cmd, u64 target_addr)
+{
+	cmd->raw_cmd[2] &= ~(0xffffffffUL << 16);
+	cmd->raw_cmd[2] |= (target_addr & (0xffffffffUL << 16));
+}
+
+static void its_encode_collection(struct its_cmd_block *cmd, u16 col)
+{
+	cmd->raw_cmd[2] &= ~0xffffUL;
+	cmd->raw_cmd[2] |= col;
+}
+
+static inline void its_fixup_cmd(struct its_cmd_block *cmd)
+{
+	/* Let's fixup BE commands */
+	cmd->raw_cmd[0] = cpu_to_le64(cmd->raw_cmd[0]);
+	cmd->raw_cmd[1] = cpu_to_le64(cmd->raw_cmd[1]);
+	cmd->raw_cmd[2] = cpu_to_le64(cmd->raw_cmd[2]);
+	cmd->raw_cmd[3] = cpu_to_le64(cmd->raw_cmd[3]);
+}
+
+static struct its_collection *its_build_mapd_cmd(struct its_cmd_block *cmd,
+						 struct its_cmd_desc *desc)
+{
+	unsigned long itt_addr;
+	u8 size = ilog2(desc->its_mapd_cmd.dev->nr_ites);
+
+	itt_addr = virt_to_phys(desc->its_mapd_cmd.dev->itt);
+	itt_addr = ALIGN(itt_addr, ITS_ITT_ALIGN);
+
+	its_encode_cmd(cmd, GITS_CMD_MAPD);
+	its_encode_devid(cmd, desc->its_mapd_cmd.dev->device_id);
+	its_encode_size(cmd, size - 1);
+	its_encode_itt(cmd, itt_addr);
+	its_encode_valid(cmd, desc->its_mapd_cmd.valid);
+
+	its_fixup_cmd(cmd);
+
+	return desc->its_mapd_cmd.dev->collection;
+}
+
+static struct its_collection *its_build_mapc_cmd(struct its_cmd_block *cmd,
+						 struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_MAPC);
+	its_encode_collection(cmd, desc->its_mapc_cmd.col->col_id);
+	its_encode_target(cmd, desc->its_mapc_cmd.col->target_address);
+	its_encode_valid(cmd, desc->its_mapc_cmd.valid);
+
+	its_fixup_cmd(cmd);
+
+	return desc->its_mapc_cmd.col;
+}
+
+static struct its_collection *its_build_mapvi_cmd(struct its_cmd_block *cmd,
+						  struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_MAPVI);
+	its_encode_devid(cmd, desc->its_mapvi_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_mapvi_cmd.event_id);
+	its_encode_phys_id(cmd, desc->its_mapvi_cmd.phys_id);
+	its_encode_collection(cmd, desc->its_mapvi_cmd.dev->collection->col_id);
+
+	its_fixup_cmd(cmd);
+
+	return desc->its_mapvi_cmd.dev->collection;
+}
+
+static struct its_collection *its_build_movi_cmd(struct its_cmd_block *cmd,
+						 struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_MOVI);
+	its_encode_devid(cmd, desc->its_movi_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_movi_cmd.id);
+	its_encode_collection(cmd, desc->its_movi_cmd.col->col_id);
+
+	its_fixup_cmd(cmd);
+
+	return desc->its_movi_cmd.dev->collection;
+}
+
+static struct its_collection *its_build_discard_cmd(struct its_cmd_block *cmd,
+						    struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_DISCARD);
+	its_encode_devid(cmd, desc->its_discard_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_discard_cmd.event_id);
+
+	its_fixup_cmd(cmd);
+
+	return desc->its_discard_cmd.dev->collection;
+}
+
+static struct its_collection *its_build_inv_cmd(struct its_cmd_block *cmd,
+						struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_INV);
+	its_encode_devid(cmd, desc->its_inv_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_inv_cmd.event_id);
+
+	its_fixup_cmd(cmd);
+
+	return desc->its_inv_cmd.dev->collection;
+}
+
+static struct its_collection *its_build_invall_cmd(struct its_cmd_block *cmd,
+						   struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_INVALL);
+	its_encode_collection(cmd, desc->its_mapc_cmd.col->col_id);
+
+	its_fixup_cmd(cmd);
+
+	return NULL;
+}
+
+static u64 its_cmd_ptr_to_offset(struct its_node *its,
+				 struct its_cmd_block *ptr)
+{
+	return (ptr - its->cmd_base) * sizeof(*ptr);
+}
+
+static int its_queue_full(struct its_node *its)
+{
+	int widx;
+	int ridx;
+
+	widx = its->cmd_write - its->cmd_base;
+	ridx = readl_relaxed(its->base + GITS_CREADR) / sizeof(struct its_cmd_block);
+
+	/* This is incredibly unlikely to happen, unless the ITS locks up. */
+	if (((widx + 1) % ITS_CMD_QUEUE_NR_ENTRIES) == ridx)
+		return 1;
+
+	return 0;
+}
+
+static struct its_cmd_block *its_allocate_entry(struct its_node *its)
+{
+	struct its_cmd_block *cmd;
+	u32 count = 1000000;	/* 1s! */
+
+	while (its_queue_full(its)) {
+		count--;
+		if (!count) {
+			pr_err_ratelimited("ITS queue not draining\n");
+			return NULL;
+		}
+		cpu_relax();
+		udelay(1);
+	}
+
+	cmd = its->cmd_write++;
+
+	/* Handle queue wrapping */
+	if (its->cmd_write == (its->cmd_base + ITS_CMD_QUEUE_NR_ENTRIES))
+		its->cmd_write = its->cmd_base;
+
+	return cmd;
+}
+
+static struct its_cmd_block *its_post_commands(struct its_node *its)
+{
+	u64 wr = its_cmd_ptr_to_offset(its, its->cmd_write);
+
+	writel_relaxed(wr, its->base + GITS_CWRITER);
+
+	return its->cmd_write;
+}
+
+static void its_flush_cmd(struct its_node *its, struct its_cmd_block *cmd)
+{
+	/*
+	 * Make sure the commands written to memory are observable by
+	 * the ITS.
+	 */
+	if (its->flags & ITS_FLAGS_CMDQ_NEEDS_FLUSHING)
+		__flush_dcache_area(cmd, sizeof(*cmd));
+	else
+		dsb(ishst);
+}
+
+static void its_wait_for_range_completion(struct its_node *its,
+					  struct its_cmd_block *from,
+					  struct its_cmd_block *to)
+{
+	u64 rd_idx, from_idx, to_idx;
+	u32 count = 1000000;	/* 1s! */
+
+	from_idx = its_cmd_ptr_to_offset(its, from);
+	to_idx = its_cmd_ptr_to_offset(its, to);
+
+	while (1) {
+		rd_idx = readl_relaxed(its->base + GITS_CREADR);
+		if (rd_idx >= to_idx || rd_idx < from_idx)
+			break;
+
+		count--;
+		if (!count) {
+			pr_err_ratelimited("ITS queue timeout\n");
+			return;
+		}
+		cpu_relax();
+		udelay(1);
+	}
+}
+
+static void its_send_single_command(struct its_node *its,
+				    its_cmd_builder_t builder,
+				    struct its_cmd_desc *desc)
+{
+	struct its_cmd_block *cmd, *sync_cmd, *next_cmd;
+	struct its_collection *sync_col;
+
+	raw_spin_lock(&its->lock);
+
+	cmd = its_allocate_entry(its);
+	if (!cmd) {		/* We're soooooo screewed... */
+		pr_err_ratelimited("ITS can't allocate, dropping command\n");
+		raw_spin_unlock(&its->lock);
+		return;
+	}
+	sync_col = builder(cmd, desc);
+	its_flush_cmd(its, cmd);
+
+	if (sync_col) {
+		sync_cmd = its_allocate_entry(its);
+		if (!sync_cmd) {
+			pr_err_ratelimited("ITS can't SYNC, skipping\n");
+			goto post;
+		}
+		its_encode_cmd(sync_cmd, GITS_CMD_SYNC);
+		its_encode_target(sync_cmd, sync_col->target_address);
+		its_fixup_cmd(sync_cmd);
+		its_flush_cmd(its, sync_cmd);
+	}
+
+post:
+	next_cmd = its_post_commands(its);
+	raw_spin_unlock(&its->lock);
+
+	its_wait_for_range_completion(its, cmd, next_cmd);
+}
+
+static void its_send_inv(struct its_device *dev, u32 event_id)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_inv_cmd.dev = dev;
+	desc.its_inv_cmd.event_id = event_id;
+
+	its_send_single_command(dev->its, its_build_inv_cmd, &desc);
+}
+
+static void its_send_mapd(struct its_device *dev, int valid)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_mapd_cmd.dev = dev;
+	desc.its_mapd_cmd.valid = !!valid;
+
+	its_send_single_command(dev->its, its_build_mapd_cmd, &desc);
+}
+
+static void its_send_mapc(struct its_node *its, struct its_collection *col,
+			  int valid)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_mapc_cmd.col = col;
+	desc.its_mapc_cmd.valid = !!valid;
+
+	its_send_single_command(its, its_build_mapc_cmd, &desc);
+}
+
+static void its_send_mapvi(struct its_device *dev, u32 irq_id, u32 id)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_mapvi_cmd.dev = dev;
+	desc.its_mapvi_cmd.phys_id = irq_id;
+	desc.its_mapvi_cmd.event_id = id;
+
+	its_send_single_command(dev->its, its_build_mapvi_cmd, &desc);
+}
+
+static void its_send_movi(struct its_device *dev,
+			  struct its_collection *col, u32 id)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_movi_cmd.dev = dev;
+	desc.its_movi_cmd.col = col;
+	desc.its_movi_cmd.id = id;
+
+	its_send_single_command(dev->its, its_build_movi_cmd, &desc);
+}
+
+static void its_send_discard(struct its_device *dev, u32 id)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_discard_cmd.dev = dev;
+	desc.its_discard_cmd.event_id = id;
+
+	its_send_single_command(dev->its, its_build_discard_cmd, &desc);
+}
+
+static void its_send_invall(struct its_node *its, struct its_collection *col)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_invall_cmd.col = col;
+
+	its_send_single_command(its, its_build_invall_cmd, &desc);
+}
+
+/*
+ * irqchip functions - assumes MSI, mostly.
+ */
+
+static inline u32 its_get_event_id(struct irq_data *d)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	return d->hwirq - its_dev->lpi_base;
+}
+
+static void lpi_set_config(struct irq_data *d, bool enable)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	irq_hw_number_t hwirq = d->hwirq;
+	u32 id = its_get_event_id(d);
+	u8 *cfg = page_address(gic_rdists->prop_page) + hwirq - 8192;
+
+	if (enable)
+		*cfg |= LPI_PROP_ENABLED;
+	else
+		*cfg &= ~LPI_PROP_ENABLED;
+
+	/*
+	 * Make the above write visible to the redistributors.
+	 * And yes, we're flushing exactly: One. Single. Byte.
+	 * Humpf...
+	 */
+	if (gic_rdists->flags & RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING)
+		__flush_dcache_area(cfg, sizeof(*cfg));
+	else
+		dsb(ishst);
+	its_send_inv(its_dev, id);
+}
+
+static void its_mask_irq(struct irq_data *d)
+{
+	lpi_set_config(d, false);
+}
+
+static void its_unmask_irq(struct irq_data *d)
+{
+	lpi_set_config(d, true);
+}
+
+static void its_eoi_irq(struct irq_data *d)
+{
+	gic_write_eoir(d->hwirq);
+}
+
+static int its_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
+			    bool force)
+{
+	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	struct its_collection *target_col;
+	u32 id = its_get_event_id(d);
+
+	if (cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	target_col = &its_dev->its->collections[cpu];
+	its_send_movi(its_dev, target_col, id);
+	its_dev->collection = target_col;
+
+	return IRQ_SET_MASK_OK_DONE;
+}
+
+static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	struct its_node *its;
+	u64 addr;
+
+	its = its_dev->its;
+	addr = its->phys_base + GITS_TRANSLATER;
+
+	msg->address_lo		= addr & ((1UL << 32) - 1);
+	msg->address_hi		= addr >> 32;
+	msg->data		= its_get_event_id(d);
+}
+
+static struct irq_chip its_irq_chip = {
+	.name			= "ITS",
+	.irq_mask		= its_mask_irq,
+	.irq_unmask		= its_unmask_irq,
+	.irq_eoi		= its_eoi_irq,
+	.irq_set_affinity	= its_set_affinity,
+	.irq_compose_msi_msg	= its_irq_compose_msi_msg,
+};
+
+static void its_mask_msi_irq(struct irq_data *d)
+{
+	pci_msi_mask_irq(d);
+	irq_chip_mask_parent(d);
+}
+
+static void its_unmask_msi_irq(struct irq_data *d)
+{
+	pci_msi_unmask_irq(d);
+	irq_chip_unmask_parent(d);
+}
+
+static struct irq_chip its_msi_irq_chip = {
+	.name			= "ITS-MSI",
+	.irq_unmask		= its_unmask_msi_irq,
+	.irq_mask		= its_mask_msi_irq,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_write_msi_msg	= pci_msi_domain_write_msg,
+};
+
+/*
+ * How we allocate LPIs:
+ *
+ * The GIC has id_bits bits for interrupt identifiers. From there, we
+ * must subtract 8192 which are reserved for SGIs/PPIs/SPIs. Then, as
+ * we allocate LPIs by chunks of 32, we can shift the whole thing by 5
+ * bits to the right.
+ *
+ * This gives us (((1UL << id_bits) - 8192) >> 5) possible allocations.
+ */
+#define IRQS_PER_CHUNK_SHIFT	5
+#define IRQS_PER_CHUNK		(1 << IRQS_PER_CHUNK_SHIFT)
+
+static unsigned long *lpi_bitmap;
+static u32 lpi_chunks;
+static DEFINE_SPINLOCK(lpi_lock);
+
+static int its_lpi_to_chunk(int lpi)
+{
+	return (lpi - 8192) >> IRQS_PER_CHUNK_SHIFT;
+}
+
+static int its_chunk_to_lpi(int chunk)
+{
+	return (chunk << IRQS_PER_CHUNK_SHIFT) + 8192;
+}
+
+static int its_lpi_init(u32 id_bits)
+{
+	lpi_chunks = its_lpi_to_chunk(1UL << id_bits);
+
+	lpi_bitmap = kzalloc(BITS_TO_LONGS(lpi_chunks) * sizeof(long),
+			     GFP_KERNEL);
+	if (!lpi_bitmap) {
+		lpi_chunks = 0;
+		return -ENOMEM;
+	}
+
+	pr_info("ITS: Allocated %d chunks for LPIs\n", (int)lpi_chunks);
+	return 0;
+}
+
+static unsigned long *its_lpi_alloc_chunks(int nr_irqs, int *base, int *nr_ids)
+{
+	unsigned long *bitmap = NULL;
+	int chunk_id;
+	int nr_chunks;
+	int i;
+
+	nr_chunks = DIV_ROUND_UP(nr_irqs, IRQS_PER_CHUNK);
+
+	spin_lock(&lpi_lock);
+
+	do {
+		chunk_id = bitmap_find_next_zero_area(lpi_bitmap, lpi_chunks,
+						      0, nr_chunks, 0);
+		if (chunk_id < lpi_chunks)
+			break;
+
+		nr_chunks--;
+	} while (nr_chunks > 0);
+
+	if (!nr_chunks)
+		goto out;
+
+	bitmap = kzalloc(BITS_TO_LONGS(nr_chunks * IRQS_PER_CHUNK) * sizeof (long),
+			 GFP_ATOMIC);
+	if (!bitmap)
+		goto out;
+
+	for (i = 0; i < nr_chunks; i++)
+		set_bit(chunk_id + i, lpi_bitmap);
+
+	*base = its_chunk_to_lpi(chunk_id);
+	*nr_ids = nr_chunks * IRQS_PER_CHUNK;
+
+out:
+	spin_unlock(&lpi_lock);
+
+	return bitmap;
+}
+
+static void its_lpi_free(unsigned long *bitmap, int base, int nr_ids)
+{
+	int lpi;
+
+	spin_lock(&lpi_lock);
+
+	for (lpi = base; lpi < (base + nr_ids); lpi += IRQS_PER_CHUNK) {
+		int chunk = its_lpi_to_chunk(lpi);
+		BUG_ON(chunk > lpi_chunks);
+		if (test_bit(chunk, lpi_bitmap)) {
+			clear_bit(chunk, lpi_bitmap);
+		} else {
+			pr_err("Bad LPI chunk %d\n", chunk);
+		}
+	}
+
+	spin_unlock(&lpi_lock);
+
+	kfree(bitmap);
+}
+
+/*
+ * We allocate 64kB for PROPBASE. That gives us at most 64K LPIs to
+ * deal with (one configuration byte per interrupt). PENDBASE has to
+ * be 64kB aligned (one bit per LPI, plus 8192 bits for SPI/PPI/SGI).
+ */
+#define LPI_PROPBASE_SZ		SZ_64K
+#define LPI_PENDBASE_SZ		(LPI_PROPBASE_SZ / 8 + SZ_1K)
+
+/*
+ * This is how many bits of ID we need, including the useless ones.
+ */
+#define LPI_NRBITS		ilog2(LPI_PROPBASE_SZ + SZ_8K)
+
+#define LPI_PROP_DEFAULT_PRIO	0xa0
+
+static int __init its_alloc_lpi_tables(void)
+{
+	phys_addr_t paddr;
+
+	gic_rdists->prop_page = alloc_pages(GFP_NOWAIT,
+					   get_order(LPI_PROPBASE_SZ));
+	if (!gic_rdists->prop_page) {
+		pr_err("Failed to allocate PROPBASE\n");
+		return -ENOMEM;
+	}
+
+	paddr = page_to_phys(gic_rdists->prop_page);
+	pr_info("GIC: using LPI property table @%pa\n", &paddr);
+
+	/* Priority 0xa0, Group-1, disabled */
+	memset(page_address(gic_rdists->prop_page),
+	       LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1,
+	       LPI_PROPBASE_SZ);
+
+	/* Make sure the GIC will observe the written configuration */
+	__flush_dcache_area(page_address(gic_rdists->prop_page), LPI_PROPBASE_SZ);
+
+	return 0;
+}
+
+static const char *its_base_type_string[] = {
+	[GITS_BASER_TYPE_DEVICE]	= "Devices",
+	[GITS_BASER_TYPE_VCPU]		= "Virtual CPUs",
+	[GITS_BASER_TYPE_CPU]		= "Physical CPUs",
+	[GITS_BASER_TYPE_COLLECTION]	= "Interrupt Collections",
+	[GITS_BASER_TYPE_RESERVED5] 	= "Reserved (5)",
+	[GITS_BASER_TYPE_RESERVED6] 	= "Reserved (6)",
+	[GITS_BASER_TYPE_RESERVED7] 	= "Reserved (7)",
+};
+
+static void its_free_tables(struct its_node *its)
+{
+	int i;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		if (its->tables[i]) {
+			free_page((unsigned long)its->tables[i]);
+			its->tables[i] = NULL;
+		}
+	}
+}
+
+static int its_alloc_tables(struct its_node *its)
+{
+	int err;
+	int i;
+	int psz = PAGE_SIZE;
+	u64 shr = GITS_BASER_InnerShareable;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		u64 val = readq_relaxed(its->base + GITS_BASER + i * 8);
+		u64 type = GITS_BASER_TYPE(val);
+		u64 entry_size = GITS_BASER_ENTRY_SIZE(val);
+		u64 tmp;
+		void *base;
+
+		if (type == GITS_BASER_TYPE_NONE)
+			continue;
+
+		/* We're lazy and only allocate a single page for now */
+		base = (void *)get_zeroed_page(GFP_KERNEL);
+		if (!base) {
+			err = -ENOMEM;
+			goto out_free;
+		}
+
+		its->tables[i] = base;
+
+retry_baser:
+		val = (virt_to_phys(base) 				 |
+		       (type << GITS_BASER_TYPE_SHIFT)			 |
+		       ((entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT) |
+		       GITS_BASER_WaWb					 |
+		       shr						 |
+		       GITS_BASER_VALID);
+
+		switch (psz) {
+		case SZ_4K:
+			val |= GITS_BASER_PAGE_SIZE_4K;
+			break;
+		case SZ_16K:
+			val |= GITS_BASER_PAGE_SIZE_16K;
+			break;
+		case SZ_64K:
+			val |= GITS_BASER_PAGE_SIZE_64K;
+			break;
+		}
+
+		val |= (PAGE_SIZE / psz) - 1;
+
+		writeq_relaxed(val, its->base + GITS_BASER + i * 8);
+		tmp = readq_relaxed(its->base + GITS_BASER + i * 8);
+
+		if ((val ^ tmp) & GITS_BASER_SHAREABILITY_MASK) {
+			/*
+			 * Shareability didn't stick. Just use
+			 * whatever the read reported, which is likely
+			 * to be the only thing this redistributor
+			 * supports.
+			 */
+			shr = tmp & GITS_BASER_SHAREABILITY_MASK;
+			goto retry_baser;
+		}
+
+		if ((val ^ tmp) & GITS_BASER_PAGE_SIZE_MASK) {
+			/*
+			 * Page size didn't stick. Let's try a smaller
+			 * size and retry. If we reach 4K, then
+			 * something is horribly wrong...
+			 */
+			switch (psz) {
+			case SZ_16K:
+				psz = SZ_4K;
+				goto retry_baser;
+			case SZ_64K:
+				psz = SZ_16K;
+				goto retry_baser;
+			}
+		}
+
+		if (val != tmp) {
+			pr_err("ITS: %s: GITS_BASER%d doesn't stick: %lx %lx\n",
+			       its->msi_chip.of_node->full_name, i,
+			       (unsigned long) val, (unsigned long) tmp);
+			err = -ENXIO;
+			goto out_free;
+		}
+
+		pr_info("ITS: allocated %d %s @%lx (psz %dK, shr %d)\n",
+			(int)(PAGE_SIZE / entry_size),
+			its_base_type_string[type],
+			(unsigned long)virt_to_phys(base),
+			psz / SZ_1K, (int)shr >> GITS_BASER_SHAREABILITY_SHIFT);
+	}
+
+	return 0;
+
+out_free:
+	its_free_tables(its);
+
+	return err;
+}
+
+static int its_alloc_collections(struct its_node *its)
+{
+	its->collections = kzalloc(nr_cpu_ids * sizeof(*its->collections),
+				   GFP_KERNEL);
+	if (!its->collections)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void its_cpu_init_lpis(void)
+{
+	void __iomem *rbase = gic_data_rdist_rd_base();
+	struct page *pend_page;
+	u64 val, tmp;
+
+	/* If we didn't allocate the pending table yet, do it now */
+	pend_page = gic_data_rdist()->pend_page;
+	if (!pend_page) {
+		phys_addr_t paddr;
+		/*
+		 * The pending pages have to be at least 64kB aligned,
+		 * hence the 'max(LPI_PENDBASE_SZ, SZ_64K)' below.
+		 */
+		pend_page = alloc_pages(GFP_NOWAIT | __GFP_ZERO,
+					get_order(max(LPI_PENDBASE_SZ, SZ_64K)));
+		if (!pend_page) {
+			pr_err("Failed to allocate PENDBASE for CPU%d\n",
+			       smp_processor_id());
+			return;
+		}
+
+		/* Make sure the GIC will observe the zero-ed page */
+		__flush_dcache_area(page_address(pend_page), LPI_PENDBASE_SZ);
+
+		paddr = page_to_phys(pend_page);
+		pr_info("CPU%d: using LPI pending table @%pa\n",
+			smp_processor_id(), &paddr);
+		gic_data_rdist()->pend_page = pend_page;
+	}
+
+	/* Disable LPIs */
+	val = readl_relaxed(rbase + GICR_CTLR);
+	val &= ~GICR_CTLR_ENABLE_LPIS;
+	writel_relaxed(val, rbase + GICR_CTLR);
+
+	/*
+	 * Make sure any change to the table is observable by the GIC.
+	 */
+	dsb(sy);
+
+	/* set PROPBASE */
+	val = (page_to_phys(gic_rdists->prop_page) |
+	       GICR_PROPBASER_InnerShareable |
+	       GICR_PROPBASER_WaWb |
+	       ((LPI_NRBITS - 1) & GICR_PROPBASER_IDBITS_MASK));
+
+	writeq_relaxed(val, rbase + GICR_PROPBASER);
+	tmp = readq_relaxed(rbase + GICR_PROPBASER);
+
+	if ((tmp ^ val) & GICR_PROPBASER_SHAREABILITY_MASK) {
+		pr_info_once("GIC: using cache flushing for LPI property table\n");
+		gic_rdists->flags |= RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING;
+	}
+
+	/* set PENDBASE */
+	val = (page_to_phys(pend_page) |
+	       GICR_PROPBASER_InnerShareable |
+	       GICR_PROPBASER_WaWb);
+
+	writeq_relaxed(val, rbase + GICR_PENDBASER);
+
+	/* Enable LPIs */
+	val = readl_relaxed(rbase + GICR_CTLR);
+	val |= GICR_CTLR_ENABLE_LPIS;
+	writel_relaxed(val, rbase + GICR_CTLR);
+
+	/* Make sure the GIC has seen the above */
+	dsb(sy);
+}
+
+static void its_cpu_init_collection(void)
+{
+	struct its_node *its;
+	int cpu;
+
+	spin_lock(&its_lock);
+	cpu = smp_processor_id();
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		u64 target;
+
+		/*
+		 * We now have to bind each collection to its target
+		 * redistributor.
+		 */
+		if (readq_relaxed(its->base + GITS_TYPER) & GITS_TYPER_PTA) {
+			/*
+			 * This ITS wants the physical address of the
+			 * redistributor.
+			 */
+			target = gic_data_rdist()->phys_base;
+		} else {
+			/*
+			 * This ITS wants a linear CPU number.
+			 */
+			target = readq_relaxed(gic_data_rdist_rd_base() + GICR_TYPER);
+			target = GICR_TYPER_CPU_NUMBER(target);
+		}
+
+		/* Perform collection mapping */
+		its->collections[cpu].target_address = target;
+		its->collections[cpu].col_id = cpu;
+
+		its_send_mapc(its, &its->collections[cpu], 1);
+		its_send_invall(its, &its->collections[cpu]);
+	}
+
+	spin_unlock(&its_lock);
+}
+
+static struct its_device *its_find_device(struct its_node *its, u32 dev_id)
+{
+	struct its_device *its_dev = NULL, *tmp;
+
+	raw_spin_lock(&its->lock);
+
+	list_for_each_entry(tmp, &its->its_device_list, entry) {
+		if (tmp->device_id == dev_id) {
+			its_dev = tmp;
+			break;
+		}
+	}
+
+	raw_spin_unlock(&its->lock);
+
+	return its_dev;
+}
+
+static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
+					    int nvecs)
+{
+	struct its_device *dev;
+	unsigned long *lpi_map;
+	void *itt;
+	int lpi_base;
+	int nr_lpis;
+	int nr_ites;
+	int cpu;
+	int sz;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	/*
+	 * At least one bit of EventID is being used, hence a minimum
+	 * of two entries. No, the architecture doesn't let you
+	 * express an ITT with a single entry.
+	 */
+	nr_ites = max(2, roundup_pow_of_two(nvecs));
+	sz = nr_ites * its->ite_size;
+	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
+	itt = kmalloc(sz, GFP_KERNEL);
+	lpi_map = its_lpi_alloc_chunks(nvecs, &lpi_base, &nr_lpis);
+
+	if (!dev || !itt || !lpi_map) {
+		kfree(dev);
+		kfree(itt);
+		kfree(lpi_map);
+		return NULL;
+	}
+
+	dev->its = its;
+	dev->itt = itt;
+	dev->nr_ites = nr_ites;
+	dev->lpi_map = lpi_map;
+	dev->lpi_base = lpi_base;
+	dev->nr_lpis = nr_lpis;
+	dev->device_id = dev_id;
+	INIT_LIST_HEAD(&dev->entry);
+
+	raw_spin_lock(&its->lock);
+	list_add(&dev->entry, &its->its_device_list);
+	raw_spin_unlock(&its->lock);
+
+	/* Bind the device to the first possible CPU */
+	cpu = cpumask_first(cpu_online_mask);
+	dev->collection = &its->collections[cpu];
+
+	/* Map device to its ITT */
+	its_send_mapd(dev, 1);
+
+	return dev;
+}
+
+static void its_free_device(struct its_device *its_dev)
+{
+	raw_spin_lock(&its_dev->its->lock);
+	list_del(&its_dev->entry);
+	raw_spin_unlock(&its_dev->its->lock);
+	kfree(its_dev->itt);
+	kfree(its_dev);
+}
+
+static int its_alloc_device_irq(struct its_device *dev, irq_hw_number_t *hwirq)
+{
+	int idx;
+
+	idx = find_first_zero_bit(dev->lpi_map, dev->nr_lpis);
+	if (idx == dev->nr_lpis)
+		return -ENOSPC;
+
+	*hwirq = dev->lpi_base + idx;
+	set_bit(idx, dev->lpi_map);
+
+	return 0;
+}
+
+static int its_msi_prepare(struct irq_domain *domain, struct device *dev,
+			   int nvec, msi_alloc_info_t *info)
+{
+	struct pci_dev *pdev;
+	struct its_node *its;
+	u32 dev_id;
+	struct its_device *its_dev;
+
+	if (!dev_is_pci(dev))
+		return -EINVAL;
+
+	pdev = to_pci_dev(dev);
+	dev_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
+	its = domain->parent->host_data;
+
+	its_dev = its_find_device(its, dev_id);
+	if (WARN_ON(its_dev))
+		return -EINVAL;
+
+	its_dev = its_create_device(its, dev_id, nvec);
+	if (!its_dev)
+		return -ENOMEM;
+
+	dev_dbg(&pdev->dev, "ITT %d entries, %d bits\n", nvec, ilog2(nvec));
+
+	info->scratchpad[0].ptr = its_dev;
+	info->scratchpad[1].ptr = dev;
+	return 0;
+}
+
+static struct msi_domain_ops its_pci_msi_ops = {
+	.msi_prepare	= its_msi_prepare,
+};
+
+static struct msi_domain_info its_pci_msi_domain_info = {
+	.flags	= (MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
+		   MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX),
+	.ops	= &its_pci_msi_ops,
+	.chip	= &its_msi_irq_chip,
+};
+
+static int its_irq_gic_domain_alloc(struct irq_domain *domain,
+				    unsigned int virq,
+				    irq_hw_number_t hwirq)
+{
+	struct of_phandle_args args;
+
+	args.np = domain->parent->of_node;
+	args.args_count = 3;
+	args.args[0] = GIC_IRQ_TYPE_LPI;
+	args.args[1] = hwirq;
+	args.args[2] = IRQ_TYPE_EDGE_RISING;
+
+	return irq_domain_alloc_irqs_parent(domain, virq, 1, &args);
+}
+
+static int its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				unsigned int nr_irqs, void *args)
+{
+	msi_alloc_info_t *info = args;
+	struct its_device *its_dev = info->scratchpad[0].ptr;
+	irq_hw_number_t hwirq;
+	int err;
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		err = its_alloc_device_irq(its_dev, &hwirq);
+		if (err)
+			return err;
+
+		err = its_irq_gic_domain_alloc(domain, virq + i, hwirq);
+		if (err)
+			return err;
+
+		irq_domain_set_hwirq_and_chip(domain, virq + i,
+					      hwirq, &its_irq_chip, its_dev);
+		dev_dbg(info->scratchpad[1].ptr, "ID:%d pID:%d vID:%d\n",
+			(int)(hwirq - its_dev->lpi_base), (int)hwirq, virq + i);
+	}
+
+	return 0;
+}
+
+static void its_irq_domain_activate(struct irq_domain *domain,
+				    struct irq_data *d)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	u32 event = its_get_event_id(d);
+
+	/* Map the GIC IRQ and event to the device */
+	its_send_mapvi(its_dev, d->hwirq, event);
+}
+
+static void its_irq_domain_deactivate(struct irq_domain *domain,
+				      struct irq_data *d)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	u32 event = its_get_event_id(d);
+
+	/* Stop the delivery of interrupts */
+	its_send_discard(its_dev, event);
+}
+
+static void its_irq_domain_free(struct irq_domain *domain, unsigned int virq,
+				unsigned int nr_irqs)
+{
+	struct irq_data *d = irq_domain_get_irq_data(domain, virq);
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		struct irq_data *data = irq_domain_get_irq_data(domain,
+								virq + i);
+		u32 event = its_get_event_id(data);
+
+		/* Mark interrupt index as unused */
+		clear_bit(event, its_dev->lpi_map);
+
+		/* Nuke the entry in the domain */
+		irq_domain_reset_irq_data(data);
+	}
+
+	/* If all interrupts have been freed, start mopping the floor */
+	if (bitmap_empty(its_dev->lpi_map, its_dev->nr_lpis)) {
+		its_lpi_free(its_dev->lpi_map,
+			     its_dev->lpi_base,
+			     its_dev->nr_lpis);
+
+		/* Unmap device/itt */
+		its_send_mapd(its_dev, 0);
+		its_free_device(its_dev);
+	}
+
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static const struct irq_domain_ops its_domain_ops = {
+	.alloc			= its_irq_domain_alloc,
+	.free			= its_irq_domain_free,
+	.activate		= its_irq_domain_activate,
+	.deactivate		= its_irq_domain_deactivate,
+};
+
+static int its_probe(struct device_node *node, struct irq_domain *parent)
+{
+	struct resource res;
+	struct its_node *its;
+	void __iomem *its_base;
+	u32 val;
+	u64 baser, tmp;
+	int err;
+
+	err = of_address_to_resource(node, 0, &res);
+	if (err) {
+		pr_warn("%s: no regs?\n", node->full_name);
+		return -ENXIO;
+	}
+
+	its_base = ioremap(res.start, resource_size(&res));
+	if (!its_base) {
+		pr_warn("%s: unable to map registers\n", node->full_name);
+		return -ENOMEM;
+	}
+
+	val = readl_relaxed(its_base + GITS_PIDR2) & GIC_PIDR2_ARCH_MASK;
+	if (val != 0x30 && val != 0x40) {
+		pr_warn("%s: no ITS detected, giving up\n", node->full_name);
+		err = -ENODEV;
+		goto out_unmap;
+	}
+
+	pr_info("ITS: %s\n", node->full_name);
+
+	its = kzalloc(sizeof(*its), GFP_KERNEL);
+	if (!its) {
+		err = -ENOMEM;
+		goto out_unmap;
+	}
+
+	raw_spin_lock_init(&its->lock);
+	INIT_LIST_HEAD(&its->entry);
+	INIT_LIST_HEAD(&its->its_device_list);
+	its->base = its_base;
+	its->phys_base = res.start;
+	its->msi_chip.of_node = node;
+	its->ite_size = ((readl_relaxed(its_base + GITS_TYPER) >> 4) & 0xf) + 1;
+
+	its->cmd_base = kzalloc(ITS_CMD_QUEUE_SZ, GFP_KERNEL);
+	if (!its->cmd_base) {
+		err = -ENOMEM;
+		goto out_free_its;
+	}
+	its->cmd_write = its->cmd_base;
+
+	err = its_alloc_tables(its);
+	if (err)
+		goto out_free_cmd;
+
+	err = its_alloc_collections(its);
+	if (err)
+		goto out_free_tables;
+
+	baser = (virt_to_phys(its->cmd_base)	|
+		 GITS_CBASER_WaWb		|
+		 GITS_CBASER_InnerShareable	|
+		 (ITS_CMD_QUEUE_SZ / SZ_4K - 1)	|
+		 GITS_CBASER_VALID);
+
+	writeq_relaxed(baser, its->base + GITS_CBASER);
+	tmp = readq_relaxed(its->base + GITS_CBASER);
+	writeq_relaxed(0, its->base + GITS_CWRITER);
+	writel_relaxed(1, its->base + GITS_CTLR);
+
+	if ((tmp ^ baser) & GITS_BASER_SHAREABILITY_MASK) {
+		pr_info("ITS: using cache flushing for cmd queue\n");
+		its->flags |= ITS_FLAGS_CMDQ_NEEDS_FLUSHING;
+	}
+
+	if (of_property_read_bool(its->msi_chip.of_node, "msi-controller")) {
+		its->domain = irq_domain_add_tree(NULL, &its_domain_ops, its);
+		if (!its->domain) {
+			err = -ENOMEM;
+			goto out_free_tables;
+		}
+
+		its->domain->parent = parent;
+
+		its->msi_chip.domain = pci_msi_create_irq_domain(node,
+								 &its_pci_msi_domain_info,
+								 its->domain);
+		if (!its->msi_chip.domain) {
+			err = -ENOMEM;
+			goto out_free_domains;
+		}
+
+		err = of_pci_msi_chip_add(&its->msi_chip);
+		if (err)
+			goto out_free_domains;
+	}
+
+	spin_lock(&its_lock);
+	list_add(&its->entry, &its_nodes);
+	spin_unlock(&its_lock);
+
+	return 0;
+
+out_free_domains:
+	if (its->msi_chip.domain)
+		irq_domain_remove(its->msi_chip.domain);
+	if (its->domain)
+		irq_domain_remove(its->domain);
+out_free_tables:
+	its_free_tables(its);
+out_free_cmd:
+	kfree(its->cmd_base);
+out_free_its:
+	kfree(its);
+out_unmap:
+	iounmap(its_base);
+	pr_err("ITS: failed probing %s (%d)\n", node->full_name, err);
+	return err;
+}
+
+static bool gic_rdists_supports_plpis(void)
+{
+	return !!(readl_relaxed(gic_data_rdist_rd_base() + GICR_TYPER) & GICR_TYPER_PLPIS);
+}
+
+int its_cpu_init(void)
+{
+	if (!gic_rdists_supports_plpis()) {
+		pr_info("CPU%d: LPIs not supported\n", smp_processor_id());
+		return -ENXIO;
+	}
+
+	if (!list_empty(&its_nodes)) {
+		its_cpu_init_lpis();
+		its_cpu_init_collection();
+	}
+
+	return 0;
+}
+
+static struct of_device_id its_device_id[] = {
+	{	.compatible	= "arm,gic-v3-its",	},
+	{},
+};
+
+int its_init(struct device_node *node, struct rdists *rdists,
+	     struct irq_domain *parent_domain)
+{
+	struct device_node *np;
+
+	for (np = of_find_matching_node(node, its_device_id); np;
+	     np = of_find_matching_node(np, its_device_id)) {
+		its_probe(np, parent_domain);
+	}
+
+	if (list_empty(&its_nodes)) {
+		pr_warn("ITS: No ITS available, not enabling LPIs\n");
+		return -ENXIO;
+	}
+
+	gic_rdists = rdists;
+	gic_root_node = node;
+
+	its_alloc_lpi_tables();
+	its_lpi_init(rdists->id_bits);
+
+	return 0;
+}
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index aa17ae805a70..1a146ccee701 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -34,20 +34,25 @@
 #include "irq-gic-common.h"
 #include "irqchip.h"
 
+struct redist_region {
+	void __iomem		*redist_base;
+	phys_addr_t		phys_base;
+};
+
 struct gic_chip_data {
 	void __iomem		*dist_base;
-	void __iomem		**redist_base;
-	void __iomem * __percpu	*rdist;
+	struct redist_region	*redist_regions;
+	struct rdists		rdists;
 	struct irq_domain	*domain;
 	u64			redist_stride;
-	u32			redist_regions;
+	u32			nr_redist_regions;
 	unsigned int		irq_nr;
 };
 
 static struct gic_chip_data gic_data __read_mostly;
 
-#define gic_data_rdist()		(this_cpu_ptr(gic_data.rdist))
-#define gic_data_rdist_rd_base()	(*gic_data_rdist())
+#define gic_data_rdist()		(this_cpu_ptr(gic_data.rdists.rdist))
+#define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_sgi_base()	(gic_data_rdist_rd_base() + SZ_64K)
 
 /* Our default, arbitrary priority value. Linux only uses one anyway. */
@@ -71,9 +76,6 @@ static inline void __iomem *gic_dist_base(struct irq_data *d)
 	if (d->hwirq <= 1023)		/* SPI -> dist_base */
 		return gic_data.dist_base;
 
-	if (d->hwirq >= 8192)
-		BUG();		/* LPI Detected!!! */
-
 	return NULL;
 }
 
@@ -271,11 +273,11 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 	do {
 		irqnr = gic_read_iar();
 
-		if (likely(irqnr > 15 && irqnr < 1020)) {
+		if (likely(irqnr > 15 && irqnr < 1020) || irqnr >= 8192) {
 			int err;
 			err = handle_domain_irq(gic_data.domain, irqnr, regs);
 			if (err) {
-				WARN_ONCE(true, "Unexpected SPI received!\n");
+				WARN_ONCE(true, "Unexpected interrupt received!\n");
 				gic_write_eoir(irqnr);
 			}
 			continue;
@@ -333,8 +335,8 @@ static int gic_populate_rdist(void)
 	       MPIDR_AFFINITY_LEVEL(mpidr, 1) << 8 |
 	       MPIDR_AFFINITY_LEVEL(mpidr, 0));
 
-	for (i = 0; i < gic_data.redist_regions; i++) {
-		void __iomem *ptr = gic_data.redist_base[i];
+	for (i = 0; i < gic_data.nr_redist_regions; i++) {
+		void __iomem *ptr = gic_data.redist_regions[i].redist_base;
 		u32 reg;
 
 		reg = readl_relaxed(ptr + GICR_PIDR2) & GIC_PIDR2_ARCH_MASK;
@@ -347,10 +349,13 @@ static int gic_populate_rdist(void)
 		do {
 			typer = readq_relaxed(ptr + GICR_TYPER);
 			if ((typer >> 32) == aff) {
+				u64 offset = ptr - gic_data.redist_regions[i].redist_base;
 				gic_data_rdist_rd_base() = ptr;
-				pr_info("CPU%d: found redistributor %llx @%p\n",
+				gic_data_rdist()->phys_base = gic_data.redist_regions[i].phys_base + offset;
+				pr_info("CPU%d: found redistributor %llx region %d:%pa\n",
 					smp_processor_id(),
-					(unsigned long long)mpidr, ptr);
+					(unsigned long long)mpidr,
+					i, &gic_data_rdist()->phys_base);
 				return 0;
 			}
 
@@ -385,6 +390,11 @@ static void gic_cpu_sys_reg_init(void)
 	gic_write_grpen1(1);
 }
 
+static int gic_dist_supports_lpis(void)
+{
+	return !!(readl_relaxed(gic_data.dist_base + GICD_TYPER) & GICD_TYPER_LPIS);
+}
+
 static void gic_cpu_init(void)
 {
 	void __iomem *rbase;
@@ -399,6 +409,10 @@ static void gic_cpu_init(void)
 
 	gic_cpu_config(rbase, gic_redist_wait_for_rwp);
 
+	/* Give LPIs a spin */
+	if (IS_ENABLED(CONFIG_ARM_GIC_V3_ITS) && gic_dist_supports_lpis())
+		its_cpu_init();
+
 	/* initialise system registers */
 	gic_cpu_sys_reg_init();
 }
@@ -585,26 +599,43 @@ static struct irq_chip gic_chip = {
 	.irq_set_affinity	= gic_set_affinity,
 };
 
+#define GIC_ID_NR		(1U << gic_data.rdists.id_bits)
+
 static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 			      irq_hw_number_t hw)
 {
 	/* SGIs are private to the core kernel */
 	if (hw < 16)
 		return -EPERM;
+	/* Nothing here */
+	if (hw >= gic_data.irq_nr && hw < 8192)
+		return -EPERM;
+	/* Off limits */
+	if (hw >= GIC_ID_NR)
+		return -EPERM;
+
 	/* PPIs */
 	if (hw < 32) {
 		irq_set_percpu_devid(irq);
-		irq_set_chip_and_handler(irq, &gic_chip,
-					 handle_percpu_devid_irq);
+		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+				    handle_percpu_devid_irq, NULL, NULL);
 		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
 	}
 	/* SPIs */
 	if (hw >= 32 && hw < gic_data.irq_nr) {
-		irq_set_chip_and_handler(irq, &gic_chip,
-					 handle_fasteoi_irq);
+		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+				    handle_fasteoi_irq, NULL, NULL);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
-	irq_set_chip_data(irq, d->host_data);
+	/* LPIs */
+	if (hw >= 8192 && hw < GIC_ID_NR) {
+		if (!gic_dist_supports_lpis())
+			return -EPERM;
+		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+				    handle_fasteoi_irq, NULL, NULL);
+		set_irq_flags(irq, IRQF_VALID);
+	}
+
 	return 0;
 }
 
@@ -625,6 +656,9 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
 	case 1:			/* PPI */
 		*out_hwirq = intspec[1] + 16;
 		break;
+	case GIC_IRQ_TYPE_LPI:	/* LPI */
+		*out_hwirq = intspec[1];
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -633,17 +667,50 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
 	return 0;
 }
 
+static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				unsigned int nr_irqs, void *arg)
+{
+	int i, ret;
+	irq_hw_number_t hwirq;
+	unsigned int type = IRQ_TYPE_NONE;
+	struct of_phandle_args *irq_data = arg;
+
+	ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
+				   irq_data->args_count, &hwirq, &type);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++)
+		gic_irq_domain_map(domain, virq + i, hwirq + i);
+
+	return 0;
+}
+
+static void gic_irq_domain_free(struct irq_domain *domain, unsigned int virq,
+				unsigned int nr_irqs)
+{
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		struct irq_data *d = irq_domain_get_irq_data(domain, virq + i);
+		irq_set_handler(virq + i, NULL);
+		irq_domain_reset_irq_data(d);
+	}
+}
+
 static const struct irq_domain_ops gic_irq_domain_ops = {
-	.map = gic_irq_domain_map,
 	.xlate = gic_irq_domain_xlate,
+	.alloc = gic_irq_domain_alloc,
+	.free = gic_irq_domain_free,
 };
 
 static int __init gic_of_init(struct device_node *node, struct device_node *parent)
 {
 	void __iomem *dist_base;
-	void __iomem **redist_base;
+	struct redist_region *rdist_regs;
 	u64 redist_stride;
-	u32 redist_regions;
+	u32 nr_redist_regions;
+	u32 typer;
 	u32 reg;
 	int gic_irqs;
 	int err;
@@ -664,54 +731,63 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 		goto out_unmap_dist;
 	}
 
-	if (of_property_read_u32(node, "#redistributor-regions", &redist_regions))
-		redist_regions = 1;
+	if (of_property_read_u32(node, "#redistributor-regions", &nr_redist_regions))
+		nr_redist_regions = 1;
 
-	redist_base = kzalloc(sizeof(*redist_base) * redist_regions, GFP_KERNEL);
-	if (!redist_base) {
+	rdist_regs = kzalloc(sizeof(*rdist_regs) * nr_redist_regions, GFP_KERNEL);
+	if (!rdist_regs) {
 		err = -ENOMEM;
 		goto out_unmap_dist;
 	}
 
-	for (i = 0; i < redist_regions; i++) {
-		redist_base[i] = of_iomap(node, 1 + i);
-		if (!redist_base[i]) {
+	for (i = 0; i < nr_redist_regions; i++) {
+		struct resource res;
+		int ret;
+
+		ret = of_address_to_resource(node, 1 + i, &res);
+		rdist_regs[i].redist_base = of_iomap(node, 1 + i);
+		if (ret || !rdist_regs[i].redist_base) {
 			pr_err("%s: couldn't map region %d\n",
 			       node->full_name, i);
 			err = -ENODEV;
 			goto out_unmap_rdist;
 		}
+		rdist_regs[i].phys_base = res.start;
 	}
 
 	if (of_property_read_u64(node, "redistributor-stride", &redist_stride))
 		redist_stride = 0;
 
 	gic_data.dist_base = dist_base;
-	gic_data.redist_base = redist_base;
-	gic_data.redist_regions = redist_regions;
+	gic_data.redist_regions = rdist_regs;
+	gic_data.nr_redist_regions = nr_redist_regions;
 	gic_data.redist_stride = redist_stride;
 
 	/*
 	 * Find out how many interrupts are supported.
 	 * The GIC only supports up to 1020 interrupt sources (SGI+PPI+SPI)
 	 */
-	gic_irqs = readl_relaxed(gic_data.dist_base + GICD_TYPER) & 0x1f;
-	gic_irqs = (gic_irqs + 1) * 32;
+	typer = readl_relaxed(gic_data.dist_base + GICD_TYPER);
+	gic_data.rdists.id_bits = GICD_TYPER_ID_BITS(typer);
+	gic_irqs = GICD_TYPER_IRQS(typer);
 	if (gic_irqs > 1020)
 		gic_irqs = 1020;
 	gic_data.irq_nr = gic_irqs;
 
 	gic_data.domain = irq_domain_add_tree(node, &gic_irq_domain_ops,
 					      &gic_data);
-	gic_data.rdist = alloc_percpu(typeof(*gic_data.rdist));
+	gic_data.rdists.rdist = alloc_percpu(typeof(*gic_data.rdists.rdist));
 
-	if (WARN_ON(!gic_data.domain) || WARN_ON(!gic_data.rdist)) {
+	if (WARN_ON(!gic_data.domain) || WARN_ON(!gic_data.rdists.rdist)) {
 		err = -ENOMEM;
 		goto out_free;
 	}
 
 	set_handle_irq(gic_handle_irq);
 
+	if (IS_ENABLED(CONFIG_ARM_GIC_V3_ITS) && gic_dist_supports_lpis())
+		its_init(node, &gic_data.rdists, gic_data.domain);
+
 	gic_smp_init();
 	gic_dist_init();
 	gic_cpu_init();
@@ -722,12 +798,12 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 out_free:
 	if (gic_data.domain)
 		irq_domain_remove(gic_data.domain);
-	free_percpu(gic_data.rdist);
+	free_percpu(gic_data.rdists.rdist);
 out_unmap_rdist:
-	for (i = 0; i < redist_regions; i++)
-		if (redist_base[i])
-			iounmap(redist_base[i]);
-	kfree(redist_base);
+	for (i = 0; i < nr_redist_regions; i++)
+		if (rdist_regs[i].redist_base)
+			iounmap(rdist_regs[i].redist_base);
+	kfree(rdist_regs);
 out_unmap_dist:
 	iounmap(dist_base);
 	return err;
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 38493ff28fa5..5a71be79786d 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -788,17 +788,16 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 {
 	if (hw < 32) {
 		irq_set_percpu_devid(irq);
-		irq_set_chip_and_handler(irq, &gic_chip,
-					 handle_percpu_devid_irq);
+		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+				    handle_percpu_devid_irq, NULL, NULL);
 		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
 	} else {
-		irq_set_chip_and_handler(irq, &gic_chip,
-					 handle_fasteoi_irq);
+		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
+				    handle_fasteoi_irq, NULL, NULL);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 
 		gic_routable_irq_domain_ops->map(d, irq, hw);
 	}
-	irq_set_chip_data(irq, d->host_data);
 	return 0;
 }
 
@@ -858,6 +857,31 @@ static struct notifier_block gic_cpu_notifier = {
 };
 #endif
 
+static int gic_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				unsigned int nr_irqs, void *arg)
+{
+	int i, ret;
+	irq_hw_number_t hwirq;
+	unsigned int type = IRQ_TYPE_NONE;
+	struct of_phandle_args *irq_data = arg;
+
+	ret = gic_irq_domain_xlate(domain, irq_data->np, irq_data->args,
+				   irq_data->args_count, &hwirq, &type);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++)
+		gic_irq_domain_map(domain, virq + i, hwirq + i);
+
+	return 0;
+}
+
+static const struct irq_domain_ops gic_irq_domain_hierarchy_ops = {
+	.xlate = gic_irq_domain_xlate,
+	.alloc = gic_irq_domain_alloc,
+	.free = irq_domain_free_irqs_top,
+};
+
 static const struct irq_domain_ops gic_irq_domain_ops = {
 	.map = gic_irq_domain_map,
 	.unmap = gic_irq_domain_unmap,
@@ -948,18 +972,6 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		gic_cpu_map[i] = 0xff;
 
 	/*
-	 * For primary GICs, skip over SGIs.
-	 * For secondary GICs, skip over PPIs, too.
-	 */
-	if (gic_nr == 0 && (irq_start & 31) > 0) {
-		hwirq_base = 16;
-		if (irq_start != -1)
-			irq_start = (irq_start & ~31) + 16;
-	} else {
-		hwirq_base = 32;
-	}
-
-	/*
 	 * Find out how many interrupts are supported.
 	 * The GIC only supports up to 1020 interrupt sources.
 	 */
@@ -969,10 +981,31 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		gic_irqs = 1020;
 	gic->gic_irqs = gic_irqs;
 
-	gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
+	if (node) {		/* DT case */
+		const struct irq_domain_ops *ops = &gic_irq_domain_hierarchy_ops;
+
+		if (!of_property_read_u32(node, "arm,routable-irqs",
+					  &nr_routable_irqs)) {
+			ops = &gic_irq_domain_ops;
+			gic_irqs = nr_routable_irqs;
+		}
+
+		gic->domain = irq_domain_add_linear(node, gic_irqs, ops, gic);
+	} else {		/* Non-DT case */
+		/*
+		 * For primary GICs, skip over SGIs.
+		 * For secondary GICs, skip over PPIs, too.
+		 */
+		if (gic_nr == 0 && (irq_start & 31) > 0) {
+			hwirq_base = 16;
+			if (irq_start != -1)
+				irq_start = (irq_start & ~31) + 16;
+		} else {
+			hwirq_base = 32;
+		}
+
+		gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
 
-	if (of_property_read_u32(node, "arm,routable-irqs",
-				 &nr_routable_irqs)) {
 		irq_base = irq_alloc_descs(irq_start, 16, gic_irqs,
 					   numa_node_id());
 		if (IS_ERR_VALUE(irq_base)) {
@@ -983,10 +1016,6 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 
 		gic->domain = irq_domain_add_legacy(node, gic_irqs, irq_base,
 					hwirq_base, &gic_irq_domain_ops, gic);
-	} else {
-		gic->domain = irq_domain_add_linear(node, nr_routable_irqs,
-						    &gic_irq_domain_ops,
-						    gic);
 	}
 
 	if (WARN_ON(!gic->domain))
@@ -1037,6 +1066,10 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 		irq = irq_of_parse_and_map(node, 0);
 		gic_cascade_irq(gic_cnt, irq);
 	}
+
+	if (IS_ENABLED(CONFIG_ARM_GIC_V2M))
+		gicv2m_of_init(node, gic_data[gic_cnt].domain);
+
 	gic_cnt++;
 	return 0;
 }
diff --git a/drivers/irqchip/irq-mtk-sysirq.c b/drivers/irqchip/irq-mtk-sysirq.c
new file mode 100644
index 000000000000..7e342df6a62f
--- /dev/null
+++ b/drivers/irqchip/irq-mtk-sysirq.c
@@ -0,0 +1,163 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Joe.C <yingjoe.chen@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include "irqchip.h"
+
+#define MT6577_SYS_INTPOL_NUM	(224)
+
+struct mtk_sysirq_chip_data {
+	spinlock_t lock;
+	void __iomem *intpol_base;
+};
+
+static int mtk_sysirq_set_type(struct irq_data *data, unsigned int type)
+{
+	irq_hw_number_t hwirq = data->hwirq;
+	struct mtk_sysirq_chip_data *chip_data = data->chip_data;
+	u32 offset, reg_index, value;
+	unsigned long flags;
+	int ret;
+
+	offset = hwirq & 0x1f;
+	reg_index = hwirq >> 5;
+
+	spin_lock_irqsave(&chip_data->lock, flags);
+	value = readl_relaxed(chip_data->intpol_base + reg_index * 4);
+	if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_EDGE_FALLING) {
+		if (type == IRQ_TYPE_LEVEL_LOW)
+			type = IRQ_TYPE_LEVEL_HIGH;
+		else
+			type = IRQ_TYPE_EDGE_RISING;
+		value |= (1 << offset);
+	} else {
+		value &= ~(1 << offset);
+	}
+	writel(value, chip_data->intpol_base + reg_index * 4);
+
+	data = data->parent_data;
+	ret = data->chip->irq_set_type(data, type);
+	spin_unlock_irqrestore(&chip_data->lock, flags);
+	return ret;
+}
+
+static struct irq_chip mtk_sysirq_chip = {
+	.name			= "MT_SYSIRQ",
+	.irq_mask		= irq_chip_mask_parent,
+	.irq_unmask		= irq_chip_unmask_parent,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_set_type		= mtk_sysirq_set_type,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_set_affinity	= irq_chip_set_affinity_parent,
+};
+
+static int mtk_sysirq_domain_xlate(struct irq_domain *d,
+				   struct device_node *controller,
+				   const u32 *intspec, unsigned int intsize,
+				   unsigned long *out_hwirq,
+				   unsigned int *out_type)
+{
+	if (intsize != 3)
+		return -EINVAL;
+
+	/* sysirq doesn't support PPI */
+	if (intspec[0])
+		return -EINVAL;
+
+	*out_hwirq = intspec[1];
+	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;
+	return 0;
+}
+
+static int mtk_sysirq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				   unsigned int nr_irqs, void *arg)
+{
+	int i;
+	irq_hw_number_t hwirq;
+	struct of_phandle_args *irq_data = arg;
+	struct of_phandle_args gic_data = *irq_data;
+
+	if (irq_data->args_count != 3)
+		return -EINVAL;
+
+	/* sysirq doesn't support PPI */
+	if (irq_data->args[0])
+		return -EINVAL;
+
+	hwirq = irq_data->args[1];
+	for (i = 0; i < nr_irqs; i++)
+		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
+					      &mtk_sysirq_chip,
+					      domain->host_data);
+
+	gic_data.np = domain->parent->of_node;
+	return irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, &gic_data);
+}
+
+static struct irq_domain_ops sysirq_domain_ops = {
+	.xlate = mtk_sysirq_domain_xlate,
+	.alloc = mtk_sysirq_domain_alloc,
+	.free = irq_domain_free_irqs_common,
+};
+
+static int __init mtk_sysirq_of_init(struct device_node *node,
+				     struct device_node *parent)
+{
+	struct irq_domain *domain, *domain_parent;
+	struct mtk_sysirq_chip_data *chip_data;
+	int ret = 0;
+
+	domain_parent = irq_find_host(parent);
+	if (!domain_parent) {
+		pr_err("mtk_sysirq: interrupt-parent not found\n");
+		return -EINVAL;
+	}
+
+	chip_data = kzalloc(sizeof(*chip_data), GFP_KERNEL);
+	if (!chip_data)
+		return -ENOMEM;
+
+	chip_data->intpol_base = of_io_request_and_map(node, 0, "intpol");
+	if (!chip_data->intpol_base) {
+		pr_err("mtk_sysirq: unable to map sysirq register\n");
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	domain = irq_domain_add_hierarchy(domain_parent, 0,
+					  MT6577_SYS_INTPOL_NUM, node,
+					  &sysirq_domain_ops, chip_data);
+	if (!domain) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+	spin_lock_init(&chip_data->lock);
+
+	return 0;
+
+out_unmap:
+	iounmap(chip_data->intpol_base);
+out_free:
+	kfree(chip_data);
+	return ret;
+}
+IRQCHIP_DECLARE(mtk_sysirq, "mediatek,mt6577-sysirq", mtk_sysirq_of_init);
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 03a4ea37ba86..1e8b0cf30792 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -49,6 +49,10 @@
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
 
+#define GICD_TYPER_ID_BITS(typer)	((((typer) >> 19) & 0x1f) + 1)
+#define GICD_TYPER_IRQS(typer)		((((typer) & 0x1f) + 1) * 32)
+#define GICD_TYPER_LPIS			(1U << 17)
+
 #define GICD_IROUTER_SPI_MODE_ONE	(0U << 31)
 #define GICD_IROUTER_SPI_MODE_ANY	(1U << 31)
 
@@ -76,9 +80,27 @@
 #define GICR_MOVALLR			0x0110
 #define GICR_PIDR2			GICD_PIDR2
 
+#define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
+
+#define GICR_TYPER_CPU_NUMBER(r)	(((r) >> 8) & 0xffff)
+
 #define GICR_WAKER_ProcessorSleep	(1U << 1)
 #define GICR_WAKER_ChildrenAsleep	(1U << 2)
 
+#define GICR_PROPBASER_NonShareable	(0U << 10)
+#define GICR_PROPBASER_InnerShareable	(1U << 10)
+#define GICR_PROPBASER_OuterShareable	(2U << 10)
+#define GICR_PROPBASER_SHAREABILITY_MASK (3UL << 10)
+#define GICR_PROPBASER_nCnB		(0U << 7)
+#define GICR_PROPBASER_nC		(1U << 7)
+#define GICR_PROPBASER_RaWt		(2U << 7)
+#define GICR_PROPBASER_RaWb		(3U << 7)
+#define GICR_PROPBASER_WaWt		(4U << 7)
+#define GICR_PROPBASER_WaWb		(5U << 7)
+#define GICR_PROPBASER_RaWaWt		(6U << 7)
+#define GICR_PROPBASER_RaWaWb		(7U << 7)
+#define GICR_PROPBASER_IDBITS_MASK	(0x1f)
+
 /*
  * Re-Distributor registers, offsets from SGI_base
  */
@@ -91,9 +113,93 @@
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
 #define GICR_ICFGR0			GICD_ICFGR
 
+#define GICR_TYPER_PLPIS		(1U << 0)
 #define GICR_TYPER_VLPIS		(1U << 1)
 #define GICR_TYPER_LAST			(1U << 4)
 
+#define LPI_PROP_GROUP1			(1 << 1)
+#define LPI_PROP_ENABLED		(1 << 0)
+
+/*
+ * ITS registers, offsets from ITS_base
+ */
+#define GITS_CTLR			0x0000
+#define GITS_IIDR			0x0004
+#define GITS_TYPER			0x0008
+#define GITS_CBASER			0x0080
+#define GITS_CWRITER			0x0088
+#define GITS_CREADR			0x0090
+#define GITS_BASER			0x0100
+#define GITS_PIDR2			GICR_PIDR2
+
+#define GITS_TRANSLATER			0x10040
+
+#define GITS_TYPER_PTA			(1UL << 19)
+
+#define GITS_CBASER_VALID		(1UL << 63)
+#define GITS_CBASER_nCnB		(0UL << 59)
+#define GITS_CBASER_nC			(1UL << 59)
+#define GITS_CBASER_RaWt		(2UL << 59)
+#define GITS_CBASER_RaWb		(3UL << 59)
+#define GITS_CBASER_WaWt		(4UL << 59)
+#define GITS_CBASER_WaWb		(5UL << 59)
+#define GITS_CBASER_RaWaWt		(6UL << 59)
+#define GITS_CBASER_RaWaWb		(7UL << 59)
+#define GITS_CBASER_NonShareable	(0UL << 10)
+#define GITS_CBASER_InnerShareable	(1UL << 10)
+#define GITS_CBASER_OuterShareable	(2UL << 10)
+#define GITS_CBASER_SHAREABILITY_MASK	(3UL << 10)
+
+#define GITS_BASER_NR_REGS		8
+
+#define GITS_BASER_VALID		(1UL << 63)
+#define GITS_BASER_nCnB			(0UL << 59)
+#define GITS_BASER_nC			(1UL << 59)
+#define GITS_BASER_RaWt			(2UL << 59)
+#define GITS_BASER_RaWb			(3UL << 59)
+#define GITS_BASER_WaWt			(4UL << 59)
+#define GITS_BASER_WaWb			(5UL << 59)
+#define GITS_BASER_RaWaWt		(6UL << 59)
+#define GITS_BASER_RaWaWb		(7UL << 59)
+#define GITS_BASER_TYPE_SHIFT		(56)
+#define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
+#define GITS_BASER_ENTRY_SIZE_SHIFT	(48)
+#define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0xff) + 1)
+#define GITS_BASER_NonShareable		(0UL << 10)
+#define GITS_BASER_InnerShareable	(1UL << 10)
+#define GITS_BASER_OuterShareable	(2UL << 10)
+#define GITS_BASER_SHAREABILITY_SHIFT	(10)
+#define GITS_BASER_SHAREABILITY_MASK	(3UL << GITS_BASER_SHAREABILITY_SHIFT)
+#define GITS_BASER_PAGE_SIZE_SHIFT	(8)
+#define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_64K	(2UL << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
+
+#define GITS_BASER_TYPE_NONE		0
+#define GITS_BASER_TYPE_DEVICE		1
+#define GITS_BASER_TYPE_VCPU		2
+#define GITS_BASER_TYPE_CPU		3
+#define GITS_BASER_TYPE_COLLECTION	4
+#define GITS_BASER_TYPE_RESERVED5	5
+#define GITS_BASER_TYPE_RESERVED6	6
+#define GITS_BASER_TYPE_RESERVED7	7
+
+/*
+ * ITS commands
+ */
+#define GITS_CMD_MAPD			0x08
+#define GITS_CMD_MAPC			0x09
+#define GITS_CMD_MAPVI			0x0a
+#define GITS_CMD_MOVI			0x01
+#define GITS_CMD_DISCARD		0x0f
+#define GITS_CMD_INV			0x0c
+#define GITS_CMD_MOVALL			0x0e
+#define GITS_CMD_INVALL			0x0d
+#define GITS_CMD_INT			0x03
+#define GITS_CMD_CLEAR			0x04
+#define GITS_CMD_SYNC			0x05
+
 /*
  * CPU interface registers
  */
@@ -189,12 +295,34 @@
 
 #include <linux/stringify.h>
 
+/*
+ * We need a value to serve as a irq-type for LPIs. Choose one that will
+ * hopefully pique the interest of the reviewer.
+ */
+#define GIC_IRQ_TYPE_LPI		0xa110c8ed
+
+struct rdists {
+	struct {
+		void __iomem	*rd_base;
+		struct page	*pend_page;
+		phys_addr_t	phys_base;
+	} __percpu		*rdist;
+	struct page		*prop_page;
+	int			id_bits;
+	u64			flags;
+};
+
 static inline void gic_write_eoir(u64 irq)
 {
 	asm volatile("msr_s " __stringify(ICC_EOIR1_EL1) ", %0" : : "r" (irq));
 	isb();
 }
 
+struct irq_domain;
+int its_cpu_init(void);
+int its_init(struct device_node *node, struct rdists *rdists,
+	     struct irq_domain *domain);
+
 #endif
 
 #endif
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 13eed92c7d24..71d706d5f169 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -91,6 +91,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/irqdomain.h>
+
 struct device_node;
 
 extern struct irq_chip gic_arch_extn;
@@ -106,6 +108,8 @@ static inline void gic_init(unsigned int nr, int start,
 	gic_init_bases(nr, start, dist, cpu, 0, NULL);
 }
 
+int gicv2m_of_init(struct device_node *node, struct irq_domain *parent);
+
 void gic_send_sgi(unsigned int cpu_id, unsigned int irq);
 int gic_get_cpu_id(unsigned int cpu);
 void gic_migrate_target(unsigned int new_cpu_id);
