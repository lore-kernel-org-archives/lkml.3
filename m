Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069AbaETUcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:32:13 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:63264 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaETUcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:32:10 -0400
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
Date: Tue, 20 May 2014 22:31:29 +0200
Message-ID: <5123714.0MpMQfsmcr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140520135956.GA23140@ulmo>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com> <4161434.ylGuoPKcfs@wuerfel> <20140520135956.GA23140@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BKdRC9nLSIt3VSR6Sbdl0nx1J+SeZTE1w0wbmtlovR9
 qs2decDUgdXEw1eiYm2BpGHDLhMUJCWijHN2qzLzEYNNjlzHMQ
 U0U+aqeff9IlSfKRACqZeXftjEXPXxyujhF1snE/HAuajZo3bb
 moFrl0AJ2VfFPl5DwzosH8NSJDzb0nVIgEN+TJcZj+0S7VeIbg
 pvrznc4hV5csxAR2akn+Oj5HTWW+PG9lum9B3ZJGl6P9w5OKfd
 6fqUsforglTcMVRiuCQJ9ggL59ktRAzHslm4SWWPJDTfHYU/5+
 lKqrd2/NiWfYCSDXkoqmJhM8uwljImJPUEBdIOYHbZCZnQCs23
 mobszKTm2ROu9R4gRpO0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 16:00:02 Thierry Reding wrote:
> On Tue, May 20, 2014 at 03:34:46PM +0200, Arnd Bergmann wrote:
> > On Tuesday 20 May 2014 15:17:43 Thierry Reding wrote:
> > > On Tue, May 20, 2014 at 02:41:18PM +0200, Arnd Bergmann wrote:
> > > > On Tuesday 20 May 2014 14:02:43 Thierry Reding wrote:
> > > [...]
> > > > > Couldn't a single-master IOMMU be windowed?
> > > > 
> > > > Ah, yes. That would actually be like an IBM pSeries, which has a windowed
> > > > IOMMU but uses one window per virtual machine. In that case, the window could
> > > > be a property of the iommu node though, rather than part of the address
> > > > in the link.
> > > 
> > > Does that mean that the IOMMU has one statically configured window which
> > > is the same for each virtual machine? That would require some other
> > > mechanism to assign separate address spaces to each virtual machine,
> > > wouldn't it? But I suspect that if the IOMMU allows that it could be
> > > allocated dynamically at runtime.
> > 
> > The way it works on pSeries is that upon VM creation, the guest is assigned
> > one 256MB window for use by assigned DMA capable devices. When the guest
> > creates a mapping, it uses a hypercall to associate a bus address in that
> > range with a guest physical address. The hypervisor checks that the bus
> > address is within the allowed range, and translates the guest physical
> > address into a host physical address, then enters both into the I/O page
> > table or I/O TLB.
> 
> So when a VM is booted it is passed a device tree with that DMA window?

Correct.

> Given what you describe above this seems to be more of a configuration
> option to restrict the IOMMU to a subset of the physical memory for
> purposes of virtualization. So I agree that this wouldn't be a good fit
> for what we're trying to achieve with iommus or dma-ranges in this
> binding.

Thinking about it again now, I wonder if there are any other use cases
for windowed IOMMUs. If this is the only one, there might be no use
in the #address-cells model I suggested instead of your original
#iommu-cells.

> > > > I would like to add an explanation about dma-ranges to the binding:
> > > > 
> > > > 8<--------
> > > > The parent bus of the iommu must have a valid "dma-ranges" property
> > > > describing how the physical address space of the IOMMU maps into
> > > > memory.
> > > 
> > > With physical address space you mean the addresses after translation,
> > > not the I/O virtual addresses, right? But even so, how will this work
> > > when there are multiple IOMMU devices? What determines which IOMMU is
> > > mapped via which entry?
> > > 
> > > Perhaps having multiple IOMMUs implies that there will have to be some
> > > partitioning of the parent address space to make sure two IOMMUs don't
> > > translate to the same ranges?
> > 
> > These dma-ranges properties would almost always be for the entire RAM,
> > and we can treat anything else as a bug.
> 
> Would it typically be a 1:1 mapping? In that case could we define an
> empty dma-ranges property to mean exactly that? That would make it
> consistent with the ranges property.

Yes, I believe that is how it's already defined.

> > > > A device with an "iommus" property will ignore the "dma-ranges" property
> > > > of the parent node and rely on the IOMMU for translation instead.
> > > 
> > > Do we need to consider the case where an IOMMU listed in iommus isn't
> > > enabled (status = "disabled")? In that case presumably the device would
> > > either not function or may optionally continue to master onto the parent
> > > untranslated.
> > 
> > My reasoning was that the DT should specify whether we use the IOMMU
> > or not. Being able to just switch on or off the IOMMU sounds nice as
> > well, so we could change the text above to do that.
> > 
> > Another option would be to do this in the IOMMU code, basically
> > falling back to the IOMMU parent's dma-ranges property and using
> > linear dma_map_ops when that is disabled.
> 
> Yes, it should be trivial for the IOMMU core code to take care of this
> special case. Still I think it's worth mentioning it in the binding so
> that it's clearly specified.

Agreed.

> > > > Using an "iommus" property in bus device nodes with "dma-ranges"
> > > > specifying how child devices relate to the IOMMU is a possible extension
> > > > but is not recommended until this binding gets extended.
> > > 
> > > Just for my understanding, bus device nodes with iommus and dma-ranges
> > > properties could be equivalently written by explicitly moving the iommus
> > > properties into the child device nodes, right? In which case they should
> > > be the same as the other examples. So that concept is a convenience
> > > notation to reduce duplication, but doesn't fundamentally introduce any
> > > new concept.
> > 
> > The one case  where that doesn't work is PCI, because we don't list the
> > PCI devices in DT normally, and the iommus property would only exist
> > at the PCI host controller node.
> 
> But it could work in classic OpenFirmware where the device tree can be
> populated with the tree of PCI devices enumerated by OF. There are also
> devices that have a fixed configuration and where technically the PCI
> devices can be listed in the device tree. This is somewhat important if
> for example one PCI device is a GPIO controller and needs to be
> referenced by phandle from some other device.

Correct. The flaw of classic Open Firmware here was that it cannot
handle PCIe hotplug though, so we can never rely on the DT to
describe all devices.

	Arnd
