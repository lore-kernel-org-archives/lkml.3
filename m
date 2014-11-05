Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070AbaKEXtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:49:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:39986 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaKEXtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:49:39 -0500
Date: Thu, 6 Nov 2014 00:48:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
Subject: Re: [Patch Part2 v4 01/31] irqdomain: Introduce new interfaces to
 support hierarchy irqdomains
In-Reply-To: <1415102525-9898-2-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1411060044100.24960@nanos>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com> <1415102525-9898-2-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014, Jiang Liu wrote:
>  /* Number of irqs reserved for a legacy isa controller */
>  #define NUM_ISA_INTERRUPTS	16
> @@ -64,6 +66,16 @@ struct irq_domain_ops {
>  	int (*xlate)(struct irq_domain *d, struct device_node *node,
>  		     const u32 *intspec, unsigned int intsize,
>  		     unsigned long *out_hwirq, unsigned int *out_type);
> +
> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> +	/* extended V2 interfaces to support hierarchy irq_domains */
> +	int (*alloc)(struct irq_domain *d, unsigned int virq,
> +		     unsigned int nr_irqs, void *arg);
> +	void (*free)(struct irq_domain *d, unsigned int virq,
> +		     unsigned int nr_irqs);
> +	int (*activate)(struct irq_domain *d, struct irq_data *irq_data);
> +	int (*deactivate)(struct irq_domain *d, struct irq_data *irq_data);

Why do we have a return value here? Especially the deactivate one
makes no sense at all.

> +extern int irq_domain_activate_irq(struct irq_data *irq_data);
> +extern int irq_domain_deactivate_irq(struct irq_data *irq_data);

And here.

> @@ -178,6 +179,7 @@ int irq_startup(struct irq_desc *desc, bool resend)
>  	irq_state_clr_disabled(desc);
>  	desc->depth = 0;
>  
> +	irq_domain_activate_irq(&desc->irq_data);

We do not check it and we cannot do here AFAICT.

>  	if (desc->irq_data.chip->irq_startup) {
>  		ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
>  		irq_state_clr_masked(desc);
> @@ -199,6 +201,7 @@ void irq_shutdown(struct irq_desc *desc)
>  		desc->irq_data.chip->irq_disable(&desc->irq_data);
>  	else
>  		desc->irq_data.chip->irq_mask(&desc->irq_data);
> +	irq_domain_deactivate_irq(&desc->irq_data);

Ditto.

So the return value for irq_domain_deactivate_irq() is silly to begin
with, but also the return value for irq_domain_activate_irq() does not
really make sense. We've allocated the resources for the interrupt
already down the hierarchy chain. So there is no reason why the actual
activation should fail.

Thanks,

	tglx
