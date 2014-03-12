Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaCLQ7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:59:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:53992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaCLQ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:59:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/7] of: configure the platform device dma_mask and dma_pfn_offset
Date: Wed, 12 Mar 2014 17:58:41 +0100
Message-ID: <201988591.AhaUZy8EHz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53205EF4.3070308@ti.com>
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com> <CAL_Jsq+KPpqmF3eU49AeWO2Q0d4uBon_67+zUz6dXKtfsjA3Nw@mail.gmail.com> <53205EF4.3070308@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iXMy3IhiHMAS9iwPf5bgbhNO0YVJz9LLjQeIEAJxdhx
 67TezENSMGIRt+kP9v4X/sxtel3DYs7IN/L+lXGDd77JmH+QKQ
 L6cdjIDOZrOHjZjSfbz/mqqtSJ+aTlyf/tSQzOQFUm7OHNR/Eg
 cBgO8At3zKeLjfcWcQ2j2ZwT1E/y3481sjtAbQAfSMrqjuEGTi
 yVlu8aL5xKP7AFRzUsyy0aIs9+WcznxPwTUq7VbM5JBUgQVexY
 BRuDAK/q63HGaipRC9nqcoi3SHWc7uMt/3RkQoduZJC4SUu7HG
 cLXolMah13FsXBrnH5oDdaQwcA1x8Rl0Pl/UlP8MUHqZWHz0zj
 5p99MUnl9NQWNyttF57Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2014 15:19:48 Grygorii Strashko wrote:
> On 03/12/2014 02:15 AM, Rob Herring wrote:
> > On Sun, Mar 9, 2014 at 12:39 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> On Saturday 08 March 2014, Rob Herring wrote:
> >>> On Fri, Mar 7, 2014 at 10:02 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >>
> >>>> a) Follow what we do for PCI devices: assume that we can do DMA_MASK(32)
> >>>> on any device, and have drivers call dma_set_mask(DMA_MASK(64)) on devices
> >>>> that would like to do more than that, or call e.g. dma_set_mask(DMA_MASK(28))
> >>>> for devices that can do less than 32 bit, as given in the argument. This
> >>>> approach would be most consistent with the way PCI works, but it doesn't
> >>>> really work well for the case where the mask is less than 32-bit and the
> >>>> device driver doesn't know that.
> >>>>
> >>>> b) Never have to call dma_set_mask() for platform devices and assume that the
> >>>> platform code sets it up correctly. This would probably be the simpler
> >>>> solution, and I can't think of any downsides at the moment.
> >>>
> >>> I don't think we want this. In the case of setting up 64-bit masters,
> >>> it is typically the device that knows if it can do 64-bit DMA either
> >>> thru a capabilities register or compatible value. That device specific
> >>> knowledge should really stay within the device's driver.
> >>
> >> So you think we should still set a 64-bit mask in the "ranges" property
> >> for devices that can only do 32-bit and let the driver figure it out?
> > 
> > No, I think option a makes more sense. 

Ok.

> > BTW, don't you mean dma-ranges?

Yes, sorry about the confusion.

> > A device has it's own mask which is typically going to be 32 or
> > 64-bit. The core code may not know what the device supports, so the
> > device has to set it's own mask. I don't see a way around that. DT is
> > not a good option because it is discoverable in some cases.

What is "it"? Do you mean the mask of the device is discoverable,
or something else?

> > Isn't the question here how do we handle restrictions added by the
> > bus? It seems while this series adds support for handling dma-ranges
> > to set the default case, it also needs to handle when the driver sets
> > the mask. Is this not simply a matter of having dma_set_mask also
> > parse dma-ranges (or reuse a saved bus mask)?

With the current proposed implementation, the device also has to set
a "dma-ranges" property to get any DMA support, we don't just take
the mask of the parent bus. This is important because the translation
does not have to be 1:1 but there can be an offset between the device
and the parent. I'd prefer to leave this explicit.

> >> I think this approach is much less useful for platform devices than it is
> >> for PCI devices, where we don't explicitly describe the "ranges" for each
> >> device. Are you thinking of off-chip or on-chip DMA masters here? If
> >> on-chip, I don't think it's likely that we would end up with different
> >> versions of the chip that have the same device on there but not the
> >> same DMA capabilities.
> > 
> > Sounds like a challenge to h/w designers. :)
> > 
> > I'm mainly thinking about the midway case where all masters are 32-bit
> > except AHCI which is 64-bit. The core libahci sets the mask based on
> > the capabilities register regardless of PCI or platform bus. Requiring
> > this to be setup by the platform or in the DT seems like a step
> > backwards. A slightly more complicated case would be something like
> > midway, but with RAM starting at say 2GB and DMA masters have the same
> > view as the cpu (i.e. no offset). Then the platform does need to set
> > the mask to (2^31 -1).

So how would you show this in DT? I'd assume that some of the other
devices on midway have drivers that may also try to set a 64-bit mask,
like EHCI for instance does. Is AHCI the only one that sits on a 64-bit
wide bus, like this?

	axi {
		#address-cells = <2>;
		#size-cells = <2>;
		dma-ranges = <0 0 0 0 0x100 0>; /* max phys address space */

		ahci {
			dma-ranges = <0 0  0 0  0x100 0>;
			...
		};

		ahb {
			#address-cells = <1>;
			#size-cells = <1>;
			dma-ranges = <0 0  0  0x1 0>; /* only 4GB */

			ehci {
				dma-ranges = <0  0  0xffffffff>;
				/* side-question: is that the right way
				  to describe 4GB length? it seems missing
				  a byte */
			};
		};
	};

