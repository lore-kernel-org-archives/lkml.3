Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3FIO4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 10:56:19 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54063 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739Ab3FIO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 10:56:18 -0400
Date: Sun, 9 Jun 2013 16:54:57 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3 02/27] x86, irq: Modify irq chip once for irq remapping
Message-ID: <20130609145457.GA2245@breakpoint.cc>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
 <1370644273-10495-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370644273-10495-3-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:30:48PM -0700, Yinghai Lu wrote:
> Current code: after irq remapping is enabled, irq_chip fields are modified
> during every irq setup.
> 	mp_register_gsi
> 		io_apic_set_pci_routing
> 			io_apic_setup_irq_pin
> 				setup_ioapic_irq
> 					ioapic_register_intr
> 						setup_remapped_irq
> 	native_setup_msi_irqs
> 		setup_msi_irq
> 			setup_remapped_irq
> 	default_setup_hpet_msi
> 		setup_remapped_irq
> that is not efficient.
> 
> We only need to modify those irq chip one time just after we enable
> irq mapping.

The overhead you talk about is calling setup_remapped_irq() for every
interrupt from the mp_register_gsi() call chain? MSI & HPET should happen only
once, or do I miss something?

> Change irq_remap_modify_chip_defaults() to __init as it only gets
> called during booting stage, via irq_remap_modify_chips().
> 
> Affected irq_chip: ioapic_chip, msi_chip, hpet_msi_type.
> We don't need to use #ifdef in irq_remap_modify_chips():
> IRQ_REMAP only support x86_64 and X86_IO_APIC and PCI_MSI.
> HPET_TIMER is set when x86_64 is set.
> When we have IRQ_REMAP enabled, al three chips are defined and
> used.

all, not al

Still, the user could disable hpet or apic from the commandline but this
should cause any harm as the irq chips shouldn't be used then.

> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 904611b..ff50b90 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1552,6 +1552,8 @@ void enable_x2apic(void)
>  int __init enable_IR(void)
>  {
>  #ifdef CONFIG_IRQ_REMAP
> +	int ret;
> +
>  	if (!irq_remapping_supported()) {
>  		pr_debug("intr-remapping not supported\n");
>  		return -1;
> @@ -1563,7 +1565,12 @@ int __init enable_IR(void)
>  		return -1;
>  	}
>  
> -	return irq_remapping_enable();
> +	ret = irq_remapping_enable();
> +
> +	if (ret >= 0)
> +		irq_remap_modify_chips();

This looks like ehm, well not well.
Could you please change this to:
	ret = irq_remapping_enable();
	if (ret)
		return ret;

	irq_remap_modify_chips();

> +
> +	return ret;
>  #endif
>  	return -1;
>  }
> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> index 07ce86a..21ef344 100644
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -373,19 +373,26 @@ static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
>  	seq_printf(p, " IR-%s", data->chip->name);
>  }
>  
> -static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
> +static void __init irq_remap_modify_chip_defaults(struct irq_chip *chip)
>  {
> +	printk(KERN_DEBUG "irq_chip: %s ==> IR-%s", chip->name, chip->name);

If you need this please use pr_debug and add a \n at the end.

>  	chip->irq_print_chip = ir_print_prefix;
>  	chip->irq_ack = ir_ack_apic_edge;
>  	chip->irq_eoi = ir_ack_apic_level;
>  	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
>  }
>  
> +void __init irq_remap_modify_chips(void)
> +{
> +	irq_remap_modify_chip_defaults(&ioapic_chip);
> +	irq_remap_modify_chip_defaults(&msi_chip);
> +	irq_remap_modify_chip_defaults(&hpet_msi_type);
> +}
> +
>  bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
>  {
>  	if (!irq_remapped(cfg))
>  		return false;
>  	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
> -	irq_remap_modify_chip_defaults(chip);

chip is not required, and can be removed.

>  	return true;
>  }

Sebastian
