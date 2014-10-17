Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaJQLGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 07:06:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45087 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbaJQLGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 07:06:01 -0400
Date: Fri, 17 Oct 2014 12:00:44 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Marek Belisko <marek@goldelico.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Documentation: devicetree: Add bindings for Wi2Wi
 w2sg0004 gps
Message-ID: <20141017110043.GA5335@leverpostej>
References: <1413491183-15018-1-git-send-email-marek@goldelico.com>
 <1413491183-15018-2-git-send-email-marek@goldelico.com>
 <20141017093714.GB4202@leverpostej>
 <D65FF64A-856F-47EC-B3DE-7F2FCE505087@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D65FF64A-856F-47EC-B3DE-7F2FCE505087@goldelico.com>
Thread-Topic: [PATCH 2/2] Documentation: devicetree: Add bindings for Wi2Wi
 w2sg0004 gps
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 11:16:42AM +0100, Dr. H. Nikolaus Schaller wrote:
> 
> Am 17.10.2014 um 11:37 schrieb Mark Rutland <mark.rutland@arm.com>:
> 
> > On Thu, Oct 16, 2014 at 09:26:23PM +0100, Marek Belisko wrote:
> >> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> >> Signed-off-by: Marek Belisko <marek@goldelico.com>
> >> ---
> >> .../devicetree/bindings/misc/wi2wi,w2sg0004.txt    | 44 ++++++++++++++++++++++
> >> 1 file changed, 44 insertions(+)
> >> create mode 100644 Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt b/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
> >> new file mode 100644
> >> index 0000000..e144441
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
> >> @@ -0,0 +1,44 @@
> >> +Wi2Wi GPS module connected through UART
> >> +
> >> +Required properties:
> >> +- compatible: wi2wi,w2sg0004 or wi2wi,w2sg0084
> >> +- pinctrl: specify two states (default and monitor). One is the default (UART) mode
> >> +  and the other is for monitoring the RX line by an interrupt
> >> +- on-off-gpio: the GPIO that controls the module's on-off toggle input
> >> +
> >> +Optional properties:
> >> +- lna-suppy: an (optional) LNA regulator that is enabled together with the GPS receiver
> >> +
> >> +example:
> >> +
> >> +        gps_receiver: w2sg0004 {
> >> +                compatible = "wi2wi,w2sg0004";
> > 
> > I couldn't spot "wi2wi" in
> > Documentation/devicetree/bindings/vendor-prefixes.txt (in mainline).
> > 
> > Could you please add it?
> > 
> >> +                gpio-controller;
> >> +                #gpio-cells = <2>;
> > 
> > As far as I can see, these properties aren't necessary. This only
> > consumes a GPIO, it doesn't provide any.
> 
> Well, it provides one GPIO. Sort of a "virtual“ GPIO. It is needed so that 
> it can be wired up to the DTR gpio of the UART driver (unfortunately this
> patch was reverted some months ago from mainline and we will reintroduce
> it soon).

If this GPIO doesn't really exist, then it's a Linux internal
implementation detail rather than a description of the hardware, and
doesn't really belong in the DT.

It sounds like what we actually need is the ability to describe devices
attached to UARTs. Then you could have a mechanism whereby the UART
driver can notify the other device driver regarding events (e.g. the
UART being opened for access), or the other driver could claim ownership
of the UART and expose its own interface to userspace.

That would be independent of the particular UART or other device, and
the only description necessary in the DT would be an accurate
representation of the way the hardware is wired.

There are a few ways that could be done, but I suspect the simplest is
to just have the device as a sub-node of the UART, like we do for SPI or
I2C buses:

	serial@f00 {
		compatible = "vendor,uart";
		reg = <0xf00 0x100>;
		...

		gps {
			compatible = "wi2wi,w2sg0004";
			...
		};
	};

That wouldn't work for devices with multiple UART connections. Do those
exist, and are they common in configurations where out-of-band
management is necessary (e.g. regulators, clocks)?

> The reason to solve it that way is that we did not want to have a direct link
> between this driver and any serial drivers or other mechanisms how drivers
> can detect that their serial port (/dev/tty*) is opened.
>
> It is used to power down the w2sg GPS chip if no user space process is
> accessing its serial port (or de-asserts DTR through tcsetattr/ioctl).
> 
> > 
> >> +
> >> +                pinctrl-names = "default", "monitor";
> >> +                pinctrl-0 = <&uart2_pins>;
> >> +                pinctrl-1 = <&uart2_rx_irq_pins>;
> >> +
> >> +                interrupt-parent = <&gpio5>;
> >> +                interrupts = <19 IRQ_TYPE_EDGE_FALLING>;  /* GPIO_147: RX - trigger on arrival of start bit */
> > 
> > While interrupts is a standard property, please describe above how many
> > you expect and what their logical function is.
> > 
> > The only part I'm confused about is how the link to the UART is
> > described. I assume I'm just ignorant of some existing pattern.
> 
> The serial link itself is not described at all because it is assumed to be a „must have“.

Huh? So it's a "must have" that you "don't have" in the DT?

I think that the relationship is being described incorrectly in the DT,
and I think that there is a more general problem that needs to be
addressed in order to make this case work.

> The driver only needs to monitor the RX line and needs to switch it between UART and
> GPIO/IRQ mode. So this monitoring switch is described (with two different pinctrl states).

While this particular driver only needs that at this point in time,
that's not necessarily true of drivers for similar devices, nor is it
necessarily true if we need to add additional features to this driver.

Describing the relationship leaves a lot more freedom to improve things
without having to update every DTB.
 
> We know that it is a little tricky to control this chip correctly - and we think this solution
> is the most general (no direct dependency on the serial line, and just to pinmux states
> and an interrupt).

I think that the rough approach I sketched out above is more general,
and I think that you must describe the relationship with the serial
line.

It's not clear to me whether the interrupt you describe is attached to
the GPS, or if this is logically part of the UART.

Thanks,
Mark.
