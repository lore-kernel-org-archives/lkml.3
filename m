Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaENHXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:23:54 -0400
Received: from mout.perfora.net ([74.208.4.194]:52845 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbaENHXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:23:52 -0400
Message-ID: <537319CE.7020101@ziswiler.com>
Date: Wed, 14 May 2014 09:22:54 +0200
From: Marcel Ziswiler <marcel@ziswiler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, stefan@agner.ch,
        thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: tegra: initial add of Colibri T30
References: <cover.1400001937.git.stefan@agner.ch> <d45ec5351ce8ef03256061bdc4b0ba673bd40c66.1400001937.git.stefan@agner.ch> <53727738.4080901@wwwdotorg.org>
In-Reply-To: <53727738.4080901@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:c+2Qt1bsG82b8YoSZMj5Iwad0FhDuGmUJ99ggV9lZhK
 eTHF1KGmDW/F2X7iPr43VYIg/4X34V8boXgdzEXtJYFVSEOxdu
 HG3hVcK727Et7ezruGc1TFHym1w7BTeLg4APgVsst8jz4rmLYe
 8RS1HvEmovTzGzqo1+n35Aj9cCDdRJkLKJb9+NwDp6tLLWrslC
 CGhabkaRb9Zc++hzOAjSRbnpE6oam5Jg+eIhome5Fhib8lsw0t
 0ct5Qk+G20RWWjgpCMHlYN11Pm863gAP8ox19GRLq8NVatFKEt
 28zgJ1Im9OHkEyOWDsqL2f2J54gnViR60I0whijNd5ITlOrgYK
 wXd4JK1RGFv5FJ/uAooE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 09:49 PM, Stephen Warren wrote:
> On 05/13/2014 11:27 AM, stefan@agner.ch wrote:
>> This patch adds the device tree to support Toradex Colibri T30, a
>> computer on module which can be used on different carrier boards.
>>
>> The module consists of a Tegra 30 SoC, two PMIC, DDR3L RAM, eMMC,
>> a LM95245 temperature sensor and an AX88772B USB Ethernet
>> Controller. Furthermore, there is a STMPE811 and SGTL5000 audio
>> codec which are not yet supported. Anything that is not self
>> contained on the module is disabled by default.
>>
>> The device tree for the Evaluation Board includes the modules
>> device tree and enables the supported pheripherials of the carrier
>> board (the Evaluation Board supports almost all of them).
>
>> diff --git a/arch/arm/boot/dts/tegra30-colibri-eval-v3.dts b/arch/arm/boot/dts/tegra30-colibri-eval-v3.dts
>
>> +#include "tegra30-colibri.dtsi"
>> +
>> +/ {
>> +	model = "Toradex Colibri T30 on Colibri Evaluation Board";
>> +	compatible = "toradex,colibri_t30-eval-v3", "nvidia,tegra30";
>
> That should include all the compatible values "inherited" from the
> Colibri T30 module .dtsi file too.
>
>> +	aliases {
>> +		rtc0 = "/i2c@7000c000/rtc@68";
>> +		rtc1 = "/i2c@7000d000/tps65911@2d";
>> +		rtc2 = "/rtc@7000e000";
>> +	};
>
> Wow, no shortage of RTCs!

Yes (;-p). Please understand however that there are certain limitation 
if it comes to real-time clocks: The first one is the ultra low-power 
RTC available on the carrier board. The second one is PMIC integrated 
usually drawing much more current that the first dedicated one. The 
third one is Tegra SoC internal and won't keep the time across 
power-cycles in our design.

>> +	/* SPI1: Colibri SSP */
>> +	spi@7000d400 {
>> +		status = "okay";
>> +		spi-max-frequency = <25000000>;
>> +		can0: can@0 {
>> +			compatible = "microchip,mcp2515";
>> +			reg = <0>;
>> +			clocks = <&clk16m>;
>> +			interrupt-parent = <&gpio>;
>> +			interrupts = <TEGRA_GPIO(S, 0) GPIO_ACTIVE_LOW>;
>> +			spi-max-frequency = <10000000>;
>
> So this chip doesn't get confused by a faster clock frequency when its
> chip-select line isn't asserted? I would have expected spi-max-frequency
> for the bus to be the minimum value that any device on the bus would
> tolerate.

No SPI chip should ever get confused like that as long as they are chip 
select gated. At least by the traditional chip select meaning as opposed 
to NVIDIA's designers taking the term chip select a little too personal: 
they indeed only select a chip otherwise all the chip select pins are 
just left floating!

>> +	/* EHCI instance 0: USB1_DP/N -> USBC_P/N */
>> +	usb@7d000000 {
>> +		status = "okay";
>> +		dr_mode = "otg";
>
> The dr_mode property is only for the PHY node.
>
>> +	panel: panel {
>> +		compatible = "edt,et057090dhu", "simple-panel";
>
> The panel-simple driver doesn't seem to know about that EDT panel. How
> will it work out the display timings?

Good question and me and Stefan actually even talked about that 
yesterday. I am actually using KMS right now as follows:

video=HDMI-A-1:1280x720-16@60 video=LVDS-1:640x480-16@60'

So the panel node is purely used to hook up the back light part right now.

 From our point of view for our completely generic module approach where 
each customer potentially hooks up his own display make/model it would 
be desirable to have some way of defining such timings directly through 
the device tree.

>> diff --git a/arch/arm/boot/dts/tegra30-colibri.dtsi b/arch/arm/boot/dts/tegra30-colibri.dtsi
>
>> +/ {
>> +	model = "Toradex Colibri T30";
>> +	compatible = "toradex,colibri_t30-v11b",
>> +		     "toradex,colibri_t30-v11c",
>> +		     "toradex,colibri_t30-v11d",
>> +		     "toradex,colibri_t30", "nvidia,tegra30";
>
> Do we really need all those compatible values? If those board revisions
> are all SW-compatible, then you may as well write just:

You are right. It indeed does not make much sense as only V1.0a which 
never actually went on sale would be software incompatible.

> 	compatible = "toradex,colibri_t30", "nvidia,tegra30";
>
>> +	aliases {
>> +		serial0 = &uarta;
>> +		serial1 = &uartd;
>> +		serial2 = &uartb;
>> +	};
>
> tegra20.dtsi already sets the alias names for the serial ports. Previous
> discussions settled on giving each on-chip UART a static name, rather
> than renaming them per board.

Understood, however our Colibri standard defines a completely different 
order of the UARTs which is what we attempted to indicate by this aliases.

>> +	pmc@7000e400 {
>> +		status = "okay";
>
> The PMC node isn't disabled in tegra20.dtsi, so you don't need the
> status property here.
