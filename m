Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaHTSyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:54:46 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:37724 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaHTSyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:54:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140820100447.GG15414@ulmo>
References: <1408464476-28316-1-git-send-email-dianders@chromium.org>
	<1408464476-28316-3-git-send-email-dianders@chromium.org>
	<20140820100447.GG15414@ulmo>
Date: Wed, 20 Aug 2014 11:54:11 -0700
X-Google-Sender-Auth: 0BO1QxjZqNIneJ4aekk7lOUXSUk
Message-ID: <CAD=FV=U9gOiY=4s7WmAQcm0n9s67nWdqQ3A0L2B7Dg83dNotjQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] pwm: rockchip: Allow polarity invert on rk3288
From: Doug Anderson <dianders@chromium.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-pwm <linux-pwm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry,

On Wed, Aug 20, 2014 at 3:04 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Tue, Aug 19, 2014 at 09:07:54AM -0700, Doug Anderson wrote:
>> The rk3288 has the ability to invert the polarity of the PWM.  Let's
>> enable that ability.
>>
>> To do this we increase the number of pwm_cells to 3 to allow using the
>> PWM_POLARITY_INVERTED flag.  Since the PWM driver on rk3288 is very
>> new, I thought this was OK.
>
> I don't see any files in arch/arm/boot/dts using either of the
> rockchip,vop-pwm or rockchip,rk3288-pwm compatible strings, so there's
> no reason to consider this stable ABI yet. As far as I'm concerned the
> last sentence can just as well be dropped.
>
> Besides, patches have been posted to support #pwm-cells = <2> and
> #pwm-cells = <3> at the same time which should give you backwards-
> compatibility for free.

Done.  I'm happy that the subsystem is being improved to handle
pwm-cells more dynamically, too!  That's a nice improvement.


> A couple more comments inline.
>
>> diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
> [...]
>> +int rockchip_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
>> +                           enum pwm_polarity polarity)
>
> This should be static.

Done.


>> +{
>> +     struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
>> +
>> +     if (!pc->data->has_invert)
>> +             return -ENOSYS;
>> +
>> +     /*
>> +      * No action needed here because pwm->polarity will be set by the core
>> +      * and the core will only change polarity when the PWM is not enabled.
>> +      * We'll handle things in set_enable().
>> +      */
>> +
>> +     return 0;
>> +}
>
> An alternative here would be to provide a separate pwm_ops with
> .set_polarity = NULL for the versions of the IP block that don't support
> polarity inversion yet, but this works for me too.

Good point.  I'll make the change since it paves the way for other
pwm_ops that are different.


>> @@ -173,6 +201,7 @@ static const struct rockchip_pwm_data pwm_data_v2 = {
>>               .ctrl = 0x0c,
>>       },
>>       .prescaler = 1,
>> +     .has_invert = true,
>>       .set_enable = rockchip_pwm_set_enable_v2,
>>  };
>>
>> @@ -184,6 +213,7 @@ static const struct rockchip_pwm_data pwm_data_vop = {
>>               .ctrl = 0x00,
>>       },
>>       .prescaler = 1,
>> +     .has_invert = true,
>>       .set_enable = rockchip_pwm_set_enable_v2,
>>  };
>
> Can you please add a '.has_invert = false,' line to pwm_data_v1? I know
> it's not strictly necessary but I like it when things are explicitly
> stated.

No longer relevant with different pwm_ops.


>> @@ -230,6 +260,10 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
>>       pc->chip.ops = &rockchip_pwm_ops;
>>       pc->chip.base = -1;
>>       pc->chip.npwm = 1;
>> +     if (pc->data->has_invert) {
>
> There should be a blank line between the above two.

Done.
