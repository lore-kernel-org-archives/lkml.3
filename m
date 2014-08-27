Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaH0HNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:13:55 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47329 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaH0HNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:13:53 -0400
Message-ID: <53FD8528.7090504@collabora.co.uk>
Date: Wed, 27 Aug 2014 09:13:44 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Nick Dyer <nick.dyer@itdev.co.uk>,
        Yufeng Shen <miletus@chromium.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v2 1/3] ARM: dts: Add Peach Pit dts entry for Atmel touchpad
References: <1409066937-3574-1-git-send-email-javier.martinez@collabora.co.uk> <1409066937-3574-2-git-send-email-javier.martinez@collabora.co.uk> <53FD1001.30701@suse.de>
In-Reply-To: <53FD1001.30701@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

On 08/27/2014 12:53 AM, Andreas Färber wrote:
>>  
>> +&hsi2c_8 {
>> +	status = "okay";
>> +	clock-frequency = <333000>;
>> +
>> +	trackpad@4b {
>> +		compatible="atmel,maxtouch";
>> +		reg=<0x4b>;
>> +		interrupt-parent=<&gpx1>;
>> +		interrupts=<1 IRQ_TYPE_EDGE_FALLING>;
> 
> Nit: Here's a style break (4x spaces around '=' missing).
>

True, these bits were copied from the downstream Chrome OS verbatim and
the missing space around '=' was there, I missed that when reviewing.

I'll re-spin and fix those style issues.

>> +		wakeup-source;
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&trackpad_irq>;
>> +		linux,gpio-keymap = < KEY_RESERVED
>> +				      KEY_RESERVED
>> +				      0		/* GPIO 0 */
>> +				      0		/* GPIO 1 */
>> +				      0		/* GPIO 2 */
>> +				      BTN_LEFT 	/* GPIO 3 */
>> +				      KEY_RESERVED
>> +				      KEY_RESERVED >;
>> +	};
> 
> Coincidentally, I experimentally came up with a very similar DT node for
> Spring the weekend:
> 
> +	trackpad@4b {
> +		compatible = "atmel,maxtouch";
> +		reg = <0x4b>;
> +		interrupt-parent = <&gpx1>;
> +		interrupts = <2 IRQ_TYPE_NONE>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&trackpad_irq>;
> +		linux,gpio-keymap = <KEY_RESERVED
> +		                     KEY_RESERVED
> +		                     KEY_RESERVED
> +		                     KEY_RESERVED
> +		                     KEY_RESERVED
> +		                     BTN_LEFT>;
> +		wakeup-source;
> +	};
> 
> 0 == KEY_RESERVED, so you can consistently use it for GPIO 0-2, too. :)
> 

I know that the value of KEY_RESERVED is 0 but I didn't use KEY_RESERVED
for the GPIO on purpose.

What I understood is that the SPT_GPIOPWN_T19 object sends messages using
a status byte so you have a maximum of 8 GPIO but not every maXTouch
devices use all of them. So in the particular case of the device in the
Peach Pit, from the 8 possible GPIO only 4 can be used and these are pins
2-5. So in theory you could connect 3 more GPIO in case you had more
buttons (e.g: BTN_RIGHT, BTN_MIDDLE) but only 1 is used since the
Chromebook just have BTN_LEFT.

Nick sent a patch [0] that extend the atmel touchpad DT binding and the
doc says "Use KEY_RESERVED for unused padding values". But is not clear
what value you should use for GPIO that are actually supported by the
device but have no keycode associated.

So by using 0 instead of KEY_RESERVED I wanted to document that pins 2-4
are actually supported and not reserved by the device but there is no
keycode associated with that GPIO.

If there was a BTN_NONE or KEY_UNUSED it would had been better but I think
that making a distinction between these two cases (reserved pin vs GPIO
available but not used) is useful.

> I probably should add the two trailing _RESERVEDs, too?
> 

I see that is used for properties that are arrays, for example
"linux,keymap" in Documentation/devicetree/bindings/input/matrix-keymap.txt.

> With my above snippet I got an awful lot of "Interrupt triggered but
> zero messages" warnings (which I simply commented out as quickfix).
> Is that why you are using _EDGE_FALLING? Or pin-function 0xf?
> (In my case the ChromeOS DT had IRQ_TYPE_NONE and pin-function 0x0.)
>

These are two separate but related things:

a) IRQF_TRIGGER_FALLING:

Yes, the Chrome OS DT for Peach Pit also has IRQ_TYPE_NONE but the DTS is
not correct.

If you look at the Chrome OS atmel driver
(drivers/input/touchscreen/atmel_mxt_ts.c), it passes IRQF_TRIGGER_FALLING
to request_threaded_irq():

/* Default to falling edge if no platform data provided */
irqflags = data->pdata ? data->pdata->irqflags : IRQF_TRIGGER_FALLING;
error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
			     irqflags | IRQF_ONESHOT,
			     client->name, data);

The above code is wrong since is overwriting the edge/level type flags set
by OF when parsing the "interrupts" property so you have to use the
expected IRQ flags in your DTS.

b) pin-function 0xf instead of 0x0:

The pin-function 0x0 is GPIO input while 0xf is GPIO IRQ. Usually on other
SoCs to use a GPIO IRQ you just configure the pad as GPIO input and then
enable the pin as an interrupt but on Exynos SoC these are really two
different functions. So if you configure the pin as GPIO input and this
happens after the pin is configured as GPIO IRQ, interrupts are not triggered.

I faced that issue before [1] and was solved with Tomasz's commit:

f6a8249 pinctrl: exynos: Lock GPIOs as interrupts when used as EINTs

which changes the pinctrl-exynos driver to setup a pin as GPIO IRQ on
.irq_request_resources instead of .irq_set_type. So, with that patch even
when pin-function re-configures the function to GPIO input, is then
configured as GPIO IRQ when request_threaded_irq() is called.

So probably is working for you just because you tested on linux-next that
already has Tomasz's changes but still the correct thing to do is to setup
the pin as 0xf. This change probably is needed on other pins used as GPIO
IRQ that are using 0x0 now.

Sorry, the email became longer than I wanted but I hope is helpful to you.

> Regards,
> Andreas
> 

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/8/15/244
[1]: https://lkml.org/lkml/2014/8/8/621
