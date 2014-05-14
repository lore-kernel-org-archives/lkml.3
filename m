Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbaENPia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:38:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50018 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaENPi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:38:28 -0400
Message-ID: <53738DEF.70108@wwwdotorg.org>
Date: Wed, 14 May 2014 09:38:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>, stefan@agner.ch,
        thierry.reding@gmail.com, Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: tegra: initial add of Colibri T30
References: <cover.1400001937.git.stefan@agner.ch> <d45ec5351ce8ef03256061bdc4b0ba673bd40c66.1400001937.git.stefan@agner.ch> <53727738.4080901@wwwdotorg.org> <537319CE.7020101@ziswiler.com>
In-Reply-To: <537319CE.7020101@ziswiler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 01:22 AM, Marcel Ziswiler wrote:
> On 05/13/2014 09:49 PM, Stephen Warren wrote:
>> On 05/13/2014 11:27 AM, stefan@agner.ch wrote:
>>> This patch adds the device tree to support Toradex Colibri T30, a
>>> computer on module which can be used on different carrier boards.
>>>
>>> The module consists of a Tegra 30 SoC, two PMIC, DDR3L RAM, eMMC,
>>> a LM95245 temperature sensor and an AX88772B USB Ethernet
>>> Controller. Furthermore, there is a STMPE811 and SGTL5000 audio
>>> codec which are not yet supported. Anything that is not self
>>> contained on the module is disabled by default.
>>>
>>> The device tree for the Evaluation Board includes the modules
>>> device tree and enables the supported pheripherials of the carrier
>>> board (the Evaluation Board supports almost all of them).
>>
>>> diff --git a/arch/arm/boot/dts/tegra30-colibri-eval-v3.dts

>>> +    aliases {
>>> +        rtc0 = "/i2c@7000c000/rtc@68";
>>> +        rtc1 = "/i2c@7000d000/tps65911@2d";
>>> +        rtc2 = "/rtc@7000e000";
>>> +    };
>>
>> Wow, no shortage of RTCs!
> 
> Yes (;-p). Please understand however that there are certain limitation
> if it comes to real-time clocks: The first one is the ultra low-power
> RTC available on the carrier board. The second one is PMIC integrated
> usually drawing much more current that the first dedicated one. The
> third one is Tegra SoC internal and won't keep the time across
> power-cycles in our design.

Sure, I understand this is just representing the HW. It was just
surprising to see so many.

>>> +    /* SPI1: Colibri SSP */
>>> +    spi@7000d400 {
>>> +        status = "okay";
>>> +        spi-max-frequency = <25000000>;
>>> +        can0: can@0 {
>>> +            compatible = "microchip,mcp2515";
>>> +            reg = <0>;
>>> +            clocks = <&clk16m>;
>>> +            interrupt-parent = <&gpio>;
>>> +            interrupts = <TEGRA_GPIO(S, 0) GPIO_ACTIVE_LOW>;
>>> +            spi-max-frequency = <10000000>;
>>
>> So this chip doesn't get confused by a faster clock frequency when its
>> chip-select line isn't asserted? I would have expected spi-max-frequency
>> for the bus to be the minimum value that any device on the bus would
>> tolerate.
> 
> No SPI chip should ever get confused like that as long as they are chip
> select gated. At least by the traditional chip select meaning as opposed
> to NVIDIA's designers taking the term chip select a little too personal:
> they indeed only select a chip otherwise all the chip select pins are
> just left floating!

I'm not convinced about this. The clock signal still reaches all the
chips, and hence still reaches some logic inside those chips. If the
setup/hold timings aren't met (for internal parts of the chip's SPI
state machine), then presumably all bets are off re: performance of the
chip, irrespective of whether the CS line happens to gate how much of
the chip actually does anything.

>> The dr_mode property is only for the PHY node.
>>
>>> +    panel: panel {
>>> +        compatible = "edt,et057090dhu", "simple-panel";
>>
>> The panel-simple driver doesn't seem to know about that EDT panel. How
>> will it work out the display timings?
> 
> Good question and me and Stefan actually even talked about that
> yesterday. I am actually using KMS right now as follows:
> 
> video=HDMI-A-1:1280x720-16@60 video=LVDS-1:640x480-16@60'
> 
> So the panel node is purely used to hook up the back light part right now.
> 
> From our point of view for our completely generic module approach where
> each customer potentially hooks up his own display make/model it would
> be desirable to have some way of defining such timings directly through
> the device tree.

Like Thierry, I think the DT needs to represent the actual HW.

If there's no panel on the carrier board itself, then it probably
shouldn't even be in the base DT. If a user adds a panel, then they will
modify their own DT to correctly represent it.

>>     compatible = "toradex,colibri_t30", "nvidia,tegra30";
>>
>>> +    aliases {
>>> +        serial0 = &uarta;
>>> +        serial1 = &uartd;
>>> +        serial2 = &uartb;
>>> +    };
>>
>> tegra20.dtsi already sets the alias names for the serial ports. Previous
>> discussions settled on giving each on-chip UART a static name, rather
>> than renaming them per board.
> 
> Understood, however our Colibri standard defines a completely different
> order of the UARTs which is what we attempted to indicate by this aliases.

I'd prefer that all Tegra boards use serial aliases consistently. If
there's a real issue with this, please talk to Laxman (CC'd) and see if
we can move all the UART alias entries into individual board files, so
that this board isn't the odd one out.
