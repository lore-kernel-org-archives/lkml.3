Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaJHJAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:00:17 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:39876 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaJHJAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:00:12 -0400
MIME-Version: 1.0
In-Reply-To: <1412713696-13343-1-git-send-email-dianders@chromium.org>
References: <1412713696-13343-1-git-send-email-dianders@chromium.org>
Date: Wed, 8 Oct 2014 11:00:11 +0200
Message-ID: <CACRpkda2O+LWQovekrxNDa27O7OK4GRRz6ugA=Yzh4qZ3JSc7Q@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers/pinctrl: Add the concept of an "init" state
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Chris Zhong <zyw@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 10:28 PM, Doug Anderson <dianders@chromium.org> wrote:

> For pinctrl the "default" state is applied to pins before the driver's
> probe function is called.  This is normally a sensible thing to do,
> but in some cases can cause problems.  That's because the pins will
> change state before the driver is given a chance to program how those
> pins should behave.
>
> As an example you might have a regulator that is controlled by a PWM
> (output high = high voltage, output low = low voltage).  The firmware
> might leave this pin as driven high.  If we allow the driver core to
> reconfigure this pin as a PWM pin before the PWM's probe function runs
> then you might end up running at too low of a voltage while we probe.
>
> Let's introudce a new "init" state.  If this is defined we'll set
> pinctrl to this state before probe and then "default" after probe
> (unless the driver explicitly changed states already).
>
> An alternative idea that was thought of was to use the pre-existing
> "sleep" or "idle" states and add a boolean property that we should
> start in that mode.  This was not done because the "init" state is
> needed for correctness and those other states are only present (and
> only transitioned in to and out of) when (optional) power management
> is enabled.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

I *like* this approach. A lot.

It will come with DT bindings for free as it's just strings.

> +++ b/drivers/base/dd.c
> @@ -308,6 +308,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>                         goto probe_failed;
>         }
>
> +       pinctrl_init_done(dev);

We will need Greg's ACK for this oneliner.

> +/**
> + * pinctrl_init_done() - tell pinctrl probe is done
> + * @dev: device to that's done probing
> + */
> +int pinctrl_init_done(struct device *dev)
> +{
> +       struct dev_pin_info *pins = dev->pins;
> +       int ret;
> +
> +       if (!pins)
> +               return 0;
> +

Add a comment here that this will switch the pins from
"init" to "default" state unless the driver selected some
other state.


> +       if (IS_ERR(pins->init_state))
> +               return 0; /* No such state */
> +
> +       if (pins->p->state != pins->init_state)
> +               return 0; /* Not at init anyway */
> +
> +       if (IS_ERR(pins->default_state))
> +               return 0; /* No default state */
> +
> +       ret = pinctrl_select_state(pins->p, pins->default_state);
> +       if (ret)
> +               dev_err(dev, "failed to activate default pinctrl state\n");
> +
> +       return ret;
> +}
(...)
> +++ b/include/linux/pinctrl/devinfo.h
> @@ -24,10 +24,14 @@
>   * struct dev_pin_info - pin state container for devices
>   * @p: pinctrl handle for the containing device
>   * @default_state: the default state for the handle, if found
> + * @init_state: the state at probe time, if found
> + * @sleep_state: the state at suspend time, if found
> + * @idle_state: the state at idle (runtime suspend) time, if found

Thanks for adding my missing docs.

I like the patch. Please include Greg K-H on To: and request his
ACK on the next respin and I'm ready to merge it to pinctrl for
v3.19.

Yours,
Linus Walleij
