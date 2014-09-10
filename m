Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaIJPKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:10:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49654 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbaIJPKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:10:34 -0400
Date: Wed, 10 Sep 2014 16:10:26 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
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
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v10 08/10] OF: PCI: Add support for parsing PCI host
 bridge resources from DT
Message-ID: <20140910151026.GB11640@e102568-lin.cambridge.arm.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184472-17630-9-git-send-email-Liviu.Dudau@arm.com>
 <20140909133546.GB2636@e102568-lin.cambridge.arm.com>
 <20140910142241.GD27864@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
In-Reply-To: <20140910142241.GD27864@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Sep 2014 15:10:28.0232 (UTC) FILETIME=[5B027080:01CFCD09]
X-MC-Unique: 114091016103001101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 03:22:41PM +0100, Liviu Dudau wrote:
> On Tue, Sep 09, 2014 at 02:35:46PM +0100, Lorenzo Pieralisi wrote:
> > On Mon, Sep 08, 2014 at 02:54:30PM +0100, Liviu Dudau wrote:
> > > Provide a function to parse the PCI DT ranges that can be used to
> > > create a pci_host_bridge structure together with its associated
> > > bus.
> > > 
> > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Grant Likely <grant.likely@linaro.org>
> > > Cc: Rob Herring <robh+dt@kernel.org>
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > > ---
> > >  drivers/of/of_pci.c    | 102 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/of_pci.h |  11 ++++++
> > >  2 files changed, 113 insertions(+)
> > > 
> > > diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> > > index a107edb..36701da 100644
> > > --- a/drivers/of/of_pci.c
> > > +++ b/drivers/of/of_pci.c
> > > @@ -1,7 +1,9 @@
> > >  #include <linux/kernel.h>
> > >  #include <linux/export.h>
> > >  #include <linux/of.h>
> > > +#include <linux/of_address.h>
> > >  #include <linux/of_pci.h>
> > > +#include <linux/slab.h>
> > >  
> > >  static inline int __of_pci_pci_compare(struct device_node *node,
> > >  				       unsigned int data)
> > > @@ -123,6 +125,106 @@ int of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing)
> > >  }
> > >  EXPORT_SYMBOL_GPL(of_pci_get_domain_nr);
> > >  
> > > +/**
> > > + * of_pci_get_host_bridge_resources - Parse PCI host bridge resources from DT
> > > + * @dev: device node of the host bridge having the range property
> > > + * @busno: bus number associated with the bridge root bus
> > > + * @bus_max: maximum number of busses for this bridge
> > > + * @resources: list where the range of resources will be added after DT parsing
> > > + * @io_base: pointer to a variable that will contain on return the physical
> > > + * address for the start of the I/O range.
> > > + *
> > > + * It is the callers job to free the @resources list.
> > > + *
> > > + * This function will parse the "ranges" property of a PCI host bridge device
> > > + * node and setup the resource mapping based on its content. It is expected
> > > + * that the property conforms with the Power ePAPR document.
> > 
> > You should also define what it returns and when.
> 
> Thanks, will do.
> 
> > 
> > > + *
> > > + */
> > > +int of_pci_get_host_bridge_resources(struct device_node *dev,
> > > +			unsigned char busno, unsigned char bus_max,
> > > +			struct list_head *resources, resource_size_t *io_base)
> > > +{
> > > +	struct resource *res;
> > > +	struct resource *bus_range;
> > > +	struct of_pci_range range;
> > > +	struct of_pci_range_parser parser;
> > > +	char range_type[4];
> > > +	int err;
> > > +
> > > +	bus_range = kzalloc(sizeof(*bus_range), GFP_KERNEL);
> > > +	if (!bus_range)
> > > +		return -ENOMEM;
> > > +
> > > +	pr_info("PCI host bridge %s ranges:\n", dev->full_name);
> > > +
> > > +	err = of_pci_parse_bus_range(dev, bus_range);
> > > +	if (err) {
> > > +		bus_range->start = busno;
> > > +		bus_range->end = bus_max;
> > > +		bus_range->flags = IORESOURCE_BUS;
> > > +		pr_info("  No bus range found for %s, using %pR\n",
> > > +			dev->full_name, &bus_range);
> > > +	} else {
> > > +		if (bus_range->end > bus_range->start + bus_max)
> > > +			bus_range->end = bus_range->start + bus_max;
> > > +	}
> > > +	pci_add_resource(resources, bus_range);
> > 
> > This means that eg in the PCI generic host controller I cannot "filter"
> > the bus resource, unless I remove it, "filter" it, and add it again.
> 
> I'm not sure what you mean. Why do you have to remove the bus resource and
> add it again? What you get back from of_pci_get_host_bridge_resources() is
> a list of resources as they have been parsed from DT. You now have the option
> of doing any filtering that you might have done pre-v10 in the
> pcibios_fixup_bridge_ranges() but that is only on the list that was returned
> from of_pci_get_host_bridge_resources(). At this moment no root bus or
> host bridge structure has been created so no resource was added to those.
> With the filtered list you can use it to call pci_scan_root_bus() and *then*
> it gets added to the pci_host_bridge structure.

You are right sorry. As discussed, I just have to remove the resources
assignment in the respective host controller drivers (because you do
that in the API) and grab the resource pointers to "filter" them.

> > I certainly can't filter a resource that has been already added without
> > removing it first.
> > 
> > Thoughts ?
> 
> Hope I have explained what happens. Please let me know if you have any other
> comments.

There were other comments below ;)

Thanks,
Lorenzo

> 
> Best regards,
> Liviu
> 
> > 
> > > +
> > > +	/* Check for ranges property */
> > > +	err = of_pci_range_parser_init(&parser, dev);
> > > +	if (err)
> > > +		goto parse_failed;
> > > +
> > > +	pr_debug("Parsing ranges property...\n");
> > > +	for_each_of_pci_range(&parser, &range) {
> > > +		/* Read next ranges element */
> > > +		if ((range.flags & IORESOURCE_TYPE_BITS) == IORESOURCE_IO)
> > > +			snprintf(range_type, 4, " IO");
> > > +		else if ((range.flags & IORESOURCE_TYPE_BITS) == IORESOURCE_MEM)
> > > +			snprintf(range_type, 4, "MEM");
> > > +		else
> > > +			snprintf(range_type, 4, "err");
> > > +		pr_info("  %s %#010llx..%#010llx -> %#010llx\n", range_type,
> > > +			range.cpu_addr, range.cpu_addr + range.size - 1,
> > > +			range.pci_addr);
> > > +
> > > +		/*
> > > +		 * If we failed translation or got a zero-sized region
> > > +		 * then skip this range
> > > +		 */
> > > +		if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
> > > +			continue;
> > > +
> > > +		res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> > > +		if (!res) {
> > > +			err = -ENOMEM;
> > > +			goto parse_failed;
> > > +		}
> > > +
> > > +		err = of_pci_range_to_resource(&range, dev, res);
> > > +		if (err) {
> > > +			kfree(res);
> > 
> > You might want to add a label to free res to make things more uniform.
> > 
> > > +			goto parse_failed;
> > > +		}
> > > +
> > > +		if (resource_type(res) == IORESOURCE_IO) {
> > > +			if (*io_base)
> > 
> > You do not zero io_base in the first place so you should ask the API
> > user to do that. Is 0 a valid value BTW ? If it is you've got to resort
> > to something else to detect multiple IO resources.
> > 
> > Lorenzo
> 
> -- 
> ====================
> | I would like to |
> | fix the world,  |
> | but they're not |
> | giving me the   |
>  \ source code!  /
>   ---------------
>     ?\_(?)_/?

