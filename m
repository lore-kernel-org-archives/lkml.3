Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaLJJMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:12:51 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:1594 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaLJJMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:12:45 -0500
Message-ID: <54880E5C.1040007@huawei.com>
Date: Wed, 10 Dec 2014 17:11:56 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Marc Zyngier <marc.zyngier@arm.com>, Jiang Liu <jiang.liu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        "Yijing Wang" <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos> <546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com> <546B4F18.5060705@huawei.com> <alpine.DEB.2.11.1411181518310.3909@nanos> <546B5904.6020200@huawei.com> <8761ece85x.fsf@approximate.cambridge.arm.com> <546C1148.4080102@huawei.com> <alpine.DEB.2.11.1411191209400.3909@nanos>
In-Reply-To: <alpine.DEB.2.11.1411191209400.3909@nanos>
Content-Type: multipart/mixed;
	boundary="------------040304040304000607000002"
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------040304040304000607000002
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 2014/11/19 19:11, Thomas Gleixner wrote:

> On Wed, 19 Nov 2014, Yun Wu (Abel) wrote:
>> On 2014/11/19 1:21, Marc Zyngier wrote:
>>> This is why the framework gives you the opportunity to provide methods
>>> that:
>>> - compose the message
>>> - program the message into the device
>>>
>>> None of that has to be PCI specific, and gives you a clean
>>> abstraction. The framework only gives you a number of shortcuts for PCI
>>> MSI, because that's what most people care about.
>>>
>>
>> Indeed, and I never said Jiang's patches don't work, I was just thinking
>> that they were not that perfect.
> 
> But your magic extra layer of indirection is perfect? It's not, it
> just violates sane layering in order to support braindead hardware
> designs.
> 

Hi Thomas, Gerry and Marc,

I spent last two weeks implementing and testing my original idea about making
the sub domains generic, based on stacked domain feature. Now it comes real,
please see the attached patch.

With this patch applied, I think things will get easier.

For drivers of interrupt controllers, they need to implement:
a) struct irq_chip, gets associated in domain's map/alloc callback
b) struct irq_domain, with corresponding operations
c) create sub generic MBI domain of IRQ domain to deal with all MBI types.
This changes almost nothing of the current code.

For drivers of MBI-capable devices, they need to implement:
a) MBI operations, like mask/unmask or setting message.
This will remove current ugly arch-specific code by organizing the device
behavior into a generic structure used in generic MBI layer.

The MBI generic code will build the bridge between the two groups. So when a
new driver need to implement, either controller's or endpoint's, just code
the corresponding 'need' described above with no more work to do.

This patch (also with several other patches) is tested on Hisilicon ARM64 SoC,
with non PCI devices capable of message based interrupts. The PCI part is not
tested because it needs large refactoring work to do. So yes, the testing work
is not sufficient, but I think the patch is enough to present what I really
wanted to express. :)

A new term introduced by the patch named Message Based Interrupt (MBI) is used
for presenting the generic MSIs (which does help me avoid conflicting with the
existing code). Actually the new name is proposed by Marc several months ago,
suggesting that MSI implies too much about PCI. I think it's a good idea to use
MBI in generic code and make the MSI/MSI-x a wrapper of MBI inside the PCI core.
Anyway, naming is not the key point yet.

Finally, yes, my thoughts is not perfect, but I am just trying to make it better.

Best regards and thanks,
	Abel

--------------040304040304000607000002
Content-Type: text/plain; charset="gb18030";
	name="0001-MBI-initial-support-for-message-based-interrupts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-MBI-initial-support-for-message-based-interrupts.patch"

>From 64c5440f685440bb7d92ab716013f9f54f21bca2 Mon Sep 17 00:00:00 2001
From: Yun Wu <wuyun.wu@huawei.com>
Date: Wed, 10 Dec 2014 10:32:58 +0800
Subject: [PATCH] MBI: initial support for message based interrupts

This patch provides initial support for Message Based Interrupt (MBI),
which is a write from the device to a special address which causes an
interrupt to be received by the CPU.

