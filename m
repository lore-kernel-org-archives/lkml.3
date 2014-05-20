Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaETPZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:25:38 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50521 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751161AbaETPZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:25:36 -0400
Date: Tue, 20 May 2014 16:24:59 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
        iommu@lists.linux-foundation.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, linux-tegra@vger.kernel.org,
        Cho KyongHo <pullip.cho@samsung.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140520152458.GB5041@e103592.cambridge.arm.com>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <10711669.TTjp9L4tTG@wuerfel>
 <20140520120242.GA20995@ulmo>
 <8663464.40PHEumOar@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8663464.40PHEumOar@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 02:41:18PM +0200, Arnd Bergmann wrote:
> On Tuesday 20 May 2014 14:02:43 Thierry Reding wrote:
> > On Tue, May 20, 2014 at 01:15:48PM +0200, Arnd Bergmann wrote:
> > > On Tuesday 20 May 2014 13:05:37 Thierry Reding wrote:
> > > > On Tue, May 20, 2014 at 12:04:54PM +0200, Arnd Bergmann wrote:
> > > > > On Monday 19 May 2014 22:59:46 Thierry Reding wrote:
> > > > > > On Mon, May 19, 2014 at 08:34:07PM +0200, Arnd Bergmann wrote:
> > [...]
> > > > > > > You should never need #size-cells > #address-cells
> > > > > > 
> > > > > > That was always my impression as well. But how then do you represent the
> > > > > > full 4 GiB address space in a 32-bit system? It starts at 0 and ends at
> > > > > > 4 GiB - 1, which makes it 4 GiB large. That's:
> > > > > > 
> > > > > > 	<0 1 0>
> > > > > > 
> > > > > > With #address-cells = <1> and #size-cells = <1> the best you can do is:
> > > > > > 
> > > > > > 	<0 0xffffffff>
> > > > > > 
> > > > > > but that's not accurate.
> > > > > 
> > > > > I think we've done both in the past, either extended #size-cells or
> > > > > taken 0xffffffff as a special token. Note that in your example,
> > > > > the iommu actually needs #address-cells = <2> anyway.
> > > > 
> > > > But it needs #address-cells = <2> only to encode an ID in addition to
> > > > the address. If this was a single-master IOMMU then there'd be no need
> > > > for the ID.
> > > 
> > > Right. But for a single-master IOMMU, there is no need to specify
> > > any additional data, it could have #address-cells=<0> if we take the
> > > optimization you suggested.
> > 
> > Couldn't a single-master IOMMU be windowed?
> 
> Ah, yes. That would actually be like an IBM pSeries, which has a windowed
> IOMMU but uses one window per virtual machine. In that case, the window could
> be a property of the iommu node though, rather than part of the address
> in the link.
> 
> > > > > The main advantage I think would be for IOMMUs that use the PCI b/d/f
> > > > > numbers as IDs. These can have #address-cells=<3>, #size-cells=<2>
> > > > > and have an empty dma-ranges property in the PCI host bridge node,
> > > > > and interpret this as using the same encoding as the PCI BARs in
> > > > > the ranges property.
> > > > 
> > > > I'm somewhat confused here, since you said earlier:
> > > > 
> > > > > After giving the ranges stuff some more thought, I have come to the
> > > > > conclusion that using #iommu-cells should work fine for almost
> > > > > all cases, including windowed iommus, because the window is not
> > > > > actually needed in the device, but only in the iommu, wihch is of course
> > > > > free to interpret the arguments as addresses.
> > > > 
> > > > But now you seem to be saying that we should still be using the
> > > > #address-cells and #size-cells properties in the IOMMU node to determine
> > > > the length of the specifier.
> > > 
> > > I probably wasn't clear. I think we can make it work either way, but
> > > my feeling is that using #address-cells/#size-cells gives us a nicer
> > > syntax for the more complex cases.
> > 
> > Okay, so in summary we'd have something like this for simple cases:
> > 
> > Required properties:
> > --------------------
> > - #address-cells: The number of cells in an IOMMU specifier needed to encode
> >   an address.
> > - #size-cells: The number of cells in an IOMMU specifier needed to represent
> >   the length of an address range.
> > 
> > Typical values for the above include:
> > - #address-cells = <0>, size-cells = <0>: Single master IOMMU devices are not
> >   configurable and therefore no additional information needs to be encoded in
> >   the specifier. This may also apply to multiple master IOMMU devices that do
> >   not allow the association of masters to be configured.
> > - #address-cells = <1>, size-cells = <0>: Multiple master IOMMU devices may
> >   need to be configured in order to enable translation for a given master. In
> >   such cases the single address cell corresponds to the master device's ID.
> > - #address-cells = <2>, size-cells = <2>: Some IOMMU devices allow the DMA
> >   window for masters to be configured. The first cell of the address in this
> >   may contain the master device's ID for example, while the second cell could
> >   contain the start of the DMA window for the given device. The length of the
> >   DMA window is specified by two additional cells.

