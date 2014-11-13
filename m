Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbaKMLlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:41:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:56473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639AbaKMLlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:41:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,376,1413270000"; 
   d="scan'208";a="607188341"
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
Subject: [Patch V1 4/6] genirq: Provide default callbacks for msi_domain_ops
Date: Thu, 13 Nov 2014 19:43:47 +0800
Message-Id: <1415879029-20098-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend struct msi_domain_info and provide default callbacks for
msi_domain_ops.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/msi.h |   26 +++++++++++---
 kernel/irq/msi.c    |   93 +++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 111 insertions(+), 8 deletions(-)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 6b356a1410b2..c62a1ca71241 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -121,13 +121,15 @@ typedef struct msi_alloc_info msi_alloc_info_t;
 
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
@@ -147,15 +149,29 @@ struct msi_domain_ops {
 };
 
 struct msi_domain_info {
+	u32			flags;
 	struct msi_domain_ops	*ops;
 	struct irq_chip		*chip;
-	void			*data;
+	void			*chip_data;	/* optional chip data */
+	void			*handler;	/* optional flow handler */
+	void			*handler_data;	/* optional handler data */
+	const char		*handler_name;	/* optional handler name */
+	void			*data;		/* optional private data */
 };
 
+/* Use default MSI domain ops if possible */
+#define MSI_FLAG_USE_DEF_OPS		0x1
+/* Build identity map between hwirq and irq */
+#define MSI_FLAG_IDENTITY_MAP		0x2
+/* Support multiple PCI MSI interrupts */
+#define MSI_FLAG_MULTI_PCI_MSI		0x4
+/* Support PCI MSIX interrupts */
+#define MSI_FLAG_PCI_MSIX		0x8
+
 int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			    bool force);
 
-struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
+struct irq_domain *msi_create_irq_domain(struct device_node *node,
 					 struct msi_domain_info *info,
 					 struct irq_domain *parent);
 int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev);
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 0b6665de3a60..5512aa155a50 100644
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
@@ -114,13 +116,94 @@ static struct irq_domain_ops msi_domain_ops = {
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
+				  struct msi_alloc_info *arg)
+{
+	memset(arg, 0, sizeof(*arg));
+
+	return 0;
+}
+
+static void msi_domain_ops_set_desc(struct msi_alloc_info *arg,
+				    struct msi_desc *desc)
+{
+	arg->desc = desc;
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
+static void msi_domain_update_ops(struct msi_domain_info *info)
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
+struct irq_domain *msi_create_irq_domain(struct device_node *node,
 					 struct msi_domain_info *info,
 					 struct irq_domain *parent)
 {
 	struct irq_domain *domain;
 
-	domain = irq_domain_add_tree(of_node, &msi_domain_ops, info);
+	if (info->flags & MSI_FLAG_USE_DEF_OPS)
+		msi_domain_update_ops(info);
+
+	domain = irq_domain_add_tree(node, &msi_domain_ops, info);
 	if (domain)
 		domain->parent = parent;
 
@@ -143,8 +226,12 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev)
 
 	for_each_msi_entry(desc, dev) {
 		ops->set_desc(&arg, desc);
+		if (info->flags & MSI_FLAG_IDENTITY_MAP)
+			virq = (int)ops->get_hwirq(info, &arg);
+		else
+			virq = -1;
 
-		virq = __irq_domain_alloc_irqs(domain, -1, desc->nvec_used,
+		virq = __irq_domain_alloc_irqs(domain, virq, desc->nvec_used,
 					       dev_to_node(dev), &arg, false);
 		if (virq < 0) {
 			ret = -ENOSPC;
-- 
1.7.10.4

