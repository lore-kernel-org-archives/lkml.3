Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab3DXVAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:00:19 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:54030 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3DXVAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:00:18 -0400
MIME-Version: 1.0
In-Reply-To: <1366836616-21475-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1366836616-21475-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 24 Apr 2013 13:59:55 -0700
Message-ID: <CAK5ve-JreGA+rusXWG8aM-ybPuJdhntw4x3-LTfYS_2+WZq2aw@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] leds: Remove leds-renesas-tpu driver
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 1:50 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> The driver is superseded by the generic rmob-tpu-pwm driver used with
> leds-pwm.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>


It's nice to move to generic driver.

Acked-by: Bryan Wu <cooloney@gmail.com>

> ---
>  drivers/leds/Kconfig                           |  12 -
>  drivers/leds/Makefile                          |   1 -
>  drivers/leds/leds-renesas-tpu.c                | 336 -------------------------
>  include/linux/platform_data/leds-renesas-tpu.h |  14 --
>  4 files changed, 363 deletions(-)
>  delete mode 100644 drivers/leds/leds-renesas-tpu.c
>  delete mode 100644 include/linux/platform_data/leds-renesas-tpu.h
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index ec50824..da2ac5c 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -419,18 +419,6 @@ config LEDS_ASIC3
>           cannot be used. This driver supports hardware blinking with an on+off
>           period from 62ms to 125s. Say Y to enable LEDs on the HP iPAQ hx4700.
>
> -config LEDS_RENESAS_TPU
> -       bool "LED support for Renesas TPU"
> -       depends on LEDS_CLASS=y && HAVE_CLK && GENERIC_GPIO
> -       help
> -         This option enables build of the LED TPU platform driver,
> -         suitable to drive any TPU channel on newer Renesas SoCs.
> -         The driver controls the GPIO pin connected to the LED via
> -         the GPIO framework and expects the LED to be connected to
> -         a pin that can be driven in both GPIO mode and using TPU
> -         pin function. The latter to support brightness control.
> -         Brightness control is supported but hardware blinking is not.
> -
>  config LEDS_TCA6507
>         tristate "LED Support for TCA6507 I2C chip"
>         depends on LEDS_CLASS && I2C
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 215e7e3..dd80c1a 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -48,7 +48,6 @@ obj-$(CONFIG_LEDS_MC13783)            += leds-mc13783.o
>  obj-$(CONFIG_LEDS_NS2)                 += leds-ns2.o
>  obj-$(CONFIG_LEDS_NETXBIG)             += leds-netxbig.o
>  obj-$(CONFIG_LEDS_ASIC3)               += leds-asic3.o
> -obj-$(CONFIG_LEDS_RENESAS_TPU)         += leds-renesas-tpu.o
>  obj-$(CONFIG_LEDS_MAX8997)             += leds-max8997.o
>  obj-$(CONFIG_LEDS_LM355x)              += leds-lm355x.o
>  obj-$(CONFIG_LEDS_BLINKM)              += leds-blinkm.o
> diff --git a/drivers/leds/leds-renesas-tpu.c b/drivers/leds/leds-renesas-tpu.c
> deleted file mode 100644
> index d3c2b7e..0000000
> --- a/drivers/leds/leds-renesas-tpu.c
> +++ /dev/null
> @@ -1,336 +0,0 @@
> -/*
> - * LED control using Renesas TPU
> - *
> - *  Copyright (C) 2011 Magnus Damm
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -
> -#include <linux/module.h>
> -#include <linux/init.h>
> -#include <linux/platform_device.h>
> -#include <linux/spinlock.h>
> -#include <linux/printk.h>
> -#include <linux/ioport.h>
> -#include <linux/io.h>
> -#include <linux/clk.h>
> -#include <linux/leds.h>
> -#include <linux/platform_data/leds-renesas-tpu.h>
> -#include <linux/gpio.h>
> -#include <linux/err.h>
> -#include <linux/slab.h>
> -#include <linux/pm_runtime.h>
> -#include <linux/workqueue.h>
> -
> -enum r_tpu_pin { R_TPU_PIN_UNUSED, R_TPU_PIN_GPIO, R_TPU_PIN_GPIO_FN };
> -enum r_tpu_timer { R_TPU_TIMER_UNUSED, R_TPU_TIMER_ON };
> -
> -struct r_tpu_priv {
> -       struct led_classdev ldev;
> -       void __iomem *mapbase;
> -       struct clk *clk;
> -       struct platform_device *pdev;
> -       enum r_tpu_pin pin_state;
> -       enum r_tpu_timer timer_state;
> -       unsigned long min_rate;
> -       unsigned int refresh_rate;
> -       struct work_struct work;
> -       enum led_brightness new_brightness;
> -};
> -
> -static DEFINE_SPINLOCK(r_tpu_lock);
> -
> -#define TSTR -1 /* Timer start register (shared register) */
> -#define TCR  0 /* Timer control register (+0x00) */
> -#define TMDR 1 /* Timer mode register (+0x04) */
> -#define TIOR 2 /* Timer I/O control register (+0x08) */
> -#define TIER 3 /* Timer interrupt enable register (+0x0c) */
> -#define TSR  4 /* Timer status register (+0x10) */
> -#define TCNT 5 /* Timer counter (+0x14) */
> -#define TGRA 6 /* Timer general register A (+0x18) */
> -#define TGRB 7 /* Timer general register B (+0x1c) */
> -#define TGRC 8 /* Timer general register C (+0x20) */
> -#define TGRD 9 /* Timer general register D (+0x24) */
> -
> -static inline unsigned short r_tpu_read(struct r_tpu_priv *p, int reg_nr)
> -{
> -       struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
> -       void __iomem *base = p->mapbase;
> -       unsigned long offs = reg_nr << 2;
> -
> -       if (reg_nr == TSTR)
> -               return ioread16(base - cfg->channel_offset);
> -
> -       return ioread16(base + offs);
> -}
> -
> -static inline void r_tpu_write(struct r_tpu_priv *p, int reg_nr,
> -                              unsigned short value)
> -{
> -       struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
> -       void __iomem *base = p->mapbase;
> -       unsigned long offs = reg_nr << 2;
> -
> -       if (reg_nr == TSTR) {
> -               iowrite16(value, base - cfg->channel_offset);
> -               return;
> -       }
> -
> -       iowrite16(value, base + offs);
> -}
> -
> -static void r_tpu_start_stop_ch(struct r_tpu_priv *p, int start)
> -{
> -       struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
> -       unsigned long flags, value;
> -
> -       /* start stop register shared by multiple timer channels */
> -       spin_lock_irqsave(&r_tpu_lock, flags);
> -       value = r_tpu_read(p, TSTR);
> -
> -       if (start)
> -               value |= 1 << cfg->timer_bit;
> -       else
> -               value &= ~(1 << cfg->timer_bit);
> -
> -       r_tpu_write(p, TSTR, value);
> -       spin_unlock_irqrestore(&r_tpu_lock, flags);
> -}
> -
> -static int r_tpu_enable(struct r_tpu_priv *p, enum led_brightness brightness)
> -{
> -       struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
> -       int prescaler[] = { 1, 4, 16, 64 };
> -       int k, ret;
> -       unsigned long rate, tmp;
> -
> -       if (p->timer_state == R_TPU_TIMER_ON)
> -               return 0;
> -
> -       /* wake up device and enable clock */
> -       pm_runtime_get_sync(&p->pdev->dev);
> -       ret = clk_enable(p->clk);
> -       if (ret) {
> -               dev_err(&p->pdev->dev, "cannot enable clock\n");
> -               return ret;
> -       }
> -
> -       /* make sure channel is disabled */
> -       r_tpu_start_stop_ch(p, 0);
> -
> -       /* get clock rate after enabling it */
> -       rate = clk_get_rate(p->clk);
> -
> -       /* pick the lowest acceptable rate */
> -       for (k = ARRAY_SIZE(prescaler) - 1; k >= 0; k--)
> -               if ((rate / prescaler[k]) >= p->min_rate)
> -                       break;
> -
> -       if (k < 0) {
> -               dev_err(&p->pdev->dev, "clock rate mismatch\n");
> -               goto err0;
> -       }
> -       dev_dbg(&p->pdev->dev, "rate = %lu, prescaler %u\n",
> -               rate, prescaler[k]);
> -
> -       /* clear TCNT on TGRB match, count on rising edge, set prescaler */
> -       r_tpu_write(p, TCR, 0x0040 | k);
> -
> -       /* output 0 until TGRA, output 1 until TGRB */
> -       r_tpu_write(p, TIOR, 0x0002);
> -
> -       rate /= prescaler[k] * p->refresh_rate;
> -       r_tpu_write(p, TGRB, rate);
> -       dev_dbg(&p->pdev->dev, "TRGB = 0x%04lx\n", rate);
> -
> -       tmp = (cfg->max_brightness - brightness) * rate;
> -       r_tpu_write(p, TGRA, tmp / cfg->max_brightness);
> -       dev_dbg(&p->pdev->dev, "TRGA = 0x%04lx\n", tmp / cfg->max_brightness);
> -
> -       /* PWM mode */
> -       r_tpu_write(p, TMDR, 0x0002);
> -
> -       /* enable channel */
> -       r_tpu_start_stop_ch(p, 1);
> -
> -       p->timer_state = R_TPU_TIMER_ON;
> -       return 0;
> - err0:
> -       clk_disable(p->clk);
> -       pm_runtime_put_sync(&p->pdev->dev);
> -       return -ENOTSUPP;
> -}
> -
> -static void r_tpu_disable(struct r_tpu_priv *p)
> -{
> -       if (p->timer_state == R_TPU_TIMER_UNUSED)
> -               return;
> -
> -       /* disable channel */
> -       r_tpu_start_stop_ch(p, 0);
> -
> -       /* stop clock and mark device as idle */
> -       clk_disable(p->clk);
> -       pm_runtime_put_sync(&p->pdev->dev);
> -
> -       p->timer_state = R_TPU_TIMER_UNUSED;
> -}
> -
> -static void r_tpu_set_pin(struct r_tpu_priv *p, enum r_tpu_pin new_state,
> -                         enum led_brightness brightness)
> -{
> -       struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
> -
> -       if (p->pin_state == new_state) {
> -               if (p->pin_state == R_TPU_PIN_GPIO)
> -                       gpio_set_value(cfg->pin_gpio, brightness);
> -               return;
> -       }
> -
> -       if (p->pin_state == R_TPU_PIN_GPIO)
> -               gpio_free(cfg->pin_gpio);
> -
> -       if (p->pin_state == R_TPU_PIN_GPIO_FN)
> -               gpio_free(cfg->pin_gpio_fn);
> -
> -       if (new_state == R_TPU_PIN_GPIO)
> -               gpio_request_one(cfg->pin_gpio, GPIOF_DIR_OUT | !!brightness,
> -                               cfg->name);
> -
> -       if (new_state == R_TPU_PIN_GPIO_FN)
> -               gpio_request(cfg->pin_gpio_fn, cfg->name);
> -
> -       p->pin_state = new_state;
> -}
> -
> -static void r_tpu_work(struct work_struct *work)
> -{
> -       struct r_tpu_priv *p = container_of(work, struct r_tpu_priv, work);
> -       enum led_brightness brightness = p->new_brightness;
> -
> -       r_tpu_disable(p);
> -
> -       /* off and maximum are handled as GPIO pins, in between PWM */
> -       if ((brightness == 0) || (brightness == p->ldev.max_brightness))
> -               r_tpu_set_pin(p, R_TPU_PIN_GPIO, brightness);
> -       else {
> -               r_tpu_set_pin(p, R_TPU_PIN_GPIO_FN, 0);
> -               r_tpu_enable(p, brightness);
> -       }
> -}
> -
> -static void r_tpu_set_brightness(struct led_classdev *ldev,
> -                                enum led_brightness brightness)
> -{
> -       struct r_tpu_priv *p = container_of(ldev, struct r_tpu_priv, ldev);
> -       p->new_brightness = brightness;
> -       schedule_work(&p->work);
> -}
> -
> -static int r_tpu_probe(struct platform_device *pdev)
> -{
> -       struct led_renesas_tpu_config *cfg = pdev->dev.platform_data;
> -       struct r_tpu_priv *p;
> -       struct resource *res;
> -       int ret;
> -
> -       if (!cfg) {
> -               dev_err(&pdev->dev, "missing platform data\n");
> -               return -ENODEV;
> -       }
> -
> -       p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
> -       if (p == NULL) {
> -               dev_err(&pdev->dev, "failed to allocate driver data\n");
> -               return -ENOMEM;
> -       }
> -
> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!res) {
> -               dev_err(&pdev->dev, "failed to get I/O memory\n");
> -               return -ENXIO;
> -       }
> -
> -       /* map memory, let mapbase point to our channel */
> -       p->mapbase = devm_ioremap_nocache(&pdev->dev, res->start,
> -                                       resource_size(res));
> -       if (p->mapbase == NULL) {
> -               dev_err(&pdev->dev, "failed to remap I/O memory\n");
> -               return -ENXIO;
> -       }
> -
> -       /* get hold of clock */
> -       p->clk = devm_clk_get(&pdev->dev, NULL);
> -       if (IS_ERR(p->clk)) {
> -               dev_err(&pdev->dev, "cannot get clock\n");
> -               return PTR_ERR(p->clk);
> -       }
> -
> -       p->pdev = pdev;
> -       p->pin_state = R_TPU_PIN_UNUSED;
> -       p->timer_state = R_TPU_TIMER_UNUSED;
> -       p->refresh_rate = cfg->refresh_rate ? cfg->refresh_rate : 100;
> -       r_tpu_set_pin(p, R_TPU_PIN_GPIO, LED_OFF);
> -       platform_set_drvdata(pdev, p);
> -
> -       INIT_WORK(&p->work, r_tpu_work);
> -
> -       p->ldev.name = cfg->name;
> -       p->ldev.brightness = LED_OFF;
> -       p->ldev.max_brightness = cfg->max_brightness;
> -       p->ldev.brightness_set = r_tpu_set_brightness;
> -       p->ldev.flags |= LED_CORE_SUSPENDRESUME;
> -       ret = led_classdev_register(&pdev->dev, &p->ldev);
> -       if (ret < 0)
> -               goto err0;
> -
> -       /* max_brightness may be updated by the LED core code */
> -       p->min_rate = p->ldev.max_brightness * p->refresh_rate;
> -
> -       pm_runtime_enable(&pdev->dev);
> -       return 0;
> -
> - err0:
> -       r_tpu_set_pin(p, R_TPU_PIN_UNUSED, LED_OFF);
> -       return ret;
> -}
> -
> -static int r_tpu_remove(struct platform_device *pdev)
> -{
> -       struct r_tpu_priv *p = platform_get_drvdata(pdev);
> -
> -       r_tpu_set_brightness(&p->ldev, LED_OFF);
> -       led_classdev_unregister(&p->ldev);
> -       cancel_work_sync(&p->work);
> -       r_tpu_disable(p);
> -       r_tpu_set_pin(p, R_TPU_PIN_UNUSED, LED_OFF);
> -
> -       pm_runtime_disable(&pdev->dev);
> -
> -       return 0;
> -}
> -
> -static struct platform_driver r_tpu_device_driver = {
> -       .probe          = r_tpu_probe,
> -       .remove         = r_tpu_remove,
> -       .driver         = {
> -               .name   = "leds-renesas-tpu",
> -       }
> -};
> -
> -module_platform_driver(r_tpu_device_driver);
> -
> -MODULE_AUTHOR("Magnus Damm");
> -MODULE_DESCRIPTION("Renesas TPU LED Driver");
> -MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/platform_data/leds-renesas-tpu.h b/include/linux/platform_data/leds-renesas-tpu.h
> deleted file mode 100644
> index 0553870..0000000
> --- a/include/linux/platform_data/leds-renesas-tpu.h
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -#ifndef __LEDS_RENESAS_TPU_H__
> -#define __LEDS_RENESAS_TPU_H__
> -
> -struct led_renesas_tpu_config {
> -       char *name;
> -       unsigned pin_gpio_fn;
> -       unsigned pin_gpio;
> -       unsigned int channel_offset;
> -       unsigned int timer_bit;
> -       unsigned int max_brightness;
> -       unsigned int refresh_rate;
> -};
> -
> -#endif /* __LEDS_RENESAS_TPU_H__ */
> --
> 1.8.1.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-leds" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
