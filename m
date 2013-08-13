Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab3HMU6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:58:31 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:54555 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab3HMU63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:58:29 -0400
MIME-Version: 1.0
In-Reply-To: <1375948794-6286-8-git-send-email-milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com> <1375948794-6286-8-git-send-email-milo.kim@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 13 Aug 2013 13:58:06 -0700
Message-ID: <CAK5ve-LgBj7byAtO9CME6X18hGSRHx-ewzvsTcummXWTRBe3_Q@mail.gmail.com>
Subject: Re: [PATCH 07/10] leds: lp5523: restore legacy device attributes
To: Milo Kim <woogyom.kim@gmail.com>
Cc: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Milo Kim <milo.kim@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 12:59 AM, Milo Kim <woogyom.kim@gmail.com> wrote:
> git commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0
> (leds-lp5523: use generic firmware interface) causes an application conflict.
> This interface should be maintained for compatibility.
>
> Restored device attributes are 'engineN_mode', 'engineN_load' and
> 'engineN_leds'. (N = 1, 2 or 3)
> A 'selftest' attribute macro is replaced with LP55xx common macro.
> Those are accessed when a LED pattern is run by an application.
>
> Use a mutex in lp5523_update_program_memory()
> : This function is called when an user-application writes a 'engineN_load' file
> or pattern data is loaded from generic firmware interface.
> So, writing program memory should be protected.
> If an error occurs on accessing this area, just it returns as -EINVAL quickly.
> This error code is exact same as old driver function, lp5523_do_store_load()
> because it should be kept for an user-application compatibility.
> Even the driver is changed, we can use the application without re-compiling
> sources.
>

Good, I will merge this.

-Bryan

