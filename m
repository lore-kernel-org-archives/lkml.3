Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934835Ab3GRXjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:39:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54939 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933481Ab3GRXji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:39:38 -0400
Message-ID: <51E87C98.5030001@ti.com>
Date: Thu, 18 Jul 2013 19:39:04 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, <balbi@ti.com>
CC: Sricharan R <r.sricharan@ti.com>, <linux@arm.linux.org.uk>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <rnayak@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
References: <1374165830-6367-1-git-send-email-r.sricharan@ti.com> <1374165830-6367-2-git-send-email-r.sricharan@ti.com> <51E83A4F.5080904@ti.com>
In-Reply-To: <51E83A4F.5080904@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 July 2013 02:56 PM, Nishanth Menon wrote:
> On 07/18/2013 11:43 AM, Sricharan R wrote:
>> Some socs have a large number of interrupts/dma requests to service
>> the needs of its many peripherals and subsystems. All of the
>> requests lines from the subsystems are not needed at the same
>> time, so they have to be muxed to the controllers appropriately.
>> In such places a interrupt/dma controllers are preceded by an
>> IRQ/DMA CROSSBAR that provides flexibility in muxing the device
>> requests to the controller inputs.
>>
>> The Peripheral irq/dma requests are connected to one crossbar's input
>> and the output of the crossbar is connected to controller's input
>> line. On POR, there are some mappings which are done by default.
>> Those peripherals which do not have a mapping on POR, should be configured
>> to route its requests using the crossbar.
>>
>> The drivers identifies every controller's crossbar as individual devices.
>> The mappings can be specified from the DT crossbar nodes and those gets mapped
>> during the crossbar device's probe. The mappings can also be specified by adding
>> the crossbar lines to the peripheral device nodes and map it with
>> crossbar_map/unmap apis.
>>
>> Signed-off-by: Sricharan R <r.sricharan@ti.com>
>> ---
>>   .../devicetree/bindings/arm/omap/crossbar.txt      |   24 ++
>>   drivers/misc/Kconfig                               |    8 +
>>   drivers/misc/Makefile                              |    1 +
>>   drivers/misc/crossbar.c                            |  258 ++++++++++++++++++++
>>   include/linux/crossbar.h                           |   71 ++++++
>>   5 files changed, 362 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/arm/omap/crossbar.txt
>>   create mode 100644 drivers/misc/crossbar.c
>>   create mode 100644 include/linux/crossbar.h
>>
>> diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
>> new file mode 100644
>> index 0000000..02a8a28
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
>> @@ -0,0 +1,24 @@
>> +* TI - IRQ/DMA Crossbar
>> +
>> +This version is an implementation of the Crossbar IRQ/DMA IP
>> +
>> +Required properties:
>> +- compatible : Should be "ti,dra-crossbar"
>> +- crossbar-name: Name of the controller to which crossbar output is routed
>> +- reg:    Contains crossbar register address range
>> +- reg-width: Represents the width of the individual registers
>> +- crossbar-lines:  Default mappings.Should contain the crossbar-name
>> +           device name, int/dma request number, crossbar number,
>> +           register offset in the same order.
>> +
>> +Examples:
>> +        crossbar_mpu: mpuirq@4a002a48 {
>> +            compatible = "crossbar";
>> +            crossbar-name = "mpu-irq";
>> +            reg = <0x4a002a48 0x0130>;
>> +            reg-width = <16>;
>> +            crossbar-lines = "mpu-irq", "rtc-ss-alarm", <0x9f 0xd9 0x12c>,
>> +                     "mpu-irq", "mcasp3-arevt", <0x9e 0x96 0x12a>,
>> +                     "mpu-irq", "mcasp3-axevt", <0x9d 0x97 0x128>;
>> +        };
> 
> I carry forward my TI internal objection to this approach:
> 
> NAK.
> 
> DRA7 uses a cross bar to map a line to GIC interrupt. Flow of interrupt is as follows:
> hardware IP block -interrupt line-> IRQ Cross bar -> GIC IRQ line --> MPU IRQ.
> 
> 
> What we have done today for DRA is to provide IRQ numbers as direct maps from hardware IP block to GIC based on default IRQ cross bar mapping.
> 
> Lets see what happens as a result of this:
> 
> https://patchwork.kernel.org/patch/2825148/ (introducing DTS for DRA7)
> uart1 to uart6 is defined. while in fact 10 uarts exist on IP block.
> uart1: serial@4806a000 {
> <snip>
> +            interrupts = <0 72 0x4>;
> Assumes that GIC interrupt by default mapping used.
> 
> Now, think of a product that wants to use UART10 instead of UART1, SoC design allows you do that by doing a remapping of GIC interrupt to UART10 - which is awesome.
> 
> Option 1: u-boot/bootloader
> mw.l IRQ_CROSSBAR_address with value to map uart10 to GIC IRQ for UART1,
> 
> Option 2: in kernel do a raw_writel version of option 1.
> This patch does option 1 in kernel in a "fancy way" - why the heck would I want to do that when u-boot allows me to do the same thing in uEnv.txt
> 
> Option 3: map GIC interrupt to IRQ CROSS bar dynamically.
> a) Allows us to define every single IP available on DRA7 SoC.
> b) GIC allocation happens dynamically
> c) allow products use IPs as needed.
> 
> Sorry, Conceptually option 3 is the right approach in my view.
> instead of doing
> uart1: serial@4806a000 {
> <snip>
> +            interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
> 
> we should be able to do the following:
> uart1: serial@4806a000 {
> <snip>
> +            interrupts = <TI_IRQ_CROSSBAR 192 IRQ_TYPE_LEVEL_HIGH>;
> 
> and not worry about the GIC interrupt number used
> 
> 
Since the cross-bar is not limited t0 IRQ lines and applicable for
DMA request lines as well, making it IRQ chip doesn't make sense. Its
not typical pin control functionality either but at least that framework
is much closer to consider as an option.

Actually its more of setting up the IRQ and DMA pins maps once
at boot for a given SOC based on chosen configuration by the
board. So I am leaning towards pinctrl as well. Just haven't
thought enough about whether thats the best approach.

CC'ing Linus W and Tony L whether we can use pinctrl framework
for such an IP and if yes how ;-).

Regards,
Santosh

