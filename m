Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaILAdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 20:33:05 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:35102 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaILAdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 20:33:03 -0400
MIME-Version: 1.0
In-Reply-To: <1410248433-24005-3-git-send-email-LW@KARO-electronics.de>
References: <1410248433-24005-1-git-send-email-LW@KARO-electronics.de> <1410248433-24005-3-git-send-email-LW@KARO-electronics.de>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 11 Sep 2014 17:32:40 -0700
Message-ID: <CAK5ve-+BCvfHZ-JrYD_48KYzaZGE0as=eMe0+XPbgh5DfH9qRw@mail.gmail.com>
Subject: Re: [PATCH 2/2] leds: trigger: gpio: make ledtrig-gpio useable with
 GPIO drivers requiring threaded irqs
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
> When trying to use the LED GPIO trigger with e.g. the PCA953x GPIO
> driver, request_irq() fails with -EINVAL, because the GPIO driver
> requires a nested interrupt handler.
>
> Use request_any_context_irq() to be able to use any GPIO driver as LED
> trigger.
>

Hmmm, what about use request_thread_irq() and put the gpio_trig_work()
in as the thread_func.

Felipe, can you take a look at this?

Also in the first patch:
Actually in gpio_trig_irq(), it said:
/* just schedule_work since gpio_get_value can sleep */
        schedule_work(&gpio_data->work);

Then that means we need to call gpio_get_value_can_sleep() in the
gpio_trig_work() instead of gpio_get_value(), right?

Thanks,
-Bryan


> Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> ---
>  drivers/leds/trigger/ledtrig-gpio.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/leds/trigger/ledtrig-gpio.c b/drivers/leds/trigger/ledtrig-gpio.c
> index c86c418..b4168a7 100644
> --- a/drivers/leds/trigger/ledtrig-gpio.c
> +++ b/drivers/leds/trigger/ledtrig-gpio.c
> @@ -161,10 +161,10 @@ static ssize_t gpio_trig_gpio_store(struct device *dev,
>                 return n;
>         }
>
> -       ret = request_irq(gpio_to_irq(gpio), gpio_trig_irq,
> +       ret = request_any_context_irq(gpio_to_irq(gpio), gpio_trig_irq,
>                         IRQF_SHARED | IRQF_TRIGGER_RISING
>                         | IRQF_TRIGGER_FALLING, "ledtrig-gpio", led);
> -       if (ret) {
> +       if (ret < 0) {
>                 dev_err(dev, "request_irq failed with error %d\n", ret);
>         } else {
>                 if (gpio_data->gpio != 0)
> @@ -172,7 +172,7 @@ static ssize_t gpio_trig_gpio_store(struct device *dev,
>                 gpio_data->gpio = gpio;
>         }
>
> -       return ret ? ret : n;
> +       return ret < 0 ? ret : n;
>  }
>  static DEVICE_ATTR(gpio, 0644, gpio_trig_gpio_show, gpio_trig_gpio_store);
>
> --
> 1.7.10.4
>
