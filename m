Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaETNf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:35:58 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:62098 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaETNf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:35:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, iommu@lists.linux-foundation.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org, Cho KyongHo <pullip.cho@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Date: Tue, 20 May 2014 15:34:46 +0200
Message-ID: <4161434.ylGuoPKcfs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140520131741.GB6240@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <8663464.40PHEumOar@wuerfel> <20140520131741.GB6240@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:a6P9Gzab1xbfCvDeQxo3NasssrsUcf1EMrbBii64Smj
 v3Cu8Grk4H8hvSPCSgFnLD2Hi25NKY1WN4gi8uTHBe5bk36hQ6
 zxPgcHUHj6KqwxQCnsqc6jwuLe0+m5MVuFHSuKU5Rfy5j/u1AF
 npA6URLDOGd9YO+3NdzghxVEQa6V+YDGHvjC4YFl6oZcGeAf8T
 nE7hN+dLNBaMHPanzKEayabLyyaGH4PnWTb5406dBRKo4aFHHg
 4X3ynBF6fH7wNANIFQe+gjPfdnFaDloBl7aiyEEcCPHPbxn9t1
 sRBsbufQND4UZ0EDATC1/WoG47aL4WtEBhooMIGZleG/ndEfxW
 bs1obq7cXxQUhdPoOOkg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 15:17:43 Thierry Reding wrote:
> On Tue, May 20, 2014 at 02:41:18PM +0200, Arnd Bergmann wrote:
> > On Tuesday 20 May 2014 14:02:43 Thierry Reding wrote:
> [...]
> > > Couldn't a single-master IOMMU be windowed?
> > 
> > Ah, yes. That would actually be like an IBM pSeries, which has a windowed
> > IOMMU but uses one window per virtual machine. In that case, the window could
> > be a property of the iommu node though, rather than part of the address
> > in the link.
> 
> Does that mean that the IOMMU has one statically configured window which
> is the same for each virtual machine? That would require some other
> mechanism to assign separate address spaces to each virtual machine,
> wouldn't it? But I suspect that if the IOMMU allows that it could be
> allocated dynamically at runtime.

The way it works on pSeries is that upon VM creation, the guest is assigned
one 256MB window for use by assigned DMA capable devices. When the guest
creates a mapping, it uses a hypercall to associate a bus address in that
range with a guest physical address. The hypervisor checks that the bus
address is within the allowed range, and translates the guest physical
address into a host physical address, then enters both into the I/O page
table or I/O TLB.

> > I would like to add an explanation about dma-ranges to the binding:
> > 
> > 8<--------
> > The parent bus of the iommu must have a valid "dma-ranges" property
> > describing how the physical address space of the IOMMU maps into
> > memory.
> 
> With physical address space you mean the addresses after translation,
> not the I/O virtual addresses, right? But even so, how will this work
> when there are multiple IOMMU devices? What determines which IOMMU is
> mapped via which entry?
> 
> Perhaps having multiple IOMMUs implies that there will have to be some
> partitioning of the parent address space to make sure two IOMMUs don't
> translate to the same ranges?

These dma-ranges properties would almost always be for the entire RAM,
and we can treat anything else as a bug.

The mapping between what goes into the IOMMU and what comes out of it
is not reflected in DT at all, since it only happens at runtime.
The dma-ranges property I mean above describes how what comes out of
the IOMMU maps into physical memory.

> > A device with an "iommus" property will ignore the "dma-ranges" property
> > of the parent node and rely on the IOMMU for translation instead.
> 
> Do we need to consider the case where an IOMMU listed in iommus isn't
> enabled (status = "disabled")? In that case presumably the device would
> either not function or may optionally continue to master onto the parent
> untranslated.

My reasoning was that the DT should specify whether we use the IOMMU
or not. Being able to just switch on or off the IOMMU sounds nice as
well, so we could change the text above to do that.

Another option would be to do this in the IOMMU code, basically
falling back to the IOMMU parent's dma-ranges property and using
linear dma_map_ops when that is disabled.

> > Using an "iommus" property in bus device nodes with "dma-ranges"
> > specifying how child devices relate to the IOMMU is a possible extension
> > but is not recommended until this binding gets extended.
> 
> Just for my understanding, bus device nodes with iommus and dma-ranges
> properties could be equivalently written by explicitly moving the iommus
> properties into the child device nodes, right? In which case they should
> be the same as the other examples. So that concept is a convenience
> notation to reduce duplication, but doesn't fundamentally introduce any
> new concept.

The one case  where that doesn't work is PCI, because we don't list the
PCI devices in DT normally, and the iommus property would only exist
at the PCI host controller node.

	Arnd
