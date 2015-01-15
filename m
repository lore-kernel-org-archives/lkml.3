Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbbAOIET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:04:19 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:50698 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbAOIEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:04:16 -0500
From: Stefan Agner <stefan@agner.ch>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com
Cc: u.kleine-koenig@pengutronix.de, shawn.guo@linaro.org,
        kernel@pengutronix.de, arnd@arndb.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH RESEND v3 1/3] irqchip: vf610-mscm: add support for MSCM interrupt router
Date: Thu, 15 Jan 2015 09:04:04 +0100
Message-Id: <1421309046-22452-2-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421309046-22452-1-git-send-email-stefan@agner.ch>
References: <1421309046-22452-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for Vybrid's interrupt router. On VF6xx models,
almost all peripherals can be accessed from either of the two
CPU's, from the Cortex-A5 or from the Cortex-M4. The interrupt
router routes the peripheral interrupts to the configured CPU.

The driver makes use of the irqdomain hierarchy support. The
parent is either the ARM GIC or the ARM NVIC interrupt controller
depending on which CPU the kernel is executed on. Currently only
ARM GIC is supported because the NVIC driver lacks hierarchical
irqdomain support as of now.

Currently, there is no resource control mechnism implemented to
avoid concurrent access of the same peripheral. The user needs
to make sure to use device trees which assign the peripherals
orthogonally. However, this driver warns the user in case the
interrupt is already configured for the other CPU. This provides
a poor man's resource controller.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/mach-imx/Kconfig        |   1 +
 drivers/irqchip/Kconfig          |  11 +++
 drivers/irqchip/Makefile         |   1 +
 drivers/irqchip/irq-vf610-mscm.c | 186 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 199 insertions(+)
 create mode 100644 drivers/irqchip/irq-vf610-mscm.c

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index e8627e0..3c5859e 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -631,6 +631,7 @@ config SOC_IMX6SX
 
 config SOC_VF610
 	bool "Vybrid Family VF610 support"
+	select VF610_MSCM
 	select ARM_GIC
 	select PINCTRL_VF610
 	select PL310_ERRATA_769419 if CACHE_L2X0
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index cc79d2a..af5e72a 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -136,6 +136,17 @@ config IRQ_CROSSBAR
 	  a free irq and configures the IP. Thus the peripheral interrupts are
 	  routed to one of the free irqchip interrupt lines.
 
+config VF610_MSCM
+	bool
+	help
+	  Support for MSCM interrupt router available on Vybrid SoC's. The
+	  interrupt router is between the CPU's interrupt controller and the
+	  peripheral. The router allows to route the peripheral interrupts to
+	  one of the two available CPU's on Vybrid VF6xx SoC's (Cortex-A5 or
+	  Cortex-M4). The router will be configured transparently on a IRQ
+	  request.
+	select IRQ_DOMAIN_HIERARCHY
+
 config KEYSTONE_IRQ
 	tristate "Keystone 2 IRQ controller IP"
 	depends on ARCH_KEYSTONE
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 9516a32..85651be 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
 obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
 obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
 obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
+obj-$(CONFIG_VF610_MSCM)		+= irq-vf610-mscm.o
 obj-$(CONFIG_BCM7120_L2_IRQ)		+= irq-bcm7120-l2.o
 obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
 obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
