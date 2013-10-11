Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab3JKPoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:44:18 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33276 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439Ab3JKPoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:44:14 -0400
MIME-Version: 1.0
In-Reply-To: <1381503190-5733-1-git-send-email-jonas.jensen@gmail.com>
References: <1375103161-12460-1-git-send-email-jonas.jensen@gmail.com>
	<1381503190-5733-1-git-send-email-jonas.jensen@gmail.com>
Date: Fri, 11 Oct 2013 17:44:13 +0200
Message-ID: <CACRpkda23nUF8i03RWePj+dGa9Wj6E1L8vfPMfxvnGkazfKS5w@mail.gmail.com>
Subject: Re: [PATCH v5] gpio: Add MOXA ART GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 4:53 PM, Jonas Jensen <jonas.jensen@gmail.com> wrote:

>     I agree it is a bit strange GPIO control is divided in two
>     separate registers. Unfortunately I can't offer an explanation
>     because the documentation is not publicly available.
>
>     The register responsible for doing enable/disable is located
>     at <0x98100100 0x4>, the clock register is very close at
>     <0x98100000 0x34>.

If we don't know we have to guess.

This layout makes me think that the IO-window at 0x98100000 is
a power-clock-and-reset controller. It contains some register
to latch the pins enable/disable them, or if this is even a clock
gate? Are you sure about this? Is it now a gated clock, simply,
so that this bit should be handled in the clock driver, i.e.
this bit gets set by clk_enable() from the GPIO driver?

I am very suspicious about this especially since the GPIO
driver is lacking clk_get() and friends.

If it's not a clock gate, and you are convinced that you must still
reach out into this range I think you want something like this:

syscon: syscon@98100000 {
                compatible = "syscon";
                reg = <0x98100000 0x1000>;
};

gpio: gpio@98700000 {
               gpio-controller;
               #gpio-cells = <2>;
               syscon = <&syscon>;
               compatible = "moxa,moxart-gpio";
               reg =   <0x98700000 0xC>,
                       <0x98100100 0x4>;
};

Then the driver can use something like:

        struct device_node *np = pdev->dev.of_node;
        struct device_node *syscon_np;
        struct regmap *regmap;
        int err;

        syscon_np = of_parse_phandle(np, "syscon", 0);
        if (!syscon_np) {
                pr_crit("no syscon node\n");
                return -ENODEV;
        }
        regmap = syscon_node_to_regmap(syscon_np);
        if (!regmap) {
                pr_crit("could not locate syscon regmap\n");
                return -ENODEV;
        }

Then update the registers using regmap_update_bits() and
friends.

>     I don't think gpio_poweroff driver is right for this hardware
>     because the pin is not connected to anything that can do reset.
>     The old 2.6.9 kernel driver uses timer poll with eventual call
>     to userspace.
>
>     To test that it works, I added gpio_poweroff anyway, modified
>     with gpio_export() the pin can then be seen switching between
>     0 and 1 (on "cat /sys/class/gpio/gpio25/value").

Hmmmm not quite following this...

> +Required properties:
> +
> +- #gpio-cells : Should be 2, The first cell is the pin number and
> +               the second cell is used to specify polarity:
> +                       0 = active high
> +                       1 = active low

Could reference <dt-bindings/gpio/gpio.h> I guess?

Oh well, no big deal.

The driver as such is looking nice but now I strongly suspect
it should clk_get/clk_prepare/clk_enable ... etc.

Yours,
Linus Walleij
