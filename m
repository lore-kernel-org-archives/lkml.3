Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3CHTr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:47:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27145 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3CHTr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:47:26 -0500
Date: Fri, 8 Mar 2013 14:46:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH v2 05/26] x86, irq: Show pci device name for msi in
 /proc/interrupt
Message-ID: <20130308194627.GB6622@phenom.dumpdata.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
 <1360351703-20571-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360351703-20571-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 11:28:02AM -0800, Yinghai Lu wrote:
> We could find out which device is using that MSI/MSI-X.
> Use irq_print_chip() to append pci device name.

What would the end result be? For example for:

80:	some values PCI-MSI-edge      xhci_hcd

Is it going to be:

80:	some values PCI-MSI-edge-xhci_hcd	xhci_hcd

?

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  arch/x86/kernel/apic/io_apic.c |    9 ++++++---
>  drivers/iommu/irq_remapping.c  |    8 ++++++++
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index f8d4d8d..8b03875 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3089,8 +3089,11 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
>  
>  static void msi_irq_print_chip(struct irq_data *data, struct seq_file *p)
>  {
> -	seq_printf(p, " %s%s", data->chip->name,
> -			data->msi_desc->msi_attrib.is_msix ? "-X" : "");
> +	struct pci_dev *dev = data->msi_desc->dev;
> +
> +	seq_printf(p, " %s%s-edge@%s", data->chip->name,
> +			data->msi_desc->msi_attrib.is_msix ? "-X" : "",
> +			dev_name(&dev->dev));
>  }
>  
>  /*
> @@ -3130,7 +3133,7 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
>  
>  	setup_remapped_irq(irq, irq_get_chip_data(irq), chip);
>  
> -	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
> +	irq_set_chip_and_handler(irq, chip, handle_edge_irq);
>  
>  	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI%s\n", irq,
>  			 msidesc->msi_attrib.is_msix ? "-X" : "");
> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> index e245ab0..ca595f7 100644
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -365,10 +365,18 @@ static void ir_ack_apic_level(struct irq_data *data)
>  
>  static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
>  {
> +	struct pci_dev *dev = NULL;
> +
>  	seq_printf(p, " IR-%s%s", data->chip->name,
>  			data->msi_desc ?
>  			 (data->msi_desc->msi_attrib.is_msix ? "-X" : "")
>  			 : "");
> +
> +	if (data->msi_desc)
> +		dev = data->msi_desc->dev;
> +
> +	if (dev)
> +		seq_printf(p, "-edge@%s", dev_name(&dev->dev));
>  }
>  
>  static void __init irq_remap_modify_chip_defaults(struct irq_chip *chip)
> -- 
> 1.7.10.4
> 
