Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbaJ2W0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:26:25 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:56980 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbaJ2W0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:26:22 -0400
MIME-Version: 1.0
In-Reply-To: <2524690.yVcDsnFz2O@diego>
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
	<7hppda7iaa.fsf@deeprootsystems.com>
	<2524690.yVcDsnFz2O@diego>
Date: Wed, 29 Oct 2014 15:26:21 -0700
X-Google-Sender-Auth: KHTFLdT6m6gCBncVTP_YuYEh854
Message-ID: <CAD=FV=U-HesWSHdtiNq=5KquuBUR5_EBrL=rfZsAZEn+uuU5gw@mail.gmail.com>
Subject: Re: [PATCH v6 0/7] This is the 1st version of suspend for RK3288.
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Kevin Hilman <khilman@kernel.org>, Chris Zhong <zyw@rock-chips.com>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-gpio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tony Xie <xxx@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Wed, Oct 29, 2014 at 2:50 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Mittwoch, 29. Oktober 2014, 13:06:05 schrieb Kevin Hilman:
>> Hi Chris,
>>
>> Chris Zhong <zyw@rock-chips.com> writes:
>> > RK3288 can shut down the cpu, gpu and other device controllers in suspend,
>> > and it will pull the GLOBAL_PWROFF pin to high in the final stage of the
>> > process of suspend, pull the pin to low again when resume.
>>
>> I tried to test this on top of linux-next (next-20141029) and it doesn't
>> wake up from serial port activity.
>>
>> Can you describe how to test this, as well as describe dependencies on
>> other out-of-tree patches, including pointers to where they've been
>> posted.
>>
>> Also, please describe how you tested this and on which hardware
>> platforms.  It's a big help to reviewers to know how it's been tested,
>> and for anyone with similar hardware to know what else it's been tested
>> on.
>
> When testing this series it did go to sleep with
>
> / # echo mem > /sys/power/state
> PM: Syncing filesystems ... done.
> Freezing user space processes ... (elapsed 0.010 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.010 seconds) done.
> PM: suspend of devices complete after 0.001 msecs
> PM: late suspend of devices complete after 0.001 msecs
> PM: noirq suspend of devices complete after 0.001 msecs
> Disabling non-boot CPUs ...
> CPU1: shutdown
> CPU2: shutdown
> CPU3: shutdown
>
> and the change in pmic-noise lets me assume it's really asleep.
>
>
> But I'm not exactly sure how to wake it up again. I even hard-wired the gpio-
> keys to always enable the irq wake, but so far it didn't wake again when
> pressing the power-key on the evb.
>
> If anyone wants to peek, the collected patches (Doug's and Chris') can be
> found on [0].

Unless you get a device tree that sets up regulator states I think
you're going to be SOL.  In other words one thing that will definitely
bite you is (7592100 ARM: dts: add suspend voltage setting for RK808).

That's referencing the "global_pwroff" which means we'll be telling
the PMIC when we suspend.  That's good but the PMIC hasn't been
programmed with any reasonable voltages because all the device tree
properties are ignored.  That's not good.  You can see my comments
about this at <https://patchwork.kernel.org/patch/5186951/>

Also: I think that I remember the GPU being pretty unhappy if you
turned its voltage off but didn't gate its power domain.  At the
moment I've got all the power domain patches sitting in my tree plus
<https://chromium-review.googlesource.com/#/c/223464/>.  You might
also just be able to change the GPU not to be powered off in suspend
(but then you need to program a good voltage to it).


At the moment all of my testing is happening in the chromeos-3.14 tree
(which has a ton of backports and thus isn't that different than
mainline as far as Rockchip is concerned).  You could theoretically
try jamming Chris's stuff into the top of the chromeos-3.14 tree and
see what happens on EVB.  I may be able to give that a shot
tomorrow...

-Doug
