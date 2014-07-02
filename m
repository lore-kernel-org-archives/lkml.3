Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbaGBRbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:31:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40450 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756451AbaGBRbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:31:09 -0400
Date: Wed, 2 Jul 2014 18:31:13 +0100
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
Message-ID: <20140702173113.GJ24879@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-9-git-send-email-Liviu.Dudau@arm.com>
 <20140702112230.GL18731@arm.com>
 <20140702172355.GQ2173@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702172355.GQ2173@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 06:23:55PM +0100, Liviu Dudau wrote:
> On Wed, Jul 02, 2014 at 12:22:30PM +0100, Will Deacon wrote:
> > On Tue, Jul 01, 2014 at 07:43:33PM +0100, Liviu Dudau wrote:
> > > Several platforms use a rather generic version of parsing
> > > the device tree to find the host bridge ranges. Move the common code
> > > into the generic PCI code and use it to create a pci_host_bridge
> > > structure that can be used by arch code.
> > > 
> > > Based on early attempts by Andrew Murray to unify the code.
> > > Used powerpc and microblaze PCI code as starting point.
> > 
> > I just had a quick look at this to see how it differs from the parsing in
> > pci-host-generic.c and there a few small differences worth discussing.

[...]

> > > +	}
> > > +
> > > +	/* Apply architecture specific fixups for the ranges */
> > > +	return pcibios_fixup_bridge_ranges(resources);
> > 
> > I currently mandate at least one non-prefetchable resource in the
> > device-tree. Should I simply drop this restriction, or do I have to somehow
> > hook this into the pcibios callback?
> 
> Don't think I understand why you need at least one non-prefetcheable resource
> but if you want to mandate that then the pcibios_fixup_bridge_ranges() would
> be the place to put that check.

I think it was Arnd's idea at the time:

  http://lists.infradead.org/pipermail/linux-arm-kernel/2014-February/232225.html

and it's probably worth keeping if possible (just to avoid changes to the
behaviour of the existing driver).

However, that means I already need a host-controller callback via
pcibios_fixup_bridge_ranges...

> > > +	err = of_pci_parse_bus_range(parent->of_node, bus_range);
> > > +	if (err) {
> > > +		dev_info(parent, "No bus range for %s, using default [0-255]\n",
> > > +			parent->of_node->full_name);
> > > +		bus_range->start = 0;
> > > +		bus_range->end = 255;
> > > +		bus_range->flags = IORESOURCE_BUS;
> > 
> > What about bus_range->name?
> 
> Don't know! Is anyone using it?

I guess /proc/iomem prints it out? I set it in my current driver, if you
want to take a look.

> > 
> > > +	}
> > > +	busno = bus_range->start;
> > > +	pci_add_resource(&res, bus_range);
> > 
> > I currently truncate the bus range to fit inside the Configuration Space
> > window I have (in the reg property). How can I continue to do that with this
> > patch?
> 
> Not easily. Unless I add an argument to this function that will allow you to
> pass in the max number for the bus range, then the code becomes:
> 
> +	err = of_pci_parse_bus_range(parent->of_node, bus_range);
> +	if (err) {
> +		dev_info(parent, "No bus range for %s, using default [0-%d]\n",
> +			parent->of_node->full_name, max_range);
> +		bus_range->start = 0;
> +		bus_range->end = max_range;
> +		bus_range->flags = IORESOURCE_BUS;
> +	} else {
> +		if (bus_range->end > bus_range->start + max_range) {
> +			bus_range->end = bus_range->start + max_range;
> +		}
> +	}
> 
> Or something like that.

Again, take a look at my driver (it's in mainline now) to see how I deal
with this.

Will