MBI is a generic mechanism not specific to any architectures or any
subsystems. MSI/MSI-X defined in PCI specification are special MBIs.

Signed-off-by: Yun Wu <wuyun.wu@huawei.com>
---
 arch/arm64/Kconfig     |   1 +
 include/linux/device.h |   3 +
 include/linux/irq.h    |  22 ++++
 include/linux/mbi.h    |  95 ++++++++++++++++++
 kernel/irq/Kconfig     |   5 +
 kernel/irq/Makefile    |   1 +
 kernel/irq/chip.c      |  66 ++++++++++++
 kernel/irq/mbi.c       | 260 +++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 453 insertions(+)
 create mode 100644 include/linux/mbi.h
 create mode 100644 kernel/irq/mbi.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1f49c288..ef55541 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -13,6 +13,7 @@ config ARM64
 	select ARM_GIC
 	select AUDIT_ARCH_COMPAT_GENERIC
 	select ARM_GIC_V3
+	select MBI
 	select ARM_GIC_V3_ITS if PCI_MSI
 	select BUILDTIME_EXTABLE_SORT
 	select CLONE_BACKWARDS
diff --git a/include/linux/device.h b/include/linux/device.h
index ce1f2160..e0618c2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -715,6 +715,7 @@ struct acpi_dev_node {
  * 		gone away. This should be set by the allocator of the
  * 		device (i.e. the bus driver that discovered the device).
  * @iommu_group: IOMMU group the device belongs to.
+ * @mbi:	Pointer to the data of message based interrupts.
  *
  * @offline_disabled: If set, the device is permanently online.
  * @offline:	Set after successful invocation of bus type's .offline().
@@ -794,6 +795,8 @@ struct device {
 	void	(*release)(struct device *dev);
 	struct iommu_group	*iommu_group;
 
+	struct mbi_data		*mbi;
+
 	bool			offline_disabled:1;
 	bool			offline:1;
 };
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8badf34..92e25e6 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -28,6 +28,7 @@
 
 struct seq_file;
 struct module;
+struct mbi_msg;
 struct msi_msg;
 
 /*
@@ -120,6 +121,7 @@ enum {
 	IRQ_SET_MASK_OK_DONE,
 };
 
+struct mbi_desc;
 struct msi_desc;
 struct irq_domain;
 
@@ -139,6 +141,7 @@ struct irq_domain;
  * @handler_data:	per-IRQ data for the irq_chip methods
  * @chip_data:		platform-specific per-chip private data for the chip
  *			methods, to allow shared chip implementations
+ * @mbi_desc:		MBI descriptor
  * @msi_desc:		MSI descriptor
  * @affinity:		IRQ affinity on SMP
  *
@@ -159,6 +162,7 @@ struct irq_data {
 #endif
 	void			*handler_data;
 	void			*chip_data;
+	struct mbi_desc		*mbi_desc;
 	struct msi_desc		*msi_desc;
 	cpumask_var_t		affinity;
 };
@@ -323,6 +327,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  *				irq_request_resources
  * @irq_compose_msi_msg:	optional to compose message content for MSI
  * @irq_write_msi_msg:	optional to write message content for MSI
+ * @irq_compose_msg:	optional to write message content for MBI
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -362,6 +367,8 @@ struct irq_chip {
 	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 
+	void		(*irq_compose_msg)(struct irq_data *data, struct mbi_msg *msg);
+
 	unsigned long	flags;
 };
 
@@ -567,10 +574,14 @@ extern int irq_set_chip(unsigned int irq, struct irq_chip *chip);
 extern int irq_set_handler_data(unsigned int irq, void *data);
 extern int irq_set_chip_data(unsigned int irq, void *data);
 extern int irq_set_irq_type(unsigned int irq, unsigned int type);
+extern int irq_set_mbi_desc(unsigned int irq, struct mbi_desc *entry);
+extern int irq_set_mbi_desc_range(unsigned int irq, struct mbi_desc *entry,
+				  unsigned int count);
 extern int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry);
 extern int irq_set_msi_desc_off(unsigned int irq_base, unsigned int irq_offset,
 				struct msi_desc *entry);
 extern struct irq_data *irq_get_irq_data(unsigned int irq);
+extern int irq_compose_mbi_msg(struct irq_data *data, struct mbi_msg *msg);
 
 static inline struct irq_chip *irq_get_chip(unsigned int irq)
 {
@@ -605,6 +616,17 @@ static inline void *irq_data_get_irq_handler_data(struct irq_data *d)
 	return d->handler_data;
 }
 
+static inline struct mbi_desc *irq_get_mbi_desc(unsigned int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	return d ? d->mbi_desc : NULL;
+}
+
+static inline struct mbi_desc *irq_data_get_mbi(struct irq_data *d)
+{
+	return d->mbi_desc;
+}
+
 static inline struct msi_desc *irq_get_msi_desc(unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
diff --git a/include/linux/mbi.h b/include/linux/mbi.h
new file mode 100644
index 0000000..075a453
--- /dev/null
+++ b/include/linux/mbi.h
@@ -0,0 +1,95 @@
+#ifndef _LINUX_MBI_H
+#define _LINUX_MBI_H
+
+#include <linux/device.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+
+struct mbi_data;
+
+/**
+ * struct mbi_msg - MBI message descriptor
+ *
+ * @address_lo:	lower 32bit value of MBI address register
+ * @address_hi:	higher 32bit value of MBI address register
+ * @data:	data value of MBI data register
+ */
+struct mbi_msg {
+	u32	address_lo;
+	u32	address_hi;
+	u32	data;
+};
+
+/**
+ * struct mbi_desc - Message Based Interrupt (MBI) descriptor
+ *
+ * @entry:	element in device MBI list
+ * @mbi:	the device MBI data
+ * @data:	message-specific unique data to identify an MBI
+ * @msg:	message registers info of the MBI
+ * @irq:	base linux interrupt number of the MBI
+ * @nvec:	number of interrupts supported
+ */
+struct mbi_desc {
+	struct list_head	entry;
+	struct mbi_data		*mbi;
+	void			*data;
+	struct mbi_msg		msg;
+	unsigned int		irq;
+	unsigned int		nvec;
+};
+
+/**
+ * struct mbi_ops - MBI functions of MBI-capable device
+ *
+ * @write_msg:	write message registers for an MBI
+ * @mask_irq:	mask an MBI interrupt
+ * @unmask_irq:	unmask an MBI interrupt
+ */
+struct mbi_ops {
+	void	(*write_msg)(struct mbi_desc *desc, struct mbi_msg *msg);
+	void	(*mask_irq)(struct mbi_desc *desc, int id);
+	void	(*unmask_irq)(struct mbi_desc *desc, int id);
+};
+
+/**
+ * struct mbi_data - MBI information of a device
+ *
+ * @dev:	the device owned the MBI data
+ * @ops:	operations of the MBI-capable device
+ * @lock:	spinlock for @mbi_list
+ * @mbi_list:	list of MBI descriptors
+ *
+ * One MBI data for each MBI-capable device, holding device specific
+ * information.
+ */
+struct mbi_data {
+	struct device		*dev;
+	struct mbi_ops		*ops;
+	raw_spinlock_t		lock;
+	struct list_head	mbi_list;
+};
+
+/**
+ * struct mbi_domain_info - Infomation prepared for MBI domain
+ *
+ * @dev:	the device owned the MBI data
+ * @ops:	operations of the MBI-capable device
+ * @data:	message-specific data to identify an MBI
+ * @nvec:	maximum number of supported interrupts by the device
+ *
+ * The MBI-capable devices should provide this to their parent MBI
+ * domains when initializing MBIs.
+ */
+struct mbi_domain_info {
+	struct device		*dev;
+	struct mbi_ops		*ops;
+	void			*data;
+	unsigned int		nvec;
+};
+
+/* Create hierarchy MBI domain for interrupt controllers */
+struct irq_domain *mbi_create_irq_domain(struct device_node *of_node,
+					 struct irq_domain *parent);
+
+#endif /* _LINUX_MBI_H */
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 9a76e3b..d1071cf 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -60,6 +60,11 @@ config IRQ_DOMAIN_HIERARCHY
 	bool
 	select IRQ_DOMAIN
 
+# Support for Message Based Interrupt (MBI)
+config MBI
+	bool "Support Message Based Interrupt (MBI)"
+	select IRQ_DOMAIN_HIERARCHY
+
 # Generic MSI interrupt support
 config GENERIC_MSI_IRQ
 	bool
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index d121235..1e5f4b8 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_IRQ_DOMAIN) += irqdomain.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
+obj-$(CONFIG_MBI) += mbi.o
 obj-$(CONFIG_GENERIC_MSI_IRQ) += msi.o
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6f1c7a5..756d277 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -90,6 +90,45 @@ int irq_set_handler_data(unsigned int irq, void *data)
 EXPORT_SYMBOL(irq_set_handler_data);
 
 /**
+ *	irq_set_mbi_desc - set MBI descriptor for an irq
+ *	@irq:	Interrupt number
+ *	@entry:	Pointer to MBI descriptor
+ */
+int irq_set_mbi_desc(unsigned int irq, struct mbi_desc *entry)
+{
+	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+
+	if (!desc)
+		return -EINVAL;
+	desc->irq_data.mbi_desc = entry;
+	irq_put_desc_unlock(desc, flags);
+	return 0;
+}
+EXPORT_SYMBOL(irq_set_mbi_desc);
+
+/**
+ *	irq_set_mbi_desc_range - set MBI descriptor for a range of irqs
+ *	@irq:	Interrupt number
+ *	@entry:	Pointer to MBI descriptor
+ *	@count:	Number of interrupts to be set
+ */
+int irq_set_mbi_desc_range(unsigned int irq, struct mbi_desc *entry,
+			   unsigned int count)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < count; i++) {
+		ret = irq_set_mbi_desc(irq + i, entry);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(irq_set_mbi_desc_range);
+
+/**
  *	irq_set_msi_desc_off - set MSI descriptor data for an irq at offset
  *	@irq_base:	Interrupt number base
  *	@irq_offset:	Interrupt number offset
@@ -152,6 +191,33 @@ struct irq_data *irq_get_irq_data(unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(irq_get_irq_data);
 
+/**
+ * irq_compose_mbi_msg - Compose mbi message for an irq chip
+ * @data:	Pointer to interrupt specific data
+ * @msg:	Pointer to the MBI message
+ *
+ * For hierarchical domains we find the first chip in the hierarchy
+ * which implements the irq_compose_msg callback. For non hierarchical
+ * we use the top level chip.
+ */
+int irq_compose_mbi_msg(struct irq_data *data, struct mbi_msg *msg)
+{
+	struct irq_data *pos = NULL;
+
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+	for (; data; data = data->parent_data)
+#endif
+		if (data->chip && data->chip->irq_compose_msg)
+			pos = data;
+	if (!pos)
+		return -ENOSYS;
+
+	pos->chip->irq_compose_msg(pos, msg);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_compose_mbi_msg);
+
 static void irq_state_clr_disabled(struct irq_desc *desc)
 {
 	irqd_clear(&desc->irq_data, IRQD_IRQ_DISABLED);
diff --git a/kernel/irq/mbi.c b/kernel/irq/mbi.c
new file mode 100644
index 0000000..1b1f108
--- /dev/null
+++ b/kernel/irq/mbi.c
@@ -0,0 +1,260 @@
+/**
+ * Copyright (C) 2014, Yun Wu <wuyun.wu@huawei.com>
+ *
+ * This file contains the generic interfaces for Message Based
+ * Interrupts (MBI).
+ */
+
+#include <linux/interrupt.h>
+#include <linux/mbi.h>
+#include <linux/slab.h>
+
+/**
+ * mbi_find_desc() - search an MBI descriptor from MBI data
+ * @mbi:	MBI data of the device
+ * @data:	the unique MBI-specific data
+ */
+static struct mbi_desc *mbi_find_desc(struct device *dev, void *data)
+{
+	struct mbi_desc *desc;
+
+	list_for_each_entry(desc, &dev->mbi->mbi_list, entry) {
+		if (desc->data == data)
+			return desc;
+	}
+
+	return NULL;
+}
+
+/**
+ * mbi_init() - initialize MBI data
+ * @dev:	the device owned the MBI data
+ * @ops:	operations of the MBI-capable device
+ * @pmbi:	pointer to the pointer of MBI data
+ */
+static int mbi_init(struct device *dev, struct mbi_ops *ops,
+		    struct mbi_data **pmbi)
+{
+	struct mbi_data *mbi = dev->mbi;
+
+	if (mbi)
+		goto out_done;
+	if (!ops)
+		return -EINVAL;
+
+	mbi = kzalloc(sizeof(*mbi), GFP_KERNEL);
+	if (!mbi)
+		return -ENOMEM;
+
+	mbi->dev = dev;
+	mbi->ops = ops;
+	raw_spin_lock_init(&mbi->lock);
+	INIT_LIST_HEAD(&mbi->mbi_list);
+	dev->mbi = mbi;
+
+out_done:
+	*pmbi = mbi;
+	return 0;
+}
+
+/**
+ * mbi_free_desc() - free an MBI descriptor
+ * @desc:	the MBI descriptor to be freed
+ */
+static void mbi_free_desc(struct mbi_desc *desc)
+{
+	struct mbi_data *mbi;
+
+	mbi = desc ? desc->mbi : NULL;
+	BUG_ON(!mbi);
+
+	raw_spin_lock(&mbi->lock);
+	list_del(&desc->entry);
+	if (list_empty(&mbi->mbi_list))
+		mbi->dev->mbi = NULL;
+	raw_spin_unlock(&mbi->lock);
+
+	kfree(desc);
+	kfree(mbi);
+}
+
+/**
+ * mbi_alloc_desc() - allocate an MBI descriptor
+ * @info:	infomation prepared for the MBI domain
+ * @virq:	the base linux interrupt number of the MBI
+ * @pdesc:	pointer to the pointer of MBI descriptor
+ */
+static int mbi_alloc_desc(struct mbi_domain_info *info, unsigned int virq,
+			  struct mbi_desc **pdesc)
+{
+	struct mbi_data *mbi = NULL;
+	struct mbi_desc *desc;
+	int ret;
+
+	ret = mbi_init(info->dev, info->ops, &mbi);
+	if (ret)
+		return ret;
+
+	desc = mbi_find_desc(info->dev, info->data);
+	if (desc)
+		goto out_done;
+
+	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	desc->mbi = mbi;
+	desc->irq = virq;
+	desc->data = info->data;
+	desc->nvec = info->nvec;
+
+	raw_spin_lock(&mbi->lock);
+	list_add(&desc->entry, &mbi->mbi_list);
+	raw_spin_unlock(&mbi->lock);
+
+out_done:
+	*pdesc = desc;
+	return 0;
+}
+
+/**
+ * mbi_config_irq() - config one MBI interrupt
+ * @data:	irq_data of the MBI interrupt
+ * @mask:	type of configuration, mask if true, otherwise unmask
+ */
+static void mbi_config_irq(struct irq_data *data, int mask)
+{
+	struct mbi_desc *desc = data->mbi_desc;
+	struct mbi_ops *ops = desc->mbi->ops;
+	unsigned int id = data->irq - desc->irq;
+	void (*fn)(struct mbi_desc *, int) = NULL;
+
+	if (ops)
+		fn = mask ? ops->mask_irq : ops->unmask_irq;
+	if (fn)
+		fn(desc, id);
+}
+
+static void mbi_mask_irq(struct irq_data *data)
+{
+	mbi_config_irq(data, 1);
+}
+
+static void mbi_unmask_irq(struct irq_data *data)
+{
+	mbi_config_irq(data, 0);
+}
+
+static void mbi_write_msg(struct mbi_desc *desc, struct mbi_msg *msg)
+{
+	desc->mbi->ops->write_msg(desc, msg);
+	desc->msg = *msg;
+}
+
+static int mbi_set_affinity(struct irq_data *irq_data,
+			    const struct cpumask *mask, bool force)
+{
+	struct irq_data *parent = irq_data->parent_data;
+	struct mbi_msg msg;
+	int ret;
+
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
+		BUG_ON(irq_compose_mbi_msg(irq_data, &msg));
+		mbi_write_msg(irq_data->mbi_desc, &msg);
+	}
+
+	return ret;
+}
+
+static struct irq_chip mbi_irq_chip = {
+	.name = "MBI",
+	.irq_unmask = mbi_unmask_irq,
+	.irq_mask = mbi_mask_irq,
+	.irq_ack = irq_chip_ack_parent,
+	.irq_set_affinity = mbi_set_affinity,
+	.irq_retrigger = irq_chip_retrigger_hierarchy,
+	.flags = IRQCHIP_SKIP_SET_WAKE,
+};
+
+static void mbi_domain_activate(struct irq_domain *domain, struct irq_data *data)
+{
+	struct mbi_desc *desc = data->mbi_desc;
+	struct mbi_msg msg;
+
+	WARN_ON(domain != data->domain);
+	BUG_ON(irq_compose_mbi_msg(data, &msg));
+	mbi_write_msg(desc, &msg);
+}
+
+static void mbi_domain_deactivate(struct irq_domain *domain, struct irq_data *data)
+{
+	struct mbi_desc *desc = data->mbi_desc;
+	struct mbi_msg msg;
+
+	WARN_ON(domain != data->domain);
+	memset(&msg, 0, sizeof(msg));
+	mbi_write_msg(desc, &msg);
+}
+
+static int mbi_domain_alloc(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs, void *arg)
+{
+	struct mbi_domain_info *info = arg;
+	struct mbi_desc *desc;
+	int ret, i;
+
+	ret = mbi_alloc_desc(info, virq, &desc);
+	if (ret)
+		return ret;
+
+	ret = irq_set_mbi_desc_range(virq, desc, nr_irqs);
+	if (unlikely(ret))
+		goto out_free_desc;
+
+	for (i = 0; i < nr_irqs; i++)
+		irq_domain_set_hwirq_and_chip(domain, virq + i, virq + i,
+					      &mbi_irq_chip, NULL);
+
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, NULL);
+	if (ret)
+		goto out_unset_desc;
+
+	return 0;
+
+out_unset_desc:
+	irq_set_mbi_desc_range(virq, NULL, nr_irqs);
+out_free_desc:
+	mbi_free_desc(desc);
+	return ret;
+}
+
+static void mbi_domain_free(struct irq_domain *domain, unsigned int virq,
+			    unsigned int nr_irqs)
+{
+	struct mbi_desc *desc = irq_get_mbi_desc(virq);
+
+	irq_set_mbi_desc_range(virq, NULL, nr_irqs);
+	mbi_free_desc(desc);
+	irq_domain_free_irqs_top(domain, virq, nr_irqs);
+}
+
+static struct irq_domain_ops mbi_domain_ops = {
+	.alloc = mbi_domain_alloc,
+	.free = mbi_domain_free,
+	.activate = mbi_domain_activate,
+	.deactivate = mbi_domain_deactivate,
+};
+
+struct irq_domain *mbi_create_irq_domain(struct device_node *of_node,
+					 struct irq_domain *parent)
+{
+	struct irq_domain *domain;
+
+	domain = irq_domain_add_tree(of_node, &mbi_domain_ops, NULL);
+	if (!domain)
+		return NULL;
+
+	domain->parent = parent;
+	return domain;
+}
-- 
1.8.0


--------------040304040304000607000002--
