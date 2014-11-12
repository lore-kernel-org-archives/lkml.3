Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaKLNnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:43:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:41671 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaKLNnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:43:06 -0500
Message-Id: <20141112134120.569789374@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:43:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [patch 09/16] genirq: Add generic msi irq domain support
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=genirq-add-generic-msi-irq-support.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

Implement the basic functions for MSI interrupt support with
hierarchical interrupt domains.

[ tglx: Extracted and combined from several patches ]

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/msi.h |   35 +++++++++++++++
 kernel/irq/Kconfig  |   10 ++++
 kernel/irq/Makefile |    1 
 kernel/irq/msi.c    |  119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 165 insertions(+)

Index: tip/include/linux/msi.h
===================================================================
--- tip.orig/include/linux/msi.h
+++ tip/include/linux/msi.h
@@ -77,4 +77,39 @@ struct msi_chip {
 	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
 };
 
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+struct irq_domain;
+struct irq_chip;
+struct device_node;
+struct msi_domain_info;
+
+struct msi_domain_ops {
+	void		(*calc_hwirq)(struct msi_domain_info *info, void *arg,
+				      struct msi_desc *desc);
+	irq_hw_number_t	(*get_hwirq)(struct msi_domain_info *info, void *arg);
+	int		(*msi_init)(struct irq_domain *domain,
+				    struct msi_domain_info *info,
+				    unsigned int virq, irq_hw_number_t hwirq,
+				    void *arg);
+	void		(*msi_free)(struct irq_domain *domain,
+				    struct msi_domain_info *info,
+				    unsigned int virq);
+};
+
+struct msi_domain_info {
+	struct msi_domain_ops	*ops;
+	struct irq_chip		*chip;
+	void			*data;
+};
+
+int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			    bool force);
+
+struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
+					 struct msi_domain_info *info,
+					 struct irq_domain *parent);
+struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain);
+
+#endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
+
 #endif /* LINUX_MSI_H */
Index: tip/kernel/irq/Kconfig
===================================================================
--- tip.orig/kernel/irq/Kconfig
+++ tip/kernel/irq/Kconfig
@@ -60,6 +60,16 @@ config IRQ_DOMAIN_HIERARCHY
 	bool
 	select IRQ_DOMAIN
 
+# Generic MSI interrupt support
+config GENERIC_MSI_IRQ
+	bool
+
+# Generic MSI hierarchical interrupt domain support
+config GENERIC_MSI_IRQ_DOMAIN
+	bool
+	select IRQ_DOMAIN_HIERARCHY
+	select GENERIC_MSI_IRQ
+
 config HANDLE_DOMAIN_IRQ
 	bool
 
Index: tip/kernel/irq/Makefile
===================================================================
--- tip.orig/kernel/irq/Makefile
+++ tip/kernel/irq/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_IRQ_DOMAIN) += irqdomain.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
+obj-$(CONFIG_GENERIC_MSI_IRQ) += msi.o
Index: tip/kernel/irq/msi.c
===================================================================
--- /dev/null
+++ tip/kernel/irq/msi.c
@@ -0,0 +1,119 @@
+/*
+ * linux/kernel/irq/msi.c
+ *
+ * Copyright (C) 2014 Intel Corp.
+ * Author: Jiang Liu <jiang.liu@linux.intel.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This file contains common code to support Message Signalled Interrupt for
+ * PCI compatible and non PCI compatible devices.
+ */
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/msi.h>
+
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+int msi_domain_set_affinity(struct irq_data *irq_data,
+			    const struct cpumask *mask, bool force)
+{
+	struct irq_data *parent = irq_data->parent_data;
+	struct msi_msg msg;
+	int ret;
+
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
+		BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+		irq_chip_write_msi_msg(irq_data, &msg);
+	}
+
+	return ret;
+}
+
+static void msi_domain_activate(struct irq_domain *domain,
+				struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+
+	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+	irq_chip_write_msi_msg(irq_data, &msg);
+}
+
+static void msi_domain_deactivate(struct irq_domain *domain,
+				  struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+
+	memset(&msg, 0, sizeof(msg));
+	irq_chip_write_msi_msg(irq_data, &msg);
+}
+
+static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs, void *arg)
+{
+	struct msi_domain_info *info = domain->host_data;
+	struct msi_domain_ops *ops = info->ops;
+	irq_hw_number_t hwirq = ops->get_hwirq(info, arg);
+	int i, ret;
+
+	if (irq_find_mapping(domain, hwirq) > 0)
+		return -EEXIST;
+
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < nr_irqs; i++) {
+		ret = ops->msi_init(domain, info, virq + i, hwirq + i, arg);
+		if (ret < 0) {
+			if (ops->msi_free) {
+				for (i--; i > 0; i--)
+					ops->msi_free(domain, info, virq + i);
+			}
+			irq_domain_free_irqs_top(domain, virq, nr_irqs);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void msi_domain_free(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs)
+{
+	struct msi_domain_info *info = domain->host_data;
+	int i;
+
+	if (info->ops->msi_free) {
+		for (i = 0; i < nr_irqs; i++)
+			info->ops->msi_free(domain, info, virq + i);
+	}
+	irq_domain_free_irqs_top(domain, virq, nr_irqs);
+}
+
+static struct irq_domain_ops msi_domain_ops = {
+	.alloc		= msi_domain_alloc,
+	.free		= msi_domain_free,
+	.activate	= msi_domain_activate,
+	.deactivate	= msi_domain_deactivate,
+};
+
+struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
+					 struct msi_domain_info *info,
+					 struct irq_domain *parent)
+{
+	struct irq_domain *domain;
+
+	domain = irq_domain_add_tree(of_node, &msi_domain_ops, info);
+	if (domain)
+		domain->parent = parent;
+
+	return domain;
+}
+
+struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain)
+{
+	return (struct msi_domain_info *)domain->host_data;
+}
+
+#endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */


