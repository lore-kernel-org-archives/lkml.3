Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398AbaE3TMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:12:07 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59919 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaE3TMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:12:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Joerg Roedel <joro@8bytes.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Date: Fri, 30 May 2014 21:11:07 +0200
Message-ID: <4663172.oXIylQOrlk@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140530112728.GB3949@e103592.cambridge.arm.com>
References: <1400877395-4235-1-git-send-email-thierry.reding@gmail.com> <20140530073006.GA24748@ulmo> <20140530112728.GB3949@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:AKhJVynj57Ol4BgqMLyHaRGgLZVUzr/qfigo0KIeTGN
 yQeo7PD3miczCx+9RJ9Rzc6Y1wnXJOm4ILQ7pVyIhC8ib8gpfT
 AkiCeJVn1C8Cb175tFIOnB5yl4u0nXJNGD/wtcSYcadCu+WfAP
 R5xNClDgoQ1RYRJdzYA8O0eAH67rRq/MymKC8t1Kz8Dg//eyJn
 31pK3k0elcoaK2ljn26m/c7ntDYssqtlklQjmzyyf82qdkEUCL
 ymMnNiua0td+WSkj7cyIfn52JoGI3K5d/yRro6RfOpwrtJTlb/
 I0+gAQpLAEXA+E7u9ADMHcoNPH6GBkRozVayTKkPuSci/UfuLi
 g95DBZ8xpyrPq5NFzqw8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 May 2014 12:27:28 Dave Martin wrote:
> On Fri, May 30, 2014 at 08:30:08AM +0100, Thierry Reding wrote:
> > On Thu, May 29, 2014 at 09:52:22AM -0600, Stephen Warren wrote:
> > > On 05/23/2014 02:36 PM, Thierry Reding wrote:
> > > I think this is a mistake. address-cells/size-cells are for transactions
> > > flowing down the bus (from the CPU to date). Describing a connection
> > > from a device to an IOMMU is something completely different, and should
> > > therefore simply use an iommu-cells property to describe any necessary
> > > information. If we start re-using properties for different things in
> > > different contexts, how is anyone going to know what they mean, and how
> > > will conflicts be resolved. For example, what if there's a single HW
> > > module that both acts as a regular register bus with children (where
> > > address-cells/size-cells defines how transactions reach the children
> > > from the parent), and is also an IOMMU (where according to this binding
> > > proposal, address-cells/size-cells represent some aspect of the IOMMU
> > > feature). Using different properties for different things is the only
> > > sane way to keep different concepts separate. Another alternative would
> > > be to represent the single HW module as separate nodes in DT, but I
> > > think that will only make our lives harder, and where I've done that in
> > > the past, I've regretted it.
> > 
> > There was some back-and-forth on this topic and the latest concensus
> > when I wrote the second version was that #address-cells and #size-cells
> > were to be used.
> > 
> > But there was some bore back-and-forth after that, and it seems like
> > Arnd no longer thinks that using #address-cells and #size-cells is a
> > good idea either[0].
> 
> Mistake or not, ePAPR already (ab)uses the address concept for PCI.
> Unless ePAPR is wrong, I don't think it makes sense to argue that
> the address concept cannot be repurposed.
> 
> The reason why this is abused for PCI is the same as our reason here:
> different masters really are treated as distinct even when accessing
> the same destination address, and DT has no general native way to
> describe that.
> 
> One clear advantage of using #address-cells etc. is that ePAPR already
> has very clear and well-defined ways of how to specify range mappings.
> This gives us a ready-made way to describe windowed IOMMUs and 1:1
> remappings of whole blocks of master IDs, which are the most obvious
> cases other than having a small-integer set of explicit IDs.
> 
> That said, the PCI pseudo-address thing is not something we _necessarily_
> want to repeat.

I'm really impartial to the question of whether to use #address-cells
or #iommus now. It's possible that we can use the addresses in some
meaningful way, but it's not clear to me that this will help make the
representation cleaner or that we will actually want it for SMMU.

> > Arnd, can you take another look at this binding and see if there's
> > anything else missing? If not I'll go through the document again and
> > update all #address-cells/#size-cells references with #iommu-cells as
> > appropriate and submit v3.
> 
> How do you envisage propagation of the master ID bits downstream of the
> IOMMU would be described?
> 
> We will definitely need a way to describe this for GICv3.  How those
> values are propagated is likely to vary between related SoCs and doesn't
> feel like it should be baked into a driver, especially for the ARM SMMU
> which may get reused in radically different SoC families from different
> vendors.
> 
> The most likely types of remapping are the adding of a base offset or
> some extra bits to the ID -- because not all MSIs to the GIC will
> necessarily pass through the IOMMU.  It's also possible that we might
> see ID squashing or folding in some systems.
> 
> 
> For types of remapping which mix the ID and address together, I now
> do tend to agree that any flexibility arising from describing that
> in a general way that is unlikely to repay the cost of trying to
> interpret and analyse the DT.  Defining a few sterotypical kinds
> of mapping explicitly, as needed, looks more sensible for now.  The
> windowed-IOMMU case is one example.

For MSI, my feeling is that we'd just be best off doing an end-to-end
description. Any device using an MSI would have an interrupt specifier
that is sufficient for the interrupt controller to understand where
the IRQ comes from, and return an address/value pair back to the driver
to program into some register.

	Arnd
