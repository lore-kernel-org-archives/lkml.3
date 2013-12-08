Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab3LHOQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 09:16:25 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:35927 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3LHOOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 09:14:17 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/9] irqchip: add DesignWare APB ICTL interrupt controller
Date: Sun,  8 Dec 2013 15:13:58 +0100
Message-Id: <1386512047-874-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1383661723-17956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1386512047-874-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an irqchip driver and corresponding devicetree binding for the
secondary interrupt controllers based on Synopsys DesignWare IP dw_apb_ictl.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Jisheng Zhang <jszhang@marvell.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
Changelog:
v2->v4:
- none
v1->v2:
- reword binding docu for reg property and add FIQ decoding note
  (Suggested by Mark Rutland)
- add cleanup on error path (Reported by Jisheng Zhang)
RFCv1->RFCv2:
- added copyright reference

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../interrupt-controller/snps,dw-apb-ictl.txt      |  32 +++++
 drivers/irqchip/Kconfig                            |   4 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-dw-apb-ictl.c                  | 150 +++++++++++++++++++++
 4 files changed, 187 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
 create mode 100644 drivers/irqchip/irq-dw-apb-ictl.c

diff --git a/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt b/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
new file mode 100644
index 0000000..4929117
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/snps,dw-apb-ictl.txt
@@ -0,0 +1,32 @@
+Synopsys DesignWare APB interrupt controller (dw_apb_ictl)
+
+Synopsys DesignWare provides interrupt controller IP for APB known as
+dw_apb_ictl. The IP is used as secondary interrupt controller in some SoCs with
+APB bus, e.g. Marvell Armada 1500.
+
+Required properties:
+- compatible: shall be "snps,dw-apb-ictl"
+- reg: physical base address of the controller and length of memory mapped
+  region starting with ENABLE_LOW register
+- interrupt-controller: identifies the node as an interrupt controller
+- #interrupt-cells: number of cells to encode an interrupt-specifier, shall be 1
+- interrupts: interrupt reference to primary interrupt controller
+- interrupt-parent: (optional) reference specific primary interrupt controller
+
+The interrupt sources map to the corresponding bits in the interrupt
+registers, i.e.
+- 0 maps to bit 0 of low interrupts,
+- 1 maps to bit 1 of low interrupts,
+- 32 maps to bit 0 of high interrupts,
+- 33 maps to bit 1 of high interrupts,
+- (optional) fast interrupts start at 64.
+
+Example:
+	aic: interrupt-controller@3000 {
+		compatible = "snps,dw-apb-ictl";
+		reg = <0x3000 0xc00>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
+	};
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 3792a1a..940638d 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -30,6 +30,10 @@ config ARM_VIC_NR
 	  The maximum number of VICs available in the system, for
 	  power management.
 
+config DW_APB_ICTL
+	bool
+	select IRQ_DOMAIN
+
 config IMGPDC_IRQ
 	bool
 	select GENERIC_IRQ_CHIP
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index c60b901..6427323 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_ARCH_MMP)			+= irq-mmp.o
 obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
 obj-$(CONFIG_ARCH_MXS)			+= irq-mxs.o
 obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.o
+obj-$(CONFIG_DW_APB_ICTL)		+= irq-dw-apb-ictl.o
 obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
