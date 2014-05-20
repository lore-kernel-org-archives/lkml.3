Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbaETU1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:27:13 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:61298 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaETU1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:27:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Martin <Dave.Martin@arm.com>
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
Date: Tue, 20 May 2014 22:26:12 +0200
Message-ID: <5612206.Fzsy1mf3q3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140520152458.GB5041@e103592.cambridge.arm.com>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <8663464.40PHEumOar@wuerfel> <20140520152458.GB5041@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mr4x//poy5khdh8jlK+G+J5T0tdVpKnIKfYjyVlcv77
 8NrvgKJnTHtRI0GxQN8q6VoDHlT++hK2eMXYWMeF1hLzMlsJBK
 TjnzsCju6/ipUFLO2NBVDdlT5Yz9aZCorIUs3gO7nHAeZsLg+m
 altbtMS+GI6ihcOWpjIBTCXOb+b/xgsP2uSthbf9hGKSna9JCC
 sPQJp4dG9B5WqrzorfhVgPx0jcJdKmljDn7ciWnwm3Y4Ui2GGt
 hyyUMLcNSNm4bH0KcBzHZiAaqwFWC1qHU026LOCnbDnxbEvLlz
 LX0CkbU3pxox7F48jr3/10xpHk6eWV5tgQBXfTxayEt1KMTJeL
 hbXZaYdcix+eRTFJt26E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 16:24:59 Dave Martin wrote:
> On Tue, May 20, 2014 at 02:41:18PM +0200, Arnd Bergmann wrote:
> > On Tuesday 20 May 2014 14:02:43 Thierry Reding wrote:
> > > On Tue, May 20, 2014 at 01:15:48PM +0200, Arnd Bergmann wrote:
> > > Typical values for the above include:
> > > - #address-cells = <0>, size-cells = <0>: Single master IOMMU devices are not
> > >   configurable and therefore no additional information needs to be encoded in
> > >   the specifier. This may also apply to multiple master IOMMU devices that do
> > >   not allow the association of masters to be configured.
> > > - #address-cells = <1>, size-cells = <0>: Multiple master IOMMU devices may
> > >   need to be configured in order to enable translation for a given master. In
> > >   such cases the single address cell corresponds to the master device's ID.
> > > - #address-cells = <2>, size-cells = <2>: Some IOMMU devices allow the DMA
> > >   window for masters to be configured. The first cell of the address in this
> > >   may contain the master device's ID for example, while the second cell could
> > >   contain the start of the DMA window for the given device. The length of the
> > >   DMA window is specified by two additional cells.
> 
> I was trying to figure out how to describe the different kinds of
> transformation we could have on the address/ID input to the IOMMU.
> Treating the whole thing as opaque gets us off the hook there.
> 
> IDs are probably not propagated, not remapped, or we simply don't care
> about them; whereas the address transformation is software-controlled,
> so we don't describe that anyway.
> 
> Delegating grokking the mapping to the iommu driver makes sense --
> it's what it's there for, after all.
> 
> 
> I'm not sure whether the windowed IOMMU case is special actually.
> 
> Since the address to program into the master is found by calling the
> IOMMU driver to create some mappings, does anything except the IOMMU
> driver need to understand that there is windowing?

No. I tried to explain that earlier today, and in my earlier mails
I hadn't thought that part through. Only the IOMMU driver needs to care
about the window.

