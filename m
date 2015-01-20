Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbbATTRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:17:11 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:21066 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbbATTRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:17:06 -0500
X-IronPort-AV: E=Sophos;i="5.09,435,1418112000"; 
   d="scan'208";a="55196921"
Message-ID: <54BEA9AF.7070209@broadcom.com>
Date: Tue, 20 Jan 2015 11:17:03 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Alexandre Courbot" <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Christian Daudt" <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>, Scott Branden <sbranden@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 2/3] gpio: Cygnus: add GPIO driver
References: <rjui@broadcom.com>	<1418696307-19392-1-git-send-email-rjui@broadcom.com>	<1418696307-19392-3-git-send-email-rjui@broadcom.com>	<CACRpkdYGksEseGaO49=1rUi5WBdOxwAd-F1gpgZn+BFatRCdDg@mail.gmail.com>	<54B55068.8050500@broadcom.com>	<CACRpkdZef8S-EAbShjJ1eg+-3wQKn+yx4u1k_Mf8F7uFkJYdFw@mail.gmail.com>	<54B9A8A2.6090209@broadcom.com> <CACRpkdYydCO9Wu3fMyh0qt=e_hxT5ch2gqNhEsfQpf5WYUS-kQ@mail.gmail.com>
In-Reply-To: <CACRpkdYydCO9Wu3fMyh0qt=e_hxT5ch2gqNhEsfQpf5WYUS-kQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/20/2015 1:53 AM, Linus Walleij wrote:
> On Sat, Jan 17, 2015 at 1:11 AM, Ray Jui <rjui@broadcom.com> wrote:
>> On 1/16/2015 2:14 AM, Linus Walleij wrote:
> 
>>> Some hardware designs put the software-controlled biasing
>>> resistors in the GPIO block electronically connected to the actual
>>> pins, so that e.g. the biasing will be available if some MMC or
>>> whatever is using the same pins in another muxing. In such
>>> situations it's quite evident that they need to be a combined
>>> GPIO and pin controller.
>>>
>>> I have some regrets that bolting a second pin controller to the
>>> GPIO chip make things a bit complex but it's a price we have
>>> to pay for getting some kind of generic interface.
>>
>> Okay. In summary, I think both of us think the following approach makes
>> sense in my situation:
>> - leave pinmux in pinctrl-bcm-cygnus.c
>> - leave pinctrl + gpio in pinctrl-bcm-cygnus-gpio.c under drivers/pinctrl/*
>>
>> But by thinking about this more, I thought this would create duplicated
>> pinctrl descriptors in our system, one from the pinmux driver, and the
>> other from this pinctrl+gpio driver. That is probably undesirable?
> 
> No, there are several systems with multiple pin controllers and the
> framework easily handles multiple pin controllers in the same
> system just as well as we handle multiple GPIO chips.
> 
>> By reviewing various drivers in the pinctrl directory, I found what
>> pinctrl-u300.c and pinctrl-coh901.c does seems to serve as a good model
>> for me to follow:
>> - pinctrl-u300.c is the pinmux driver
>> - pinctrl-coh901.c is the gpio+pinctrl driver
> 
> Yeah, I don't know if the separation between them is as beautiful
> as it should be. I used it when developing the pin control
> subsystem.
> 
>> The GPIO pinctrl logic is in the coh901 block, so pinctrl-coh901.c
>> exposed two public functions u300_gpio_config_get, u300_gpio_config_set
>> that pinctrl-u300.c can use. The u300 populates all pinmux/pinctrl
>> related functions into the subsystem. This way there's only one pinctrl
>> descriptor, populated through pinctrl-u300.c.
>>
>> Does that model make more sense to you?
> 
> Yeah I wrote it myself so I'm maybe blind for any dumbness in
> the code. But I think it's kind of elegant. But it is not using the
> generic pinctrl device tree bindings so it's kind of oldstyle and
> bloated in that sense.
> 
> Yours,
> Linus Walleij
> 
Okay. I think I have a pretty good idea of what you expect. Regarding
whether or not to keep pinctrl-bcm-cygnus.c and
pinctrl-bcm-cygnus-gpio.c completely independent with each other and
therefore have two pinctrl in the system, I'll play with it a bit more
and make a decision.

Thanks a lot for spending all these time explaining it to me. Really
appreciate it!
