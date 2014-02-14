Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaBNVBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:01:05 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:54492 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaBNVBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:01:02 -0500
Date: Fri, 14 Feb 2014 14:00:57 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: linux-pci@vger.kernel.org
Cc: e1000-devel@lists.sourceforge.net,
        Stephen Hemminger <stephen@networkplumber.org>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Aaron F Brown <aaron.f.brown@intel.com>
Subject: Re: [PATCH 1/2] PCI: Remove unused MMIO exclusivity support
Message-ID: <20140214210057.GG31093@google.com>
References: <20140130192011.25426.45702.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140130192038.25426.8346.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130192038.25426.8346.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Aaron]

On Thu, Jan 30, 2014 at 12:20:38PM -0700, Bjorn Helgaas wrote:
> This reverts commit e8de1481fd71 ("resource: allow MMIO exclusivity for
> device drivers"), removing these exported interfaces:
> 
>   pci_request_region_exclusive()
>   pci_request_regions_exclusive()
>   pci_request_selected_regions_exclusive()
> 
> There's nothing wrong with the MMIO exclusivity code, but it is used only
> by the e1000e driver, and the only reason it's there is because it was
> added during a bug hunt.  The bug has been fixed, and apparently no other
> drivers have found it useful in the five years since then.
> 
> This is based on Stephen Hemminger's patch (see link below), but goes a bit
> further by removing the use in e1000e.
> 
> Link: http://lkml.kernel.org/r/20131227132710.7190647c@nehalam.linuxnetplumber.net
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Arjan van de Ven <arjan@linux.intel.com>
> CC: Stephen Hemminger <stephen@networkplumber.org>

I'm dropping this one for now because it's used by:

  - e1000e
  - alpha pci_mmap_resource()
  - sp5100_tco_setupdevice()

That's still sort of a marginal number of users, but in any event, it's
clear that a little more work would be required to remove it.

> ---
>  Documentation/kernel-parameters.txt        |    4 -
>  arch/x86/mm/init.c                         |    2 -
>  drivers/net/ethernet/intel/e1000e/netdev.c |    3 -
>  drivers/pci/pci-sysfs.c                    |    3 -
>  drivers/pci/pci.c                          |  112 +++-------------------------
>  include/linux/ioport.h                     |    5 -
>  include/linux/pci.h                        |    3 -
>  kernel/resource.c                          |   54 --------------
>  8 files changed, 14 insertions(+), 172 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 8f441dab0396..4943bddeacc1 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1323,10 +1323,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			no_x2apic_optout
>  				BIOS x2APIC opt-out request will be ignored
>  
> -	iomem=		Disable strict checking of access to MMIO memory
> -		strict	regions from userspace.
> -		relaxed
> -
>  	iommu=		[x86]
>  		off
>  		force
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index f97130618113..575cbfd89238 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -583,8 +583,6 @@ int devmem_is_allowed(unsigned long pagenr)
>  {
>  	if (pagenr < 256)
>  		return 1;
> -	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
> -		return 0;
>  	if (!page_is_ram(pagenr))
>  		return 1;
>  	return 0;
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 6d91933c4cdd..97a11b19e46f 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6574,8 +6574,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	}
>  
>  	bars = pci_select_bars(pdev, IORESOURCE_MEM);
> -	err = pci_request_selected_regions_exclusive(pdev, bars,
> -						     e1000e_driver_name);
> +	err = pci_request_selected_regions(pdev, bars, e1000e_driver_name);
>  	if (err)
>  		goto err_pci_reg;
>  
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 276ef9c18802..4580fa859f38 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -993,9 +993,6 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
>  	vma->vm_pgoff += start >> PAGE_SHIFT;
>  	mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;
>  
> -	if (res->flags & IORESOURCE_MEM && iomem_is_exclusive(start))
> -		return -EINVAL;
> -
>  	return pci_mmap_page_range(pdev, vma, mmap_type, write_combine);
>  }
>  
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 1febe90831b4..1011c0b281ca 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2432,26 +2432,20 @@ void pci_release_region(struct pci_dev *pdev, int bar)
>  }
>  
>  /**
> - *	__pci_request_region - Reserved PCI I/O and memory resource
> + *	pci_request_region - Reserved PCI I/O and memory resource
>   *	@pdev: PCI device whose resources are to be reserved
>   *	@bar: BAR to be reserved
>   *	@res_name: Name to be associated with resource.
> - *	@exclusive: whether the region access is exclusive or not
>   *
>   *	Mark the PCI region associated with PCI device @pdev BR @bar as
>   *	being reserved by owner @res_name.  Do not access any
>   *	address inside the PCI regions unless this call returns
>   *	successfully.
>   *
> - *	If @exclusive is set, then the region is marked so that userspace
> - *	is explicitly not allowed to map the resource via /dev/mem or
> - *	sysfs MMIO access.
> - *
>   *	Returns 0 on success, or %EBUSY on error.  A warning
>   *	message is also printed on failure.
>   */
> -static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_name,
> -									int exclusive)
> +int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
>  {
>  	struct pci_devres *dr;
>  
> @@ -2464,9 +2458,8 @@ static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_n
>  			goto err_out;
>  	}
>  	else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
> -		if (!__request_mem_region(pci_resource_start(pdev, bar),
> -					pci_resource_len(pdev, bar), res_name,
> -					exclusive))
> +		if (!request_mem_region(pci_resource_start(pdev, bar),
> +					pci_resource_len(pdev, bar), res_name))
>  			goto err_out;
>  	}
>  
> @@ -2483,47 +2476,6 @@ err_out:
>  }
>  
>  /**
> - *	pci_request_region - Reserve PCI I/O and memory resource
> - *	@pdev: PCI device whose resources are to be reserved
> - *	@bar: BAR to be reserved
> - *	@res_name: Name to be associated with resource
> - *
> - *	Mark the PCI region associated with PCI device @pdev BAR @bar as
> - *	being reserved by owner @res_name.  Do not access any
> - *	address inside the PCI regions unless this call returns
> - *	successfully.
> - *
> - *	Returns 0 on success, or %EBUSY on error.  A warning
> - *	message is also printed on failure.
> - */
> -int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
> -{
> -	return __pci_request_region(pdev, bar, res_name, 0);
> -}
> -
> -/**
> - *	pci_request_region_exclusive - Reserved PCI I/O and memory resource
> - *	@pdev: PCI device whose resources are to be reserved
> - *	@bar: BAR to be reserved
> - *	@res_name: Name to be associated with resource.
> - *
> - *	Mark the PCI region associated with PCI device @pdev BR @bar as
> - *	being reserved by owner @res_name.  Do not access any
> - *	address inside the PCI regions unless this call returns
> - *	successfully.
> - *
> - *	Returns 0 on success, or %EBUSY on error.  A warning
> - *	message is also printed on failure.
> - *
> - *	The key difference that _exclusive makes it that userspace is
> - *	explicitly not allowed to map the resource via /dev/mem or
> - *	sysfs.
> - */
> -int pci_request_region_exclusive(struct pci_dev *pdev, int bar, const char *res_name)
> -{
> -	return __pci_request_region(pdev, bar, res_name, IORESOURCE_EXCLUSIVE);
> -}
> -/**
>   * pci_release_selected_regions - Release selected PCI I/O and memory resources
>   * @pdev: PCI device whose resources were previously reserved
>   * @bars: Bitmask of BARs to be released
> @@ -2540,14 +2492,20 @@ void pci_release_selected_regions(struct pci_dev *pdev, int bars)
>  			pci_release_region(pdev, i);
>  }
>  
> -static int __pci_request_selected_regions(struct pci_dev *pdev, int bars,
> -				 const char *res_name, int excl)
> +/**
> + * pci_request_selected_regions - Reserve selected PCI I/O and memory resources
> + * @pdev: PCI device whose resources are to be reserved
> + * @bars: Bitmask of BARs to be requested
> + * @res_name: Name to be associated with resource
> + */
> +int pci_request_selected_regions(struct pci_dev *pdev, int bars,
> +				 const char *res_name)
>  {
>  	int i;
>  
>  	for (i = 0; i < 6; i++)
>  		if (bars & (1 << i))
> -			if (__pci_request_region(pdev, i, res_name, excl))
> +			if (pci_request_region(pdev, i, res_name))
>  				goto err_out;
>  	return 0;
>  
> @@ -2561,25 +2519,6 @@ err_out:
>  
>  
>  /**
> - * pci_request_selected_regions - Reserve selected PCI I/O and memory resources
> - * @pdev: PCI device whose resources are to be reserved
> - * @bars: Bitmask of BARs to be requested
> - * @res_name: Name to be associated with resource
> - */
> -int pci_request_selected_regions(struct pci_dev *pdev, int bars,
> -				 const char *res_name)
> -{
> -	return __pci_request_selected_regions(pdev, bars, res_name, 0);
> -}
> -
> -int pci_request_selected_regions_exclusive(struct pci_dev *pdev,
> -				 int bars, const char *res_name)
> -{
> -	return __pci_request_selected_regions(pdev, bars, res_name,
> -			IORESOURCE_EXCLUSIVE);
> -}
> -
> -/**
>   *	pci_release_regions - Release reserved PCI I/O and memory resources
>   *	@pdev: PCI device whose resources were previously reserved by pci_request_regions
>   *
> @@ -2611,28 +2550,6 @@ int pci_request_regions(struct pci_dev *pdev, const char *res_name)
>  	return pci_request_selected_regions(pdev, ((1 << 6) - 1), res_name);
>  }
>  
> -/**
> - *	pci_request_regions_exclusive - Reserved PCI I/O and memory resources
> - *	@pdev: PCI device whose resources are to be reserved
> - *	@res_name: Name to be associated with resource.
> - *
> - *	Mark all PCI regions associated with PCI device @pdev as
> - *	being reserved by owner @res_name.  Do not access any
> - *	address inside the PCI regions unless this call returns
> - *	successfully.
> - *
> - *	pci_request_regions_exclusive() will mark the region so that
> - *	/dev/mem and the sysfs MMIO access will not be allowed.
> - *
> - *	Returns 0 on success, or %EBUSY on error.  A warning
> - *	message is also printed on failure.
> - */
> -int pci_request_regions_exclusive(struct pci_dev *pdev, const char *res_name)
> -{
> -	return pci_request_selected_regions_exclusive(pdev,
> -					((1 << 6) - 1), res_name);
> -}
> -
>  static void __pci_set_master(struct pci_dev *dev, bool enable)
>  {
>  	u16 old_cmd, cmd;
> @@ -4387,13 +4304,10 @@ EXPORT_SYMBOL(pci_find_capability);
>  EXPORT_SYMBOL(pci_bus_find_capability);
>  EXPORT_SYMBOL(pci_release_regions);
>  EXPORT_SYMBOL(pci_request_regions);
> -EXPORT_SYMBOL(pci_request_regions_exclusive);
>  EXPORT_SYMBOL(pci_release_region);
>  EXPORT_SYMBOL(pci_request_region);
> -EXPORT_SYMBOL(pci_request_region_exclusive);
>  EXPORT_SYMBOL(pci_release_selected_regions);
>  EXPORT_SYMBOL(pci_request_selected_regions);
> -EXPORT_SYMBOL(pci_request_selected_regions_exclusive);
>  EXPORT_SYMBOL(pci_set_master);
>  EXPORT_SYMBOL(pci_clear_master);
>  EXPORT_SYMBOL(pci_set_mwi);
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 89b7c24a36e9..f2d45ea3ee53 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -49,7 +49,6 @@ struct resource {
>  #define IORESOURCE_WINDOW	0x00200000	/* forwarded by bridge */
>  #define IORESOURCE_MUXED	0x00400000	/* Resource is software muxed */
>  
> -#define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resource */
>  #define IORESOURCE_DISABLED	0x10000000
>  #define IORESOURCE_UNSET	0x20000000
>  #define IORESOURCE_AUTO		0x40000000
> @@ -173,10 +172,7 @@ static inline unsigned long resource_type(const struct resource *res)
>  /* Convenience shorthand with allocation */
>  #define request_region(start,n,name)		__request_region(&ioport_resource, (start), (n), (name), 0)
>  #define request_muxed_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name), IORESOURCE_MUXED)
> -#define __request_mem_region(start,n,name, excl) __request_region(&iomem_resource, (start), (n), (name), excl)
>  #define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 0)
> -#define request_mem_region_exclusive(start,n,name) \
> -	__request_region(&iomem_resource, (start), (n), (name), IORESOURCE_EXCLUSIVE)
>  #define rename_region(region, newname) do { (region)->name = (newname); } while (0)
>  
>  extern struct resource * __request_region(struct resource *,
> @@ -222,7 +218,6 @@ extern struct resource * __devm_request_region(struct device *dev,
>  extern void __devm_release_region(struct device *dev, struct resource *parent,
>  				  resource_size_t start, resource_size_t n);
>  extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
> -extern int iomem_is_exclusive(u64 addr);
>  
>  extern int
>  walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index fb57c892b214..b3cd9d58f5a9 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1038,13 +1038,10 @@ void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
>  		    int (*)(const struct pci_dev *, u8, u8));
>  #define HAVE_PCI_REQ_REGIONS	2
>  int __must_check pci_request_regions(struct pci_dev *, const char *);
> -int __must_check pci_request_regions_exclusive(struct pci_dev *, const char *);
>  void pci_release_regions(struct pci_dev *);
>  int __must_check pci_request_region(struct pci_dev *, int, const char *);
> -int __must_check pci_request_region_exclusive(struct pci_dev *, int, const char *);
>  void pci_release_region(struct pci_dev *, int);
>  int pci_request_selected_regions(struct pci_dev *, int, const char *);
> -int pci_request_selected_regions_exclusive(struct pci_dev *, int, const char *);
>  void pci_release_selected_regions(struct pci_dev *, int);
>  
>  /* drivers/pci/bus.c */
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 3f285dce9347..9a29d989aa5e 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1306,57 +1306,3 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
>  
>  	return err;
>  }
> -
> -#ifdef CONFIG_STRICT_DEVMEM
> -static int strict_iomem_checks = 1;
> -#else
> -static int strict_iomem_checks;
> -#endif
> -
> -/*
> - * check if an address is reserved in the iomem resource tree
> - * returns 1 if reserved, 0 if not reserved.
> - */
> -int iomem_is_exclusive(u64 addr)
> -{
> -	struct resource *p = &iomem_resource;
> -	int err = 0;
> -	loff_t l;
> -	int size = PAGE_SIZE;
> -
> -	if (!strict_iomem_checks)
> -		return 0;
> -
> -	addr = addr & PAGE_MASK;
> -
> -	read_lock(&resource_lock);
> -	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
> -		/*
> -		 * We can probably skip the resources without
> -		 * IORESOURCE_IO attribute?
> -		 */
> -		if (p->start >= addr + size)
> -			break;
> -		if (p->end < addr)
> -			continue;
> -		if (p->flags & IORESOURCE_BUSY &&
> -		     p->flags & IORESOURCE_EXCLUSIVE) {
> -			err = 1;
> -			break;
> -		}
> -	}
> -	read_unlock(&resource_lock);
> -
> -	return err;
> -}
> -
> -static int __init strict_iomem(char *str)
> -{
> -	if (strstr(str, "relaxed"))
> -		strict_iomem_checks = 0;
> -	if (strstr(str, "strict"))
> -		strict_iomem_checks = 1;
> -	return 1;
> -}
> -
> -__setup("iomem=", strict_iomem);
> 
