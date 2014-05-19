Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbaESSeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:34:22 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54030 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaESSeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:34:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, iommu@lists.linux-foundation.org,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Mon, 19 May 2014 20:34:07 +0200
Message-ID: <14622654.QO8kH1AoTT@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140519125336.GA9466@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <4391809.OTRCiJQXS4@wuerfel> <20140519125336.GA9466@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8I/qdSlUqTifu9EFHOmcvFux/voUFBodk96Q/S4CyAm
 l5j5Yl1JLv48N940GHzyNL021ASpwNevKMdTSrgBLBecNVU8K2
 5VWPxzO7A5ctx/pGPLTVxSwh1uZU/HfEdqK4jFtyb+duNDBId/
 4t4PWHhSl7IqEb9I1n3FgFwnihDVu1Udlfa0PMR49vdPHxJoOl
 CNUOZJY2mRKRG8LFWBMI0pVqOYdvQDty8cfEt5tIdUjJI64GH9
 /PNl9t8C1O45yQW4xB6+JV4yXHFAh8jXg4L3y0RwxvjJxM4B3H
 Do6ePTD35VzNwczCdwptMCaq4/xjjRm40gpyPtV0bf5fbjwtWv
 JaS+e3KgKgcjA67Tx/F0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2014 14:53:37 Thierry Reding wrote:
> On Mon, May 19, 2014 at 12:26:35PM +0200, Arnd Bergmann wrote:
> > On Friday 16 May 2014 14:23:18 Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > > 
> > > This commit introduces a generic device tree binding for IOMMU devices.
> > > Only a very minimal subset is described here, but it is enough to cover
> > > the requirements of both the Exynos System MMU and Tegra SMMU as
> > > discussed here:
> > > 
> > >     https://lkml.org/lkml/2014/4/27/346
> > > 
> > > More advanced functionality such as the dma-ranges property can easily
> > > be added in a backwards-compatible way. In the absence of a dma-ranges
> > > property it should be safe to default to the whole address space.
> > > 
> > 
> > The basic binding looks fine, but I'd like it to be more explicit
> > about dma-ranges. Most importantly, what does "the whole address space"
> > mean?
> 
> The whole point was to leave out any mention of dma-ranges from the
> binding until we've figured out more of the puzzle.
> 
> So what I was trying to avoid was another lengthy discussion on the
> topic of dma-ranges. Oh well... =)

I think that can't work, because we need a way to specify the
ranges for some iommu drivers. We have to make sure we at least
don't prevent it from working.

> > A lot of IOMMUs have only 32-bit bus addresses when targetted
> > by a bus master, it would also be normal for some to be smaller and
> > some might even support 64-bit.
> > 
> > For the upstream side, I'd hope we always have access to the full
> > physical memory, but since this is a brand-new binding, it should
> > be straightforward to just ask for upstream dma-ranges properties
> > to be set all the way up to the root to confirm that.
> > 
> > For downstream, we don't actually have a good place to put the
> > dma-ranges property.
> 
> I'm not sure I understand what you mean by upstream and downstream in
> this context.

Upstream -> close to memory
Downstream -> close to DMA master

> > We can't put it into the iommu node, because  that would imply translating
> > to the iommu's parent bus, not the iommu's own bus space.
> 
> My understanding was that the purpose of dma-ranges was to define a
> mapping from one bus to another. So the general form of
> 
> 	child-address  parent-address  child-size
> 
> Would be used to translate a region of size <child-size> from the
> <child-address> (the I/O address space created by the IOMMU) to the
> <parent-address> (physical address space).

That's how it's defined for normal buses, we haven't defined it for
IOMMUs yet.

> > We also can't put it into the master, because dma-ranges is supposed to be
> > in the parent bus.
> 
> I don't understand. From the above I would think that the master's node
> is precisely where it belongs.

The way that I read the binding, the way that dma-ranges belongs into the parent
of the master, according. On normal buses (e.g. classic PCI), all DMA masters
see the same address space. The bus defines how a transaction started on one
of its children gets translated to the address space of its parent. This
is similar to 'ranges', which defines how an MMIO address initiated on the
parent of a bus gets translated to an address understood by its children.

My interpretation at least matches the defintion of of_dma_get_range(),
but then again Santosh added that according to my comments.

> > Finally, it makes no sense to use the dma-ranges property of the master's
> > parent bus, because that bus isn't actually involved in the translation.
> 
> My understanding here is mostly based on the OpenFirmware working group
> proposal for the dma-ranges property[0]. I'll give another example to
> try and clarify how I had imagined this to work:
> 
> 	/ {
> 		#address-cells = <2>;
> 		#size-cells = <2>;
> 
> 		iommu {
> 			/*
> 			 * This is somewhat unusual (or maybe not) in that we
> 			 * need 2 cells to represent the size of an address
> 			 * space that is 32 bits long.
> 			 */
> 			#address-cells = <1>;
> 			#size-cells = <2>;

You should never need #size-cells > #address-cells

> 			#iommu-cells = <1>;
> 		};
> 
> 		master {
> 			iommus = <&/iommu 42>;
> 			/*
> 			 * Map I/O addresses 0 - 4 GiB to physical addresses
> 			 * 2 GiB - 6 GiB.
> 			 */
> 			dma-ranges = <0x00000000 0 0x80000000 1 0>;
> 		};
> 	};
> 
> This is somewhat incompatible with [0] in that #address-cells used to
> parse the child address must be taken from the iommu node rather than
> the child node. But that seems to me to be the only reasonable thing
> to do, because after all the IOMMU creates a completely new address
> space for the master.
> 
> [0]: http://www.openfirmware.org/ofwg/proposals/Closed/Accepted/410-it.txt

I don't think you can have a dma-ranges without a #address-cells and
#size-cells property in the same node. In your example, I'd also expect
a child node below 'master' that then interprets the address space
made up by dma-ranges.

As a comment on the numbers in your example, I don't expect to ever
see a 4GB IOMMU address space that doesn't start at an offset. Instead
I'd expect either addresses that encode a device ID, or those that
are just a subset of the parent address space, with non-overlapping
bus addresses for each master.

> > My preferred option would be to always put the address range into
> > the iommu descriptor, using the iommu's #address-cells.
> 
> That could become impossible to parse. I'm not sure if such hardware
> actually exists, but if for some reason we have to split the address
> range into two, then there's no longer any way to determine the size
> needed for the specifier.
> 
> On the other hand what you propose makes it easy to represent multiple
> master interfaces on a device. With a separate dma-ranges property how
> can you define which ranges apply to which of the master interfaces?

Well, you could have multiple links to the same IOMMU if you want to 
do that, and define that there must be at least one dma-ranges entry
for each IOMMU entry (although not necessarily the other way round,
you could have direct ranges in addition to translated ones.

> Then again if address ranges can't be broken up in the first place, then
> dma-ranges could be considered to be one entry per IOMMU in the iommus
> property.

Let me do another example, with the address merged into the iommu
references:

/ {
	#address-cells = <2>; // 64-bit address
	#size-cells = <2>;

	iommu@a {
		#address-cells = <2>; // 1 cell ID, 1 cell address
		#size-cells = <1>;

		// no need for #iommu-cells
	};


	master@b {
		iommus = <&/iommu@a // iommu
			0x23  	     // ID
			0x40000000   // window start
			0x10000000>; //window size
	};
};

A disadvantage of this model would be that for all ARM SMMU users, we'd
have to always list a 4GB address space, which is kind of redundant.

	Arnd
