Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab3AQQkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:40:13 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54625 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757211Ab3AQQkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:40:10 -0500
Date: Thu, 17 Jan 2013 16:39:41 +0000
From: Will Deacon <will.deacon@arm.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "pullip.cho@samsung.com" <pullip.cho@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "prathyush.k@samsung.com" <prathyush.k@samsung.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "subash.ramaswamy@linaro.org" <subash.ramaswamy@linaro.org>,
        "sanghyun75.lee@samsung.com" <sanghyun75.lee@samsung.com>,
        "rahul.sharma@samsung.com" <rahul.sharma@samsung.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v5 06/14] ARM: EXYNOS: add System MMU definition to DT
Message-ID: <20130117163941.GL3699@mudshark.cambridge.arm.com>
References: <003601cdd790$082a1310$187e3930$%cho@samsung.com>
 <20130116115114.GB16543@mudshark.cambridge.arm.com>
 <20130116.184321.179736289870581833.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116.184321.179736289870581833.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiroshi,

On Wed, Jan 16, 2013 at 04:43:21PM +0000, Hiroshi Doyu wrote:
> Will Deacon <will.deacon@arm.com> wrote @ Wed, 16 Jan 2013 12:51:14 +0100:
> > Given that this information is not discoverable, it needs to be encoded
> > in the device tree, but where? I can see two approaches:
> > 
> >   1. For each IOMMU node, list phandles to the devices connected to it
> >      and have a corresponding list of StreamIDs.
> > 
> > or
> > 
> >   2. For each device wishing to use an IOMMU, have a phandle to the
> >      IOMMU node and a separate StreamID property. The IOMMU would then
> >      parse this information when the device is added to the bus.
> > 
> > Although I prefer the second approach, it has the downside of affecting
> > all device bindings that wish to use an IOMMU, so I'm open to any other
> > ideas.
> 
> Actually the above summarize tegra SMMU situation well too. For
> example, each IOMMU'able device has IOVA constraint that some of the
> address area isn't available because of its MMIO. This info needs to
> be described in DT. If <IOMMU phandle> + some parametes are embedded
> in a device node, that info could be dealt at a bus notifier(*1).
> 
> *1: http://lists.linuxfoundation.org/pipermail/iommu/2012-November/004934.html

I've been thinking about this a bit more and, unfortunately, my conclusion
is that method (2) above is problematic, so we do need something similar to
(1).

The reason for this comes about when dealing with chained IOMMUs. In this
case, each IOMMU in the chain needs to know about all of the masters hanging
beneath it (potentially behind other IOMMUs) but may also need to supplement
each device with additional data relevant to that point in the IOMMU chain.
In the case of the ARM System MMU, this could be StreamID information (as
the StreamID for a device can change as the transaction stream passes
through an SMMU) and for your case it could be that the DMA window is
widened along the chain.

So, extending the mmu-master property described in this thread to be
"mmu-masters : a list of phandles to device nodes representing bus masters
for which the IOMMU can provide a translation" is probably a good start.

Will
