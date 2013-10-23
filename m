Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab3JWIvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:51:39 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:41615 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab3JWIvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:51:35 -0400
Date: Wed, 23 Oct 2013 10:51:28 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Johan Hovold'" <jhovold@gmail.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/9] backlight: atmel-pwm-bl: fix reported brightness
Message-ID: <20131023085128.GA11025@localhost>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
 <1382462819-28576-2-git-send-email-jhovold@gmail.com>
 <001901cecf8e$21764db0$6462e910$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001901cecf8e$21764db0$6462e910$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 10:20:59AM +0900, Jingoo Han wrote:
> On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> > 
> > The driver supports 16-bit brightness values, but the value returned
> > from get_brightness was truncated to eight bits.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > ---
> >  drivers/video/backlight/atmel-pwm-bl.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
> > index 66885fb..8aac273 100644
> > --- a/drivers/video/backlight/atmel-pwm-bl.c
> > +++ b/drivers/video/backlight/atmel-pwm-bl.c
> > @@ -70,7 +70,7 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
> >  static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
> >  {
> >  	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
> > -	u8 intensity;
> > +	u32 intensity;
> > 
> >  	if (pwmbl->pdata->pwm_active_low) {
> >  		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
> > @@ -80,7 +80,7 @@ static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
> >  			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
> >  	}
> > 
> > -	return intensity;
> > +	return (u16)intensity;
> 
> However, atmel_pwm_bl_get_intensity() should return 'int',
> instead of 'u16'.

Yes, but the cast to int is implicit. Perhaps

	return (intensity & 0xffff);

(or just a comment) would make it more clear why the cast is there.

> Also, pwm_channel_readl() returns 'u32'.

Yes, (and only the 16 least-significant bits are used). That and the
fact that the platform-data limits are currently unsigned long (I was
considering fixing this later) was why I preferred keeping all register
value manipulation in u32 and do a single cast at the end.

> Then, how about the following?
> 
> --- a/drivers/video/backlight/atmel-pwm-bl.c
> +++ b/drivers/video/backlight/atmel-pwm-bl.c
> @@ -70,17 +70,17 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
>  static int atmel_pwm_bl_get_intensity(struct backlight_device *bd)
>  {
> 	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
> -	u8 intensity;
> +	u16 intensity;
> 
> 	if (pwmbl->pdata->pwm_active_low) {
> -		intensity = pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
> +		intensity = (u16) pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY) -
> 			pwmbl->pdata->pwm_duty_min;

This would actually introduce a new conversion warning (unless you add
parentheses as well) as pwm_duty_min is unsigned long. Same below.

> 	} else {
> -		intensity = pwmbl->pdata->pwm_duty_max -
> +		intensity = (u16) pwmbl->pdata->pwm_duty_max -
> 			pwm_channel_readl(&pwmbl->pwmc, PWM_CDTY);
> 	}
> 
> -	return intensity;
> +	return (int)intensity;
>  }

However, if you feel strongly about this, I'll respin the series (a later
patch would likely no longer apply), use u16 and add casts to the two
assignments.

Thanks,
Johan
 
