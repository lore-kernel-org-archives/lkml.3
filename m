Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbaGZCoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:44:20 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:45737 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbaGZCnw (ORCPT
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
Subject: [RFC PATCH 10/11] PCI/MSI: Split the generic MSI code into new file
Date: Sat, 26 Jul 2014 11:08:47 +0800
Message-ID: <1406344128-27055-11-git-send-email-wangyijing@huawei.com>
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

MSI interrupt will not only used in PCI device, more
and more Non-PCI device also want to use MSI. ARM
GIC v3 spec says in ARM platform with GIC v3 controller,
Non-PCI device can also be design to support MSI to
simplify interrupt wires, for the existing Non-PCI
device, consolidator is designed and used to translate
legacy interrupt to MSI. So for support Non-PCI MSI
device, generic MSI driver is needed. Split the generic
MSI code into new location, drivers/msi/msi.c. Then
MSI driver does not depend PCI anymore.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/Kconfig      |    1 +
 drivers/Makefile     |    1 +
 drivers/msi/Kconfig  |    8 +
 drivers/msi/Makefile |    1 +
 drivers/msi/msi.c    |  540 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/Kconfig  |    6 +-
 drivers/pci/msi.c    |  500 ++++-------------------------------------------
 include/linux/msi.h  |   31 +++-
 8 files changed, 617 insertions(+), 471 deletions(-)
 create mode 100644 drivers/msi/Kconfig
 create mode 100644 drivers/msi/Makefile
 create mode 100644 drivers/msi/msi.c

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 0e87a34..4d05749 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -176,4 +176,5 @@ source "drivers/powercap/Kconfig"
 
 source "drivers/mcb/Kconfig"
 
+source "drivers/msi/Kconfig"
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index f98b50d..47ae3d1 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -158,3 +158,4 @@ obj-$(CONFIG_NTB)		+= ntb/
 obj-$(CONFIG_FMC)		+= fmc/
 obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
+obj-$(CONFIG_MSI)		+= msi/
diff --git a/drivers/msi/Kconfig b/drivers/msi/Kconfig
new file mode 100644
index 0000000..739bd13
--- /dev/null
+++ b/drivers/msi/Kconfig
@@ -0,0 +1,8 @@
+config MSI
+	bool "Message Signaled Interrupts (MSI and MSI-X)"
+	default y
+	help
+		This allows device drivers to use generic MSI(Message
+		Signaled Interrupt). Message Signaled Interrupts enable 
+		a device to generate an interrupt using an inbound Memory 
+		Write to a specific target address.
diff --git a/drivers/msi/Makefile b/drivers/msi/Makefile
new file mode 100644
index 0000000..39cb026
--- /dev/null
+++ b/drivers/msi/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MSI) += msi.o
diff --git a/drivers/msi/msi.c b/drivers/msi/msi.c
new file mode 100644
index 0000000..3fbd539
--- /dev/null
+++ b/drivers/msi/msi.c
@@ -0,0 +1,540 @@
+/*
+ * File:	msi.c
+ * Purpose:	Message Signaled Interrupt (MSI)
+ *
+ * Copyright (C) 2014 Huawei Ltd.
+ * Copyright (C) Yijing Wang <wangyijing@huawei.com> 
+ */
+#include <linux/err.h>
+#include <linux/mm.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/export.h>
+#include <linux/ioport.h>
+#include <linux/proc_fs.h>
+#include <linux/msi.h>
+#include <linux/smp.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+
+/* Arch hooks */
+
+int __weak arch_setup_msi_irq(struct msi_irqs *msi, struct msi_desc *desc)
+{
+	struct pci_dev *dev = msi->data;
+	struct msi_chip *chip = dev->bus->msi; //TO BE DONE: rework msi_chip to support Non-PCI MSI
+	int err;
+
+	if (!chip || !chip->setup_irq)
+		return -EINVAL;
+
+	err = chip->setup_irq(chip, dev, desc);
+	if (err < 0)
+		return err;
+
+	irq_set_chip_data(desc->irq, chip);
+	return 0;
+}
+
+void __weak arch_teardown_msi_irq(unsigned int irq)
+{
+	struct msi_chip *chip = irq_get_chip_data(irq);
+
+	if (!chip || !chip->teardown_irq)
+		return;
+
+	chip->teardown_irq(chip, irq);
+}
+
+int __weak arch_msi_check_device(struct msi_irqs *msi, int nvec, int type)
+{
+	struct pci_dev *dev = msi->data;
+	struct msi_chip *chip = dev->bus->msi; //TO BE DONE: rework msi_chip to support Non-PCI MSI
+
+	if (!chip || !chip->check_device)
+		return 0;
+
+	return chip->check_device(chip, dev, nvec, type);
+}
+
+int __weak arch_setup_msi_irqs(struct msi_irqs *msi, int nvec, int type)
+{
+	struct msi_desc *entry;
+	int ret;
+
+	/*
+	 * If an architecture wants to support multiple MSI, it needs to
+	 * override arch_setup_msi_irqs()
+	 */
+	if (type == MSI_TYPE && nvec > 1)
+		return 1;
+
+	list_for_each_entry(entry, &msi->msi_list, list) {
+		ret = arch_setup_msi_irq(msi, entry);
+		if (ret < 0)
+			return ret;
+		if (ret > 0)
+			return -ENOSPC;
+	}
+	return 0;
+}
+
+
+void __weak arch_teardown_msi_irqs(struct msi_irqs *msi)
+{
+	return default_teardown_msi_irqs(msi);
+}
+
+/*
+ * We have a default implementation available as a separate non-weak
+ * function, as it is used by the Xen x86 PCI code
+ */
+void default_teardown_msi_irqs(struct msi_irqs *msi)
+{
+	struct msi_desc *entry;
+
+	list_for_each_entry(entry, &msi->msi_list, list) {
+		int i, nvec;
+		if (entry->irq == 0)
+			continue;
+		if (entry->nvec_used)
+			nvec = entry->nvec_used;
+		else
+			nvec = 1 << entry->msi_attrib.multiple;
+		for (i = 0; i < nvec; i++)
+			arch_teardown_msi_irq(entry->irq + i);
+	}
+}
+
+static void default_restore_msi_irq(struct msi_irqs *msi, int irq)
+{
+	struct msi_desc *entry;
+
+	entry = NULL;
+	if (msi->msix_enabled) {
+		list_for_each_entry(entry, &msi->msi_list, list) {
+			if (irq == entry->irq)
+				break;
+		}
+	} else if (msi->msi_enabled)  {
+		entry = irq_get_msi_desc(irq);
+	}
+
+	if (entry)
+		write_msi_msg(irq, &entry->msg);
+}
+
+void default_restore_msi_irqs(struct msi_irqs *msi)
+{
+	struct msi_desc *entry;
+
+	list_for_each_entry(entry, &msi->msi_list, list) {
+		default_restore_msi_irq(msi, entry->irq);
+	}
+}
+
+void __weak arch_restore_msi_irqs(struct msi_irqs *msi)
+{
+	return default_restore_msi_irqs(msi);
+}
+
+u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+{
+	struct msi_irqs *msi = desc->msi;
+
+	if (!msi || !msi->ops || !msi->ops->msi_mask_irq)
+		return desc->masked;
+	return msi->ops->msi_mask_irq(desc, mask, flag);
+}
+
+__weak u32 arch_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+{
+	return default_msi_mask_irq(desc, mask, flag);
+}
+
+void msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+{
+	desc->masked = arch_msi_mask_irq(desc, mask, flag);
+}
+
+u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag)
+{
+	struct msi_irqs *msi = desc->msi;
+
+	if (!msi || !msi->ops || !msi->ops->msix_mask_irq)
+		return desc->masked;
+
+	return msi->ops->msix_mask_irq(desc, flag);
+}
+
+__weak u32 arch_msix_mask_irq(struct msi_desc *desc, u32 flag)
+{
+	return default_msix_mask_irq(desc, flag);
+}
+
+void msix_mask_irq(struct msi_desc *desc, u32 flag)
+{
+	desc->masked = arch_msix_mask_irq(desc, flag);
+}
+
+static void msi_set_mask_bit(struct irq_data *data, u32 flag)
+{
+	struct msi_desc *desc = irq_data_get_msi(data);
+
+	if (desc->msi_attrib.is_msix) {
+		msix_mask_irq(desc, flag);
+		readl(desc->mask_base);		/* Flush write to device */
+	} else {
+		unsigned offset = data->irq - desc->irq;
+		msi_mask_irq(desc, 1 << offset, flag << offset);
+	}
+}
+
+void mask_msi_irq(struct irq_data *data)
+{
+	msi_set_mask_bit(data, 1);
+}
+
+void unmask_msi_irq(struct irq_data *data)
+{
+	msi_set_mask_bit(data, 0);
+}
+
+void msi_set_enable(struct msi_irqs *msi, int enable, int type)
+{
+	if (!msi || !msi->ops || !msi->ops->msi_set_enable)
+		return;
+	msi->ops->msi_set_enable(msi, enable, type);
+}
+EXPORT_SYMBOL(msi_set_enable);
+
+void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+{
+	struct msi_irqs *msi = entry->msi;
+
+	if (!msi || !msi->ops || !msi->ops->msi_read_message)
+		return;
+	msi->ops->msi_read_message(entry, msg);
+}
+
+void read_msi_msg(unsigned int irq, struct msi_msg *msg)
+{
+	struct msi_desc *entry = irq_get_msi_desc(irq);
+
+	__read_msi_msg(entry, msg);
+}
+
+void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+{
+	/* Assert that the cache is valid, assuming that
+	 * valid messages are not all-zeroes. */
+	BUG_ON(!(entry->msg.address_hi | entry->msg.address_lo |
+		 entry->msg.data));
+
+	*msg = entry->msg;
+}
+
+void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
+{
+	struct msi_desc *entry = irq_get_msi_desc(irq);
+
+	__get_cached_msi_msg(entry, msg);
+}
+
+void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+{
+	struct msi_irqs *msi = entry->msi;
+
+	if (!msi || !msi->ops || !msi->ops->msi_write_message)
+		return;
+	msi->ops->msi_write_message(entry, msg);
+}
+
+void write_msi_msg(unsigned int irq, struct msi_msg *msg)
+{
+	struct msi_desc *entry = irq_get_msi_desc(irq);
+
+	__write_msi_msg(entry, msg);
+}
+
+void free_msi_irqs(struct msi_irqs *msi)
+{
+	struct msi_desc *entry, *tmp;
+
+	list_for_each_entry(entry, &msi->msi_list, list) {
+		int i, nvec;
+		if (!entry->irq)
+			continue;
+		if (entry->nvec_used)
+			nvec = entry->nvec_used;
+		else
+			nvec = 1 << entry->msi_attrib.multiple;
+		for (i = 0; i < nvec; i++)
+			BUG_ON(irq_has_action(entry->irq + i));
+	}
+
+	arch_teardown_msi_irqs(msi);
+
+	list_for_each_entry_safe(entry, tmp, &msi->msi_list, list) {
+		if (entry->msi_attrib.is_msix) {
+			if (list_is_last(&entry->list, &msi->msi_list))
+				iounmap(entry->mask_base);
+		}
+
+		/*
+		 * Its possible that we get into this path
+		 * When populate_msi_sysfs fails, which means the entries
+		 * were not registered with sysfs.  In that case don't
+		 * unregister them.
+		 */
+		if (entry->kobj.parent) {
+			kobject_del(&entry->kobj);
+			kobject_put(&entry->kobj);
+		}
+
+		list_del(&entry->list);
+		kfree(entry);
+	}
+}
+EXPORT_SYMBOL(free_msi_irqs);
+
+struct msi_irqs *alloc_msi_irqs(void *data, struct msi_ops *ops)
+{
+	struct msi_irqs *msi;
+
+	msi = kzalloc(sizeof(struct msi_irqs), GFP_KERNEL);
+	if (!msi)
+		return NULL;
+
+	INIT_LIST_HEAD(&msi->msi_list);
+	msi->data = data;
+	msi->ops = ops;
+	return msi;
+}
+EXPORT_SYMBOL(alloc_msi_irqs);
+
+struct msi_desc *alloc_msi_entry(struct msi_irqs *msi)
+{
+	struct msi_desc *desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return NULL;
+
+	INIT_LIST_HEAD(&desc->list);
+	desc->msi = msi;
+
+	return desc;
+}
+EXPORT_SYMBOL(alloc_msi_entry);
+
+static void msi_set_intx(struct msi_irqs *msi, int flag)
+{
+	if (!msi || !msi->ops || !msi->ops->msi_set_intx)
+		return;
+	msi->ops->msi_set_intx(msi, flag);
+}
+
+void msi_shutdown(struct msi_irqs *msi)
+{
+	u32 mask;
+	struct msi_desc *desc;
+
+	if (!msi || !msi->msi_enabled)
+		return;
+
+	BUG_ON(list_empty(&msi->msi_list));
+
+	desc = list_first_entry(&msi->msi_list, struct msi_desc, list);
+	msi_set_enable(msi, 0, MSI_TYPE);
+	msi_set_intx(msi, 1);
+	msi->msi_enabled = 0;
+
+	mask = msi_mask(desc->msi_attrib.multi_cap);
+	arch_msi_mask_irq(desc, mask, ~mask);
+}
+
+void msix_shutdown(struct msi_irqs *msi)
+{
+	struct msi_desc *entry;
+
+	if (!msi || !msi->msix_enabled)
+		return;
+
+	list_for_each_entry(entry, &msi->msi_list, list)
+		arch_msix_mask_irq(entry, 1);
+
+	msi_set_enable(msi, 0, MSIX_TYPE);
+	msi_set_intx(msi, 1);
+	msi->msix_enabled = 0;
+}
+
+static struct msi_desc * msi_setup_entry(struct msi_irqs *msi)
+{
+	struct msi_desc *entry;
+	
+	entry = alloc_msi_entry(msi);
+	if (!entry)
+		return NULL;
+
+	entry->msi_attrib.is_msix	= 0;
+	entry->msi_attrib.entry_nr	= 0;
+
+	if (!msi->ops || !msi->ops->msi_setup_entry) {
+		kfree(entry);
+		return NULL;
+	}
+
+	msi->ops->msi_setup_entry(msi, entry);
+	return entry;
+}
+
+static int msix_setup_entries(struct msi_irqs *msi, void __iomem *base,
+			      struct msix_entry *entries, int nvec)
+{
+	struct msi_desc *entry;
+	int i;
+
+	for (i = 0; i < nvec; i++) {
+		entry = alloc_msi_entry(msi);
+		if (!entry) {
+			if (!i)
+				iounmap(base);
+			else
+				free_msi_irqs(msi);
+			/* No enough memory. Don't try again */
+			return -ENOMEM;
+		}
+
+		entry->msi_attrib.is_msix	= 1;
+		entry->msi_attrib.is_64		= 1;
+		entry->msi_attrib.entry_nr	= entries[i].entry;
+		entry->mask_base		= base;
+		
+		list_add_tail(&entry->list, &msi->msi_list);
+	}
+
+	if (msi->ops && msi->ops->msix_setup_entries)
+		return msi->ops->msix_setup_entries(msi, entries);
+
+	return 0;
+}
+
+/**
+ * msi_capability_init - configure device's MSI capability structure
+ * @msi: pointer to the msi_irqs data structure of MSI device function
+ * @nvec: number of interrupts to allocate
+ *
+ * Setup the MSI capability structure of the device with the requested
+ * number of interrupts.  A return value of zero indicates the successful
+ * setup of an entry with the new MSI irq.  A negative return value indicates
+ * an error, and a positive return value indicates the number of interrupts
+ * which could have been allocated.
+ */
+int msi_capability_init(struct msi_irqs *msi, int nvec)
+{
+	struct msi_desc *entry;
+	int ret;
+	unsigned mask;
+
+	msi_set_enable(msi, 0, MSI_TYPE);	/* Disable MSI during set up */
+
+	/* MSI Entry Initialization */
+	entry = msi_setup_entry(msi);
+	if (!entry)
+		return -ENOMEM;
+
+	/* All MSIs are unmasked by default, Mask them all */
+	mask = msi_mask(entry->msi_attrib.multi_cap);
+	msi_mask_irq(entry, mask, mask);
+
+	/* Configure MSI capability structure */
+	ret = arch_setup_msi_irqs(msi, nvec, MSI_TYPE);
+	if (ret)
+		goto err;
+
+	/* Set MSI enabled bits	 */
+	msi_set_intx(msi, 0);
+	msi_set_enable(msi, 1, MSI_TYPE);
+	msi->msi_enabled = 1;
+
+	return 0;
+
+err:
+	msi_mask_irq(entry, mask, ~mask);
+	free_msi_irqs(msi);
+	return ret;
+}
+
+static void msix_program_entries(struct msi_irqs *msi,
+				 struct msix_entry *entries)
+{
+	struct msi_desc *entry;
+	int i = 0;
+
+	list_for_each_entry(entry, &msi->msi_list, list) {
+		entries[i].vector = entry->irq;
+		irq_set_msi_desc(entry->irq, entry);
+		i++;
+	}
+}
+
+/**
+ * msix_capability_init - configure device's MSI-X capability
+ * @dev: pointer to the pci_dev data structure of MSI-X device function
+ * @entries: pointer to an array of struct msix_entry entries
+ * @nvec: number of @entries
+ *
+ * Setup the MSI-X capability structure of device function with a
+ * single MSI-X irq. A return of zero indicates the successful setup of
+ * requested MSI-X entries with allocated irqs or non-zero for otherwise.
+ **/
+int msix_capability_init(struct msi_irqs *msi, void __iomem *base,
+				struct msix_entry *entries, int nvec)
+{
+	int ret;
+
+	/* Ensure MSI-X is disabled while it is set up */
+	msi_set_enable(msi, 0, MSIX_TYPE);
+
+	ret = msix_setup_entries(msi, base, entries, nvec);
+	if (ret)
+		return ret;
+
+	ret = arch_setup_msi_irqs(msi, nvec, MSIX_TYPE);
+	if (ret)
+		goto out_avail;
+
+	msix_program_entries(msi, entries);
+
+	/* Set MSI-X enabled bits and unmask the function */
+	msi_set_intx(msi, 0);
+	msi->msix_enabled = 1;
+
+	msi_set_enable(msi, 1, MSIX_TYPE);
+
+	return 0;
+
+out_avail:
+	if (ret < 0) {
+		/*
+		 * If we had some success, report the number of irqs
+		 * we succeeded in setting up.
+		 */
+		struct msi_desc *entry;
+		int avail = 0;
+
+		list_for_each_entry(entry, &msi->msi_list, list) {
+			if (entry->irq != 0)
+				avail++;
+		}
+		if (avail != 0)
+			ret = avail;
+	}
+
+	free_msi_irqs(msi);
+
+	return ret;
+}
+
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 893503f..1a10488 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -2,10 +2,10 @@
 # PCI configuration
 #
 config PCI_MSI
