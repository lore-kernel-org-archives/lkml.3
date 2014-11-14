Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaKNIhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:37:21 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:45883 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbaKNIhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:37:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=VLvoNw5pu5P_iny5a-3-f1XMqGwgQLBp4QmoAM6WPWAA@mail.gmail.com>
References: <1414529835-16207-1-git-send-email-dianders@chromium.org>
	<CACRpkdagHFAaPmQptsm7pz_JqYUCbU-0FoH45vrXo8pG6mTAxA@mail.gmail.com>
	<CAD=FV=VLvoNw5pu5P_iny5a-3-f1XMqGwgQLBp4QmoAM6WPWAA@mail.gmail.com>
Date: Fri, 14 Nov 2014 09:37:17 +0100
Message-ID: <CACRpkda3QZNoy0RYYYnmc4DY0mhDF0QxREyVi=c_diKnD5rwTQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] pinctrl: Add output-disable
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, Sherman Yin <syin@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 10:09 PM, Doug Anderson <dianders@chromium.org> wrote:
> On Fri, Oct 31, 2014 at 1:49 AM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> Figure out the exact electronic meaning of what happens when you do
>> "output disable" in your hardware, I think it is very likely that
>> PIN_CONFIG_BIAS_HIGH_IMPEDANCE is what you are really
>> after here.
>
> OK, that seems plausible.  ...so it is OK to set both
> "bias-high-impedance" _and_ "bias-pull-up" on a pin?  That seemed
> weird to me but if that's right I can do that and try to implement
> "bias-high-impedance" on Rockchip...

I don't quite get the question. What this patch does is add something
called "output disable" which I think is analogous to high impedance.

If you enable both as the same time something is likely wrong
because it doesn't make electronic sense, high impedance and
pull up are kind of mutually exclusive. High impedance is also
know as "tristate" and means the line will assume the level of
whatever it is connected to, not try to pull things up.

So either:

- This is the wrong terminology, "output disable" means something
  else. Like "disconnect the driver stages" or something, so pull-up
  can be enabled.

- Stuff has been programmed in a bad way all the time.

Understanding the hardware is paramount...

> Maybe better to explain the problem.  I have a pin that I wish to
> drive high weakly (using a pullup rather than actually pushing
> output-high to the pin).  The firmware has left the pin configured as
> an output with no pull.
>
> I can configure the pin like this:
>   rockchip,pins = <7 12 RK_FUNC_GPIO &pcfg_pull_up>;
>
>   pcfg_pull_up: pcfg-pull-up {
>     bias-pull-up;
>   };

This makes perfect sense.

> When I do this the current Rockchip pinctrl driver will _not_
> configure me as an input.  It will happily flip the "pullup" bit in
> hardware and leave the pin configured as an output.

You seem to imply that the pins registers work such that
input needs to be enabled for pull-up to work.

This is a hardware pecularity. Just enable input in the hardware
whenever pull-up is requested then, as that is how that hardware
has to work. If you want to be explicit there is always
PIN_CONFIG_INPUT_ENABLE (input-enable;)

> I could certainly reach into the GPIO controller part of things
> whenever I see "bias-pull-up" and configure the pin as an input.

I think you should. This is a side effect of combined hardware
and expected.

>  I
> guess that wouldn't actually hurt to do even if the pin wasn't
> configured as a GPIO...

This is why we have the callbacks:

pinctrl_request_gpio()
pinctrl_free_gpio()
pinctrl_gpio_direction_input()
pinctrl_gpio_direction_output()

By letting the GPIO driver side call these to set direction, we
can leave the control over direction status and incommensurable
states to the pin control driver.

Not that I have all things in my head, but if you're not using
the above calls in your GPIO driver, I suggest doing so and leaving
the pin direction status for the pinctrl side to handle.

> A third option that would work in my case (and actually be sorta
> clean) would be to implement a faux open-drain output.  The hardware
> itself doesn't have a concept of open drain (unlike some SoCs) but I
> could implement it by swapping between "input pulled up" and "output
> driven low".

Uhm. Not following this. Probably you are better at electronics than
I am.

Anyway, I think the answers above is what you actually need to
keep working on this.

Yours,
Linus Walleij
