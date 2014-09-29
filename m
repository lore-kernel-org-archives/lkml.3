Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaI2TVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:21:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbaI2TVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:21:40 -0400
Message-ID: <5429B0FE.4070904@redhat.com>
Date: Mon, 29 Sep 2014 13:20:30 -0600
From: Al Stone <ahs3@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-arch <linux-arch@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Device Tree ML <devicetree@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Grant Likely <grant.likely@linaro.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v13 02/12] of/pci: Add pci_register_io_range() and pci_pio_to_address()
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com> <1412000971-9242-3-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1412000971-9242-3-git-send-email-Liviu.Dudau@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 08:29 AM, Liviu Dudau wrote:
> Some architectures do not have a simple view of the PCI I/O space and
> instead use a range of CPU addresses that map to bus addresses.  For some
> architectures these ranges will be expressed by OF bindings in a device
> tree file.
> 
> This patch introduces a pci_register_io_range() helper function with a
> generic implementation that can be used by such architectures to keep track
> of the I/O ranges described by the PCI bindings.  If the PCI_IOBASE macro
> is not defined, that signals lack of support for PCI and we return an
> error.
> 
> In order to retrieve the CPU address associated with an I/O port, a new
> helper function pci_pio_to_address() is introduced.  This will search in
> the list of ranges registered with pci_register_io_range() and return the
> CPU address that corresponds to the given port.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Rob Herring <robh@kernel.org>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/of/address.c       | 109 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_address.h |   2 +
>  2 files changed, 111 insertions(+)
> 
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index e371825..758d4f0 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -5,6 +5,8 @@
>  #include <linux/module.h>
>  #include <linux/of_address.h>
>  #include <linux/pci_regs.h>
> +#include <linux/sizes.h>
> +#include <linux/slab.h>
>  #include <linux/string.h>
>  
>  /* Max address size we deal with */
> @@ -601,12 +603,119 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
>  }
>  EXPORT_SYMBOL(of_get_address);
>  
> +#ifdef PCI_IOBASE
> +struct io_range {
> +	struct list_head list;
> +	phys_addr_t start;
> +	resource_size_t size;
> +};
> +
> +static LIST_HEAD(io_range_list);
> +static DEFINE_SPINLOCK(io_range_lock);
> +#endif
> +
> +/*
> + * Record the PCI IO range (expressed as CPU physical address + size).
> + * Return a negative value if an error has occured, zero otherwise
> + */
> +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> +{
> +	int err = 0;
> +
> +#ifdef PCI_IOBASE
> +	struct io_range *range;
> +	resource_size_t allocated_size = 0;
> +
> +	/* check if the range hasn't been previously recorded */
> +	spin_lock(&io_range_lock);
> +	list_for_each_entry(range, &io_range_list, list) {
> +		if (addr >= range->start && addr + size <= range->start + size) {
> +			/* range already registered, bail out */
> +			goto end_register;
> +		}
> +		allocated_size += range->size;
> +	}
> +
> +	/* range not registed yet, check for available space */
> +	if (allocated_size + size - 1 > IO_SPACE_LIMIT) {
> +		/* if it's too big check if 64K space can be reserved */
> +		if (allocated_size + SZ_64K - 1 > IO_SPACE_LIMIT) {
> +			err = -E2BIG;
> +			goto end_register;
> +		}
> +
> +		size = SZ_64K;
> +		pr_warn("Requested IO range too big, new size set to 64K\n");
> +	}
> +
> +	/* add the range to the list */
> +	range = kzalloc(sizeof(*range), GFP_KERNEL);
> +	if (!range) {
> +		err = -ENOMEM;
> +		goto end_register;
> +	}
> +
> +	range->start = addr;
> +	range->size = size;
> +
> +	list_add_tail(&range->list, &io_range_list);
> +
> +end_register:
> +	spin_unlock(&io_range_lock);
> +#endif
> +
> +	return err;
> +}
> +
> +phys_addr_t pci_pio_to_address(unsigned long pio)
> +{
> +	phys_addr_t address = (phys_addr_t)OF_BAD_ADDR;

This reference to OF_BAD_ADDR is the only thing I'm seeing in this
patch that is DT specific.

Couldn't these helper functions be more useful if provided outside
of DT, perhaps in the PCI code instead?  I was giving some thought
to re-using them for ACPI support of PCI but don't want to have to
build DT if I'm not really going to use it.

> +#ifdef PCI_IOBASE
> +	struct io_range *range;
> +	resource_size_t allocated_size = 0;
> +
> +	if (pio > IO_SPACE_LIMIT)
> +		return address;
> +
> +	spin_lock(&io_range_lock);
> +	list_for_each_entry(range, &io_range_list, list) {
> +		if (pio >= allocated_size && pio < allocated_size + range->size) {
> +			address = range->start + pio - allocated_size;
> +			break;
> +		}
> +		allocated_size += range->size;
> +	}
> +	spin_unlock(&io_range_lock);
> +#endif
> +
> +	return address;
> +}
> +
>  unsigned long __weak pci_address_to_pio(phys_addr_t address)
>  {
> +#ifdef PCI_IOBASE
> +	struct io_range *res;
> +	resource_size_t offset = 0;
> +	unsigned long addr = -1;
> +
> +	spin_lock(&io_range_lock);
> +	list_for_each_entry(res, &io_range_list, list) {
> +		if (address >= res->start && address < res->start + res->size) {
> +			addr = res->start - address + offset;
> +			break;
> +		}
> +		offset += res->size;
> +	}
> +	spin_unlock(&io_range_lock);
> +
> +	return addr;
> +#else
>  	if (address > IO_SPACE_LIMIT)
>  		return (unsigned long)-1;
>  
>  	return (unsigned long) address;
> +#endif
>  }
>  
>  static int __of_address_to_resource(struct device_node *dev,
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index fb7b722..f8cc7da 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -55,7 +55,9 @@ extern void __iomem *of_iomap(struct device_node *device, int index);
>  extern const __be32 *of_get_address(struct device_node *dev, int index,
>  			   u64 *size, unsigned int *flags);
>  
> +extern int pci_register_io_range(phys_addr_t addr, resource_size_t size);
>  extern unsigned long pci_address_to_pio(phys_addr_t addr);
> +extern phys_addr_t pci_pio_to_address(unsigned long pio);
>  
>  extern int of_pci_range_parser_init(struct of_pci_range_parser *parser,
>  			struct device_node *node);
> 


-- 
ciao,
al
-----------------------------------
Al Stone
Software Engineer
Red Hat, Inc.
ahs3@redhat.com
-----------------------------------