diff --git a/drivers/irqchip/irq-dw-apb-ictl.c b/drivers/irqchip/irq-dw-apb-ictl.c
new file mode 100644
index 0000000..31e231e
--- /dev/null
+++ b/drivers/irqchip/irq-dw-apb-ictl.c
@@ -0,0 +1,150 @@
+/*
+ * Synopsys DW APB ICTL irqchip driver.
+ *
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ * based on GPL'ed 2.6 kernel sources
+ *  (c) Marvell International Ltd.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
+#include "irqchip.h"
+
+#define APB_INT_ENABLE_L	0x00
+#define APB_INT_ENABLE_H	0x04
+#define APB_INT_MASK_L		0x08
+#define APB_INT_MASK_H		0x0c
+#define APB_INT_FINALSTATUS_L	0x30
+#define APB_INT_FINALSTATUS_H	0x34
+
+static void dw_apb_ictl_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_chip *chip = irq_get_chip(irq);
+	struct irq_chip_generic *gc = irq_get_handler_data(irq);
+	struct irq_domain *d = gc->private;
+	u32 stat;
+	int n;
+
+	chained_irq_enter(chip, desc);
+
+	for (n = 0; n < gc->num_ct; n++) {
+		stat = readl_relaxed(gc->reg_base +
+				     APB_INT_FINALSTATUS_L + 4 * n);
+		while (stat) {
+			u32 hwirq = ffs(stat) - 1;
+			generic_handle_irq(irq_find_mapping(d,
+					    gc->irq_base + hwirq + 32 * n));
+			stat &= ~(1 << hwirq);
+		}
+	}
+
+	chained_irq_exit(chip, desc);
+}
+
+static int __init dw_apb_ictl_init(struct device_node *np,
+				   struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct resource r;
+	struct irq_domain *domain;
+	struct irq_chip_generic *gc;
+	void __iomem *iobase;
+	int ret, nrirqs, irq;
+	u32 reg;
+
+	/* Map the parent interrupt for the chained handler */
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq <= 0) {
+		pr_err("%s: unable to parse irq\n", np->full_name);
+		return -EINVAL;
+	}
+
+	ret = of_address_to_resource(np, 0, &r);
+	if (ret) {
+		pr_err("%s: unable to get resource\n", np->full_name);
+		return ret;
+	}
+
+	if (!request_mem_region(r.start, resource_size(&r), np->full_name)) {
+		pr_err("%s: unable to request mem region\n", np->full_name);
+		return -ENOMEM;
+	}
+
+	iobase = ioremap(r.start, resource_size(&r));
+	if (!iobase) {
+		pr_err("%s: unable to map resource\n", np->full_name);
+		ret = -ENOMEM;
+		goto err_release;
+	}
+
+	/*
+	 * DW IP can be configured to allow 2-64 irqs. We can determine
+	 * the number of irqs supported by writing into enable register
+	 * and look for bits not set, as corresponding flip-flops will
+	 * have been removed by sythesis tool.
+	 */
+
+	/* mask and enable all interrupts */
+	writel(~0, iobase + APB_INT_MASK_L);
+	writel(~0, iobase + APB_INT_MASK_H);
+	writel(~0, iobase + APB_INT_ENABLE_L);
+	writel(~0, iobase + APB_INT_ENABLE_H);
+
+	reg = readl(iobase + APB_INT_ENABLE_H);
+	if (reg)
+		nrirqs = 32 + fls(reg);
+	else
+		nrirqs = fls(readl(iobase + APB_INT_ENABLE_L));
+
+	domain = irq_domain_add_linear(np, nrirqs,
+				       &irq_generic_chip_ops, NULL);
+	if (!domain) {
+		pr_err("%s: unable to add irq domain\n", np->full_name);
+		ret = -ENOMEM;
+		goto err_unmap;
+	}
+
+	ret = irq_alloc_domain_generic_chips(domain, 32, (nrirqs > 32) ? 2 : 1,
+					     np->name, handle_level_irq, clr, 0,
+					     IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_err("%s: unable to alloc irq domain gc\n", np->full_name);
+		goto err_unmap;
+	}
+
+	gc = irq_get_domain_generic_chip(domain, 0);
+	gc->private = domain;
+	gc->reg_base = iobase;
+
+	gc->chip_types[0].regs.mask = APB_INT_MASK_L;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_set_bit;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_clr_bit;
+
+	if (nrirqs > 32) {
+		gc->chip_types[1].regs.mask = APB_INT_MASK_H;
+		gc->chip_types[1].chip.irq_mask = irq_gc_mask_set_bit;
+		gc->chip_types[1].chip.irq_unmask = irq_gc_mask_clr_bit;
+	}
+
+	irq_set_handler_data(irq, gc);
+	irq_set_chained_handler(irq, dw_apb_ictl_handler);
+
+	return 0;
+
+err_unmap:
+	iounmap(iobase);
+err_release:
+	release_mem_region(r.start, resource_size(&r));
+	return ret;
+}
+IRQCHIP_DECLARE(dw_apb_ictl,
+		"snps,dw-apb-ictl", dw_apb_ictl_init);
-- 
1.8.4.rc3

