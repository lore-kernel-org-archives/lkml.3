Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3JASjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:39:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35874 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3JASjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:39:43 -0400
Message-ID: <524B16E8.5080506@wwwdotorg.org>
Date: Tue, 01 Oct 2013 12:39:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] pwm-backlight: Use new enable_gpio field
References: <1379972467-11243-1-git-send-email-treding@nvidia.com> <1379972467-11243-9-git-send-email-treding@nvidia.com>
In-Reply-To: <1379972467-11243-9-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 03:41 PM, Thierry Reding wrote:
> Make use of the new enable_gpio field and allow it to be set from DT as
> well. Now that all legacy users of platform data have been converted to
> initialize this field to an invalid value, it is safe to use the field
> from the driver.

> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt

>  Optional properties:

> +  - enable-gpios: a list of GPIOs to enable and disable the backlight

That seems to imply that multiple GPIOs are legal. Was that intended? If
not, I would suggest:

- enable-gpios: contains a single GPIO specifier for the GPIO which
		enables/disables the backlight. See [1] for the format.

>  
>  [0]: Documentation/devicetree/bindings/pwm/pwm.txt
+ [1]: Documentation/devicetree/bindings/gpio/gpio.txt

> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c

> @@ -51,12 +55,27 @@ static void pwm_backlight_power_on(struct pwm_bl_data *pb, int brightness,
>  		     pb->lth_brightness;
>  
>  	pwm_config(pb->pwm, duty_cycle, pb->period);
> +
> +	if (gpio_is_valid(pb->enable_gpio)) {
> +		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
> +			gpio_set_value(pb->enable_gpio, 0);
> +		else
> +			gpio_set_value(pb->enable_gpio, 1);
> +	}

Feel completely free to ignore this, but when the difference in two
code-paths is solely in function parameters, I prefer to calculate the
parameter inside the if statement, then call the function outside the
conditional code, to highlight the common/different parts:

int value;

/* or an if statement for the next 1 line, if you don't like ?: */
value = (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW) ? 0 : 1;
gpio_set_value((pb->enable_gpio, value);

> @@ -148,11 +168,10 @@ static int pwm_backlight_parse_dt(struct device *dev,

> +	data->enable_gpio = of_get_named_gpio_flags(node, "enable-gpios", 0,
> +						    &flags);
> +	if (gpio_is_valid(data->enable_gpio) && (flags & OF_GPIO_ACTIVE_LOW))
> +		data->enable_gpio_flags |= PWM_BACKLIGHT_GPIO_ACTIVE_LOW;

This doesn't seem to handle deferred probe correctly; I would expect
something more like:

	data->enable_gpio = of_get_named_gpio_flags(...);
	if (data->enable_gpio == -EPROBE_DEFERRED)
		return data->enable_gpio;
	if (gpio_is_valid(...))
		...
	return 0;

I suppose it's possible that the value filters down to
gpio_request_one() and this actually does work out OK, but that feels
very accidental/implicit to me.
