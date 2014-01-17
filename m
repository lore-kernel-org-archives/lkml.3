Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaAQXL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 18:11:59 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:65308 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAQXL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 18:11:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAGb2v67UKiyfJbKZ_Frk3OwZupMPoA2Ck3Hj2zsRFXBQPztavg@mail.gmail.com>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
	<1389941251-32692-5-git-send-email-wens@csie.org>
	<201401171747.46332.arnd@arndb.de>
	<CAGb2v67UKiyfJbKZ_Frk3OwZupMPoA2Ck3Hj2zsRFXBQPztavg@mail.gmail.com>
Date: Sat, 18 Jan 2014 00:11:56 +0100
Message-ID: <CACRpkdZOD4zeA8T5kbJ4c5NsnuzHCg1mw8rRMYNT9c4R-Qnc6A@mail.gmail.com>
Subject: Re: [PATCH RFC 4/6] net: rfkill: gpio: add device tree support
From: Linus Walleij <linus.walleij@linaro.org>
To: Chen-Yu Tsai <wens@csie.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 6:43 PM, Chen-Yu Tsai <wens@csie.org> wrote:
> On Sat, Jan 18, 2014 at 12:47 AM, Arnd Bergmann <arnd@arndb.de> wrote:

>>> +- NAME_shutdown-gpios  : GPIO phandle to shutdown control
>>> +                         (phandle must be the second)
>>> +- NAME_reset-gpios     : GPIO phandle to reset control
>>> +
>>> +NAME must match the rfkill-name property. NAME_shutdown-gpios or
>>> +NAME_reset-gpios, or both, must be defined.
>>> +
>>
>> I don't understand this part. Why do you include the name in the
>> gpios property, rather than just hardcoding the property strings
>> to "shutdown-gpios" and "reset-gpios"?
>
> This quirk is a result of how gpiod_get_index implements device tree
> lookup.

Why can't it just have a single property "gpios", where the first
element is the reset GPIO and the second is the shutdown GPIO?

rfkill-gpio does this:

gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
gpio = devm_gpiod_get_index(&pdev->dev, rfkill->shutdown_name, 1);

The passed con ID name parameter is only there for the device
tree case it seems. (ACPI ignores it.) So what about you just
don't pass it at all and patch it to do like this instead:

gpio = devm_gpiod_get_index(&pdev->dev, NULL, 0);
gpio = devm_gpiod_get_index(&pdev->dev, NULL, 1);

Heikki, are you OK with this change?

I think this is actually necessary if the ACPI and DT unification
pipe dream shall limp forward, we cannot have arguments passed
that have a semantic effect on DT but not on ACPI... Drivers
that are supposed to use both ACPI and DT will always
have to pass NULL as con ID.

> If con_id is given, it is prepended to "gpios" as the property string.
> con_id is also used as the label passed to gpiod_request, which is
> then shown in /sys/kernel/debug/gpio.

If your problem  is really what turns up in debugfs, then we need
to figure out a way to label gpios outside of the *gpiod_get* calls.

The string passed in *gpiod_get* is a "connection ID" not a proper
name for the GPIO.

Yours,
Linus Walleij
