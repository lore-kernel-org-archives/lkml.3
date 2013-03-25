Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab3CYWGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:06:37 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:52023 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974Ab3CYWGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:06:35 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E48E2B@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E48E2B@DQHE02.ent.ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 25 Mar 2013 15:06:12 -0700
Message-ID: <CAK5ve-Lmae+Y8M2Jx_2P69k8DEXRLxUL+0EJf6Ff30xcdPxknA@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds: lp55xx: use common clock framework when
 external clock is used
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Mike Turquette (mturquette@linaro.org)" <mturquette@linaro.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 5:37 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> Program execution is timed with 32768Hz clock in the LP55xx family devices.
> To run LED functionalities, LP55xx devices provide two options.
> One is using internal clock. The other is using external clock.
> This patch enables external clock detection automatically.
> If external clock is not detected, then the internal clock will be used in the
> LP55xx driver.
>
> Valid clock rate is 32768Hz in LP55xx devices.
>
> This new API is used in each LP55xx driver like LP5521 and LP5562.
>

Looks good to me, I merged this patchset.
Thanks,

-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp55xx-common.c |   36 ++++++++++++++++++++++++++++++++++++
>  drivers/leds/leds-lp55xx-common.h |    4 ++++
>  2 files changed, 40 insertions(+)
>
> diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
> index 715a602..ba34199 100644
> --- a/drivers/leds/leds-lp55xx-common.c
> +++ b/drivers/leds/leds-lp55xx-common.c
> @@ -12,6 +12,7 @@
>   * Derived from leds-lp5521.c, leds-lp5523.c
>   */
>
> +#include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/firmware.h>
>  #include <linux/i2c.h>
> @@ -21,6 +22,9 @@
>
>  #include "leds-lp55xx-common.h"
>
> +/* External clock rate */
> +#define LP55XX_CLK_32K                 32768
> +
>  static struct lp55xx_led *cdev_to_lp55xx_led(struct led_classdev *cdev)
>  {
>         return container_of(cdev, struct lp55xx_led, cdev);
> @@ -357,6 +361,35 @@ int lp55xx_update_bits(struct lp55xx_chip *chip, u8 reg, u8 mask, u8 val)
>  }
>  EXPORT_SYMBOL_GPL(lp55xx_update_bits);
>
> +bool lp55xx_is_extclk_used(struct lp55xx_chip *chip)
> +{
> +       struct clk *clk;
> +       int err;
> +
> +       clk = devm_clk_get(&chip->cl->dev, "32k_clk");
> +       if (IS_ERR(clk))
> +               goto use_internal_clk;
> +
> +       err = clk_prepare_enable(clk);
> +       if (err)
> +               goto use_internal_clk;
> +
> +       if (clk_get_rate(clk) != LP55XX_CLK_32K) {
> +               clk_disable_unprepare(clk);
> +               goto use_internal_clk;
> +       }
> +
> +       dev_info(&chip->cl->dev, "%dHz external clock used\n",  LP55XX_CLK_32K);
> +
> +       chip->clk = clk;
> +       return true;
> +
> +use_internal_clk:
> +       dev_info(&chip->cl->dev, "internal clock used\n");
> +       return false;
> +}
> +EXPORT_SYMBOL_GPL(lp55xx_is_extclk_used);
> +
>  int lp55xx_init_device(struct lp55xx_chip *chip)
>  {
>         struct lp55xx_platform_data *pdata;
> @@ -421,6 +454,9 @@ void lp55xx_deinit_device(struct lp55xx_chip *chip)
>  {
>         struct lp55xx_platform_data *pdata = chip->pdata;
>
> +       if (chip->clk)
> +               clk_disable_unprepare(chip->clk);
> +
>         if (pdata->enable)
>                 pdata->enable(0);
>
> diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
> index ece4761..fa6a078 100644
> --- a/drivers/leds/leds-lp55xx-common.h
> +++ b/drivers/leds/leds-lp55xx-common.h
> @@ -83,6 +83,7 @@ struct lp55xx_device_config {
>   */
>  struct lp55xx_chip {
>         struct i2c_client *cl;
> +       struct clk *clk;
>         struct lp55xx_platform_data *pdata;
>         struct mutex lock;      /* lock for user-space interface */
>         int num_leds;
> @@ -117,6 +118,9 @@ extern int lp55xx_read(struct lp55xx_chip *chip, u8 reg, u8 *val);
>  extern int lp55xx_update_bits(struct lp55xx_chip *chip, u8 reg,
>                         u8 mask, u8 val);
>
> +/* external clock detection */
> +extern bool lp55xx_is_extclk_used(struct lp55xx_chip *chip);
> +
>  /* common device init/deinit functions */
>  extern int lp55xx_init_device(struct lp55xx_chip *chip);
>  extern void lp55xx_deinit_device(struct lp55xx_chip *chip);
> --
> 1.7.9.5
>
>
> Best Regards,
> Milo
>
