Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbaGZCoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:44:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:45739 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbaGZCnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:43:52 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "Marc Zyngier" <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>,
        <virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [RFC PATCH 09/11] PCI/MSI: refactor PCI MSI driver
Date: Sat, 26 Jul 2014 11:08:46 +0800
Message-ID: <1406344128-27055-10-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct msi_ops to hook PCI MSI operations,
and use struct msi_irqs to refactor PCI MSI drvier.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/msi.c   |  351 ++++++++++++++++++++++++++++++---------------------
 include/linux/msi.h |   14 +-
 include/linux/pci.h |   11 +-
 3 files changed, 222 insertions(+), 154 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 41c33da..f0c5989 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -29,8 +29,9 @@ static int pci_msi_enable = 1;
 
 /* Arch hooks */
 
-int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
+int __weak arch_setup_msi_irq(struct msi_irqs *msi, struct msi_desc *desc)
 {
+	struct pci_dev *dev = msi->data; //TO BE DONE: rework msi_chip to support Non-PCI
 	struct msi_chip *chip = dev->bus->msi;
 	int err;
 
@@ -56,8 +57,9 @@ void __weak arch_teardown_msi_irq(unsigned int irq)
 	chip->teardown_irq(chip, irq);
 }
 
-int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
+int __weak arch_msi_check_device(struct msi_irqs *msi, int nvec, int type)
 {
+	struct pci_dev *dev = msi->data; //TO BE DONE: rework msi_chip to support Non-PCI
 	struct msi_chip *chip = dev->bus->msi;
 
 	if (!chip || !chip->check_device)
@@ -66,7 +68,7 @@ int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 	return chip->check_device(chip, dev, nvec, type);
 }
 
-int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int __weak arch_setup_msi_irqs(struct msi_irqs *msi, int nvec, int type)
 {
 	struct msi_desc *entry;
 	int ret;
@@ -78,8 +80,8 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	if (type == MSI_TYPE && nvec > 1)
 		return 1;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		ret = arch_setup_msi_irq(dev, entry);
+	list_for_each_entry(entry, &msi->msi_list, list) {
+		ret = arch_setup_msi_irq(msi, entry);
 		if (ret < 0)
 			return ret;
 		if (ret > 0)
@@ -93,11 +95,11 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
  * We have a default implementation available as a separate non-weak
  * function, as it is used by the Xen x86 PCI code
  */
-void default_teardown_msi_irqs(struct pci_dev *dev)
+void default_teardown_msi_irqs(struct msi_irqs *msi)
 {
 	struct msi_desc *entry;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
+	list_for_each_entry(entry, &msi->msi_list, list) {
 		int i, nvec;
 		if (entry->irq == 0)
 			continue;
@@ -110,22 +112,22 @@ void default_teardown_msi_irqs(struct pci_dev *dev)
 	}
 }
 
-void __weak arch_teardown_msi_irqs(struct pci_dev *dev)
+void __weak arch_teardown_msi_irqs(struct msi_irqs *msi)
 {
-	return default_teardown_msi_irqs(dev);
+	return default_teardown_msi_irqs(msi);
 }
 
-static void default_restore_msi_irq(struct pci_dev *dev, int irq)
+static void default_restore_msi_irq(struct msi_irqs *msi, int irq)
 {
 	struct msi_desc *entry;
 
 	entry = NULL;
-	if (dev->msix_enabled) {
-		list_for_each_entry(entry, &dev->msi_list, list) {
+	if (msi->msix_enabled) {
+		list_for_each_entry(entry, &msi->msi_list, list) {
 			if (irq == entry->irq)
 				break;
 		}
-	} else if (pci_dev_msi_enabled(dev, MSI_TYPE))  {
+	} else if (msi->msi_enabled)  {
 		entry = irq_get_msi_desc(irq);
 	}
 
@@ -133,20 +135,9 @@ static void default_restore_msi_irq(struct pci_dev *dev, int irq)
 		write_msi_msg(irq, &entry->msg);
 }
 
-void __weak arch_restore_msi_irqs(struct pci_dev *dev)
+void __weak arch_restore_msi_irqs(struct msi_irqs *msi)
 {
-	return default_restore_msi_irqs(dev);
-}
-
-static void msi_set_enable(struct pci_dev *dev, int enable)
-{
-	u16 control;
-
-	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
-	control &= ~PCI_MSI_FLAGS_ENABLE;
-	if (enable)
-		control |= PCI_MSI_FLAGS_ENABLE;
-	pci_write_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, control);
+	return default_restore_msi_irqs(msi);
 }
 
 static void msix_clear_and_set_ctrl(struct pci_dev *dev, u16 clear, u16 set)
@@ -159,6 +150,25 @@ static void msix_clear_and_set_ctrl(struct pci_dev *dev, u16 clear, u16 set)
 	pci_write_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, ctrl);
 }
 
+static void msi_set_enable(struct msi_irqs *msi, int enable, int type)
+{
+	u16 control;
+	struct pci_dev *dev = msi->data;
+
+	if (type == MSI_TYPE) {
+		pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
+		control &= ~PCI_MSI_FLAGS_ENABLE;
+		if (enable)
+			control |= PCI_MSI_FLAGS_ENABLE;
+		pci_write_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, control);
+	} else if (type == MSIX_TYPE) {
+		if (enable)
+			msix_clear_and_set_ctrl(dev, 0, PCI_MSIX_FLAGS_ENABLE);
+		else
+			msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
+	}
+}
+
 static inline __attribute_const__ u32 msi_mask(unsigned x)
 {
 	/* Don't shift by >= width of type */
@@ -175,6 +185,7 @@ static inline __attribute_const__ u32 msi_mask(unsigned x)
  */
 u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
+	struct pci_dev *dev = desc->msi->data;
 	u32 mask_bits = desc->masked;
 
 	if (!desc->msi_attrib.maskbit)
@@ -182,7 +193,7 @@ u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 
 	mask_bits &= ~mask;
 	mask_bits |= flag;
-	pci_write_config_dword(desc->dev, desc->mask_pos, mask_bits);
+	pci_write_config_dword(dev, desc->mask_pos, mask_bits);
 
 	return mask_bits;
 }
