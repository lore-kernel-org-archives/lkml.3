Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233Ab3GSKsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:48:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54136 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760204Ab3GSKsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:48:51 -0400
Message-ID: <51E9196B.3070900@ti.com>
Date: Fri, 19 Jul 2013 16:18:11 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, <balbi@ti.com>,
        <linux@arm.linux.org.uk>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rnayak@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
References: <1374165830-6367-1-git-send-email-r.sricharan@ti.com> <1374165830-6367-2-git-send-email-r.sricharan@ti.com> <51E83A4F.5080904@ti.com> <51E87C98.5030001@ti.com> <CAGo_u6rO0SjHzXhMBPeSmWykqqpf9phLEPBEaeFtS9bkHoq8qg@mail.gmail.com>
In-Reply-To: <CAGo_u6rO0SjHzXhMBPeSmWykqqpf9phLEPBEaeFtS9bkHoq8qg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 19 July 2013 05:43 AM, Nishanth Menon wrote:
> On Thu, Jul 18, 2013 at 6:39 PM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> On Thursday 18 July 2013 02:56 PM, Nishanth Menon wrote:
>>> On 07/18/2013 11:43 AM, Sricharan R wrote:
>>>> Some socs have a large number of interrupts/dma requests to service
>>>> the needs of its many peripherals and subsystems. All of the
>>>> requests lines from the subsystems are not needed at the same
>>>> time, so they have to be muxed to the controllers appropriately.
>>>> In such places a interrupt/dma controllers are preceded by an
>>>> IRQ/DMA CROSSBAR that provides flexibility in muxing the device
>>>> requests to the controller inputs.
>>>>
>>>> The Peripheral irq/dma requests are connected to one crossbar's input
>>>> and the output of the crossbar is connected to controller's input
>>>> line. On POR, there are some mappings which are done by default.
>>>> Those peripherals which do not have a mapping on POR, should be configured
>>>> to route its requests using the crossbar.
>>>>
>>>> The drivers identifies every controller's crossbar as individual devices.
>>>> The mappings can be specified from the DT crossbar nodes and those gets mapped
>>>> during the crossbar device's probe. The mappings can also be specified by adding
>>>> the crossbar lines to the peripheral device nodes and map it with
>>>> crossbar_map/unmap apis.
>>>>
>>>> Signed-off-by: Sricharan R <r.sricharan@ti.com>
>>>> ---
>>>>   .../devicetree/bindings/arm/omap/crossbar.txt      |   24 ++
>>>>   drivers/misc/Kconfig                               |    8 +
>>>>   drivers/misc/Makefile                              |    1 +
>>>>   drivers/misc/crossbar.c                            |  258 ++++++++++++++++++++
>>>>   include/linux/crossbar.h                           |   71 ++++++
>>>>   5 files changed, 362 insertions(+)
>>>>   create mode 100644 Documentation/devicetree/bindings/arm/omap/crossbar.txt
>>>>   create mode 100644 drivers/misc/crossbar.c
>>>>   create mode 100644 include/linux/crossbar.h
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
>>>> new file mode 100644
>>>> index 0000000..02a8a28
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
>>>> @@ -0,0 +1,24 @@
>>>> +* TI - IRQ/DMA Crossbar
>>>> +
>>>> +This version is an implementation of the Crossbar IRQ/DMA IP
>>>> +
>>>> +Required properties:
>>>> +- compatible : Should be "ti,dra-crossbar"
>>>> +- crossbar-name: Name of the controller to which crossbar output is routed
>>>> +- reg:    Contains crossbar register address range
>>>> +- reg-width: Represents the width of the individual registers
>>>> +- crossbar-lines:  Default mappings.Should contain the crossbar-name
>>>> +           device name, int/dma request number, crossbar number,
>>>> +           register offset in the same order.
>>>> +
>>>> +Examples:
>>>> +        crossbar_mpu: mpuirq@4a002a48 {
>>>> +            compatible = "crossbar";
>>>> +            crossbar-name = "mpu-irq";
>>>> +            reg = <0x4a002a48 0x0130>;
>>>> +            reg-width = <16>;
>>>> +            crossbar-lines = "mpu-irq", "rtc-ss-alarm", <0x9f 0xd9 0x12c>,
>>>> +                     "mpu-irq", "mcasp3-arevt", <0x9e 0x96 0x12a>,
>>>> +                     "mpu-irq", "mcasp3-axevt", <0x9d 0x97 0x128>;
>>>> +        };
>>> I carry forward my TI internal objection to this approach:
>>>
>>> NAK.
>>>
>>> DRA7 uses a cross bar to map a line to GIC interrupt. Flow of interrupt is as follows:
>>> hardware IP block -interrupt line-> IRQ Cross bar -> GIC IRQ line --> MPU IRQ.
>>>
>>>
>>> What we have done today for DRA is to provide IRQ numbers as direct maps from hardware IP block to GIC based on default IRQ cross bar mapping.
>>>
>>> Lets see what happens as a result of this:
>>>
>>> https://patchwork.kernel.org/patch/2825148/ (introducing DTS for DRA7)
>>> uart1 to uart6 is defined. while in fact 10 uarts exist on IP block.
>>> uart1: serial@4806a000 {
>>> <snip>
>>> +            interrupts = <0 72 0x4>;
>>> Assumes that GIC interrupt by default mapping used.
>>>
>>> Now, think of a product that wants to use UART10 instead of UART1, SoC design allows you do that by doing a remapping of GIC interrupt to UART10 - which is awesome.
>>>
>>> Option 1: u-boot/bootloader
>>> mw.l IRQ_CROSSBAR_address with value to map uart10 to GIC IRQ for UART1,
>>>
>>> Option 2: in kernel do a raw_writel version of option 1.
>>> This patch does option 1 in kernel in a "fancy way" - why the heck would I want to do that when u-boot allows me to do the same thing in uEnv.txt
>>>
>>> Option 3: map GIC interrupt to IRQ CROSS bar dynamically.
>>> a) Allows us to define every single IP available on DRA7 SoC.
>>> b) GIC allocation happens dynamically
>>> c) allow products use IPs as needed.
>>>
>>> Sorry, Conceptually option 3 is the right approach in my view.
>>> instead of doing
>>> uart1: serial@4806a000 {
>>> <snip>
>>> +            interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
>>>
>>> we should be able to do the following:
>>> uart1: serial@4806a000 {
>>> <snip>
>>> +            interrupts = <TI_IRQ_CROSSBAR 192 IRQ_TYPE_LEVEL_HIGH>;
>>>
>>> and not worry about the GIC interrupt number used
>>>
>>>
>> Since the cross-bar is not limited t0 IRQ lines and applicable for
>> DMA request lines as well, making it IRQ chip doesn't make sense. Its
>> not typical pin control functionality either but at least that framework
>> is much closer to consider as an option.
> The core concept is that this is a trivial mapping problem and if can
> extrapolate pinctrl to be mapping for SoC internal signals, oh great!
>
> pinctrl solved a problem where we are not absolutely sure how to
> reallocate SoC *external* pins to board interface. pinctrl works in
> more complex world, each SoC pinout has A options, but not all B SoC
> signals can or will routed there - in fact, inside one single SoC
> family, there never was a pattern even as it all depended on how the
> board manufacturer wanted to do it - and yep, it was easy - a signal
> just had limited number of options it could go to review and pinctrl
> options to do that was simple as well!
>
> The problem here IMHO is different. it is a simple X->Y mapping, where
> X > Y, but any of X can be mapped to any of Y - so, now with a static
> map, you need be sure that you do not map double even by mistake - so
> what ever number of GIC mappings need to be evaluated always every
> time we do a static map change to ensure no conflicts w.r.t board
> usage etc. Doable? sure! Right way to solve a simple X->Y mapping
> problem? I personally don't think so.
>
> <rant>
>
> Now, if we want to force every single DRA7 product board designers and
> s/w board support guy to consider how the DRA internal signals are
> mapped using dts - yes, we are proposing to solve the problem of a
> trivial resource allocation problem with a framework meant to handle
> much more complex muxing problem and ensured that all DRA7 product
> guys will wonder "what the heck were these guys thinking"?
>
> </rant>
  The problems to be solved with Dynamic mappings are
  1) How to populate the drivers resources with the dynamically allocated
       data? This also means that all the drivers should
     be adapted to use crossbar before it does a request_irq.

 2) How to get a dynamic line when there is no "free" line.
      That is how to decide runtime which one to replace.
      We can do this in dts because we know what peripheral is not used
      in a board.

Regards,
 Sricharan
