Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaCLM1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:27:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35190 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaCLM1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:27:20 -0400
Message-ID: <53205EF4.3070308@ti.com>
Date: Wed, 12 Mar 2014 15:19:48 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
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
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com>	<201403071702.41716.arnd@arndb.de>	<CAL_JsqLu_16p-8FLjBYt7xQA2eAyiprPML2q5R3fnivZPrvPug@mail.gmail.com>	<201403090739.18351.arnd@arndb.de> <CAL_Jsq+KPpqmF3eU49AeWO2Q0d4uBon_67+zUz6dXKtfsjA3Nw@mail.gmail.com>
In-Reply-To: <CAL_Jsq+KPpqmF3eU49AeWO2Q0d4uBon_67+zUz6dXKtfsjA3Nw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob, Arnd,

On 03/12/2014 02:15 AM, Rob Herring wrote:
> On Sun, Mar 9, 2014 at 12:39 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Saturday 08 March 2014, Rob Herring wrote:
>>> On Fri, Mar 7, 2014 at 10:02 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>>>> a) Follow what we do for PCI devices: assume that we can do DMA_MASK(32)
>>>> on any device, and have drivers call dma_set_mask(DMA_MASK(64)) on devices
>>>> that would like to do more than that, or call e.g. dma_set_mask(DMA_MASK(28))
>>>> for devices that can do less than 32 bit, as given in the argument. This
>>>> approach would be most consistent with the way PCI works, but it doesn't
>>>> really work well for the case where the mask is less than 32-bit and the
>>>> device driver doesn't know that.
>>>>
>>>> b) Never have to call dma_set_mask() for platform devices and assume that the
>>>> platform code sets it up correctly. This would probably be the simpler
>>>> solution, and I can't think of any downsides at the moment.
>>>
>>> I don't think we want this. In the case of setting up 64-bit masters,
>>> it is typically the device that knows if it can do 64-bit DMA either
>>> thru a capabilities register or compatible value. That device specific
>>> knowledge should really stay within the device's driver.
>>
>> So you think we should still set a 64-bit mask in the "ranges" property
>> for devices that can only do 32-bit and let the driver figure it out?
> 
> No, I think option a makes more sense. BTW, don't you mean dma-ranges?
> A device has it's own mask which is typically going to be 32 or
> 64-bit. The core code may not know what the device supports, so the
> device has to set it's own mask. I don't see a way around that. DT is
> not a good option because it is discoverable in some cases.
> 
> Isn't the question here how do we handle restrictions added by the
> bus? It seems while this series adds support for handling dma-ranges
> to set the default case, it also needs to handle when the driver sets
> the mask. Is this not simply a matter of having dma_set_mask also
> parse dma-ranges (or reuse a saved bus mask)?
> 
>> I think this approach is much less useful for platform devices than it is
>> for PCI devices, where we don't explicitly describe the "ranges" for each
>> device. Are you thinking of off-chip or on-chip DMA masters here? If
>> on-chip, I don't think it's likely that we would end up with different
>> versions of the chip that have the same device on there but not the
>> same DMA capabilities.
> 
> Sounds like a challenge to h/w designers. :)
> 
> I'm mainly thinking about the midway case where all masters are 32-bit
> except AHCI which is 64-bit. The core libahci sets the mask based on
> the capabilities register regardless of PCI or platform bus. Requiring
> this to be setup by the platform or in the DT seems like a step
> backwards. A slightly more complicated case would be something like
> midway, but with RAM starting at say 2GB and DMA masters have the same
> view as the cpu (i.e. no offset). Then the platform does need to set
> the mask to (2^31 -1).
> 

mask has to be (2^32 -1).

I'd like to add my 5 cents here :)
First of all this solution is pretended to be generic, so by default it
can't handle all possible cases (corner cases) - only widely used. 
Arch or driver can always fix up it through bus notifier or driver's probe.

Second, it works only for DT-boot case when devices instantiated from DT in generic way.
So, if any bus creates devices in its own way - proper DMA configuration of such
devices will be private problem of this bus.

I've tried to formulate possible use cases which can be and can't be covered
by this approach:
[1] 32 bit SoC:
- no DMA range limitation: DMA range has to be absent or be equal to RAM
  (default DMA configuration will be applied)

- DMA range present and It's defined inside RAM (no address translation needed):
  DMA range can be present and depending on its size
  dma_mask will be equal or less than DMA_MASK(32).
  (default DMA configuration will be applied - if DMA range isn't present)

- DMA range present and It's defined outside of RAM (address translation needed):
  DMA range has to be present and depending on its size
  dma_mask will be equal or less than DMA_MASK(32); and dma_pfn_offset will be calculated.

Compatibility issues:
  - Old DT without DMA properties defined and DMA range is defined outside of RAM:
  arch or drivers code has to provide proper address translation routines.

[2] 64 bit SOC (only 64 bit masters):
- no DMA range limitation: DMA range has to be present and equal to RAM

- DMA range present and It's defined inside RAM (no address translation needed):
  DMA range has to be present and depending on its size
  dma_mask will be equal or less than DMA_MASK(64).

- DMA range present and It's defined outside of RAM (address translation needed):
  DMA range has to be present and depending on its size
  dma_mask will be equal or less than DMA_MASK(64); and dma_pfn_offset will be calculated.

Compatibility issues:
  - Old DT without DMA properties defined: Drivers may still need to call dma_set_mask(DMA_MASK(64)
  - Old DT without DMA properties defined and DMA range is defined outside of RAM:
  arch or drivers code still has to provide proper address translation routines.

[3] 64 bit SOC (only 32 bit masters):

- DMA range is present and It's defined inside RAM (no address translation needed):
  DMA range can be absent - default DMA configuration will be applied.

- DMA range present and It's defined outside of RAM (address translation needed):
  DMA range has to be present and depending on its size
  dma_mask will be equal or less than DMA_MASK(32); and dma_pfn_offset will be calculated.

Compatibility issues:
  - Old DT without DMA properties defined and DMA range is defined outside of RAM:
  arch or drivers code has to provide proper address translation routines.


[4] 64 bit SOC (32 bit and 64 masters):
- This is combination of above 2,3 cases.
  The current approach will allow to handle it by defining two buses in DT
  "simple-bus32" and "simple-bus64", and each one should have its own DMA properties
  defined in DT.

- The worst case will be if some device is able to change its DMA configuration
  dynamically by reading its DMA configuration from HW. The main difficulties will
  be to handle DMA addresses translation properly in this case. But, in my opinion,
  such behavior will be needed in very rare case as DT has to describe specific SoC
  and such device has to belong to only one bus as per SoC specification.

Compatibility issues:
  - Old DT without DMA properties defined and 32 bits DMA range is defined outside of RAM:
  arch or drivers code has to provide proper address translation routines.

As per above, this approach will allow to handle most of cases and configure DMA properly
with one exception - device is able to change its DMA configuration dynamically.

Also, for compatibility reasons, arches and drivers may need to continue maintain their own
DMA addresses translation routines to support the case
"Old DT without DMA properties defined and DMA range is defined outside of RAM".

Regards,
- grygorii

