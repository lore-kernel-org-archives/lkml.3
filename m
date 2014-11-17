Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaKQVCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:02:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:35552 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbaKQVCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:02:52 -0500
Date: Mon, 17 Nov 2014 22:02:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: Re: [PATCH 00/10] Save MSI chip in pci_sys_data
In-Reply-To: <CAErSpo46d0OJbO6tuDUXb2q7+00BUuHzJdsCr+aOhY4we+zn=w@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411172138191.3909@nanos>
References: <1414396127-30023-1-git-send-email-wangyijing@huawei.com> <20141112042359.GK28161@google.com> <20141117025914.GC4280@google.com> <alpine.DEB.2.11.1411171035270.3909@nanos> <CAErSpo46d0OJbO6tuDUXb2q7+00BUuHzJdsCr+aOhY4we+zn=w@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Bjorn Helgaas wrote:
> On Mon, Nov 17, 2014 at 2:38 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > The simplest way to dead with it is that I pull in pci/msi (assuming
> > that it contains only the above) and base the rest of it on top, so I
> > can deal with the resulting conflicts. So you still can keep that in
> > your pile and no matter who sends the pull request first everything
> > will just fall in place.
> 
> In addition to the ("Save MSI chip in pci_sys_data") series, my
> pci/msi branch contains these:
> 
>   f83386942702 s390/MSI: Use __msi_mask_irq() instead of default_msi_mask_irq()
>   03f56e42d03e Revert "PCI: Add x86_msi.msi_mask_irq() and msix_mask_irq()"
>   38737d82f9f0 PCI/MSI: Add pci_msi_ignore_mask to prevent writes to
> MSI/MSI-X Mask Bits
> 
> but I don't think it will hurt if you pull in those as well.

They are blessed by you, so I don't worry :)
 
> The bigger problem might be the first patch of the "Save MSI chip in
> pci_sys_data", which renames "struct msi_chip" to "struct
> msi_controller".  I asked Yijing to do that because I didn't think
> "_chip" really conveyed any information.  I didn't know we were going
> to have quite this many MSI-related patches to fix up.

Not a big deal at all. I pulled your branch and fixed up the pending
mess on top of it. Not a really big deal.
 
> So I'll just leave my pci/msi branch as-is for now.  If the rename is
> too painful, let me know and I'll drop the branch and we can rework
> the rest of the "Save MSI chip in pci_sys_data" series to match.

No, not a problem at all. If I can carry your branch and it is
immutable then I think we are fine.

The changes we have stashed on top of this which touch linux/msi.h and
pci/msi.c are at the end of this mail. But most of this is
selfcontained and wont hurt anything which does not enable the
required config options. The diffstat is:

 drivers/pci/msi.c   |  334 +++++++++++++++++++++++++++++++++++++++++-----------
 include/linux/msi.h |  158 +++++++++++++++++++++++-
 2 files changed, 422 insertions(+), 70 deletions(-)

Looks large, but it provides common infrastructure which allows ARM64
to implement MSI support w/o any of the gazillion weak arch
callbacks. Jiangs x86 work distangles the convoluted mess we have with
irq remapping etc. and we can have non PCI based MSI interrupts as a
bonus.

So I'm pretty happy with the outcome now. The stacked irqdomains
really worked out well so far. I don't think that the pci/msi.c side
will see much updates on that in the next weeks. Though based on that
we'll try to get rid of the whole weak arch_xxx in the long run, but
that's a different issue and nothing we need to worry about now.

I'm going to push out the current state of affairs soon and will ask
all involved folks to have a look on that. If I don't hear someone
crying murder I'm going to make the branch immutable and push it into
next so that ARM and x86 can follow up with their stuff which depends
on that whole endavour.

If you have updates to your pci/msi stuff before the merge window then
please let me know, so we can coordinate on the procedure.

Thanks,

	tglx
----
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 6e2ebe6efca5..d5fea9b18fef 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/irqdomain.h>
 
 #include "pci.h"
 
