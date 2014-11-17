Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaKQLA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:00:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:38760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaKQLAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:00:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487989133"
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
Subject: [Patch V3 8/9] PCI, MSI: Refine irqdomain interfaces to simplify its usage
Date: Mon, 17 Nov 2014 19:03:21 +0800
Message-Id: <1416222202-28002-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine irqdomain interfaces to simplify its usage.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/pci/msi.c   |  121 +++++++++++++++++++++++++++++++++++++++------------
 include/linux/msi.h |   13 +++---
 2 files changed, 100 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 9c53b865cb1b..62f504887c1d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1099,38 +1099,101 @@ irq_hw_number_t pci_msi_domain_calc_hwirq(struct pci_dev *dev,
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
+
+	/* Special handling to support pci_enable_msi_range() */
+	if (pci_msi_desc_is_multi_msi(desc) &&
+	    !(info->flags & MSI_FLAG_MULTI_PCI_MSI))
+		return 1;
+	else if (desc->msi_attrib.is_msix && !(info->flags & MSI_FLAG_PCI_MSIX))
+		return -ENOTSUPP;
 
-	list_for_each_entry(desc, &dev->msi_list, list)
-		if (desc->nvec_used == 1)
-			dev_dbg(&dev->dev, "irq %d for MSI/MSI-X\n", virq);
-		else
-			dev_dbg(&dev->dev, "irq [%d-%d] for MSI/MSI-X\n",
-				virq, virq + desc->nvec_used - 1);
+	return 0;
+}
+
+static int pci_msi_domain_handle_error(msi_alloc_info_t *arg,
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
+static int pci_msi_domain_set_desc(struct msi_alloc_info *arg,
+				   struct msi_desc *desc)
+{
+	arg->desc = desc;
+	arg->hwirq = pci_msi_domain_calc_hwirq(msi_desc_to_pci_dev(desc),
+					       desc);
 
 	return 0;
 }
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
+static void pci_msi_domain_update_dom_ops(struct msi_domain_info *info)
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
+static void pci_msi_domain_update_chip_ops(struct msi_domain_info *info)
+{
+	struct irq_chip *chip = info->chip;
+
+	BUG_ON(!chip);
+	if (!chip->irq_write_msi_msg)
+		chip->irq_write_msi_msg = pci_msi_domain_write_msg;
+}
+
+struct irq_domain *pci_msi_create_irq_domain(struct device_node *node,
+					     struct msi_domain_info *info,
+					     struct irq_domain *parent)
+{
+	if (info->flags & MSI_FLAG_USE_DEF_DOM_OPS)
+		pci_msi_domain_update_dom_ops(info);
+	if (info->flags & MSI_FLAG_USE_DEF_CHIP_OPS)
+		pci_msi_domain_update_chip_ops(info);
+
+	return msi_create_irq_domain(node, info, parent);
+}
+
+int pci_msi_domain_alloc_irqs(struct irq_domain *domain, struct pci_dev *dev,
+			      int nvec, int type)
+{
+	return msi_domain_alloc_irqs(domain, &dev->dev, nvec);
+}
+
+void pci_msi_domain_free_irqs(struct irq_domain *domain, struct pci_dev *dev)
+{
+	msi_domain_free_irqs(domain, &dev->dev);
+}
 #endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 3571b4715c75..eadd47c309a7 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -125,9 +125,6 @@ typedef struct msi_alloc_info msi_alloc_info_t;
 
 struct msi_domain_ops {
 	/* Callbacks for msi_create_irq_domain() */
-	void		(*calc_hwirq)(struct msi_domain_info *info,
-				      msi_alloc_info_t *arg,
-				      struct msi_desc *desc);
 	irq_hw_number_t	(*get_hwirq)(struct msi_domain_info *info,
 				     msi_alloc_info_t *arg);
 	int		(*msi_init)(struct irq_domain *domain,
@@ -189,10 +186,16 @@ struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain);
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
 void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg);
-int pci_msi_domain_alloc_irqs(struct irq_domain *domain, int type,
-			      struct pci_dev *dev, void *arg);
+struct irq_domain *pci_msi_create_irq_domain(struct device_node *node,
+					     struct msi_domain_info *info,
+					     struct irq_domain *parent);
+int pci_msi_domain_alloc_irqs(struct irq_domain *domain, struct pci_dev *dev,
+			      int nvec, int type);
+void pci_msi_domain_free_irqs(struct irq_domain *domain, struct pci_dev *dev);
 irq_hw_number_t pci_msi_domain_calc_hwirq(struct pci_dev *dev,
 					  struct msi_desc *desc);
+int pci_msi_domain_check_cap(struct irq_domain *domain,
+			     struct msi_domain_info *info, struct device *dev);
 #endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
 
 #endif /* LINUX_MSI_H */
-- 
1.7.10.4

