Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbaILAN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 20:13:26 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:43154 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaILANY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 20:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <1410248433-24005-2-git-send-email-LW@KARO-electronics.de>
References: <1410248433-24005-1-git-send-email-LW@KARO-electronics.de> <1410248433-24005-2-git-send-email-LW@KARO-electronics.de>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 11 Sep 2014 17:13:02 -0700
Message-ID: <CAK5ve-L-Q29nuifBOXQgyWQ6e-k4wACfb7ccOQSPKp0fHkHmjA@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds: trigger: gpio: fix warning in gpio trigger for
 gpios whose accessor function may sleep
To: =?UTF-8?Q?Lothar_Wa=C3=9Fmann?= <LW@karo-electronics.de>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 12:40 AM, Lothar Waßmann <LW@karo-electronics.de> wrote:
> When using a GPIO driver whose accessor functions may sleep (e.g. an
> I2C GPIO extender like PCA9554) the following warning is issued:
> WARNING: CPU: 0 PID: 665 at drivers/gpio/gpiolib.c:2274 gpiod_get_raw_value+0x3c/0x48()
> Modules linked in:
> CPU: 0 PID: 665 Comm: kworker/0:2 Not tainted 3.16.0-karo+ #115
> Workqueue: events gpio_trig_work
> [<c00142cc>] (unwind_backtrace) from [<c00118f8>] (show_stack+0x10/0x14)
> [<c00118f8>] (show_stack) from [<c001bf10>] (warn_slowpath_common+0x64/0x84)
> [<c001bf10>] (warn_slowpath_common) from [<c001bf4c>] (warn_slowpath_null+0x1c/0x24)
> [<c001bf4c>] (warn_slowpath_null) from [<c020a1b8>] (gpiod_get_raw_value+0x3c/0x48)
> [<c020a1b8>] (gpiod_get_raw_value) from [<c02f68a0>] (gpio_trig_work+0x1c/0xb0)
> [<c02f68a0>] (gpio_trig_work) from [<c0030c1c>] (process_one_work+0x144/0x38c)
> [<c0030c1c>] (process_one_work) from [<c0030ef8>] (worker_thread+0x60/0x5cc)
> [<c0030ef8>] (worker_thread) from [<c0036dd4>] (kthread+0xb4/0xd0)
> [<c0036dd4>] (kthread) from [<c000f0f0>] (ret_from_fork+0x14/0x24)
> ---[ end trace cd51a1dad8b86c9c ]---
>
> Fix this by using the _cansleep() variant of gpio_get_value().
>

Good catch, I will merge this.

Thanks,
-Bryan

> Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> ---
>  drivers/leds/trigger/ledtrig-gpio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/leds/trigger/ledtrig-gpio.c b/drivers/leds/trigger/ledtrig-gpio.c
> index 35812e3..c86c418 100644
> --- a/drivers/leds/trigger/ledtrig-gpio.c
> +++ b/drivers/leds/trigger/ledtrig-gpio.c
> @@ -48,7 +48,7 @@ static void gpio_trig_work(struct work_struct *work)
>         if (!gpio_data->gpio)
>                 return;
>
> -       tmp = gpio_get_value(gpio_data->gpio);
> +       tmp = gpio_get_value_cansleep(gpio_data->gpio);
>         if (gpio_data->inverted)
>                 tmp = !tmp;
>
> --
> 1.7.10.4
>
