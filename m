Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaFGNXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 09:23:12 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57908 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaFGNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 09:23:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Date: Sat, 07 Jun 2014 15:22:13 +0200
Message-ID: <4306568.dZTtF4xhhK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140606224542.GA22188@mithrandir>
References: <20140606224542.GA22188@mithrandir>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:jNpaa1jELX5G2xTyQOi6snbI6lekNdkoZ0vOJMdFxXh
 VCYlaJF3EqhmxrV7qwPTqqm8+FjXgq2fLhQW7TESvk+Fz1SVY5
 tzmNV7+hd2k1WjRojfnyj+y7WoHIn02MQ3gjjziomyiP8RbLW+
 H4cKZI5ZUWxGlh2Su/X+rCFtOPVTGYDbDUEQPgeO6JwoqZ8U0j
 GaPi6aNDmObr4Zmxn2WitKxWv70ooBzZcQIKdIixEZOhsNUo3B
 YhygHICOJr0EBX/EnQqSakLJbYx6AZBlj0ds3N4DnVSfujG/xa
 EvfMu1JF1aX/U3RS9ZrFOIQvyiFGwqWxBGf4AFRF6vnjMYwO0n
 yrsSiP1e/ENyuc7Ufn9c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 June 2014 00:45:45 Thierry Reding wrote:
> This is somewhat off-topic, but given the various concepts discussed in
> this thread I'm beginning to wonder how they will be implemented.

I think it's good you raised the question.

> The
> current implementation hooks the IOMMU API into the DMA mapping API, and
> the way this is done is by setting a single IOMMU (or rather a set of
> IOMMU operations) globally per bus type.

I hadn't realized that we have a per-bus iommu_ops pointer. I agree
this will become a limitation as soon as we have a soc with two different
IOMMUs that have platform devices attached, and it has to be moved into
the device or a structure related to that.

If that turns out controversial, we can probably have a set of pseudo
iommu ops that just call into dev->archdata->iommu_ops->function()
for ARM.

> There are two issues that I can see with that: one is that we can't
> support multiple IOMMUs in the system at all, and the other is that
> there is no context associated with the IOMMU ops, and therefore there
> is no way to differentiate between two instances of the same IOMMU. A
> few drivers use global variables to keep track of context information
> but that won't work with multiple instances, unless they keep a global
> list of all instances and then require explicit lookup in each of the
> IOMMU operations. That sounds more like a workaround rather than a
> proper solution to me.

Supporting multiple iommus that share one iommu driver should work
without such hacks, as you can put the per-device information into
dev->device_dma_parameters (this works only for very simple IOMMUs)
or dev->archdata->iommu (we may want to generalize that, I think
someone just posted patches for it).

> Discussion in this thread indicates that both of the above will be
> required at some point. Have I completely missed something or will we
> have to rework (parts of) the IOMMU API to make this work?
> 
> One other thing that I have some difficulty understanding is how we can
> support things like process isolation using the current IOMMU API. Since
> a device will be statically assigned to one IOMMU domain at probe time
> there is no way we can change the address space upon a context switch.

We have just introduced a way to parse dma-ranges in of_dma_configure().

The only way I see this done for platform devices is to do the IOMMU
configuration in the same place: if an iommus property is found there,
we call out to the iommu driver that matches the respective iommu device
and let it configure the master device.

The device already has multiple properties related to iommus:
'struct device_dma_parameters', 'archdata', 'iommu_group', and
pdev_archdata for platform devices. This should be enough to set up
the default iommu dma_map_ops so we can have non-isolated DMA using
dma_map_* and dma_alloc_coherent.

I haven't given much thought to devices that want to use the IOMMU
API directly so they can have multiple domains rather than rely on
the dma-mapping abstraction.

	Arnd
