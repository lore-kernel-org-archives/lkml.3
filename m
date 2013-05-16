Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3EPPgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:36:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57792 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3EPPga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:36:30 -0400
Message-ID: <5194FCDD.8080209@ti.com>
Date: Thu, 16 May 2013 10:35:57 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] ARM:dts:omap4-panda: Update the LED support for the
 panda DTS
References: <1368636386-17138-1-git-send-email-dmurphy@ti.com> <20130515170516.GA6135@kahuna>
In-Reply-To: <20130515170516.GA6135@kahuna>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 12:05 PM, Nishanth Menon wrote:
> On 11:46-20130515, Dan Murphy wrote:
>> The GPIO for LED D1 on the omap4-panda a1-a3 rev and the omap4-panda-es
>> are different.
>>
>> A1-A3 = gpio_wk7
>> ES = gpio_110
>>
>> There is no change to LED D2
>>
>> Abstract away the pinmux and the LED definitions for the two boards into
>> the respective DTS files.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
> nit: Giving patch history is a nice practise.
>>  arch/arm/boot/dts/omap4-panda-common.dtsi |   16 +++++++++++-
>>  arch/arm/boot/dts/omap4-panda-es.dts      |   40 +++++++++++++++++++++++++++++
>>  2 files changed, 55 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
>> index 03bd60d..2b516af 100644
>> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
>> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
>> @@ -16,7 +16,7 @@
>>  		reg = <0x80000000 0x40000000>; /* 1 GB */
>>  	};
>>  
>> -	leds {
>> +	leds: leds {
>>  		compatible = "gpio-leds";
>>  		heartbeat {
>>  			label = "pandaboard::status1";
>> @@ -137,6 +137,20 @@
> I missed noticing this previously, Apologies on the same.
> Considering that drivers/leds/leds-gpio.c has ability to handle pinctrl,
> One better option might be to provide pinctrl phandle with leds -
> Couple of reasons why this might be good:
> a) one gets the following warning at boot:
> "leds-gpio leds.8: pins are not configured from the driver"
> b) you donot need to setup the pins by default at boot - it is not
> mandatory for the system functionality, instead we do it *if* the driver
> is enabled.
> Further, optionally, all you'd have to do in panda-es.dts is the following
> &led_wkgpio_pins {
> 		pinctrl-single,pins = <
> 			0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
> 		>;
> }
> Similarly for gpios override for panda-es.
I am not sure you really want to do this.
If I make the pinctrl part of the led structure then the only way the gpio_wk7 on a1-a3 to be configured is when
the CONFIG_LEDS_GPIO flag is set.

Do you really want that dependency?  You did say it was a key fix
At least this way the pins are configured regardless of that flag.
>>  	};
>>  };
>>  
>> +&omap4_pmx_wkup {
>> +	pinctrl-names = "default";
>> +	pinctrl-0 = <
>> +		&led_wkgpio_pins
>> +	>;
>> +
>> +	led_wkgpio_pins: pinmux_leds_wkpins {
>> +		pinctrl-single,pins = <
>> +			0x1a 0x3	/* gpio_wk7 OUTPUT | MODE 3 */
>> +			0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
>> +		>;
>> +	};
>> +};
>> +
>>  &i2c1 {
>>  	pinctrl-names = "default";
>>  	pinctrl-0 = <&i2c1_pins>;
>> diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
>> index f1d8c21..e6f696d 100644
>> --- a/arch/arm/boot/dts/omap4-panda-es.dts
>> +++ b/arch/arm/boot/dts/omap4-panda-es.dts
>> @@ -34,3 +34,43 @@
>>  		0x5e 0x100	/* hdmi_sda.hdmi_sda INPUT | MODE 0 */
>>  		>;
>>  };
>> +
>> +&leds {
>> +	compatible = "gpio-leds";
>> +	heartbeat {
>> +		label = "pandaboard::status1";
>> +		gpios = <&gpio4 14 0>;
>> +		linux,default-trigger = "heartbeat";
>> +	};
>> +	mmc {
>> +		label = "pandaboard::status2";
>> +		gpios = <&gpio1 8 0>;
>> +		linux,default-trigger = "mmc0";
>> +	};
>> +};
>> +
>> +&omap4_pmx_core {
>> +	pinctrl-names = "default";
>> +	pinctrl-0 = <
>> +		&led_gpio_pins
>> +	>;
>> +
>> +	led_gpio_pins: gpio_led_pmx {
>> +		pinctrl-single,pins = <
>> +			0xb6 0x3	/* gpio_110 OUTPUT | MODE 3 */
>> +		>;
>> +	};
>> +};
>> +
>> +&omap4_pmx_wkup {
>> +	pinctrl-names = "default";
>> +	pinctrl-0 = <
>> +		&led_wkgpio_pins
>> +	>;
>> +
>> +	led_wkgpio_pins: pinmux_leds_wkpins {
>> +		pinctrl-single,pins = <
>> +			0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
>> +		>;
>> +	};
>> +};
>> -- 
>> 1.7.5.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
------------------
Dan Murphy