@@ -27,6 +28,52 @@ int pci_msi_ignore_mask;
 
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
+static struct irq_domain *pci_msi_get_domain(struct pci_dev *dev)
+{
+	struct irq_domain *domain = NULL;
+
+	if (dev->bus->msi)
+		domain = dev->bus->msi->domain;
+	if (!domain)
+		domain = arch_get_pci_msi_domain(dev);
+
+	return domain;
+}
+
+static int pci_msi_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	struct irq_domain *domain;
+
+	domain = pci_msi_get_domain(dev);
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
+	domain = pci_msi_get_domain(dev);
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
 
@@ -96,19 +143,13 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
  */
 void default_teardown_msi_irqs(struct pci_dev *dev)
 {
+	int i;
 	struct msi_desc *entry;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
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
+	list_for_each_entry(entry, &dev->msi_list, list)
+		if (entry->irq)
+			for (i = 0; i < entry->nvec_used; i++)
+				arch_teardown_msi_irq(entry->irq + i);
 }
 
 void __weak arch_teardown_msi_irqs(struct pci_dev *dev)
@@ -131,7 +172,7 @@ static void default_restore_msi_irq(struct pci_dev *dev, int irq)
 	}
 
 	if (entry)
-		__write_msi_msg(entry, &entry->msg);
+		__pci_write_msi_msg(entry, &entry->msg);
 }
 
 void __weak arch_restore_msi_irqs(struct pci_dev *dev)
@@ -249,12 +290,11 @@ void default_restore_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
+	list_for_each_entry(entry, &dev->msi_list, list)
 		default_restore_msi_irq(dev, entry->irq);
-	}
 }
 
-void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	BUG_ON(entry->dev->current_state != PCI_D0);
 
@@ -284,32 +324,7 @@ void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
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
-EXPORT_SYMBOL_GPL(get_cached_msi_msg);
-
-void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	if (entry->dev->current_state != PCI_D0) {
 		/* Don't touch the hardware now */
@@ -346,34 +361,27 @@ void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 	entry->msg = *msg;
 }
 
-void write_msi_msg(unsigned int irq, struct msi_msg *msg)
+void pci_write_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
 	struct msi_desc *entry = irq_get_msi_desc(irq);
 
-	__write_msi_msg(entry, msg);
+	__pci_write_msi_msg(entry, msg);
 }
-EXPORT_SYMBOL_GPL(write_msi_msg);
+EXPORT_SYMBOL_GPL(pci_write_msi_msg);
 
 static void free_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry, *tmp;
 	struct attribute **msi_attrs;
 	struct device_attribute *dev_attr;
-	int count = 0;
+	int i, count = 0;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
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
+	list_for_each_entry(entry, &dev->msi_list, list)
+		if (entry->irq)
+			for (i = 0; i < entry->nvec_used; i++)
+				BUG_ON(irq_has_action(entry->irq + i));
 
-	arch_teardown_msi_irqs(dev);
+	pci_msi_teardown_msi_irqs(dev);
 
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
 		if (entry->msi_attrib.is_msix) {
@@ -456,9 +464,8 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 				PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL);
 
 	arch_restore_msi_irqs(dev);
-	list_for_each_entry(entry, &dev->msi_list, list) {
+	list_for_each_entry(entry, &dev->msi_list, list)
 		msix_mask_irq(entry, entry->masked);
-	}
 
 	msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
 }
@@ -502,9 +509,8 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
 	int count = 0;
 
 	/* Determine how many msi entries we have */
-	list_for_each_entry(entry, &pdev->msi_list, list) {
+	list_for_each_entry(entry, &pdev->msi_list, list)
 		++num_msi;
-	}
 	if (!num_msi)
 		return 0;
 
@@ -564,7 +570,7 @@ error_attrs:
 	return ret;
 }
 
