Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaAMMMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:12:32 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59381 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaAMMMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:12:30 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbih0xQWqnuouhuiRCzYmou++76ex5zC1nh=iBQWJ9otA@mail.gmail.com>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-4-git-send-email-lpapp@kde.org>
	<CACRpkdbAPYs=48RXr6r5kqkYj2V9GitRMT2BRKkn4_gT77wUEg@mail.gmail.com>
	<CAOMwXhNcmbk92TsNTGVQdfWrbVycVW++-+46+8onDZ5xPCD-Jw@mail.gmail.com>
	<CACRpkdbih0xQWqnuouhuiRCzYmou++76ex5zC1nh=iBQWJ9otA@mail.gmail.com>
Date: Mon, 13 Jan 2014 12:12:29 +0000
X-Google-Sender-Auth: 8KYkGzWxhHWunnrBF2vEUA6Hnrg
Message-ID: <CAOMwXhMtc44SpA5yoGBP38muMqPMi3EkxeAKh3V5c_H=3qoXhw@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 9:43 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Jan 8, 2014 at 3:59 PM, Laszlo Papp <lpapp@kde.org> wrote:
>> On Tue, Jan 7, 2014 at 2:33 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>
>>> As I can see this is really a GPIO+pin control driver it shall be
>>> moved to drivers/pinctrl.
>>
>> Hmm, but then I am not sure why the gpio-max*.c are similar in the
>> drivers/gpio area. Could you please elaborate? They are somewhat
>> similar to my understanding, but perhaps there is some fundamental
>> difference I am not aware of?
>
> The other drivers were merged before the pin control subsystem
> existed. If they had been submitted today, the comments would
> be the same as for your driver.

Fair enough, but I have one question in here: shall I keep the gpio
driver in place and the layer on top of that would be established
under drivers/pinctrl or the whole should be moved to there?

>>> Do you *really* have to split up this handling into two files with
>>> criss-cross calls like this?
>>
>> I personally think it is a bit excessive, so I agree with you. I
>> wished to stay somewhat consistent to the following drivers:
>>
>> * gpio-max730x.c
>> * gpio-max7300.c
>> * gpio-max7301.c
>>
>> Are you OK with that then if I do not follow the consistency?
>
> Yes. It should be moved to pinctrl anyway.

Even the gpio functionality itself? So, to clarify my question above,
I thought it would be something like this:

- gpio
          \
           ---
              \
- alarm ----- pinctrol
              /
         ----
- etc /

So, pinctrl on top of them, and only this high layer would be moved to
pinctrl. Perhaps, I should check existing drivers and the pinctrl
before asking this... Will have a look very soon.

> What about rewriting and fixing up all drivers.
>
>>> Anyway if you absolutely have to do
>>> this don't use "__" prefixes, those are for the preprocessor.
>>> Just max665x_probe() is fine.
>>
>> This is because of the same reason as above: consistency. I can drop
>> it if you wish?
>
> Yes please.

Good, thanks.

>>> Why does it have to be subsys_initcall? Please try to avoid
>>> this.
>>
>> It is for consistency just as before. :-) Could you please elaborate
>> why it is better to be avoided, or at least point me to some
>> documentation?
>
> We want to move all drivers to module_init() (device_initcall level)
> as shoveling initcalls around is creating an uncontrolled and
> unmaintained mess.
>
> To fix this, we're using deferred probe.
>
> See commit d1c3414c2a9d10ef7f0f7665f5d2947cd088c093
> "drivercore: Add driver probe deferral mechanism"

Thanks.

>>> And *why* should I have a fan controller in the GPIO subsystem?
>>> I don't quite get this.
>>
>> The MAX6651 chip is multifunctional, but it is ultimate a fan
>> controller IC as per Kconfig guided text. If you prefer, I can rename
>> the term here to refer to the GPIO subfunctionality, or you had
>> something else in mind?
>
> Aha OK I can live with this, sorry for missing the Kconfig
> fragment.

OK, thanks.

>>>> +    switch (offset) {
>>>> +    case 0:
>>>> +        level = max665x_get_level(gpio, offset, config & PIN0_CONFIG_MASK);
>>>> +        break;
>>>> +    case 1:
>>>> +        level = max665x_get_level(gpio, offset, (config & PIN1_CONFIG_MASK) >> 2);
>>>> +        break;
>>>> +    case 2:
>>>> +        level = max665x_get_level(gpio, offset, (config & PIN2_CONFIG_MASK) >> 4);
>>>> +        break;
>>>> +    case 3:
>>>> +        level = max665x_get_level(gpio, offset, (config & PIN3_CONFIG_MASK) >> 5);
>>>> +        break;
>>>> +    case 4:
>>>> +        level = max665x_get_level(gpio, offset, (config & PIN3_CONFIG_MASK) >> 6);
>>>> +        break;
>>>
>>> This looks like it could be made a lot simpler using a table.
>>
>> How exactly would you like to have it?
>
> struct max_config {
>     u32 mask;
>     u8 shift;
> };
>
> struct max_config max_configs = {
>     {
>         .mask = PIN0_CONFIG_MASK,
>         .shift = 0,
>     },
>     {
>         .mask = PIN1_CONFIG_MASK,
>         .shift = 2,
>     },
> ....
>
> struct max_config *cfg = max_configs[offset];
>
> level = max665x_get_level(gpio, offset, (config & cfg->mask) >> cfg->shift);
>
> You get the idea.

Yes, thanks.

>>> No way. No custom interfaces for setting pullups, use generic pin config.
>>
>> What do you mean here? Could you please elaborate a bit more? The pull
>> up trait depends on the given hardware. It must be coming from
>> platform data, e.g. we can supply the right variant from our custom
>> board file.
>
> I mean use pin config from pin control for setting this.
> Documentation/pinctrl.txt
>
> Regarding your comment on platform data, see the section named
> "Board/machine configuration".

OK, I will have a look; thanks.

>>> Why can't you always use dynamic assignments of GPIO numbers?
>>
>> Because this information is board related.
>
> OK so this board is not using any dynamic number assignment
> system such as ACPI or device tree?

I cannot be sure if I understand the question correctly, but what I
can say now is that we use a custom board file not upstreamed.

> Which board is it?

It is our custom board. We have also been developing hardware, not
just software.

>>> When implementing the pinctrl interface, you may want to use
>>> gpiochip_add_pin_range() to cross-reference between GPIOs
>>> and pinctrl.
>>
>> Well, Guenter wanted to go through the gpio system... Perhaps, it was
>> not made clear that pinctrl would be better. I just followed the GPIO
>> generic guideline. :)
>
> GPIO is not sufficient since it needs both GPIO and pin
> control interfaces. You need both/and not either/or.
> Look at other driver in drivers/pinctrl and you will get the hang
> of this.

OK, I believe the Linux kernel is too big to adequate answers from
anyone for any area, so it is fine. At least, I have been pointed to
here, but then it is good that this gpio functionality was not put
into the hwmon directly as suggested over there if I am not mistaken.
