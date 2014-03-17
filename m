Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000AbaCQTAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:00:09 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:64352 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaCQTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:00:07 -0400
MIME-Version: 1.0
In-Reply-To: <5326F72E.7010401@monstr.eu>
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
	<CAL_JsqKacetGytGUJir7ky3qOgCy-3ny1pT_Bx4eCYV2wMgcTg@mail.gmail.com>
	<5326F72E.7010401@monstr.eu>
Date: Mon, 17 Mar 2014 14:00:05 -0500
Message-ID: <CAL_JsqL9z_4T+cz425bHHpwx_dXaZjJEHwZKFCOibWYuWM4rkA@mail.gmail.com>
Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
From: Rob Herring <robherring2@gmail.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Harini Katakam <harinik@xilinx.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 8:22 AM, Michal Simek <monstr@monstr.eu> wrote:
> Hi Rob,
>
> On 03/17/2014 01:47 PM, Rob Herring wrote:
>> On Mon, Mar 17, 2014 at 7:05 AM, Harini Katakam <harinik@xilinx.com> wrote:
>>> Add driver for Cadence SPI controller. This is used in Xilinx Zynq.
>>>
>>> Signed-off-by: Harini Katakam <harinik@xilinx.com>
>>> ---
>>>  .../devicetree/bindings/spi/spi-cadence.txt        |   25 +
>>
>> We prefer binding docs in separate patch.
>
> I have heard several times that also for binding review you need driver
> to look if this binding make sense that's why Harini sent this together.
> It means 2 emails instead of one.
> But if you wish to have this in two files no problem to split it
> but then I believe both should be copied to DT mailing list.

Yes, for 2 reasons:
- To prepare for DT bindings to get merged to separate repo if we ever
get there.
- So DT maintainers can review/ack just the bindings.


>>> +- reg                  : Physical base address and size of SPI registers map.
>>> +- interrupts           : Property with a value describing the interrupt
>>> +                         number.
>>> +- interrupt-parent     : Must be core interrupt controller
>>> +- clock-names          : List of input clock names - "ref_clk", "pclk"
>>> +                         (See clock bindings for details).
>>> +- clocks               : Clock phandles (see clock bindings for details).
>>> +- num-chip-select      : Number of chip selects used.
>>
>> See Documentation/devicetree/bindings/spi/spi-bus.txt. Use "num-cs" here.
>>
>>> +
>>> +Example:
>>> +
>>> +       spi@e0007000 {
>>> +               clock-names = "ref_clk", "pclk";
>>> +               clocks = <&clkc 26>, <&clkc 35>;
>>> +               compatible = "cdns,spi-r1p6";
>>
>> Nit. We usually put compatible first in the node.
>
> Our device-tree generator sorts them that's why it is just like this
> but not a problem to fix just in documentation.
>
>
>>> +               interrupt-parent = <&intc>;
>>> +               interrupts = <0 49 4>;
>>> +               num-chip-select = /bits/ 16 <4>;
>
> I was expecting you will comment this a little bit. :-)
> Because all just reading this num-cs as 32bit and then
> assigning this value to master->num_chipselect which is 16bit.

Well, everyone else has that problem then. Obviously it takes a bit
more care than just reading into a u32, but that is a kernel problem
and not a problem of the binding.

>>> +/* Macros for the SPI controller read/write */
>>> +#define cdns_spi_read(addr)    readl_relaxed(addr)
>>> +#define cdns_spi_write(addr, val)      writel_relaxed((val), (addr))
>>
>> Just use readl/writel directly.
>
> There shouldn't be any problem to use these helper macros
> and even I think this is better than using readl/writel directly
> because you are more flexible if you want to change it to different
> IO.

Then when I read the code I have to go lookup what they do while I
know exactly what writel/readl do already. It is really the same
reasons as why the kernel doesn't have register set and clear bits
accessors.


>>> +       irq = platform_get_irq(pdev, 0);
>>> +       if (irq < 0) {
>>
>> I believe this returns NO_IRQ which could be 0.
>>
>> s/</<=/
>
> Are you sure regarding this?
> NO_IRQ on ARM is -1.
> And IRC irq = 0 should be just valid number.
>
> But if you are right then others drivers have to fixed too.

The definition varies by arch being 0 or -1, so drivers need to deal
with both. The preference is 0 is NO_IRQ. It has been decreed by
Linus. ARM is actually pretty close to being able to change NO_IRQ to
0.

Rob
