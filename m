Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab3LPIXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:23:47 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:46013 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3LPIXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:23:44 -0500
Date: Mon, 16 Dec 2013 16:23:30 +0800
From: Guo Chao <yan@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/5] PCI: Try best to allocate pref mmio 64bit above 4g
Message-ID: <20131216082329.GA4926@yanx>
References: <1386658484-15774-1-git-send-email-yinghai@kernel.org>
 <1386658484-15774-5-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386658484-15774-5-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121608-3864-0000-0000-00000B8A03C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 10:54:43PM -0800, Yinghai Lu wrote:
> When one of children resources does not support MEM_64, MEM_64 for
> bridge get reset, so pull down whole pref resource on the bridge under 4G.
> 
> If the bridge support pref mem 64, will only allocate that with pref mem64 to
> children that support it.
> For children resources if they only support pref mem 32, will allocate them
> from non pref mem instead.
> 
> If the bridge only support 32bit pref mmio, will still have all children pref
> mmio under that.
> 
> -v2: Add release bridge res support with bridge mem res for pref_mem children res.
> -v3: refresh and make it can be applied early before for_each_dev_res patchset.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Tested-by: Guo Chao <yan@linux.vnet.ibm.com>
> ---
>  drivers/pci/setup-bus.c | 133 ++++++++++++++++++++++++++++++++----------------
>  drivers/pci/setup-res.c |  14 ++++-
>  2 files changed, 101 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 7933982..843764e 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -711,12 +711,11 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
>     bus resource of a given type. Note: we intentionally skip
>     the bus resources which have already been assigned (that is,
>     have non-NULL parent resource). */
> -static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned long type)
> +static struct resource *find_free_bus_resource(struct pci_bus *bus,
> +			 unsigned long type_mask, unsigned long type)
>  {
>  	int i;
>  	struct resource *r;
> -	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> -				  IORESOURCE_PREFETCH;
> 
>  	pci_bus_for_each_resource(bus, r, i) {
>  		if (r == &ioport_resource || r == &iomem_resource)
> @@ -813,7 +812,8 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
>  		resource_size_t add_size, struct list_head *realloc_head)
>  {
>  	struct pci_dev *dev;
> -	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
> +	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO,
> +							IORESOURCE_IO);
>  	resource_size_t size = 0, size0 = 0, size1 = 0;
>  	resource_size_t children_add_size = 0;
>  	resource_size_t min_align, align;
> @@ -913,15 +913,16 @@ static inline resource_size_t calculate_mem_align(resource_size_t *aligns,
>   * guarantees that all child resources fit in this size.
>   */
>  static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
> -			 unsigned long type, resource_size_t min_size,
> -			resource_size_t add_size,
> -			struct list_head *realloc_head)
> +			 unsigned long type, unsigned long type2,
> +			 resource_size_t min_size, resource_size_t add_size,
> +			 struct list_head *realloc_head)
>  {
>  	struct pci_dev *dev;
>  	resource_size_t min_align, align, size, size0, size1;
>  	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
>  	int order, max_order;
> -	struct resource *b_res = find_free_bus_resource(bus, type);
> +	struct resource *b_res = find_free_bus_resource(bus,
> +					 mask | IORESOURCE_PREFETCH, type);
>  	unsigned int mem64_mask = 0;
>  	resource_size_t children_add_size = 0;
> 
> @@ -942,7 +943,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>  			struct resource *r = &dev->resource[i];
>  			resource_size_t r_size;
> 
> -			if (r->parent || (r->flags & mask) != type)
> +			if (r->parent || ((r->flags & mask) != type &&
> +					  (r->flags & mask) != type2))
>  				continue;
>  			r_size = resource_size(r);
>  #ifdef CONFIG_PCI_IOV
> @@ -1115,8 +1117,9 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
>  			struct list_head *realloc_head)
>  {
>  	struct pci_dev *dev;
> -	unsigned long mask, prefmask;
> +	unsigned long mask, prefmask, type2 = 0;
>  	resource_size_t additional_mem_size = 0, additional_io_size = 0;
> +	struct resource *b_res;
> 
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
>  		struct pci_bus *b = dev->subordinate;
> @@ -1161,15 +1164,31 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
>  		   has already been allocated by arch code, try
>  		   non-prefetchable range for both types of PCI memory
>  		   resources. */
> +		b_res = &bus->self->resource[PCI_BRIDGE_RESOURCES];
>  		mask = IORESOURCE_MEM;
>  		prefmask = IORESOURCE_MEM | IORESOURCE_PREFETCH;
> -		if (pbus_size_mem(bus, prefmask, prefmask,
> +		if (b_res[2].flags & IORESOURCE_MEM_64) {
> +			prefmask |= IORESOURCE_MEM_64;
> +			if (pbus_size_mem(bus, prefmask, prefmask, prefmask,
>  				  realloc_head ? 0 : additional_mem_size,
> -				  additional_mem_size, realloc_head))
> -			mask = prefmask; /* Success, size non-prefetch only. */
> -		else
> -			additional_mem_size += additional_mem_size;
> -		pbus_size_mem(bus, mask, IORESOURCE_MEM,
> +				  additional_mem_size, realloc_head)) {
> +					/* Success, size non-pref64 only. */
> +					mask = prefmask;
> +					type2 = prefmask & ~IORESOURCE_MEM_64;
> +			}
> +		}
> +		if (!type2) {
> +			prefmask &= ~IORESOURCE_MEM_64;
> +			if (pbus_size_mem(bus, prefmask, prefmask, prefmask,
> +					 realloc_head ? 0 : additional_mem_size,
> +					 additional_mem_size, realloc_head)) {
> +				/* Success, size non-prefetch only. */
> +				mask = prefmask;
> +			} else
> +				additional_mem_size += additional_mem_size;
> +			type2 = IORESOURCE_MEM;
> +		}
> +		pbus_size_mem(bus, mask, IORESOURCE_MEM, type2,
>  				realloc_head ? 0 : additional_mem_size,
>  				additional_mem_size, realloc_head);
>  		break;


64-bit non-prefetchable BARs are missed from caculation in the scheme,
causing assign failed eventually.

[    0.350882] pci 0002:00:00.0: BAR 14: assigned [mem
0x3d04080000000-0x3d04080
7fffff]
[    0.350941] pci 0002:01:00.4: BAR 2: assigned [mem
0x3d04080000000-0x3d040807fffff 64bit]
[    0.351009] pci 0002:01:00.0: BAR 0: can't assign mem (size 0x40000)
[    0.351055] pci 0002:01:00.0: BAR 6: can't assign mem pref (size
0x40000)
[    0.351101] pci 0002:01:00.1: BAR 0: can't assign mem (size 0x40000)
[    0.351148] pci 0002:01:00.1: BAR 6: can't assign mem pref (size
0x40000)
[    0.351195] pci 0002:01:00.2: BAR 0: can't assign mem (size 0x40000)
[    0.351241] pci 0002:01:00.2: BAR 6: can't assign mem pref (size
0x40000)
[    0.351286] pci 0002:01:00.3: BAR 0: can't assign mem (size 0x40000)
[    0.351335] pci 0002:01:00.3: BAR 6: can't assign mem pref (size
0x40000)
[    0.351382] pci 0002:01:00.4: BAR 0: can't assign mem (size 0x40000)
[    0.351428] pci 0002:01:00.5: BAR 0: can't assign mem (size 0x40000)
[    0.351473] pci 0002:01:00.6: BAR 0: can't assign mem (size 0x40000)
[    0.351519] pci 0002:01:00.0: BAR 4: can't assign mem (size 0x2000)
[    0.351604] pci 0002:01:00.1: BAR 4: can't assign mem (size 0x2000)
[    0.351696] pci 0002:01:00.2: BAR 4: can't assign mem (size 0x2000)
[    0.351789] pci 0002:01:00.3: BAR 4: can't assign mem (size 0x2000)
[    0.351882] pci 0002:01:00.4: BAR 4: can't assign mem (size 0x2000)
[    0.351974] pci 0002:01:00.5: BAR 4: can't assign mem (size 0x2000)
[    0.352067] pci 0002:01:00.6: BAR 4: can't assign mem (size 0x2000)


