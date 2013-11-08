Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3KHAbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:31:08 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2158 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab3KHAbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:31:06 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <527C3080.5050202@broadcom.com>
Date: Thu, 7 Nov 2013 16:29:52 -0800
From: "Sherman Yin" <syin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-Version: 1.0
To: "Linus Walleij" <linus.walleij@linaro.org>
cc: "Stephen Warren" <swarren@wwwdotorg.org>,
        "=?ISO-8859-1?Q?Heiko_St=FCb?= =?ISO-8859-1?Q?ner?=" 
	<heiko@sntech.de>,
        "Laxman Dewangan" <ldewangan@nvidia.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Christian Daudt" <bcm@fixthebug.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "Rob Landley" <rob@landley.net>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
 <051069C10411E24D9749790C498526FA1BE0B7D7@SJEXCHMB12.corp.ad.broadcom.com>
 <CACRpkdYSLxp2M4HghcUdjEYGh-UQ+DaiCGp6yee+Qds6DR9poA@mail.gmail.com>
 <201311050026.56321.heiko@sntech.de> <527835FE.2030102@wwwdotorg.org>
 <5279A319.5060701@broadcom.com>
 <CACRpkdaxPv6CLMjab_4umyUvbBVYcazjmwx_LGRK76vxT4VUqA@mail.gmail.com>
In-Reply-To: <CACRpkdaxPv6CLMjab_4umyUvbBVYcazjmwx_LGRK76vxT4VUqA@mail.gmail.com>
X-WSS-ID: 7E62EF2E4RS6005700-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-11-06 01:40 AM, Linus Walleij wrote:
> On Wed, Nov 6, 2013 at 3:02 AM, Sherman Yin <syin@broadcom.com> wrote:
>> When Linus asked me to try using generic pinconf instead, I ran into
>> problems with this feature due to how the generic pinconf properties are
>> defined differently than my properties - perhaps this feature just doesn't
>> work for generic pinconf-based drivers with the (Unless we are ok with using
>> 1/0 for boolean properties, but it has already been pointed out that these
>> should be valueless.).
>
> Well it seems you would need a way to pass an array of the same
> boolean property and that seems a bit more complex and hard to
> read than the generic boolean bindings.
>
> You would have to patch the OF core to do something like that:
>
> bias-pull-up = <true true false>;
>
> 1/0 isn't so good I think, what should the parser do with e.g. 2?
> This is more to the point.

I would imagine that the platform-specific device tree bindings would 
need to clearly explain what the valid values are, as they should.  If 
we're using integers, we could either have a) !0 and 0, or b) just 1 and 
0, and everything else is an error.  Or c) the platform could decide 
that the value provides addition info like pull-up-strength, so 0 = no 
pull up, >0 = pull up enabled and the number is the pull up strength in 
Ohm (bindings should indicate which values are valid), and everything 
else is an error.

>> While I'd love to be able define my pin config nodes this way, if I have to
>> use generic pinconf for the driver to be upstreamed, then I'm fine with it.
>
> Well you need to use generic pin config because all the custom
> stuff - i.MX comes to mind - is creating a mess. I prefer that we
> share bindings and code, as any programmer would...

Ok

> That said, if you can patch the OF core and the generic pin config
> parser to do what you want with lists like that, it's your pick.
> It may take some time though.

I don't mind patching the generic pin config, and I don't think the core 
needs to change, but first there needs to be an agreement on the changes 
since other drivers will need to use pinconf-generic. Am I the only one 
who would like to see this feature, or do others see value in being able 
to group more pins together - resulting in fewer sub-nodes?  Do the pros 
out-weight the cons?

>>> "input disable"
>>> This setting disconnects the input (DIN) to the internal logic from >the
>>> pin pad. However, the output (DOUT) can still drive the pad.  It
>>> seems to match PIN_CONFIG_OUTPUT, but the current generic option is
>>> either "output-low" or "output-high" - are these referring to a static
>>> output of 0 and 1?
>>
>> What's the best property to use in this case?
>
> Seems like a new case.
>
> What about you patch include/linux/pinctrl/pinconf-generic.h
> to add PIN_CONFIG_INPUT_DISABLE with this semantic
> and also patch the generic pinconf parser in drivers/pinctrl/pinconf-generic.c
> to handle this?

Sure, I can add PIN_CONFIG_INPUT_DISABLE.  However I suspect people 
might be confused by this and PIN_CONFIG_OUTPUT.

>>> "mode"
>>> This controls several aspect of the pin (slew rate, pull up strength,
>>> etc) to meet I2C specs for Standard/Fast mode vs High Speed mode.  I
>>> think the best way is to map this to slew rate, which would require
>>> some explanation because the meaning of slew rate differs depending on
>>> what pin function is selected:
>>> - When I2C (*_SCL or *_SDA) function is selected for the pin: 0:
>>>   Standard (100kbps)
>>>   & Fast mode (400kbps), 1: High Speed mode (3.4Mbps)
>>> - When IC_DM or IC_DP function is selected, 0: normal slew rate, 1:
>>>   fast slew rate
>>> - Else: 0: fast slew rate, 1: normal slew rate
>>
>> Do we agree that the "slew rate" is the best property to use for "mode"?
>
> It seems to be indeed mostly related to slew rate.
>
> However if you want a custom brcm,mode binding that should
> be possible too, as well as augmenting the driver to use
> *both* generic pinconf *and* some custom config options
> on top. That has not been done so far though I think, so you
> might need a bit of hacking to do that.

I think I'll stick with slew rate.  :)

Regards,
Sherman


