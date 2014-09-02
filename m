Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaIBDpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 23:45:45 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:63453 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaIBDpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 23:45:41 -0400
Message-ID: <54053CDD.90300@huawei.com>
Date: Tue, 2 Sep 2014 11:43:25 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>
CC: linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 03/12] PCI: Introduce helper functions to deal with
 PCI I/O ranges.
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com> <1407860725-25202-4-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1407860725-25202-4-git-send-email-Liviu.Dudau@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.54053D5B.000F,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 4f6289fe825541f5b15ceee763232f97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/13 0:25, Liviu Dudau wrote:
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
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> ---
>  drivers/of/address.c       | 95 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_address.h |  2 +
>  2 files changed, 97 insertions(+)
> 
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 5edfcb0..4dab700 100644
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
> @@ -601,12 +602,106 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
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
> +		allocated_size += range->size;
> +	}
> +	spin_unlock(&io_range_lock);
> +
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
> +	list_add_tail(&range->list, &io_range_list);

Need spin_lock() here ?

> +#endif
> +
> +	return 0;
> +}
> +
> +phys_addr_t pci_pio_to_address(unsigned long pio)
> +{
> +	phys_addr_t address = (phys_addr_t)OF_BAD_ADDR;
> +
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
> +
> +	list_for_each_entry(res, &io_range_list, list) {

And here.

> +		if (address >= res->start &&
> +			address < res->start + res->size) {
> +			return res->start - address + offset;
> +		}
> +		offset += res->size;
> +	}
> +
> +	return (unsigned long)-1;
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
> index c13b878..28e6836 100644
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
Thanks!
Yijing

