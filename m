Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaFQKnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:43:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65261 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341AbaFQKnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:43:09 -0400
Date: Tue, 17 Jun 2014 11:43:04 +0100
From: Will Deacon <will.deacon@arm.com>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: Stuart Yoder <stuart.yoder@freescale.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140617104304.GD13808@arm.com>
References: <5288123.eXagyPAxNq@wuerfel>
 <20140602104104.GD3855@e103592.cambridge.arm.com>
 <20140604143509.GF28484@ulmo>
 <20140604164132.GF6644@arm.com>
 <07321368d15d4ad9928ebb83af87e401@DM2PR03MB479.namprd03.prod.outlook.com>
 <20140616152739.GS16758@arm.com>
 <8b0492b4697943a0b1f276ef42cc8223@DM2PR03MB352.namprd03.prod.outlook.com>
 <20140616170416.GA16758@arm.com>
 <419e67f783524d208ab3be16bcd94bd9@DM2PR03MB352.namprd03.prod.outlook.com>
 <0587e1f4894546398be0798d2bc2c84f@BL2PR03MB468.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0587e1f4894546398be0798d2bc2c84f@BL2PR03MB468.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 11:26:48AM +0100, Varun Sethi wrote:
> > The way we generally thought it would work was something like
> > this:
> >    -u-boot/bootloader makes any static streamID allocation if needed,
> >     sets a default streamID  (e.g. 0x0) in device and expresses
> >     that in the device tree
> >    -device tree would express relationship between devices
> >     (including bus controllers) and the SMMU through mmu-masters
> >     property
> >    -u-boot would express the range of unused (or used) streamIDs via a
> > new
> >     device tree property so the kernel SMMU driver knows what streamIDs
> > are
> >     free
> >    -in the SMMU driver a different vendor specific 'add_device' callback
> >     could be used to handle our special cases where we need to set/change
> >     the stream ID for devices added to a domain
> 
> Another possibility, could be to program the stream Id in the device
> registers (reference for the stream ID register can be obtained from the
> device tree) during device attach. This could be relevant in case of VFIO,
> when we are assigning multiple devices to a single VM. All the devices can
> share the same stream ID.

I think for simple masters (i.e. those that have all their StreamIDs under
control of one driver), then setting something during attach (or add?)
based on the DT could work pretty well. The other case is when we have
masters behind a bridge (such as a PCI RC). In this case, it might actually
be better to ask the bridge for the IDs and let it sort out the allocation
itself. That would also move the RequesterID -> StreamID mapping out of
the SMMU code.

What do you think?

Will
