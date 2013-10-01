Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3JASvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:51:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50888 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3JASu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:50:57 -0400
Message-ID: <524B198B.3010609@wwwdotorg.org>
Date: Tue, 01 Oct 2013 12:50:51 -0600
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
Subject: Re: [PATCH 10/10] pwm-backlight: Allow backlight to remain disabled
 on boot
References: <1379972467-11243-1-git-send-email-treding@nvidia.com> <1379972467-11243-11-git-send-email-treding@nvidia.com>
In-Reply-To: <1379972467-11243-11-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 03:41 PM, Thierry Reding wrote:
> The default for backlight devices is to be enabled immediately when
> registering with the backlight core. This can be useful for setups that
> use a simple framebuffer device and where the backlight cannot otherwise
> be hooked up to the panel.
> 
> However, when dealing with more complex setups, such as those of recent
> ARM SoCs, this can be problematic. Since the backlight is usually setup
> separately from the display controller, the probe order is not usually
> deterministic. That can lead to situations where the backlight will be
> powered up and the panel will show an uninitialized framebuffer.
> 
> Furthermore, subsystems such as DRM have advanced functionality to set
> the power mode of a panel. In order to allow such setups to power up the
> panel at exactly the right moment, a way is needed to prevent the
> backlight core from powering the backlight up automatically when it is
> registered.
> 
> This commit introduces a new boot_off field in the platform data (and
> also implements getting the same information from device tree). When set
> the initial backlight power mode will be set to "off".

> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt

> +  - backlight-boot-off: keep the backlight disabled on boot

A few thoughts:

1) Does this property indicate that:

a) The current state of the backlight at boot. In which case, this will
need bootloader involvement to modify the value in the DT at boot time
based on whether the bootloader turned on the backlight:-(

b) That the driver should not turn on the backlight immediately? That
seems to describe driver behaviour more than HW. Is it appropriate to
put that into DT?

Your suggestion to make the backlight not turn on by default might be a
better fix?

2) Should the driver instead attempt to read the current state of the
GPIO output to determine whether the backlight is on? This may not be
possible on all HW.

3) Doesn't the following code in probe() (added in a previous patch)
need to be updated?

> +	if (gpio_is_valid(pb->enable_gpio)) {
> +		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
> +			gpio_set_value(pb->enable_gpio, 0);
> +		else
> +			gpio_set_value(pb->enable_gpio, 1);
> +	}

... That assumes that the backlight is on at boot, and hence presumably
after this patch still always turns on the backlight, only to turn it
off very quickly once the following code in this patch executes:

(and perhaps we also need to avoid turning the backlight off then on if
it was already on at boot)

> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c

> @@ -318,6 +320,12 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>  	}
>  
>  	bl->props.brightness = data->dft_brightness;
> +
> +	if (data->boot_off)
> +		bl->props.power = FB_BLANK_POWERDOWN;
> +	else
> +		bl->props.power = FB_BLANK_UNBLANK;

