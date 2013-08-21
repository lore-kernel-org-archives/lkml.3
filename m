Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3HUP5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:57:13 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39409 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3HUP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:57:08 -0400
MIME-Version: 1.0
In-Reply-To: <2276651.WHL3SkvOZi@vostro.rjw.lan>
References: <20130820192650.GA19470@srcf.ucam.org>
	<2276651.WHL3SkvOZi@vostro.rjw.lan>
Date: Wed, 21 Aug 2013 17:57:07 +0200
Message-ID: <CACRpkdaVz28gn-keUC4tTX+bdTKEV2ZrdHxshG=K3oM_NhvroA@mail.gmail.com>
Subject: Re: ACPI vs Device Tree - moving forward
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Darren Hart <dvhart@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:11 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> There's one more problematic case which is that some systems ship with ACPI
> tables that don't contain all of the information necessary to enumerate
> hardware appropriately and it's difficult, if not impossible, to convince
> the vendors of those systems to fix their ACPI firmware after the fact.
> However, at least in some cases there are well defined DT bindings for the
> hardware in question.

I think this works as far as the hardware can be described in a simple
way.

When the hardware is complex, the problem of interoperating with ACPI
becomes complex, because when it comes to interrupts and other
resources, it seems to me that both ACPI and DT wants to be in
the driver seat and there is only place for one.

Let me copy this example again for this wider discusson
(OK Rafael has seen it before, so you can skip the rest):

Here is an example:
drivers/gpio/gpio-stmpe.c

This is a generic multi-purpose-expander, it can be used on any
system, be it ARM, blackfin or x86 embedded. You connect this
to an I2C port and then there is an IRQ line that you will need to
connect to a dedicated IRQ in pin or a GPIO line configured to take
an IRQ in. Since it contains a GPIO expander and a keypad driver
those two aspects get configured.

It looks like this in an I2C controller node
(condensed from arch/arm/boot/dts/href.dtsi and more)

i2c@80004000 {
        stmpe1601: stmpe1601@40 {
                compatible = "st,stmpe1601";
                reg = <0x40>;
                interrupts = <26 IRQ_TYPE_EDGE_FALLING>;
                interrupt-parent = <&gpio6>;
                interrupt-controller;

                wakeup-source;
                st,autosleep-timeout = <1024>;

                stmpe_keypad {
                        compatible = "st,stmpe-keypad";

                        debounce-interval = <64>;
                        st,scan-count = <8>;
                        st,no-autorepeat;

                        linux,keymap = <0x205006b
                                        0x4010074
                                        0x3050072
                                        0x1030004
                                        0x502006a
                                        0x500000a
                                        0x5008b
                                        0x706001c
                                        0x405000b
                                        0x6070003
                                        0x3040067
                                        0x303006c
                                        0x60400e7
                                        0x602009e
                                        0x4020073
                                        0x5050002
                                        0x4030069
                                        0x3020008>;
                };
         };
};

As you can some stuff is nice to get for free: the keymap
parser, scan settings, debounce, and so on. But then we run
into these problems:

- The I2C address is specified in "reg" - maybe ACPI have
  some other way to assign I2C addresses to I2C devices?
  In any case, it *must* reference the parent I2C controller,
  here that is done implicitly by placing this DT node inside
  the I2C controllers DT node.

- Then it is using a GPIO line as interrupt, and specify that
  this shall be configured as a falling edge IRQ.

- It then tells the interrupt controller parent. So it needs
  to have a reference to whatever interrupt chip device
  will handle that IRQ.

- Further it *is* an interrupt controller, so devices connected
  to the GPIO lines may generate IRQs and then this
  device should service them. Is it possible that the devices
  connected to this expander in turn use ACPI to describe
  themselves? Then we need a reference in the other
  direction.

- Further it is a wakeup source, so each IRQ it provides
  on its GPIO lines can be set as a wakeup. I wonder how
  this plays with D-states and ACPI.

-------

I did present the above as an extreme example, but if we
start to combine DT and ACPI we have to have that kind of
hardware in mind. GPIO expanders with IRQs and all are
maybe rare on desktops and laptops but very common on
embedded systems.

Yours,
Linus Walleij
