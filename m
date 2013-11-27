Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab3K0Sq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:46:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3K0Sqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:46:54 -0500
Date: Wed, 27 Nov 2013 10:46:52 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Neil Horman <nhorman@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCI: export MSI mode using attributes, not kobjects
Message-ID: <20131127184652.GA1856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The PCI MSI sysfs code is a mess with kobjects for things that don't
really need to be kobjects.  This patch creates attributes dynamically
for the MSI interrupts instead of using kobjects.

Note, this removes a directory from the current MSI interrupt sysfs
code:

old MSI kobjects:
pci_device
   └── msi_irqs
       └── 40
           └── mode

new MSI attributes:
pci_device
   └── msi_irqs
       └── 40

As there was only one file "mode" with the kobject model, the interrupt
number is now a file that returns the "mode" of the interrupt (msi vs.
msix).

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

Neil, can you test this patch to see if irqbalance works as-is or not?

thanks,

greg k-h

 drivers/pci/msi.c   |  152 +++++++++++++++++++++++++---------------------------
 include/linux/pci.h |    2 
 2 files changed, 76 insertions(+), 78 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -363,6 +363,9 @@ void write_msi_msg(unsigned int irq, str
 static void free_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry, *tmp;
+	struct attribute **msi_attrs;
+	struct device_attribute *dev_attr;
+	int count = 0;
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
 		int i, nvec;
@@ -398,6 +401,22 @@ static void free_msi_irqs(struct pci_dev
 		list_del(&entry->list);
 		kfree(entry);
 	}
+
+	if (dev->msi_irq_groups) {
+		sysfs_remove_groups(&dev->dev.kobj, dev->msi_irq_groups);
+		msi_attrs = dev->msi_irq_groups[0]->attrs;
+		list_for_each_entry(entry, &dev->msi_list, list) {
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
 }
 
 static struct msi_desc *alloc_msi_entry(struct pci_dev *dev)
@@ -471,96 +490,79 @@ void pci_restore_msi_state(struct pci_de
 }
 EXPORT_SYMBOL_GPL(pci_restore_msi_state);
 
-
-#define to_msi_attr(obj) container_of(obj, struct msi_attribute, attr)
-#define to_msi_desc(obj) container_of(obj, struct msi_desc, kobj)
-
-struct msi_attribute {
-	struct attribute        attr;
-	ssize_t (*show)(struct msi_desc *entry, struct msi_attribute *attr,
-			char *buf);
-	ssize_t (*store)(struct msi_desc *entry, struct msi_attribute *attr,
-			 const char *buf, size_t count);
-};
-
-static ssize_t show_msi_mode(struct msi_desc *entry, struct msi_attribute *atr,
+static ssize_t msi_mode_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	return sprintf(buf, "%s\n", entry->msi_attrib.is_msix ? "msix" : "msi");
-}
-
-static ssize_t msi_irq_attr_show(struct kobject *kobj,
-				 struct attribute *attr, char *buf)
-{
-	struct msi_attribute *attribute = to_msi_attr(attr);
-	struct msi_desc *entry = to_msi_desc(kobj);
-
-	if (!attribute->show)
-		return -EIO;
-
-	return attribute->show(entry, attribute, buf);
-}
-
-static const struct sysfs_ops msi_irq_sysfs_ops = {
-	.show = msi_irq_attr_show,
-};
-
-static struct msi_attribute mode_attribute =
-	__ATTR(mode, S_IRUGO, show_msi_mode, NULL);
-
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct msi_desc *entry;
+	unsigned long irq;
+	int retval;
 
-static struct attribute *msi_irq_default_attrs[] = {
-	&mode_attribute.attr,
-	NULL
-};
+	retval = kstrtoul(attr->attr.name, 10, &irq);
+	if (retval)
+		return retval;
 
-static void msi_kobj_release(struct kobject *kobj)
-{
-	struct msi_desc *entry = to_msi_desc(kobj);
-
-	pci_dev_put(entry->dev);
+	list_for_each_entry(entry, &pdev->msi_list, list) {
+		if (entry->irq == irq) {
+			return sprintf(buf, "%s\n",
+				       entry->msi_attrib.is_msix ? "msix" : "msi");
+		}
+	}
+	return -ENODEV;
 }
 
-static struct kobj_type msi_irq_ktype = {
-	.release = msi_kobj_release,
-	.sysfs_ops = &msi_irq_sysfs_ops,
-	.default_attrs = msi_irq_default_attrs,
-};
-
 static int populate_msi_sysfs(struct pci_dev *pdev)
 {
+	struct attribute **msi_attrs;
+	struct device_attribute *msi_dev_attr;
+	struct attribute_group *msi_irq_group;
+	const struct attribute_group **msi_irq_groups;
 	struct msi_desc *entry;
-	struct kobject *kobj;
 	int ret;
+	int num_msi = 0;
 	int count = 0;
 
-	pdev->msi_kset = kset_create_and_add("msi_irqs", NULL, &pdev->dev.kobj);
-	if (!pdev->msi_kset)
-		return -ENOMEM;
-
+	/* Determine how many msi entries we have */
 	list_for_each_entry(entry, &pdev->msi_list, list) {
-		kobj = &entry->kobj;
-		kobj->kset = pdev->msi_kset;
-		pci_dev_get(pdev);
-		ret = kobject_init_and_add(kobj, &msi_irq_ktype, NULL,
-				     "%u", entry->irq);
-		if (ret)
-			goto out_unroll;
-
-		count++;
+		++num_msi;
 	}
+	if (!num_msi)
+		return 0;
 
-	return 0;
-
-out_unroll:
+	/* Dynamically create the MSI attributes for the PCI device */
+	msi_attrs = kzalloc(sizeof(void *) * (num_msi + 1), GFP_KERNEL);
+	if (!msi_attrs)
+		return -ENOMEM;
 	list_for_each_entry(entry, &pdev->msi_list, list) {
-		if (!count)
-			break;
-		kobject_del(&entry->kobj);
-		kobject_put(&entry->kobj);
-		count--;
+		char *name = kmalloc(20, GFP_KERNEL);
+		msi_dev_attr = kzalloc(sizeof(*msi_dev_attr), GFP_KERNEL);
+		if (!msi_dev_attr)
+			return -ENOMEM;
+		sprintf(name, "%d", entry->irq);
+		msi_dev_attr->attr.name = name;
+		msi_dev_attr->attr.mode = S_IRUGO;
+		msi_dev_attr->show = msi_mode_show;
+		msi_attrs[count] = &msi_dev_attr->attr;
+		++count;
 	}
-	return ret;
+
+	msi_irq_group = kzalloc(sizeof(*msi_irq_group), GFP_KERNEL);
+	if (!msi_irq_group)
+		return -ENOMEM;
+	msi_irq_group->name = "msi_irqs";
+	msi_irq_group->attrs = msi_attrs;
+
+	msi_irq_groups = kzalloc(sizeof(void *) * 2, GFP_KERNEL);
+	if (!msi_irq_groups)
+		return -ENOMEM;
+	msi_irq_groups[0] = msi_irq_group;
+
+	ret = sysfs_create_groups(&pdev->dev.kobj, msi_irq_groups);
+	if (ret)
+		return ret;
+	pdev->msi_irq_groups = msi_irq_groups;
+
+	return 0;
 }
 
 /**
@@ -925,8 +927,6 @@ void pci_disable_msi(struct pci_dev *dev
 
 	pci_msi_shutdown(dev);
 	free_msi_irqs(dev);
-	kset_unregister(dev->msi_kset);
-	dev->msi_kset = NULL;
 }
 EXPORT_SYMBOL(pci_disable_msi);
 
@@ -1023,8 +1023,6 @@ void pci_disable_msix(struct pci_dev *de
 
 	pci_msix_shutdown(dev);
 	free_msi_irqs(dev);
-	kset_unregister(dev->msi_kset);
-	dev->msi_kset = NULL;
 }
 EXPORT_SYMBOL(pci_disable_msix);
 
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -351,7 +351,7 @@ struct pci_dev {
 	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of resources */
 #ifdef CONFIG_PCI_MSI
 	struct list_head msi_list;
-	struct kset *msi_kset;
+	const struct attribute_group **msi_irq_groups;
 #endif
 	struct pci_vpd *vpd;
 #ifdef CONFIG_PCI_ATS
