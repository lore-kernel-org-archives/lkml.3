Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaFBKli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:41:38 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54794 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752805AbaFBKlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:41:35 -0400
Date: Mon, 2 Jun 2014 11:41:04 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140602104104.GD3855@e103592.cambridge.arm.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com>
 <4545972.cM7IP1qTXQ@wuerfel>
 <CAL_Jsq+tkFNpjSEZboT+o69B_Z3a8e-ZVKaYDmLwtkyYoPy6VQ@mail.gmail.com>
 <5288123.eXagyPAxNq@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5288123.eXagyPAxNq@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 09:49:59PM +0200, Arnd Bergmann wrote:
> On Friday 30 May 2014 14:31:55 Rob Herring wrote:
> > On Fri, May 30, 2014 at 2:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Friday 30 May 2014 08:16:05 Rob Herring wrote:
> > >> On Fri, May 23, 2014 at 3:33 PM, Thierry Reding
> > >> <thierry.reding@gmail.com> wrote:
> > >> > From: Thierry Reding <treding@nvidia.com>
> > >> > +IOMMU master node:
> > >> > +==================
> > >> > +
> > >> > +Devices that access memory through an IOMMU are called masters. A device can
> > >> > +have multiple master interfaces (to one or more IOMMU devices).
> > >> > +
> > >> > +Required properties:
> > >> > +--------------------
> > >> > +- iommus: A list of phandle and IOMMU specifier pairs that describe the IOMMU
> > >> > +  master interfaces of the device. One entry in the list describes one master
> > >> > +  interface of the device.
> > >> > +
> > >> > +When an "iommus" property is specified in a device tree node, the IOMMU will
> > >> > +be used for address translation. If a "dma-ranges" property exists in the
> > >> > +device's parent node it will be ignored. An exception to this rule is if the
> > >> > +referenced IOMMU is disabled, in which case the "dma-ranges" property of the
> > >> > +parent shall take effect.
> > >>
> > >> Just thinking out loud, could you have dma-ranges in the iommu node
> > >> for the case when the iommu is enabled rather than putting the DMA
> > >> window information into the iommus property?
> > >>
> > >> This would probably mean that you need both #iommu-cells and #address-cells.
> > >
> > > The reason for doing like this was that you may need a different window
> > > for each device, while there can only be one dma-ranges property in
> > > an iommu node.
> > 
> > My suggestion was that you also put the IDs in the dma-ranges as the
> > first cell much as ranges for PCI encodes other information in the
> > first cell. Then you can have an entry for each ID. The downside is
> > another special case like PCI.
> > 
> > The argument for using #address-cells and #size-cells seems to be to
> > align with how ranges work. If that's the route we want to go, then I
> > say we should not stop there and actually use dma-ranges as well.
> > Otherwise, I don't see the advantage over #iommu-cells.
> 
> I can see how dma-ranges in bus nodes work, it just doesn't seem to
> have any reasonable meaning in the iommu node itself.

dma-ranges defines a static mapping for mastering through the bus node.

The whole point of an IOMMU is that it maps dynamically, so I agree:
I'm unclear on what dma-ranges should mean in the IOMMU node itself
(if anything).

> 
> > > I don't understand the problem. If you have stream IDs 0 through 7,
> > > you would have
> > >
> > >         master@a {
> > >                 ...
> > >                 iommus = <&smmu 0>;
> > >         };
> > >
> > >         master@b {
> > >                 ...
> > >                 iommus = <&smmu 1;
> > >         };
> > >
> > >         ...
> > >
> > >         master@12 {
> > >                 ...
> > >                 iommus = <&smmu 7;
> > >         };
> > >
> > > and you don't need a window at all. Why would you need a mask of
> > > some sort?
> > 
> > 1 master with 7 IDs like this:
> > 
> >          master@a {
> >                  ...
> >                  iommus = <&smmu 0> <&smmu 1> <&smmu 2> <&smmu 3>
> > <&smmu 4> <&smmu 5> <&smmu 6> <&smmu 7>;
> >          };
> > 
> > If there was any sort of window, then it is almost certainly the same
> > window for each ID.

Do we have real examples of using a window *and* an ID?  I thought the
windowed-IOMMU concept was partly a way of encoding the ID in some
real address bits on the bus.  If you're doing that, it seems less likely
that there is a true "ID" as such (though it is possible).

> Ok, I see. In that case you'd probably want to have #address-cells = <1>
> and #size-cells = <1> and give a range of IDs like
> 
> 	iommus = <&smmu 0 8>;
> 
> Do you think that ranges can have a meaningful definition with the ARM
> SMMU stream IDs?

In the strictest sense, no.

But for a large set of sane configurations, this probably works.

Small sets of randomly-assigned IDs can just be enumerated one by one.

We wouldn't be able to describe folding and bit shuffling, but we
probably don't want to encourage that anyway.

Cheers
---Dave
