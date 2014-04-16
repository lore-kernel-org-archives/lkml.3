Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaDPS20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:28:26 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:52734 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbaDPS2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:28:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140415225210.GK12304@sirena.org.uk>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
	<1397592876-5741-4-git-send-email-dianders@chromium.org>
	<20140415225210.GK12304@sirena.org.uk>
Date: Wed, 16 Apr 2014 11:28:16 -0700
X-Google-Sender-Auth: 12VtJqe7AMrkRcAl1zdns6qnbEU
Message-ID: <CAD=FV=WtspeorCqJ_dTjZbhhMzUJ-+t6bWeh7pwmJd3VAJqEGQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] regulator: tps65090: Make FETs more reliable
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Tue, Apr 15, 2014 at 3:52 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Apr 15, 2014 at 01:14:36PM -0700, Doug Anderson wrote:
>
>> Mitigate the problem by:
>> * Allow setting the overcurrent wait time so devices with this problem
>>   can set it to the max.
>> * Add retry logic on enables of FETs.
>
> This is two changes, should really be two patches.

OK, sure.


>> +- ti,overcurrent-wait: This is applicable to FET registers, which have a
>> +  poorly defined "overcurrent wait" field.  If this property is present it
>> +  should be between 0 - 3.  If this property isn't present we won't touch the
>> +  "overcurrent wait" field and we'll leave it to the BIOS/EC to deal with.
>
> I take it this is the raw value to write to the register?

Yes.


>> +static int tps65090_fet_is_enabled(struct regulator_dev *rdev)
>> +{
>> +     unsigned int control;
>> +     unsigned int expected = rdev->desc->enable_mask | BIT(CTRL_PG_BIT);
>> +     int ret;
>> +
>> +     ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &control);
>> +     if (ret != 0)
>> +             return ret;
>> +
>> +     return (control & expected) == expected;
>> +}
>
> No need to open code this, regulator_is_enabled_regmap() can check for
> any value in a bitfield.

The overall problem was that we were checking a different bit than we
were setting.  We set "enabled" to turn things on and then we check
"power good".

I can avoid the open coding by doing something that's slightly a hack.
 I'll put that in V2 and you can tell me if you like it better.  I'll
set "enable_mask" and "enable_val" to include both bits.  The "power
good" is read only so it won't hurt to set it.  ...and it doesn't hurt
to check the enabled bit in addition to the power good bit.


>> +static int tps6090_try_enable_fet(struct regulator_dev *rdev)
>
> Why is this called tps6090_try_enable_fet(), looks like a missing 5?

typo.  fixed.

>
>> +     /*
>> +      * Try enabling multiple times until we succeed since sometimes the
>> +      * first try times out.
>> +      */
>> +     for (tries = 0; ; tries++) {
>> +             ret = tps6090_try_enable_fet(rdev);
>> +             if (!ret)
>> +                     break;
>> +             if (ret != -ENOTRECOVERABLE || tries == MAX_FET_ENABLE_TRIES)
>> +                     goto err;
>
> Make this a do { } while so we don't have the exit condition missing in
> the for loop please, it's doing the right thing but it's not as obvious
> as it could be.

It's not quite a "do { } while" since the break is in the middle, but
happy to change to a "while (true)".  Hope that's OK.

>
>> +     if (tries) {
>> +             dev_warn(&rdev->dev, "reg %#x enable ok after %d tries\n",
>> +                      rdev->desc->enable_reg, tries);
>> +     }
>
> No need for braces here, and I guess that ought to be retries rather
> than tries (though that is pedantry).

LOL.  I've been yelled at for the opposite.  ;)  There's at least
someone out there who thinks that we should have braces if you've got
a single statement like this that wraps to two lines, but I can't
remember who.

In any case, fixed.

-Doug
