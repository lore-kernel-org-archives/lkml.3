Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934444AbaJ2Q33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:29:29 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60442 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933459AbaJ2Q32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:29:28 -0400
Message-ID: <545115DF.9070008@collabora.co.uk>
Date: Wed, 29 Oct 2014 17:29:19 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Chris Zhong <zyw@rock-chips.com>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 7/7] ARM: dts: add suspend voltage setting for RK808
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>	<1414583525-17395-8-git-send-email-zyw@rock-chips.com> <CAD=FV=XeGj63_MEPL5i1ihUORuHnwD1ktEjJN5x=B-tkHV088w@mail.gmail.com>
In-Reply-To: <CAD=FV=XeGj63_MEPL5i1ihUORuHnwD1ktEjJN5x=B-tkHV088w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris,

On 10/29/2014 04:40 PM, Doug Anderson wrote:
>>                                 regulator-min-microvolt = <750000>;
>>                                 regulator-max-microvolt = <1300000>;
>>                                 regulator-name = "vdd_arm";
>> +                               regulator-suspend-mem-disabled;
> 
> NAK.  "regulator-suspend-mem-disabled" is a local property added by
> local Chrome OS patches and doesn't belong in an upstream submission.
> 
> You should using the new patches from Chanwoo.
> 
> 40e20d6 regulator: of: Add support for parsing regulator_state for suspend state
> 291d761 regulator: Document binding for regulator suspend state for PM state
> 
> In your case, it would look like:
> 
> regulator-state-mem {
>   regulator-off-in-suspend;
> };

Agreed.

> 
>> @@ -76,6 +80,7 @@
>>                                 regulator-min-microvolt = <3300000>;
>>                                 regulator-max-microvolt = <3300000>;
>>                                 regulator-name = "vccio_pmu";
>> +                               regulator-suspend-mem-microvolt = <3300000>;
> 
> Similarly this property isn't upstream.  You can see Javier's work on
> this in <https://patchwork.kernel.org/patch/5106351/> and I think
> you'll need an rk808-specific patch just like he needs an max77802
> patch.  You probably want to wait for him to spin it first, though,
> since Mark had feedback on his last patch.
>

I'm working on adding support to configure the regulator mode on startup
and when the system enters in a suspend state.

As Doug said I've to re-spin since Mark wanted things to be more integrated
with the core. So I'm doing some refactoring to pass the static regulator
descriptor to the function extracting the regulator initial data so drivers
should only define a function handler that does the modes translation.
I believe this is the more sensible place to add the mapping function since
the modes translation should be a non-varying property of the regulator.
 
Having said that, I see a different use case here. You want to set a voltage
on system suspend. But the value is the same that is set to your fixed
regulator so I wonder if what you want here is to enable the regulator on
suspend instead?

In other words, do you want the core to call rk808_set_suspend_voltage() or
rk808_set_suspend_enable()? If the later then you can use Chanwoo's bindings:

regulator-state-mem {
   regulator-on-in-suspend;
};

If you want the former then you should look at Chanwoo's previous series that
had support to define the voltage for regulators during a suspend state [0]

Mark had some questions about how that should play with the regulator voltage
range [1] but was not against the idea AFAIU.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/8/18/22
[1]: https://lkml.org/lkml/2014/9/4/651
