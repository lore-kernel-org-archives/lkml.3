Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbaCLAPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 20:15:48 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:56552 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbaCLAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 20:15:46 -0400
MIME-Version: 1.0
In-Reply-To: <201403090739.18351.arnd@arndb.de>
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com>
	<201403071702.41716.arnd@arndb.de>
	<CAL_JsqLu_16p-8FLjBYt7xQA2eAyiprPML2q5R3fnivZPrvPug@mail.gmail.com>
	<201403090739.18351.arnd@arndb.de>
Date: Tue, 11 Mar 2014 19:15:45 -0500
Message-ID: <CAL_Jsq+KPpqmF3eU49AeWO2Q0d4uBon_67+zUz6dXKtfsjA3Nw@mail.gmail.com>
Subject: Re: [PATCH 4/7] of: configure the platform device dma_mask and dma_pfn_offset
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2014 at 12:39 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 08 March 2014, Rob Herring wrote:
>> On Fri, Mar 7, 2014 at 10:02 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
>> > a) Follow what we do for PCI devices: assume that we can do DMA_MASK(32)
>> > on any device, and have drivers call dma_set_mask(DMA_MASK(64)) on devices
>> > that would like to do more than that, or call e.g. dma_set_mask(DMA_MASK(28))
>> > for devices that can do less than 32 bit, as given in the argument. This
>> > approach would be most consistent with the way PCI works, but it doesn't
>> > really work well for the case where the mask is less than 32-bit and the
>> > device driver doesn't know that.
>> >
>> > b) Never have to call dma_set_mask() for platform devices and assume that the
>> > platform code sets it up correctly. This would probably be the simpler
>> > solution, and I can't think of any downsides at the moment.
>>
>> I don't think we want this. In the case of setting up 64-bit masters,
>> it is typically the device that knows if it can do 64-bit DMA either
>> thru a capabilities register or compatible value. That device specific
>> knowledge should really stay within the device's driver.
>
> So you think we should still set a 64-bit mask in the "ranges" property
> for devices that can only do 32-bit and let the driver figure it out?

No, I think option a makes more sense. BTW, don't you mean dma-ranges?
A device has it's own mask which is typically going to be 32 or
64-bit. The core code may not know what the device supports, so the
device has to set it's own mask. I don't see a way around that. DT is
not a good option because it is discoverable in some cases.

Isn't the question here how do we handle restrictions added by the
bus? It seems while this series adds support for handling dma-ranges
to set the default case, it also needs to handle when the driver sets
the mask. Is this not simply a matter of having dma_set_mask also
parse dma-ranges (or reuse a saved bus mask)?

> I think this approach is much less useful for platform devices than it is
> for PCI devices, where we don't explicitly describe the "ranges" for each
> device. Are you thinking of off-chip or on-chip DMA masters here? If
> on-chip, I don't think it's likely that we would end up with different
> versions of the chip that have the same device on there but not the
> same DMA capabilities.

Sounds like a challenge to h/w designers. :)

I'm mainly thinking about the midway case where all masters are 32-bit
except AHCI which is 64-bit. The core libahci sets the mask based on
the capabilities register regardless of PCI or platform bus. Requiring
this to be setup by the platform or in the DT seems like a step
backwards. A slightly more complicated case would be something like
midway, but with RAM starting at say 2GB and DMA masters have the same
view as the cpu (i.e. no offset). Then the platform does need to set
the mask to (2^31 -1).

Rob
