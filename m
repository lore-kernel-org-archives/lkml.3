Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3LBTiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:38:50 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:34908 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab3LBTiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:38:15 -0500
MIME-Version: 1.0
In-Reply-To: <1385014414-6400-1-git-send-email-milo.kim@ti.com>
References: <1385014414-6400-1-git-send-email-milo.kim@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 2 Dec 2013 11:37:52 -0800
Message-ID: <CAK5ve-+kY=1g+NKbkueZnO9-KvZxWz+gBuUnsz1emNpmFqrRqg@mail.gmail.com>
Subject: Re: [PATCH 1/3] leds: lp5521/5523: Fix multiple engine usage bug
To: Milo Kim <milo.kim@ti.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 10:13 PM, Milo Kim <milo.kim@ti.com> wrote:
> Whenever the engine is loaded by the user-application, the operation mode is
> reset first. But it has a problem in case of multiple engine used because
> previous engine settings are cleared.
> The driver should update not whole 8bits but each engine bit by masking.
>
> On the other hands, whole engines should be reset when the driver is unloaded
> and on initializing the LP5523 driver.
> So, new functions are used for this handling - lp5521/5523_stop_all_engines().
>

This one looks good to me, I will merge it.

Thanks,
-Bryan

> Cc: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5521.c |   18 ++++++++++++++++--
>  drivers/leds/leds-lp5523.c |   20 +++++++++++++++++---
>  2 files changed, 33 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index 0518835..26f89ac 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -152,12 +152,26 @@ static void lp5521_load_engine(struct lp55xx_chip *chip)
>         lp5521_wait_opmode_done();
>  }
>
> -static void lp5521_stop_engine(struct lp55xx_chip *chip)
> +static void lp5521_stop_all_engines(struct lp55xx_chip *chip)
>  {
>         lp55xx_write(chip, LP5521_REG_OP_MODE, 0);
>         lp5521_wait_opmode_done();
>  }
>
> +static void lp5521_stop_engine(struct lp55xx_chip *chip)
> +{
> +       enum lp55xx_engine_index idx = chip->engine_idx;
> +       u8 mask[] = {
> +               [LP55XX_ENGINE_1] = LP5521_MODE_R_M,
> +               [LP55XX_ENGINE_2] = LP5521_MODE_G_M,
> +               [LP55XX_ENGINE_3] = LP5521_MODE_B_M,
> +       };
> +
> +       lp55xx_update_bits(chip, LP5521_REG_OP_MODE, mask[idx], 0);
> +
> +       lp5521_wait_opmode_done();
> +}
> +
>  static void lp5521_run_engine(struct lp55xx_chip *chip, bool start)
>  {
>         int ret;
> @@ -568,7 +582,7 @@ static int lp5521_remove(struct i2c_client *client)
>         struct lp55xx_led *led = i2c_get_clientdata(client);
>         struct lp55xx_chip *chip = led->chip;
>
> -       lp5521_stop_engine(chip);
> +       lp5521_stop_all_engines(chip);
>         lp55xx_unregister_sysfs(chip);
>         lp55xx_unregister_leds(led, chip);
>         lp55xx_deinit_device(chip);
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index 6b553d9..2ce1723 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -187,12 +187,26 @@ static void lp5523_load_engine_and_select_page(struct lp55xx_chip *chip)
>         lp55xx_write(chip, LP5523_REG_PROG_PAGE_SEL, page_sel[idx]);
>  }
>
> -static void lp5523_stop_engine(struct lp55xx_chip *chip)
> +static void lp5523_stop_all_engines(struct lp55xx_chip *chip)
>  {
>         lp55xx_write(chip, LP5523_REG_OP_MODE, 0);
>         lp5523_wait_opmode_done();
>  }
>
> +static void lp5523_stop_engine(struct lp55xx_chip *chip)
> +{
> +       enum lp55xx_engine_index idx = chip->engine_idx;
> +       u8 mask[] = {
> +               [LP55XX_ENGINE_1] = LP5523_MODE_ENG1_M,
> +               [LP55XX_ENGINE_2] = LP5523_MODE_ENG2_M,
> +               [LP55XX_ENGINE_3] = LP5523_MODE_ENG3_M,
> +       };
> +
> +       lp55xx_update_bits(chip, LP5523_REG_OP_MODE, mask[idx], 0);
> +
> +       lp5523_wait_opmode_done();
> +}
> +
>  static void lp5523_turn_off_channels(struct lp55xx_chip *chip)
>  {
>         int i;
> @@ -303,7 +317,7 @@ static int lp5523_init_program_engine(struct lp55xx_chip *chip)
>         }
>
>  out:
> -       lp5523_stop_engine(chip);
> +       lp5523_stop_all_engines(chip);
>         return ret;
>  }
>
> @@ -778,7 +792,7 @@ static int lp5523_remove(struct i2c_client *client)
>         struct lp55xx_led *led = i2c_get_clientdata(client);
>         struct lp55xx_chip *chip = led->chip;
>
> -       lp5523_stop_engine(chip);
> +       lp5523_stop_all_engines(chip);
>         lp55xx_unregister_sysfs(chip);
>         lp55xx_unregister_leds(led, chip);
>         lp55xx_deinit_device(chip);
> --
> 1.7.9.5
>
