Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbaJGNPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:15:25 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39584 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJGNPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Xq5XtskHW8B2QcpSSh3apK9a+eBCg07cfPL3tFqXntWA@mail.gmail.com>
References: <1411514246-6163-1-git-send-email-dianders@chromium.org>
	<CACRpkdbQ_21BcaK9T8aTHoDdXQpb-6KKZwcJzJJdBK0ztcG=ww@mail.gmail.com>
	<CAD=FV=Xq5XtskHW8B2QcpSSh3apK9a+eBCg07cfPL3tFqXntWA@mail.gmail.com>
Date: Tue, 7 Oct 2014 15:15:23 +0200
Message-ID: <CACRpkdbi4iDwAF674vm+yogv0ocXV+Pv6tq06i5YSgsJMv_PAg@mail.gmail.com>
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

On Thu, Sep 25, 2014 at 10:26 PM, Doug Anderson <dianders@chromium.org> wrote:
> On Thu, Sep 25, 2014 at 12:31 AM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
>> On Wed, Sep 24, 2014 at 1:17 AM, Doug Anderson <dianders@chromium.org> wrote:

>> The device core will handle three states for you: "default", "sleep", "idle".
>
> Except it will handle only one state unless "CONFIG_PM" is defined,
> right?  In other words "sleep" and "idle" totally don't exist in the
> "!CONFIG_PM" case.

Yes. Because the intent of these settings is usually to save power.
So by disabling the PM config, you can test if the system works
without PM. Even hairy stuff like power-related pin control. It has
this nice orthogonal debug feature to it...

> Normally it should be considered "safe" (though high power)
> to disable CONFIG_PM, right?

Yeah. If your usecase makes it unsafe to have just "default",
you should not rely on these state names but invent new ones.

>> What I worry about in this patch is that you redefine the meaning
>> of "default" from what it used to be into "sleep", basically, that
>> you want the device to come up in a relaxed mode, whereas
>> the "default" state is usually defined as "ready to go", i.e. what
>> you refer to as "active".
>
> Yeah, I didn't like that either.  That's mostly why I put the RFC and
> "I'm gonna get yelled at" comment.  ;)
>
> Hrm, I wonder if another reasonable option is to add a boolean
> property somewhere saying that "pinctrl starts idle" would fix things
> for me.

That's a pretty good idea actually.

It has to be part of the state defintion and also the device tree
bindings then I guess?

Something in <linux/pinctrl/machine.h> needs patching.

>> Inspecting the helper code in drivers/base/pinctrl.c you will find
>> that if the "default" state is defined it will be retrieved and
>> activated on boot, so you don't have to do this yourself. Then
>> if "sleep" and "idle" exist, these will be grabbed and made
>> accessible using special helper functions.
>
> How I deal with this would depend on whether I require CONFIG_PM.
> What do you think?

No I don't have everything in my head, it depends on whether
you can live with the device being in the "default" state if
CONFIG_PM is disabled.

You could always have the driver do this in Kconfig:

depends on PM

but I don't know if that is desireable.

>> I realize that this means that you will end up with a transient
>> state where the pins are in "default" mode before probe
>> commence. If this is a big problem, yeah, then you have to
>> go for custom states.
>
> In this case I think it could be a big problem.  When you're just
> talking about a PWM backlight then it doesn't matter much, but I don't
> like the idea of letting a regulator glitch to a random voltage during
> probe.

OK something like tagging the device to go to "sleep"
when probing would work.

> What do you think about the "default to idle" boolean, then (and
> corresponding device tree property)?  It would be a pretty small patch
> to pinctrl_bind_pins(), I think.  I could make sure that "idle" is
> defined even if no CONFIG_PM...

Yeah I sort of like this idea.

Like you could override what is the actual preferred
probe state.

I would like something like that:

        /* For a client device requiring named states */
        device {
                pinctrl-names = "default", "sleep";
                pinctrl-0 = <&state_0_node_a>;
                pinctrl-1 = <&state_1_node_a &state_1_node_b>;
                pinctrl-probe-state = "sleep";
        };



Then patch the code in drivers/base/pinctrl.c to respect
this if DT is used and this is present, else just use "default".

Note that since it's just a string, you can specify any state
here.

Yours,
Linus Walleij