> Reported-by: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5523.c |  227 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 223 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index 29c8b19..9b8be6f6 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -74,6 +74,9 @@
>  #define LP5523_PAGE_ENG1               0
>  #define LP5523_PAGE_ENG2               1
>  #define LP5523_PAGE_ENG3               2
> +#define LP5523_PAGE_MUX1               3
> +#define LP5523_PAGE_MUX2               4
> +#define LP5523_PAGE_MUX3               5
>
>  /* Program Memory Operations */
>  #define LP5523_MODE_ENG1_M             0x30    /* Operation Mode Register */
> @@ -98,6 +101,8 @@
>  #define LP5523_RUN_ENG2                        0x08
>  #define LP5523_RUN_ENG3                        0x02
>
> +#define LED_ACTIVE(mux, led)           (!!(mux & (0x0001 << led)))
> +
>  enum lp5523_chip_id {
>         LP5523,
>         LP55231,
> @@ -338,10 +343,20 @@ static int lp5523_update_program_memory(struct lp55xx_chip *chip,
>                 goto err;
>
>         update_size = i;
> -       for (i = 0; i < update_size; i++)
> -               lp55xx_write(chip, LP5523_REG_PROG_MEM + i, pattern[i]);
>
> -       return 0;
> +       mutex_lock(&chip->lock);
> +
> +       for (i = 0; i < update_size; i++) {
> +               ret = lp55xx_write(chip, LP5523_REG_PROG_MEM + i, pattern[i]);
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
> @@ -368,6 +383,192 @@ static void lp5523_firmware_loaded(struct lp55xx_chip *chip)
>         lp5523_update_program_memory(chip, fw->data, fw->size);
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
> +               lp5523_run_engine(chip, true);
> +               engine->mode = LP55XX_ENGINE_RUN;
> +       } else if (!strncmp(buf, "load", 4)) {
> +               lp5523_stop_engine(chip);
> +               lp5523_load_engine(chip);
> +               engine->mode = LP55XX_ENGINE_LOAD;
> +       } else if (!strncmp(buf, "disabled", 8)) {
> +               lp5523_stop_engine(chip);
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
> +static int lp5523_mux_parse(const char *buf, u16 *mux, size_t len)
> +{
> +       u16 tmp_mux = 0;
> +       int i;
> +
> +       len = min_t(int, len, LP5523_MAX_LEDS);
> +
> +       for (i = 0; i < len; i++) {
> +               switch (buf[i]) {
> +               case '1':
> +                       tmp_mux |= (1 << i);
> +                       break;
> +               case '0':
> +                       break;
> +               case '\n':
> +                       i = len;
> +                       break;
> +               default:
> +                       return -1;
> +               }
> +       }
> +       *mux = tmp_mux;
> +
> +       return 0;
> +}
> +
> +static void lp5523_mux_to_array(u16 led_mux, char *array)
> +{
> +       int i, pos = 0;
> +       for (i = 0; i < LP5523_MAX_LEDS; i++)
> +               pos += sprintf(array + pos, "%x", LED_ACTIVE(led_mux, i));
> +
> +       array[pos] = '\0';
> +}
> +
> +static ssize_t show_engine_leds(struct device *dev,
> +                           struct device_attribute *attr,
> +                           char *buf, int nr)
> +{
> +       struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
> +       struct lp55xx_chip *chip = led->chip;
> +       char mux[LP5523_MAX_LEDS + 1];
> +
> +       lp5523_mux_to_array(chip->engines[nr - 1].led_mux, mux);
> +
> +       return sprintf(buf, "%s\n", mux);
> +}
> +show_leds(1)
> +show_leds(2)
> +show_leds(3)
> +
> +static int lp5523_load_mux(struct lp55xx_chip *chip, u16 mux, int nr)
> +{
> +       struct lp55xx_engine *engine = &chip->engines[nr - 1];
> +       int ret;
> +       u8 mux_page[] = {
> +               [LP55XX_ENGINE_1] = LP5523_PAGE_MUX1,
> +               [LP55XX_ENGINE_2] = LP5523_PAGE_MUX2,
> +               [LP55XX_ENGINE_3] = LP5523_PAGE_MUX3,
> +       };
> +
> +       lp5523_load_engine(chip);
> +
> +       ret = lp55xx_write(chip, LP5523_REG_PROG_PAGE_SEL, mux_page[nr]);
> +       if (ret)
> +               return ret;
> +
> +       ret = lp55xx_write(chip, LP5523_REG_PROG_MEM , (u8)(mux >> 8));
> +       if (ret)
> +               return ret;
> +
> +       ret = lp55xx_write(chip, LP5523_REG_PROG_MEM + 1, (u8)(mux));
> +       if (ret)
> +               return ret;
> +
> +       engine->led_mux = mux;
> +       return 0;
> +}
> +
> +static ssize_t store_engine_leds(struct device *dev,
> +                            struct device_attribute *attr,
> +                            const char *buf, size_t len, int nr)
> +{
> +       struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
> +       struct lp55xx_chip *chip = led->chip;
> +       struct lp55xx_engine *engine = &chip->engines[nr - 1];
> +       u16 mux = 0;
> +       ssize_t ret;
> +
> +       if (lp5523_mux_parse(buf, &mux, len))
> +               return -EINVAL;
> +
> +       mutex_lock(&chip->lock);
> +
> +       chip->engine_idx = nr;
> +       ret = -EINVAL;
> +
> +       if (engine->mode != LP55XX_ENGINE_LOAD)
> +               goto leave;
> +
> +       if (lp5523_load_mux(chip, mux, nr))
> +               goto leave;
> +
> +       ret = len;
> +leave:
> +       mutex_unlock(&chip->lock);
> +       return ret;
> +}
> +store_leds(1)
> +store_leds(2)
> +store_leds(3)
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
> +       lp5523_load_engine_and_select_page(chip);
> +
> +       mutex_unlock(&chip->lock);
> +
> +       return lp5523_update_program_memory(chip, buf, len);
> +}
> +store_load(1)
> +store_load(2)
> +store_load(3)
> +
>  static ssize_t lp5523_selftest(struct device *dev,
>                                struct device_attribute *attr,
>                                char *buf)
> @@ -467,9 +668,27 @@ static void lp5523_led_brightness_work(struct work_struct *work)
>         mutex_unlock(&chip->lock);
>  }
>
> -static DEVICE_ATTR(selftest, S_IRUGO, lp5523_selftest, NULL);
> +static LP55XX_DEV_ATTR_RW(engine1_mode, show_engine1_mode, store_engine1_mode);
> +static LP55XX_DEV_ATTR_RW(engine2_mode, show_engine2_mode, store_engine2_mode);
> +static LP55XX_DEV_ATTR_RW(engine3_mode, show_engine3_mode, store_engine3_mode);
> +static LP55XX_DEV_ATTR_RW(engine1_leds, show_engine1_leds, store_engine1_leds);
> +static LP55XX_DEV_ATTR_RW(engine2_leds, show_engine2_leds, store_engine2_leds);
> +static LP55XX_DEV_ATTR_RW(engine3_leds, show_engine3_leds, store_engine3_leds);
> +static LP55XX_DEV_ATTR_WO(engine1_load, store_engine1_load);
> +static LP55XX_DEV_ATTR_WO(engine2_load, store_engine2_load);
> +static LP55XX_DEV_ATTR_WO(engine3_load, store_engine3_load);
> +static LP55XX_DEV_ATTR_RO(selftest, lp5523_selftest);
>
>  static struct attribute *lp5523_attributes[] = {
> +       &dev_attr_engine1_mode.attr,
> +       &dev_attr_engine2_mode.attr,
> +       &dev_attr_engine3_mode.attr,
> +       &dev_attr_engine1_load.attr,
> +       &dev_attr_engine2_load.attr,
> +       &dev_attr_engine3_load.attr,
> +       &dev_attr_engine1_leds.attr,
> +       &dev_attr_engine2_leds.attr,
> +       &dev_attr_engine3_leds.attr,
>         &dev_attr_selftest.attr,
>         NULL,
>  };
> --
> 1.7.9.5
>