I was trying to figure out how to describe the different kinds of
transformation we could have on the address/ID input to the IOMMU.
Treating the whole thing as opaque gets us off the hook there.

IDs are probably not propagated, not remapped, or we simply don't care
about them; whereas the address transformation is software-controlled,
so we don't describe that anyway.

Delegating grokking the mapping to the iommu driver makes sense --
it's what it's there for, after all.


I'm not sure whether the windowed IOMMU case is special actually.

Since the address to program into the master is found by calling the
IOMMU driver to create some mappings, does anything except the IOMMU
driver need to understand that there is windowing?

> > 
> > Examples:
> > =========
> > 
> > Single-master IOMMU:
> > --------------------
> > 
> > 	iommu {
> > 		#address-cells = <0>;
> > 		#size-cells = <0>;
> > 	};
> > 
> > 	master {
> > 		iommus = <&/iommu>;
> > 	};
> > 
> > Multiple-master IOMMU with fixed associations:
> > ----------------------------------------------
> > 
> > 	/* multiple-master IOMMU */
> > 	iommu {
> > 		/*
> > 		 * Masters are statically associated with this IOMMU and
> > 		 * address translation is always enabled.
> > 		 */
> > 		#iommu-cells = <0>;
> > 	};
> 
> copied wrong? I guess you mean #address-cells=<0>/#size-cells=<0> here.
> 
> > 	/* static association with IOMMU */
> > 	master@1 {
> > 		reg = <1>;

Just for clarification, "reg" just has its standard meaning here, and
is nothing to do with the IOMMU?

> > 		iommus = <&/iommu>;

In effect, "iommus" is doing the same thing as my "slaves" property.

The way #address-cells and #size-cells determine the address and range
size for mastering into the IOMMU is also similar.  The main difference
is that I didn't build the ID into the address.

> > 	};
> > 
> > 	/* static association with IOMMU */
> > 	master@2 {
> > 		reg = <2>;
> > 		iommus = <&/iommu>;
> > 	};
> > 
> > Multiple-master IOMMU:
> > ----------------------
> > 
> > 	iommu {
> > 		/* the specifier represents the ID of the master */
> > 		#address-cells = <1>;
> > 		#size-cells = <0>;

How do we know the size of the input address to the IOMMU?  Do we
get cases for example where the IOMMU only accepts a 32-bit input
address, but some 64-bit capable masters are connected through it?

The size of the output address from the IOMMU will be determined
by its own mastering destination, which by default in ePAPR is the
IOMMU node's parent.  I think that's what you intended, and what we
expect in this case.

For determining dma masks, it is the output address that it
important.  Santosh's code can probably be taught to handle this,
if given an additional traversal rule for following "iommus"
properties.  However, deploying an IOMMU whose output address size
is smaller than the 

> > 	};
> > 
> > 	master {
> > 		/* device has master ID 42 in the IOMMU */
> > 		iommus = <&/iommu 42>;
> > 	};
> > 
> > Multiple-master device:
> > -----------------------
> > 
> > 	/* single-master IOMMU */
> > 	iommu@1 {
> > 		reg = <1>;
> > 		#address-cells = <0>;
> > 		#size-cells = <0>;
> > 	};
> > 
> > 	/* multiple-master IOMMU */
> > 	iommu@2 {
> > 		reg = <2>;
> > 		#address-cells = <1>;
> > 		#size-cells = <0>;
> > 	};
> > 
> > 	/* device with two master interfaces */
> > 	master {
> > 		iommus = <&/iommu@1>,    /* master of the single-master IOMMU */
> > 			 <&/iommu@2 42>; /* ID 42 in multiple-master IOMMU */
> > 	};
> > 
> > Multiple-master IOMMU with configurable DMA window:
> > ---------------------------------------------------
> > 
> > 	/ {
> > 		#address-cells = <1>;
> > 		#size-cells = <1>;
> > 
> > 		iommu {
> > 			/* master ID, address of DMA window */
> > 			#address-cells = <2>;
> > 			#size-cells = <2>;
> > 		};
> > 
> > 		master {
> > 			/* master ID 42, 4 GiB DMA window starting at 0 */
> > 			iommus = <&/iommu  42 0  0x1 0x0>;
> > 		};
> > 	};
> > 
> > Does that sound about right?
> 
> Yes, sounds great. I would probably leave out the Multiple-master device
> from the examples, since that seems to be a rather obscure case.

