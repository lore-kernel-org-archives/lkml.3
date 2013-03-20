Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab3CTUF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:05:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50134 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab3CTUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:05:26 -0400
Date: Wed, 20 Mar 2013 21:05:21 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Murray <Andrew.Murray@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Linus Walleij <linus.walleij@linaro.org>, linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v2] of/pci: Provide support for parsing PCI DT
 ranges property
Message-ID: <20130320210521.65261e77@skate>
In-Reply-To: <20130221154709.GA26660@arm.com>
References: <20130221154709.GA26660@arm.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

What is the status of the below patch? Both Marvell PCIe driver and
Tegra PCIe driver need a way to parse the ranges = <...> property of
the PCI DT node.

Would it be possible to get this patch merged for 3.10, or get some
review comments that would allow us to rework it in time for 3.10 ?

Thanks,

Thomas

On Thu, 21 Feb 2013 15:47:09 +0000, Andrew Murray wrote:
> DT bindings for PCI host bridges often use the ranges property to describe
> memory and IO ranges - this binding tends to be the same across architectures
> yet several parsing implementations exist, e.g. arch/mips/pci/pci.c,
> arch/powerpc/kernel/pci-common.c, arch/sparc/kernel/pci.c and
> arch/microblaze/pci/pci-common.c (clone of PPC). Some of these duplicate
> functionality provided by drivers/of/address.c.
> 
> This patch factors out common implementations patterns to reduce overall kernel
> code and provide a means for host bridge drivers to directly obtain struct
> resources from the DT's ranges property without relying on architecture specific
> DT handling. This will make it easier to write archiecture independent host bridge
> drivers and mitigate against further duplication of DT parsing code.
> 
> This patch can be used in the following way:
> 
> 	struct of_pci_range_iter iter;
> 	for_each_of_pci_range(&iter, np) {
> 
> 		//directly access properties of the address range, e.g.:
> 		//iter.pci_space, iter.pci_addr, iter.cpu_addr, iter.size or
> 		//iter.flags
> 
> 		//alternatively obtain a struct resource, e.g.:
> 		//struct resource res;
> 		//range_iter_fill_resource(iter, np, res);
> 	}
> 
> Additionally the implementation takes care of adjacent ranges and merges them
> into a single range (as was the case with powerpc and microblaze).
> 
> The modifications to microblaze, mips and powerpc have not been tested.
> 
> v2:
>   - This follows on from suggestions made by Grant Likely
>     (marc.info/?l=linux-kernel&m=136079602806328)
> 
> Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> ---
>  arch/microblaze/pci/pci-common.c |  100 +++++++++++--------------------------
>  arch/mips/pci/pci.c              |   44 ++++-------------
>  arch/powerpc/kernel/pci-common.c |   93 ++++++++++-------------------------
>  drivers/of/address.c             |   54 ++++++++++++++++++++
>  include/linux/of_address.h       |   30 +++++++++++
>  5 files changed, 151 insertions(+), 170 deletions(-)
> 
> diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
> index 4dbb505..ccc0d63 100644
> --- a/arch/microblaze/pci/pci-common.c
> +++ b/arch/microblaze/pci/pci-common.c
> @@ -659,67 +659,37 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  					    struct device_node *dev,
>  					    int primary)
>  {
> -	const u32 *ranges;
> -	int rlen;
> -	int pna = of_n_addr_cells(dev);
> -	int np = pna + 5;
>  	int memno = 0, isa_hole = -1;
> -	u32 pci_space;
> -	unsigned long long pci_addr, cpu_addr, pci_next, cpu_next, size;
>  	unsigned long long isa_mb = 0;
>  	struct resource *res;
> +	struct of_pci_range_iter iter;
>  
>  	printk(KERN_INFO "PCI host bridge %s %s ranges:\n",
>  	       dev->full_name, primary ? "(primary)" : "");
>  
> -	/* Get ranges property */
> -	ranges = of_get_property(dev, "ranges", &rlen);
> -	if (ranges == NULL)
> -		return;
> -
> -	/* Parse it */
>  	pr_debug("Parsing ranges property...\n");
> -	while ((rlen -= np * 4) >= 0) {
> +	for_each_of_pci_range(&iter, dev) {
>  		/* Read next ranges element */
> -		pci_space = ranges[0];
> -		pci_addr = of_read_number(ranges + 1, 2);
> -		cpu_addr = of_translate_address(dev, ranges + 3);
> -		size = of_read_number(ranges + pna + 3, 2);
> -
>  		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx "
>  				"cpu_addr:0x%016llx size:0x%016llx\n",
> -					pci_space, pci_addr, cpu_addr, size);
> -
> -		ranges += np;
> +				iter.pci_space, iter.pci_addr, iter.cpu_addr,
> +				iter.size);
>  
>  		/* If we failed translation or got a zero-sized region
>  		 * (some FW try to feed us with non sensical zero sized regions
>  		 * such as power3 which look like some kind of attempt
>  		 * at exposing the VGA memory hole)
>  		 */
> -		if (cpu_addr == OF_BAD_ADDR || size == 0)
> +		if (iter.cpu_addr == OF_BAD_ADDR || iter.size == 0)
>  			continue;
>  
> -		/* Now consume following elements while they are contiguous */
> -		for (; rlen >= np * sizeof(u32);
> -		     ranges += np, rlen -= np * 4) {
> -			if (ranges[0] != pci_space)
> -				break;
> -			pci_next = of_read_number(ranges + 1, 2);
> -			cpu_next = of_translate_address(dev, ranges + 3);
> -			if (pci_next != pci_addr + size ||
> -			    cpu_next != cpu_addr + size)
> -				break;
> -			size += of_read_number(ranges + pna + 3, 2);
> -		}
> -
>  		/* Act based on address space type */
>  		res = NULL;
> -		switch ((pci_space >> 24) & 0x3) {
> -		case 1:		/* PCI IO space */
> +		if (iter.flags & IORESOURCE_IO) {
>  			printk(KERN_INFO
>  			       "  IO 0x%016llx..0x%016llx -> 0x%016llx\n",
> -			       cpu_addr, cpu_addr + size - 1, pci_addr);
> +			       iter.cpu_addr, iter.cpu_addr + iter.size - 1,
> +			       iter.pci_addr);
>  
>  			/* We support only one IO range */
>  			if (hose->pci_io_size) {
> @@ -728,11 +698,11 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  				continue;
>  			}
>  			/* On 32 bits, limit I/O space to 16MB */
> -			if (size > 0x01000000)
> -				size = 0x01000000;
> +			if (iter.size > 0x01000000)
> +				iter.size = 0x01000000;
>  
>  			/* 32 bits needs to map IOs here */
> -			hose->io_base_virt = ioremap(cpu_addr, size);
> +			hose->io_base_virt = ioremap(iter.cpu_addr, iter.size);
>  
>  			/* Expect trouble if pci_addr is not 0 */
>  			if (primary)
> @@ -741,20 +711,18 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  			/* pci_io_size and io_base_phys always represent IO
>  			 * space starting at 0 so we factor in pci_addr
>  			 */
> -			hose->pci_io_size = pci_addr + size;
> -			hose->io_base_phys = cpu_addr - pci_addr;
> +			hose->pci_io_size = iter.pci_addr + iter.size;
> +			hose->io_base_phys = iter.cpu_addr - iter.pci_addr;
>  
>  			/* Build resource */
>  			res = &hose->io_resource;
> -			res->flags = IORESOURCE_IO;
> -			res->start = pci_addr;
> -			break;
> -		case 2:		/* PCI Memory space */
> -		case 3:		/* PCI 64 bits Memory space */
> +			iter.cpu_addr = iter.pci_addr;
> +		} else if (iter.flags & IORESOURCE_MEM) {
>  			printk(KERN_INFO
>  			       " MEM 0x%016llx..0x%016llx -> 0x%016llx %s\n",
> -			       cpu_addr, cpu_addr + size - 1, pci_addr,
> -			       (pci_space & 0x40000000) ? "Prefetch" : "");
> +			       iter.cpu_addr, iter.cpu_addr + iter.size - 1,
> +			       iter.pci_addr,
> +			       (iter.pci_space & 0x40000000) ? "Prefetch" : "");
>  
>  			/* We support only 3 memory ranges */
>  			if (memno >= 3) {
> @@ -763,13 +731,13 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  				continue;
>  			}
>  			/* Handles ISA memory hole space here */
> -			if (pci_addr == 0) {
> +			if (iter.pci_addr == 0) {
>  				isa_mb = cpu_addr;
>  				isa_hole = memno;
>  				if (primary || isa_mem_base == 0)
> -					isa_mem_base = cpu_addr;
> -				hose->isa_mem_phys = cpu_addr;
> -				hose->isa_mem_size = size;
> +					isa_mem_base = iter.cpu_addr;
> +				hose->isa_mem_phys = iter.cpu_addr;
> +				hose->isa_mem_size = iter.size;
>  			}
>  
>  			/* We get the PCI/Mem offset from the first range or
> @@ -777,11 +745,13 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  			 * hole. If they don't match, bugger.
>  			 */
>  			if (memno == 0 ||
> -			    (isa_hole >= 0 && pci_addr != 0 &&
> +			    (isa_hole >= 0 && iter.pci_addr != 0 &&
>  			     hose->pci_mem_offset == isa_mb))
> -				hose->pci_mem_offset = cpu_addr - pci_addr;
> -			else if (pci_addr != 0 &&
> -				 hose->pci_mem_offset != cpu_addr - pci_addr) {
> +				hose->pci_mem_offset = iter.cpu_addr
> +							- iter.pci_addr;
> +			else if (iter.pci_addr != 0 &&
> +				 hose->pci_mem_offset != iter.cpu_addr
> +							- iter.pci_addr) {
>  				printk(KERN_INFO
>  				       " \\--> Skipped (offset mismatch) !\n");
>  				continue;
> @@ -789,19 +759,9 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  
>  			/* Build resource */
>  			res = &hose->mem_resources[memno++];
> -			res->flags = IORESOURCE_MEM;
> -			if (pci_space & 0x40000000)
> -				res->flags |= IORESOURCE_PREFETCH;
> -			res->start = cpu_addr;
> -			break;
> -		}
> -		if (res != NULL) {
> -			res->name = dev->full_name;
> -			res->end = res->start + size - 1;
> -			res->parent = NULL;
> -			res->sibling = NULL;
> -			res->child = NULL;
>  		}
> +		if (res != NULL)
> +			range_iter_fill_resource(iter, dev, res);
>  	}
>  
>  	/* If there's an ISA hole and the pci_mem_offset is -not- matching
> diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
> index 6903568..07d3769 100644
> --- a/arch/mips/pci/pci.c
> +++ b/arch/mips/pci/pci.c
> @@ -123,51 +123,27 @@ static void __devinit pcibios_scanbus(struct pci_controller *hose)
>  void __devinit pci_load_of_ranges(struct pci_controller *hose,
>  				struct device_node *node)
>  {
> -	const __be32 *ranges;
> -	int rlen;
> -	int pna = of_n_addr_cells(node);
> -	int np = pna + 5;
> +	struct of_pci_range_iter iter;
>  
>  	pr_info("PCI host bridge %s ranges:\n", node->full_name);
> -	ranges = of_get_property(node, "ranges", &rlen);
> -	if (ranges == NULL)
> -		return;
>  	hose->of_node = node;
>  
> -	while ((rlen -= np * 4) >= 0) {
> -		u32 pci_space;
> +	for_each_of_pci_range(&iter, node) {
>  		struct resource *res = NULL;
> -		u64 addr, size;
> -
> -		pci_space = be32_to_cpup(&ranges[0]);
> -		addr = of_translate_address(node, ranges + 3);
> -		size = of_read_number(ranges + pna + 3, 2);
> -		ranges += np;
> -		switch ((pci_space >> 24) & 0x3) {
> -		case 1:		/* PCI IO space */
> +
> +		if (iter.flags & IORESOURCE_IO) {
>  			pr_info("  IO 0x%016llx..0x%016llx\n",
> -					addr, addr + size - 1);
> +					iter.addr, iter.addr + iter.size - 1);
>  			hose->io_map_base =
> -				(unsigned long)ioremap(addr, size);
> +				(unsigned long)ioremap(iter.addr, iter.size);
>  			res = hose->io_resource;
> -			res->flags = IORESOURCE_IO;
> -			break;
> -		case 2:		/* PCI Memory space */
> -		case 3:		/* PCI 64 bits Memory space */
> +		} else if (iter.flags & IORESOURCE_MEM) {
>  			pr_info(" MEM 0x%016llx..0x%016llx\n",
> -					addr, addr + size - 1);
> +					iter.addr, iter.addr + iter.size - 1);
>  			res = hose->mem_resource;
> -			res->flags = IORESOURCE_MEM;
> -			break;
> -		}
> -		if (res != NULL) {
> -			res->start = addr;
> -			res->name = node->full_name;
> -			res->end = res->start + size - 1;
> -			res->parent = NULL;
> -			res->sibling = NULL;
> -			res->child = NULL;
>  		}
> +		if (res != NULL)
> +			range_iter_fill_resource(iter, node, res);
>  	}
>  }
>  #endif
> diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> index 2aa04f2..c6cd4e0 100644
> --- a/arch/powerpc/kernel/pci-common.c
> +++ b/arch/powerpc/kernel/pci-common.c
> @@ -657,61 +657,31 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  					    struct device_node *dev,
>  					    int primary)
>  {
> -	const u32 *ranges;
> -	int rlen;
> -	int pna = of_n_addr_cells(dev);
> -	int np = pna + 5;
>  	int memno = 0, isa_hole = -1;
> -	u32 pci_space;
> -	unsigned long long pci_addr, cpu_addr, pci_next, cpu_next, size;
>  	unsigned long long isa_mb = 0;
>  	struct resource *res;
> +	struct of_pci_range_iter iter;
>  
>  	printk(KERN_INFO "PCI host bridge %s %s ranges:\n",
>  	       dev->full_name, primary ? "(primary)" : "");
>  
> -	/* Get ranges property */
> -	ranges = of_get_property(dev, "ranges", &rlen);
> -	if (ranges == NULL)
> -		return;
> -
>  	/* Parse it */
> -	while ((rlen -= np * 4) >= 0) {
> -		/* Read next ranges element */
> -		pci_space = ranges[0];
> -		pci_addr = of_read_number(ranges + 1, 2);
> -		cpu_addr = of_translate_address(dev, ranges + 3);
> -		size = of_read_number(ranges + pna + 3, 2);
> -		ranges += np;
> -
> +	for_each_of_pci_range(&iter, dev) {
>  		/* If we failed translation or got a zero-sized region
>  		 * (some FW try to feed us with non sensical zero sized regions
>  		 * such as power3 which look like some kind of attempt at exposing
>  		 * the VGA memory hole)
>  		 */
> -		if (cpu_addr == OF_BAD_ADDR || size == 0)
> +		if (iter.cpu_addr == OF_BAD_ADDR || iter.size == 0)
>  			continue;
>  
> -		/* Now consume following elements while they are contiguous */
> -		for (; rlen >= np * sizeof(u32);
> -		     ranges += np, rlen -= np * 4) {
> -			if (ranges[0] != pci_space)
> -				break;
> -			pci_next = of_read_number(ranges + 1, 2);
> -			cpu_next = of_translate_address(dev, ranges + 3);
> -			if (pci_next != pci_addr + size ||
> -			    cpu_next != cpu_addr + size)
> -				break;
> -			size += of_read_number(ranges + pna + 3, 2);
> -		}
> -
>  		/* Act based on address space type */
>  		res = NULL;
> -		switch ((pci_space >> 24) & 0x3) {
> -		case 1:		/* PCI IO space */
> +		if (iter.flags & IORESOURCE_IO) {
>  			printk(KERN_INFO
>  			       "  IO 0x%016llx..0x%016llx -> 0x%016llx\n",
> -			       cpu_addr, cpu_addr + size - 1, pci_addr);
> +			       iter.cpu_addr, iter.cpu_addr + iter.size - 1,
> +			       iter.pci_addr);
>  
>  			/* We support only one IO range */
>  			if (hose->pci_io_size) {
> @@ -721,11 +691,11 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  			}
>  #ifdef CONFIG_PPC32
>  			/* On 32 bits, limit I/O space to 16MB */
> -			if (size > 0x01000000)
> -				size = 0x01000000;
> +			if (iter.size > 0x01000000)
> +				iter.size = 0x01000000;
>  
>  			/* 32 bits needs to map IOs here */
> -			hose->io_base_virt = ioremap(cpu_addr, size);
> +			hose->io_base_virt = ioremap(iter.cpu_addr, iter.size);
>  
>  			/* Expect trouble if pci_addr is not 0 */
>  			if (primary)
> @@ -735,20 +705,18 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  			/* pci_io_size and io_base_phys always represent IO
>  			 * space starting at 0 so we factor in pci_addr
>  			 */
> -			hose->pci_io_size = pci_addr + size;
> -			hose->io_base_phys = cpu_addr - pci_addr;
> +			hose->pci_io_size = iter.pci_addr + iter.size;
> +			hose->io_base_phys = iter.cpu_addr - iter.pci_addr;
>  
>  			/* Build resource */
>  			res = &hose->io_resource;
> -			res->flags = IORESOURCE_IO;
> -			res->start = pci_addr;
> -			break;
> -		case 2:		/* PCI Memory space */
> -		case 3:		/* PCI 64 bits Memory space */
> +			iter.cpu_addr = iter.pci_addr;
> +		} else if (flags & IORESOURCE_MEM) {
>  			printk(KERN_INFO
>  			       " MEM 0x%016llx..0x%016llx -> 0x%016llx %s\n",
> -			       cpu_addr, cpu_addr + size - 1, pci_addr,
> -			       (pci_space & 0x40000000) ? "Prefetch" : "");
> +			       iter.cpu_addr, iter.cpu_addr + iter.size - 1,
> +			       iter.pci_addr,
> +			       (iter.pci_space & 0x40000000) ? "Prefetch" : "");
>  
>  			/* We support only 3 memory ranges */
>  			if (memno >= 3) {
> @@ -757,13 +725,13 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  				continue;
>  			}
>  			/* Handles ISA memory hole space here */
> -			if (pci_addr == 0) {
> +			if (iter.pci_addr == 0) {
>  				isa_mb = cpu_addr;
>  				isa_hole = memno;
>  				if (primary || isa_mem_base == 0)
> -					isa_mem_base = cpu_addr;
> -				hose->isa_mem_phys = cpu_addr;
> -				hose->isa_mem_size = size;
> +					isa_mem_base = iter.cpu_addr;
> +				hose->isa_mem_phys = iter.cpu_addr;
> +				hose->isa_mem_size = iter.size;
>  			}
>  
>  			/* We get the PCI/Mem offset from the first range or
> @@ -771,11 +739,13 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  			 * hole. If they don't match, bugger.
>  			 */
>  			if (memno == 0 ||
> -			    (isa_hole >= 0 && pci_addr != 0 &&
> +			    (isa_hole >= 0 && iter.pci_addr != 0 &&
>  			     hose->pci_mem_offset == isa_mb))
> -				hose->pci_mem_offset = cpu_addr - pci_addr;
> +				hose->pci_mem_offset = iter.cpu_addr -
> +							iter.pci_addr;
>  			else if (pci_addr != 0 &&
> -				 hose->pci_mem_offset != cpu_addr - pci_addr) {
> +				 hose->pci_mem_offset != iter.cpu_addr -
> +							iter.pci_addr) {
>  				printk(KERN_INFO
>  				       " \\--> Skipped (offset mismatch) !\n");
>  				continue;
> @@ -783,19 +753,10 @@ void __devinit pci_process_bridge_OF_ranges(struct pci_controller *hose,
>  
>  			/* Build resource */
>  			res = &hose->mem_resources[memno++];
> -			res->flags = IORESOURCE_MEM;
> -			if (pci_space & 0x40000000)
> -				res->flags |= IORESOURCE_PREFETCH;
> -			res->start = cpu_addr;
>  			break;
>  		}
> -		if (res != NULL) {
> -			res->name = dev->full_name;
> -			res->end = res->start + size - 1;
> -			res->parent = NULL;
> -			res->sibling = NULL;
> -			res->child = NULL;
> -		}
> +		if (res != NULL)
> +			range_iter_fill_resource(iter, dev, res);
>  	}
>  
>  	/* If there's an ISA hole and the pci_mem_offset is -not- matching
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 7e262a6..726899b 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -219,6 +219,60 @@ int of_pci_address_to_resource(struct device_node *dev, int bar,
>  	return __of_address_to_resource(dev, addrp, size, flags, NULL, r);
>  }
>  EXPORT_SYMBOL_GPL(of_pci_address_to_resource);
> +
> +struct of_pci_range_iter *of_pci_process_ranges(struct of_pci_range_iter *iter,
> +						struct device_node *node)
> +{
> +	const int na = 3, ns = 2;
> +	int rlen;
> +
> +	if (!iter->range) {
> +		iter->pna = of_n_addr_cells(node);
> +		iter->np = iter->pna + na + ns;
> +
> +		iter->range = of_get_property(node, "ranges", &rlen);
> +		if (iter->range == NULL)
> +			return NULL;
> +
> +		iter->end = iter->range + rlen / sizeof(__be32);
> +	}
> +
> +	if (iter->range + iter->np > iter->end)
> +		return NULL;
> +
> +	iter->pci_space = be32_to_cpup(iter->range);
> +	iter->flags = of_bus_pci_get_flags(iter->range);
> +	iter->pci_addr = of_read_number(iter->range + 1, ns);
> +	iter->cpu_addr = of_translate_address(node, iter->range + na);
> +	iter->size = of_read_number(iter->range + iter->pna + na, ns);
> +
> +	iter->range += iter->np;
> +
> +	/* Now consume following elements while they are contiguous */
> +	while (iter->range + iter->np <= iter->end) {
> +		u32 flags, pci_space;
> +		u64 pci_addr, cpu_addr, size;
> +
> +		pci_space = be32_to_cpup(iter->range);
> +		flags = of_bus_pci_get_flags(iter->range);
> +		pci_addr = of_read_number(iter->range + 1, ns);
> +		cpu_addr = of_translate_address(node, iter->range + na);
> +		size = of_read_number(iter->range + iter->pna + na, ns);
> +
> +		if (flags != iter->flags)
> +			break;
> +		if (pci_addr != iter->pci_addr + iter->size ||
> +		    cpu_addr != iter->cpu_addr + iter->size)
> +			break;
> +
> +		iter->size += size;
> +		iter->range += iter->np;
> +	}
> +
> +	return iter;
> +}
> +EXPORT_SYMBOL_GPL(of_pci_process_ranges);
> +
>  #endif /* CONFIG_PCI */
>  
>  /*
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 01b925a..15f91a1 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -4,6 +4,29 @@
>  #include <linux/errno.h>
>  #include <linux/of.h>
>  
> +struct of_pci_range_iter {
> +	const __be32 *range, *end;
> +	int np, pna;
> +
> +	u32 pci_space;
> +	u64 pci_addr;
> +	u64 cpu_addr;
> +	u64 size;
> +	u32 flags;
> +};
> +
> +#define for_each_of_pci_range(iter, np) \
> +	for (; of_pci_process_ranges(iter, np);)
> +
> +#define range_iter_fill_resource(iter, np, res) \
> +	do { \
> +		res->flags = iter.flags; \
> +		res->start = iter.cpu_addr; \
> +		res->end = iter.cpu_addr + iter.size - 1; \
> +		res->parent = res->child = res->sibling = NULL; \
> +		res->name = np->full_name; \
> +	} while (0)
> +
>  #ifdef CONFIG_OF_ADDRESS
>  extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
>  extern int of_address_to_resource(struct device_node *dev, int index,
> @@ -26,6 +49,8 @@ static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
>  #define pci_address_to_pio pci_address_to_pio
>  #endif
>  
> +struct of_pci_range_iter *of_pci_process_ranges(struct of_pci_range_iter *iter,
> +						struct device_node *node);
>  #else /* CONFIG_OF_ADDRESS */
>  static inline int of_address_to_resource(struct device_node *dev, int index,
>  					 struct resource *r)
> @@ -48,6 +73,11 @@ static inline const u32 *of_get_address(struct device_node *dev, int index,
>  {
>  	return NULL;
>  }
> +struct of_pci_range_iter *of_pci_process_ranges(struct of_pci_range_iter *iter,
> +						struct device_node *node)
> +{
> +	return NULL;
> +}
>  #endif /* CONFIG_OF_ADDRESS */
>  
>  



-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