-	bool "Message Signaled Interrupts (MSI and MSI-X)"
-	depends on PCI
+	bool "PCI Message Signaled Interrupts (MSI and MSI-X)"
+	depends on PCI && MSI
 	help
-	   This allows device drivers to enable MSI (Message Signaled
+	   This allows PCI device drivers to enable MSI (Message Signaled
 	   Interrupts).  Message Signaled Interrupts enable a device to
 	   generate an interrupt using an inbound Memory Write on its
 	   PCI bus instead of asserting a device IRQ pin.
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index f0c5989..df7223c 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -26,121 +26,8 @@ static int pci_msi_enable = 1;
 
 #define msix_table_size(flags)	((flags & PCI_MSIX_FLAGS_QSIZE) + 1)
 
-
-/* Arch hooks */
-
-int __weak arch_setup_msi_irq(struct msi_irqs *msi, struct msi_desc *desc)
-{
-	struct pci_dev *dev = msi->data; //TO BE DONE: rework msi_chip to support Non-PCI
-	struct msi_chip *chip = dev->bus->msi;
-	int err;
-
-	if (!chip || !chip->setup_irq)
-		return -EINVAL;
-
-	err = chip->setup_irq(chip, dev, desc);
-	if (err < 0)
-		return err;
-
-	irq_set_chip_data(desc->irq, chip);
-
-	return 0;
-}
-
-void __weak arch_teardown_msi_irq(unsigned int irq)
-{
-	struct msi_chip *chip = irq_get_chip_data(irq);
-
-	if (!chip || !chip->teardown_irq)
-		return;
-
-	chip->teardown_irq(chip, irq);
-}
-
-int __weak arch_msi_check_device(struct msi_irqs *msi, int nvec, int type)
-{
-	struct pci_dev *dev = msi->data; //TO BE DONE: rework msi_chip to support Non-PCI
-	struct msi_chip *chip = dev->bus->msi;
-
-	if (!chip || !chip->check_device)
-		return 0;
-
-	return chip->check_device(chip, dev, nvec, type);
-}
-
-int __weak arch_setup_msi_irqs(struct msi_irqs *msi, int nvec, int type)
-{
-	struct msi_desc *entry;
-	int ret;
-
-	/*
-	 * If an architecture wants to support multiple MSI, it needs to
-	 * override arch_setup_msi_irqs()
-	 */
-	if (type == MSI_TYPE && nvec > 1)
-		return 1;
-
-	list_for_each_entry(entry, &msi->msi_list, list) {
-		ret = arch_setup_msi_irq(msi, entry);
-		if (ret < 0)
-			return ret;
-		if (ret > 0)
-			return -ENOSPC;
-	}
-
-	return 0;
-}
-
-/*
- * We have a default implementation available as a separate non-weak
- * function, as it is used by the Xen x86 PCI code
- */
-void default_teardown_msi_irqs(struct msi_irqs *msi)
-{
-	struct msi_desc *entry;
-
-	list_for_each_entry(entry, &msi->msi_list, list) {
-		int i, nvec;
-		if (entry->irq == 0)
-			continue;
-		if (entry->nvec_used)
-			nvec = entry->nvec_used;
-		else
-			nvec = 1 << entry->msi_attrib.multiple;
-		for (i = 0; i < nvec; i++)
-			arch_teardown_msi_irq(entry->irq + i);
-	}
-}
-
-void __weak arch_teardown_msi_irqs(struct msi_irqs *msi)
-{
-	return default_teardown_msi_irqs(msi);
-}
-
-static void default_restore_msi_irq(struct msi_irqs *msi, int irq)
-{
-	struct msi_desc *entry;
-
-	entry = NULL;
-	if (msi->msix_enabled) {
-		list_for_each_entry(entry, &msi->msi_list, list) {
-			if (irq == entry->irq)
-				break;
-		}
-	} else if (msi->msi_enabled)  {
-		entry = irq_get_msi_desc(irq);
-	}
-
-	if (entry)
-		write_msi_msg(irq, &entry->msg);
-}
-
-void __weak arch_restore_msi_irqs(struct msi_irqs *msi)
-{
-	return default_restore_msi_irqs(msi);
-}
-
-static void msix_clear_and_set_ctrl(struct pci_dev *dev, u16 clear, u16 set)
+static void msix_clear_and_set_ctrl(struct pci_dev *dev, 
+		u16 clear, u16 set)
 {
 	u16 ctrl;
 
@@ -150,7 +37,7 @@ static void msix_clear_and_set_ctrl(struct pci_dev *dev, u16 clear, u16 set)
 	pci_write_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, ctrl);
 }
 
