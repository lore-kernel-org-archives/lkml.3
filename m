Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbaG3SSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:18:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45605 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbaG3SSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:18:48 -0400
Date: Wed, 30 Jul 2014 19:18:42 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140730181842.GG20162@leverpostej>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140730152646.GC20162@leverpostej>
 <CAOesGMi3zM1-cqmeGddJ69RNXx0ktFm_zXO_yq7N0EeA3HNrUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMi3zM1-cqmeGddJ69RNXx0ktFm_zXO_yq7N0EeA3HNrUQ@mail.gmail.com>
Thread-Topic: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> >> +Multiple-master IOMMU:
> >> +----------------------
> >> +
> >> +     iommu {
> >> +             /* the specifier represents the ID of the master */
> >> +             #iommu-cells = <1>;
> >> +     };
> >> +
> >> +     master@1 {
> >> +             /* device has master ID 42 in the IOMMU */
> >> +             iommus = <&/iommu 42>;
> >> +     };
> >> +
> >> +     master@2 {
> >> +             /* device has master IDs 23 and 24 in the IOMMU */
> >> +             iommus = <&/iommu 23>, <&/iommu 24>;
> >> +     };
> >
> > In future I suspect master will need to be able to identify which master
> > IDs correspond to which of their master ports (where each port might
> > have an arbitrary number of master IDs).
> >
> > While we don't need that for the first run, it would be nice to have
> > that looked into so master bindings don't come up with arbitrarily
> > different ways of doing that.
> 
> iommu-names would be the logical extension to handle that, just like
> we do with other resources, right?

Possibly. If the master has multiple IDs assigned to transactions from a
single master port then it depends on how the master wants to group
those for the sake of the binding. If it's per-port then you'd need the
same name multiple times:

iommus = <&iommu 0>, <&iommu 4>, <&iommu 17>, <&iommu 25>;
iommu-names = "video", "video", "dram", dram";

This is really specific to a given master, so we can table that until
the first master appears which needs to distinguish between IDs.

> >> +
> >> +Multiple-master IOMMU with configurable DMA window:
> >> +---------------------------------------------------
> >> +
> >> +     / {
> >> +             #address-cells = <1>;
> >> +             #size-cells = <1>;
> >> +
> >> +             iommu {
> >> +                     /* master ID, address and length of DMA window */
> >> +                     #iommu-cells = <4>;
> >> +             };
> >> +
> >> +             master {
> >> +                     /* master ID 42, 4 GiB DMA window starting at 0 */
> >> +                     iommus = <&/iommu  42  0  0x1 0x0>;
> >
> > Is this that window is from the POV of the master, i.e. the master can
> > address 0x0 to 0xffffffff when generating transactions, and these get
> > translated somehow?
> >
> > Or is this the physical addresses to allocate to the master?
> 
> It needs to be clarified in the documentation, but as far as I know it
> is the DMA address space that is used.

Ok. So that's pre-translation, from the POV of the master?

If we don't have that knowledge about the master already (e.g. based on
the compatible string), surely we always need that information in a
given iommu-specifier format? Otherwise certain iommus won't be able to
handle masters with limited addressing only due to limitations of their
binding.

> It is somewhat confusing to have size-cells = 1 and then use 2 cells
> for size in the iommu property. It's legal and expected, but having
> size-cells in the example adds a little confusion.
> 
> Either way, I'm OK with fixing the above with an incremental patch,
> assuming there is no disagreements on what's said above.

I like the general idea.

Given my concerns are to do with implementation details I'm happy to
have this go through and fix it up as the first implementations of the
binding take shape.

Thanks,
Mark.
