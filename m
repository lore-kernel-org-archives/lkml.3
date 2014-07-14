Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaGNKIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:08:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36331 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057AbaGNKIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:08:23 -0400
Date: Mon, 14 Jul 2014 11:08:13 +0100
From: Will Deacon <will.deacon@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Clark <robdclark@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <20140714100813.GC1779@arm.com>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140712093917.GD18601@arm.com>
 <CAF6AEGutHp+3f3iPA+jjaRkqq=5T_vytZ_ESoSqsQ4RHZ8F8yQ@mail.gmail.com>
 <201407121422.02078.arnd@arndb.de>
 <CAF6AEGs7=3UByP2DLm-uwU03wr7M14x2t-0hLX-VPJ6_eZbU3g@mail.gmail.com>
 <20140713094341.GB23235@arm.com>
 <20140714064452.GD2081@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714064452.GD2081@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Mon, Jul 14, 2014 at 07:44:53AM +0100, Thierry Reding wrote:
> On Sun, Jul 13, 2014 at 10:43:41AM +0100, Will Deacon wrote:
> > My plan for the ARM SMMU driver is:
> > 
> >   (1) Change ->probe() to walk the device-tree looking for all masters with
> >       phandles back to the SMMU instance being probed
> 
> You and Rob mentioned this several times and I don't understand why the
> SMMU needs to know all masters up front. Is this necessary because it
> needs to program all registers at .probe() time and they can't be
> reprogrammed subsequently? Or is this just some kind of optimization?

It's an optimization to reduce resource usage in the IOMMU, but one that
is *required* by certain platforms (e.g. Olav mentioned his 43-ID master
and Calxeda had something similar).

Basically, in order to perform an ->attach() for a master to a domain, we
need complete knowledge of the system so that we can avoid accidentally
attaching other masters to the same domain. The programming is done using
a form of StreamID wildcarding, so at this point we would need to have
parsed the entire DT to ensure our wildcard doesn't match other masters.

> >   (2) For each master, extract the Stream IDs and add them to the internal
> >       SMMU driver data structures (an rbtree per SMMU instance). For
> >       hotpluggable buses, we'll need a way for the bus controller to
> >       reserve a range of IDs -- this will likely be a later extension to
> >       the binding.
> > 
> >   (3) When we get an ->add() call, warn if it's a device we haven't seen
> >       and reject the addition.
> 
> It seems to me like this would be the logical place to parse stream IDs.

We could do that only if we were guaranteed to have an ->add() call for
*every* master before an ->attach() call for *any* master. I don't think
that is necessarily true.

> You could for example have a case where some device tree contains a node
> for which no driver will ever be loaded (for example because it hasn't
> been built-in, or the device is never used and the module is therefore
> never loaded). That's a situation that you cannot determine by simply
> walking the device tree in the IOMMU's .probe().

Why not? If we're simply searching for phandles to the IOMMU, why does it
matter whether a driver is bound to the master?

> I've always thought about IOMMU masters much in the same way as other
> types of resources, such as memory or interrupts. In the rest of the
> kernel we do carefully try to postpone allocation of these resources
> until they are required, specifically so we don't waste resources when
> they're unused.

See above, they are all required the moment anybody tries an ->attach().

> That's also one of the reasons why I think associating an IOMMU with the
> bus type is bad. Currently if an IOMMU driver thinks it should enable
> translation for a given device, then there's no way for that device's
> driver to opt out again. There may be reasons (performance, hardware
> bugs, ...) for the driver to decide against using the IOMMU for
> translation, but there's currently no way to do that if the IOMMU driver
> disagrees.

Yes, we need a way to associate an IOMMU with a bus instance, but I think
that's a separate topic, no?

Will
