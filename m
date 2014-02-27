Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaB0ON3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:13:29 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52544 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaB0ON0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:13:26 -0500
Date: Thu, 27 Feb 2014 14:13:22 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] pci: Add support for creating a generic
 host_bridge from device tree
Message-ID: <20140227141322.GL1692@e106497-lin.cambridge.arm.com>
Mail-Followup-To: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
 <1393506402-11474-5-git-send-email-Liviu.Dudau@arm.com>
 <18746655.qWHLpMg2Yy@wuerfel>
MIME-Version: 1.0
In-Reply-To: <18746655.qWHLpMg2Yy@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 27 Feb 2014 14:13:23.0372 (UTC) FILETIME=[131506C0:01CF33C6]
X-MC-Unique: 114022714132410601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:38:32PM +0000, Arnd Bergmann wrote:
> On Thursday 27 February 2014 13:06:42 Liviu Dudau wrote:
> > Several platforms use a rather generic version of parsing
> > the device tree to find the host bridge ranges. Move the common code
> > into the generic PCI code and use it to create a pci_host_bridge
> > structure that can be used by arch code.
> > 
> > Based on early attempts by Andrew Murray to unify the code.
> > Used powerpc and microblaze PCI code as starting point.
> > 
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> Please add Benjamin Herrenschmidt to Cc here, I think it would be helpful
> to get his input so we can make this work on powerpc as well.

Sorry to Benjamin for omitting him, I will add him to future postings (if he finds
the direction interesting ;) ).

> 
> > diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
> > index 06ace62..feb8436 100644
> > --- a/drivers/pci/host-bridge.c
> > +++ b/drivers/pci/host-bridge.c
> > @@ -6,9 +6,13 @@
> >  #include <linux/init.h>
> >  #include <linux/pci.h>
> >  #include <linux/module.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_pci.h>
> >  
> >  #include "pci.h"
> >  
> > +static int domain_nr;
> > +
> 
> For correctness, I think you want an 'atomic_t' here and use
> atomic_inc_return() to get a new value.

OK, will do.

> 
> >  static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
> >  {
> >  	while (bus->parent)
> > @@ -91,3 +95,133 @@ void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
> >  	res->end = region->end + offset;
> >  }
> >  EXPORT_SYMBOL(pcibios_bus_to_resource);
> > +
> > +/**
> > + * pci_host_bridge_of_get_ranges - Parse PCI host bridge resources from DT
> > + * @dev: device node of the host bridge having the range property
> > + * @resources: list where the range of resources will be added after DT parsing
> > + * @io_base: pointer to a variable that will contain the physical address for
> > + * the start of the I/O range.
> > + *
> > + * If this function returns an error then the @resources list will be freed.
> > + *
> > + * This function will parse the "ranges" property of a PCI host bridge device
> > + * node and setup the resource mapping based on its content. It is expected
> > + * that the property conforms with the Power ePAPR document.
> > + *
> > + * Each architecture is then offered the chance of applying their own
> > + * filtering of pci_host_bridge_windows based on their own restrictions by
> > + * calling pcibios_fixup_bridge_ranges(). The filtered list of windows
> > + * can then be used when creating a pci_host_bridge structure.
> > + */
> > +static int pci_host_bridge_of_get_ranges(struct device_node *dev,
> > +		struct list_head *resources, resource_size_t *io_base)
> > +{
> > +	struct resource *res;
> > +	struct of_pci_range range;
> > +	struct of_pci_range_parser parser;
> > +	int err;
> > +
> > +	pr_info("PCI host bridge %s ranges:\n", dev->full_name);
> > +
> > +	/* Check for ranges property */
> > +	err = of_pci_range_parser_init(&parser, dev);
> > +	if (err)
> > +		return err;
> > +
> > +	pr_debug("Parsing ranges property...\n");
> > +	for_each_of_pci_range(&parser, &range) {
> > +		/* Read next ranges element */
> > +		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
> > +				range.pci_space, range.pci_addr);
> > +		pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
> > +					range.cpu_addr, range.size);
> > +
> > +		/*
> > +		 * If we failed translation or got a zero-sized region
> > +		 * then skip this range
> > +		 */
> > +		if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
> > +			continue;
> > +
> > +		res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> > +		if (!res) {
> > +			err = -ENOMEM;
> > +			goto bridge_ranges_nomem;
> > +		}
> > +
> > +		of_pci_range_to_resource(&range, dev, res);
> > +
> > +		if (resource_type(res) == IORESOURCE_IO)
> > +			*io_base = range.cpu_addr;
> > +
> > +		pci_add_resource_offset(resources, res,
> > +				res->start - range.pci_addr);
> > +	}
> 
> This is not the correct resource for I/O space at all. Please talk
> to Will, I've been over this with him in detail and he probably
> understands it now. I assume you are both working in the same
> building.

As you noticed later, it is now correct because res->start will
have the start logical I/O port. I'm talking with Will on regular basis
and I think we are both on the same sheet.

> 
> Since this is common PCI code, you could also decide to open-code
> the pci_add_resource_offset() function. If you don't do that, I
> think you have a memory leak for the resources that you can avoid
> by allocating the resource and pci_host_bridge_window structures
> together with a single kzalloc.

This is a list of temporary resources that hasn't been yet added
to pci_host_bridge_window. As noted in the comment for the function, if
the call fails it will clear the resources list.

