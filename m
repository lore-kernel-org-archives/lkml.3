Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbbA0LP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:15:26 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43860 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbbA0LPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:15:23 -0500
Date: Tue, 27 Jan 2015 11:14:58 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] HID: i2c-hid: Add support for GPIO interrupts
Message-ID: <20150127111458.GD17721@leverpostej>
References: <20150126143723.GI23313@leverpostej>
 <20150126144729.GG1451@lahna.fi.intel.com>
 <20150126145000.GJ23313@leverpostej>
 <20150126151637.GH1451@lahna.fi.intel.com>
 <20150126160044.GK23313@leverpostej>
 <20150126161356.GJ1451@lahna.fi.intel.com>
 <20150126163929.GL23313@leverpostej>
 <20150127101610.GK1451@lahna.fi.intel.com>
 <20150127103925.GB17721@leverpostej>
 <20150127105931.GN1451@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127105931.GN1451@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 10:59:31AM +0000, Mika Westerberg wrote:
> On Tue, Jan 27, 2015 at 10:39:25AM +0000, Mark Rutland wrote:
> > > If the above is not the right way to use GPIOs as interrupt, can you
> > > please tell me how it is done then?
> > 
> > 
> > So lets say we have a device which generates an interrupt:
> > 
> > 	device@f00 {
> > 		compatible = "some-interrupting-device";
> > 		reg = <0xf00 0x100>;
> > 		interrupts = < ... >;
> > 	};
> > 
> > It's intended that this is connected to an interrupt controller:
> > 
> > 	ic: interrupt-controller@b00 {
> > 		compatible = "some-interrupt-controller";
> > 		reg = <0xb00 0x100>;
> > 		#interrupt-cells = <1>;
> > 	};
> > 
> > 	device@f00 {
> > 		compatible = "some-interrupting-device";
> > 		reg = <0xf00 0x100>;
> > 		interrupt-parent = <&ic>;
> > 		interrupts = <0x3>;
> > 	};
> > 
> > But in some cases, this gets connected to a GPIO controller. In these
> > cases, the device is still logically generating an interrupt, and the
> > fact that the endpoint is an interrupt controller is irrelevant from the
> > PoV of the device. So we acknowledge that the GPIO controller is also
> > capable of acting as an interrupt controller, and mark it as such:
> > 
> > 	gc: gpio-controller@000 {
> > 		compatible = "some-gpio-controller";
> > 		reg = <0x000 0x100>;
> > 		#gpio-cells = <1>;
> > 		#interrupt-cells = <1>;
> > 	};
> > 
> > 	device@f00 {
> > 		compatible = "some-interrupting-device";
> > 		reg = <0xf00 0x100>;
> > 		interrupt-parent = <&gc>;
> > 		interrupts = <0x1>;
> > 	};
> > 
> > Thus the device binding only describes the logical interrupt, and the
> > driver only needs to handle interrupts.
> 
> OK.
> 
> > In cases where the binding/driver actually care about the GPIO being a
> > GPIO (e.g. for card detect in an MMC controller), describing the GPIO as
> > a GPIO makes sense, and we can try gpio_to_irq as an optimisation over
> > polling the state of the GPIO.
> 
> Well, I've seen touch panels where you actually need to switch the GPIO
> to be output and do some magic before you can use the same GPIO as an
> interrupt.

Ok. That's a nasty case, but surely in that case the relevant GPIO
shoiuld be a GpioIO object for output?

> > > BTW, passing NULL to gpiod_get() implies property named "gpios" in DT
> > > (which is why I added it to the documentation).
> > 
> > Sure. My concern is that we should not need to deal with GPIOs in this
> > case were the GPIO is only there to function as an interrupt.
> > 
> > Given that GpioInt seems to describe an interrupt which happens to be
> > backed by a GPIO, I don't understand what it is necessary to translate
> > this as a GPIO rather than an interrupt. If it were going to be used as
> > a GPIO, then it would be a GpioIO object, no?
> 
> OK, so where do you propose we handle the translation if not in the
> driver? Also keep in mind that some of the devices may have multiple
> GpioInt()s.

To me it seems that GpioInt objects should be translated to interrupts
by some core code. How are interrupts described and handed in ACPI? Are
they resource along the lines of GpioInts, or are they a completely
separate class of device property?

Thanks,
Mark
