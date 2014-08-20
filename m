Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaHTBxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 21:53:04 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38847 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaHTBxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 21:53:01 -0400
Date: Tue, 19 Aug 2014 18:51:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Vincent Donnefort <vdonnefort@gmail.com>
cc: Valdis.Kletnieks@vt.edu, cooloney@gmail.com, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] leds: make led_blink_set IRQ safe
In-Reply-To: <1408453101-30290-2-git-send-email-vdonnefort@gmail.com>
Message-ID: <alpine.LSU.2.11.1408191835200.3003@eggly.anvils>
References: <alpine.LSU.2.11.1408161946450.1064@eggly.anvils> <1408453101-30290-1-git-send-email-vdonnefort@gmail.com> <1408453101-30290-2-git-send-email-vdonnefort@gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2014, Vincent Donnefort wrote:

> This patch introduces a work which take care of reseting the blink workqueue and
> avoid calling the cancel_delayed_work_sync function which may sleep, from an IRQ
> context.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>

Thanks.  It does work for me.  Though the problem was more general than
stated above: not just a problem in IRQ context, but in any atomic context.

I don't suppose it has any effect on Valdis's lockdep issue, which I
didn't get to see myself; but we should let Valdis report back on that.

May I (most ungratefully!) say that your patch doesn't fill me with
confidence that it's the right solution: adding yet another work_struct
to get around the issue seemed dubious to me, I wonder if it might expose
new races.

But rest assured that I know nothing about this, and I'm not at all
qualified to review your patch: I hope Bryan and others will do so.

Thanks,
Hugh

> 
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 129729d..0971554 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -148,6 +148,24 @@ static void led_work_function(struct work_struct *ws)
>  			   msecs_to_jiffies(delay));
>  }
>  
> +static void reset_blink_work_delayed(struct work_struct *ws)
> +{
> +	struct led_classdev *led_cdev =
> +		container_of(ws, struct led_classdev, reset_blink_work);
> +
> +	cancel_delayed_work_sync(&led_cdev->blink_work);
> +
> +	if (!led_cdev->blink_delay_on) {
> +		__led_set_brightness(led_cdev, LED_OFF);
> +		return;
> +	} else if (!led_cdev->blink_delay_off) {
> +		__led_set_brightness(led_cdev, led_cdev->blink_brightness);
> +		return;
> +	}
> +
> +	queue_delayed_work(system_wq, &led_cdev->blink_work, 1);
> +}
> +
>  static void set_brightness_delayed(struct work_struct *ws)
>  {
>  	struct led_classdev *led_cdev =
> @@ -234,6 +252,7 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
>  	INIT_WORK(&led_cdev->set_brightness_work, set_brightness_delayed);
>  
>  	INIT_DELAYED_WORK(&led_cdev->blink_work, led_work_function);
> +	INIT_WORK(&led_cdev->reset_blink_work, reset_blink_work_delayed);
>  
>  #ifdef CONFIG_LEDS_TRIGGERS
>  	led_trigger_set_default(led_cdev);
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index 4bb1168..959510a 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -40,19 +40,7 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
>  	led_cdev->blink_delay_on = delay_on;
>  	led_cdev->blink_delay_off = delay_off;
>  
> -	/* never on - just set to off */
> -	if (!delay_on) {
> -		__led_set_brightness(led_cdev, LED_OFF);
> -		return;
> -	}
> -
> -	/* never off - just set to brightness */
> -	if (!delay_off) {
> -		__led_set_brightness(led_cdev, led_cdev->blink_brightness);
> -		return;
> -	}
> -
> -	queue_delayed_work(system_wq, &led_cdev->blink_work, 1);
> +	schedule_work(&led_cdev->reset_blink_work);
>  }
>  
>  
> @@ -76,8 +64,6 @@ void led_blink_set(struct led_classdev *led_cdev,
>  		   unsigned long *delay_on,
>  		   unsigned long *delay_off)
>  {
> -	cancel_delayed_work_sync(&led_cdev->blink_work);
> -
>  	led_cdev->flags &= ~LED_BLINK_ONESHOT;
>  	led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
>  
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 6a599dc..6e5523d 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -69,6 +69,7 @@ struct led_classdev {
>  
>  	unsigned long		 blink_delay_on, blink_delay_off;
>  	struct delayed_work	 blink_work;
> +	struct work_struct	 reset_blink_work;
>  	int			 blink_brightness;
>  
>  	struct work_struct	set_brightness_work;
> -- 
> 1.9.1
> 
> 
