Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaIZHlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:41:18 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:42388 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaIZHlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:41:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Sep 2014 09:40:34 +0200
From: Stefan Agner <stefan@agner.ch>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, kernel@pengutronix.de,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bpringlemeir@nbsps.com,
        l.stach@pengutronix.de
Subject: Re: [PATCH v3 4/5] ARM: dts: vf610: use new GPIO support
In-Reply-To: <20140926012126.GC21077@dragon>
References: <cover.1411662961.git.stefan@agner.ch>
 <590a5fbc4f8b552355a93c1002041765352cd1c3.1411662961.git.stefan@agner.ch>
 <20140926012126.GC21077@dragon>
Message-ID: <f3bba83ea15d680c852eb7d6e45de08a@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-26 03:21, schrieb Shawn Guo:
> On Thu, Sep 25, 2014 at 06:37:08PM +0200, Stefan Agner wrote:
>> Use GPIO support by adding SD card detection configuration and
>> GPIO pinmux for Colibri's standard GPIO pins. Attach the GPIO
>> pins to the iomuxc node to get the GPIO pin settings applied.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  arch/arm/boot/dts/vf610-colibri.dtsi | 9 +++++++++
>>  arch/arm/boot/dts/vf610-twr.dts      | 1 +
>>  arch/arm/boot/dts/vf610.dtsi         | 1 +
>>  3 files changed, 11 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
>> index 0cd8343..efd4322 100644
>> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
>> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
>> @@ -31,6 +31,7 @@
>>  	pinctrl-names = "default";
>>  	pinctrl-0 = <&pinctrl_esdhc1>;
>>  	bus-width = <4>;
>> +	cd-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
>>  };
>>
>>  &fec1 {
>> @@ -71,6 +72,14 @@
>>
>>  &iomuxc {
>>  	vf610-colibri {
>> +		pinctrl_gpio_ext: gpio_ext {
>> +			fsl,pins = <
>> +				VF610_PAD_PTD10__GPIO_89	0x22ed /* EXT_IO_0 */
>> +				VF610_PAD_PTD9__GPIO_88		0x22ed /* EXT_IO_1 */
>> +				VF610_PAD_PTD26__GPIO_68	0x22ed /* EXT_IO_2 */
>> +			>;
>> +		};
>> +
> 
> I'm not sure these GPIOs will be set up at anywhere.  To set them up,
> you need to either have pinctrl_gpio_ext referenced by some client
> device in its pinctrl-* property or put these pins into hog group (see
> example in arch/arm/boot/dts/vf610-twr.dts).
> 
> Shawn
> 

This GPIO's are meant to be used from user space by default. The latest
implementation of imx_pmx_gpio_request_enable not only takes care of the
muxing, but also applies the whole pad settings. Hence we do not need
the pinctrl subsystem to apply it (through pinctrl-* dt properties).

I changed this now in v3, in v2 I had still to use the pinctrl-*
properties. I like that 3rd version much more, this way the pin only
really gets muxed when the user uses it (e.g. we save power because the
pad is disabled when the GPIO is not in use). If the pin needs to be in
a defined state, then we would have to explicitly configure/enable it
through a pinctrl-* properties, but this is not the case for these
external GPIO's.

--
Stefan

>>  		pinctrl_esdhc1: esdhc1grp {
>>  			fsl,pins = <
>>  				VF610_PAD_PTA24__ESDHC1_CLK	0x31ef
>> diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
>> index 189b697..3fe8a8f 100644
>> --- a/arch/arm/boot/dts/vf610-twr.dts
>> +++ b/arch/arm/boot/dts/vf610-twr.dts
>> @@ -116,6 +116,7 @@
>>  	pinctrl-names = "default";
>>  	pinctrl-0 = <&pinctrl_esdhc1>;
>>  	bus-width = <4>;
>> +	cd-gpios = <&gpio5 6 GPIO_ACTIVE_LOW>;
>>  	status = "okay";
>>  };
>>
>> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
>> index 4d2ec32..467c97e 100644
>> --- a/arch/arm/boot/dts/vf610.dtsi
>> +++ b/arch/arm/boot/dts/vf610.dtsi
>> @@ -11,6 +11,7 @@
>>  #include "vf610-pinfunc.h"
>>  #include <dt-bindings/clock/vf610-clock.h>
>>  #include <dt-bindings/interrupt-controller/irq.h>
>> +#include <dt-bindings/gpio/gpio.h>
>>
>>  / {
>>  	aliases {
>> --
>> 2.1.0
>>
