Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3LBToA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:44:00 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:33452 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab3LBTn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:43:56 -0500
MIME-Version: 1.0
In-Reply-To: <1385014474-6487-1-git-send-email-milo.kim@ti.com>
References: <1385014474-6487-1-git-send-email-milo.kim@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 2 Dec 2013 11:43:34 -0800
Message-ID: <CAK5ve-KYMoqVikDKLiXp0uoyRPc4uKZicM2he3wcM1W528XRCw@mail.gmail.com>
Subject: Re: [PATCH 3/3] leds: lp5523: Support LED MUX configuration on
 running a pattern
To: Milo Kim <milo.kim@ti.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 10:14 PM, Milo Kim <milo.kim@ti.com> wrote:
> There are two ways to run a pattern in LP5523.
> One is using legacy sysfs files such as 'enginex_mode','enginex_load' and
> 'enginex_leds'. ('x' is from 1 to 3).
> Among them, 'enginex_leds' are used for selecting specific LED channel MUX.
> (MUX means which LEDs are used for running a pattern from LED 1 to 9.)
>
> The other way is using the firmware interface.
> In this mode, the default LED MUX strings are used.
> In other words, LED MUX is not configurable on the fly.
>
> This patch enables dynamic LED MUX configuration when the firmware is loaded.
> By accessing the sysfs file 'enginex_leds', the LED channels can be configured.
> To synchronize the operation mode, each engine mode should be set to 'LOAD'.
>
> The documentation is updated as well.
>

Thanks, I will merge this one.

-Bryan

> Cc: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  Documentation/leds/leds-lp55xx.txt |   10 +++++++++-
>  drivers/leds/leds-lp55xx-common.c  |    2 ++
>  2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/leds/leds-lp55xx.txt b/Documentation/leds/leds-lp55xx.txt
> index 82713ff..bcea12a 100644
> --- a/Documentation/leds/leds-lp55xx.txt
> +++ b/Documentation/leds/leds-lp55xx.txt
> @@ -73,6 +73,10 @@ select_engine : Select which engine is used for running program
>  run_engine    : Start program which is loaded via the firmware interface
>  firmware      : Load program data
>
> +In case of LP5523, one more command is required, 'enginex_leds'.
> +It is used for selecting LED output(s) at each engine number.
> +In more details, please refer to 'leds-lp5523.txt'.
> +
>  For example, run blinking pattern in engine #1 of LP5521
>  echo 1 > /sys/bus/i2c/devices/xxxx/select_engine
>  echo 1 > /sys/class/firmware/lp5521/loading
> @@ -81,10 +85,12 @@ echo 0 > /sys/class/firmware/lp5521/loading
>  echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
>
>  For example, run blinking pattern in engine #3 of LP55231
> +Two LEDs are configured as pattern output channels.
>  echo 3 > /sys/bus/i2c/devices/xxxx/select_engine
>  echo 1 > /sys/class/firmware/lp55231/loading
>  echo "9d0740ff7e0040007e00a0010000" > /sys/class/firmware/lp55231/data
>  echo 0 > /sys/class/firmware/lp55231/loading
> +echo "000001100" > /sys/bus/i2c/devices/xxxx/engine3_leds
>  echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
>
>  To start blinking patterns in engine #2 and #3 simultaneously,
> @@ -99,17 +105,19 @@ done
>  echo 1 > /sys/class/leds/red/device/run_engine
>
>  Here is another example for LP5523.
> +Full LED strings are selected by 'engine2_leds'.
>  echo 2 > /sys/bus/i2c/devices/xxxx/select_engine
>  echo 1 > /sys/class/firmware/lp5523/loading
>  echo "9d80400004ff05ff437f0000" > /sys/class/firmware/lp5523/data
>  echo 0 > /sys/class/firmware/lp5523/loading
> +echo "111111111" > /sys/bus/i2c/devices/xxxx/engine2_leds
>  echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
>
>  As soon as 'loading' is set to 0, registered callback is called.
>  Inside the callback, the selected engine is loaded and memory is updated.
>  To run programmed pattern, 'run_engine' attribute should be enabled.
>
> -The pattern sqeuence of LP8501 is same as LP5523.
> +The pattern sqeuence of LP8501 is similar to LP5523.
>  However pattern data is specific.
>  Ex 1) Engine 1 is used
>  echo 1 > /sys/bus/i2c/devices/xxxx/select_engine
> diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
> index 9acc6bb..88317b4 100644
> --- a/drivers/leds/leds-lp55xx-common.c
> +++ b/drivers/leds/leds-lp55xx-common.c
> @@ -210,6 +210,7 @@ static void lp55xx_firmware_loaded(const struct firmware *fw, void *context)
>  {
>         struct lp55xx_chip *chip = context;
>         struct device *dev = &chip->cl->dev;
> +       enum lp55xx_engine_index idx = chip->engine_idx;
>
>         if (!fw) {
>                 dev_err(dev, "firmware request failed\n");
> @@ -219,6 +220,7 @@ static void lp55xx_firmware_loaded(const struct firmware *fw, void *context)
>         /* handling firmware data is chip dependent */
>         mutex_lock(&chip->lock);
>
> +       chip->engines[idx - 1].mode = LP55XX_ENGINE_LOAD;
>         chip->fw = fw;
>         if (chip->cfg->firmware_cb)
>                 chip->cfg->firmware_cb(chip);
> --
> 1.7.9.5
>
