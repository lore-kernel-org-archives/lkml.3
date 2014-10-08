Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbaJHQND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:13:03 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:45367 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaJHQNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:13:00 -0400
MIME-Version: 1.0
In-Reply-To: <20141008124935.GA24947@sirena.org.uk>
References: <1412671438-25399-1-git-send-email-zyw@rock-chips.com>
	<CAD=FV=W_6_JSn5ZWEG7YBDw5xf+tGReSB-WCV798gBqXyhikgg@mail.gmail.com>
	<20141008124935.GA24947@sirena.org.uk>
Date: Wed, 8 Oct 2014 09:12:59 -0700
X-Google-Sender-Auth: 0bIcTIoS_Ex2m9mH2nRtQyIQO8Y
Message-ID: <CAD=FV=U5ng8egj4b5Mz1gwFpJPFxJmnSzhT0iRtOj=7VxFTbSA@mail.gmail.com>
Subject: Re: [PATCH] regulator: rk808: Add support setting suspend voltage
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Wed, Oct 8, 2014 at 5:49 AM, Mark Brown <broonie@kernel.org> wrote:
>> One point of curiosity (maybe this is a question for Chanwoo and
>> Javier): I'd expect that if someone didn't explicitly setup a "suspend
>> voltage" that their voltage would just be left alone at suspend time.
>
> No, this is not the case.  The suspend mode settings are a completely
> different set of settings activated when the system goes into suspend
> with explicit hardware support.  If no configuration for this mode is
> provided then

I think maybe you missed finishing your sentence?


>> I believe that won't be the case for your driver.  The rk808 will (I
>> think) automatically transition to the "suspend voltage" settings for
>> ALL regulators at suspend time.  If you didn't explicitly set the
>> suspend voltage then you'll move to whatever the default voltage is,
>> right?
>
> As ever the hardware configuration won't be touched by the kernel unless
> it's explicitly told to do something.

I guess my point is that the kernel's inaction is actually causing
something unexpected to happen.  Robots can't let humans come to harm
by inaction any more than they can harm them by action.

Specifically I would expect that voltages would stay constant when the
rk808 "sleep" pin is asserted if I didn't explicitly say to disable
this regulator at sleep time and I didn't explicitly specify a voltage
at sleep time.  As Chris's patch stands right now this isn't the case.

To make it concrete, imagine that no "sleep voltage" was specified for
DCDC4 and it's setup to stay enabled during sleep.  Let's say that a
kernel driver makes a decision at runtime time to set this to 1.8V or
1.9V.

When the kernel driver sets it to 1.9V, it will go through
regulator_set_voltage_sel_regmap() which will set the BUCK4_ON_VSEL
register and we'll be at 1.9V.  Great, we're at 1.9V.  Now we're ready
to go to sleep.  I'd expect that the voltage would stay at 1.9V, but
it won't.  BUCK4_SLP_VSEL was never programmed so it's at whatever the
default is (1.8V) and we will transition there.

The above is a fictitious example since really we don't vary BUCK4 at
runtime in our system.  ...and really my concern only matters for
regulators that vary at runtime, so maybe we can ignore my comments.
To me, it does seem unexpected, though.

-Doug