> 
> > +	/* Apply architecture specific fixups for the ranges */
> > +	pcibios_fixup_bridge_ranges(resources);
> > +
> > +	return 0;
> > +
> > +bridge_ranges_nomem:
> > +	pci_free_resource_list(resources);
> > +	return err;
> > +}
> > +
> > +/**
> > + * of_create_pci_host_bridge - Create a PCI host bridge structure using
> > + * information passed in the DT.
> > + * @parent: device owning this host bridge
> > + * @ops: pci_ops associated with the host controller
> > + * @host_data: opaque data structure used by the host controller.
> > + *
> > + * returns a pointer to the newly created pci_host_bridge structure, or
> > + * NULL if the call failed.
> > + *
> > + * This function will try to obtain the host bridge domain number by
> > + * using of_alias_get_id() call with "pci-domain" as a stem. If that
> > + * fails, a local allocator will be used that will put each host bridge
> > + * in a new domain.
> > + */
> > +struct pci_host_bridge *
> > +of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops, void *host_data)
> > +{
> > +	int err, domain, busno;
> > +	struct resource bus_range;
> > +	struct pci_bus *root_bus;
> > +	struct pci_host_bridge *bridge;
> > +	resource_size_t io_base;
> > +	LIST_HEAD(res);
> > +
> > +	domain = of_alias_get_id(parent->of_node, "pci-domain");
> > +	if (domain == -ENODEV)
> > +		domain = domain_nr++;
> > +
> > +	err = of_pci_parse_bus_range(parent->of_node, &bus_range);
> > +	if (err) {
> > +		dev_info(parent, "No bus range for %s, using default [0-255]\n",
> > +			parent->of_node->full_name);
> > +		bus_range.start = 0;
> > +		bus_range.end = 255;
> > +		bus_range.flags = IORESOURCE_BUS;
> > +	}
> > +	busno = bus_range.start;
> > +	pci_add_resource(&res, &bus_range);
> > +
> > +	/* now parse the rest of host bridge bus ranges */
> > +	if (pci_host_bridge_of_get_ranges(parent->of_node, &res, &io_base))
> > +		return NULL;
> > +
> > +	/* then create the root bus */
> > +	root_bus = pci_create_root_bus_in_domain(parent, domain, busno,
> > +						ops, host_data, &res);
> > +	if (!root_bus)
> > +		return NULL;
> 
> Do we have any code that checks for conflicting domain/bus numbers here?
> I guess pci_create_root_bus_in_domain() will fail if you have that.

It does fail.

> 
> Since pci_create_root_bus_in_domain() is a new function that you just
> introduced, it would be helpful to change the calling conventions
> so it returns an error pointer instead of NULL upon failing.
> of_create_pci_host_bridge() can do the same, but pci_create_root_bus()
> should keep returning NULL so we don't have to change all the
> callers.

I need to look if any useful information is being captured in the function.
Please note that pci_create_root_bus_in_domain() is actually the old
pci_create_root_bus() function with an added parameter.

> 
> > +	bridge = to_pci_host_bridge(root_bus->bridge);
> > +	bridge->io_base = io_base;

To answer your later question, io_base is remembered here.

> > +
> > +	return bridge;
> > +}
> > +EXPORT_SYMBOL_GPL(of_create_pci_host_bridge);
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index 1eed009..0c5e269 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -395,6 +395,7 @@ struct pci_host_bridge {
> >  	struct device dev;
> >  	struct pci_bus *bus;		/* root bus */
> >  	int domain_nr;
> > +	resource_size_t io_base;	/* physical address for the start of I/O area */
> >  	struct list_head windows;	/* pci_host_bridge_windows */
> >  	void (*release_fn)(struct pci_host_bridge *);
> >  	void *release_data;
> 
> What is the io_base used for here?

It is useful for host bridge drivers as this is the only place where we store
the physical CPU address for the IO range. This is then needed when setting up the
translation registers. Also used when calling the pci_ioremap_io function that I'm
introducing in the AArch64 patches.

Whole patch is still under legal review, but the fragment for setting up the ATR looks
like this:

	list_for_each_entry(window, &bridge->windows, list) {
		res = window->res;
		offset = window->offset;
		wsize = ilog2(resource_size(res)) - 1;

		if (resource_type(res) == IORESOURCE_MEM)
			update_atr_entry(pp->base + ATR_REG_whatever,
				res->start, 	                        /* CPU address */
				res->start - offset,                    /* PCI address */
				0, wsize);
		else if (resource_type(res) == IORESOURCE_IO) {
			io_offset = pci_ioremap_io(res, bridge->io_base + offset);
			update_atr_entry(pp->base + ATR_REG_whatever,
				bridge->io_base + res->start + offset,  /* CPU address */
				res->start,                             /* PCI address */
				0x20000, wsize);
		}
	}


Best regards,
Liviu


> 
> > @@ -1786,11 +1787,23 @@ static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
> >  	return bus ? bus->dev.of_node : NULL;
> >  }
> >  
> > +struct pci_host_bridge *
> > +of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops,
> > +			void *host_data);
> > +
> > +void pcibios_fixup_bridge_ranges(struct list_head *resources);
> >  #else /* CONFIG_OF */
> >  static inline void pci_set_of_node(struct pci_dev *dev) { }
> >  static inline void pci_release_of_node(struct pci_dev *dev) { }
> >  static inline void pci_set_bus_of_node(struct pci_bus *bus) { }
> >  static inline void pci_release_bus_of_node(struct pci_bus *bus) { }
> > +
> > +static inline struct pci_host_bridge *
> > +pci_host_bridge_of_init(struct device *parent, struct pci_ops *ops,
> > +			void *host_data)
> > +{
> > +	return NULL;
> > +}
> >  #endif  /* CONFIG_OF */
> >  
> >  #ifdef CONFIG_EEH
> > 
> 
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

