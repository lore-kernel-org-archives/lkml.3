Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834AbaKMLlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:41:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:60839 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639AbaKMLlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:41:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,376,1413270000"; 
   d="scan'208";a="607188390"
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
Subject: [Patch V1 5/6] PCI, MSI: Refine irqdomain interfaces to simplify its usage
Date: Thu, 13 Nov 2014 19:43:48 +0800
Message-Id: <1415879029-20098-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine irqdomain interfaces to simplify its usage.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/pci/msi.c   |  108 +++++++++++++++++++++++++++++++++++++--------------
 include/linux/msi.h |   11 ++++--
 2 files changed, 86 insertions(+), 33 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 9c53b865cb1b..0319c21dd208 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1099,38 +1099,88 @@ irq_hw_number_t pci_msi_domain_calc_hwirq(struct pci_dev *dev,
 		(pci_domain_nr(dev->bus) & 0xFFFFFFFF) << 27;
 }
 
-int pci_msi_domain_alloc_irqs(struct irq_domain *domain, int type,
-			      struct pci_dev *dev, void *arg)
+static inline bool pci_msi_desc_is_multi_msi(struct msi_desc *desc)
 {
-	struct msi_domain_info *info = domain->host_data;
-	int node = dev_to_node(&dev->dev);
-	struct msi_desc *desc;
-	int i, virq;
-
-	list_for_each_entry(desc, &dev->msi_list, list) {
-		if (info->ops->calc_hwirq)
-			info->ops->calc_hwirq(info, arg, desc);
-
-		virq = irq_domain_alloc_irqs(domain, desc->nvec_used,
-					     node, arg);
-		if (virq < 0) {
-			/* Special handling for pci_enable_msi_range(). */
-			if (type == PCI_CAP_ID_MSI && desc->nvec_used > 1)
-				return 1;
-			else
-				return -ENOSPC;
-		}
-		for (i = 0; i < desc->nvec_used; i++)
-			irq_set_msi_desc_off(virq, i, desc);
-	}
+	return !desc->msi_attrib.is_msix && desc->nvec_used > 1;
+}
+
+int pci_msi_domain_check_cap(struct irq_domain *domain,
+			     struct msi_domain_info *info, struct device *dev)
+{
+	struct msi_desc *desc = first_pci_msi_entry(to_pci_dev(dev));
 
-	list_for_each_entry(desc, &dev->msi_list, list)
-		if (desc->nvec_used == 1)
-			dev_dbg(&dev->dev, "irq %d for MSI/MSI-X\n", virq);
-		else
-			dev_dbg(&dev->dev, "irq [%d-%d] for MSI/MSI-X\n",
-				virq, virq + desc->nvec_used - 1);
+	/* Special handling to support pci_enable_msi_range() */
+	if (pci_msi_desc_is_multi_msi(desc) &&
+	    !(info->flags & MSI_FLAG_MULTI_PCI_MSI))
+		return 1;
+	else if (desc->msi_attrib.is_msix && !(info->flags & MSI_FLAG_PCI_MSIX))
+		return -ENOTSUPP;
 
 	return 0;
 }
+
+static int pci_msi_domain_handle_error(struct irq_domain *domain,
+				       struct msi_desc *desc, int error)
+{
+	/* Special handling to support pci_enable_msi_range() */
+	if (pci_msi_desc_is_multi_msi(desc) && error == -ENOSPC)
+		return 1;
+
+	return error;
+}
+
+#ifndef msi_alloc_info_t
+static void pci_msi_domain_set_desc(struct msi_alloc_info *arg,
+				    struct msi_desc *desc)
+{
+	arg->desc = desc;
+	arg->hwirq = pci_msi_domain_calc_hwirq(msi_desc_to_pci_dev(desc),
+					       desc);
+}
+#else
+#define pci_msi_domain_set_desc		NULL
+#endif
+
+static struct msi_domain_ops pci_msi_domain_ops_default = {
+	.set_desc	= pci_msi_domain_set_desc,
+	.msi_check	= pci_msi_domain_check_cap,
+	.handle_error	= pci_msi_domain_handle_error,
+};
+
+static void pci_msi_domain_update_ops(struct msi_domain_info *info)
+{
+	struct msi_domain_ops *ops = info->ops;
+
+	if (ops == NULL) {
+		info->ops = &pci_msi_domain_ops_default;
+	} else {
+		if (ops->set_desc == NULL)
+			ops->set_desc = pci_msi_domain_set_desc;
+		if (ops->msi_check == NULL)
+			ops->msi_check = pci_msi_domain_check_cap;
+		if (ops->handle_error == NULL)
+			ops->handle_error = pci_msi_domain_handle_error;
+	}
+}
+
+struct irq_domain *pci_msi_create_irq_domain(struct device_node *node,
+					     struct msi_domain_info *info,
+					     struct irq_domain *parent)
+{
+	if (info->flags & MSI_FLAG_USE_DEF_OPS)
+		pci_msi_domain_update_ops(info);
+
+	return msi_create_irq_domain(node, info, parent);
+}
+
+int pci_msi_domain_alloc_irqs(struct irq_domain *domain, int type,
+			      struct pci_dev *dev)
+{
+	return msi_domain_alloc_irqs(domain, &dev->dev);
+}
+
+void pci_msi_domain_free_irqs(struct irq_domain *domain, struct pci_dev *dev)
+{
+	msi_domain_free_irqs(domain, &dev->dev);
+}
 #endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
diff --git a/include/linux/msi.h b/include/linux/msi.h
index c62a1ca71241..9031791e9b4c 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -121,9 +121,6 @@ typedef struct msi_alloc_info msi_alloc_info_t;
 
 struct msi_domain_ops {
 	/* Callbacks for msi_create_irq_domain() */
-	void		(*calc_hwirq)(struct msi_domain_info *info,
-				      msi_alloc_info_t *arg,
-				      struct msi_desc *desc);
 	irq_hw_number_t	(*get_hwirq)(struct msi_domain_info *info,
 				     msi_alloc_info_t *arg);
 	int		(*msi_init)(struct irq_domain *domain,
@@ -182,10 +179,16 @@ struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain);
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
 void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg);
+struct irq_domain *pci_msi_create_irq_domain(struct device_node *node,
+					     struct msi_domain_info *info,
+					     struct irq_domain *parent);
 int pci_msi_domain_alloc_irqs(struct irq_domain *domain, int type,
-			      struct pci_dev *dev, void *arg);
+			      struct pci_dev *dev);
+void pci_msi_domain_free_irqs(struct irq_domain *domain, struct pci_dev *dev);
 irq_hw_number_t pci_msi_domain_calc_hwirq(struct pci_dev *dev,
 					  struct msi_desc *desc);
+int pci_msi_domain_check_cap(struct irq_domain *domain,
+			     struct msi_domain_info *info, struct device *dev);
 #endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
 
 #endif /* LINUX_MSI_H */
-- 
1.7.10.4

