Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3EUUlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:41:07 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38063 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3EUUlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:41:04 -0400
Date: Tue, 21 May 2013 14:41:00 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI: Split pci_assign_unassigned_resources to per
 root bus
Message-ID: <20130521204100.GA12440@google.com>
References: <1367837311.15842.31.camel@pasglop>
 <1367882130-19452-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367882130-19452-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 04:15:29PM -0700, Yinghai Lu wrote:
> BenH reported that there is some assign unassigned resource problem
> in powerpc.
> 
> It turns out after
> | commit 0c5be0cb0edfe3b5c4b62eac68aa2aa15ec681af
> | Date:   Thu Feb 23 19:23:29 2012 -0800
> |
> |    PCI: Retry on IORESOURCE_IO type allocations
> 
> even the root bus does not have io port range, it will keep retrying
> to realloc with mmio.
> 
> Current retry logic is : try with must+optional at first, and if
> it fails will try must then try to extend must with optional.
> That will fail as mmio-non-pref and mmio-pref for bridge will
> be next to each other. So we have no chance to extend mmio-non-pref.
> 
> We should not fall into retry in this case, as root bus does
> not io port range.
> 
> Before we do that we need to split pci_assign_unassiged_resource
> to every root bus, so we can stop early for root bus without ioport
> range, and still continue to retry on buses that do have ioport range.
> 
> This will be become more often when we have x86 8 sockets or 32 sockets
> system, and those system will have one root bus per socket.
> They will have some root buses do not have ioport range.
> 
> For the retry failing, we could allocate mmio-non-pref bottom-up
> and mmio-pref will be top-down, but that could not be material for v3.10.

If I understand correctly, this particular patch makes no functional
changes, so the changelog above should be saved for the patches that *do*
actually fix problems.

> 
> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |  101 +++++++++++++++++++++++-------------------------
>  1 file changed, 49 insertions(+), 52 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -1315,21 +1315,6 @@ static int __init pci_bus_get_depth(stru
>  
>  	return depth;
>  }
> -static int __init pci_get_max_depth(void)
> -{
> -	int depth = 0;
> -	struct pci_bus *bus;
> -
> -	list_for_each_entry(bus, &pci_root_buses, node) {
> -		int ret;
> -
> -		ret = pci_bus_get_depth(bus);
> -		if (ret > depth)
> -			depth = ret;
> -	}
> -
> -	return depth;
> -}
>  
>  /*
>   * -1: undefined, will auto detect later
> @@ -1354,34 +1339,41 @@ void __init pci_realloc_get_opt(char *st
>  	else if (!strncmp(str, "on", 2))
>  		pci_realloc_enable = user_enabled;
>  }
> -static bool __init pci_realloc_enabled(void)
> +static bool __init pci_realloc_enabled(enum enable_type enable)
>  {
> -	return pci_realloc_enable >= user_enabled;
> +	return enable >= user_enabled;
>  }
>  
> -static void __init pci_realloc_detect(void)
> +static enum enable_type __init pci_realloc_detect(struct pci_bus *bus,
> +			 enum enable_type enable_local)
>  {
>  #if defined(CONFIG_PCI_IOV) && defined(CONFIG_PCI_REALLOC_ENABLE_AUTO)
> -	struct pci_dev *dev = NULL;
> +	struct pci_dev *dev;
>  
> -	if (pci_realloc_enable != undefined)
> -		return;
> +	if (enable_local != undefined)
> +		return enable_local;
>  
> -	for_each_pci_dev(dev) {
> +	list_for_each_entry(dev, &bus->devices, bus_list) {
>  		int i;
>  
>  		for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
>  			struct resource *r = &dev->resource[i];
>  
>  			/* Not assigned, or rejected by kernel ? */
> -			if (r->flags && !r->start) {
> -				pci_realloc_enable = auto_enabled;
> -
> -				return;
> -			}
> +			if (r->flags && !r->start)
> +				return auto_enabled;
>  		}
>  	}
> +
> +	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		struct pci_bus *child = dev->subordinate;
> +
> +		if (child &&
> +		    pci_realloc_detect(child, enable_local) == auto_enabled)
> +			return auto_enabled;
> +	}

This uses recursion and basically does the same thing as pci_walk_bus().
I think it will be clearer if you make it look something like this:

        static int count_unassigned_resources(struct pci_dev *dev, void *data)
        {
          int *count = data;

          for (i = PCI_IOV_RESOURCES; ...)
            if (r->flags && !r->start)
              *count++;

          return 0;
        }

        static pci_realloc_detect(struct pci_bus *bus, ...  enable_local)
        {
	  int unassigned;

          if (enable_local != undefined)
            return enable_local;

	  unassigned = 0;
	  pci_walk_bus(bus, count_unassigned_resources, &unassigned);
	  if (unassigned)
	    return auto_enabled;

          return enable_local;
        }