BTW, I hope I understood you right that you wouldn't actually trust the
capabilities register by itself but only allow setting the 64-bit mask
in the arch code if the DT doesn't have any information about the
bus being incapable of doing this, right?

> mask has to be (2^32 -1).

Right.
 
> I'd like to add my 5 cents here :)
> First of all this solution is pretended to be generic, so by default it
> can't handle all possible cases (corner cases) - only widely used. 
> Arch or driver can always fix up it through bus notifier or driver's probe.

Right, but we should strive to avoid that.

> Second, it works only for DT-boot case when devices instantiated from DT in generic way.
> So, if any bus creates devices in its own way - proper DMA configuration of such
> devices will be private problem of this bus.

True as well. Do you see any buses besides platform, amba and PCI that need
to describe bus masters?

> I've tried to formulate possible use cases which can be and can't be covered
> by this approach:
> [1] 32 bit SoC:
> - no DMA range limitation: DMA range has to be absent or be equal to RAM
>   (default DMA configuration will be applied)
> 
> - DMA range present and It's defined inside RAM (no address translation needed):
>   DMA range can be present and depending on its size
>   dma_mask will be equal or less than DMA_MASK(32).
>   (default DMA configuration will be applied - if DMA range isn't present)
> 
> - DMA range present and It's defined outside of RAM (address translation needed):
>   DMA range has to be present and depending on its size
>   dma_mask will be equal or less than DMA_MASK(32); and dma_pfn_offset will be calculated.
> 
> Compatibility issues:
>   - Old DT without DMA properties defined and DMA range is defined outside of RAM:
>   arch or drivers code has to provide proper address translation routines.

Can you clarify what you mean by "outside of RAM"? Is this the IOMMU case, no-IOMMU
but offset, or both?

> [2] 64 bit SOC (only 64 bit masters):
> - no DMA range limitation: DMA range has to be present and equal to RAM
> 
> - DMA range present and It's defined inside RAM (no address translation needed):
>   DMA range has to be present and depending on its size
>   dma_mask will be equal or less than DMA_MASK(64).
> 
> - DMA range present and It's defined outside of RAM (address translation needed):
>   DMA range has to be present and depending on its size
>   dma_mask will be equal or less than DMA_MASK(64); and dma_pfn_offset will be calculated.
> 
> Compatibility issues:
>   - Old DT without DMA properties defined: Drivers may still need to call dma_set_mask(DMA_MASK(64)
>   - Old DT without DMA properties defined and DMA range is defined outside of RAM:
>   arch or drivers code still has to provide proper address translation routines.

64-bit SOC includes 32-bit CPU with LPAE, right?

Would you want to allow dma_set_mask(DMA_MASK(64)) to succeed in the absence
of the dma-ranges properties?

> [3] 64 bit SOC (only 32 bit masters):
> 
> - DMA range is present and It's defined inside RAM (no address translation needed):
>   DMA range can be absent - default DMA configuration will be applied.
> 
> - DMA range present and It's defined outside of RAM (address translation needed):
>   DMA range has to be present and depending on its size
>   dma_mask will be equal or less than DMA_MASK(32); and dma_pfn_offset will be calculated.
> 
> Compatibility issues:
>   - Old DT without DMA properties defined and DMA range is defined outside of RAM:
>   arch or drivers code has to provide proper address translation routines.
> 
> 
> [4] 64 bit SOC (32 bit and 64 masters):
> - This is combination of above 2,3 cases.
>   The current approach will allow to handle it by defining two buses in DT
>   "simple-bus32" and "simple-bus64", and each one should have its own DMA properties
>   defined in DT.

We already try to describe the hierarchy of the buses, and only AXI4 buses can be
64-bit, unlike AHB or other types of AMBA buses AFAIK. We should just call them
what they are.

> - The worst case will be if some device is able to change its DMA configuration
>   dynamically by reading its DMA configuration from HW. The main difficulties will
>   be to handle DMA addresses translation properly in this case. But, in my opinion,
>   such behavior will be needed in very rare case as DT has to describe specific SoC
>   and such device has to belong to only one bus as per SoC specification.
> 
> Compatibility issues:
>   - Old DT without DMA properties defined and 32 bits DMA range is defined outside of RAM:
>   arch or drivers code has to provide proper address translation routines.
> 
> As per above, this approach will allow to handle most of cases and configure DMA properly
> with one exception - device is able to change its DMA configuration dynamically.
> 
> Also, for compatibility reasons, arches and drivers may need to continue maintain their own
> DMA addresses translation routines to support the case
> "Old DT without DMA properties defined and DMA range is defined outside of RAM".

Can we try to list all the platforms we already support in Linux? There should not be
a lot of examples of 64-bit SoCs, as we don't really support any /hardware/ in arm64
properly (apm xgene is incomplete enough that we don't have to worry about breaking it).

The ones I see are

midway
armada xp
keystone 2
r-car

It may be easier to see what their individual requirements are for backwards
compatibility. Some might never have shipped with more than 4GB, and in that
case we don't care at all. I believe exynos5 and tc2 are in that category,
so I didn't even list them.

	Arnd
