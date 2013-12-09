Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856Ab3LIXWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:22:48 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:42228 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3LIXWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:22:45 -0500
Date: Mon, 9 Dec 2013 16:22:40 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: DuanZhenzhong <zhenzhong.duan@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Subject: Re: [PATCH] Update x86_msi.restore_msi_irqs API param
Message-ID: <20131209232240.GB4699@google.com>
References: <529EB8FC.4070308@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529EB8FC.4070308@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 01:09:16PM +0800, DuanZhenzhong wrote:
> Change x86_msi.restore_msi_irqs(struct pci_dev *dev, int irq) to
> x86_msi.restore_msi_irqs(struct pci_dev *dev)
> 
> From its naming, restore_msi_irqs is used to restore multiple msix irqs,
> param 'int irq' is unneeded. This could make code looks consistent in vm
> and bare metal.
> 
> Dom0 msix restore code could also be optimized as XEN only has a hypercall
> to restore all MSIX vectors in one time.
> 
> Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Unless any x86 folks object, I'll merge this via pci for v3.14.  Thanks!

Bjorn

> ---
> arch/x86/include/asm/pci.h      |    2 +-
> arch/x86/include/asm/x86_init.h |    2 +-
> arch/x86/kernel/x86_init.c      |    4 ++--
> arch/x86/pci/xen.c              |    2 +-
> drivers/pci/msi.c               |   19 ++++++++++++++-----
> include/linux/msi.h             |    4 ++--
> 6 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
> index 947b5c4..0de52c5 100644
> --- a/arch/x86/include/asm/pci.h
> +++ b/arch/x86/include/asm/pci.h
> @@ -104,7 +104,7 @@ extern void pci_iommu_alloc(void);
> struct msi_desc;
> int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
> void native_teardown_msi_irq(unsigned int irq);
> -void native_restore_msi_irqs(struct pci_dev *dev, int irq);
> +void native_restore_msi_irqs(struct pci_dev *dev);
> int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
> 		  unsigned int irq_base, unsigned int irq_offset);
> #else
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index 0f1be11..e45e4da 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -181,7 +181,7 @@ struct x86_msi_ops {
> 			       u8 hpet_id);
> 	void (*teardown_msi_irq)(unsigned int irq);
> 	void (*teardown_msi_irqs)(struct pci_dev *dev);
> -	void (*restore_msi_irqs)(struct pci_dev *dev, int irq);
> +	void (*restore_msi_irqs)(struct pci_dev *dev);
> 	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
> 	u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
> 	u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> index 021783b..e48b674 100644
> --- a/arch/x86/kernel/x86_init.c
> +++ b/arch/x86/kernel/x86_init.c
> @@ -136,9 +136,9 @@ void arch_teardown_msi_irq(unsigned int irq)
> 	x86_msi.teardown_msi_irq(irq);
> }
> 
> -void arch_restore_msi_irqs(struct pci_dev *dev, int irq)
> +void arch_restore_msi_irqs(struct pci_dev *dev)
> {
> -	x86_msi.restore_msi_irqs(dev, irq);
> +	x86_msi.restore_msi_irqs(dev);
> }
> u32 arch_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
> {
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 5eee495..103e702 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -337,7 +337,7 @@ out:
> 	return ret;
> }
> 
> -static void xen_initdom_restore_msi_irqs(struct pci_dev *dev, int irq)
> +static void xen_initdom_restore_msi_irqs(struct pci_dev *dev)
> {
> 	int ret = 0;
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 3fcd67a..ed7310d 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -116,7 +116,7 @@ void __weak arch_teardown_msi_irqs(struct pci_dev *dev)
> 	return default_teardown_msi_irqs(dev);
> }
> 
> -void default_restore_msi_irqs(struct pci_dev *dev, int irq)
> +void default_restore_msi_irq(struct pci_dev *dev, int irq)
> {
> 	struct msi_desc *entry;
> 
> @@ -134,9 +134,9 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq)
> 		write_msi_msg(irq, &entry->msg);
> }
> 
> -void __weak arch_restore_msi_irqs(struct pci_dev *dev, int irq)
> +void __weak arch_restore_msi_irqs(struct pci_dev *dev)
> {
> -	return default_restore_msi_irqs(dev, irq);
> +	return default_restore_msi_irqs(dev);
> }
> 
> static void msi_set_enable(struct pci_dev *dev, int enable)
> @@ -262,6 +262,15 @@ void unmask_msi_irq(struct irq_data *data)
> 	msi_set_mask_bit(data, 0);
> }
> 
> +void default_restore_msi_irqs(struct pci_dev *dev)
> +{
> +	struct msi_desc *entry;
> +
> +	list_for_each_entry(entry, &dev->msi_list, list) {
> +		default_restore_msi_irq(dev, entry->irq);
> +	}
> +}
> +
> void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
> {
> 	BUG_ON(entry->dev->current_state != PCI_D0);
> @@ -430,7 +439,7 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
> 
> 	pci_intx_for_msi(dev, 0);
> 	msi_set_enable(dev, 0);
> -	arch_restore_msi_irqs(dev, dev->irq);
> +	arch_restore_msi_irqs(dev);
> 
> 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
> 	msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
> @@ -455,8 +464,8 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
> 	control |= PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL;
> 	pci_write_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, control);
> 
> +	arch_restore_msi_irqs(dev);
> 	list_for_each_entry(entry, &dev->msi_list, list) {
> -		arch_restore_msi_irqs(dev, entry->irq);
> 		msix_mask_irq(entry, entry->masked);
> 	}
> 
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index 009b024..92a2f99 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -60,10 +60,10 @@ void arch_teardown_msi_irq(unsigned int irq);
> int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
> void arch_teardown_msi_irqs(struct pci_dev *dev);
> int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
> -void arch_restore_msi_irqs(struct pci_dev *dev, int irq);
> +void arch_restore_msi_irqs(struct pci_dev *dev);
> 
> void default_teardown_msi_irqs(struct pci_dev *dev);
> -void default_restore_msi_irqs(struct pci_dev *dev, int irq);
> +void default_restore_msi_irqs(struct pci_dev *dev);
> u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
> u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag);
> 
> -- 
> 1.7.3
> 
> 
