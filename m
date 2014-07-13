Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaGMJnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 05:43:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57812 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237AbaGMJnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:39 -0400
Date: Sun, 13 Jul 2014 10:43:41 +0100
From: Will Deacon <will.deacon@arm.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joerg Roedel <joro@8bytes.org>,
        Olav Haugan <ohaugan@codeaurora.org>,
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
Message-ID: <20140713094341.GB23235@arm.com>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140712093917.GD18601@arm.com>
 <CAF6AEGutHp+3f3iPA+jjaRkqq=5T_vytZ_ESoSqsQ4RHZ8F8yQ@mail.gmail.com>
 <201407121422.02078.arnd@arndb.de>
 <CAF6AEGs7=3UByP2DLm-uwU03wr7M14x2t-0hLX-VPJ6_eZbU3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGs7=3UByP2DLm-uwU03wr7M14x2t-0hLX-VPJ6_eZbU3g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 01:57:31PM +0100, Rob Clark wrote:
> On Sat, Jul 12, 2014 at 8:22 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Saturday 12 July 2014, Rob Clark wrote:
> >> >> Was there actually a good reason for having the device link to the
> >> >> iommu rather than the other way around?  How much would people hate it
> >> >> if I just ignore the generic bindings and use something that works for
> >> >> me instead.  I mean, it isn't exactly like there is going to be .dts
> >> >> re-use across different SoC's..  and at least with current IOMMU API
> >> >> some sort of of_get_named_iommu() API doesn't really make sense.
> >> >
> >> > The thing is, if you end up ignoring the generic binding then we have two
> >> > IOMMUs using the same (ARM SMMU) binding and it begs the question as to
> >> > which is the more generic! I know we're keen to get this merged, but merging
> >> > something that people won't use and calling it generic doesn't seem ideal
> >> > either. We do, however, desperately need a generic binding.
> >>
> >> yeah, ignoring the generic binding is not my first choice.  I'd rather
> >> have something that works well for everyone.  But I wasn't really sure
> >> if the current proposal was arbitrary, or if there are some
> >> conflicting requirements between different platforms.
> >
> > The common case that needs to be simple is attaching one (master) device
> > to an IOMMU using the shared global context for the purposes of implementing
> > the dma-mapping API.
> 
> well, I don't disagree that IOMMU API has some problems.  It is too
> tied to the bus type, which doesn't really seem to make sense for
> platform devices.  (Unless we start having multiple platform busses?)
> 
> But at least given the current IOMMU API I'm not really sure how it
> makes a difference which way the link goes.  But if there has already
> been some discussion about how you want to handle the tie in with
> dma-mapping, if you could point me at that then maybe your point will
> make more sense to me.

If you look at the proposed binding in isolation, I think it *is* cleaner
than the ARM SMMU binding (I've acked it...) and I believe it's more
consistent with the way we describe linkages elsewhere.

However, the issue you're raising is that it's more difficult to make use of
in a Linux IOMMU driver. The reward you'll get for using it will come
eventually when the DMA ops are automatically swizzled for devices using the
generic binding.

My plan for the ARM SMMU driver is:

  (1) Change ->probe() to walk the device-tree looking for all masters with
      phandles back to the SMMU instance being probed

  (2) For each master, extract the Stream IDs and add them to the internal
      SMMU driver data structures (an rbtree per SMMU instance). For
      hotpluggable buses, we'll need a way for the bus controller to
      reserve a range of IDs -- this will likely be a later extension to
      the binding.

  (3) When we get an ->add() call, warn if it's a device we haven't seen
      and reject the addition.

That way, ->attach() should be the same as it is now, I think.

Have you tried implementing something like that? We agreed that (1) isn't
pretty, but I don't have a good alternative and it's only done at
probe-time.

Will

BTW: Is the msm-v0 IOMMU compatible with the ARM SMMU driver, or is it a
completely different design requiring a different driver?
