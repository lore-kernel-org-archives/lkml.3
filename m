Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaJQKXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 06:23:05 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:14475 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaJQKXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 06:23:04 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2014 06:23:03 EDT
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat+gdPpyI0=
X-RZG-CLASS-ID: mo00
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] Documentation: devicetree: Add bindings for Wi2Wi w2sg0004 gps
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20141017093714.GB4202@leverpostej>
Date: Fri, 17 Oct 2014 12:16:42 +0200
Cc: Marek Belisko <marek@goldelico.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D65FF64A-856F-47EC-B3DE-7F2FCE505087@goldelico.com>
References: <1413491183-15018-1-git-send-email-marek@goldelico.com> <1413491183-15018-2-git-send-email-marek@goldelico.com> <20141017093714.GB4202@leverpostej>
To: Mark Rutland <mark.rutland@arm.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 17.10.2014 um 11:37 schrieb Mark Rutland <mark.rutland@arm.com>:

> On Thu, Oct 16, 2014 at 09:26:23PM +0100, Marek Belisko wrote:
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> ---
>> .../devicetree/bindings/misc/wi2wi,w2sg0004.txt    | 44 ++++++++++++++++++++++
>> 1 file changed, 44 insertions(+)
>> create mode 100644 Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
>> 
>> diff --git a/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt b/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
>> new file mode 100644
>> index 0000000..e144441
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
>> @@ -0,0 +1,44 @@
>> +Wi2Wi GPS module connected through UART
>> +
>> +Required properties:
>> +- compatible: wi2wi,w2sg0004 or wi2wi,w2sg0084
>> +- pinctrl: specify two states (default and monitor). One is the default (UART) mode
>> +  and the other is for monitoring the RX line by an interrupt
>> +- on-off-gpio: the GPIO that controls the module's on-off toggle input
>> +
>> +Optional properties:
>> +- lna-suppy: an (optional) LNA regulator that is enabled together with the GPS receiver
>> +
>> +example:
>> +
>> +        gps_receiver: w2sg0004 {
>> +                compatible = "wi2wi,w2sg0004";
> 
> I couldn't spot "wi2wi" in
> Documentation/devicetree/bindings/vendor-prefixes.txt (in mainline).
> 
> Could you please add it?
> 
>> +                gpio-controller;
>> +                #gpio-cells = <2>;
> 
> As far as I can see, these properties aren't necessary. This only
> consumes a GPIO, it doesn't provide any.

Well, it provides one GPIO. Sort of a "virtual“ GPIO. It is needed so that 
it can be wired up to the DTR gpio of the UART driver (unfortunately this
patch was reverted some months ago from mainline and we will reintroduce
it soon).

The reason to solve it that way is that we did not want to have a direct link
between this driver and any serial drivers or other mechanisms how drivers
can detect that their serial port (/dev/tty*) is opened.

It is used to power down the w2sg GPS chip if no user space process is
accessing its serial port (or de-asserts DTR through tcsetattr/ioctl).

> 
>> +
>> +                pinctrl-names = "default", "monitor";
>> +                pinctrl-0 = <&uart2_pins>;
>> +                pinctrl-1 = <&uart2_rx_irq_pins>;
>> +
>> +                interrupt-parent = <&gpio5>;
>> +                interrupts = <19 IRQ_TYPE_EDGE_FALLING>;  /* GPIO_147: RX - trigger on arrival of start bit */
> 
> While interrupts is a standard property, please describe above how many
> you expect and what their logical function is.
> 
> The only part I'm confused about is how the link to the UART is
> described. I assume I'm just ignorant of some existing pattern.

The serial link itself is not described at all because it is assumed to be a „must have“.
The driver only needs to monitor the RX line and needs to switch it between UART and
GPIO/IRQ mode. So this monitoring switch is described (with two different pinctrl states).

We know that it is a little tricky to control this chip correctly - and we think this solution
is the most general (no direct dependency on the serial line, and just to pinmux states
and an interrupt).

> 
> Otherwise this looks ok.
> 
> Thanks,
> Mark.

Thanks as well,
Nikolaus

> 
>> +                lna-supply = <&vsim>;	/* LNA regulator */
>> +                on-off-gpio = <&gpio5 17 0>;	/* GPIO_145: trigger for turning on/off w2sg0004 */
>> +
>> +&pinmux {
>> +
>> +	uart2_pins: pinmux_uart2_pins {
>> +		pinctrl-single,pins = <
>> +			0x14a (PIN_INPUT | MUX_MODE0)		/* uart2_tx.uart2_rx */
>> +			0x148 (PIN_OUTPUT | MUX_MODE0)		/* uart2_tx.uart2_tx */
>> +		>;
>> +	};
>> +
>> +	uart2_rx_irq_pins: pinmux_uart2_rx_irq_pins {
>> +		pinctrl-single,pins = <
>> +			/* switch RX to GPIO so that we can get interrupts by the start bit */
>> +			0x14a (PIN_INPUT | MUX_MODE4)		/* uart2_tx.uart2_rx */
>> +		>;
>> +	};
>> +
>> +}
>> -- 
>> 1.9.1