diff --git a/drivers/irqchip/irq-vf610-mscm.c b/drivers/irqchip/irq-vf610-mscm.c
new file mode 100644
index 0000000..7a284d5
--- /dev/null
+++ b/drivers/irqchip/irq-vf610-mscm.c
@@ -0,0 +1,186 @@
+/*
+ * Copyright 2014 Stefan Agner
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/cpu_pm.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+
+#include "irqchip.h"
+
+#define MSCM_CPxNUM		0x4
+#define MSCM_IRSPRC(n)		(0x880 + 2 * (n))
+#define MSCM_IRSPRC_CPEN_MASK	0x3
+
+#define MSCM_IRSPRC_NUM		112
+
+struct vf610_mscm_chip_data {
+	void __iomem *mscm_base;
+	u16 cpu_mask;
+	u16 saved_irsprc[MSCM_IRSPRC_NUM];
+};
+
+static struct vf610_mscm_chip_data *mscm_data;
+
+static inline void vf610_mscm_save(struct vf610_mscm_chip_data *data)
+{
+	int i;
+
+	for (i = 0; i < MSCM_IRSPRC_NUM; i++)
+		data->saved_irsprc[i] = readw_relaxed(data->mscm_base + MSCM_IRSPRC(i));
+}
+
+static inline void vf610_mscm_restore(struct vf610_mscm_chip_data *data)
+{
+	int i;
+
+	for (i = 0; i < MSCM_IRSPRC_NUM; i++)
+		writew_relaxed(data->saved_irsprc[i], data->mscm_base + MSCM_IRSPRC(i));
+}
+
+static int vf610_mscm_notifier(struct notifier_block *self, unsigned long cmd,
+			       void *v)
+{
+	switch (cmd) {
+	case CPU_CLUSTER_PM_ENTER:
+		vf610_mscm_save(mscm_data);
+		break;
+	case CPU_CLUSTER_PM_ENTER_FAILED:
+	case CPU_CLUSTER_PM_EXIT:
+		vf610_mscm_restore(mscm_data);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block mscm_notifier_block = {
+	.notifier_call = vf610_mscm_notifier,
+};
+
+static void vf610_mscm_enable(struct irq_data *data)
+{
+	irq_hw_number_t hwirq = data->hwirq;
+	struct vf610_mscm_chip_data *chip_data = data->chip_data;
+	u16 irsprc;
+
+	irsprc = readw_relaxed(chip_data->mscm_base + MSCM_IRSPRC(hwirq));
+	irsprc &= MSCM_IRSPRC_CPEN_MASK;
+
+	WARN_ON(irsprc);
+
+	writew_relaxed(chip_data->cpu_mask,
+		       chip_data->mscm_base + MSCM_IRSPRC(hwirq));
+
+	irq_chip_unmask_parent(data);
+}
+
+static void vf610_mscm_disable(struct irq_data *data)
+{
+	irq_hw_number_t hwirq = data->hwirq;
+	struct vf610_mscm_chip_data *chip_data = data->chip_data;
+
+	writew_relaxed(0x0, chip_data->mscm_base + MSCM_IRSPRC(hwirq));
+
+	irq_chip_mask_parent(data);
+}
+
+static struct irq_chip vf610_mscm_irq_chip = {
+	.name			= "MSCM",
+	.irq_mask		= irq_chip_mask_parent,
+	.irq_unmask		= irq_chip_unmask_parent,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_enable		= vf610_mscm_enable,
+	.irq_disable		= vf610_mscm_disable,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_set_affinity	= irq_chip_set_affinity_parent,
+};
+
+static int vf610_mscm_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				   unsigned int nr_irqs, void *arg)
+{
+	int i;
+	irq_hw_number_t hwirq;
+	struct of_phandle_args *irq_data = arg;
+	struct of_phandle_args gic_data;
+
+	if (irq_data->args_count != 2)
+		return -EINVAL;
+
+	hwirq = irq_data->args[0];
+	for (i = 0; i < nr_irqs; i++)
+		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
+					      &vf610_mscm_irq_chip,
+					      domain->host_data);
+
+	gic_data.np = domain->parent->of_node;
+	gic_data.args_count = 3;
+	gic_data.args[0] = GIC_SPI;
+	gic_data.args[1] = irq_data->args[0];
+	gic_data.args[2] = irq_data->args[1];
+	return irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, &gic_data);
+}
+
+static const struct irq_domain_ops mscm_irq_domain_ops = {
+	.xlate = irq_domain_xlate_twocell,
+	.alloc = vf610_mscm_domain_alloc,
+	.free = irq_domain_free_irqs_common,
+};
+
+static int __init vf610_mscm_of_init(struct device_node *node,
+			       struct device_node *parent)
+{
+	struct irq_domain *domain, *domain_parent;
+	int ret;
+
+	domain_parent = irq_find_host(parent);
+	if (!domain_parent) {
+		pr_err("vf610_mscm: interrupt-parent not found\n");
+		return -EINVAL;
+	}
+
+	mscm_data = kzalloc(sizeof(*mscm_data), GFP_KERNEL);
+	if (!mscm_data)
+		return -ENOMEM;
+
+	mscm_data->mscm_base = of_io_request_and_map(node, 0, "mscm");
+
+	if (!mscm_data->mscm_base) {
+		pr_err("vf610_mscm: unable to map mscm register\n");
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	domain = irq_domain_add_hierarchy(domain_parent, 0,
+					  MSCM_IRSPRC_NUM, node,
+					  &mscm_irq_domain_ops, mscm_data);
+	if (!domain) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	mscm_data->cpu_mask = 0x1 << readl_relaxed(mscm_data->mscm_base + MSCM_CPxNUM);
+
+	cpu_pm_register_notifier(&mscm_notifier_block);
+
+	return 0;
+
+out_unmap:
+	iounmap(mscm_data->mscm_base);
+out_free:
+	kfree(mscm_data);
+	return ret;
+}
+IRQCHIP_DECLARE(vf610_mscm, "fsl,vf610-mscm", vf610_mscm_of_init);
-- 
2.2.1

