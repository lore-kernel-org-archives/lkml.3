Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaKXUVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:21:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49078 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaKXUVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:21:43 -0500
Date: Sun, 23 Nov 2014 10:14:13 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-8e047adae969701c6cec136484bb9de8572af934@git.kernel.org>
Cc: marc.zyngier@arm.com, bp@alien8.de, tglx@linutronix.de,
        wangyijing@huawei.com, hpa@zytor.com, agordeev@redhat.com,
        tony.luck@intel.com, bhelgaas@google.com, mingo@kernel.org,
        yingjoe.chen@mediatek.com, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, jiang.liu@linux.intel.com,
        matthias.bgg@gmail.com
Reply-To: jiang.liu@linux.intel.com, matthias.bgg@gmail.com,
        grant.likely@linaro.org, linux-kernel@vger.kernel.org,
        yingjoe.chen@mediatek.com, mingo@kernel.org, tony.luck@intel.com,
        bhelgaas@google.com, agordeev@redhat.com, wangyijing@huawei.com,
        tglx@linutronix.de, hpa@zytor.com, marc.zyngier@arm.com, bp@alien8.de
In-Reply-To: <1416061447-9472-10-git-send-email-jiang.liu@linux.intel.com>
References: <1416061447-9472-10-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/irqdomain] PCI/MSI: Provide mechanism to alloc/free MSI/
 MSIX interrupt from irqdomain
Git-Commit-ID: 8e047adae969701c6cec136484bb9de8572af934
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e047adae969701c6cec136484bb9de8572af934
Gitweb:     http://git.kernel.org/tip/8e047adae969701c6cec136484bb9de8572af934
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Sat, 15 Nov 2014 22:24:07 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 23 Nov 2014 13:01:47 +0100

PCI/MSI: Provide mechanism to alloc/free MSI/MSIX interrupt from irqdomain

Provide mechanism to directly alloc/free MSI/MSIX interrupt from
irqdomain, which will be used to replace arch_setup_msi_irq()/
arch_setup_msi_irqs()/arch_teardown_msi_irq()/arch_teardown_msi_irqs().

To kill weak functions, this patch introduce a new weak function
arch_get_pci_msi_domain(), which is to retrieve the MSI irqdomain
for a PCI device. This weak function could be killed once we get
a common way to associate MSI domain with PCI device.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/1416061447-9472-10-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/pci/msi.c   | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/msi.h |  3 +++
 2 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 36b0c2e..4befe09 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -28,6 +28,40 @@ int pci_msi_ignore_mask;
 
 #define msix_table_size(flags)	((flags & PCI_MSIX_FLAGS_QSIZE) + 1)
 
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+static struct irq_domain *pci_msi_default_domain;
+static DEFINE_MUTEX(pci_msi_domain_lock);
+
+struct irq_domain * __weak arch_get_pci_msi_domain(struct pci_dev *dev)
+{
+	return pci_msi_default_domain;
+}
+
+static int pci_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	struct irq_domain *domain;
+
+	domain = arch_get_pci_msi_domain(dev);
+	if (domain)
+		return pci_msi_domain_alloc_irqs(domain, dev, nvec, type);
+
+	return arch_setup_msi_irqs(dev, nvec, type);
+}
+
+static void pci_msi_teardown_msi_irqs(struct pci_dev *dev)
+{
+	struct irq_domain *domain;
+
+	domain = arch_get_pci_msi_domain(dev);
+	if (domain)
+		pci_msi_domain_free_irqs(domain, dev);
+	else
+		arch_teardown_msi_irqs(dev);
+}
+#else
+#define pci_msi_setup_msi_irqs		arch_setup_msi_irqs
+#define pci_msi_teardown_msi_irqs	arch_teardown_msi_irqs
+#endif
 
 /* Arch hooks */
 
@@ -348,7 +382,7 @@ static void free_msi_irqs(struct pci_dev *dev)
 			for (i = 0; i < entry->nvec_used; i++)
 				BUG_ON(irq_has_action(entry->irq + i));
 
-	arch_teardown_msi_irqs(dev);
+	pci_msi_teardown_msi_irqs(dev);
 
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
 		if (entry->msi_attrib.is_msix) {
@@ -600,7 +634,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
+	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
 	if (ret) {
 		msi_mask_irq(entry, mask, ~mask);
 		free_msi_irqs(dev);
@@ -715,7 +749,7 @@ static int msix_capability_init(struct pci_dev *dev,
 	if (ret)
 		return ret;
 
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
+	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
 		goto out_avail;
 
@@ -1258,4 +1292,31 @@ void pci_msi_domain_free_irqs(struct irq_domain *domain, struct pci_dev *dev)
 {
 	msi_domain_free_irqs(domain, &dev->dev);
 }
+
+/**
+ * pci_msi_create_default_irq_domain - Create a default MSI interrupt domain
+ * @node:	Optional device-tree node of the interrupt controller
+ * @info:	MSI domain info
+ * @parent:	Parent irq domain
+ *
+ * Returns: A domain pointer or NULL in case of failure. If successful
+ * the default PCI/MSI irqdomain pointer is updated.
+ */
+struct irq_domain *pci_msi_create_default_irq_domain(struct device_node *node,
+		struct msi_domain_info *info, struct irq_domain *parent)
+{
+	struct irq_domain *domain;
+
+	mutex_lock(&pci_msi_domain_lock);
+	if (pci_msi_default_domain) {
+		pr_err("PCI: default irq domain for PCI MSI has already been created.\n");
+		domain = NULL;
+	} else {
+		domain = pci_msi_create_irq_domain(node, info, parent);
+		pci_msi_default_domain = domain;
+	}
+	mutex_unlock(&pci_msi_domain_lock);
+
+	return domain;
+}
 #endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 1628788..692f217 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -228,6 +228,9 @@ struct irq_domain *pci_msi_create_irq_domain(struct device_node *node,
 int pci_msi_domain_alloc_irqs(struct irq_domain *domain, struct pci_dev *dev,
 			      int nvec, int type);
 void pci_msi_domain_free_irqs(struct irq_domain *domain, struct pci_dev *dev);
+struct irq_domain *pci_msi_create_default_irq_domain(struct device_node *node,
+		 struct msi_domain_info *info, struct irq_domain *parent);
+
 irq_hw_number_t pci_msi_domain_calc_hwirq(struct pci_dev *dev,
 					  struct msi_desc *desc);
 int pci_msi_domain_check_cap(struct irq_domain *domain,
