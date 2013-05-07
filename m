Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab3EGW2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 18:28:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:57885 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab3EGW2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 18:28:16 -0400
Message-ID: <1367965682.25488.26.camel@pasglop>
Subject: Re: [PATCH v3 3/5] PCI: Skip IORESOURCE_MMIO allocation for root
 bus without MMIO range
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 08 May 2013 08:28:02 +1000
In-Reply-To: <1367965054-9013-4-git-send-email-yinghai@kernel.org>
References: <1367965054-9013-1-git-send-email-yinghai@kernel.org>
	 <1367965054-9013-4-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 15:17 -0700, Yinghai Lu wrote:
> For x86 8 sockets or 32 sockets system that will have one root bus per socket,
> They may have some root buses do not have mmio non-pref range.

That seems very odd. Most device registers are non-prefetchable. I know
of no adapter today that would work in a prefetchable-only environment.

Are you sure that isn't the other way around ?

Regarding your 3.10 patches, me and Gavin will test your v3 later today
(ASAP) and will give you an Ack if they work, in which case they should
hit Linus as soon as Bjorn is comfortable with :-)

Cheers,
Ben.

> We should not fall into retry in this case, as root bus does
> not mmio non-pref range.
> 
> We check if the root bus has mmio-nonpref range, and set bus_res_type_mask,
> and pass it to assign_resources and don't add mmio-nonpref res to failed list
> for root bus that does not have mmio-nonpref range.
> So even BIOS set wrong value to pci devices and bridges will still
> get cleared.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |   32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -299,9 +299,17 @@ static void assign_requested_resources_s
>  				bool is_ioport_res_without_bus_support =
>  					 (!(bus_res_type_mask & IORESOURCE_IO)) &&
>  					 (res->flags & IORESOURCE_IO);
> +				/*
> +				 * if the failed res is mmio, but bus does
> +				 * not have io port support, don't add it
> +				 */
> +				bool is_mmio_nonpref_res_without_bus_support =
> +					 (!(bus_res_type_mask & IORESOURCE_MEM)) &&
> +					 ((res->flags & (IORESOURCE_MEM | IORESOURCE_PREFETCH)) == IORESOURCE_MEM);
>  
>  				if (!is_rom_res_not_enabled &&
> -				    !is_ioport_res_without_bus_support)
> +				    !is_ioport_res_without_bus_support &&
> +				    !is_mmio_nonpref_res_without_bus_support)
>  					add_to_list(fail_head,
>  						    dev_res->dev, res,
>  						    0 /* dont care */,
> @@ -1407,12 +1415,24 @@ static unsigned long pci_bus_res_type_ma
>  	int i;
>  	struct resource *r;
>  	unsigned long mask = 0;
> -	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> -				  IORESOURCE_PREFETCH;
>  
> -	pci_bus_for_each_resource(bus, r, i)
> -		if (r)
> -			mask |= r->flags & type_mask;
> +	pci_bus_for_each_resource(bus, r, i) {
> +		if (!r)
> +			continue;
> +
> +		if (r->flags & IORESOURCE_IO) {
> +			mask |= IORESOURCE_IO;
> +			continue;
> +		}
> +		if (r->flags & IORESOURCE_PREFETCH) {
> +			mask |= IORESOURCE_PREFETCH;
> +			continue;
> +		}
> +		if ((r->flags & (IORESOURCE_MEM | IORESOURCE_PREFETCH)) == IORESOURCE_MEM) {
> +			mask |= IORESOURCE_MEM; /* nonpref only */
> +			continue;
> +		}
> +	}
>  
>  	return mask;
>  }


