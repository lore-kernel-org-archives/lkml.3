Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaIYHb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:31:59 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:40139 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaIYHb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:31:56 -0400
MIME-Version: 1.0
In-Reply-To: <1411514246-6163-1-git-send-email-dianders@chromium.org>
References: <1411514246-6163-1-git-send-email-dianders@chromium.org>
Date: Thu, 25 Sep 2014 09:31:55 +0200
Message-ID: <CACRpkdbQ_21BcaK9T8aTHoDdXQpb-6KKZwcJzJJdBK0ztcG=ww@mail.gmail.com>
Subject: Re: [RFC PATCH] pwm: Add the concept of an "active" pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Chris Zhong <zyw@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 1:17 AM, Doug Anderson <dianders@chromium.org> wrote:

> There are cases where you really don't want a PWM's pinctrl to take
> effect until you know that the PWM is driving at the proper rate.  A
> good example of this is a PWM-controlled regulator, where the boot
> state of the pin (maybe a pulled down input) could cause a vastly
> different voltage to take effect than having the pin setup as a PWM
> but not having the PWM enabled yet.
>
> Let's add a feature where you can define an "active" pinctrl state.
> This state (if it exists) will be applied after the PWM has actually
> been enabled.  If the PWM is ever disabled we'll go back to "default"
> state.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> I'm sure Linus W or Thierry or Mark will tell me this is an idiotic
> idea (or totally the wrong way to do it), but I figured I'd float it
> out there and maybe someone can tell me something better to do.  ;)

Hey it's not like this is obvious or anything....

The device core will handle three states for you: "default", "sleep", "idle".

What I worry about in this patch is that you redefine the meaning
of "default" from what it used to be into "sleep", basically, that
you want the device to come up in a relaxed mode, whereas
the "default" state is usually defined as "ready to go", i.e. what
you refer to as "active".

If you choose this approach, it is better to not define the "default"
state *at all*, just define "active" and "sleep" and/or "idle".
(The difference between the two latter is basically the same
semantic as suspend vs runtime suspend.)

We have some helpers in the device core to help getting
things right.

Inspecting the helper code in drivers/base/pinctrl.c you will find
that if the "default" state is defined it will be retrieved and
activated on boot, so you don't have to do this yourself. Then
if "sleep" and "idle" exist, these will be grabbed and made
accessible using special helper functions.

I would actually prefer, if it is not causing any trouble, to have
the same semantics as the core expects, then have the driver
do something like this in probe():

probe():
   pinctrl_pm_select_sleep_state(dev);

This means the device will be pushed to "default" before
it's probed, then set to sleep quickly after that. It requires that
CONFIG_PM is enabled for the platform, too. (As you can see
in drivers/base/pinctrl.c)

Then when you want it back into "active", i.e. "default" mode
use the pinctrl_pm_select_default_state(dev);

I realize that this means that you will end up with a transient
state where the pins are in "default" mode before probe
commence. If this is a big problem, yeah, then you have to
go for custom states. But then the "default" state should not
be defined at all, instead call them something unique like
"active" and "relaxed" or so, so you don't overrun states already
used by the pinctrl core. Then all confusion is gone.

The "default" state was added with the assumption that most
drivers want their pins to be in "ready to go" mode by default.

Yours,
Linus Walleij
