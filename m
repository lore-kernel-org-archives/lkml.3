Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab3HMUke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:40:34 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:43473 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160Ab3HMUkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:40:32 -0400
MIME-Version: 1.0
In-Reply-To: <1375948794-6286-4-git-send-email-milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com> <1375948794-6286-4-git-send-email-milo.kim@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 13 Aug 2013 13:40:10 -0700
Message-ID: <CAK5ve-+e-yTgsqf=Vk3OjmVWUsbj-XypLbr+x+SDJ7s+OWkXEg@mail.gmail.com>
Subject: Re: [PATCH 03/10] leds: lp5521: restore legacy device attributes
To: Milo Kim <woogyom.kim@gmail.com>
Cc: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Milo Kim <milo.kim@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 12:59 AM, Milo Kim <woogyom.kim@gmail.com> wrote:
> git commit 9ce7cb170f97f83a78dc948bf7d25690f15e1328
> may cause an application confict, engineN_mode and engineN_load.
> This interface should be maintained for compatibility.
>
> Restored device attributes are 'engineN_mode' and 'engineN_load'.
> A 'selftest' attribute macro is replaced with LP55xx common macro.
>
> Use a mutex in lp5521_update_program_memory()
> : This function is called when an user-application writes a 'engineN_load' file
> or pattern data is loaded from generic firmware interface.
> So, writing program memory should be protected.
> If an error occurs on accessing this area, just it returns as -EINVAL quickly.
> This error code is exact same as old driver function, lp5521_do_store_load()
> because it should be kept for an user-application compatibility.
> Even the driver is changed, we can use the application without re-compiling
> sources.
>
> 'led_pattern' attribute is not included
> : engineN_mode and _load were created for custom user-application.
> 'led_pattern' is an exception. I added this attribute not for custom application
> but for simple test. Now it is used only in LP5562 driver, not LP5521.
>

Looks good to me. Thanks,
-Bryan

> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5521.c |  104 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 100 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index 9e28dd0..c00f922 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -251,10 +251,20 @@ static int lp5521_update_program_memory(struct lp55xx_chip *chip,
>                 goto err;
>
>         program_size = i;
> -       for (i = 0; i < program_size; i++)
> -               lp55xx_write(chip, addr[idx] + i, pattern[i]);
>
> -       return 0;
> +       mutex_lock(&chip->lock);
> +
> +       for (i = 0; i < program_size; i++) {
> +               ret = lp55xx_write(chip, addr[idx] + i, pattern[i]);
> +               if (ret) {
> +                       mutex_unlock(&chip->lock);
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       mutex_unlock(&chip->lock);
> +
> +       return size;
>
>  err:
>         dev_err(&chip->cl->dev, "wrong pattern format\n");
> @@ -365,6 +375,80 @@ static void lp5521_led_brightness_work(struct work_struct *work)
>         mutex_unlock(&chip->lock);
>  }
>
> +static ssize_t show_engine_mode(struct device *dev,
> +                               struct device_attribute *attr,
> +                               char *buf, int nr)
> +{
> +       struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
> +       struct lp55xx_chip *chip = led->chip;
> +       enum lp55xx_engine_mode mode = chip->engines[nr - 1].mode;
> +
> +       switch (mode) {
> +       case LP55XX_ENGINE_RUN:
> +               return sprintf(buf, "run\n");
> +       case LP55XX_ENGINE_LOAD:
> +               return sprintf(buf, "load\n");
> +       case LP55XX_ENGINE_DISABLED:
> +       default:
> +               return sprintf(buf, "disabled\n");
> +       }
> +}
> +show_mode(1)
> +show_mode(2)
> +show_mode(3)
> +
> +static ssize_t store_engine_mode(struct device *dev,
> +                                struct device_attribute *attr,
> +                                const char *buf, size_t len, int nr)
> +{
> +       struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
> +       struct lp55xx_chip *chip = led->chip;
> +       struct lp55xx_engine *engine = &chip->engines[nr - 1];
> +
> +       mutex_lock(&chip->lock);
> +
> +       chip->engine_idx = nr;
> +
> +       if (!strncmp(buf, "run", 3)) {
> +               lp5521_run_engine(chip, true);
> +               engine->mode = LP55XX_ENGINE_RUN;
> +       } else if (!strncmp(buf, "load", 4)) {
> +               lp5521_stop_engine(chip);
> +               lp5521_load_engine(chip);
> +               engine->mode = LP55XX_ENGINE_LOAD;
> +       } else if (!strncmp(buf, "disabled", 8)) {
> +               lp5521_stop_engine(chip);
> +               engine->mode = LP55XX_ENGINE_DISABLED;
> +       }
> +
> +       mutex_unlock(&chip->lock);
> +
> +       return len;
> +}
> +store_mode(1)
> +store_mode(2)
> +store_mode(3)
> +
> +static ssize_t store_engine_load(struct device *dev,
> +                            struct device_attribute *attr,
> +                            const char *buf, size_t len, int nr)
> +{
> +       struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
> +       struct lp55xx_chip *chip = led->chip;
> +
> +       mutex_lock(&chip->lock);
> +
> +       chip->engine_idx = nr;
> +       lp5521_load_engine(chip);
> +
> +       mutex_unlock(&chip->lock);
> +
> +       return lp5521_update_program_memory(chip, buf, len);
> +}
> +store_load(1)
> +store_load(2)
> +store_load(3)
> +
>  static ssize_t lp5521_selftest(struct device *dev,
>                                struct device_attribute *attr,
>                                char *buf)
> @@ -381,9 +465,21 @@ static ssize_t lp5521_selftest(struct device *dev,
>  }
>
>  /* device attributes */
> -static DEVICE_ATTR(selftest, S_IRUGO, lp5521_selftest, NULL);
> +static LP55XX_DEV_ATTR_RW(engine1_mode, show_engine1_mode, store_engine1_mode);
> +static LP55XX_DEV_ATTR_RW(engine2_mode, show_engine2_mode, store_engine2_mode);
> +static LP55XX_DEV_ATTR_RW(engine3_mode, show_engine3_mode, store_engine3_mode);
> +static LP55XX_DEV_ATTR_WO(engine1_load, store_engine1_load);
> +static LP55XX_DEV_ATTR_WO(engine2_load, store_engine2_load);
> +static LP55XX_DEV_ATTR_WO(engine3_load, store_engine3_load);
> +static LP55XX_DEV_ATTR_RO(selftest, lp5521_selftest);
>
>  static struct attribute *lp5521_attributes[] = {
> +       &dev_attr_engine1_mode.attr,
> +       &dev_attr_engine2_mode.attr,
> +       &dev_attr_engine3_mode.attr,
> +       &dev_attr_engine1_load.attr,
> +       &dev_attr_engine2_load.attr,
> +       &dev_attr_engine3_load.attr,
>         &dev_attr_selftest.attr,
>         NULL
>  };
> --
> 1.7.9.5
>