@@ -250,18 +261,30 @@ void unmask_msi_irq(struct irq_data *data)
 	msi_set_mask_bit(data, 0);
 }
 
-void default_restore_msi_irqs(struct pci_dev *dev)
+static void msix_set_all_mask(struct msi_irqs *msi, int flag)
+{
+	struct pci_dev *dev = msi->data;
+
+	if (flag)
+		msix_clear_and_set_ctrl(dev, 0, PCI_MSIX_FLAGS_MASKALL);
+	else
+		msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
+}
+
+void default_restore_msi_irqs(struct msi_irqs *msi)
 {
 	struct msi_desc *entry;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		default_restore_msi_irq(dev, entry->irq);
+	list_for_each_entry(entry, &msi->msi_list, list) {
+		default_restore_msi_irq(msi, entry->irq);
 	}
 }
 
 void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
-	BUG_ON(entry->dev->current_state != PCI_D0);
+	struct pci_dev *dev = entry->msi->data;
+
+	BUG_ON(dev->current_state != PCI_D0);
 
 	if (entry->msi_attrib.is_msix) {
 		void __iomem *base = entry->mask_base +
@@ -271,7 +294,6 @@ void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 		msg->address_hi = readl(base + PCI_MSIX_ENTRY_UPPER_ADDR);
 		msg->data = readl(base + PCI_MSIX_ENTRY_DATA);
 	} else {
-		struct pci_dev *dev = entry->dev;
 		int pos = dev->msi_cap;
 		u16 data;
 
@@ -315,7 +337,9 @@ void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
 
 void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
-	if (entry->dev->current_state != PCI_D0) {
+	struct pci_dev *dev = entry->msi->data;
+
+	if (dev->current_state != PCI_D0) {
 		/* Don't touch the hardware now */
 	} else if (entry->msi_attrib.is_msix) {
 		void __iomem *base;
@@ -326,7 +350,6 @@ void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 		writel(msg->address_hi, base + PCI_MSIX_ENTRY_UPPER_ADDR);
 		writel(msg->data, base + PCI_MSIX_ENTRY_DATA);
 	} else {
-		struct pci_dev *dev = entry->dev;
 		int pos = dev->msi_cap;
 		u16 msgctl;
 
@@ -357,14 +380,34 @@ void write_msi_msg(unsigned int irq, struct msi_msg *msg)
 	__write_msi_msg(entry, msg);
 }
 
-static void free_msi_irqs(struct pci_dev *dev)
+static void free_msi_sysfs(struct pci_dev *dev)
 {
-	struct msi_desc *entry, *tmp;
 	struct attribute **msi_attrs;
 	struct device_attribute *dev_attr;
 	int count = 0;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
+	if (dev->msi_irq_groups) {
+		sysfs_remove_groups(&dev->dev.kobj, dev->msi_irq_groups);
+		msi_attrs = dev->msi_irq_groups[0]->attrs;
+		while (msi_attrs[count]) {
+			dev_attr = container_of(msi_attrs[count],
+						struct device_attribute, attr);
+			kfree(dev_attr->attr.name);
+			kfree(dev_attr);
+			++count;
+		}
+		kfree(msi_attrs);
+		kfree(dev->msi_irq_groups[0]);
+		kfree(dev->msi_irq_groups);
+		dev->msi_irq_groups = NULL;
+	}
+}
+
+static void free_msi_irqs(struct msi_irqs *msi)
+{
+	struct msi_desc *entry, *tmp;
+
+	list_for_each_entry(entry, &msi->msi_list, list) {
 		int i, nvec;
 		if (!entry->irq)
 			continue;
@@ -376,11 +419,11 @@ static void free_msi_irqs(struct pci_dev *dev)
 			BUG_ON(irq_has_action(entry->irq + i));
 	}
 
-	arch_teardown_msi_irqs(dev);
+	arch_teardown_msi_irqs(msi);
 
-	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
+	list_for_each_entry_safe(entry, tmp, &msi->msi_list, list) {
 		if (entry->msi_attrib.is_msix) {
-			if (list_is_last(&entry->list, &dev->msi_list))
+			if (list_is_last(&entry->list, &msi->msi_list))
 				iounmap(entry->mask_base);
 		}
 
@@ -398,38 +441,24 @@ static void free_msi_irqs(struct pci_dev *dev)
 		list_del(&entry->list);
 		kfree(entry);
 	}
-
-	if (dev->msi_irq_groups) {
-		sysfs_remove_groups(&dev->dev.kobj, dev->msi_irq_groups);
-		msi_attrs = dev->msi_irq_groups[0]->attrs;
-		while (msi_attrs[count]) {
-			dev_attr = container_of(msi_attrs[count],
-						struct device_attribute, attr);
-			kfree(dev_attr->attr.name);
-			kfree(dev_attr);
-			++count;
-		}
-		kfree(msi_attrs);
-		kfree(dev->msi_irq_groups[0]);
-		kfree(dev->msi_irq_groups);
-		dev->msi_irq_groups = NULL;
-	}
 }
 
-static struct msi_desc *alloc_msi_entry(struct pci_dev *dev)
+static struct msi_desc *alloc_msi_entry(struct msi_irqs *msi)
 {
 	struct msi_desc *desc = kzalloc(sizeof(*desc), GFP_KERNEL);
 	if (!desc)
 		return NULL;
 
 	INIT_LIST_HEAD(&desc->list);
-	desc->dev = dev;
+	desc->msi = msi;
 
 	return desc;
 }
 
-static void pci_intx_for_msi(struct pci_dev *dev, int enable)
+static void pci_intx_for_msi(struct msi_irqs *msi, int enable)
 {
+	struct pci_dev *dev = msi->data;
+
 	if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
 		pci_intx(dev, enable);
 }
@@ -444,9 +473,9 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 
 	entry = irq_get_msi_desc(dev->irq);
 
-	pci_intx_for_msi(dev, 0);
-	msi_set_enable(dev, 0);
-	arch_restore_msi_irqs(dev);
+	pci_intx_for_msi(dev->msi, 0);
+	msi_set_enable(dev->msi, 0, MSI_TYPE);
+	arch_restore_msi_irqs(dev->msi);
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
 	msi_mask_irq(entry, msi_mask(entry->msi_attrib.multi_cap),
@@ -459,22 +488,21 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 static void __pci_restore_msix_state(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
+	struct msi_irqs *msi = dev->msi;
 
-	if (!dev->msix_enabled)
+	if (!pci_dev_msi_enabled(dev, MSIX_TYPE))
 		return;
-	BUG_ON(list_empty(&dev->msi_list));
+	BUG_ON(list_empty(&msi->msi_list));
 
 	/* route the table */
-	pci_intx_for_msi(dev, 0);
-	msix_clear_and_set_ctrl(dev, 0,
-				PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL);
-
-	arch_restore_msi_irqs(dev);
-	list_for_each_entry(entry, &dev->msi_list, list) {
+	pci_intx_for_msi(msi, 0);
+	msi_set_enable(msi, 1, MSIX_TYPE);
+	msix_set_all_mask(msi, 1);
+	arch_restore_msi_irqs(msi);
+	list_for_each_entry(entry, &msi->msi_list, list) 
 		msix_mask_irq(entry, entry->masked);
-	}
 
-	msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
+	msix_set_all_mask(msi, 0);
 }
 
 void pci_restore_msi_state(struct pci_dev *dev)
@@ -516,7 +544,7 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
 	int count = 0;
 
 	/* Determine how many msi entries we have */
-	list_for_each_entry(entry, &pdev->msi_list, list) {
+	list_for_each_entry(entry, &pdev->msi->msi_list, list) {
 		++num_msi;
 	}
 	if (!num_msi)
@@ -526,7 +554,7 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
 	msi_attrs = kzalloc(sizeof(void *) * (num_msi + 1), GFP_KERNEL);
 	if (!msi_attrs)
 		return -ENOMEM;
-	list_for_each_entry(entry, &pdev->msi_list, list) {
+	list_for_each_entry(entry, &pdev->msi->msi_list, list) {
 		msi_dev_attr = kzalloc(sizeof(*msi_dev_attr), GFP_KERNEL);
 		if (!msi_dev_attr)
 			goto error_attrs;
@@ -578,13 +606,14 @@ error_attrs:
 	return ret;
 }
 
-static struct msi_desc *msi_setup_entry(struct pci_dev *dev)
+static struct msi_desc *msi_setup_entry(struct msi_irqs *msi)
 {
 	u16 control;
 	struct msi_desc *entry;
+	struct pci_dev *dev = msi->data;
 
 	/* MSI Entry Initialization */
-	entry = alloc_msi_entry(dev);
+	entry = alloc_msi_entry(msi);
 	if (!entry)
 		return NULL;
 
@@ -620,15 +649,15 @@ static struct msi_desc *msi_setup_entry(struct pci_dev *dev)
  * an error, and a positive return value indicates the number of interrupts
  * which could have been allocated.
  */
-static int msi_capability_init(struct pci_dev *dev, int nvec)
+static int msi_capability_init(struct msi_irqs *msi, int nvec)
 {
 	struct msi_desc *entry;
 	int ret;
 	unsigned mask;
 
-	msi_set_enable(dev, 0);	/* Disable MSI during set up */
+	msi_set_enable(msi, 0, MSI_TYPE);	/* Disable MSI during set up */
 
-	entry = msi_setup_entry(dev);
+	entry = msi_setup_entry(msi);
 	if (!entry)
 		return -ENOMEM;
 
@@ -636,21 +665,23 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 	mask = msi_mask(entry->msi_attrib.multi_cap);
 	msi_mask_irq(entry, mask, mask);
 
-	list_add_tail(&entry->list, &dev->msi_list);
+	list_add_tail(&entry->list, &msi->msi_list);
 
 	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(dev, nvec, MSI_TYPE);
-	if (ret) {
-		msi_mask_irq(entry, mask, ~mask);
-		free_msi_irqs(dev);
-		return ret;
-	}
+	ret = arch_setup_msi_irqs(msi, nvec, MSI_TYPE);
+	if (ret)
+		goto err;
 
 	/* Set MSI enabled bits	 */
-	pci_intx_for_msi(dev, 0);
-	msi_set_enable(dev, 1);
-	dev->msi_enabled = 1;
+	pci_intx_for_msi(msi, 0);
+	msi_set_enable(msi, 1, MSI_TYPE);
+	msi->msi_enabled = 1;
 	return 0;
+
+err:
+	msi_mask_irq(entry, mask, ~mask);
+	free_msi_irqs(msi);
+	return ret;
 }
 
 static void __iomem *msix_map_region(struct pci_dev *dev, unsigned nr_entries)
@@ -668,19 +699,20 @@ static void __iomem *msix_map_region(struct pci_dev *dev, unsigned nr_entries)
 	return ioremap_nocache(phys_addr, nr_entries * PCI_MSIX_ENTRY_SIZE);
 }
 
-static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
+static int msix_setup_entries(struct msi_irqs *msi, void __iomem *base,
 			      struct msix_entry *entries, int nvec)
 {
 	struct msi_desc *entry;
 	int i, offset;
+	struct pci_dev *dev = msi->data;
 
 	for (i = 0; i < nvec; i++) {
-		entry = alloc_msi_entry(dev);
+		entry = alloc_msi_entry(msi);
 		if (!entry) {
 			if (!i)
 				iounmap(base);
 			else
-				free_msi_irqs(dev);
+				free_msi_irqs(msi);
 			/* No enough memory. Don't try again */
 			return -ENOMEM;
 		}
@@ -688,7 +720,6 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		entry->msi_attrib.is_msix	= 1;
 		entry->msi_attrib.is_64		= 1;
 		entry->msi_attrib.entry_nr	= entries[i].entry;
-		entry->msi_attrib.default_irq	= dev->irq;
 		entry->mask_base		= base;
 
 		msix_clear_and_set_ctrl(dev, 0, 
@@ -700,19 +731,19 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		msix_clear_and_set_ctrl(dev, 
 				PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE, 0);
 
-		list_add_tail(&entry->list, &dev->msi_list);
+		list_add_tail(&entry->list, &msi->msi_list);
 	}
 
 	return 0;
 }
 
-static void msix_program_entries(struct pci_dev *dev,
+static void msix_program_entries(struct msi_irqs *msi,
 				 struct msix_entry *entries)
 {
 	struct msi_desc *entry;
 	int i = 0;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
+	list_for_each_entry(entry, &msi->msi_list, list) {
 		entries[i].vector = entry->irq;
 		irq_set_msi_desc(entry->irq, entry);
 		i++;
@@ -729,19 +760,19 @@ static void msix_program_entries(struct pci_dev *dev,
  * single MSI-X irq. A return of zero indicates the successful setup of
  * requested MSI-X entries with allocated irqs or non-zero for otherwise.
  **/
-static int msix_capability_init(struct pci_dev *dev, void __iomem *base,
+static int msix_capability_init(struct msi_irqs *msi, void __iomem *base,
 				struct msix_entry *entries, int nvec)
 {
 	int ret;
 
 	/* Ensure MSI-X is disabled while it is set up */
-	msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
+	msi_set_enable(msi, 0, MSIX_TYPE);
 
-	ret = msix_setup_entries(dev, base, entries, nvec);
+	ret = msix_setup_entries(msi, base, entries, nvec);
 	if (ret)
 		return ret;
 
-	ret = arch_setup_msi_irqs(dev, nvec, MSIX_TYPE);
+	ret = arch_setup_msi_irqs(msi, nvec, MSIX_TYPE);
 	if (ret)
 		goto out_avail;
 
@@ -750,13 +781,13 @@ static int msix_capability_init(struct pci_dev *dev, void __iomem *base,
 	 * MSI-X registers.  We need to mask all the vectors to prevent
 	 * interrupts coming in before they're fully set up.
 	 */
-	msix_program_entries(dev, entries);
+	msix_program_entries(msi, entries);
 
 	/* Set MSI-X enabled bits and unmask the function */
-	pci_intx_for_msi(dev, 0);
-	dev->msix_enabled = 1;
+	pci_intx_for_msi(msi, 0);
+	msi->msix_enabled = 1;
 
-	msix_clear_and_set_ctrl(dev, 0, PCI_MSIX_FLAGS_ENABLE);
+	msi_set_enable(msi, 1, MSIX_TYPE);
 
 	return 0;
 
@@ -769,7 +800,7 @@ out_avail:
 		struct msi_desc *entry;
 		int avail = 0;
 
-		list_for_each_entry(entry, &dev->msi_list, list) {
+		list_for_each_entry(entry, &msi->msi_list, list) {
 			if (entry->irq != 0)
 				avail++;
 		}
@@ -777,7 +808,7 @@ out_avail:
 			ret = avail;
 	}
 
-	free_msi_irqs(dev);
+	free_msi_irqs(msi);
 
 	return ret;
 }
@@ -820,7 +851,7 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
 		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
 			return -EINVAL;
 
-	ret = arch_msi_check_device(dev, nvec, type);
+	ret = arch_msi_check_device(dev->msi, nvec, type);
 	if (ret)
 		return ret;
 
@@ -861,12 +892,12 @@ void pci_msi_shutdown(struct pci_dev *dev)
 			!pci_dev_msi_enabled(dev, MSI_TYPE))
 		return;
 
-	BUG_ON(list_empty(&dev->msi_list));
-	desc = list_first_entry(&dev->msi_list, struct msi_desc, list);
+	BUG_ON(list_empty(&dev->msi->msi_list));
+	desc = list_first_entry(&dev->msi->msi_list, struct msi_desc, list);
 
-	msi_set_enable(dev, 0);
-	pci_intx_for_msi(dev, 1);
-	dev->msi_enabled = 0;
+	msi_set_enable(dev->msi, 0, MSI_TYPE);
+	pci_intx_for_msi(dev->msi, 1);
+	dev->msi->msi_enabled = 0;
 
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
@@ -884,7 +915,8 @@ void pci_disable_msi(struct pci_dev *dev)
 		return;
 
 	pci_msi_shutdown(dev);
-	free_msi_irqs(dev);
+	free_msi_irqs(dev->msi);
+	free_msi_sysfs(dev);
 }
 EXPORT_SYMBOL(pci_disable_msi);
 
@@ -930,9 +962,10 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 	void __iomem *base;
 	u16 control;
 
-	if (!entries || !dev->msix_cap || dev->current_state != PCI_D0)
+	if (!entries || !dev->msix_cap || !dev->msi
+		   	|| dev->current_state != PCI_D0)
 		return -EINVAL;
-
+	
 	status = pci_msi_check_device(dev, nvec, MSIX_TYPE);
 	if (status)
 		return status;
@@ -952,7 +985,7 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 				return -EINVAL;	/* duplicate entry */
 		}
 	}
-	WARN_ON(!!dev->msix_enabled);
+	WARN_ON(!!pci_dev_msi_enabled(dev, MSIX_TYPE));
 
 	/* Check whether driver already requested for MSI irq */
 	if (pci_dev_msi_enabled(dev, MSI_TYPE)) {
@@ -966,13 +999,13 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 	if (!base)
 		return -ENOMEM;
 
-	status = msix_capability_init(dev, base, entries, nvec);
+	status = msix_capability_init(dev->msi, base, entries, nvec);
 	if (!status) {
 		ret = populate_msi_sysfs(dev);
 		if (ret) {
-			dev->msix_enabled = 0;
-			pci_intx_for_msi(dev, 1);
-			free_msi_irqs(dev);
+			dev->msi->msix_enabled = 0;
+			pci_intx_for_msi(dev->msi, 1);
+			free_msi_irqs(dev->msi);
 		}
 	}
 	return status;
@@ -983,18 +1016,18 @@ void pci_msix_shutdown(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
 
-	if (!pci_msi_enable || !dev || !dev->msix_enabled)
+	if (!pci_msi_enable || !dev || !pci_dev_msi_enabled(dev, MSIX_TYPE))
 		return;
 
 	/* Return the device with MSI-X masked as initial states */
-	list_for_each_entry(entry, &dev->msi_list, list) {
+	list_for_each_entry(entry, &dev->msi->msi_list, list) {
 		/* Keep cached states to be restored */
 		arch_msix_mask_irq(entry, 1);
 	}
 
-	msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
-	pci_intx_for_msi(dev, 1);
-	dev->msix_enabled = 0;
+	msi_set_enable(dev->msi, 0, MSIX_TYPE);
+	pci_intx_for_msi(dev->msi, 1);
+	dev->msi->msix_enabled = 0;
 }
 
 void pci_disable_msix(struct pci_dev *dev)
@@ -1004,7 +1037,8 @@ void pci_disable_msix(struct pci_dev *dev)
 		return;
 
 	pci_msix_shutdown(dev);
-	free_msi_irqs(dev);
+	free_msi_irqs(dev->msi);
+	free_msi_sysfs(dev);
 }
 EXPORT_SYMBOL(pci_disable_msix);
 
@@ -1025,21 +1059,52 @@ int pci_msi_enabled(void)
 }
 EXPORT_SYMBOL(pci_msi_enabled);
 
-void pci_msi_init_pci_dev(struct pci_dev *dev)
+static struct msi_ops pci_msi = {
+	.msi_set_enable = msi_set_enable,
+	.msi_setup_entry = msi_setup_entry,
+	.msix_setup_entries = msix_setup_entries,
+	.msi_mask_irq = default_msi_mask_irq,
+	.msix_mask_irq = default_msix_mask_irq,
+	.msi_read_message = __read_msi_msg,
+	.msi_write_message = __write_msi_msg,
+	.msi_set_intx =  pci_intx_for_msi,
+};
+
+struct msi_irqs *alloc_msi_irqs(void *data, struct msi_ops *ops)
 {
-	INIT_LIST_HEAD(&dev->msi_list);
+	struct msi_irqs *msi;
+
+	msi = kzalloc(sizeof(struct msi_irqs), GFP_KERNEL);
+	if (!msi)
+		return NULL;
 
+	INIT_LIST_HEAD(&msi->msi_list);
+	msi->data = data;
+	msi->ops = ops;
+	return msi;
+}
+
+void pci_msi_init_pci_dev(struct pci_dev *dev)
+{
 	/* Disable the msi hardware to avoid screaming interrupts
 	 * during boot.  This is the power on reset default so
 	 * usually this should be a noop.
 	 */
 	dev->msi_cap = pci_find_capability(dev, PCI_CAP_ID_MSI);
-	if (dev->msi_cap)
-		msi_set_enable(dev, 0);
-
 	dev->msix_cap = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	if (dev->msix_cap)
-		msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
+
+	if (dev->msi_cap || dev->msix_cap) {
+		dev->msi = alloc_msi_irqs(dev, &pci_msi);
+		if (!dev->msi)
+			return;
+			
+		dev->msi->node = dev_to_node(&dev->dev);
+		if (dev->msi_cap) 
+			msi_set_enable(dev->msi, 0, MSI_TYPE);
+
+		if (dev->msix_cap) 
+			msi_set_enable(dev->msi, 0, MSIX_TYPE);
+	}
 }
 
 /**
@@ -1060,13 +1125,13 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 	int rc;
 	struct msi_desc *entry;
 
-	if (dev->current_state != PCI_D0)
+	if (dev->current_state != PCI_D0 || !dev->msi)
 		return -EINVAL;
 
-	WARN_ON(!!dev->msi_enabled);
+	WARN_ON(!!pci_dev_msi_enabled(dev, MSI_TYPE));
 
 	/* Check whether driver already requested MSI-X irqs */
-	if (dev->msix_enabled) {
+	if (pci_dev_msi_enabled(dev, MSIX_TYPE)) {
 		dev_info(&dev->dev,
 			 "can't enable MSI (MSI-X already enabled)\n");
 		return -EINVAL;
@@ -1095,7 +1160,7 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 	} while (rc);
 
 	do {
-		rc = msi_capability_init(dev, nvec);
+		rc = msi_capability_init(dev->msi, nvec);
 		if (rc < 0) {
 			return rc;
 		} else if (rc > 0) {
@@ -1107,14 +1172,14 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 
 	rc = populate_msi_sysfs(dev);
 	if (rc) {
-		msi_set_enable(dev, 0);
-		pci_intx_for_msi(dev, 1);
-		dev->msi_enabled = 0;
-		free_msi_irqs(dev);
+		msi_set_enable(dev->msi, 0, MSI_TYPE);
+		pci_intx_for_msi(dev->msi, 1);
+		dev->msi->msi_enabled = 0;
+		free_msi_irqs(dev->msi);
 		return rc;
 	}
 
-	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
+	entry = list_entry(dev->msi->msi_list.next, struct msi_desc, list);
 	dev->irq = entry->irq;
 	return nvec;
 }
@@ -1158,3 +1223,5 @@ int pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
 	return nvec;
 }
 EXPORT_SYMBOL(pci_enable_msix_range);
+
+
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 5a672d3..fc8f3e8 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -83,15 +83,15 @@ struct msi_desc {
  * implemented as weak symbols so that they /can/ be overriden by
  * architecture specific code if needed.
  */
-int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
+int arch_setup_msi_irq(struct msi_irqs *msi, struct msi_desc *desc);
 void arch_teardown_msi_irq(unsigned int irq);
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
-void arch_teardown_msi_irqs(struct pci_dev *dev);
-int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
-void arch_restore_msi_irqs(struct pci_dev *dev);
+int arch_setup_msi_irqs(struct msi_irqs *msi, int nvec, int type);
+void arch_teardown_msi_irqs(struct msi_irqs *msi);
+int arch_msi_check_device(struct msi_irqs *msi, int nvec, int type);
+void arch_restore_msi_irqs(struct msi_irqs *msi);
 
-void default_teardown_msi_irqs(struct pci_dev *dev);
-void default_restore_msi_irqs(struct pci_dev *dev);
+void default_teardown_msi_irqs(struct msi_irqs *msi);
+void default_restore_msi_irqs(struct msi_irqs *msi);
 u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
 u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c7bca1c..d7126fc 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -334,8 +334,6 @@ struct pci_dev {
 	unsigned int	block_cfg_access:1;	/* config space access is blocked */
 	unsigned int	broken_parity_status:1;	/* Device generates false positive parity */
 	unsigned int	irq_reroute_variant:2;	/* device needs IRQ rerouting variant */
-	unsigned int	msi_enabled:1;
-	unsigned int	msix_enabled:1;
 	unsigned int	ari_enabled:1;	/* ARI forwarding */
 	unsigned int	is_managed:1;
 	unsigned int    needs_freset:1; /* Dev requires fundamental reset */
@@ -358,7 +356,7 @@ struct pci_dev {
 	struct bin_attribute *res_attr[DEVICE_COUNT_RESOURCE]; /* sysfs file for resources */
 	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of resources */
 #ifdef CONFIG_PCI_MSI
-	struct list_head msi_list;
+	struct msi_irqs *msi;
 	const struct attribute_group **msi_irq_groups;
 #endif
 	struct pci_vpd *vpd;
@@ -510,11 +508,14 @@ static inline struct pci_dev *pci_upstream_bridge(struct pci_dev *dev)
 static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev, int type)
 {
 	bool enabled = 0;
+	
+	if (!pci_dev->msi)
+		return false;
 
 	if (type & MSI_TYPE)
-		enabled |= pci_dev->msi_enabled;
+		enabled |= pci_dev->msi->msi_enabled;
 	if (type & MSIX_TYPE)
-		enabled |= pci_dev->msix_enabled;
+		enabled |= pci_dev->msi->msix_enabled;
 
 	return enabled;
 }
-- 
1.7.1

