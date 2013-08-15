Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3HOFzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 01:55:35 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:40825 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3HOFze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 01:55:34 -0400
Date: Thu, 15 Aug 2013 13:55:23 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        joro@8bytes.org
Subject: Re: [PATCH v2] KVM: PPC: move iommu_add_device earlier
Message-ID: <20130815055523.GA13692@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1376535439-12838-1-git-send-email-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376535439-12838-1-git-send-email-aik@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081505-4790-0000-0000-000009CF1BFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey,

On Thu, Aug 15, 2013 at 12:57:19PM +1000, Alexey Kardashevskiy wrote:
>The current implementation of IOMMU on sPAPR does not use iommu_ops
>and therefore does not call IOMMU API's bus_set_iommu() which
>1) sets iommu_ops for a bus
>2) registers a bus notifier
>Instead, PCI devices are added to IOMMU groups from
>subsys_initcall_sync(tce_iommu_init) which does basically the same
>thing without using iommu_ops callbacks.
>
>However Freescale PAMU driver (https://lkml.org/lkml/2013/7/1/158)
>implements iommu_ops and when tce_iommu_init is called, every PCI device
>is already added to some group so there is a conflict.
>
>This patch does 2 things:
>1. removes the loop in which PCI devices were added to groups and
>adds devices as soon as they get the iommu_table pointer assigned to them.
>For this, the set_iommu_table_base_and_group() function is introduced.
>2. moves a bus notifier to powernv code (for hotplug) in order to avoid
>conflict with the notifier from the Freescale driver.
>
>iommu_add_device() and iommu_del_device() are public now.

Small suggestion, how about add a prefix like "ppc_"?

Since on intel, it has intel_iommu_add_device. Maybe this could help the
audience.

>
>Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>---
>
>@@ -623,3 +623,33 @@ void __init pnv_pci_init(void)
> 	ppc_md.teardown_msi_irqs = pnv_teardown_msi_irqs;
> #endif
> }
>+
>+static int tce_iommu_bus_notifier(struct notifier_block *nb,
>+		unsigned long action, void *data)
>+{
>+	struct device *dev = data;
>+
>+	switch (action) {
>+	case BUS_NOTIFY_ADD_DEVICE:
>+		return iommu_add_device(dev);
>+	case BUS_NOTIFY_DEL_DEVICE:
>+		iommu_del_device(dev);
>+		return 0;

Recently, I encounter a problem for device remove. In some cases, the device
will not belong to any iommu_group. For example, the DMA space is not enough
and can't allocate a TCE segment. (This happens on P7IOC. I think on P8 it
won't happen.) In this case, dev->iommu_group would be NULL and kernel crash
in iommu_group_remove_device(), since it try to reference group->notifier.

In iommu_bus_notifier(), it will check dev->iommu_group before calling the
remove_device. 
	if (ops->remove_device && dev->iommu_group)

So I suggest to add this check here too.

BTW, I have a patch like this, which I put the check in iommu_group_remove_device.
This could protect the kernel from do the removing without the check outside. 

Author: Wei Yang <weiyang@linux.vnet.ibm.com>
Date:   Wed Aug 14 04:45:06 2013 -0400

    iommu: check dev->iommu_group before removing a device 
    
    In some cases, one device may not associate with any iommu_group.
    For example, not enough DMA address space.
    
    For those devices, kernel will crash when try to remove it from an iommu_group.
    
    This patch do the check before remove it.
    
    Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fbe9ca7..fe41946 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -379,6 +379,9 @@ void iommu_group_remove_device(struct device *dev)
        struct iommu_group *group = dev->iommu_group;
        struct iommu_device *tmp_device, *device = NULL;
 
+       if (!group)
+               return;
+
        /* Pre-notify listeners that a device is being removed. */
        blocking_notifier_call_chain(&group->notifier,
                                     IOMMU_GROUP_NOTIFY_DEL_DEVICE, dev);

I am not sure which place is better, in iommu_group_remove_device() or in the 
tce_iommu_bus_notifier().

I am glad to hear your suggestions.


-- 
Richard Yang
Help you, Help me

