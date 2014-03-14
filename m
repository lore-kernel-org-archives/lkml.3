Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaCNRZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:25:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:63542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbaCNRZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:25:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 4/7] of: configure the platform device dma_mask and dma_pfn_offset
Date: Fri, 14 Mar 2014 18:25:07 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com> <201988591.AhaUZy8EHz@wuerfel> <CAL_JsqKbtAxDBrF3O=C8exke9HVU0_ZC-vWZKiiftR+YMaUwMw@mail.gmail.com>
In-Reply-To: <CAL_JsqKbtAxDBrF3O=C8exke9HVU0_ZC-vWZKiiftR+YMaUwMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403141825.07705.arnd@arndb.de>
X-Provags-ID: V02:K0:kvYtpJU6BgujD+m10KA9CyplOzW7pBdkgVzCkoDlqE2
 6tm9UeN/SxGZwzUhvpum3fwn6ByEhpwXe8ZO0MaZOcc0aCfoZJ
 XzFwBaeje5b0/ekgJ4TsBFTv+qt6Bo0mhf6B5z9Yp0kO5XiDNO
 DBuMFwf/VEa6dBc387Qq8se9w4/d4Gfp9hw62yYNpeB8SMiRvN
 PLj1zt6GISJImbqVrX8iMENBVBvxoYg/rMTe9cOwD+dvCWXAF8
 8Q2YLtv5jT/8yg/sVlYmVYff8SWY1lc2lQtMUwaznlE40Y0978
 DzM7Xl3D1oYOheOGLtRPVNy/Z9/BhO5vGxdZOoB2zeIhXMG1QS
 ICrBZieoqsLSzWX3J5ReKFChmteEN0Nr6vSusWsCX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 March 2014, Rob Herring wrote:
> On Wed, Mar 12, 2014 at 11:58 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 12 March 2014 15:19:48 Grygorii Strashko wrote:
> >> > Isn't the question here how do we handle restrictions added by the
> >> > bus? It seems while this series adds support for handling dma-ranges
> >> > to set the default case, it also needs to handle when the driver sets
> >> > the mask. Is this not simply a matter of having dma_set_mask also
> >> > parse dma-ranges (or reuse a saved bus mask)?
> >
> > With the current proposed implementation, the device also has to set
> > a "dma-ranges" property to get any DMA support, we don't just take
> > the mask of the parent bus. This is important because the translation
> > does not have to be 1:1 but there can be an offset between the device
> > and the parent. I'd prefer to leave this explicit.
> 
> But according to Ben H, dma-ranges is a bridge (i.e. parent) property
> and not a device property[1]. So I don't think the device's mask
> (again, before any bus restrictions) belongs in DT. A given IP block
> is going to have some number of address bits for DMA. How it is hooked
> up into an SOC is a separate issue. The driver should know its mask
> whether it is fixed, discoverable, or tied to the compatible string.
> 
> Santosh's patch only looks for dma-ranges in parent nodes which I
> believe is correct.

Ok, good point.

