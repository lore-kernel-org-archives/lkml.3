Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab3LKTIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:08:21 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:43944 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3LKTIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:08:15 -0500
MIME-Version: 1.0
In-Reply-To: <1386753582-16009-1-git-send-email-Li.Xiubo@freescale.com>
References: <1386753582-16009-1-git-send-email-Li.Xiubo@freescale.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 11 Dec 2013 11:07:53 -0800
Message-ID: <CAK5ve-JQEX5yOCW7vxu1yq7RrCUH0aWSrEJ0eBqSoOtMnjHEVg@mail.gmail.com>
Subject: Re: [PATCH] leds: leds-pwm: fix duty time overflow.
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, b47053@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 1:19 AM, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> Overflow maybe occurs when calculates the duty time. For instance,
> the period time is 990000000ns, and the max_brightness is 127, when
> setting the brightness to 12, the duty value will be 25906026ns, but
> it should be 93543307ns.

This looks good to me. Good catch. I will merge this.

Thanks,
-Bryan


> ---
>  drivers/leds/leds-pwm.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> index bb6f948..7cb2cd8 100644
> --- a/drivers/leds/leds-pwm.c
> +++ b/drivers/leds/leds-pwm.c
> @@ -66,9 +66,11 @@ static void led_pwm_set(struct led_classdev *led_cdev,
>         struct led_pwm_data *led_dat =
>                 container_of(led_cdev, struct led_pwm_data, cdev);
>         unsigned int max = led_dat->cdev.max_brightness;
> -       unsigned int period =  led_dat->period;
> +       unsigned long long duty =  led_dat->period;
>
> -       led_dat->duty = brightness * period / max;
> +       duty *= brightness;
> +       do_div(duty, max);
> +       led_dat->duty = duty;
>
>         if (led_dat->can_sleep)
>                 schedule_work(&led_dat->work);
> --
> 1.8.4
>
>
