Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbaD1MFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:05:45 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56343 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbaD1MFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:05:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thierry Reding <thierry.reding@gmail.com>, t.figa@samsung.com,
        Will Deacon <will.deacon@arm.com>, tomasz.figa@gmail.com,
        joshi@samsung.com, s.nawrocki@samsung.com, Varun.Sethi@freescale.com,
        kgene.kim@samsung.com, prathyush.k@samsung.com,
        sachin.kamat@linaro.org, joro@8bytes.org, devicetree@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>, grundler@chromium.org,
        linux-samsung-soc@vger.kernel.org, a.motakis@virtualopensystems.com,
        pullip.cho@samsung.com, rahul.sharma@samsung.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        supash.ramaswamy@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v12 11/31] documentation: iommu: add binding document of Exynos System MMU
Date: Mon, 28 Apr 2014 14:05:30 +0200
Message-ID: <4780885.JaktFvJeC7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140428111802.GI19455@ulmo>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com> <6544270.ddFBoY6LMm@wuerfel> <20140428111802.GI19455@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5/jNxjeAABBTtt7tH8RusMShzyKcQwp0nvh4u8G5rWY
 tETrD0oJUc8uX2M6vWK0rNcHpscQcPUmSLjocIkpCu8Zv4fodV
 XZk5DFCpeNvMWF5v5jRJkJhF3nBlieQeYtV6MN9u6CI74d78Dz
 biEP8fuxV3BzgJl94Hz9RIGhi6hRo9KaHkV2/SgDvjKgFJ+A15
 7kzkQ959vVKo1xQhnSPAVLUC+ypo+PPAcal6G9bk0bTp6wR1eh
 kWy4DhDFynal0KCKUePML5htHcvDvCgR/ZNToj0Kc78L57M+IN
 ZH40ewKV1HCfrkCqy5RQm4lZOAMyTCXnhDFIgasY9sVOI3b04D
 XWydUnhLVFcIxNw5WEwA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2014 13:18:03 Thierry Reding wrote:
> On Mon, Apr 28, 2014 at 12:56:03PM +0200, Arnd Bergmann wrote:
> > On Monday 28 April 2014 12:39:20 Thierry Reding wrote:
> > > And possibly with a iommu-names property to go along with that. The idea
> > > being that a device can be a master on possibly multiple IOMMUs. Using
> > > the above it would also be possible to have one device be multiple
> > > masters on the same IOMMU.
> > 
> > Yes, that seems reasonable. Just one question: How would you represent a
> > device that has multiple masters, with at least one connected to an IOMMU
> > and another one connected to memory directly, without going to the IOMMU?
> 
> Heh, I don't think I've ever thought about that use-case. I guess I was
> always assuming that in the absence of an IOMMU the device would simply
> access memory directly. From what I can tell that's how Tegra works at
> least. If the IOMMU is not enabled for a given client, that client will
> access physical memory untranslated.
> 
> I suppose if that really must be represented then a global dummy IOMMU
> could be introduced to help with these cases.

It's actually not too uncommon: you can have e.g. the lower 2GB mapped
directly from the device address space into the host memory, but have
an iommu that translates accesses from some range in the upper 2GB of
the 32-bit address space into full 64-bit addresses.

This use case makes no sense if you use the IOMMU for isolation
or virtualization, but it gives better performance for lowmem access
when the only reason to have the IOMMU is to map highmem addresses.

> > > On Tegra the specifier would be used to encode a memory controller's
> > > client ID. One discussion point back at the time was to encode the ID as
> > > a bitmask to allow more than a single master per entry. Another solution
> > > which I think is a little cleaner and more generic, would be to use one
> > > entry per master and use a single cell to encode the client ID. Devices
> > > with multiple clients to the same IOMMU could then use multiple entries
> > > referencing the same IOMMU.
> > 
> > I'm not completely following here. Are you talking about the generic
> > binding, or the part that is tegra specific for the specifier?
> > 
> > My first impression is that the generic binding should just allow an
> > arbitrary specifier with a variable #iommu-cells, and leave the format
> > up to the IOMMU driver.
> 
> Yes, I was getting ahead of myself. The idea was to have #iommu-cells
> and allow the specifier to be IOMMU-specific. On Tegra that would
> translate to the memory controller client ID, on other devices I suspect
> something similar might exist, but for the generic binding it should be
> completely opaque and hence irrelevant.
> 
> Really just like any of the other bindings that have foos and #foo-cells
> properties.

Ok.

> > A lot of drivers probably only support one
> > master, so they can just set #iommu-cells=<0>, others might require
> > IDs that do not fit into one cell.
> 
> You mean "#iommu-cells = <1>" for devices that only require one master?

I meant an IOMMU device that acts as the slave for exactly one device,
even if that device has multiple master ports.

> There still has to be one cell to specify which master. Unless perhaps
> if they can be arbitrarily assigned. I guess even if there's a fixed
> mapping that applies to one SoC generation, it might be good to still
> employ a specifier and have the mapping in DT for flexibility.

let me clarify by example:

	iommu@1 {
		compatible = "some,simple-iommu";
		reg = <1>;
		#iommu-cells = <0>; /* supports only one master */
	};

	iommu@2 {
		compatible = "some,other-iommu";
		reg = <3>;
		#iommu-cells = <1>; /* contains master ID */
	};

	iommu@3 {
		compatible = "some,windowed-iommu";
		reg = <2>;
		#iommu-cells = <2>; /* contains dma-window */
	};

	device@4 {
		compatible = "some,ethernet";
		iommus = <&/iommu@1>;
	};

	device@5 {
		compatible = "some,dmaengine";
		iommus = <&/iommu@2 0x40000000 0x1000000>,
			 <&/iommu@3 0x101>;
	};

The device at address 4 has a one-one relationship with iommu@1, so there
is no need for any data. device@5 has two master ports. One is connected to
an IOMMU that has a per-device aperture, device@5 can only issue transfers
to the 256MB area at 0x40000000, and the IOMMU will have to put entries for
this device into that address. The second master port is connected to
iommu@3, which uses a master ID that gets passed along with each transfer,
so that needs to be put into the IOTLBs.

A variation would be to not use #iommu-cells at all, but provide a
#address-cells / #size-cells pair in the IOMMU, and have a translation
as we do for dma-ranges. This is probably most flexible.

One completely open question that I just noticed is how the kernel should
deal with the case of multiple IOMMUs attached to one master: the
data structures we have assume that we know exactly how to do DMA by
setting the per-device dma_map_ops (iommu or not, coherent or not),
and by setting a pointer to at most one IOMMU.

	Arnd
