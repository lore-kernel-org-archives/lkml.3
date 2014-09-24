Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaIXRbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:31:17 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37220 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaIXRbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:31:14 -0400
Date: Wed, 24 Sep 2014 11:31:09 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
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
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Robert Richter <rrichter@cavium.com>
Subject: Re: [PATCH v12 09/12] OF: PCI: Add support for parsing PCI host
 bridge resources from DT
Message-ID: <20140924173109.GA20416@google.com>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
 <1411498874-9864-10-git-send-email-Liviu.Dudau@arm.com>
 <20140924164304.GF1994@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924164304.GF1994@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 05:43:04PM +0100, Liviu Dudau wrote:
> Provide a function to parse the PCI DT ranges that can be used to
> create a pci_host_bridge structure together with its associated
> bus.
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> [make io_base parameter optional]
> Signed-off-by: Robert Richter <rrichter@cavium.com>
> ---
> Hi Bjorn,
> 
> I have fixed the compilation error that this patch was triggering. I
> have validated that the patch applies to your pci/host-generic branch
> as well as to my series.

I applied this to pci/host-generic along with the following patches and
pushed the branch, thanks!

Bjorn

>  drivers/of/of_pci.c    | 117 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_pci.h |   6 +++
>  2 files changed, 123 insertions(+)
> 
> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> index 82d172f..3cad1af 100644
> --- a/drivers/of/of_pci.c
> +++ b/drivers/of/of_pci.c
> @@ -1,7 +1,9 @@
>  #include <linux/kernel.h>
>  #include <linux/export.h>
>  #include <linux/of.h>
> +#include <linux/of_address.h>
>  #include <linux/of_pci.h>
> +#include <linux/slab.h>
>  
>  static inline int __of_pci_pci_compare(struct device_node *node,
>  				       unsigned int data)
> @@ -114,6 +116,121 @@ int of_get_pci_domain_nr(struct device_node *node)
>  }
>  EXPORT_SYMBOL_GPL(of_get_pci_domain_nr);
>  
> +#if defined(CONFIG_OF_ADDRESS)
> +/**
> + * of_pci_get_host_bridge_resources - Parse PCI host bridge resources from DT
> + * @dev: device node of the host bridge having the range property
> + * @busno: bus number associated with the bridge root bus
> + * @bus_max: maximum number of busses for this bridge
> + * @resources: list where the range of resources will be added after DT parsing
> + * @io_base: pointer to a variable that will contain on return the physical
> + * address for the start of the I/O range. Can be NULL if the caller doesn't
> + * expect IO ranges to be present in the device tree.
> + *
> + * It is the callers job to free the @resources list.
> + *
> + * This function will parse the "ranges" property of a PCI host bridge device
> + * node and setup the resource mapping based on its content. It is expected
> + * that the property conforms with the Power ePAPR document.
> + *
> + * It returns zero if the range parsing has been successful or a standard error
> + * value if it failed.
> + */
> +int of_pci_get_host_bridge_resources(struct device_node *dev,
> +			unsigned char busno, unsigned char bus_max,
> +			struct list_head *resources, resource_size_t *io_base)
> +{
> +	struct resource *res;
> +	struct resource *bus_range;
> +	struct of_pci_range range;
> +	struct of_pci_range_parser parser;
> +	char range_type[4];
> +	int err;
> +
> +	if (io_base)
> +		*io_base = (resource_size_t)OF_BAD_ADDR;
> +
> +	bus_range = kzalloc(sizeof(*bus_range), GFP_KERNEL);
> +	if (!bus_range)
> +		return -ENOMEM;
> +
> +	pr_info("PCI host bridge %s ranges:\n", dev->full_name);
> +
> +	err = of_pci_parse_bus_range(dev, bus_range);
> +	if (err) {
> +		bus_range->start = busno;
> +		bus_range->end = bus_max;
> +		bus_range->flags = IORESOURCE_BUS;
> +		pr_info("  No bus range found for %s, using %pR\n",
> +			dev->full_name, bus_range);
> +	} else {
> +		if (bus_range->end > bus_range->start + bus_max)
> +			bus_range->end = bus_range->start + bus_max;
> +	}
> +	pci_add_resource(resources, bus_range);
> +
> +	/* Check for ranges property */
> +	err = of_pci_range_parser_init(&parser, dev);
> +	if (err)
> +		goto parse_failed;
> +
> +	pr_debug("Parsing ranges property...\n");
> +	for_each_of_pci_range(&parser, &range) {
> +		/* Read next ranges element */
> +		if ((range.flags & IORESOURCE_TYPE_BITS) == IORESOURCE_IO)
> +			snprintf(range_type, 4, " IO");
> +		else if ((range.flags & IORESOURCE_TYPE_BITS) == IORESOURCE_MEM)
> +			snprintf(range_type, 4, "MEM");
> +		else
> +			snprintf(range_type, 4, "err");
> +		pr_info("  %s %#010llx..%#010llx -> %#010llx\n", range_type,
> +			range.cpu_addr, range.cpu_addr + range.size - 1,
> +			range.pci_addr);
> +
> +		/*
> +		 * If we failed translation or got a zero-sized region
> +		 * then skip this range
> +		 */
> +		if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
> +			continue;
> +
> +		res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> +		if (!res) {
> +			err = -ENOMEM;
> +			goto parse_failed;
> +		}
> +
> +		err = of_pci_range_to_resource(&range, dev, res);
> +		if (err)
> +			goto conversion_failed;
> +
> +		if (resource_type(res) == IORESOURCE_IO) {
> +			if (!io_base) {
> +				pr_err("I/O range found for %s. Please provide an io_base pointer to save CPU base address\n",
> +					dev->full_name);
> +				err = -EINVAL;
> +				goto conversion_failed;
> +			}
> +			if (*io_base != (resource_size_t)OF_BAD_ADDR)
> +				pr_warn("More than one I/O resource converted for %s. CPU base address for old range lost!\n",
> +					dev->full_name);
> +			*io_base = range.cpu_addr;
> +		}
> +
> +		pci_add_resource_offset(resources, res,	res->start - range.pci_addr);
> +	}
> +
> +	return 0;
> +
> +conversion_failed:
> +	kfree(res);
> +parse_failed:
> +	pci_free_resource_list(resources);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(of_pci_get_host_bridge_resources);
> +#endif /* CONFIG_OF_ADDRESS */
> +
>  #ifdef CONFIG_PCI_MSI
>  
>  static LIST_HEAD(of_pci_msi_chip_list);
> diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
> index 71062e9..1fd207e 100644
> --- a/include/linux/of_pci.h
> +++ b/include/linux/of_pci.h
> @@ -52,6 +52,12 @@ of_get_pci_domain_nr(struct device_node *node)
>  }
>  #endif
>  
> +#if defined(CONFIG_OF_ADDRESS)
> +int of_pci_get_host_bridge_resources(struct device_node *dev,
> +			unsigned char busno, unsigned char bus_max,
> +			struct list_head *resources, resource_size_t *io_base);
> +#endif
> +
>  #if defined(CONFIG_OF) && defined(CONFIG_PCI_MSI)
>  int of_pci_msi_chip_add(struct msi_chip *chip);
>  void of_pci_msi_chip_remove(struct msi_chip *chip);
> -- 
> 2.1.0
> 
> 