> >> >> I think this approach is much less useful for platform devices than it is
> >> >> for PCI devices, where we don't explicitly describe the "ranges" for each
> >> >> device. Are you thinking of off-chip or on-chip DMA masters here? If
> >> >> on-chip, I don't think it's likely that we would end up with different
> >> >> versions of the chip that have the same device on there but not the
> >> >> same DMA capabilities.
> >> >
> >> > Sounds like a challenge to h/w designers. :)
> >> >
> >> > I'm mainly thinking about the midway case where all masters are 32-bit
> >> > except AHCI which is 64-bit. The core libahci sets the mask based on
> >> > the capabilities register regardless of PCI or platform bus. Requiring
> >> > this to be setup by the platform or in the DT seems like a step
> >> > backwards. A slightly more complicated case would be something like
> >> > midway, but with RAM starting at say 2GB and DMA masters have the same
> >> > view as the cpu (i.e. no offset). Then the platform does need to set
> >> > the mask to (2^31 -1).
> >
> > So how would you show this in DT? I'd assume that some of the other
> > devices on midway have drivers that may also try to set a 64-bit mask,
> > like EHCI for instance does. Is AHCI the only one that sits on a 64-bit
> > wide bus, like this?
> >
> >         axi {
> >                 #address-cells = <2>;
> >                 #size-cells = <2>;
> >                 dma-ranges = <0 0 0 0 0x100 0>; /* max phys address space */
> >
> >                 ahci {
> >                         dma-ranges = <0 0  0 0  0x100 0>;
> 
> There is no point to this dma-ranges here. Based on the capabilities
> reg, we know that we can do either 32 or 64 bit DMA.

Ok

> In the case of
> 64-bit DMA, the device should try to set its mask to DMA_MASK(64), but
> the parent dma-ranges should restrict that to DMA_MASK(40).

Now I'm confused about what dma_set_mask is actually supposed to do here.
I /think/ it should fail the DMA_MASK(64) call if the bus supports
less than 64 bits as in the above example. However it seems like a
valid shortcut to always succeed here if the effective mask covers
all of the installed RAM.

That would mean that even if we only have a 32-bit bus, but all RAM
resides below 4GB, a call to dma_set_mask using DMA_MASK(64) would
also succeed.

> >                         ...
> >                 };
> >
> >                 ahb {
> >                         #address-cells = <1>;
> >                         #size-cells = <1>;
> 
> This would need to be 2. ePAPR says the size cells size is determined
> by #size-cells in the same node.

Ah, of course.

> >                         dma-ranges = <0 0  0  0x1 0>; /* only 4GB */
> >
> >                         ehci {
> >                                 dma-ranges = <0  0  0xffffffff>;
> 
> Again, I don't think this is needed. Here, regardless of the device's
> capabilities, the bus is restricting the mask to DMA_MASK(32).

Right.

> >                                 /* side-question: is that the right way
> >                                   to describe 4GB length? it seems missing
> >                                   a byte */
> >                         };
> >                 };
> >         };
> >
> > BTW, I hope I understood you right that you wouldn't actually trust the
> > capabilities register by itself but only allow setting the 64-bit mask
> > in the arch code if the DT doesn't have any information about the
> > bus being incapable of doing this, right?
> 
> Ideally no, but it appears we are ATM for midway. We get away with it
> since it is midway/highbank specific driver setup and know there are
> not any restrictions in addressing RAM. I think we have to keep bus
> and device masks separate and the final mask is the AND of them. There
> isn't really a construct to do this currently AFAICT. dma_set_mask
> could be modified to adjust the mask, but that would be a change in
> how dma_set_mask works as it is supposed to fail if the requested mask
> cannot be supported.
> 
> Perhaps using dma_get_required_mask to parse dma-ranges would be
> appropriate here? It doesn't seem widely used though.

Hmm, I've never even heard of that interface.

> >> Compatibility issues:
> >>   - Old DT without DMA properties defined: Drivers may still need to call dma_set_mask(DMA_MASK(64)
> >>   - Old DT without DMA properties defined and DMA range is defined outside of RAM:
> >>   arch or drivers code still has to provide proper address translation routines.
> >
> > 64-bit SOC includes 32-bit CPU with LPAE, right?
> >
> > Would you want to allow dma_set_mask(DMA_MASK(64)) to succeed in the absence
> > of the dma-ranges properties?
> 
> Yes, because the default should be no restrictions are imposed by the
> bus. DT should describe the restrictions or translations. The default
> should be masters have the same view of memory map as the cpu and can
> use all address bits the device has.

Hmm, I was rather thinking we should mirror what we have for the "ranges"
property where an empty property signifies that there are no restrictions
and the parent and child bus have the same view.

In case of "ranges", the absence of the property means that there is
no possible translation, but we can't do that for "dma-ranges" because
that would break every single 32-bit SoC in existence today.

Defining this case to mean "only 32-bit translations are possible" is
a bit hacky but I think it would be a more pragmatic approach.

> >> [3] 64 bit SOC (only 32 bit masters):
> >>
> >> - DMA range is present and It's defined inside RAM (no address translation needed):
> >>   DMA range can be absent - default DMA configuration will be applied.
> >>
> >> - DMA range present and It's defined outside of RAM (address translation needed):
> >>   DMA range has to be present and depending on its size
> >>   dma_mask will be equal or less than DMA_MASK(32); and dma_pfn_offset will be calculated.
> >>
> >> Compatibility issues:
> >>   - Old DT without DMA properties defined and DMA range is defined outside of RAM:
> >>   arch or drivers code has to provide proper address translation routines.
> >>
> >>
> >> [4] 64 bit SOC (32 bit and 64 masters):
> >> - This is combination of above 2,3 cases.
> >>   The current approach will allow to handle it by defining two buses in DT
> >>   "simple-bus32" and "simple-bus64", and each one should have its own DMA properties
> >>   defined in DT.
> >
> > We already try to describe the hierarchy of the buses, and only AXI4 buses can be
> > 64-bit, unlike AHB or other types of AMBA buses AFAIK. We should just call them
> > what they are.
> 
> I don't think we do describe the hierarchy. We are describing the
> slave side which is not necessarily the same as the master side.
> Internal buses are also much more complex than any of the SOCs
> describe in their DT.

I think we try to describe them as good as we can if we have access to
the documentation. I keep hearing people mention the case where the
slave side is different from the master side, but is that actually
a common scenario? If it's as rare as I suspect, we can fake a hierarchy
for the cases we need, but describe most of them correctly.

	Arnd
