Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbaIPSce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:32:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:43701 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbaIPScc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:32:32 -0400
Date: Tue, 16 Sep 2014 11:31:45 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC Part2 v1 14/21] x86, hpet: Enhance HPET IRQ to support
 hierarchy irqdomain
In-Reply-To: <1410444228-3134-15-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409161104120.4247@nanos>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com> <1410444228-3134-15-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Jiang Liu wrote:
>  #ifdef CONFIG_HPET_TIMER
> +#define	HPET_DOMAIN_REMAPPED		0x80000000
> +
> +static inline int hpet_dev_id(struct irq_domain *domain)
> +{
> +	return (int)((long)domain->host_data & ~HPET_DOMAIN_REMAPPED);
> +}
> +
> +static inline bool hpet_remapped(struct irq_domain *domain)
> +{
> +	return (bool)((long)domain->host_data & HPET_DOMAIN_REMAPPED);
> +}

It's kinda odd to have this encoded in domain->host_data.

>  static int hpet_msi_set_affinity(struct irq_data *data,
>  				 const struct cpumask *mask, bool force)
>  {
> +	struct irq_data *parent = data->parent_data;
>  	struct irq_cfg *cfg = irqd_cfg(data);
>  	struct msi_msg msg;
> -	unsigned int dest;
>  	int ret;
>  
> -	ret = apic_set_affinity(data, mask, &dest);
> -	if (ret)
> -		return ret;
> -
> -	hpet_msi_read(data->handler_data, &msg);
> -
> -	msg.data &= ~MSI_DATA_VECTOR_MASK;
> -	msg.data |= MSI_DATA_VECTOR(cfg->vector);
> -	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
> -	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
> -
> -	hpet_msi_write(data->handler_data, &msg);
> +	ret = parent->chip->irq_set_affinity(parent, mask, force);
> +	/* No need to rewrite HPET registers if interrupt is remapped */
> +	if (ret >= 0 && !hpet_remapped(data->domain)) {

So we really should use irq_data->chip_data for this, i.e. storing

struct hpet_msi {
       struct msi_msg msg;
       bool remapped;
       /* whatever you need here */
};

> +		hpet_msi_read(data->handler_data, &msg);
> +		msg.data &= ~MSI_DATA_VECTOR_MASK;
> +		msg.data |= MSI_DATA_VECTOR(cfg->vector);
> +		msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
> +		msg.address_lo |= MSI_ADDR_DEST_ID(cfg->dest_apicid);

We need the same thing for MSI so this should be a helper function

   msi_update_msg(struct msi_msg *msg, struct irq_cfg *cfg)

> +		hpet_msi_write(data->handler_data, &msg);
> +	}
>  
> -	return IRQ_SET_MASK_OK_NOCOPY;
> +	return ret;
>  }
 
Thanks,

	tglx
