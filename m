Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3KEOcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:32:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34188 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab3KEOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:32:38 -0500
Date: Tue, 5 Nov 2013 09:32:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>, Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 2/3] PCI: Refactor MSI/MSIX mask restore code to fix
 interrupt lost issue
Message-ID: <20131105143223.GA3550@phenom.dumpdata.com>
References: <525E3320.5080700@oracle.com>
 <20131029215848.GA15159@google.com>
 <52706CF8.1090409@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52706CF8.1090409@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 10:20:40AM +0800, Zhenzhong Duan wrote:
> 
> On 2013-10-30 05:58, Bjorn Helgaas wrote:
> >On Wed, Oct 16, 2013 at 02:33:04PM +0800, Zhenzhong Duan wrote:
> >>Driver init call graph under baremetal:
> >>driver_init->
> >>     msix_capability_init->
> >>         msix_program_entries->
> >>             msix_mask_irq->
> >>                 entry->masked = 1
> >>     request_irq->
> >>         __setup_irq->
> >>             irq_startup->
> >>                 unmask_msi_irq->
> >>                     msix_mask_irq->
> >>                         entry->masked = 0;
> >>
> >>So entry->masked is always updated with newest value and its value could be used
> >>to restore to mask register in device.
> >>
> >>But in initial domain (aka priviliged guest), it's different.
> >>Driver init call graph under initial domain:
> >>driver_init->
> >>     msix_capability_init->
> >>         msix_program_entries->
> >>             msix_mask_irq->
> >>                 entry->masked = 1
> >>     request_irq->
> >>         __setup_irq->
> >>             irq_startup->
> >>                 __startup_pirq->
> >>                     EVTCHNOP_bind_pirq hypercall    (trap into Xen)
> >>[Xen:]
> >>pirq_guest_bind->
> >>     startup_msi_irq->
> >>         unmask_msi_irq->
> >>             msi_set_mask_bit->
> >>                 entry->msi_attrib.masked = 0;
> The right mask value is saved in entry->msi_attrib.masked on Xen.
> >>
> >>So entry->msi_attrib.masked in xen side always has newest value. entry->masked
> >>in initial domain is untouched and is 1 after msix_capability_init.
> >If we run the following sequence:
> >
> >     pci_enable_msix()
> >     request_irq()
> >
> >don't we end up with the MSI IRQ unmasked if we're on bare metal but masked
> >if we're on Xen?  It seems like we'd want it unmasked in both cases, so I
> >expected your patch to do something to make it unmasked if we're on Xen.
> >But I don't think it does, does it?
> >
> >As far as I can tell, this patch only changes the pci_restore_state()
> >path.  I think that part makes sense.
> >
> >Bjorn
> It's unmasked on Xen too. This is just what this patch try to fix.
> In PHYSDEVOP_restore_msi hypercall, xen did the right thing that did
> by kernel in baremetal.

Part of this problem is that all of the interrupt vector setting (either
be it GSI, MSI or MSI-X) is handled by the hypervisor. That means the kernel
consults the hypervisor for the right 'vector' value for all of the different
types of interrupts. And that 'vector' value is not even used - the interrupts
first hit the hypervisor - which dispatches them to the guest via a software
event channel mechanism (a bitmap of 'active' events - and an event can be
tied to a physical interrupt or an IPI, etc).

Even more recently we have been clamping down - so that the kernel pagetables
for the MSI-X tables for example are R/O - so it can't write (or over-write)
with a different vector value (or the same one). The hypervisor is the one
that does this change.

Perhaps a different way of fixing this is making the '__msi_mask_irq' and
'__msix_mask_irq' be part of the x86.msi function ops? And then the platform
can over-write it with its own mechanism for masking/unmasking? (and in case
of Xen it would be a nop as that has already been done by the hypervisor?)

The 'write_msi_msg' we don't have to worry about as it is only used by
default_restore_msi_irqs (which is part of the x86.msi and can be over-written).

