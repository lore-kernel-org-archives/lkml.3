Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbbAMIUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:20:10 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:59725 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbAMIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:20:08 -0500
MIME-Version: 1.0
In-Reply-To: <54B01D44.5080601@broadcom.com>
References: <rjui@broadcom.com>
	<1417131990-17954-1-git-send-email-rjui@broadcom.com>
	<1417131990-17954-2-git-send-email-rjui@broadcom.com>
	<CACRpkdb5pNMbXmWGjrGpAYNLLwv6pWWOJQy0C6BLetNcStFM6A@mail.gmail.com>
	<54B01D44.5080601@broadcom.com>
Date: Tue, 13 Jan 2015 09:20:02 +0100
Message-ID: <CACRpkdbW5P=w0CPYYf_gfBuD7W0WOdAYCKpTXM5MsK9mdYDc5w@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: Broadcom Cygnus pinctrl device tree binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Ray Jui <rjui@broadcom.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Scott Branden <sbranden@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 7:26 PM, Ray Jui <rjui@broadcom.com> wrote:
> On 1/9/2015 2:12 AM, Linus Walleij wrote:

>> Just use "groups" and "function" and refer to
>> Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
>>
>> Then "alt1", "alt2" etc are non-functional names of functions.
>> Use the real function names, like "spi0" or so. This
>> alt-business seems to be just a shortcut to make it
>> simple, don't do that.
>>
>> Then you use e.g. "spi0" as a group name. I prefer you
>> call that "spi0_grp" or something to say it is a group of
>> pins associated with spi0, as spi0 is actually the
>> function.
>>
> Hmmm, I did this by following brcm,bcm11351-pinctrl.txt:
> - function: String. Specifies the pin mux selection. Values must be one
> of: "alt1", "alt2", "alt3", "alt4"
>
> But you are right, in the pinctrl binding document it describes the
> generic pin multiplexing nodes use "function" and "group".

Note "function" and "groups". Note groups is pluralis. You can
select multiple groups for a single function.

> For example, the group "lcd" covers 30 pins. When I configure "lcd" to
> alternate function 1, all 30 pins are muxed to LCD function. When
> configured to function 2, all pins are muxed to SRAM function. Now, here
> comes the issue, when configured to function 3, pins 1-15 and 20-30
> become GPIO function, but pins 16-19 becomes SPI5 function. When it's
> configured to function 4, all 30 pins become GPIO.

I would split the use case in two groups for LCD and SRAM,
and three groups for GPIO:
"lcd_grp", "sram_grp", "gpio-1-15_grp",
"gpio-16-19_grp", "gpio-20-30_grp", "spi5_grp"

Valid combinations become

function = "lcd"
groups = "lcd_grp";

function = "sram"
groups = "sram_grp"

For all GPIO only this:

function = "gpio"
groups = "gpio-1-16_grp", "gpio-16-19_grp", "gpio-20-30_grp"

For a combined GPIO+SPI:

function = "gpio"
groups = "gpio-1-16_grp", "gpio-20-30_grp"

function = "spi5"
groups = "spi5_grp"

The pinctrl runtile will protest if you try to combine spi5_grp
with gpio-16-19_grp.

> In some other cases, when I configure a group to other functions, there
> could be spare pins which become unused (not brought out to the pad).
> Or, the spare pins may also become a separate function.

That's cool.

> Based on the LCD example, I'd assume I would do the following for the
> default LCD function:
>
> lcd_node {
>         group = "lcd_grp";
>         function = "lcd";
> };
>
> And in the case of function 3, I would call the function "spi5" and
> assume the rest of pins become either GPIO (or unused)?
>
> spi5_node {
>         group = "lcd_grp";
>         function = "spi5";
> };

Looks cool per above.

You need some clever code in the driver to handle double-configuration
of registers and so on, but I think it can be done.

Using pin control as a GPIO backend can be a bit tricky and will need
some testing and elaboration, but the subsystem will block collisions.

Yours,
Linus Walleij