-static void msi_set_enable(struct msi_irqs *msi, int enable, int type)
+static void pci_msi_set_enable(struct msi_irqs *msi, int enable, int type)
 {
 	u16 control;
 	struct pci_dev *dev = msi->data;
@@ -169,21 +56,13 @@ static void msi_set_enable(struct msi_irqs *msi, int enable, int type)
 	}
 }
 
-static inline __attribute_const__ u32 msi_mask(unsigned x)
-{
-	/* Don't shift by >= width of type */
-	if (x >= 5)
-		return 0xffffffff;
-	return (1 << (1 << x)) - 1;
-}
-
 /*
  * PCI 2.3 does not specify mask bits for each MSI interrupt.  Attempting to
  * mask all MSI interrupts by clearing the MSI enable bit does not work
  * reliably as devices without an INTx disable bit will then generate a
  * level IRQ which will never be cleared.
  */
-u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+u32 pci_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
 	struct pci_dev *dev = desc->msi->data;
 	u32 mask_bits = desc->masked;
@@ -198,16 +77,6 @@ u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 	return mask_bits;
 }
 
-__weak u32 arch_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
-{
-	return default_msi_mask_irq(desc, mask, flag);
-}
-
-static void msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
-{
-	desc->masked = arch_msi_mask_irq(desc, mask, flag);
-}
-
 /*
  * This internal function does not flush PCI writes to the device.
  * All users must ensure that they read from the device before either
@@ -215,7 +84,7 @@ static void msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
  * file.  This saves a few milliseconds when initialising devices with lots
  * of MSI-X interrupts.
  */
