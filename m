Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3FEHBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:01:47 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53422 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3FEHBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:01:45 -0400
MIME-Version: 1.0
In-Reply-To: <201306041405.13320.heiko@sntech.de>
References: <201306030055.15413.heiko@sntech.de>
	<201306030059.47611.heiko@sntech.de>
	<CACRpkdbBr7s1NoTQewVOotorHJHLL8Z6-_gAx5GC0x6uNUX0gw@mail.gmail.com>
	<201306041405.13320.heiko@sntech.de>
Date: Wed, 5 Jun 2013 09:01:44 +0200
Message-ID: <CACRpkdZty-TszfBTOab4_PUi8dy5DYim=wNERv=pyqC3HNuT4w@mail.gmail.com>
Subject: Re: [PATCH 07/10] pinctrl: add pinctrl driver for Rockchip SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 2:05 PM, Heiko Stübner <heiko@sntech.de> wrote:

>> > +PULL_AUTO      (1 << 0): indicate this pin needs a pull setting for SoCs
>> > +                         that determine the pull up or down themselfs
>>
>> Hm, never saw that before...
>
> Citing the original gpio driver:
>
>         /*
>          * Values written to this register independently
>          * control Pullup/Pulldown or not for the
>          * corresponding data bit in GPIO.
>          * 0: pull up/down enable, PAD type will decide
>          * to be up or down, not related with this value
>          * 1: pull up/down disable
>          */
>
> So if it's a pull up or down is decided based on the mux of the pin. Calling
> everything a "pull down" (or up) when it isn't seemed somehow wrong to me.
>
> The rk3188 on the other hand supports both pull up and down separately.
>
> Or should this be selected as PULL_UP | PULL_DOWN in the config?

The generic config is pretty much either/or so it'd be a new
config for that approach.

Basically it seems they have embedded knowledge into the
silicon: there is no specific rule as to whether a pad should be
pulled up or down depending on "pad type" as is stated, rather
it's so that if you know a pad will be used for I2C SCL then
you know it needs pull-up. Probably something like a "1" on
some constant switch in VHDL/Verilog is hard-coded into
the silicon turning on pull-up if I2C is selected and the
autopull is set for example.

>> +config PINCTRL_ROCKCHIP
>> +       bool
>> +       select PINMUX
>> +       select PINCONF
>> +       select GENERIC_IRQ_CHIP
>>
>> Why is this super-simple pin config thing not using
>> GENERIC_PINCONF?
>>
>> I *know* it is simpler to implement your own thing, but think of the
>> poor maintainers that have to wade through 50 identical implementations.
>> Do this, it pays off.
>
> generic pinconf sounds interesting ... will give it a try.
>
> The only problem is the pull stuff mentioned above that is either pull up or
> down without the driver having knowledge about it. And generic_pinconf only
> knows about them separately right now.

Create a separate patch adding PIN_CONFIG_BIAS_PULL_AUTO
to include/linux/pinctrl/pinconf-generic.h, don't forget the
kerneldoc, and patching drivers/pinctrl/pinconf-generic.c.

I'll apply it right away.

>> Nothing else you want to say about the pins here?
>> (No big deal for sure, but....)
>
> when using pinconfig_generic, its dump_pin function should be more talkative
> right?

Yes, one of the things you get for free... soon also the pin config
DT parser will be for free I hope.

Yours,
Linus Walleij
