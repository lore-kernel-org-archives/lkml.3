Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab3J2V64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:58:56 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:41913 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3J2V6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:58:53 -0400
Date: Tue, 29 Oct 2013 15:58:48 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 2/3] PCI: Refactor MSI/MSIX mask restore code to fix
 interrupt lost issue
Message-ID: <20131029215848.GA15159@google.com>
References: <525E3320.5080700@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525E3320.5080700@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 02:33:04PM +0800, Zhenzhong Duan wrote:
> Driver init call graph under baremetal:
> driver_init->
>     msix_capability_init->
>         msix_program_entries->
>             msix_mask_irq->
>                 entry->masked = 1
>     request_irq->
>         __setup_irq->
>             irq_startup->
>                 unmask_msi_irq->
>                     msix_mask_irq->
>                         entry->masked = 0;
> 
> So entry->masked is always updated with newest value and its value could be used
> to restore to mask register in device.
> 
> But in initial domain (aka priviliged guest), it's different.
> Driver init call graph under initial domain:
> driver_init->
>     msix_capability_init->
>         msix_program_entries->
>             msix_mask_irq->
>                 entry->masked = 1
>     request_irq->
>         __setup_irq->
>             irq_startup->
>                 __startup_pirq->
>                     EVTCHNOP_bind_pirq hypercall    (trap into Xen)
> [Xen:]
> pirq_guest_bind->
>     startup_msi_irq->
>         unmask_msi_irq->
>             msi_set_mask_bit->
>                 entry->msi_attrib.masked = 0;
> 
> So entry->msi_attrib.masked in xen side always has newest value. entry->masked
> in initial domain is untouched and is 1 after msix_capability_init.

If we run the following sequence:

    pci_enable_msix()
    request_irq()

don't we end up with the MSI IRQ unmasked if we're on bare metal but masked
if we're on Xen?  It seems like we'd want it unmasked in both cases, so I
expected your patch to do something to make it unmasked if we're on Xen.
But I don't think it does, does it?

As far as I can tell, this patch only changes the pci_restore_state()
path.  I think that part makes sense.

Bjorn

> Based on above, it's Xen's duty to restore entry->msi_attrib.masked to device,
> but with current code, entry->masked is used and MSI-x interrupt is masked.
> 
> Before patch, restore call graph under initial domain:
> pci_reset_function->
>     pci_restore_state->
>         __pci_restore_msix_state->
>             arch_restore_msi_irqs->
>                 xen_initdom_restore_msi_irqs->
>                     PHYSDEVOP_restore_msi hypercall (first mask restore)
>             msix_mask_irq(entry, entry->masked)     (second mask restore)
> 
> So msix_mask_irq call in initial domain call graph needs to be removed.
> 
> Based on this we can move the restore of the mask in default_restore_msi_irqs
> which would avoid restoring the invalid mask under Xen. Furthermore this
> simplifies the API by making everything related to restoring an MSI be in the
> platform specific APIs instead of just parts of it.
> 
> After patch, restore call graph under initial domain:
> pci_reset_function->
>     pci_restore_state->
>         __pci_restore_msix_state->
>             arch_restore_msi_irqs->
>                 xen_initdom_restore_msi_irqs->
>                     PHYSDEVOP_restore_msi hypercall (first mask restore)
> 
> Logic for baremetal is not changed.
> Before patch, restore call graph under baremetal:
> pci_reset_function->
>     pci_restore_state->
>         __pci_restore_msix_state->
>             arch_restore_msi_irqs->
>                 default_restore_msi_irqs->
>             msix_mask_irq(entry, entry->masked)     (first mask restore)
> 
> After patch, restore call graph under baremetal:
> pci_reset_function->
>     pci_restore_state->
>         __pci_restore_msix_state->
>             arch_restore_msi_irqs->
>                 default_restore_msi_irqs->
>                     msix_mask_irq(entry, entry->masked) (first mask restore)
> 
> The process for MSI code is similiar.
> 
> Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/pci/msi.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index ecd4cdf..38237f4 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -236,6 +236,8 @@ void unmask_msi_irq(struct irq_data *data)
>  
>  void default_restore_msi_irqs(struct pci_dev *dev, int irq)
>  {
> +	int pos;
> +	u16 control;
>  	struct msi_desc *entry;
>  
>  	entry = NULL;
> @@ -248,8 +250,19 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq)
>  		entry = irq_get_msi_desc(irq);
>  	}
>  
> -	if (entry)
> +	if (entry) {
>  		write_msi_msg(irq, &entry->msg);
> +		if (dev->msix_enabled) {
> +			msix_mask_irq(entry, entry->masked);
> +			readl(entry->mask_base);
> +		} else {
> +			pos = entry->msi_attrib.pos;
> +			pci_read_config_word(dev, pos + PCI_MSI_FLAGS,
> +					     &control);
> +			msi_mask_irq(entry, msi_capable_mask(control),
> +				     entry->masked);
> +		}
> +	}
>  }
>  
>  void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
> @@ -423,7 +436,6 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
>  	arch_restore_msi_irqs(dev, dev->irq);
>  
>  	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
> -	msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
>  	control &= ~PCI_MSI_FLAGS_QSIZE;
>  	control |= (entry->msi_attrib.multiple << 4) | PCI_MSI_FLAGS_ENABLE;
>  	pci_write_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, control);
> @@ -447,7 +459,6 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
>  
>  	list_for_each_entry(entry, &dev->msi_list, list) {
>  		arch_restore_msi_irqs(dev, entry->irq);
> -		msix_mask_irq(entry, entry->masked);
>  	}
>  
>  	control &= ~PCI_MSIX_FLAGS_MASKALL;
> -- 
> 1.7.3
> 