-u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag)
+u32 pci_msix_mask_irq(struct msi_desc *desc, u32 flag)
 {
 	u32 mask_bits = desc->masked;
 	unsigned offset = desc->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
@@ -228,40 +97,7 @@ u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag)
 	return mask_bits;
 }
 
-__weak u32 arch_msix_mask_irq(struct msi_desc *desc, u32 flag)
-{
-	return default_msix_mask_irq(desc, flag);
-}
-
-static void msix_mask_irq(struct msi_desc *desc, u32 flag)
-{
-	desc->masked = arch_msix_mask_irq(desc, flag);
-}
-
-static void msi_set_mask_bit(struct irq_data *data, u32 flag)
-{
-	struct msi_desc *desc = irq_data_get_msi(data);
-
-	if (desc->msi_attrib.is_msix) {
-		msix_mask_irq(desc, flag);
-		readl(desc->mask_base);		/* Flush write to device */
-	} else {
-		unsigned offset = data->irq - desc->irq;
-		msi_mask_irq(desc, 1 << offset, flag << offset);
-	}
-}
-
-void mask_msi_irq(struct irq_data *data)
-{
-	msi_set_mask_bit(data, 1);
-}
-
-void unmask_msi_irq(struct irq_data *data)
-{
-	msi_set_mask_bit(data, 0);
-}
-
-static void msix_set_all_mask(struct msi_irqs *msi, int flag)
+static void pci_msix_set_all_mask(struct msi_irqs *msi, int flag)
 {
 	struct pci_dev *dev = msi->data;
 
@@ -271,16 +107,7 @@ static void msix_set_all_mask(struct msi_irqs *msi, int flag)
 		msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
 }
 