>  #endif
> +	return enable_local;
>  }
>  
>  /*
> @@ -1389,10 +1381,9 @@ static void __init pci_realloc_detect(vo
>   * second  and later try will clear small leaf bridge res
>   * will stop till to the max  deepth if can not find good one
>   */
> -void __init
> -pci_assign_unassigned_resources(void)
> +static void __init
> +pci_assign_unassigned_root_bus_resources(struct pci_bus *bus)
>  {
> -	struct pci_bus *bus;
>  	LIST_HEAD(realloc_head); /* list of resources that
>  					want additional resources */
>  	struct list_head *add_list = NULL;
> @@ -1403,15 +1394,17 @@ pci_assign_unassigned_resources(void)
>  	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
>  				  IORESOURCE_PREFETCH;
>  	int pci_try_num = 1;
> +	enum enable_type enable_local;
>  
>  	/* don't realloc if asked to do so */
> -	pci_realloc_detect();
> -	if (pci_realloc_enabled()) {
> -		int max_depth = pci_get_max_depth();
> +	enable_local = pci_realloc_detect(bus, pci_realloc_enable);
> +	if (pci_realloc_enabled(enable_local)) {
> +		int max_depth = pci_bus_get_depth(bus);
>  
>  		pci_try_num = max_depth + 1;
> -		printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
> -			 max_depth, pci_try_num);
> +		dev_printk(KERN_DEBUG, &bus->dev,
> +			   "max bus depth: %d pci_try_num: %d\n",
> +			   max_depth, pci_try_num);
>  	}
>  
>  again:
> @@ -1423,12 +1416,10 @@ again:
>  		add_list = &realloc_head;
>  	/* Depth first, calculate sizes and alignments of all
>  	   subordinate buses. */
> -	list_for_each_entry(bus, &pci_root_buses, node)
> -		__pci_bus_size_bridges(bus, add_list);
> +	__pci_bus_size_bridges(bus, add_list);
>  
>  	/* Depth last, allocate resources and update the hardware. */
> -	list_for_each_entry(bus, &pci_root_buses, node)
> -		__pci_bus_assign_resources(bus, add_list, &fail_head);
> +	__pci_bus_assign_resources(bus, add_list, &fail_head);
>  	if (add_list)
>  		BUG_ON(!list_empty(add_list));
>  	tried_times++;
> @@ -1438,17 +1429,17 @@ again:
>  		goto enable_and_dump;
>  
>  	if (tried_times >= pci_try_num) {
> -		if (pci_realloc_enable == undefined)
> -			printk(KERN_INFO "Some PCI device resources are unassigned, try booting with pci=realloc\n");
> -		else if (pci_realloc_enable == auto_enabled)
> -			printk(KERN_INFO "Automatically enabled pci realloc, if you have problem, try booting with pci=realloc=off\n");
> +		if (enable_local == undefined)
> +			dev_info(&bus->dev, "Some PCI device resources are unassigned, try booting with pci=realloc\n");
> +		else if (enable_local == auto_enabled)
> +			dev_info(&bus->dev, "Automatically enabled pci realloc, if you have problem, try booting with pci=realloc=off\n");

I think you can add enable_local and the pci_realloc_enabled() parameter
in a separate patch.  That will remove distractions from the main patch.

>  
>  		free_list(&fail_head);
>  		goto enable_and_dump;
>  	}
>  
> -	printk(KERN_DEBUG "PCI: No. %d try to assign unassigned res\n",
> -			 tried_times + 1);
> +	dev_printk(KERN_DEBUG, &bus->dev,
> +		   "No. %d try to assign unassigned res\n", tried_times + 1);
>  
>  	/* third times and later will not check if it is leaf */
>  	if ((tried_times + 1) > 2)
> @@ -1458,12 +1449,11 @@ again:
>  	 * Try to release leaf bridge's resources that doesn't fit resource of
>  	 * child device under that bridge
>  	 */
> -	list_for_each_entry(fail_res, &fail_head, list) {
> -		bus = fail_res->dev->bus;
> -		pci_bus_release_bridge_resources(bus,
> +	list_for_each_entry(fail_res, &fail_head, list)
> +		pci_bus_release_bridge_resources(fail_res->dev->bus,

This change is gratuitous and distracting.  Please move it to a
separate patch.

>  						 fail_res->flags & type_mask,
>  						 rel_type);
> -	}
> +
>  	/* restore size and flags */
>  	list_for_each_entry(fail_res, &fail_head, list) {
>  		struct resource *res = fail_res->res;
> @@ -1480,12 +1470,19 @@ again:
>  
>  enable_and_dump:
>  	/* Depth last, update the hardware. */
> -	list_for_each_entry(bus, &pci_root_buses, node)
> -		pci_enable_bridges(bus);
> +	pci_enable_bridges(bus);
>  
>  	/* dump the resource on buses */
> +	pci_bus_dump_resources(bus);
> +}
> +
> +void __init
> +pci_assign_unassigned_resources(void)
> +{
> +	struct pci_bus *bus;
> +
>  	list_for_each_entry(bus, &pci_root_buses, node)
> -		pci_bus_dump_resources(bus);
> +		pci_assign_unassigned_root_bus_resources(bus);
>  }
>  
>  void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)

I think this should be split up into something like the following patches
so we can see what's going on here:

    - Remove "bus" temporary when calling pci_bus_release_bridge_resources()

    - Add pci_realloc_enabled() parameter and enable_local

    - Add pci_realloc_detect() parameters.  The "bus" parameter is 
      ignored for now.

    - Change pci_realloc_detect() to iterate over pci_root_buses and
      call pci_walk_bus() to find any unassigned resources instead of
      using for_each_pci_dev().

    - Split pci_assign_unassigned_resources() into iterating over
      pci_root_buses and calling pci_assign_unassigned_root_bus_resources(bus).
      Change pci_realloc_detect() to only walk the supplied bus instead
      of everything in pci_root_buses.  This will be basically just removing
      list_for_each_entry(bus, &pci_root_buses, node) loops.

Bjorn
