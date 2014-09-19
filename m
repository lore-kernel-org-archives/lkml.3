Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbaISUs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:48:26 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50125 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700AbaISUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:48:23 -0400
Date: Fri, 19 Sep 2014 14:48:17 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v11 02/10] PCI: Introduce helper functions to deal with
 PCI I/O ranges.
Message-ID: <20140919204817.GF19374@google.com>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
 <1411003825-21521-3-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411003825-21521-3-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 02:30:17AM +0100, Liviu Dudau wrote:
> Some architectures do not have a simple view of the PCI I/O space
> and instead use a range of CPU addresses that map to bus addresses.
> For some architectures these ranges will be expressed by OF bindings
> in a device tree file.
> 
> This patch introduces a pci_register_io_range() helper function with
> a generic implementation that can be used by such architectures to
> keep track of the I/O ranges described by the PCI bindings. If the
> PCI_IOBASE macro is not defined that signals lack of support for PCI
> and we return an error.
> 
> In order to retrieve the CPU address associated with an I/O port, a
> new helper function pci_pio_to_address() is introduced. This will
> search in the list of ranges registered with pci_register_io_range()
> and return the CPU address that corresponds to the given port.
> 
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> ---
>  drivers/of/address.c       | 100 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_address.h |   2 +
>  2 files changed, 102 insertions(+)
> 
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index e371825..2373a92 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -5,6 +5,7 @@
>  #include <linux/module.h>
>  #include <linux/of_address.h>
>  #include <linux/pci_regs.h>
> +#include <linux/slab.h>
>  #include <linux/string.h>
>  
>  /* Max address size we deal with */
> @@ -601,12 +602,111 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
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
> +#ifdef PCI_IOBASE
> +	struct io_range *range;
> +	resource_size_t allocated_size = 0;
> +
> +	/* check if the range hasn't been previously recorded */
> +	spin_lock(&io_range_lock);
> +	list_for_each_entry(range, &io_range_list, list) {
> +		if (addr >= range->start && addr + size <= range->start + size)
> +			return 0;

This returns while holding io_range_lock.

> +		allocated_size += range->size;
> +	}
> +	spin_unlock(&io_range_lock);

I think this is racy; because you drop the lock between (1) checking
whether the range is already recorded and (2) adding the range to the list,
it's still possible for two callers to add the same range.

> +	/* range not registed yet, check for available space */
> +	if (allocated_size + size - 1 > IO_SPACE_LIMIT) {
> +		/* if it's too big check if 64K space can be reserved */
> +		if (allocated_size + SZ_64K - 1 > IO_SPACE_LIMIT)
> +			return -E2BIG;
> +
> +		size = SZ_64K;
> +		pr_warn("Requested IO range too big, new size set to 64K\n");
> +	}
> +
> +	/* add the range to the list */
> +	range = kzalloc(sizeof(*range), GFP_KERNEL);
> +	if (!range)
> +		return -ENOMEM;
> +
> +	range->start = addr;
> +	range->size = size;
> +
> +	spin_lock(&io_range_lock);
> +	list_add_tail(&range->list, &io_range_list);
> +	spin_unlock(&io_range_lock);
> +#endif
> +
> +	return 0;
> +}
