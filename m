Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbaCZQz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:55:26 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:58990 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbaCZQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <1394006982-30184-1-git-send-email-jon@ringle.org>
References: <1394006982-30184-1-git-send-email-jon@ringle.org>
Date: Wed, 26 Mar 2014 12:55:21 -0400
X-Google-Sender-Auth: yyhVH9cIrIYIxqZzt8bV3LusZrA
Message-ID: <CAMwGMjyRU7UHof80sz9JEL5_NeNA-abUNdsaYRBhuVfkBn3Znw@mail.gmail.com>
Subject: Re: [PATCH v3] touchscreen: tps6507x-ts: only poll while touch event
 is occurring
From: Jon Ringle <jon@ringle.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jon Ringle <jringle@gridpoint.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've not heard anything regarding this patch. I just want to make sure
it doesn't get lost :)

Jon

On Wed, Mar 5, 2014 at 3:09 AM,  <jon@ringle.org> wrote:
> From: Jon Ringle <jringle@gridpoint.com>
>
> (Resending without corporate dislaimer in email footer)
>
> We only need to poll for touch events after an interrupt occurs due to the
> user touching the screen. We continue to poll until the user stops touching
> the screen
>
> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> ---
>  drivers/input/touchscreen/tps6507x-ts.c | 189 +++++++++++++++++++++++++-------
>  include/linux/input/tps6507x-ts.h       |   1 +
>  include/linux/mfd/tps6507x.h            |   1 +
>  3 files changed, 151 insertions(+), 40 deletions(-)
>
> diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
> index 94cde2c..c051419 100644
> --- a/drivers/input/touchscreen/tps6507x-ts.c
> +++ b/drivers/input/touchscreen/tps6507x-ts.c
> @@ -17,11 +17,14 @@
>  #include <linux/workqueue.h>
>  #include <linux/slab.h>
>  #include <linux/input.h>
> -#include <linux/input-polldev.h>
>  #include <linux/platform_device.h>
>  #include <linux/mfd/tps6507x.h>
>  #include <linux/input/tps6507x-ts.h>
>  #include <linux/delay.h>
> +#include <linux/gpio.h>
> +#include <linux/i2c.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
>
>  #define TSC_DEFAULT_POLL_PERIOD 30 /* ms */
>  #define TPS_DEFAULT_MIN_PRESSURE 0x30
> @@ -39,13 +42,17 @@ struct ts_event {
>  };
>
>  struct tps6507x_ts {
> +       struct input_dev        *input_dev;
>         struct device           *dev;
> -       struct input_polled_dev *poll_dev;
>         struct tps6507x_dev     *mfd;
>         char                    phys[32];
> +       struct delayed_work     work;
>         struct ts_event         tc;
> +       int                     irq;
> +       unsigned long           poll_period;    /* ms */
>         u16                     min_pressure;
>         bool                    pendown;
> +       int                     open_count;
>  };
>
>  static int tps6507x_read_u8(struct tps6507x_ts *tsc, u8 reg, u8 *data)
> @@ -155,13 +162,20 @@ static s32 tps6507x_adc_standby(struct tps6507x_ts *tsc)
>         return ret;
>  }
>
> -static void tps6507x_ts_poll(struct input_polled_dev *poll_dev)
> +static void tps6507x_ts_handler(struct work_struct *work)
>  {
> -       struct tps6507x_ts *tsc = poll_dev->private;
> -       struct input_dev *input_dev = poll_dev->input;
> +       struct tps6507x_ts *tsc =  container_of(work, struct tps6507x_ts, work.work);
> +       struct input_dev *input_dev = tsc->input_dev;
>         bool pendown;
> +       int schd;
> +       int poll = 0;
>         s32 ret;
>
> +       if (tsc->irq) {
> +               // Disable the touch interrupt
> +               tps6507x_write_u8(tsc, TPS6507X_REG_INT, 0);
> +       }
> +
>         ret = tps6507x_adc_conversion(tsc, TPS6507X_TSCMODE_PRESSURE,
>                                       &tsc->tc.pressure);
>         if (ret)
> @@ -178,10 +192,11 @@ static void tps6507x_ts_poll(struct input_polled_dev *poll_dev)
>         }
>
>         if (pendown) {
> +               int report_pendown = 0;
>
>                 if (!tsc->pendown) {
>                         dev_dbg(tsc->dev, "DOWN\n");
> -                       input_report_key(input_dev, BTN_TOUCH, 1);
> +                       report_pendown = 1;
>                 } else
>                         dev_dbg(tsc->dev, "still down\n");
>
> @@ -195,15 +210,86 @@ static void tps6507x_ts_poll(struct input_polled_dev *poll_dev)
>                 if (ret)
>                         goto done;
>
> -               input_report_abs(input_dev, ABS_X, tsc->tc.x);
> -               input_report_abs(input_dev, ABS_Y, tsc->tc.y);
> -               input_report_abs(input_dev, ABS_PRESSURE, tsc->tc.pressure);
> -               input_sync(input_dev);
> -               tsc->pendown = true;
> +               if (tsc->tc.x && tsc->tc.y) {
> +                       if (report_pendown)
> +                               input_report_key(input_dev, BTN_TOUCH, 1);
> +
> +                       input_report_abs(input_dev, ABS_X, tsc->tc.x);
> +                       input_report_abs(input_dev, ABS_Y, tsc->tc.y);
> +                       input_report_abs(input_dev, ABS_PRESSURE, tsc->tc.pressure);
> +                       input_sync(input_dev);
> +                       tsc->pendown = true;
> +               } else {
> +                       dev_dbg(tsc->dev, "discarding bogus read x=%d, y=%d, pressure=%d\n", tsc->tc.x, tsc->tc.y, tsc->tc.pressure);
> +               }
> +               poll = 1;
>         }
>
>  done:
>         tps6507x_adc_standby(tsc);
> +       if (tsc->irq && !poll) {
> +               // Re-enable the interrupt
> +               tps6507x_write_u8(tsc, TPS6507X_REG_INT, TPS6507X_REG_MASK_TSC);
> +       } else {
> +               /* always poll if not using interrupts */
> +               schd = schedule_delayed_work(&tsc->work,
> +                                            msecs_to_jiffies(tsc->poll_period));
> +       }
> +}
> +
> +static irqreturn_t tps6507x_ts_irq(int irq, void * dev_id)
> +{
> +       struct tps6507x_ts * tsc = (struct tps6507x_ts *)dev_id;
> +
> +       schedule_delayed_work(&tsc->work, 0);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static int tps6507x_ts_open(struct input_dev *input_dev)
> +{
> +       int ret;
> +       struct tps6507x_ts *tsc = input_get_drvdata(input_dev);
> +
> +       tsc->open_count++;
> +
> +       if (tsc->irq) {
> +
> +               tps6507x_write_u8(tsc, TPS6507X_REG_INT, 0);
> +               tps6507x_adc_standby(tsc);
> +
> +               ret = request_irq(tsc->irq,tps6507x_ts_irq, 0, "TPS6507x",tsc);
> +
> +               if(ret < 0) {
> +                       tsc->open_count--;
> +                       dev_err(tsc->dev, "cannot register irq");
> +                       return ret;
> +               }
> +               // Enable the touch event interrupt
> +               tps6507x_write_u8(tsc, TPS6507X_REG_INT, TPS6507X_REG_MASK_TSC);
> +       } else {
> +               ret = schedule_delayed_work(&tsc->work,
> +                                           msecs_to_jiffies(tsc->poll_period));
> +
> +               if (!ret) {
> +                       tsc->open_count--;
> +                       dev_err(tsc->dev, "schedule failed");
> +                       return -ENOMEM;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static void tps6507x_ts_close(struct input_dev *input_dev)
> +{
> +       struct tps6507x_ts *tsc = input_get_drvdata(input_dev);
> +
> +       tsc->open_count--;
> +
> +       if(tsc->irq) {
> +               free_irq(tsc->irq,tsc);
> +       }
>  }
>
>  static int tps6507x_ts_probe(struct platform_device *pdev)
> @@ -212,8 +298,8 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
>         const struct tps6507x_board *tps_board;
>         const struct touchscreen_init_data *init_data;
>         struct tps6507x_ts *tsc;
> -       struct input_polled_dev *poll_dev;
>         struct input_dev *input_dev;
> +       int schd;
>         int error;
>
>         /*
> @@ -239,29 +325,18 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
>                 return -ENOMEM;
>         }
>
> +       tps6507x_dev->ts = tsc;
>         tsc->mfd = tps6507x_dev;
>         tsc->dev = tps6507x_dev->dev;
> -       tsc->min_pressure = init_data ?
> -                       init_data->min_pressure : TPS_DEFAULT_MIN_PRESSURE;
> -
> -       snprintf(tsc->phys, sizeof(tsc->phys),
> -                "%s/input0", dev_name(tsc->dev));
> -
> -       poll_dev = input_allocate_polled_device();
> -       if (!poll_dev) {
> -               dev_err(tsc->dev, "Failed to allocate polled input device.\n");
> +       input_dev = input_allocate_device();
> +       if (!input_dev) {
> +               dev_err(tsc->dev, "Failed to allocate input device.\n");
>                 error = -ENOMEM;
>                 goto err_free_mem;
>         }
>
> -       tsc->poll_dev = poll_dev;
> -
> -       poll_dev->private = tsc;
> -       poll_dev->poll = tps6507x_ts_poll;
> -       poll_dev->poll_interval = init_data ?
> -                       init_data->poll_period : TSC_DEFAULT_POLL_PERIOD;
> -
> -       input_dev = poll_dev->input;
> +       input_dev->open = tps6507x_ts_open;
> +       input_dev->close = tps6507x_ts_close;
>         input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
>         input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
>
> @@ -270,42 +345,76 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
>         input_set_abs_params(input_dev, ABS_PRESSURE, 0, MAX_10BIT, 0, 0);
>
>         input_dev->name = "TPS6507x Touchscreen";
> -       input_dev->phys = tsc->phys;
> -       input_dev->dev.parent = tsc->dev;
>         input_dev->id.bustype = BUS_I2C;
> +       input_dev->dev.parent = tsc->dev;
> +
> +       snprintf(tsc->phys, sizeof(tsc->phys),
> +                "%s/input0", dev_name(tsc->dev));
> +       input_dev->phys = tsc->phys;
> +
> +       dev_dbg(tsc->dev, "device: %s\n", input_dev->phys);
> +
> +       input_set_drvdata(input_dev, tsc);
> +
> +       tsc->input_dev = input_dev;
> +
> +       INIT_DELAYED_WORK(&tsc->work, tps6507x_ts_handler);
>         if (init_data) {
> +               tsc->poll_period = init_data->poll_period;
> +               tsc->irq = gpio_to_irq(init_data->irq_pin);
> +               tsc->min_pressure = init_data->min_pressure;
>                 input_dev->id.vendor = init_data->vendor;
>                 input_dev->id.product = init_data->product;
>                 input_dev->id.version = init_data->version;
> +       } else {
> +               tsc->poll_period = TSC_DEFAULT_POLL_PERIOD;
> +               tsc->min_pressure = TPS_DEFAULT_MIN_PRESSURE;
>         }
>
>         error = tps6507x_adc_standby(tsc);
>         if (error)
> -               goto err_free_polled_dev;
> +               goto err_free_dev;
>
> -       error = input_register_polled_device(poll_dev);
> +       error = input_register_device(input_dev);
>         if (error)
> -               goto err_free_polled_dev;
> +               goto err_free_dev;
> +
> +       if (!tsc->irq) {
> +               schd = schedule_delayed_work(&tsc->work,
> +                                            msecs_to_jiffies(tsc->poll_period));
> +
> +               if (!schd) {
> +                       dev_err(tsc->dev, "schedule failed");
> +                       goto err_cancel_work;
> +               }
> +       }
>
>         platform_set_drvdata(pdev, tsc);
>
>         return 0;
>
> -err_free_polled_dev:
> -       input_free_polled_device(poll_dev);
> +err_cancel_work:
> +       cancel_delayed_work_sync(&tsc->work);
> +err_free_dev:
> +       input_free_device(input_dev);
>  err_free_mem:
>         kfree(tsc);
> +       tps6507x_dev->ts = NULL;
> +
>         return error;
>  }
>
>  static int tps6507x_ts_remove(struct platform_device *pdev)
>  {
> -       struct tps6507x_ts *tsc = platform_get_drvdata(pdev);
> -       struct input_polled_dev *poll_dev = tsc->poll_dev;
> +       struct tps6507x_dev *tps6507x_dev = platform_get_drvdata(pdev);
> +       struct tps6507x_ts *tsc = tps6507x_dev->ts;
> +       struct input_dev *input_dev = tsc->input_dev;
> +
> +       cancel_delayed_work_sync(&tsc->work);
>
> -       input_unregister_polled_device(poll_dev);
> -       input_free_polled_device(poll_dev);
> +       input_unregister_device(input_dev);
>
> +       tps6507x_dev->ts = NULL;
>         kfree(tsc);
>
>         return 0;
> diff --git a/include/linux/input/tps6507x-ts.h b/include/linux/input/tps6507x-ts.h
> index b433df8..3c5aa7b 100644
> --- a/include/linux/input/tps6507x-ts.h
> +++ b/include/linux/input/tps6507x-ts.h
> @@ -14,6 +14,7 @@
>  /* Board specific touch screen initial values */
>  struct touchscreen_init_data {
>         int     poll_period;    /* ms */
> +       int     irq_pin;
>         __u16   min_pressure;   /* min reading to be treated as a touch */
>         __u16   vendor;
>         __u16   product;
> diff --git a/include/linux/mfd/tps6507x.h b/include/linux/mfd/tps6507x.h
> index c2ae569..c923e486 100644
> --- a/include/linux/mfd/tps6507x.h
> +++ b/include/linux/mfd/tps6507x.h
> @@ -163,6 +163,7 @@ struct tps6507x_dev {
>
>         /* Client devices */
>         struct tps6507x_pmic *pmic;
> +       struct tps6507x_ts *ts;
>  };
>
>  #endif /*  __LINUX_MFD_TPS6507X_H */
> --
> 1.8.5.4
>
