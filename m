Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab3GMLPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:15:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:44364 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3GMLPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:15:20 -0400
Date: Sat, 13 Jul 2013 13:15:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] irq updates for 3.11
Message-ID: <alpine.DEB.2.02.1307131313180.11918@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

   * Core fix for missing round up in the generic irq chip
     implementation
   * New irq chip for MOXA SoCs
   * A few fixes and cleanups in the irqchip drivers

Thanks,

	tglx

------------------>
Axel Lin (4):
      irqchip: vt8500: Staticize local symbols
      irqchip: sun4i: Staticize sun4i_irq_ack()
      irqchip: nvic: Fix wrong num_ct argument for irq_alloc_domain_generic_chips()
      genirq: generic chip: Use DIV_ROUND_UP to calculate numchips

Jonas Jensen (1):
      irqchip: Add support for MOXA ART SoCs


 drivers/irqchip/Makefile     |    1 +
 drivers/irqchip/irq-moxart.c |  117 ++++++++++++++++++++++++++++++++++++++++++
 drivers/irqchip/irq-nvic.c   |    2 +-
 drivers/irqchip/irq-sun4i.c  |    2 +-
 drivers/irqchip/irq-vt8500.c |    6 ++-
 kernel/irq/generic-chip.c    |    2 +-
 6 files changed, 125 insertions(+), 5 deletions(-)
 create mode 100644 drivers/irqchip/irq-moxart.c

diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 2065ef6..e65c41a 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_ARCH_MXS)			+= irq-mxs.o
 obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.o
 obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
+obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
 obj-$(CONFIG_ORION_IRQCHIP)		+= irq-orion.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
