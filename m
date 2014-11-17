Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaKQLAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:00:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:36887 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaKQLAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:00:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487989094"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Alexander Gordeev <agordeev@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [Patch V3 7/9] genirq: Provide default callbacks for msi_domain_ops
Date: Mon, 17 Nov 2014 19:03:20 +0800
Message-Id: <1416222202-28002-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend struct msi_domain_info and provide default callbacks for
msi_domain_ops.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/msi.h |   29 ++++++++++---
 kernel/irq/msi.c    |  116 +++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 132 insertions(+), 13 deletions(-)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 243c4eb485a6..3571b4715c75 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -3,6 +3,7 @@
 
 #include <linux/kobject.h>
 #include <linux/list.h>
+#include <linux/irqhandler.h>
 #include <asm/hw_irq.h>		/* for msi_alloc_info_t */
 
 struct msi_msg {
@@ -124,13 +125,15 @@ typedef struct msi_alloc_info msi_alloc_info_t;
 
 struct msi_domain_ops {
 	/* Callbacks for msi_create_irq_domain() */
-	void		(*calc_hwirq)(struct msi_domain_info *info, void *arg,
+	void		(*calc_hwirq)(struct msi_domain_info *info,
+				      msi_alloc_info_t *arg,
 				      struct msi_desc *desc);
-	irq_hw_number_t	(*get_hwirq)(struct msi_domain_info *info, void *arg);
+	irq_hw_number_t	(*get_hwirq)(struct msi_domain_info *info,
+				     msi_alloc_info_t *arg);
 	int		(*msi_init)(struct irq_domain *domain,
 				    struct msi_domain_info *info,
 				    unsigned int virq, irq_hw_number_t hwirq,
-				    void *arg);
+				    msi_alloc_info_t *arg);
 	void		(*msi_free)(struct irq_domain *domain,
 				    struct msi_domain_info *info,
 				    unsigned int virq);
@@ -150,15 +153,31 @@ struct msi_domain_ops {
 };
 
 struct msi_domain_info {
+	u32			flags;
 	struct msi_domain_ops	*ops;
 	struct irq_chip		*chip;
-	void			*data;
+	void			*chip_data;	/* optional chip data */
+	irq_flow_handler_t	handler;	/* optional flow handler */
+	void			*handler_data;	/* optional handler data */
+	const char		*handler_name;	/* optional handler name */
+	void			*data;		/* optional private data */
 };
 
+/* Use default MSI domain ops if possible */
+#define MSI_FLAG_USE_DEF_DOM_OPS	0x1
+/* Use default MSI chip ops if possible */
+#define MSI_FLAG_USE_DEF_CHIP_OPS	0x2
+/* Build identity map between hwirq and irq */
+#define MSI_FLAG_IDENTITY_MAP		0x10
+/* Support multiple PCI MSI interrupts */
+#define MSI_FLAG_MULTI_PCI_MSI		0x100
+/* Support PCI MSIX interrupts */
+#define MSI_FLAG_PCI_MSIX		0x200
+
 int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			    bool force);
 
-struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
+struct irq_domain *msi_create_irq_domain(struct device_node *node,
 					 struct msi_domain_info *info,
 					 struct irq_domain *parent);
 int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 586cd8b3a174..1aa06b3281d6 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -9,6 +9,8 @@
  * This file contains common code to support Message Signalled Interrupt for
  * PCI compatible and non PCI compatible devices.
  */
+#include <linux/types.h>
+#include <linux/device.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/msi.h>
@@ -114,17 +116,110 @@ static struct irq_domain_ops msi_domain_ops = {
 	.deactivate	= msi_domain_deactivate,
 };
 
-struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
+#ifndef msi_alloc_info_t
+static irq_hw_number_t msi_domain_ops_get_hwirq(struct msi_domain_info *info,
+						struct msi_alloc_info *arg)
+{
+	return arg->hwirq;
+}
+
+static int msi_domain_ops_prepare(struct irq_domain *domain, struct device *dev,
+				  int nvec, struct msi_alloc_info *arg)
+{
+	memset(arg, 0, sizeof(*arg));
+
+	return 0;
+}
+
+static int msi_domain_ops_set_desc(struct msi_alloc_info *arg,
+				   struct msi_desc *desc)
+{
+	arg->desc = desc;
+
+	return 0;
+}
+#else
+#define msi_domain_ops_get_hwirq	NULL
+#define msi_domain_ops_prepare		NULL
+#define msi_domain_ops_set_desc		NULL
+#endif /* msi_alloc_info_t */
+
+static int msi_domain_ops_init(struct irq_domain *domain,
+			       struct msi_domain_info *info,
+			       unsigned int virq, irq_hw_number_t hwirq,
+			       msi_alloc_info_t *arg)
+{
+	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, info->chip,
+				      info->chip_data);
+	if (info->handler && info->handler_name) {
+		__irq_set_handler(virq, info->handler, 0, info->handler_name);
+		if (info->handler_data)
+			irq_set_handler_data(virq, info->handler_data);
+	}
+
+	return 0;
+}
+
+static int msi_domain_ops_check(struct irq_domain *domain,
+				struct msi_domain_info *info,
+				struct device *dev)
+{
+	return 0;
+}
+
+static struct msi_domain_ops msi_domain_ops_default = {
+	.get_hwirq	= msi_domain_ops_get_hwirq,
+	.msi_init	= msi_domain_ops_init,
+	.msi_check	= msi_domain_ops_check,
+	.msi_prepare	= msi_domain_ops_prepare,
+	.set_desc	= msi_domain_ops_set_desc,
+};
+
+static void msi_domain_update_dom_ops(struct msi_domain_info *info)
+{
+	struct msi_domain_ops *ops = info->ops;
+
+	if (ops == NULL) {
+		info->ops = &msi_domain_ops_default;
+		return;
+	}
+
+	if (ops->get_hwirq == NULL)
+		ops->get_hwirq = msi_domain_ops_default.get_hwirq;
+	if (ops->msi_init == NULL)
+		ops->msi_init = msi_domain_ops_default.msi_init;
+	if (ops->msi_check == NULL)
+		ops->msi_check = msi_domain_ops_default.msi_check;
+	if (ops->msi_prepare == NULL)
+		ops->msi_prepare = msi_domain_ops_default.msi_prepare;
+	if (ops->set_desc == NULL)
+		ops->set_desc = msi_domain_ops_default.set_desc;
+}
+
+static void msi_domain_update_chip_ops(struct msi_domain_info *info)
+{
+	struct irq_chip *chip = info->chip;
+
+	BUG_ON(!chip);
+	if (!chip->irq_mask)
+		chip->irq_mask = mask_msi_irq;
+	if (!chip->irq_unmask)
+		chip->irq_unmask = unmask_msi_irq;
+	if (!chip->irq_set_affinity)
+		chip->irq_set_affinity = msi_domain_set_affinity;
+}
+
+struct irq_domain *msi_create_irq_domain(struct device_node *node,
 					 struct msi_domain_info *info,
 					 struct irq_domain *parent)
 {
-	struct irq_domain *domain;
-
-	domain = irq_domain_add_tree(of_node, &msi_domain_ops, info);
-	if (domain)
-		domain->parent = parent;
+	if (info->flags & MSI_FLAG_USE_DEF_DOM_OPS)
+		msi_domain_update_dom_ops(info);
+	if (info->flags & MSI_FLAG_USE_DEF_CHIP_OPS)
+		msi_domain_update_chip_ops(info);
 
-	return domain;
+	return irq_domain_add_hierarchy(parent, 0, 0, node, &msi_domain_ops,
+					info);
 }
 
 int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
@@ -147,7 +242,12 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 		if (ret)
 			goto handle_error;
 
-		virq = __irq_domain_alloc_irqs(domain, -1, desc->nvec_used,
+		if (info->flags & MSI_FLAG_IDENTITY_MAP)
+			virq = (int)ops->get_hwirq(info, &arg);
+		else
+			virq = -1;
+
+		virq = __irq_domain_alloc_irqs(domain, virq, desc->nvec_used,
 					       dev_to_node(dev), &arg, false);
 		if (virq >= 0) {
 			for (i = 0; i < desc->nvec_used; i++)
-- 
1.7.10.4