-static struct msi_desc *msi_setup_entry(struct pci_dev *dev)
+static struct msi_desc *msi_setup_entry(struct pci_dev *dev, int nvec)
 {
 	u16 control;
 	struct msi_desc *entry;
@@ -582,6 +588,8 @@ static struct msi_desc *msi_setup_entry(struct pci_dev *dev)
 	entry->msi_attrib.maskbit	= !!(control & PCI_MSI_FLAGS_MASKBIT);
 	entry->msi_attrib.default_irq	= dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.multi_cap	= (control & PCI_MSI_FLAGS_QMASK) >> 1;
+	entry->msi_attrib.multiple	= ilog2(__roundup_pow_of_two(nvec));
+	entry->nvec_used		= nvec;
 
 	if (control & PCI_MSI_FLAGS_64BIT)
 		entry->mask_pos = dev->msi_cap + PCI_MSI_MASK_64;
@@ -614,7 +622,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 
 	msi_set_enable(dev, 0);	/* Disable MSI during set up */
 
-	entry = msi_setup_entry(dev);
+	entry = msi_setup_entry(dev, nvec);
 	if (!entry)
 		return -ENOMEM;
 
@@ -625,7 +633,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 	list_add_tail(&entry->list, &dev->msi_list);
 
 	/* Configure MSI capability structure */
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
+	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
 	if (ret) {
 		msi_mask_irq(entry, mask, ~mask);
 		free_msi_irqs(dev);
@@ -685,6 +693,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		entry->msi_attrib.entry_nr	= entries[i].entry;
 		entry->msi_attrib.default_irq	= dev->irq;
 		entry->mask_base		= base;
+		entry->nvec_used		= 1;
 
 		list_add_tail(&entry->list, &dev->msi_list);
 	}
@@ -703,7 +712,6 @@ static void msix_program_entries(struct pci_dev *dev,
 						PCI_MSIX_ENTRY_VECTOR_CTRL;
 
 		entries[i].vector = entry->irq;
-		irq_set_msi_desc(entry->irq, entry);
 		entry->masked = readl(entry->mask_base + offset);
 		msix_mask_irq(entry, 1);
 		i++;
@@ -740,7 +748,7 @@ static int msix_capability_init(struct pci_dev *dev,
 	if (ret)
 		return ret;
 
-	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
+	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
 		goto out_avail;
 
@@ -1117,3 +1125,197 @@ int pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
 	return nvec;
 }
 EXPORT_SYMBOL(pci_enable_msix_range);
+
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+/**
+ * pci_msi_domain_write_msg - Helper to write MSI message to PCI config space
+ * @irq_data:	Pointer to interrupt data of the MSI interrupt
+ * @msg:	Pointer to the message
+ */
+void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg)
+{
+	struct msi_desc *desc = irq_data->msi_desc;
+
+	/*
+	 * For MSI-X desc->irq is always equal to irq_data->irq. For
+	 * MSI only the first interrupt of MULTI MSI passes the test.
+	 */
+	if (desc->irq == irq_data->irq)
+		__pci_write_msi_msg(desc, msg);
+}
+
+/**
+ * pci_msi_domain_calc_hwirq - Generate a unique ID for an MSI source
+ * @dev:	Pointer to the PCI device
+ * @desc:	Pointer to the msi descriptor
+ *
+ * The ID number is only used within the irqdomain.
+ */
+irq_hw_number_t pci_msi_domain_calc_hwirq(struct pci_dev *dev,
+					  struct msi_desc *desc)
+{
+	return (irq_hw_number_t)desc->msi_attrib.entry_nr |
+		PCI_DEVID(dev->bus->number, dev->devfn) << 11 |
+		(pci_domain_nr(dev->bus) & 0xFFFFFFFF) << 27;
+}
+
+static inline bool pci_msi_desc_is_multi_msi(struct msi_desc *desc)
+{
+	return !desc->msi_attrib.is_msix && desc->nvec_used > 1;
+}
+
+/**
+ * pci_msi_domain_check_cap - Verify that @domain supports the capabilities for @dev
+ * @domain:	The interrupt domain to check
+ * @info:	The domain info for verification
+ * @dev:	The device to check
+ *
+ * Returns:
+ *  0 if the functionality is supported
+ *  1 if Multi MSI is requested, but the domain does not support it
+ *  -ENOTSUPP otherwise
+ */
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
+
+	return 0;
+}
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
+#ifdef GENERIC_MSI_DOMAIN_OPS
+static void pci_msi_domain_set_desc(msi_alloc_info_t *arg,
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
+/**
+ * pci_msi_create_irq_domain - Creat a MSI interrupt domain
+ * @node:	Optional device-tree node of the interrupt controller
+ * @info:	MSI domain info
+ * @parent:	Parent irq domain
+ *
+ * Updates the domain and chip ops and creates a MSI interrupt domain.
+ *
+ * Returns:
+ * A domain pointer or NULL in case of failure.
+ */
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
+/**
+ * pci_msi_domain_alloc_irqs - Allocate interrupts for @dev in @domain
+ * @domain:	The interrupt domain to allocate from
+ * @dev:	The device for which to allocate
+ * @nvec:	The number of interrupts to allocate
+ * @type:	Unused to allow simpler migration from the arch_XXX interfaces
+ *
+ * Returns:
+ * A virtual interrupt number or an error code in case of failure
+ */
+int pci_msi_domain_alloc_irqs(struct irq_domain *domain, struct pci_dev *dev,
+			      int nvec, int type)
+{
+	return msi_domain_alloc_irqs(domain, &dev->dev, nvec);
+}
+
+/**
+ * pci_msi_domain_free_irqs - Free interrupts for @dev in @domain
+ * @domain:	The interrupt domain
+ * @dev:	The device for which to free interrupts
+ */
+void pci_msi_domain_free_irqs(struct irq_domain *domain, struct pci_dev *dev)
+{
+	msi_domain_free_irqs(domain, &dev->dev);
+}
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
+#endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 6704991b0174..ead5a791f065 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -16,12 +16,9 @@ struct irq_data;
 struct msi_desc;
 void mask_msi_irq(struct irq_data *data);
 void unmask_msi_irq(struct irq_data *data);
-void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
-void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
-void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
-void write_msi_msg(unsigned int irq, struct msi_msg *msg);
+
 u32 __msix_mask_irq(struct msi_desc *desc, u32 flag);
 u32 __msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
 
@@ -51,6 +48,33 @@ struct msi_desc {
 	struct msi_msg msg;
 };
 
+/* Helpers to hide struct msi_desc implementation details */
+#define msi_desc_to_dev(desc)		(&(desc)->dev.dev)
+#define dev_to_msi_list(dev)		(&to_pci_dev((dev))->msi_list)
+#define first_msi_entry(dev)		\
+	list_first_entry(dev_to_msi_list((dev)), struct msi_desc, list)
+#define for_each_msi_entry(desc, dev)	\
+	list_for_each_entry((desc), dev_to_msi_list((dev)), list)
+
+#ifdef CONFIG_PCI_MSI
+#define first_pci_msi_entry(pdev)	first_msi_entry(&(pdev)->dev)
+#define for_each_pci_msi_entry(desc, pdev)	\
+	for_each_msi_entry((desc), &(pdev)->dev)
+
+static inline struct pci_dev *msi_desc_to_pci_dev(struct msi_desc *desc)
+{
+	return desc->dev;
+}
+#endif /* CONFIG_PCI_MSI */
+
+void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void pci_write_msi_msg(unsigned int irq, struct msi_msg *msg);
+
+/* Conversion helpers. Should be removed after merging */
+#define __write_msi_msg __pci_write_msi_msg
+#define write_msi_msg pci_write_msi_msg
+
 /*
  * The arch hooks to setup up msi irqs. Those functions are
  * implemented as weak symbols so that they /can/ be overriden by
@@ -70,10 +94,136 @@ struct msi_controller {
 	struct device *dev;
 	struct device_node *of_node;
 	struct list_head list;
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+	struct irq_domain *domain;
+#endif
 
 	int (*setup_irq)(struct msi_controller *chip, struct pci_dev *dev,
 			 struct msi_desc *desc);
 	void (*teardown_irq)(struct msi_controller *chip, unsigned int irq);
 };
 
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+
+#include <linux/irqhandler.h>
+#include <asm/msi.h>
+
+struct irq_domain;
+struct irq_chip;
+struct device_node;
+struct msi_domain_info;
+
+/**
+ * struct msi_domain_ops - MSI interrupt domain callbacks
+ * @get_hwirq:		Retrieve the resulting hw irq number
+ * @msi_init:		Domain specific init function for MSI interrupts
+ * @msi_free:		Domain specific function to free a MSI interrupts
+ * @msi_check:		Callback for verification of the domain/info/dev data
+ * @msi_prepare:	Prepare the allocation of the interrupts in the domain
+ * @msi_finish:		Optional callbacl to finalize the allocation
+ * @set_desc:		Set the msi descriptor for an interrupt
+ * @handle_error:	Optional error handler if the allocation fails
+ *
+ * @get_hwirq, @msi_init and @msi_free are callbacks used by
+ * msi_create_irq_domain() and related interfaces
+ *
+ * @msi_check, @msi_prepare, @msi_finish, @set_desc and @handle_error
+ * are callbacks used by msi_irq_domain_alloc_irqs() and related
+ * interfaces which are based on msi_desc.
+ */
+struct msi_domain_ops {
+	irq_hw_number_t	(*get_hwirq)(struct msi_domain_info *info,
+				     msi_alloc_info_t *arg);
+	int		(*msi_init)(struct irq_domain *domain,
+				    struct msi_domain_info *info,
+				    unsigned int virq, irq_hw_number_t hwirq,
+				    msi_alloc_info_t *arg);
+	void		(*msi_free)(struct irq_domain *domain,
+				    struct msi_domain_info *info,
+				    unsigned int virq);
+	int		(*msi_check)(struct irq_domain *domain,
+				     struct msi_domain_info *info,
+				     struct device *dev);
+	int		(*msi_prepare)(struct irq_domain *domain,
+				       struct device *dev, int nvec,
+				       msi_alloc_info_t *arg);
+	void		(*msi_finish)(msi_alloc_info_t *arg, int retval);
+	void		(*set_desc)(msi_alloc_info_t *arg,
+				    struct msi_desc *desc);
+	int		(*handle_error)(struct irq_domain *domain,
+					struct msi_desc *desc, int error);
+};
+
+/**
+ * struct msi_domain_info - MSI interrupt domain data
+ * @flags:		Flags to decribe features and capabilities
+ * @ops:		The callback data structure
+ * @chip:		Optional: associated interrupt chip
+ * @chip_data:		Optional: associated interrupt chip data
+ * @handler:		Optional: associated interrupt flow handler
+ * @handler_data:	Optional: associated interrupt flow handler data
+ * @handler_name:	Optional: associated interrupt flow handler name
+ * @data:		Optional: domain specific data
+ */
+struct msi_domain_info {
+	u32			flags;
+	struct msi_domain_ops	*ops;
+	struct irq_chip		*chip;
+	void			*chip_data;
+	irq_flow_handler_t	handler;
+	void			*handler_data;
+	const char		*handler_name;
+	void			*data;
+};
+
+/* Flags for msi_domain_info */
+enum {
+	/*
+	 * Init non implemented ops callbacks with default MSI domain
+	 * callbacks.
+	 */
+	MSI_FLAG_USE_DEF_DOM_OPS	= (1 << 0),
+	/*
+	 * Init non implemented chip callbacks with default MSI chip
+	 * callbacks.
+	 */
+	MSI_FLAG_USE_DEF_CHIP_OPS	= (1 << 1),
+	/* Build identity map between hwirq and irq */
+	MSI_FLAG_IDENTITY_MAP		= (1 << 2),
+	/* Support multiple PCI MSI interrupts */
+	MSI_FLAG_MULTI_PCI_MSI		= (1 << 3),
+	/* Support PCI MSIX interrupts */
+	MSI_FLAG_PCI_MSIX		= (1 << 4),
+};
+
+int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			    bool force);
+
+struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
+					 struct msi_domain_info *info,
+					 struct irq_domain *parent);
+int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
+			  int nvec);
+void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev);
+struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain);
+
+#endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
+
+#ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
+void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg);
+struct irq_domain *pci_msi_create_irq_domain(struct device_node *node,
+					     struct msi_domain_info *info,
+					     struct irq_domain *parent);
+int pci_msi_domain_alloc_irqs(struct irq_domain *domain, struct pci_dev *dev,
+			      int nvec, int type);
+void pci_msi_domain_free_irqs(struct irq_domain *domain, struct pci_dev *dev);
+struct irq_domain *pci_msi_create_default_irq_domain(struct device_node *node,
+		 struct msi_domain_info *info, struct irq_domain *parent);
+
+irq_hw_number_t pci_msi_domain_calc_hwirq(struct pci_dev *dev,
+					  struct msi_desc *desc);
+int pci_msi_domain_check_cap(struct irq_domain *domain,
+			     struct msi_domain_info *info, struct device *dev);
+#endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
+
 #endif /* LINUX_MSI_H */

