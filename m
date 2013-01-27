Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab3A0Ocz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 09:32:55 -0500
Received: from antcom.de ([188.40.178.216]:36363 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab3A0Ocx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 09:32:53 -0500
Message-ID: <510539C5.8000208@antcom.de>
Date: Sun, 27 Jan 2013 15:29:25 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Stijn Devriendt <highguy@gmail.com>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com, mark.rutland@arm.com,
        nicolas.ferre@atmel.com
Subject: Re: [PATCH 5/6 v14] gpio: Add device tree support to block GPIO API
References: <1358856404-8975-1-git-send-email-stigge@antcom.de> <1358856404-8975-6-git-send-email-stigge@antcom.de> <CAOY=C6E-+uKQGbRDjNh5ZP9Wrmd+PNbt7djkBTzwe29=qA1_PA@mail.gmail.com>
In-Reply-To: <CAOY=C6E-+uKQGbRDjNh5ZP9Wrmd+PNbt7djkBTzwe29=qA1_PA@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/13 14:07, Stijn Devriendt wrote:
>> +Example:
>> +
>> +        blockgpio {
>> +                compatible = "linux,gpio-block";
>> +
>> +                block0 {
>> +                        gpios = <&gpio 3 0 0>,
>> +                                <&gpio 3 1 0>;
>> +                };
>> +                block1 {
>> +                        gpios = <&gpio 4 1 0>,
>> +                                <&gpio 4 3 0>,
>> +                                <&gpio 4 2 0>,
>> +                                <&gpio 4 4 0>,
>> +                                <&gpio 4 5 0>,
>> +                                <&gpio 4 6 0>,
>> +                                <&gpio 4 7 0>,
>> +                                <&gpio 4 8 0>,
>> +                                <&gpio 4 9 0>,
>> +                                <&gpio 4 10 0>,
>> +                                <&gpio 4 19 0>;
>> +                };
>> +        };
> 
> How do you see bindings for other kinds of drivers?
> 
> In my patchset, it's possible for other drivers to use gpio-blocks.
> One example we have is a power sequencer with 2 pins attached
> to GPIO pins. These 2 pins form a 2bit word to select power margining.
> These 2 pins need to be set synchronously (as otherwise when going
> from profile 0 to profile 3 you pass either profile 1 or profile 2 which
> could be bad for hardware)
> 
> In the device-tree this is specified as:
> 
> powr@0x20 {
>    // other properties
> 
>   gpios = <&gpio 4 0
>                &gpio 5 0>;
> };
> 
> Is this kind of integration also possible?

You can reference the gpio block via a phandle, e.g.:

        blockgpio {
                compatible = "linux,gpio-block";

                selector1 {
                        gpios = <&gpio 4 0>,
                                <&gpio 5 0>;
                };
        };

        powr@0x20 {
                // ...

                gpios = <&selector1>;
        };


In the driver, you can get the gpio block like this:

block = gpio_block_find_by_name(of_parse_phandle(powr, "gpios", 0)->name);

(Simplified by removed error/NULL handling!)

If this turns out to be a common pattern, I can add a convenience "get"
function for this.

Roland
