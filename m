Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbbABSlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:41:16 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:38835 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbbABSlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:41:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141229172555.GE17800@sirena.org.uk>
References: <1418612879-16094-1-git-send-email-zyw@rock-chips.com>
	<1418612879-16094-3-git-send-email-zyw@rock-chips.com>
	<20141229172555.GE17800@sirena.org.uk>
Date: Fri, 2 Jan 2015 10:41:13 -0800
X-Google-Sender-Auth: wgZZ3qwE1JbcrtPu6inszoFLM40
Message-ID: <CAD=FV=VUp2xvH28g77PTC5x7__+kiiz5VRWxwmSr7V9XV_paRg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] regulator: rk808: add dvs support
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Mon, Dec 29, 2014 at 9:25 AM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Dec 15, 2014 at 11:07:58AM +0800, Chris Zhong wrote:
>
>> +     sel <<= ffs(rdev->desc->vsel_mask) - 1;
>> +     sel |= old_sel & ~rdev->desc->vsel_mask;
>> +
>> +     ret = regmap_write(rdev->regmap, reg, sel);
>> +     if (ret)
>> +             return ret;
>> +
>> +     gpiod_set_value(gpio, !gpio_level);
>
> So, this seems a bit odd.  What we appear to be doing here is
> alternating between the two different voltage setting registers which is
> all well and good but makes me wonder why we're bothering - it's a bit
> more work than just sticking with one.  We do get...

It's odd, but the rk808 is odd.

Specifically if you don't use the "DVFS" pins like this then the
hardware ignores the ramp rate that's programmed into it.  When I
submitted (8af2522 regulator: rk808: Add function for ramp delay for
buck1/buck2) upstream I verified my change by looking at the register
values that were being set (ran i2cget in userspace).  I didn't
measure the waveforms myself.  Later, Chris found that my change was
not doing anything at all because the ramp delay has no effect if you
are setting the voltage using an i2c write--it only has an effect if
you're setting the voltage using DVFS pins.

If you write the voltage directly using an i2c write the rk808 will
ramp as fast as it possibly can, which will probably lead to an
overshoot.  You could fix this by changing the voltage more slowly in
software, but it seems better to use the DVFS pin if we have it...


>> +     /*
>> +      * dvsok pin would be pull down when dvs1/2 pin changed, and
>> +      * it would be pull up once the voltage regulate complete.
>> +      * No need to wait dvsok signal when voltage falling.
>> +      */
>
> ...this but unless the voltage typically ramps much faster than spec
> it's never clear to me that we're actually winning by polling the pin
> instead of just dead reckoning the time, it's more work for the CPU to
> poll the GPIO than to sleep after all.

Possibly even fewer CPU cycles: we could configure this GPIO as an
interrupt.  Then we can look for the rising edge in hardware.  ...you
might need to make sure that the pin actually falls and goes back up,
though.  If you changed between two voltages that were pretty close to
begin with I wonder if the edge could be missed.  I guess you could
make it high-level sensitive and put the 1us delay before unmasking
it...


> One thing we can do with hardware like this is to program in a voltage
> we're likely to want to switch to quickly and then use the GPIO to get
> there.  That can be a bit hard to arrange with the regulator API as it
> currently stands since we don't exactly have an interface for it.
>
> We can just check to see what the two values are current set to before
> switching and skip the register write if it's the same (making things
> faster since we're typically avoiding an I2C or SPI transaction by doing
> that) but that's a bit meh.  We can also try to do things like keep the
> top voltage from the voltage ranges we're being given programmed which
> for DVS typically ends up doing a reasonable job since governors often
> like to jump straight to top speed when things get busy so that's one of
> the common cases where we most want to change voltages as quickly as
> possible.

You're right that there could be some cool optimizations here, but
since we really need to do a switch from A-to-B on every voltage
change to get the ramp speed right then I don't think we can do them.

Note that the MFD driver sets things up using regcache, so we
shouldn't ever do a needless i2c transaction.

-Doug
