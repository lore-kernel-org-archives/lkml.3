Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbaJ3Ac5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:32:57 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60953 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbaJ3Acz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:32:55 -0400
Message-ID: <5451872F.4050306@collabora.co.uk>
Date: Thu, 30 Oct 2014 01:32:47 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH v6 7/7] ARM: dts: add suspend voltage setting for RK808
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>	<1414583525-17395-8-git-send-email-zyw@rock-chips.com>	<CAD=FV=XeGj63_MEPL5i1ihUORuHnwD1ktEjJN5x=B-tkHV088w@mail.gmail.com>	<545115DF.9070008@collabora.co.uk> <CAD=FV=VtKdLH51tDvHsRfMYah9cUNcNRfbVJ1rfroxwsZZLTsA@mail.gmail.com>
In-Reply-To: <CAD=FV=VtKdLH51tDvHsRfMYah9cUNcNRfbVJ1rfroxwsZZLTsA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 10/29/2014 05:51 PM, Doug Anderson wrote:
>>
>> In other words, do you want the core to call rk808_set_suspend_voltage() or
>> rk808_set_suspend_enable()? If the later then you can use Chanwoo's bindings:
>>
>> regulator-state-mem {
>>    regulator-on-in-suspend;
>> };
> 
> The rk808 has a separate register for storing the sleep voltage,
> though.  ...so just using "regulator-on-in-suspend" without any
> changes to the rk808 driver won't get us this "for free".  I'd expect
> to need
> 
>  regulator-state-mem {
>     regulator-on-in-suspend;
>     regulator-suspend-microvolts = <3300000>;
>  };
>

I see, then as you said the voltage has to be defined in the DT for the suspend
state.

As I mentioned in my previous email, Chanwoo's original suspend state series had
a "regulator-volt" DT property that was used to fill the struct regulator_state
.uV field so the core could call the .set_suspend_voltage function handler.

AFAIU Mark wanted the property to be renamed to "rebulator-microvolt" [0] to be
consistent with the rest of the binding and also he was not sure if the suspend
voltage needed be in the runtime voltage range specified by the properties
"regulator-{min,max}-microvolt" since Chanwoo's patch had a check for that [1].

Chanwoo decided to drop setting the suspend voltage in a following version, but
given that there is a use case for this feature, I think that those two issues
could be addressed and added that property to the generic regulator DT binding.
 
> IMHO it wouldn't be insane to say that if someone has
> "regulator-on-in-suspend" but no suspend voltage defined that it
> should carry forward the runtime voltage.  I actually argued for that
> earlier and Mark Brown said "no" at
> <http://marc.info/?l=linux-kernel&m=141277262106368&w=2>.  More at
> <http://marc.info/?l=linux-kernel&m=141279245027919&w=2>.  It's
> entirely possible I wasn't making myself clear, though.
> 

What I learned from previous Mark's explanations is that there is always a
reason why the regulator API split different operations. So if there is both
a .set_voltage and .set_suspend_voltage, then that is an indication for me
that if someone wants a particular voltage during suspend then it has to be
explicitly set and should not rely on the runtime voltage previously set.

The fact that the rk808 has different registers to configure the runtime
and suspend voltage seems to confirm that the API split makes sense.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/9/4/652
[1]: https://lkml.org/lkml/2014/9/4/651
