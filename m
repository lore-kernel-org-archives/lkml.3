Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3FEQe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:34:58 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:36405 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab3FEQe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:34:56 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 3/3] i2c: nomadik: use pinctrl PM helpers
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
	<1370439873-30053-3-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 05 Jun 2013 09:34:53 -0700
In-Reply-To: <1370439873-30053-3-git-send-email-linus.walleij@stericsson.com>
	(Linus Walleij's message of "Wed, 5 Jun 2013 15:44:33 +0200")
Message-ID: <87bo7kwm6q.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij <linus.walleij@stericsson.com> writes:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> This utilize the new pinctrl core PM helpers to transition
> the driver to "sleep" and "idle" states, cutting away some
> boilerplate code.
>
> Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

I have some questions on the interaction with runtime PM here...

> ---
> I'm seeking Wolfram's ACK on this to take it through the
> pinctrl tree in the end.
> ---
>  drivers/i2c/busses/i2c-nomadik.c | 90 +++++-----------------------------------
>  1 file changed, 10 insertions(+), 80 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
> index 650293f..c7e3b0c 100644
> --- a/drivers/i2c/busses/i2c-nomadik.c
> +++ b/drivers/i2c/busses/i2c-nomadik.c
> @@ -148,10 +148,6 @@ struct i2c_nmk_client {
>   * @stop: stop condition.
>   * @xfer_complete: acknowledge completion for a I2C message.
>   * @result: controller propogated result.
> - * @pinctrl: pinctrl handle.
> - * @pins_default: default state for the pins.
> - * @pins_idle: idle state for the pins.
> - * @pins_sleep: sleep state for the pins.
>   * @busy: Busy doing transfer.
>   */
>  struct nmk_i2c_dev {
> @@ -165,11 +161,6 @@ struct nmk_i2c_dev {
>  	int				stop;
>  	struct completion		xfer_complete;
>  	int				result;
> -	/* Three pin states - default, idle & sleep */
> -	struct pinctrl			*pinctrl;
> -	struct pinctrl_state		*pins_default;
> -	struct pinctrl_state		*pins_idle;
> -	struct pinctrl_state		*pins_sleep;
>  	bool				busy;
>  };
>  
> @@ -645,13 +636,7 @@ static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
>  	}
>  
>  	/* Optionaly enable pins to be muxed in and configured */
> -	if (!IS_ERR(dev->pins_default)) {
> -		status = pinctrl_select_state(dev->pinctrl,
> -				dev->pins_default);
> -		if (status)
> -			dev_err(&dev->adev->dev,
> -				"could not set default pins\n");
> -	}
> +	pinctrl_pm_select_default_state(&dev->adev->dev);

Shouldn't this be in the ->runtime_resume() callback of the driver (the
original code should've as well.)

IOW, the pinctrl changes only need to happen when the runtime PM
usecount goes from zero to 1.  For any additional users, the device will
already be active and pins already in default state.

I'm not familiar with this HW, and maybe the driver already prevents
multiple users, but for correctness sake (and because others will copy
this), the (re)muxing should be in the runtime PM callback.

Also, IMO, that's further evidence that the pinctrl stuff could (and
probably should) be handled by the PM core.

>  	status = init_hw(dev);
>  	if (status)
> @@ -681,13 +666,7 @@ out:
>  	clk_disable_unprepare(dev->clk);
>  out_clk:
>  	/* Optionally let pins go into idle state */
> -	if (!IS_ERR(dev->pins_idle)) {
> -		status = pinctrl_select_state(dev->pinctrl,
> -				dev->pins_idle);
> -		if (status)
> -			dev_err(&dev->adev->dev,
> -				"could not set pins to idle state\n");
> -	}
> +	pinctrl_pm_select_idle_state(&dev->adev->dev);

Again, if there are multiple users, you're changing the pin states
without knowing if you're the last user or not (again, the problem
existed in the original code as well.)

Runtime PM is doing the usecouning, so this should be in the
->runtime_suspend() callback.

>  	pm_runtime_put_sync(&dev->adev->dev);
>  

Kevin
