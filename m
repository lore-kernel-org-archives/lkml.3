Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbaKMPiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:38:09 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:39346 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754124AbaKMPiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:38:05 -0500
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yijing Wang <wangyijing@huawei.com>, <srv_heupstream@mediatek.com>,
        <yingjoe.chen@gmail.com>, <hc.yen@mediatek.com>,
        <eddie.huang@mediatek.com>, <nathan.chung@mediatek.com>,
        <yh.chen@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH v6 4/6] ARM: mediatek: Add sysirq interrupt polarity support
Date: Thu, 13 Nov 2014 23:37:07 +0800
Message-ID: <1415893029-2971-5-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1415893029-2971-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1415893029-2971-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mediatek SoCs have interrupt polarity support in sysirq which
allows to invert polarity for given interrupt. Add this support
using hierarchy irq domain.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
---
 drivers/irqchip/Makefile         |   1 +
 drivers/irqchip/irq-mtk-sysirq.c | 156 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 157 insertions(+)
 create mode 100644 drivers/irqchip/irq-mtk-sysirq.c

diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 173bb5f..4e0f254 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -38,3 +38,4 @@ obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
 obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o \
 					   irq-bcm7120-l2.o
 obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
+obj-$(CONFIG_ARCH_MEDIATEK)		+= irq-mtk-sysirq.o
diff --git a/drivers/irqchip/irq-mtk-sysirq.c b/drivers/irqchip/irq-mtk-sysirq.c
new file mode 100644
index 0000000..976b7eb
--- /dev/null
+++ b/drivers/irqchip/irq-mtk-sysirq.c
@@ -0,0 +1,156 @@
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
+	} else
+		value &= ~(1 << offset);
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
+	if (intsize < 3)
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
+
+	if (irq_data->args_count < 3)
+		return -EINVAL;
+
+	hwirq = irq_data->args[1];
+	for (i = 0; i < nr_irqs; i++)
+		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
+					      &mtk_sysirq_chip,
+					      domain->host_data);
+
+	return irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
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
+	domain = irq_domain_add_linear(node, MT6577_SYS_INTPOL_NUM,
+				       &sysirq_domain_ops, chip_data);
+	if (!domain) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+	domain->parent = domain_parent;
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
-- 
1.8.1.1.dirty