Perhaps something like this (Testing it right now):

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 828a156..0f1be11 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -172,6 +172,7 @@ struct x86_platform_ops {
 
 struct pci_dev;
 struct msi_msg;
+struct msi_desc;
 
 struct x86_msi_ops {
 	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
@@ -182,6 +183,8 @@ struct x86_msi_ops {
 	void (*teardown_msi_irqs)(struct pci_dev *dev);
 	void (*restore_msi_irqs)(struct pci_dev *dev, int irq);
 	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
+	u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
+	u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
 };
 
 struct IO_APIC_route_entry;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 8ce0072..021783b 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -116,6 +116,8 @@ struct x86_msi_ops x86_msi = {
 	.teardown_msi_irqs	= default_teardown_msi_irqs,
 	.restore_msi_irqs	= default_restore_msi_irqs,
 	.setup_hpet_msi		= default_setup_hpet_msi,
+	.msi_mask_irq		= default_msi_mask_irq,
+	.msix_mask_irq		= default_msix_mask_irq,
 };
 
 /* MSI arch specific hooks */
@@ -138,6 +140,14 @@ void arch_restore_msi_irqs(struct pci_dev *dev, int irq)
 {
 	x86_msi.restore_msi_irqs(dev, irq);
 }
+u32 arch_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+{
+	return x86_msi.msi_mask_irq(desc, mask, flag);
+}
+u32 arch_msix_mask_irq(struct msi_desc *desc, u32 flag)
+{
+	return x86_msi.msix_mask_irq(desc, flag);
+}
 #endif
 
 struct x86_io_apic_ops x86_io_apic_ops = {
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 48e8461..5eee495 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -382,7 +382,14 @@ static void xen_teardown_msi_irq(unsigned int irq)
 {
 	xen_destroy_irq(irq);
 }
-
+static u32 xen_nop_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+{
+	return 0;
+}
+static u32 xen_nop_msix_mask_irq(struct msi_desc *desc, u32 flag)
+{
+	return 0;
+}
 #endif
 
 int __init pci_xen_init(void)
@@ -406,6 +413,8 @@ int __init pci_xen_init(void)
 	x86_msi.setup_msi_irqs = xen_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
 	x86_msi.teardown_msi_irqs = xen_teardown_msi_irqs;
+	x86_msi.msi_mask_irq = xen_nop_msi_mask_irq;
+	x86_msi.msix_mask_irq = xen_nop_msix_mask_irq;
 #endif
 	return 0;
 }
@@ -485,6 +494,8 @@ int __init pci_xen_initial_domain(void)
 	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
 	x86_msi.restore_msi_irqs = xen_initdom_restore_msi_irqs;
+	x86_msi.msi_mask_irq = xen_nop_msi_mask_irq;
+	x86_msi.msix_mask_irq = xen_nop_msix_mask_irq;
 #endif
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d5f90d6..7916699 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -185,7 +185,7 @@ static inline __attribute_const__ u32 msi_enabled_mask(u16 control)
  * reliably as devices without an INTx disable bit will then generate a
  * level IRQ which will never be cleared.
  */
-static u32 __msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
 	u32 mask_bits = desc->masked;
 
@@ -199,9 +199,14 @@ static u32 __msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 	return mask_bits;
 }
 
+__weak u32 arch_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+{
+	return default_msi_mask_irq(desc, mask, flag);
+}
+
 static void msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
-	desc->masked = __msi_mask_irq(desc, mask, flag);
+	desc->masked = arch_msi_mask_irq(desc, mask, flag);
 }
 
 /*
@@ -211,7 +216,7 @@ static void msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
  * file.  This saves a few milliseconds when initialising devices with lots
  * of MSI-X interrupts.
  */
-static u32 __msix_mask_irq(struct msi_desc *desc, u32 flag)
+u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag)
 {
 	u32 mask_bits = desc->masked;
 	unsigned offset = desc->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
@@ -224,9 +229,14 @@ static u32 __msix_mask_irq(struct msi_desc *desc, u32 flag)
 	return mask_bits;
 }
 
+__weak u32 arch_msix_mask_irq(struct msi_desc *desc, u32 flag)
+{
+	return default_msix_mask_irq(desc, flag);
+}
+
 static void msix_mask_irq(struct msi_desc *desc, u32 flag)
 {
-	desc->masked = __msix_mask_irq(desc, flag);
+	desc->masked = arch_msix_mask_irq(desc, flag);
 }
 
 static void msi_set_mask_bit(struct irq_data *data, u32 flag)
@@ -902,7 +912,7 @@ void pci_msi_shutdown(struct pci_dev *dev)
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &ctrl);
 	mask = msi_capable_mask(ctrl);
 	/* Keep cached state to be restored */
-	__msi_mask_irq(desc, mask, ~mask);
+	arch_msi_mask_irq(desc, mask, ~mask);
 
 	/* Restore dev->irq to its default pin-assertion irq */
 	dev->irq = desc->msi_attrib.default_irq;
@@ -998,7 +1008,7 @@ void pci_msix_shutdown(struct pci_dev *dev)
 	/* Return the device with MSI-X masked as initial states */
 	list_for_each_entry(entry, &dev->msi_list, list) {
 		/* Keep cached states to be restored */
-		__msix_mask_irq(entry, 1);
+		arch_msix_mask_irq(entry, 1);
 	}
 
 	msix_set_enable(dev, 0);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index b17ead8..87cce50 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -64,6 +64,8 @@ void arch_restore_msi_irqs(struct pci_dev *dev, int irq);
 
 void default_teardown_msi_irqs(struct pci_dev *dev);
 void default_restore_msi_irqs(struct pci_dev *dev, int irq);
+u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
+u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag);
 
 struct msi_chip {
 	struct module *owner;
