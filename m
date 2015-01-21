Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbbAUArv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:47:51 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60403 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751649AbbAUArt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:47:49 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Thierry Reding <treding@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Travis <travis@sgi.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [RFC Patch 17/19] resources: Move struct resource_list_entry from ACPI into resource core
Date: Wed, 21 Jan 2015 02:10:25 +0100
Message-ID: <3428063.tN1BxOoXSN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420684386-5975-18-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-18-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 08, 2015 10:33:04 AM Jiang Liu wrote:
> Currently ACPI, PCI and pnp all implement the same resource list
> management with different data structure. We need to transfer from
> one data structure into another when passing resources from one
> subsystem into another subsystem. Sp move struct resource_list_entry
> from ACPI into resource core, so it could be reused by different
> subystems and avoid the data structure conversion.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/acpi/acpi_lpss.c     |    6 +++---
>  drivers/acpi/acpi_platform.c |    2 +-
>  drivers/acpi/resource.c      |   13 ++++--------
>  drivers/dma/acpi-dma.c       |    8 +++----
>  include/linux/acpi.h         |    6 ------
>  include/linux/ioport.h       |   25 ++++++++++++++++++++++
>  kernel/resource.c            |   48 ++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 85 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 4f3febf8a589..39b548dba70b 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -333,12 +333,12 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
>  		goto err_out;
>  
>  	list_for_each_entry(rentry, &resource_list, node)
> -		if (resource_type(&rentry->res) == IORESOURCE_MEM) {
> +		if (resource_type(rentry->res) == IORESOURCE_MEM) {
>  			if (dev_desc->prv_size_override)
>  				pdata->mmio_size = dev_desc->prv_size_override;
>  			else
> -				pdata->mmio_size = resource_size(&rentry->res);
> -			pdata->mmio_base = ioremap(rentry->res.start,
> +				pdata->mmio_size = resource_size(rentry->res);
> +			pdata->mmio_base = ioremap(rentry->res->start,
>  						   pdata->mmio_size);
>  			break;
>  		}
> diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
> index 6ba8beb6b9d2..238e32b9cbb0 100644
> --- a/drivers/acpi/acpi_platform.c
> +++ b/drivers/acpi/acpi_platform.c
> @@ -71,7 +71,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
>  		}
>  		count = 0;
>  		list_for_each_entry(rentry, &resource_list, node)
> -			resources[count++] = rentry->res;
> +			resources[count++] = *rentry->res;
>  
>  		acpi_dev_free_resource_list(&resource_list);
>  	}
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index 8ea7c26d6915..c0dc038274d4 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -444,12 +444,7 @@ EXPORT_SYMBOL_GPL(acpi_dev_resource_interrupt);
>   */
>  void acpi_dev_free_resource_list(struct list_head *list)
>  {
> -	struct resource_list_entry *rentry, *re;
> -
> -	list_for_each_entry_safe(rentry, re, list, node) {
> -		list_del(&rentry->node);
> -		kfree(rentry);
> -	}
> +	resource_list_free_list(list);
>  }
>  EXPORT_SYMBOL_GPL(acpi_dev_free_resource_list);
>  
> @@ -467,14 +462,14 @@ static acpi_status acpi_dev_new_resource_entry(struct resource *r,
>  {
>  	struct resource_list_entry *rentry;
>  
> -	rentry = kmalloc(sizeof(*rentry), GFP_KERNEL);
> +	rentry = resource_list_alloc(NULL, 0);
>  	if (!rentry) {
>  		c->error = -ENOMEM;
>  		return AE_NO_MEMORY;
>  	}
> -	rentry->res = *r;
> +	*rentry->res = *r;
>  	rentry->offset = offset;
> -	list_add_tail(&rentry->node, c->list);
> +	resource_list_insert(c->list, rentry, true);
>  	c->count++;
>  	return AE_OK;
>  }
> diff --git a/drivers/dma/acpi-dma.c b/drivers/dma/acpi-dma.c
> index de361a156b34..1ce84abe0924 100644
> --- a/drivers/dma/acpi-dma.c
> +++ b/drivers/dma/acpi-dma.c
> @@ -56,10 +56,10 @@ static int acpi_dma_parse_resource_group(const struct acpi_csrt_group *grp,
>  		return 0;
>  
>  	list_for_each_entry(rentry, &resource_list, node) {
> -		if (resource_type(&rentry->res) == IORESOURCE_MEM)
> -			mem = rentry->res.start;
> -		else if (resource_type(&rentry->res) == IORESOURCE_IRQ)
> -			irq = rentry->res.start;
> +		if (resource_type(rentry->res) == IORESOURCE_MEM)
> +			mem = rentry->res->start;
> +		else if (resource_type(rentry->res) == IORESOURCE_IRQ)
> +			irq = rentry->res->start;
>  	}
>  
>  	acpi_dev_free_resource_list(&resource_list);
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 1df4a0211ae5..6d7f7edca22c 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -297,12 +297,6 @@ unsigned long acpi_dev_irq_flags(u8 triggering, u8 polarity, u8 shareable);
>  bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
>  				 struct resource *res);
>  
> -struct resource_list_entry {
> -	struct list_head node;
> -	struct resource res;
> -	resource_size_t offset;
> -};
> -
>  void acpi_dev_free_resource_list(struct list_head *list);
>  int acpi_dev_get_resources(struct acpi_device *adev, struct list_head *list,
>  			   int (*preproc)(struct acpi_resource *, void *),
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 2c5250222278..a6f4841ca40c 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -11,6 +11,7 @@
>  #ifndef __ASSEMBLY__
>  #include <linux/compiler.h>
>  #include <linux/types.h>
> +
>  /*
>   * Resources are tree-like, allowing
>   * nesting etc..
> @@ -255,6 +256,30 @@ static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
>         return (r1->start <= r2->end && r1->end >= r2->start);
>  }
>  
> +/*
> + * Common resource list management data structure and interfaces to support
> + * ACPI, PNP and PCI host bridge etc.
> + */
> +struct resource_list_entry {
> +	struct list_head	node;
> +	struct resource		*res;	/* In master (CPU) address space */
> +	resource_size_t		offset;	/* Translation offset for bridge */
> +	struct resource		__res;	/* Default storage for res */
> +};
> +
> +extern struct resource_list_entry *resource_list_alloc(struct resource *res,
> +						       size_t extra_size);
> +extern void resource_list_free(struct resource_list_entry *entry);
> +extern void resource_list_insert(struct list_head *head,
> +				 struct resource_list_entry *entry, bool tail);
> +extern void resource_list_delete(struct resource_list_entry *entry);
> +extern void resource_list_free_list(struct list_head *head);
> +
> +#define resource_list_for_each_entry(entry, list)	\
> +	list_for_each_entry((entry), (list), node)
> +
> +#define resource_list_for_each_entry_safe(entry, tmp, list)	\
> +	list_for_each_entry_safe((entry), (tmp), (list), node)
>  
>  #endif /* __ASSEMBLY__ */
>  #endif	/* _LINUX_IOPORT_H */
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 0bcebffc4e77..414183809383 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1529,6 +1529,54 @@ int iomem_is_exclusive(u64 addr)
>  	return err;
>  }
>  
> +struct resource_list_entry *resource_list_alloc(struct resource *res,
> +						size_t extra_size)

What about create_resource_list_entry()?  Less confusing surely.

> +{
> +	struct resource_list_entry *entry;
> +
> +	entry = kzalloc(sizeof(*entry) + extra_size, GFP_KERNEL);
> +	if (entry) {
> +		INIT_LIST_HEAD(&entry->node);
> +		entry->res = res ? res : &entry->__res;
> +	}
> +
> +	return entry;
> +}
> +EXPORT_SYMBOL(resource_list_alloc);
> +
> +void resource_list_free(struct resource_list_entry *entry)
> +{
> +	kfree(entry);
> +}
> +EXPORT_SYMBOL(resource_list_free);

Well, I'm not sure I like this.  The name suggests that it would free the
entire list and what's wrong with using kfree() directly on "entry" anyway?

> +
> +void resource_list_insert(struct list_head *head,
> +			  struct resource_list_entry *entry, bool tail)

I would call this resource_list_add() if anything.

Also it may be better to have two helpers, one for "add" and one for "add_tail"
(and perhaps define them as static inline?).

And why change the ordering between "head" and "entry".  That's alomost
guaranteed to confuse people.

> +{
> +	if (tail)
> +		list_add_tail(&entry->node, head);
> +	else
> +		list_add(&entry->node, head);
> +}
> +EXPORT_SYMBOL(resource_list_insert);
> +
> +void resource_list_delete(struct resource_list_entry *entry)
> +{
> +	list_del(&entry->node);
> +}
> +EXPORT_SYMBOL(resource_list_delete);

Couldn't this be a static inline)?

Or maybe we can combine the "list_del" with "kfree" in one function?

> +
> +void resource_list_free_list(struct list_head *head)
> +{
> +	struct resource_list_entry *entry, *tmp;
> +
> +	list_for_each_entry_safe(entry, tmp, head, node) {
> +		list_del(&entry->node);
> +		resource_list_free(entry);
> +	}
> +}
> +EXPORT_SYMBOL(resource_list_free_list);
> +
>  static int __init strict_iomem(char *str)
>  {
>  	if (strstr(str, "relaxed"))
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
