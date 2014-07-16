Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbaGPKLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:11:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36004 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751590AbaGPKLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:11:06 -0400
Date: Wed, 16 Jul 2014 11:10:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: Olav Haugan <ohaugan@codeaurora.org>
Cc: Rob Clark <robdclark@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joerg Roedel <joro@8bytes.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140716101053.GJ29414@arm.com>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140712093917.GD18601@arm.com>
 <CAF6AEGutHp+3f3iPA+jjaRkqq=5T_vytZ_ESoSqsQ4RHZ8F8yQ@mail.gmail.com>
 <201407121422.02078.arnd@arndb.de>
 <CAF6AEGs7=3UByP2DLm-uwU03wr7M14x2t-0hLX-VPJ6_eZbU3g@mail.gmail.com>
 <20140713094341.GB23235@arm.com>
 <CAF6AEGt5cQhDCZgYX4=M1EKE=n2J=9G6mO02JMx-+Fcq_0ukfw@mail.gmail.com>
 <53C5D480.3030409@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C5D480.3030409@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 02:25:20AM +0100, Olav Haugan wrote:
> On 7/13/2014 4:43 AM, Rob Clark wrote:
> > On Sun, Jul 13, 2014 at 5:43 AM, Will Deacon <will.deacon@arm.com> wrote:
> >> My plan for the ARM SMMU driver is:
> >>
> >>   (1) Change ->probe() to walk the device-tree looking for all masters with
> >>       phandles back to the SMMU instance being probed
> >>
> >>   (2) For each master, extract the Stream IDs and add them to the internal
> >>       SMMU driver data structures (an rbtree per SMMU instance). For
> >>       hotpluggable buses, we'll need a way for the bus controller to
> >>       reserve a range of IDs -- this will likely be a later extension to
> >>       the binding.
> >>
> >>   (3) When we get an ->add() call, warn if it's a device we haven't seen
> >>       and reject the addition.
> >>
> >> That way, ->attach() should be the same as it is now, I think.
> >>
> >> Have you tried implementing something like that? We agreed that (1) isn't
> >> pretty, but I don't have a good alternative and it's only done at
> >> probe-time.
> > 
> > I haven't tried implementing that yet, but I'm sure it would work.  I
> > was just hoping to avoid having to do that ;-)
> 
> Is the reason you want to do it this way because you want to guarantee
> that all masters (and stream IDs) have been identified before the first
> attach call? I am just wondering why you cannot continue doing the
> master/streamID discovery during add_device() callback?

That's fine if we have one SMR per ID, but the moment we want to do more
involved matching, we're going to need complete system knowledge prior to
the first attach. I don't think we can safely reconfigure live streams on
the fly.

> >> BTW: Is the msm-v0 IOMMU compatible with the ARM SMMU driver, or is it a
> >> completely different design requiring a different driver?
> > 
> > My understanding is that it is different from msm v1 IOMMU, although I
> > think it shares the same pagetable format with v1.  Not sure if that
> > is the same as arm-smmu?   If so it might be nice to try to extract
> > out some shared helper fxns for map/unmap as well.
> > 
> > I expect Olav knows better the similarities/differences.
> > 
> 
> The msm-v0 IOMMU is not compatible with ARM SMMUv1 specification.
> However, it is a close cousin. The hardware was designed before the ARM
> SMMUv1 specification was available I believe. But it shares many of the
> same concepts as the ARM SMMUv1.
> 
> msm-v0 IOMMU supports V7S page table format only. The ARM SMMU driver
> does not support V7S at this time. However, I believe we need to support
> this.
> 
> Will, this reminds me. We definitely have a need to use different page
> tables in the ARM SMMU driver vs. the ARM CPU. We have an SoC with ARMv8
> cores (and thus ARMv8 page tables) but the SMMUs (SMMUv1) on this SoC
> only have support for V7S/V7L page table format. So we cannot use the
> same page table format as the CPU.

That sounds like a sane use-case. The best thing to do would be to add
some ARM page-table code as a library under drivers/iommu/, then we can
move the ARM IOMMUs over to using that. Since we'd be moving away from the
CPU page table helpers, we could also take the opportunity to use the
coherent DMA API instead of the hack I currently use for flushing out tables
to non-coherent walkers.

Will