> > > 
> > > Examples:
> > > =========
> > > 
> > > Single-master IOMMU:
> > > --------------------
> > > 
> > > 	iommu {
> > > 		#address-cells = <0>;
> > > 		#size-cells = <0>;
> > > 	};
> > > 
> > > 	master {
> > > 		iommus = <&/iommu>;
> > > 	};
> > > 
> > > Multiple-master IOMMU with fixed associations:
> > > ----------------------------------------------
> > > 
> > > 	/* multiple-master IOMMU */
> > > 	iommu {
> > > 		/*
> > > 		 * Masters are statically associated with this IOMMU and
> > > 		 * address translation is always enabled.
> > > 		 */
> > > 		#iommu-cells = <0>;
> > > 	};
> > 
> > copied wrong? I guess you mean #address-cells=<0>/#size-cells=<0> here.
> > 
> > > 	/* static association with IOMMU */
> > > 	master@1 {
> > > 		reg = <1>;
> 
> Just for clarification, "reg" just has its standard meaning here, and
> is nothing to do with the IOMMU?

correct

> > > 		iommus = <&/iommu>;
> 
> In effect, "iommus" is doing the same thing as my "slaves" property.
> 
> The way #address-cells and #size-cells determine the address and range
> size for mastering into the IOMMU is also similar.  The main difference
> is that I didn't build the ID into the address.

Right. I think the difference is more about what we want to call
things: Calling it iommu means we want to specifically describe
the case of iommus that needs to get handled by all OSs in a particular
way, while the more generic slave connection doesn't correspond to
a specific concept in the OS.

> > > 	};
> > > 
> > > 	/* static association with IOMMU */
> > > 	master@2 {
> > > 		reg = <2>;
> > > 		iommus = <&/iommu>;
> > > 	};
> > > 
> > > Multiple-master IOMMU:
> > > ----------------------
> > > 
> > > 	iommu {
> > > 		/* the specifier represents the ID of the master */
> > > 		#address-cells = <1>;
> > > 		#size-cells = <0>;
> 
> How do we know the size of the input address to the IOMMU?  Do we
> get cases for example where the IOMMU only accepts a 32-bit input
> address, but some 64-bit capable masters are connected through it?

I was stuck on this question for a while before, but then I realized
that it doesn't matter at all: It's the IOMMU driver itself that
manages the address space, and it doesn't matter if a slave can
address a larger range than the IOMMU can accept. If the IOMMU
needs to deal with the opposite case (64-bit input addresses
but a 32-bit master), that limitation can be put into the specifier.

> The size of the output address from the IOMMU will be determined
> by its own mastering destination, which by default in ePAPR is the
> IOMMU node's parent.  I think that's what you intended, and what we
> expect in this case.

Rihgt.

> For determining dma masks, it is the output address that it
> important.  Santosh's code can probably be taught to handle this,
> if given an additional traversal rule for following "iommus"
> properties.  However, deploying an IOMMU whose output address size
> is smaller than the 

Something seems to be missing here. I don't think we want to handle
the case where the IOMMU output cannot the entire memory address
space. If necessary, that would mean using both an IOMMU driver
and swiotlb, but I think it's a reasonable assumption that hardware
isn't /that/ crazy.

> > > Multiple-master device:
> > > -----------------------
> > > 
> > > 	/* single-master IOMMU */
> > > 	iommu@1 {
> > > 		reg = <1>;
> > > 		#address-cells = <0>;
> > > 		#size-cells = <0>;
> > > 	};
> > > 
> > > 	/* multiple-master IOMMU */
> > > 	iommu@2 {
> > > 		reg = <2>;
> > > 		#address-cells = <1>;
> > > 		#size-cells = <0>;
> > > 	};
> > > 
> > > 	/* device with two master interfaces */
> > > 	master {
> > > 		iommus = <&/iommu@1>,    /* master of the single-master IOMMU */
> > > 			 <&/iommu@2 42>; /* ID 42 in multiple-master IOMMU */
> > > 	};
> > > 
> > > Multiple-master IOMMU with configurable DMA window:
> > > ---------------------------------------------------
> > > 
> > > 	/ {
> > > 		#address-cells = <1>;
> > > 		#size-cells = <1>;
> > > 
> > > 		iommu {
> > > 			/* master ID, address of DMA window */
> > > 			#address-cells = <2>;
> > > 			#size-cells = <2>;
> > > 		};
> > > 
> > > 		master {
> > > 			/* master ID 42, 4 GiB DMA window starting at 0 */
> > > 			iommus = <&/iommu  42 0  0x1 0x0>;
> > > 		};
> > > 	};
> > > 
> > > Does that sound about right?
> > 
> > Yes, sounds great. I would probably leave out the Multiple-master device
> > from the examples, since that seems to be a rather obscure case.
> 
> I think multi-master is the common case.

Which of the two cases above do you mean? I was referring to the first
as being obscure, not the second.

I still haven't seen an example of the first, while the second one
is very common.

> > ----------->8
> > 
> > Does that make sense to you? We can change what we say about
> > dma-ranges, I mainly want to be clear with what is or is not
> > allowed at this point.
> 
> I think it would be inconsistent and unnecessary to disallow it in the
> binding.  The meaning you've proposed seems completely consistent with
> ePAPR, so I suggest to keep it.  The IOMMU is just another bus master
> from the ePAPR point of view -- no need to make special rules for it
> unless they are useful.
> 
> The binding does not need to be (and generally shouldn't be) a
> description of precisely what the kernel does and does not support.
> 
> However, if we don't need to support non-identity dma-ranges in Linux
> yet, we have the option to barf if we see such a dma-ranges memorywards
> of an IOMMU, if it simplifies the Linux implementation.  We could always
> relax that later -- and it'll be obvious how to describe that situation
> in DT.

Ok.

> What I would like to see is a recommandation, based on Thierry's binding
> here, for describing how cross-mastering in general is described.  It's
> not really a binding, but more of a template for bindings.
> 
> I'm happy to have a go at writing it, then we can decide whether it's
> useful or not.

I don't mind if you take this on, but I'm not sure if that should be
part of this binding or not. Let's see what you come up with.

> There are a few things from the discussion that are *not* solved by this
> iommu binding, but they seem reasonable.  The binding also doesn't block
> solving those things later if/when needed:
> 
>  1) Cross-mastering to things that are not IOMMUs
> 
>     We might need to solve this later if we encounter SoCs with
>     problematic topologies, we shouldn't worry about it for the time
>     being.
> 
>     We'll to revisit it for GICv3 but that's a separate topic.


>  2) Describing address and ID remappings for cross-mastering.
> 
>     We can describe this in a way that is consistent with this IOMMU
>     binding.  We will need to describe something for GICv3, but the
>     common case will be that IDs are just passed through without
>     remapping.
> 
>     We don't need to clarify how IDs are propagated until we have
>     something in DT for IDs to propagate to.

Ok, thanks for pointing these out. I had forgotten about the MSI
case, but it seems ok to defer that part for now.

	Arnd
