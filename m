Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaGBLW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:22:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35087 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbaGBLWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:22:24 -0400
Date: Wed, 2 Jul 2014 12:22:30 +0100
From: Will Deacon <will.deacon@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 8/9] pci: Add support for creating a generic
 host_bridge from device tree
Message-ID: <20140702112230.GL18731@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-9-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404240214-9804-9-git-send-email-Liviu.Dudau@arm.com>
Thread-Topic: [PATCH v8 8/9] pci: Add support for creating a generic
 host_bridge from device tree
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liviu,

On Tue, Jul 01, 2014 at 07:43:33PM +0100, Liviu Dudau wrote:
> Several platforms use a rather generic version of parsing
> the device tree to find the host bridge ranges. Move the common code
> into the generic PCI code and use it to create a pci_host_bridge
> structure that can be used by arch code.
> 
> Based on early attempts by Andrew Murray to unify the code.
> Used powerpc and microblaze PCI code as starting point.

I just had a quick look at this to see how it differs from the parsing in
pci-host-generic.c and there a few small differences worth discussing.

> +static int pci_host_bridge_of_get_ranges(struct device_node *dev,
> +		struct list_head *resources, resource_size_t *io_base)
> +{
> +	struct resource *res;
> +	struct of_pci_range range;
> +	struct of_pci_range_parser parser;
> +	int err;
> +
> +	pr_info("PCI host bridge %s ranges:\n", dev->full_name);
> +
> +	/* Check for ranges property */
> +	err = of_pci_range_parser_init(&parser, dev);
> +	if (err)
> +		return err;
> +
> +	pr_debug("Parsing ranges property...\n");
> +	for_each_of_pci_range(&parser, &range) {
> +		/* Read next ranges element */
> +		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx cpu_addr:0x%016llx size:0x%016llx\n",
> +			range.pci_space, range.pci_addr, range.cpu_addr, range.size);
> +
> +		/*
> +		 * If we failed translation or got a zero-sized region
> +		 * then skip this range
> +		 */
> +		if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
> +			continue;
> +
> +		res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> +		if (!res)
> +			return -ENOMEM;
> +
> +		err = of_pci_range_to_resource(&range, dev, res);
> +		if (err)
> +			return err;
> +
> +		if (resource_type(res) == IORESOURCE_IO)
> +			*io_base = range.cpu_addr;
> +
> +		pci_add_resource_offset(resources, res,
> +				res->start - range.pci_addr);

Where do you request_resource before adding it?

> +	}
> +
> +	/* Apply architecture specific fixups for the ranges */
> +	return pcibios_fixup_bridge_ranges(resources);

I currently mandate at least one non-prefetchable resource in the
device-tree. Should I simply drop this restriction, or do I have to somehow
hook this into the pcibios callback?

> +}
> +
> +static atomic_t domain_nr = ATOMIC_INIT(-1);
> +
> +/**
> + * of_create_pci_host_bridge - Create a PCI host bridge structure using
> + * information passed in the DT.
> + * @parent: device owning this host bridge
> + * @ops: pci_ops associated with the host controller
> + * @host_data: opaque data structure used by the host controller.
> + *
> + * returns a pointer to the newly created pci_host_bridge structure, or
> + * NULL if the call failed.
> + *
> + * This function will try to obtain the host bridge domain number by
> + * using of_alias_get_id() call with "pci-domain" as a stem. If that
> + * fails, a local allocator will be used that will put each host bridge
> + * in a new domain.
> + */
> +struct pci_host_bridge *
> +of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops, void *host_data)
> +{
> +	int err, domain, busno;
> +	struct resource *bus_range;
> +	struct pci_bus *root_bus;
> +	struct pci_host_bridge *bridge;
> +	resource_size_t io_base;
> +	LIST_HEAD(res);
> +
> +	bus_range = kzalloc(sizeof(*bus_range), GFP_KERNEL);
> +	if (!bus_range)
> +		return ERR_PTR(-ENOMEM);
> +
> +	domain = of_alias_get_id(parent->of_node, "pci-domain");
> +	if (domain == -ENODEV)
> +		domain = atomic_inc_return(&domain_nr);
> +
> +	err = of_pci_parse_bus_range(parent->of_node, bus_range);
> +	if (err) {
> +		dev_info(parent, "No bus range for %s, using default [0-255]\n",
> +			parent->of_node->full_name);
> +		bus_range->start = 0;
> +		bus_range->end = 255;
> +		bus_range->flags = IORESOURCE_BUS;

What about bus_range->name?

> +	}
> +	busno = bus_range->start;
> +	pci_add_resource(&res, bus_range);

I currently truncate the bus range to fit inside the Configuration Space
window I have (in the reg property). How can I continue to do that with this
patch?

Will
