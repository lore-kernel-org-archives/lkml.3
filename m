Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaAMJnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:43:42 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:51283 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaAMJnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:43:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhNcmbk92TsNTGVQdfWrbVycVW++-+46+8onDZ5xPCD-Jw@mail.gmail.com>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-4-git-send-email-lpapp@kde.org>
	<CACRpkdbAPYs=48RXr6r5kqkYj2V9GitRMT2BRKkn4_gT77wUEg@mail.gmail.com>
	<CAOMwXhNcmbk92TsNTGVQdfWrbVycVW++-+46+8onDZ5xPCD-Jw@mail.gmail.com>
Date: Mon, 13 Jan 2014 10:43:39 +0100
Message-ID: <CACRpkdbih0xQWqnuouhuiRCzYmou++76ex5zC1nh=iBQWJ9otA@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: MAX6650/6651 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 3:59 PM, Laszlo Papp <lpapp@kde.org> wrote:
> On Tue, Jan 7, 2014 at 2:33 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> As I can see this is really a GPIO+pin control driver it shall be
>> moved to drivers/pinctrl.
>
> Hmm, but then I am not sure why the gpio-max*.c are similar in the
> drivers/gpio area. Could you please elaborate? They are somewhat
> similar to my understanding, but perhaps there is some fundamental
> difference I am not aware of?

The other drivers were merged before the pin control subsystem
existed. If they had been submitted today, the comments would
be the same as for your driver.

>> Do you *really* have to split up this handling into two files with
>> criss-cross calls like this?
>
> I personally think it is a bit excessive, so I agree with you. I
> wished to stay somewhat consistent to the following drivers:
>
> * gpio-max730x.c
> * gpio-max7300.c
> * gpio-max7301.c
>
> Are you OK with that then if I do not follow the consistency?

Yes. It should be moved to pinctrl anyway.

What about rewriting and fixing up all drivers.

>> Anyway if you absolutely have to do
>> this don't use "__" prefixes, those are for the preprocessor.
>> Just max665x_probe() is fine.
>
> This is because of the same reason as above: consistency. I can drop
> it if you wish?

Yes please.

>> Why does it have to be subsys_initcall? Please try to avoid
>> this.
>
> It is for consistency just as before. :-) Could you please elaborate
> why it is better to be avoided, or at least point me to some
> documentation?

We want to move all drivers to module_init() (device_initcall level)
as shoveling initcalls around is creating an uncontrolled and
unmaintained mess.

To fix this, we're using deferred probe.

See commit d1c3414c2a9d10ef7f0f7665f5d2947cd088c093
"drivercore: Add driver probe deferral mechanism"

>> And *why* should I have a fan controller in the GPIO subsystem?
>> I don't quite get this.
>
> The MAX6651 chip is multifunctional, but it is ultimate a fan
> controller IC as per Kconfig guided text. If you prefer, I can rename
> the term here to refer to the GPIO subfunctionality, or you had
> something else in mind?

Aha OK I can live with this, sorry for missing the Kconfig
fragment.

>> Since this is really pin configuration the driver should support more
>> stuff in the long run, and then it should be in drivers/pinctrl.
>
> Could you please elaborate what more stuff you have in mind for this?

Implement pin config portions of pin control. See
Documentation/pinctrl.txt

(You answer this yourself later.)

>>> +    switch (offset) {
>>> +    case 0:
>>> +        level = max665x_get_level(gpio, offset, config & PIN0_CONFIG_MASK);
>>> +        break;
>>> +    case 1:
>>> +        level = max665x_get_level(gpio, offset, (config & PIN1_CONFIG_MASK) >> 2);
>>> +        break;
>>> +    case 2:
>>> +        level = max665x_get_level(gpio, offset, (config & PIN2_CONFIG_MASK) >> 4);
>>> +        break;
>>> +    case 3:
>>> +        level = max665x_get_level(gpio, offset, (config & PIN3_CONFIG_MASK) >> 5);
>>> +        break;
>>> +    case 4:
>>> +        level = max665x_get_level(gpio, offset, (config & PIN3_CONFIG_MASK) >> 6);
>>> +        break;
>>
>> This looks like it could be made a lot simpler using a table.
>
> How exactly would you like to have it?

struct max_config {
    u32 mask;
    u8 shift;
};

struct max_config max_configs = {
    {
        .mask = PIN0_CONFIG_MASK,
        .shift = 0,
    },
    {
        .mask = PIN1_CONFIG_MASK,
        .shift = 2,
    },
....

struct max_config *cfg = max_configs[offset];

level = max665x_get_level(gpio, offset, (config & cfg->mask) >> cfg->shift);

You get the idea.

>> No way. No custom interfaces for setting pullups, use generic pin config.
>
> What do you mean here? Could you please elaborate a bit more? The pull
> up trait depends on the given hardware. It must be coming from
> platform data, e.g. we can supply the right variant from our custom
> board file.

I mean use pin config from pin control for setting this.
Documentation/pinctrl.txt

Regarding your comment on platform data, see the section named
"Board/machine configuration".

>> Why can't you always use dynamic assignments of GPIO numbers?
>
> Because this information is board related.

OK so this board is not using any dynamic number assignment
system such as ACPI or device tree? Which board is it?

>> When implementing the pinctrl interface, you may want to use
>> gpiochip_add_pin_range() to cross-reference between GPIOs
>> and pinctrl.
>
> Well, Guenter wanted to go through the gpio system... Perhaps, it was
> not made clear that pinctrl would be better. I just followed the GPIO
> generic guideline. :)

GPIO is not sufficient since it needs both GPIO and pin
control interfaces. You need both/and not either/or.

Look at other driver in drivers/pinctrl and you will get the hang
of this.

>>> +++ b/include/linux/mfd/max6651-private.h
>> (...)
>>> +struct max665x_gpio {
>>> +    u8     input_pullup_active;
>>
>> No way.
>
> Why so? How would you make it customizable by board files otherwise?

I mean use pin config from pin control for setting this.
Documentation/pinctrl.txt

Regarding your comment on platform data, see the section named
"Board/machine configuration".

Yours,
Linus Walleij
