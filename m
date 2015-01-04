Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbbADJAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 04:00:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58881 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADJAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 04:00:41 -0500
Date: Sun, 4 Jan 2015 10:00:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, m.chehab@samsung.com,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        j.anaszewski@samsung.com
Subject: Re: [PATCHv2] media: i2c/adp1653: devicetree support for adp1653
Message-ID: <20150104090036.GA30683@amd>
References: <20141203214641.GA1390@amd>
 <20141224223434.GA20669@amd>
 <20141230135701.GN17565@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141230135701.GN17565@valkosipuli.retiisi.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Thanks for the patch! A few comments below.
> 
> On Wed, Dec 24, 2014 at 11:34:34PM +0100, Pavel Machek wrote:
> > 
> > We are moving to device tree support on OMAP3, but that currently
> > breaks ADP1653 driver. This adds device tree support, plus required
> > documentation.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > ---
> > 
> > Changed -microsec to -us, as requested by devicetree people.
> > 
> > Fixed checkpatch issues.
> > 
> > diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
> > index 2d88816..2c6c7c5 100644
> > --- a/Documentation/devicetree/bindings/leds/common.txt
> > +++ b/Documentation/devicetree/bindings/leds/common.txt
> > @@ -14,6 +14,15 @@ Optional properties for child nodes:
> >       "ide-disk" - LED indicates disk activity
> >       "timer" - LED flashes at a fixed, configurable rate
> >  
> > +- max-microamp : maximum intensity in microamperes of the LED
> > +	         (torch LED for flash devices)
> 
> s/torch LED/torch mode/
> 
> > +- flash-max-microamp : maximum intensity in microamperes of the
> > +                       flash LED; it is mandatory if the LED should
> > +		       support the flash mode
> > +- flash-timeout-microsec : timeout in microseconds after which the flash
> > +                           LED is turned off
> 
> These should go to a different patch.

Actually these both should not be in this patch in the first place.

> > +  - reg: I2C slave address
> > +
> > +  - gpios: References to the GPIO that controls the power for the chip.
> > +
> > +There are two led outputs available - flash and indicator. One led is
> > +represented by one child node, nodes need to be named "flash" and "indicator".
> 
> 80 characters per line.

Count them. It is.

> > +
> > +Required properties of the LED child node:
> > +- max-microamp : see Documentation/devicetree/bindings/leds/common.txt
> > +
> > +Required properties of the flash LED child node:
> > +
> > +- flash-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
> > +- flash-timeout-us : see Documentation/devicetree/bindings/leds/common.txt
> > +
> > +Example:
> > +
> > +        adp1653: led-controller@30 {
> > +                compatible = "adi,adp1653";
> > +		reg = <0x30>;
> > +                gpios = <&gpio3 24 GPIO_ACTIVE_HIGH>; /* 88 */
> 
> Please use tabs for indentation above (and below).

Ok.

> > --- a/arch/arm/boot/dts/omap3-n900.dts
> > +++ b/arch/arm/boot/dts/omap3-n900.dts
> > @@ -553,6 +558,22 @@
> >  
> >  		ti,usb-charger-detection = <&isp1704>;
> >  	};
> > +
> > +	adp1653: led-controller@30 {
> > +		compatible = "adi,adp1653";
> > +		reg = <0x30>;
> > +		gpios = <&gpio3 24 GPIO_ACTIVE_HIGH>; /* 88 */
> > +
> > +		flash {
> > +			flash-timeout-us = <500000>;
> > +			flash-max-microamp = <320000>;
> > +			max-microamp = <50000>;
> > +		};
> > +
> > +		indicator {
> > +			max-microamp = <17500>;
> > +		};
> > +	};
> 
> This should go to a separate patch as well.

How many patches do I need to do for one trivial change? :-(.


> > +	if (flash->platform_data->power)
> > +		ret = flash->platform_data->power(&flash->subdev, on);
> 
> if () {
> } else {
> }

Ok.

> > +	else {
> > +		gpio_set_value(flash->platform_data->power_gpio, on);
> 
> Shouldn't you add this to the platform data struct?

I don't see what you mean.

> power_gpio is actually a poor name for this, as is the "power" callback.
> This is really "EN" gpio in the spec, I'd call it perhaps just "gpio", or
> "enable_gpio".

Feel free to clean that that up in followup patch.

> > +		if (on) {
> > +			/* Some delay is apparently required. */
> > +			udelay(20);
> 
> The driver should always handle the delay, platform data or not. This
> reminds me --- is there a need to retain the support for platform data? I
> don't think it's being used anywhere. I'm fine with both keeping and
> removing it.

Lets do that in followup patch, if needed.

> > +	child = of_get_child_by_name(node, "indicator");
> > +	if (!child)
> > +		return -EINVAL;
> 
> Do you require an indicator to be connected? I think it shouldn't be
> mandatory, at least the driver should work without it, even if it
> exposes
> the control (making that conditional would be a subject for another patch,
> but that doesn't need to be done now).

Another patch, if someone needs it, yes.	

> > +	if (of_property_read_u32(child, "max-microamp", &val))
> > +		return -EINVAL;
> > +	pd->max_indicator_intensity = val;
> > +
> > +	if (!of_find_property(node, "gpios", NULL)) {
> > +		dev_err(&client->dev, "No gpio node\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	gpio = of_get_gpio_flags(node, 0, &flags);
> 
> You could assign to pd->... here.

Ok.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
