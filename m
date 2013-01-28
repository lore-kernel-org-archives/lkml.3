Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3A1LjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:39:10 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:61476 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab3A1LjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:39:06 -0500
MIME-Version: 1.0
In-Reply-To: <510539C5.8000208@antcom.de>
References: <1358856404-8975-1-git-send-email-stigge@antcom.de>
	<1358856404-8975-6-git-send-email-stigge@antcom.de>
	<CAOY=C6E-+uKQGbRDjNh5ZP9Wrmd+PNbt7djkBTzwe29=qA1_PA@mail.gmail.com>
	<510539C5.8000208@antcom.de>
Date: Mon, 28 Jan 2013 12:39:05 +0100
Message-ID: <CAOY=C6HTRFY=rXOAhTwuR3NvtaRFbfbkkpn7FeyK+eqG7sVcKg@mail.gmail.com>
Subject: Re: [PATCH 5/6 v14] gpio: Add device tree support to block GPIO API
From: Stijn Devriendt <highguy@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com, mark.rutland@arm.com,
        nicolas.ferre@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 3:29 PM, Roland Stigge <stigge@antcom.de> wrote:
> On 27/01/13 14:07, Stijn Devriendt wrote:
>>> +Example:
>>> +
>>> +        blockgpio {
>>> +                compatible = "linux,gpio-block";
>>> +
>>> +                block0 {
>>> +                        gpios = <&gpio 3 0 0>,
>>> +                                <&gpio 3 1 0>;
>>> +                };
>>> +                block1 {
>>> +                        gpios = <&gpio 4 1 0>,
>>> +                                <&gpio 4 3 0>,
>>> +                                <&gpio 4 2 0>,
>>> +                                <&gpio 4 4 0>,
>>> +                                <&gpio 4 5 0>,
>>> +                                <&gpio 4 6 0>,
>>> +                                <&gpio 4 7 0>,
>>> +                                <&gpio 4 8 0>,
>>> +                                <&gpio 4 9 0>,
>>> +                                <&gpio 4 10 0>,
>>> +                                <&gpio 4 19 0>;
>>> +                };
>>> +        };
>>
>> How do you see bindings for other kinds of drivers?
>>
>> In my patchset, it's possible for other drivers to use gpio-blocks.
>> One example we have is a power sequencer with 2 pins attached
>> to GPIO pins. These 2 pins form a 2bit word to select power margining.
>> These 2 pins need to be set synchronously (as otherwise when going
>> from profile 0 to profile 3 you pass either profile 1 or profile 2 which
>> could be bad for hardware)
>>
>> In the device-tree this is specified as:
>>
>> powr@0x20 {
>>    // other properties
>>
>>   gpios = <&gpio 4 0
>>                &gpio 5 0>;
>> };
>>
>> Is this kind of integration also possible?
>
> You can reference the gpio block via a phandle, e.g.:
>
>         blockgpio {
>                 compatible = "linux,gpio-block";
>
>                 selector1 {
>                         gpios = <&gpio 4 0>,
>                                 <&gpio 5 0>;
>                 };
>         };
>
>         powr@0x20 {
>                 // ...
>
>                 gpios = <&selector1>;
>         };
>
>
> In the driver, you can get the gpio block like this:
>
> block = gpio_block_find_by_name(of_parse_phandle(powr, "gpios", 0)->name);
>
> (Simplified by removed error/NULL handling!)
>
> If this turns out to be a common pattern, I can add a convenience "get"
> function for this.

Given the pick-up of device-tree in ARM and MIPS, I think this stands
a good chance
of becoming a common pattern. Do mind the "gpios" name; it's already used by the
normal GPIO request functions...

This is one of the things I liked about my patch, there's little
difference between
using a group of GPIOs versus multiple separate GPIOs. The device-tree
description
is the same, only the driver handles them differently.
You could ask the question whether the device-tree should make a
difference between
1 GPIO, 2 separate GPIOs or 3 GPIOs in a block. For a H/W description
language it's
all the same. It is an implementation detail of the OS/drivers whether
they handle them
as a block or as separate GPIOs.

Regards,
Stijn
