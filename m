Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaLZTC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 14:02:27 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61634 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaLZTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 14:02:25 -0500
MIME-Version: 1.0
In-Reply-To: <20141224223434.GA20669@amd>
References: <20141203214641.GA1390@amd> <20141224223434.GA20669@amd>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 26 Dec 2014 13:02:02 -0600
Message-ID: <CAL_JsqJsDqYm-xfEM1CqNzJxfZY6vnYxaBYpT+3t4+gV2F3M1A@mail.gmail.com>
Subject: Re: [PATCHv2] media: i2c/adp1653: devicetree support for adp1653
To: Pavel Machek <pavel@ucw.cz>, Bryan Wu <cooloney@gmail.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>, freemangordon@abv.bg,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>, sakari.ailus@iki.fi,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 4:34 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
> We are moving to device tree support on OMAP3, but that currently
> breaks ADP1653 driver. This adds device tree support, plus required
> documentation.
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> ---
>
> Changed -microsec to -us, as requested by devicetree people.
>
> Fixed checkpatch issues.
>
> diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
> index 2d88816..2c6c7c5 100644
> --- a/Documentation/devicetree/bindings/leds/common.txt
> +++ b/Documentation/devicetree/bindings/leds/common.txt
> @@ -14,6 +14,15 @@ Optional properties for child nodes:
>       "ide-disk" - LED indicates disk activity
>       "timer" - LED flashes at a fixed, configurable rate
>
> +- max-microamp : maximum intensity in microamperes of the LED
> +                (torch LED for flash devices)
> +- flash-max-microamp : maximum intensity in microamperes of the
> +                       flash LED; it is mandatory if the LED should
> +                      support the flash mode
> +- flash-timeout-microsec : timeout in microseconds after which the flash
> +                           LED is turned off

Doesn't all this go in your flash led binding patch?

> +
> +
>  Examples:
>
>  system-status {
> @@ -21,3 +30,10 @@ system-status {
>         linux,default-trigger = "heartbeat";
>         ...
>  };
> +
> +camera-flash {
> +       label = "Flash";
> +       max-microamp = <50000>;
> +       flash-max-microamp = <320000>;
> +       flash-timeout-microsec = <500000>;
> +}
> diff --git a/Documentation/devicetree/bindings/media/i2c/adp1653.txt b/Documentation/devicetree/bindings/media/i2c/adp1653.txt
> new file mode 100644
> index 0000000..3c7065f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/adp1653.txt
> @@ -0,0 +1,38 @@
> +* Analog Devices ADP1653 flash LED driver
> +
> +Required Properties:
> +
> +  - compatible: Must contain one of the following
> +    - "adi,adp1653"
> +
> +  - reg: I2C slave address
> +
> +  - gpios: References to the GPIO that controls the power for the chip.
> +
> +There are two led outputs available - flash and indicator. One led is
> +represented by one child node, nodes need to be named "flash" and "indicator".
> +
> +Required properties of the LED child node:
> +- max-microamp : see Documentation/devicetree/bindings/leds/common.txt
> +
> +Required properties of the flash LED child node:
> +
> +- flash-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
> +- flash-timeout-us : see Documentation/devicetree/bindings/leds/common.txt
> +
> +Example:
> +
> +        adp1653: led-controller@30 {
> +                compatible = "adi,adp1653";
> +               reg = <0x30>;
> +                gpios = <&gpio3 24 GPIO_ACTIVE_HIGH>; /* 88 */
> +
> +               flash {
> +                        flash-timeout-us = <500000>;
> +                        flash-max-microamp = <320000>;
> +                        max-microamp = <50000>;
> +               };
> +                indicator {

These are different LEDs or different modes?

> +                        max-microamp = <17500>;

This is a bit inconsistent. The binding says this is for flash LEDs
torch mode, but I see no reason why it can't be common. Can you update
the binding doc to be clear here.

Also, aren't you missing label properties?

Rob
