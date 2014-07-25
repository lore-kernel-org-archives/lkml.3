Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbaGYHxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:53:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53513 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757022AbaGYHxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:53:23 -0400
Date: Fri, 25 Jul 2014 09:53:19 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: jiri.prchal@aksignal.cz
Cc: Bo Shen <voice.shen@atmel.com>, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: sets NPCS0 (PA14) back to GPIO
Message-ID: <20140725095319.16a8465c@bbrezillon>
In-Reply-To: <53D1F5D0.1080006@aksignal.cz>
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>
	<53D10C50.50305@aksignal.cz>
	<20140724162645.4e19c26c@bbrezillon>
	<53D12103.3020103@aksignal.cz>
	<20140724175848.44f5da10@bbrezillon>
	<53D1F5D0.1080006@aksignal.cz>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014 08:14:40 +0200
Jiří Prchal <jiri.prchal@aksignal.cz> wrote:

> 
> 
> Dne 24.7.2014 v 17:58 Boris BREZILLON napsal(a):
> > On Thu, 24 Jul 2014 17:06:43 +0200
> > Jiří Prchal <jiri.prchal@aksignal.cz> wrote:
> >
> >> Hi,
> >>
> >> Dne 24.7.2014 v 16:26 Boris BREZILLON napsal(a):
> >>> Hello Jiří,
> >>>
> >>> First of all, please try to use git format-patch when submitting a
> >>> patch to any kernel mailing list.
> >> Sorry for that.
> >>>
> >>> On Thu, 24 Jul 2014 15:38:24 +0200
> >>> Jiří Prchal <jiri.prchal@aksignal.cz> wrote:
> >>>
> >>>> After ROMBOOT tries boot from flash on SPI0 NPCS0, this NPCS0 (PA14) remains set to PERIPH_A.
> >>>> Because of that, this pin is unusable to something else.
> >>>> This patch sets it back to GPIO.
> >>>
> >>> The policy is to leave pins in an unknown state till some peripheral
> >>> need them.
> >>>
> >>> What are you trying to use this pin for ?
> >> For chip select, but #3. And when SPI communicate with cs0 (PA22), it goes down too (PA14), so 2 devices on bus were
> >> selected.
> >
> > Are you using a 9x5ek board or a custom one, in the latter case could
> > you paste your spi0 node definition ?
> I'm using custom board. My spi node:
> 			spi0: spi@f0000000 {
> 				status = "okay";
> 				cs-gpios = <&pioA 23 0
> 					    &pioA 22 0
> 					    &pioC 29 0
> 					    &pioA 14 0>;
> 
> 				fm25@0 {
> 					compatible = "cypress,fm25";
> 					spi-max-frequency = <40000000>;
> 					reg = <0>;
> 					pagesize = <256>;
> 					size = <131072>;
> 					address-width = <24>;
> 				};
> 				/* ADC */
> 				spidev@1 {
> 					compatible = "spidev";
> 					reg = <1>;
> 					spi-max-frequency = <1000000>;
> 				};
> 				/* IO expander for busaddr */
> 				spidev@2 {
> 					compatible = "spidev";
> 					reg = <2>;
> 					label = "busaddr";
> 					spi-max-frequency = <10000000>;
> 				};
> 				/* audio codec */
> 				codec: codec@3 {
> 					compatible = "ti,tlv320aic3x";
> 					spi-max-frequency = <1000000>;
> 					reg = <3>;
> 				};
> 			};
> 
> This does not work without patch, because of 2 chips selected at one time because of PA14 is periph_a. Probably ROMBOOT 
> changes that.

Yes, boot code stored in ROM probably mux PA14 to periph A function,
but with your definition PA 14 should be set GPIO mode when the codec
device is created.

I don't see any obvious error in your definition, could you add a trace
there [1] to see if the gpio is successfully requested ?
Could you also paste the content of /sys/kernel/debug/gpio ?

> >
> >>> If you just want to use it as a chip select for an spi device, take a
> >>> look at [1].
> >> At [1] it's OK until as cs0 is for example PA22 and cs1 is PA14.
> >
> > If you want PA14 to control cs1 and PA22 to control cs0 (both
> > configured as GPIOs), you'll have the following definition:
> >
> > cs-gpios = <&pioA 22 0>, <&pioA 14 0>, <0>, <0>;
> See my node.
> >
> >>>
> >>> Here the gpio is requested by the spi core when defining the cs-gpios
> >>> property. The gpio controller then request the listed pins to the pin
> >>> controller (pinctrl driver).
> >> GPIO is not set in driver as GPIO, at least I didn't find it.
> >
> > Take a look at [1], which is set as the gpio_request_enable callback,
> > called by pinctrl core when a gpio is requested.
> But is this called from spi driver when requesting gpios as cs?

Yes, it's part of the gpio_request process:
gpio_request calls request method on at91 gpio_chip which in turn
calls pinctrl_request_gpio which then calls the gpio_request_enable
method I previously mentioned.


Best Regards,

Boris

[1]http://lxr.free-electrons.com/source/drivers/spi/spi-atmel.c#L1031

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