I think multi-master is the common case.

> 
> I would like to add an explanation about dma-ranges to the binding:
> 
> 8<--------
> The parent bus of the iommu must have a valid "dma-ranges" property
> describing how the physical address space of the IOMMU maps into
> memory.
> A device with an "iommus" property will ignore the "dma-ranges" property
> of the parent node and rely on the IOMMU for translation instead.
> Using an "iommus" property in bus device nodes with "dma-ranges"
> specifying how child devices relate to the IOMMU is a possible extension
> but is not recommended until this binding gets extended.

This sounds just right.  The required semantics is that the presence of
"iommus" on some bus mastering device overrides the ePAPR default
destination so that transactions are delivered to the IOMMU for
translation instead of the master's DT parent node.

Where transactions flow out of the IOMMU, the iommu takes on the role
of the master, so the default destination would be the iommu node's
parent.

> ----------->8
> 
> Does that make sense to you? We can change what we say about
> dma-ranges, I mainly want to be clear with what is or is not
> allowed at this point.

I think it would be inconsistent and unnecessary to disallow it in the
binding.  The meaning you've proposed seems completely consistent with
ePAPR, so I suggest to keep it.  The IOMMU is just another bus master
from the ePAPR point of view -- no need to make special rules for it
unless they are useful.

The binding does not need to be (and generally shouldn't be) a
description of precisely what the kernel does and does not support.

However, if we don't need to support non-identity dma-ranges in Linux
yet, we have the option to barf if we see such a dma-ranges memorywards
of an IOMMU, if it simplifies the Linux implementation.  We could always
relax that later -- and it'll be obvious how to describe that situation
in DT.



What I would like to see is a recommandation, based on Thierry's binding
here, for describing how cross-mastering in general is described.  It's
not really a binding, but more of a template for bindings.

I'm happy to have a go at writing it, then we can decide whether it's
useful or not.


There are a few things from the discussion that are *not* solved by this
iommu binding, but they seem reasonable.  The binding also doesn't block
solving those things later if/when needed:

 1) Cross-mastering to things that are not IOMMUs

    We might need to solve this later if we encounter SoCs with
    problematic topologies, we shouldn't worry about it for the time
    being.

    We'll to revisit it for GICv3 but that's a separate topic.

 2) Describing address and ID remappings for cross-mastering.

    We can describe this in a way that is consistent with this IOMMU
    binding.  We will need to describe something for GICv3, but the
    common case will be that IDs are just passed through without
    remapping.

    We don't need to clarify how IDs are propagated until we have
    something in DT for IDs to propagate to.


Cheers
---Dave
