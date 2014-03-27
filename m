Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbaC0R2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:28:11 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:58423 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbaC0R2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:28:06 -0400
MIME-Version: 1.0
In-Reply-To: <1395234209-15546-16-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395234209-15546-16-git-send-email-alexandre.belloni@free-electrons.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 27 Mar 2014 10:27:43 -0700
Message-ID: <CAK5ve-JibixcUPvDM9AGquUXmBKWYG2E8PzwBbb_XBS9sRjDyw@mail.gmail.com>
Subject: Re: [PATCH 15/16] leds: atmel-pwm: remove obsolete driver
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-pwm@vger.kernel.org, FBDEV list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 6:03 AM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> The leds-atmel-pwmdriver is now obsolete. It is not used by any mainlined boards
> and is replaced by the generic leds_pwm with the pawm-atmel driver using the
> generic PWM framework.
>

Good to remove.

Acked-by: Bryan Wu <cooloney@gmail.com>

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/leds/Kconfig          |   8 ---
>  drivers/leds/Makefile         |   1 -
>  drivers/leds/leds-atmel-pwm.c | 149 ------------------------------------------
>  3 files changed, 158 deletions(-)
>  delete mode 100644 drivers/leds/leds-atmel-pwm.c
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 72156c123033..e7aca5f1e396 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -32,14 +32,6 @@ config LEDS_88PM860X
>           This option enables support for on-chip LED drivers found on Marvell
>           Semiconductor 88PM8606 PMIC.
>
> -config LEDS_ATMEL_PWM
> -       tristate "LED Support using Atmel PWM outputs"
> -       depends on LEDS_CLASS
> -       depends on ATMEL_PWM
> -       help
> -         This option enables support for LEDs driven using outputs
> -         of the dedicated PWM controller found on newer Atmel SOCs.
> -
>  config LEDS_LM3530
>         tristate "LCD Backlight driver for LM3530"
>         depends on LEDS_CLASS
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 3cd76dbd9be2..6ee06559db45 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -6,7 +6,6 @@ obj-$(CONFIG_LEDS_TRIGGERS)             += led-triggers.o
>
>  # LED Platform Drivers
>  obj-$(CONFIG_LEDS_88PM860X)            += leds-88pm860x.o
> -obj-$(CONFIG_LEDS_ATMEL_PWM)           += leds-atmel-pwm.o
>  obj-$(CONFIG_LEDS_BD2802)              += leds-bd2802.o
>  obj-$(CONFIG_LEDS_LOCOMO)              += leds-locomo.o
>  obj-$(CONFIG_LEDS_LM3530)              += leds-lm3530.o
> diff --git a/drivers/leds/leds-atmel-pwm.c b/drivers/leds/leds-atmel-pwm.c
> deleted file mode 100644
> index 56cec8d6a2ac..000000000000
> --- a/drivers/leds/leds-atmel-pwm.c
> +++ /dev/null
> @@ -1,149 +0,0 @@
> -#include <linux/kernel.h>
> -#include <linux/platform_device.h>
> -#include <linux/leds.h>
> -#include <linux/io.h>
> -#include <linux/atmel_pwm.h>
> -#include <linux/slab.h>
> -#include <linux/module.h>
> -
> -
> -struct pwmled {
> -       struct led_classdev     cdev;
> -       struct pwm_channel      pwmc;
> -       struct gpio_led         *desc;
> -       u32                     mult;
> -       u8                      active_low;
> -};
> -
> -
> -/*
> - * For simplicity, we use "brightness" as if it were a linear function
> - * of PWM duty cycle.  However, a logarithmic function of duty cycle is
> - * probably a better match for perceived brightness: two is half as bright
> - * as four, four is half as bright as eight, etc
> - */
> -static void pwmled_brightness(struct led_classdev *cdev, enum led_brightness b)
> -{
> -       struct pwmled            *led;
> -
> -       /* update the duty cycle for the *next* period */
> -       led = container_of(cdev, struct pwmled, cdev);
> -       pwm_channel_writel(&led->pwmc, PWM_CUPD, led->mult * (unsigned) b);
> -}
> -
> -/*
> - * NOTE:  we reuse the platform_data structure of GPIO leds,
> - * but repurpose its "gpio" number as a PWM channel number.
> - */
> -static int pwmled_probe(struct platform_device *pdev)
> -{
> -       const struct gpio_led_platform_data     *pdata;
> -       struct pwmled                           *leds;
> -       int                                     i;
> -       int                                     status;
> -
> -       pdata = dev_get_platdata(&pdev->dev);
> -       if (!pdata || pdata->num_leds < 1)
> -               return -ENODEV;
> -
> -       leds = devm_kzalloc(&pdev->dev, pdata->num_leds * sizeof(*leds),
> -                       GFP_KERNEL);
> -       if (!leds)
> -               return -ENOMEM;
> -
> -       for (i = 0; i < pdata->num_leds; i++) {
> -               struct pwmled           *led = leds + i;
> -               const struct gpio_led   *dat = pdata->leds + i;
> -               u32                     tmp;
> -
> -               led->cdev.name = dat->name;
> -               led->cdev.brightness = LED_OFF;
> -               led->cdev.brightness_set = pwmled_brightness;
> -               led->cdev.default_trigger = dat->default_trigger;
> -
> -               led->active_low = dat->active_low;
> -
> -               status = pwm_channel_alloc(dat->gpio, &led->pwmc);
> -               if (status < 0)
> -                       goto err;
> -
> -               /*
> -                * Prescale clock by 2^x, so PWM counts in low MHz.
> -                * Start each cycle with the LED active, so increasing
> -                * the duty cycle gives us more time on (== brighter).
> -                */
> -               tmp = 5;
> -               if (!led->active_low)
> -                       tmp |= PWM_CPR_CPOL;
> -               pwm_channel_writel(&led->pwmc, PWM_CMR, tmp);
> -
> -               /*
> -                * Pick a period so PWM cycles at 100+ Hz; and a multiplier
> -                * for scaling duty cycle:  brightness * mult.
> -                */
> -               tmp = (led->pwmc.mck / (1 << 5)) / 100;
> -               tmp /= 255;
> -               led->mult = tmp;
> -               pwm_channel_writel(&led->pwmc, PWM_CDTY,
> -                               led->cdev.brightness * 255);
> -               pwm_channel_writel(&led->pwmc, PWM_CPRD,
> -                               LED_FULL * tmp);
> -
> -               pwm_channel_enable(&led->pwmc);
> -
> -               /* Hand it over to the LED framework */
> -               status = led_classdev_register(&pdev->dev, &led->cdev);
> -               if (status < 0) {
> -                       pwm_channel_free(&led->pwmc);
> -                       goto err;
> -               }
> -       }
> -
> -       platform_set_drvdata(pdev, leds);
> -       return 0;
> -
> -err:
> -       if (i > 0) {
> -               for (i = i - 1; i >= 0; i--) {
> -                       led_classdev_unregister(&leds[i].cdev);
> -                       pwm_channel_free(&leds[i].pwmc);
> -               }
> -       }
> -
> -       return status;
> -}
> -
> -static int pwmled_remove(struct platform_device *pdev)
> -{
> -       const struct gpio_led_platform_data     *pdata;
> -       struct pwmled                           *leds;
> -       unsigned                                i;
> -
> -       pdata = dev_get_platdata(&pdev->dev);
> -       leds = platform_get_drvdata(pdev);
> -
> -       for (i = 0; i < pdata->num_leds; i++) {
> -               struct pwmled           *led = leds + i;
> -
> -               led_classdev_unregister(&led->cdev);
> -               pwm_channel_free(&led->pwmc);
> -       }
> -
> -       return 0;
> -}
> -
> -static struct platform_driver pwmled_driver = {
> -       .driver = {
> -               .name =         "leds-atmel-pwm",
> -               .owner =        THIS_MODULE,
> -       },
> -       /* REVISIT add suspend() and resume() methods */
> -       .probe =        pwmled_probe,
> -       .remove =       pwmled_remove,
> -};
> -
> -module_platform_driver(pwmled_driver);
> -
> -MODULE_DESCRIPTION("Driver for LEDs with PWM-controlled brightness");
> -MODULE_LICENSE("GPL");
> -MODULE_ALIAS("platform:leds-atmel-pwm");
> --
> 1.8.3.2
>