diff --git a/drivers/irqchip/irq-moxart.c b/drivers/irqchip/irq-moxart.c
new file mode 100644
index 0000000..5552fc2
--- /dev/null
+++ b/drivers/irqchip/irq-moxart.c
@@ -0,0 +1,117 @@
+/*
+ * MOXA ART SoCs IRQ chip driver.
+ *
+ * Copyright (C) 2013 Jonas Jensen
+ *
+ * Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irqdomain.h>
+
+#include <asm/exception.h>
+
+#include "irqchip.h"
+
+#define IRQ_SOURCE_REG		0
+#define IRQ_MASK_REG		0x04
+#define IRQ_CLEAR_REG		0x08
+#define IRQ_MODE_REG		0x0c
+#define IRQ_LEVEL_REG		0x10
+#define IRQ_STATUS_REG		0x14
+
+#define FIQ_SOURCE_REG		0x20
+#define FIQ_MASK_REG		0x24
+#define FIQ_CLEAR_REG		0x28
+#define FIQ_MODE_REG		0x2c
+#define FIQ_LEVEL_REG		0x30
+#define FIQ_STATUS_REG		0x34
+
+
+struct moxart_irq_data {
+	void __iomem *base;
+	struct irq_domain *domain;
+	unsigned int interrupt_mask;
+};
+
+static struct moxart_irq_data intc;
+
+static asmlinkage void __exception_irq_entry handle_irq(struct pt_regs *regs)
+{
+	u32 irqstat;
+	int hwirq;
+
+	irqstat = readl(intc.base + IRQ_STATUS_REG);
+
+	while (irqstat) {
+		hwirq = ffs(irqstat) - 1;
+		handle_IRQ(irq_linear_revmap(intc.domain, hwirq), regs);
+		irqstat &= ~(1 << hwirq);
+	}
+}
+
+static int __init moxart_of_intc_init(struct device_node *node,
+				      struct device_node *parent)
+{
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	int ret;
+	struct irq_chip_generic *gc;
+
+	intc.base = of_iomap(node, 0);
+	if (!intc.base) {
+		pr_err("%s: unable to map IC registers\n",
+		       node->full_name);
+		return -EINVAL;
+	}
+
+	intc.domain = irq_domain_add_linear(node, 32, &irq_generic_chip_ops,
+					    intc.base);
+	if (!intc.domain) {
+		pr_err("%s: unable to create IRQ domain\n", node->full_name);
+		return -EINVAL;
+	}
+
+	ret = irq_alloc_domain_generic_chips(intc.domain, 32, 1,
+					     "MOXARTINTC", handle_edge_irq,
+					     clr, 0, IRQ_GC_INIT_MASK_CACHE);
+	if (ret) {
+		pr_err("%s: could not allocate generic chip\n",
+		       node->full_name);
+		irq_domain_remove(intc.domain);
+		return -EINVAL;
+	}
+
+	ret = of_property_read_u32(node, "interrupt-mask",
+				   &intc.interrupt_mask);
+	if (ret)
+		pr_err("%s: could not read interrupt-mask DT property\n",
+		       node->full_name);
+
+	gc = irq_get_domain_generic_chip(intc.domain, 0);
+
+	gc->reg_base = intc.base;
+	gc->chip_types[0].regs.mask = IRQ_MASK_REG;
+	gc->chip_types[0].regs.ack = IRQ_CLEAR_REG;
+	gc->chip_types[0].chip.irq_ack = irq_gc_ack_set_bit;
+	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
+	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
+
+	writel(0, intc.base + IRQ_MASK_REG);
+	writel(0xffffffff, intc.base + IRQ_CLEAR_REG);
+
+	writel(intc.interrupt_mask, intc.base + IRQ_MODE_REG);
+	writel(intc.interrupt_mask, intc.base + IRQ_LEVEL_REG);
+
+	set_handle_irq(handle_irq);
+
+	return 0;
+}
+IRQCHIP_DECLARE(moxa_moxart_ic, "moxa,moxart-ic", moxart_of_intc_init);
diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
index 8d0c8b3..70bdf6e 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -84,7 +84,7 @@ static int __init nvic_of_init(struct device_node *node,
 		return -ENOMEM;
 	}
 
-	ret = irq_alloc_domain_generic_chips(nvic_irq_domain, 32, numbanks,
+	ret = irq_alloc_domain_generic_chips(nvic_irq_domain, 32, 1,
 					     "nvic_irq", handle_fasteoi_irq,
 					     clr, 0, IRQ_GC_INIT_MASK_CACHE);
 	if (ret) {
diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index b66d4ae..a5438d8 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -38,7 +38,7 @@ static struct irq_domain *sun4i_irq_domain;
 
 static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs);
 
-void sun4i_irq_ack(struct irq_data *irqd)
+static void sun4i_irq_ack(struct irq_data *irqd)
 {
 	unsigned int irq = irqd_to_hwirq(irqd);
 	unsigned int irq_off = irq % 32;
diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
index d970595..1846e7d 100644
--- a/drivers/irqchip/irq-vt8500.c
+++ b/drivers/irqchip/irq-vt8500.c
@@ -178,7 +178,8 @@ static struct irq_domain_ops vt8500_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
 
-asmlinkage void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
+static asmlinkage
+void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 {
 	u32 stat, i;
 	int irqnr, virq;
@@ -203,7 +204,8 @@ asmlinkage void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 	}
 }
 
-int __init vt8500_irq_init(struct device_node *node, struct device_node *parent)
+static int __init vt8500_irq_init(struct device_node *node,
+				  struct device_node *parent)
 {
 	int irq, i;
 	struct device_node *np = node;
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 1c39ecc..2f274f3 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -278,7 +278,7 @@ int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 	if (d->revmap_type != IRQ_DOMAIN_MAP_LINEAR)
 		return -EINVAL;
 
-	numchips = d->revmap_data.linear.size / irqs_per_chip;
+	numchips = DIV_ROUND_UP(d->revmap_data.linear.size, irqs_per_chip);
 	if (!numchips)
 		return -EINVAL;
 