-void default_restore_msi_irqs(struct msi_irqs *msi)
-{
-	struct msi_desc *entry;
-
-	list_for_each_entry(entry, &msi->msi_list, list) {
-		default_restore_msi_irq(msi, entry->irq);
-	}
-}
-
-void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+void pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	struct pci_dev *dev = entry->msi->data;
 
@@ -311,31 +138,7 @@ void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 	}
 }
 
-void read_msi_msg(unsigned int irq, struct msi_msg *msg)
-{
-	struct msi_desc *entry = irq_get_msi_desc(irq);
-
-	__read_msi_msg(entry, msg);
-}
-
-void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
-{
-	/* Assert that the cache is valid, assuming that
-	 * valid messages are not all-zeroes. */
-	BUG_ON(!(entry->msg.address_hi | entry->msg.address_lo |
-		 entry->msg.data));
-
-	*msg = entry->msg;
-}
-
-void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
-{
-	struct msi_desc *entry = irq_get_msi_desc(irq);
-
-	__get_cached_msi_msg(entry, msg);
-}
-
-void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+void pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	struct pci_dev *dev = entry->msi->data;
 
@@ -373,13 +176,6 @@ void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 	entry->msg = *msg;
 }
 
-void write_msi_msg(unsigned int irq, struct msi_msg *msg)
-{
-	struct msi_desc *entry = irq_get_msi_desc(irq);
-
-	__write_msi_msg(entry, msg);
-}
-
 static void free_msi_sysfs(struct pci_dev *dev)
 {
 	struct attribute **msi_attrs;
@@ -403,58 +199,6 @@ static void free_msi_sysfs(struct pci_dev *dev)
 	}
 }
 
-static void free_msi_irqs(struct msi_irqs *msi)
-{
-	struct msi_desc *entry, *tmp;
-
-	list_for_each_entry(entry, &msi->msi_list, list) {
-		int i, nvec;
-		if (!entry->irq)
-			continue;
-		if (entry->nvec_used)
-			nvec = entry->nvec_used;
-		else
-			nvec = 1 << entry->msi_attrib.multiple;
-		for (i = 0; i < nvec; i++)
-			BUG_ON(irq_has_action(entry->irq + i));
-	}
-
-	arch_teardown_msi_irqs(msi);
-
-	list_for_each_entry_safe(entry, tmp, &msi->msi_list, list) {
-		if (entry->msi_attrib.is_msix) {
-			if (list_is_last(&entry->list, &msi->msi_list))
-				iounmap(entry->mask_base);
-		}
-
-		/*
-		 * Its possible that we get into this path
-		 * When populate_msi_sysfs fails, which means the entries
-		 * were not registered with sysfs.  In that case don't
-		 * unregister them.
-		 */
-		if (entry->kobj.parent) {
-			kobject_del(&entry->kobj);
-			kobject_put(&entry->kobj);
-		}
-
-		list_del(&entry->list);
-		kfree(entry);
-	}
-}
-
-static struct msi_desc *alloc_msi_entry(struct msi_irqs *msi)
-{
-	struct msi_desc *desc = kzalloc(sizeof(*desc), GFP_KERNEL);
-	if (!desc)
-		return NULL;
-
-	INIT_LIST_HEAD(&desc->list);
-	desc->msi = msi;
-
-	return desc;
-}
-
 static void pci_intx_for_msi(struct msi_irqs *msi, int enable)
 {
 	struct pci_dev *dev = msi->data;
@@ -474,7 +218,7 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 	entry = irq_get_msi_desc(dev->irq);
 
 	pci_intx_for_msi(dev->msi, 0);
-	msi_set_enable(dev->msi, 0, MSI_TYPE);
+	pci_msi_set_enable(dev->msi, 0, MSI_TYPE);
 	arch_restore_msi_irqs(dev->msi);
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
@@ -496,13 +240,13 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 
 	/* route the table */
 	pci_intx_for_msi(msi, 0);
-	msi_set_enable(msi, 1, MSIX_TYPE);
-	msix_set_all_mask(msi, 1);
+	pci_msi_set_enable(msi, 1, MSIX_TYPE);
+	pci_msix_set_all_mask(msi, 1);
 	arch_restore_msi_irqs(msi);
 	list_for_each_entry(entry, &msi->msi_list, list) 
 		msix_mask_irq(entry, entry->masked);
 
-	msix_set_all_mask(msi, 0);
+	pci_msix_set_all_mask(msi, 0);
 }
 
 void pci_restore_msi_state(struct pci_dev *dev)
@@ -606,22 +350,16 @@ error_attrs:
 	return ret;
 }
 
-static struct msi_desc *msi_setup_entry(struct msi_irqs *msi)
+static struct msi_desc *pci_msi_setup_entry(struct msi_irqs *msi, 
+		struct msi_desc *entry)
 {
 	u16 control;
-	struct msi_desc *entry;
 	struct pci_dev *dev = msi->data;
 
 	/* MSI Entry Initialization */
-	entry = alloc_msi_entry(msi);
-	if (!entry)
-		return NULL;
-
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
 
-	entry->msi_attrib.is_msix	= 0;
 	entry->msi_attrib.is_64		= !!(control & PCI_MSI_FLAGS_64BIT);
-	entry->msi_attrib.entry_nr	= 0;
 	entry->msi_attrib.maskbit	= !!(control & PCI_MSI_FLAGS_MASKBIT);
 	entry->msi_attrib.default_irq	= dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.multi_cap	= (control & PCI_MSI_FLAGS_QMASK) >> 1;
@@ -638,52 +376,6 @@ static struct msi_desc *msi_setup_entry(struct msi_irqs *msi)
 	return entry;
 }
 
-/**
- * msi_capability_init - configure device's MSI capability structure
- * @dev: pointer to the pci_dev data structure of MSI device function
- * @nvec: number of interrupts to allocate
- *
- * Setup the MSI capability structure of the device with the requested
- * number of interrupts.  A return value of zero indicates the successful
- * setup of an entry with the new MSI irq.  A negative return value indicates
- * an error, and a positive return value indicates the number of interrupts
- * which could have been allocated.
- */
-static int msi_capability_init(struct msi_irqs *msi, int nvec)
-{
-	struct msi_desc *entry;
-	int ret;
-	unsigned mask;
-
-	msi_set_enable(msi, 0, MSI_TYPE);	/* Disable MSI during set up */
-
-	entry = msi_setup_entry(msi);
-	if (!entry)
-		return -ENOMEM;
-
-	/* All MSIs are unmasked by default, Mask them all */
-	mask = msi_mask(entry->msi_attrib.multi_cap);
-	msi_mask_irq(entry, mask, mask);
-
-	list_add_tail(&entry->list, &msi->msi_list);
-
-	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(msi, nvec, MSI_TYPE);
-	if (ret)
-		goto err;
-
-	/* Set MSI enabled bits	 */
-	pci_intx_for_msi(msi, 0);
-	msi_set_enable(msi, 1, MSI_TYPE);
-	msi->msi_enabled = 1;
-	return 0;
-
-err:
-	msi_mask_irq(entry, mask, ~mask);
-	free_msi_irqs(msi);
-	return ret;
-}
-
 static void __iomem *msix_map_region(struct pci_dev *dev, unsigned nr_entries)
 {
 	resource_size_t phys_addr;
@@ -699,28 +391,19 @@ static void __iomem *msix_map_region(struct pci_dev *dev, unsigned nr_entries)
 	return ioremap_nocache(phys_addr, nr_entries * PCI_MSIX_ENTRY_SIZE);
 }
 
-static int msix_setup_entries(struct msi_irqs *msi, void __iomem *base,
-			      struct msix_entry *entries, int nvec)
+static int pci_msix_setup_entries(struct msi_irqs *msi, struct msix_entry *entries)
 {
+	int offset, i = 0;
 	struct msi_desc *entry;
-	int i, offset;
 	struct pci_dev *dev = msi->data;
 
-	for (i = 0; i < nvec; i++) {
-		entry = alloc_msi_entry(msi);
-		if (!entry) {
-			if (!i)
-				iounmap(base);
-			else
-				free_msi_irqs(msi);
-			/* No enough memory. Don't try again */
-			return -ENOMEM;
-		}
 
-		entry->msi_attrib.is_msix	= 1;
-		entry->msi_attrib.is_64		= 1;
-		entry->msi_attrib.entry_nr	= entries[i].entry;
-		entry->mask_base		= base;
+	list_for_each_entry(entry, &msi->msi_list, list) {
+		/*
+		 * Some devices require MSI-X to be enabled before we can touch the
+		 * MSI-X registers.  We need to mask all the vectors to prevent
+		 * interrupts coming in before they're fully set up.
+		 */
 
 		msix_clear_and_set_ctrl(dev, 0, 
 				PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE);
@@ -730,87 +413,10 @@ static int msix_setup_entries(struct msi_irqs *msi, void __iomem *base,
 		msix_mask_irq(entry, 1);
 		msix_clear_and_set_ctrl(dev, 
 				PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE, 0);
-
-		list_add_tail(&entry->list, &msi->msi_list);
-	}
-
-	return 0;
-}
-
-static void msix_program_entries(struct msi_irqs *msi,
-				 struct msix_entry *entries)
-{
-	struct msi_desc *entry;
-	int i = 0;
-
-	list_for_each_entry(entry, &msi->msi_list, list) {
-		entries[i].vector = entry->irq;
-		irq_set_msi_desc(entry->irq, entry);
 		i++;
 	}
-}
-
-/**
- * msix_capability_init - configure device's MSI-X capability
- * @dev: pointer to the pci_dev data structure of MSI-X device function
- * @entries: pointer to an array of struct msix_entry entries
- * @nvec: number of @entries
- *
- * Setup the MSI-X capability structure of device function with a
- * single MSI-X irq. A return of zero indicates the successful setup of
- * requested MSI-X entries with allocated irqs or non-zero for otherwise.
- **/
-static int msix_capability_init(struct msi_irqs *msi, void __iomem *base,
-				struct msix_entry *entries, int nvec)
-{
-	int ret;
-
-	/* Ensure MSI-X is disabled while it is set up */
-	msi_set_enable(msi, 0, MSIX_TYPE);
-
-	ret = msix_setup_entries(msi, base, entries, nvec);
-	if (ret)
-		return ret;
-
-	ret = arch_setup_msi_irqs(msi, nvec, MSIX_TYPE);
-	if (ret)
-		goto out_avail;
-
-	/*
-	 * Some devices require MSI-X to be enabled before we can touch the
-	 * MSI-X registers.  We need to mask all the vectors to prevent
-	 * interrupts coming in before they're fully set up.
-	 */
-	msix_program_entries(msi, entries);
-
-	/* Set MSI-X enabled bits and unmask the function */
-	pci_intx_for_msi(msi, 0);
-	msi->msix_enabled = 1;
-
-	msi_set_enable(msi, 1, MSIX_TYPE);
 
 	return 0;
-
-out_avail:
-	if (ret < 0) {
-		/*
-		 * If we had some success, report the number of irqs
-		 * we succeeded in setting up.
-		 */
-		struct msi_desc *entry;
-		int avail = 0;
-
-		list_for_each_entry(entry, &msi->msi_list, list) {
-			if (entry->irq != 0)
-				avail++;
-		}
-		if (avail != 0)
-			ret = avail;
-	}
-
-	free_msi_irqs(msi);
-
-	return ret;
 }
 
 /**
@@ -886,25 +492,14 @@ EXPORT_SYMBOL(pci_msi_vec_count);
 void pci_msi_shutdown(struct pci_dev *dev)
 {
 	struct msi_desc *desc;
-	u32 mask;
 
 	if (!pci_msi_enable || !dev || 
 			!pci_dev_msi_enabled(dev, MSI_TYPE))
 		return;
 
-	BUG_ON(list_empty(&dev->msi->msi_list));
-	desc = list_first_entry(&dev->msi->msi_list, struct msi_desc, list);
-
-	msi_set_enable(dev->msi, 0, MSI_TYPE);
-	pci_intx_for_msi(dev->msi, 1);
-	dev->msi->msi_enabled = 0;
-
-	/* Return the device with MSI unmasked as initial states */
-	mask = msi_mask(desc->msi_attrib.multi_cap);
-	/* Keep cached state to be restored */
-	arch_msi_mask_irq(desc, mask, ~mask);
-
+	msi_shutdown(dev->msi);
 	/* Restore dev->irq to its default pin-assertion irq */
+	desc = list_first_entry(&dev->msi->msi_list, struct msi_desc, list);
 	dev->irq = desc->msi_attrib.default_irq;
 }
 
@@ -1014,20 +609,10 @@ EXPORT_SYMBOL(pci_enable_msix);
 
 void pci_msix_shutdown(struct pci_dev *dev)
 {
-	struct msi_desc *entry;
-
-	if (!pci_msi_enable || !dev || !pci_dev_msi_enabled(dev, MSIX_TYPE))
+	if (!pci_msi_enable || !dev)
 		return;
 
-	/* Return the device with MSI-X masked as initial states */
-	list_for_each_entry(entry, &dev->msi->msi_list, list) {
-		/* Keep cached states to be restored */
-		arch_msix_mask_irq(entry, 1);
-	}
-
-	msi_set_enable(dev->msi, 0, MSIX_TYPE);
-	pci_intx_for_msi(dev->msi, 1);
-	dev->msi->msix_enabled = 0;
+	msix_shutdown(dev->msi);
 }
 
 void pci_disable_msix(struct pci_dev *dev)
@@ -1060,30 +645,16 @@ int pci_msi_enabled(void)
 EXPORT_SYMBOL(pci_msi_enabled);
 
 static struct msi_ops pci_msi = {
-	.msi_set_enable = msi_set_enable,
-	.msi_setup_entry = msi_setup_entry,
-	.msix_setup_entries = msix_setup_entries,
-	.msi_mask_irq = default_msi_mask_irq,
-	.msix_mask_irq = default_msix_mask_irq,
-	.msi_read_message = __read_msi_msg,
-	.msi_write_message = __write_msi_msg,
+	.msi_set_enable = pci_msi_set_enable,
+	.msi_setup_entry = pci_msi_setup_entry,
+	.msix_setup_entries = pci_msix_setup_entries,
+	.msi_mask_irq = pci_msi_mask_irq,
+	.msix_mask_irq = pci_msix_mask_irq,
+	.msi_read_message = pci_read_msi_msg,
+	.msi_write_message = pci_write_msi_msg,
 	.msi_set_intx =  pci_intx_for_msi,
 };
 
-struct msi_irqs *alloc_msi_irqs(void *data, struct msi_ops *ops)
-{
-	struct msi_irqs *msi;
-
-	msi = kzalloc(sizeof(struct msi_irqs), GFP_KERNEL);
-	if (!msi)
-		return NULL;
-
-	INIT_LIST_HEAD(&msi->msi_list);
-	msi->data = data;
-	msi->ops = ops;
-	return msi;
-}
-
 void pci_msi_init_pci_dev(struct pci_dev *dev)
 {
 	/* Disable the msi hardware to avoid screaming interrupts
@@ -1100,10 +671,10 @@ void pci_msi_init_pci_dev(struct pci_dev *dev)
 			
 		dev->msi->node = dev_to_node(&dev->dev);
 		if (dev->msi_cap) 
-			msi_set_enable(dev->msi, 0, MSI_TYPE);
+			pci_msi_set_enable(dev->msi, 0, MSI_TYPE);
 
 		if (dev->msix_cap) 
-			msi_set_enable(dev->msi, 0, MSIX_TYPE);
+			pci_msi_set_enable(dev->msi, 0, MSIX_TYPE);
 	}
 }
 
@@ -1224,4 +795,3 @@ int pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
 }
 EXPORT_SYMBOL(pci_enable_msix_range);
 
-
diff --git a/include/linux/msi.h b/include/linux/msi.h
index fc8f3e8..87ed0dd 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -28,9 +28,9 @@ struct msix_entry {
 
 struct msi_ops {
 	void (*msi_set_enable)(struct msi_irqs *msi, int enable, int type);
-	struct msi_desc *(*msi_setup_entry)(struct msi_irqs *msi);
-	int (*msix_setup_entries)(struct msi_irqs *msi, void __iomem *base,
-			struct msix_entry *entries, int nvec);
+	struct msi_desc *(*msi_setup_entry)(struct msi_irqs *msi, 
+			struct msi_desc *entry);
+	int (*msix_setup_entries)(struct msi_irqs *msi, struct msix_entry *entries);
 	u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
 	u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
 	void (*msi_read_message)(struct msi_desc *desc, struct msi_msg *msg);
@@ -49,6 +49,18 @@ void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
 void write_msi_msg(unsigned int irq, struct msi_msg *msg);
+struct msi_desc *alloc_msi_entry(struct msi_irqs *msi);
+void msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
+void msix_mask_irq(struct msi_desc *desc, u32 flag);
+void msi_set_enable(struct msi_irqs *msi, int enable, int type);
+
+struct msi_irqs *alloc_msi_irqs(void *data, struct msi_ops *ops);
+
+void free_msi_irqs(struct msi_irqs *msi);
+
+int msi_capability_init(struct msi_irqs *msi, int nvec);
+int msix_capability_init(struct msi_irqs *msi, void __iomem *base, 
+		struct msix_entry *entries, int nvec);
 
 struct msi_desc {
 	struct {
@@ -89,12 +101,17 @@ int arch_setup_msi_irqs(struct msi_irqs *msi, int nvec, int type);
 void arch_teardown_msi_irqs(struct msi_irqs *msi);
 int arch_msi_check_device(struct msi_irqs *msi, int nvec, int type);
 void arch_restore_msi_irqs(struct msi_irqs *msi);
+u32 arch_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
+u32 arch_msix_mask_irq(struct msi_desc *desc, u32 flag);
 
 void default_teardown_msi_irqs(struct msi_irqs *msi);
 void default_restore_msi_irqs(struct msi_irqs *msi);
 u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
 u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag);
 
+void msi_shutdown(struct msi_irqs *msi);
+void msix_shutdown(struct msi_irqs *msi);
+
 #define MSI_TYPE	0x01
 #define MSIX_TYPE	0x02
 
@@ -111,4 +128,12 @@ struct msi_chip {
 			    int nvec, int type);
 };
 
+static inline __attribute_const__ u32 msi_mask(unsigned x)
+{
+	/* Don't shift by >= width of type */
+	if (x >= 5)
+		return 0xffffffff;
+	return (1 << (1 << x)) - 1;
+}
+
 #endif /* LINUX_MSI_H */
-- 
1.7.1

