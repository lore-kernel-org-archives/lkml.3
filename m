Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbbAISqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:46:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45606 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbbAISqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:46:10 -0500
Date: Fri, 9 Jan 2015 19:46:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Andrzej Hajda <a.hajda@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 08/19] leds: Add support for max77693 mfd flash
 cell
Message-ID: <20150109184606.GJ18076@amd>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-9-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420816989-1808-9-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2015-01-09 16:22:58, Jacek Anaszewski wrote:
> This patch adds led-flash support to Maxim max77693 chipset.
> A device can be exposed to user space through LED subsystem
> sysfs interface. Device supports up to two leds which can
> work in flash and torch mode. The leds can be triggered
> externally or by software.
> 

> +struct max77693_sub_led {
> +	/* related FLED output identifier */

->flash LED, about 4x.

> +/* split composite current @i into two @iout according to @imax weights */
> +static void __max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
> +{
> +	u64 t = i;
> +
> +	t *= imax[1];
> +	do_div(t, imax[0] + imax[1]);
> +
> +	iout[1] = (u32)t / FLASH_IOUT_STEP * FLASH_IOUT_STEP;
> +	iout[0] = i - iout[1];
> +}

Is 64-bit arithmetics neccessary here? Could we do the FLASH_IOUT_STEP
divisons before t *=, so that 64-bit division is not neccessary?

> +static int max77693_led_flash_strobe_get(
> +				struct led_classdev_flash *fled_cdev,
> +				bool *state)
> +{
> +	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
> +	struct max77693_led_device *led = sub_led_to_led(sub_led);
> +	int ret;
> +
> +	if (!state)
> +		return -EINVAL;
> +
> +	mutex_lock(&led->lock);
> +
> +	ret = max77693_strobe_status_get(led, state);
> +
> +	*state = !!(*state && (led->strobing_sub_led_id == sub_led->fled_id));
> +
> +
> +	mutex_unlock(&led->lock);
> +
> +	return ret;
> +}

Maybe remove some empty lines?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
