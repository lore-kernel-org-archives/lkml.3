Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbaCRXDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:03:14 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:63538 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315AbaCRXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:03:13 -0400
MIME-Version: 1.0
In-Reply-To: <1395081521-16568-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395081521-16568-1-git-send-email-alexandre.belloni@free-electrons.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 18 Mar 2014 16:02:51 -0700
Message-ID: <CAK5ve-JU-XfX-wTnr72riWbnSfOcnofjsXpVuyweCndjBe=UgQ@mail.gmail.com>
Subject: Re: [PATCH] leds: pwm: set polarity on non DT platforms
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 11:38 AM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> Set inversed polarity when .active_low is set in the platform_data. With device
> tree, this is taken care of by of_pwm_xlate_with_flags(), called from
> of_pwm_get().
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/leds/leds-pwm.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> index 605047428b5a..09681556a6aa 100644
> --- a/drivers/leds/leds-pwm.c
> +++ b/drivers/leds/leds-pwm.c
> @@ -180,6 +180,11 @@ static int led_pwm_probe(struct platform_device *pdev)
>                         led_dat->cdev.max_brightness = cur_led->max_brightness;
>                         led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
>
> +                       if (led_dat->active_low)

Why .active_low needs to inverse PWM polarity? In
of_pwm_xlate_with_flags(), it checked with PWM_POLARITY_INVERSED in
args. Moreover in of_pwm_simple_xlate() and pxa_pwm_of_xlate(), we
didn't inverse PWM polarity at all.

Add Thierry to review this.

Thanks,
-Bryan

> +                               if (pwm_set_polarity(led_dat->pwm,
> +                                                PWM_POLARITY_INVERSED))
> +                                       dev_err(&pdev->dev, "impossible to change polarity");
> +
>                         led_dat->can_sleep = pwm_can_sleep(led_dat->pwm);
>                         if (led_dat->can_sleep)
>                                 INIT_WORK(&led_dat->work, led_pwm_work);
> --
> 1.8.3.2
>
