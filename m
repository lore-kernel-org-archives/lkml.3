Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3LQRuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:50:17 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:45040 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3LQRuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:50:11 -0500
MIME-Version: 1.0
In-Reply-To: <20131212090838.GD25478@pengutronix.de>
References: <1386364179-28650-1-git-send-email-delicious.quinoa@gmail.com>
	<CANk1AXS=CADN53aO5KVN3UorddJ0wZ2PTqwo2XmeRuxYe_DoLg@mail.gmail.com>
	<20131212090838.GD25478@pengutronix.de>
Date: Tue, 17 Dec 2013 11:50:09 -0600
Message-ID: <CANk1AXQqXT7evrGkLEam8SP=bXRCdrnke+Q+HbWeTMP5MPFubw@mail.gmail.com>
Subject: Re: [PATCH v9] gpio: add a driver for Synopsys DesignWare APB GPIO
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 3:08 AM, Steffen Trumtrar
<s.trumtrar@pengutronix.de> wrote:
> Sorry for chiming in late. I tested your driver on the Sockit and the GPIOs
> work fine (basically just tested the 4 HPS LEDS that are on this board).
>
> With the interrupt support I had a little trouble though:
> The Sockit has an ADXL345 on the i2c bus with a gpio as interrupt line.
>
> First: When you use "interrupt-parent", you have to specify the gpio node,
> rather than the gpio-bank that has the interrupt-controller property. Is
> that expected? I'm not really sure if that is normal behavior...

I think it can work several ways.  In my device tree, the gic is one
level up in the device tree above the gpio.  So I don't have to
specify interrupt-controller in the gpio node or in the bank.

>
> Second: The interrupt is registered as "GIC 37", which is a real interrupt on
> the Socfpga. I would expect it to be marked as "GPIO 2xx" (or something in that
> range). The interrupt from the gpiochip itself isn't registered at all ?!

The bindings documentation is an example.  You will need to adjust the
device tree bindings values to suit your board.  For example, on my
socfpga cyclone5 board, I needed:

        gpio0: gpio@ff708000 {
                compatible = "snps,dw-apb-gpio";
                reg = <0xff708000 0x1000>;
                #address-cells = <1>;
                #size-cells = <0>;

                port0a: gpio-controller@0 {
                        compatible = "snps,dw-apb-gpio-port";
                        gpio-controller;
                        #gpio-cells = <2>;
                        snps,nr-gpios = <29>;
                        reg = <0>;
                        interrupt-controller;
                        interrupts = <0 164 4>;
                        #interrupt-cells = <2>;
                        clocks = <&per_base_clk>;
                        };
                };

(so on for gpio1 and gpio2)

>
> Third: The interrupt didn't work. But that might also be my failure. I guess/hope
> you tested interrupts successfully?!

Yes, tested and working for me, including the interrupts.

>
> (Fourth: small typo in the documentation example: "snps,nr-gpio" instead of "snps,nr-gpios")

Yes, should be the plural form.

Thanks for testing!

Alan

>
> Regards,
> Steffen
>
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
