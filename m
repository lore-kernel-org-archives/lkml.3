Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaGLM5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:57:35 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:47317 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaGLM5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:57:32 -0400
MIME-Version: 1.0
In-Reply-To: <201407121422.02078.arnd@arndb.de>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
	<20140712093917.GD18601@arm.com>
	<CAF6AEGutHp+3f3iPA+jjaRkqq=5T_vytZ_ESoSqsQ4RHZ8F8yQ@mail.gmail.com>
	<201407121422.02078.arnd@arndb.de>
Date: Sat, 12 Jul 2014 08:57:31 -0400
Message-ID: <CAF6AEGs7=3UByP2DLm-uwU03wr7M14x2t-0hLX-VPJ6_eZbU3g@mail.gmail.com>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
From: Rob Clark <robdclark@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 8:22 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 12 July 2014, Rob Clark wrote:
>> >> Was there actually a good reason for having the device link to the
>> >> iommu rather than the other way around?  How much would people hate it
>> >> if I just ignore the generic bindings and use something that works for
>> >> me instead.  I mean, it isn't exactly like there is going to be .dts
>> >> re-use across different SoC's..  and at least with current IOMMU API
>> >> some sort of of_get_named_iommu() API doesn't really make sense.
>> >
>> > The thing is, if you end up ignoring the generic binding then we have two
>> > IOMMUs using the same (ARM SMMU) binding and it begs the question as to
>> > which is the more generic! I know we're keen to get this merged, but merging
>> > something that people won't use and calling it generic doesn't seem ideal
>> > either. We do, however, desperately need a generic binding.
>>
>> yeah, ignoring the generic binding is not my first choice.  I'd rather
>> have something that works well for everyone.  But I wasn't really sure
>> if the current proposal was arbitrary, or if there are some
>> conflicting requirements between different platforms.
>
> The common case that needs to be simple is attaching one (master) device
> to an IOMMU using the shared global context for the purposes of implementing
> the dma-mapping API.

well, I don't disagree that IOMMU API has some problems.  It is too
tied to the bus type, which doesn't really seem to make sense for
platform devices.  (Unless we start having multiple platform busses?)

But at least given the current IOMMU API I'm not really sure how it
makes a difference which way the link goes.  But if there has already
been some discussion about how you want to handle the tie in with
dma-mapping, if you could point me at that then maybe your point will
make more sense to me.

> The way that Thierry's binding does that is the obvious solution to this,
> and it mirrors what we do in practically every other subsystem. I definitely
> want the SMMU to change before anybody starts using it in a real system,
> which we fortunately do not have yet.

hmm, well if some of the things I need for (like this or batching
mappings) are too weird and gpu specific, I'm willing to duplicate the
IOMMU driver in drm/msm.  It really isn't so much code, and that gives
me a lot more more flexibility to do crazy things... at some point I'm
probably going to want to do context switches by banging the IOMMU
registers directly from the gpu.

But given what Will said, I don't think what I need here is too far
out of line.  But if it is really a problem for dma-mapping, I suppose
we could have links in both directions?  However, I think the link
which contains the stream-id's really needs to be in the IOMMU, not
the device using the IOMMU.

BR,
-R