Though I remember 64-bit BAR should always be prefetchable ... ...

Will you figure out a better way to cover them or just add a 'type3' parameter?

Thanks,
Guo Chao

> @@ -1255,42 +1274,66 @@ static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
>  static void pci_bridge_release_resources(struct pci_bus *bus,
>  					  unsigned long type)
>  {
> -	int idx;
> -	bool changed = false;
> -	struct pci_dev *dev;
> +	struct pci_dev *dev = bus->self;
>  	struct resource *r;
>  	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> -				  IORESOURCE_PREFETCH;
> +				  IORESOURCE_PREFETCH | IORESOURCE_MEM_64;
> +	unsigned old_flags = 0;
> +	struct resource *b_res;
> +	int idx = 1;
> 
> -	dev = bus->self;
> -	for (idx = PCI_BRIDGE_RESOURCES; idx <= PCI_BRIDGE_RESOURCE_END;
> -	     idx++) {
> -		r = &dev->resource[idx];
> -		if ((r->flags & type_mask) != type)
> -			continue;
> -		if (!r->parent)
> -			continue;
> -		/*
> -		 * if there are children under that, we should release them
> -		 *  all
> -		 */
> -		release_child_resources(r);
> -		if (!release_resource(r)) {
> -			dev_printk(KERN_DEBUG, &dev->dev,
> -				 "resource %d %pR released\n", idx, r);
> -			/* keep the old size */
> -			r->end = resource_size(r) - 1;
> -			r->start = 0;
> -			r->flags = 0;
> -			changed = true;
> -		}
> -	}
> +	b_res = &dev->resource[PCI_BRIDGE_RESOURCES];
> +
> +	/*
> +	 *     1. if there is io port assign fail, will release bridge
> +	 *	  io port.
> +	 *     2. if there is non pref mmio assign fail, release bridge
> +	 *	  nonpref mmio.
> +	 *     3. if there is 64bit pref mmio assign fail, and bridge pref
> +	 *	  is 64bit, release bridge pref mmio.
> +	 *     4. if there is pref mmio assign fail, and bridge pref is
> +	 *	  32bit mmio, release bridge pref mmio
> +	 *     5. if there is pref mmio assign fail, and bridge pref is not
> +	 *	  assigned, release bridge nonpref mmio.
> +	 */
> +	if (type & IORESOURCE_IO)
> +		idx = 0;
> +	else if (!(type & IORESOURCE_PREFETCH))
> +		idx = 1;
> +	else if ((type & IORESOURCE_MEM_64) &&
> +		 (b_res[2].flags & IORESOURCE_MEM_64))
> +		idx = 2;
> +	else if (!(b_res[2].flags & IORESOURCE_MEM_64) &&
> +		 (b_res[2].flags & IORESOURCE_PREFETCH))
> +		idx = 2;
> +	else
> +		idx = 1;
> +
> +	r = &b_res[idx];
> +
> +	if (!r->parent)
> +		return;
> +
> +	/*
> +	 * if there are children under that, we should release them
> +	 *  all
> +	 */
> +	release_child_resources(r);
> +	if (!release_resource(r)) {
> +		type = old_flags = r->flags & type_mask;
> +		dev_printk(KERN_DEBUG, &dev->dev, "resource %d %pR released\n",
> +					PCI_BRIDGE_RESOURCES + idx, r);
> +		/* keep the old size */
> +		r->end = resource_size(r) - 1;
> +		r->start = 0;
> +		r->flags = 0;
> 
> -	if (changed) {
>  		/* avoiding touch the one without PREF */
>  		if (type & IORESOURCE_PREFETCH)
>  			type = IORESOURCE_PREFETCH;
>  		__pci_setup_bridge(bus, type);
> +		/* for next child res under same bridge */
> +		r->flags = old_flags;
>  	}
>  }
> 
> @@ -1469,7 +1512,7 @@ void pci_assign_unassigned_root_bus_resources(struct pci_bus *bus)
>  	LIST_HEAD(fail_head);
>  	struct pci_dev_resource *fail_res;
>  	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> -				  IORESOURCE_PREFETCH;
> +				  IORESOURCE_PREFETCH | IORESOURCE_MEM_64;
>  	int pci_try_num = 1;
>  	enum enable_type enable_local;
> 
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index 5c060b1..1a84f30 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -208,9 +208,21 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
> 
>  	/* First, try exact prefetching match.. */
>  	ret = pci_bus_alloc_resource(bus, res, size, align, min,
> -				     IORESOURCE_PREFETCH,
> +				     IORESOURCE_PREFETCH | IORESOURCE_MEM_64,
>  				     pcibios_align_resource, dev);
> 
> +	if (ret < 0 &&
> +	    (res->flags & (IORESOURCE_PREFETCH | IORESOURCE_MEM_64))) {
> +		/*
> +		 * That failed.
> +		 *
> +		 * Try below 4g pref
> +		 */
> +		ret = pci_bus_alloc_resource(bus, res, size, align, min,
> +					     IORESOURCE_PREFETCH,
> +					     pcibios_align_resource, dev);
> +	}
> +
>  	if (ret < 0 && (res->flags & IORESOURCE_PREFETCH)) {
>  		/*
>  		 * That failed.
> -- 
> 1.8.4
> 

