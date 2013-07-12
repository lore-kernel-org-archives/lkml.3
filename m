Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965249Ab3GLRqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:46:25 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:54630 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab3GLRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:46:23 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E808BA@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E808BA@DQHE06.ent.ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 12 Jul 2013 10:46:01 -0700
Message-ID: <CAK5ve-Lz+Gu1s78ccg47UPCNGPtQhkjQ4PGTa1XbSJPFcC8_=A@mail.gmail.com>
Subject: Re: [PATCH re-send] leds: support new LP8501 device - another LP55xx common
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 2:11 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
> LP8501 can drive up to 9 channels like LP5523.
> LEDs can be controlled directly via the I2C and programmable engines are
> supported.
>
> LP55xx common driver
>  LP8501 is one of LP55xx family device, so LP55xx common code are used.
>  Chip specific data is defined in the structure, 'lp55xx_device_config'.
>
> Differences between LP8501 and LP5523
>  Different register layout for LED output control and others.
>  LP8501 specific feature for separate output power selection.
>  LP8501 doesn't support external clock detection.
>  Different programming engine data.
>
> LP8501 specific feature - output power selection
>  Output channels are selected by power selection - Vout or Vdd.
>  Separate power for VDD1-6 and VDD7-9 are available.
>  It is configurable in the platform data.
>  To support this feature, LP55xx DT structure and header are changed.
>  Device tree binding is updated as well.
>
> LED pattern data
>  Example pattern data is updated in the driver documentation.
>
> Signed-off-by: Milo Kim <milo.kim@ti.com>

This patch looks good to me, I will merge it soon.

Thanks,
-Bryan

> ---
> This patch is re-sent with additional Cc lists.
>
>  .../devicetree/bindings/leds/leds-lp55xx.txt       |   72 +++-
>  Documentation/leds/leds-lp55xx.txt                 |   30 +-
>  drivers/leds/Kconfig                               |   18 +-
>  drivers/leds/Makefile                              |    1 +
>  drivers/leds/leds-lp55xx-common.c                  |    3 +
>  drivers/leds/leds-lp8501.c                         |  410 ++++++++++++++++++++
>  include/linux/platform_data/leds-lp55xx.h          |   10 +
>  7 files changed, 537 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/leds/leds-lp8501.c
>
> diff --git a/Documentation/devicetree/bindings/leds/leds-lp55xx.txt b/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
> index d517688..a61727f 100644
> --- a/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
> +++ b/Documentation/devicetree/bindings/leds/leds-lp55xx.txt
> @@ -1,7 +1,7 @@
>  Binding for TI/National Semiconductor LP55xx Led Drivers
>
>  Required properties:
> -- compatible: "national,lp5521" or "national,lp5523" or "ti,lp5562"
> +- compatible: "national,lp5521" or "national,lp5523" or "ti,lp5562" or "ti,lp8501"
>  - reg: I2C slave address
>  - clock-mode: Input clock mode, (0: automode, 1: internal, 2: external)
>
> @@ -11,6 +11,11 @@ Each child has own specific current settings
>
>  Optional properties:
>  - label: Used for naming LEDs
> +- pwr-sel: LP8501 specific property. Power selection for output channels.
> +         0: D1~9 are connected to VDD
> +         1: D1~6 with VDD, D7~9 with VOUT
> +         2: D1~6 with VOUT, D7~9 with VDD
> +         3: D1~9 are connected to VOUT
>
>  Alternatively, each child can have specific channel name
>  - chan-name: Name of each channel name
> @@ -145,3 +150,68 @@ lp5562@30 {
>                 max-cur = /bits/ 8 <0x60>;
>         };
>  };
> +
> +example 4) LP8501
> +9 channels are defined. The 'pwr-sel' is LP8501 specific property.
> +Others are same as LP5523.
> +
> +lp8501@32 {
> +       compatible = "ti,lp8501";
> +       reg = <0x32>;
> +       clock-mode = /bits/ 8 <2>;
> +       pwr-sel = /bits/ 8 <3>; /* D1~9 connected to VOUT */
> +
> +       chan0 {
> +               chan-name = "d1";
> +               led-cur = /bits/ 8 <0x14>;
> +               max-cur = /bits/ 8 <0x20>;
> +       };
> +
> +       chan1 {
> +               chan-name = "d2";
> +               led-cur = /bits/ 8 <0x14>;
> +               max-cur = /bits/ 8 <0x20>;
> +       };
> +
> +       chan2 {
> +               chan-name = "d3";
> +               led-cur = /bits/ 8 <0x14>;
> +               max-cur = /bits/ 8 <0x20>;
> +       };
> +
> +       chan3 {
> +               chan-name = "d4";
> +               led-cur = /bits/ 8 <0x14>;
> +               max-cur = /bits/ 8 <0x20>;
> +       };
> +
> +       chan4 {
> +               chan-name = "d5";
> +               led-cur = /bits/ 8 <0x14>;
> +               max-cur = /bits/ 8 <0x20>;
> +       };
> +
> +       chan5 {
> +               chan-name = "d6";
> +               led-cur = /bits/ 8 <0x14>;
> +               max-cur = /bits/ 8 <0x20>;
> +       };
> +
> +       chan6 {
> +               chan-name = "d7";
> +               led-cur = /bits/ 8 <0x14>;
> +               max-cur = /bits/ 8 <0x20>;
> +       };
> +
> +       chan7 {
> +               chan-name = "d8";
> +               led-cur = /bits/ 8 <0x14>;
> +               max-cur = /bits/ 8 <0x20>;
> +       };
> +
> +       chan8 {
> +               chan-name = "d9";
> +               led-cur = /bits/ 8 <0x14>;
> +               max-cur = /bits/ 8 <0x20>;
> +       };
> +};
> diff --git a/Documentation/leds/leds-lp55xx.txt b/Documentation/leds/leds-lp55xx.txt
> index eec8fa2..82713ff 100644
> --- a/Documentation/leds/leds-lp55xx.txt
> +++ b/Documentation/leds/leds-lp55xx.txt
> @@ -1,11 +1,11 @@
> -LP5521/LP5523/LP55231 Common Driver
> -===================================
> +LP5521/LP5523/LP55231/LP5562/LP8501 Common Driver
> +=================================================
>
>  Authors: Milo(Woogyom) Kim <milo.kim@ti.com>
>
>  Description
>  -----------
> -LP5521, LP5523/55231 and LP5562 have common features as below.
> +LP5521, LP5523/55231, LP5562 and LP8501 have common features as below.
>
>    Register access via the I2C
>    Device initialization/deinitialization
> @@ -109,6 +109,30 @@ As soon as 'loading' is set to 0, registered callback is called.
>  Inside the callback, the selected engine is loaded and memory is updated.
>  To run programmed pattern, 'run_engine' attribute should be enabled.
>
> +The pattern sqeuence of LP8501 is same as LP5523.
> +However pattern data is specific.
> +Ex 1) Engine 1 is used
> +echo 1 > /sys/bus/i2c/devices/xxxx/select_engine
> +echo 1 > /sys/class/firmware/lp8501/loading
> +echo "9d0140ff7e0040007e00a001c000" > /sys/class/firmware/lp8501/data
> +echo 0 > /sys/class/firmware/lp8501/loading
> +echo 1 > /sys/bus/i2c/devices/xxxx/run_engine
> +
> +Ex 2) Engine 2 and 3 are used at the same time
> +echo 2 > /sys/bus/i2c/devices/xxxx/select_engine
> +sleep 1
> +echo 1 > /sys/class/firmware/lp8501/loading
> +echo "9d0140ff7e0040007e00a001c000" > /sys/class/firmware/lp8501/data
> +echo 0 > /sys/class/firmware/lp8501/loading
> +sleep 1
> +echo 3 > /sys/bus/i2c/devices/xxxx/select_engine
> +sleep 1
> +echo 1 > /sys/class/firmware/lp8501/loading
> +echo "9d0340ff7e0040007e00a001c000" > /sys/class/firmware/lp8501/data
> +echo 0 > /sys/class/firmware/lp8501/loading
> +sleep 1
> +echo 1 > /sys/class/leds/d1/device/run_engine
> +
>  ( 'run_engine' and 'firmware_cb' )
>  The sequence of running the program data is common.
>  But each device has own specific register addresses for commands.
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index e43402d..77329ce 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -194,11 +194,11 @@ config LEDS_LP3944
>           module will be called leds-lp3944.
>
>  config LEDS_LP55XX_COMMON
> -       tristate "Common Driver for TI/National LP5521, LP5523/55231 and LP5562"
> -       depends on LEDS_LP5521 || LEDS_LP5523 || LEDS_LP5562
> +       tristate "Common Driver for TI/National LP5521/5523/55231/5562/8501"
> +       depends on LEDS_LP5521 || LEDS_LP5523 || LEDS_LP5562 || LEDS_LP8501
>         select FW_LOADER
>         help
> -         This option supports common operations for LP5521 and LP5523/55231
> +         This option supports common operations for LP5521/5523/55231/5562/8501
>           devices.
>
>  config LEDS_LP5521
> @@ -232,6 +232,18 @@ config LEDS_LP5562
>           Driver provides direct control via LED class and interface for
>           programming the engines.
>
> +config LEDS_LP8501
> +       tristate "LED Support for TI LP8501 LED driver chip"
> +       depends on LEDS_CLASS && I2C
> +       select LEDS_LP55XX_COMMON
> +       help
> +         If you say yes here you get support for TI LP8501 LED driver.
> +         It is 9 channel chip with programmable engines.
> +         Driver provides direct control via LED class and interface for
> +         programming the engines.
> +         It is similar as LP5523, but output power selection is available.
> +         And register layout and engine program schemes are different.
> +
>  config LEDS_LP8788
>         tristate "LED support for the TI LP8788 PMIC"
>         depends on LEDS_CLASS
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index ac28977..3013113 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -27,6 +27,7 @@ obj-$(CONFIG_LEDS_LP55XX_COMMON)      += leds-lp55xx-common.o
>  obj-$(CONFIG_LEDS_LP5521)              += leds-lp5521.o
>  obj-$(CONFIG_LEDS_LP5523)              += leds-lp5523.o
>  obj-$(CONFIG_LEDS_LP5562)              += leds-lp5562.o
> +obj-$(CONFIG_LEDS_LP8501)              += leds-lp8501.o
>  obj-$(CONFIG_LEDS_LP8788)              += leds-lp8788.o
>  obj-$(CONFIG_LEDS_TCA6507)             += leds-tca6507.o
>  obj-$(CONFIG_LEDS_CLEVO_MAIL)          += leds-clevo-mail.o
> diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
> index c2fecd4..351825b 100644
> --- a/drivers/leds/leds-lp55xx-common.c
> +++ b/drivers/leds/leds-lp55xx-common.c
> @@ -593,6 +593,9 @@ int lp55xx_of_populate_pdata(struct device *dev, struct device_node *np)
>         of_property_read_string(np, "label", &pdata->label);
>         of_property_read_u8(np, "clock-mode", &pdata->clock_mode);
>
> +       /* LP8501 specific */
> +       of_property_read_u8(np, "pwr-sel", (u8 *)&pdata->pwr_sel);
> +
>         dev->platform_data = pdata;
>
>         return 0;
> diff --git a/drivers/leds/leds-lp8501.c b/drivers/leds/leds-lp8501.c
> new file mode 100644
> index 0000000..4573b94
> --- /dev/null
> +++ b/drivers/leds/leds-lp8501.c
> @@ -0,0 +1,410 @@
> +/*
> + * TI LP8501 9 channel LED Driver
> + *
> + * Copyright (C) 2013 Texas Instruments
> + *
> + * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/firmware.h>
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/leds.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_data/leds-lp55xx.h>
> +#include <linux/slab.h>
> +
> +#include "leds-lp55xx-common.h"
> +
> +#define LP8501_PROGRAM_LENGTH          32
> +#define LP8501_MAX_LEDS                        9
> +
> +/* Registers */
> +#define LP8501_REG_ENABLE              0x00
> +#define LP8501_ENABLE                  BIT(6)
> +#define LP8501_EXEC_M                  0x3F
> +#define LP8501_EXEC_ENG1_M             0x30
> +#define LP8501_EXEC_ENG2_M             0x0C
> +#define LP8501_EXEC_ENG3_M             0x03
> +#define LP8501_RUN_ENG1                        0x20
> +#define LP8501_RUN_ENG2                        0x08
> +#define LP8501_RUN_ENG3                        0x02
> +
> +#define LP8501_REG_OP_MODE             0x01
> +#define LP8501_MODE_ENG1_M             0x30
> +#define LP8501_MODE_ENG2_M             0x0C
> +#define LP8501_MODE_ENG3_M             0x03
> +#define LP8501_LOAD_ENG1               0x10
> +#define LP8501_LOAD_ENG2               0x04
> +#define LP8501_LOAD_ENG3               0x01
> +
> +#define LP8501_REG_PWR_CONFIG          0x05
> +#define LP8501_PWR_CONFIG_M            0x03
> +
> +#define LP8501_REG_LED_PWM_BASE                0x16
> +
> +#define LP8501_REG_LED_CURRENT_BASE    0x26
> +
> +#define LP8501_REG_CONFIG              0x36
> +#define LP8501_PWM_PSAVE               BIT(7)
> +#define LP8501_AUTO_INC                        BIT(6)
> +#define LP8501_PWR_SAVE                        BIT(5)
> +#define LP8501_CP_AUTO                 0x18
> +#define LP8501_INT_CLK                 BIT(0)
> +#define LP8501_DEFAULT_CFG     \
> +       (LP8501_PWM_PSAVE | LP8501_AUTO_INC | LP8501_PWR_SAVE | LP8501_CP_AUTO)
> +
> +#define LP8501_REG_RESET               0x3D
> +#define LP8501_RESET                   0xFF
> +
> +#define LP8501_REG_PROG_PAGE_SEL       0x4F
> +#define LP8501_PAGE_ENG1               0
> +#define LP8501_PAGE_ENG2               1
> +#define LP8501_PAGE_ENG3               2
> +
> +#define LP8501_REG_PROG_MEM            0x50
> +
> +#define LP8501_ENG1_IS_LOADING(mode)   \
> +       ((mode & LP8501_MODE_ENG1_M) == LP8501_LOAD_ENG1)
> +#define LP8501_ENG2_IS_LOADING(mode)   \
> +       ((mode & LP8501_MODE_ENG2_M) == LP8501_LOAD_ENG2)
> +#define LP8501_ENG3_IS_LOADING(mode)   \
> +       ((mode & LP8501_MODE_ENG3_M) == LP8501_LOAD_ENG3)
> +
> +static inline void lp8501_wait_opmode_done(void)
> +{
> +       usleep_range(1000, 2000);
> +}
> +
> +static void lp8501_set_led_current(struct lp55xx_led *led, u8 led_current)
> +{
> +       led->led_current = led_current;
> +       lp55xx_write(led->chip, LP8501_REG_LED_CURRENT_BASE + led->chan_nr,
> +               led_current);
> +}
> +
> +static int lp8501_post_init_device(struct lp55xx_chip *chip)
> +{
> +       int ret;
> +       u8 val = LP8501_DEFAULT_CFG;
> +
> +       ret = lp55xx_write(chip, LP8501_REG_ENABLE, LP8501_ENABLE);
> +       if (ret)
> +               return ret;
> +
> +       /* Chip startup time is 500 us, 1 - 2 ms gives some margin */
> +       usleep_range(1000, 2000);
> +
> +       if (chip->pdata->clock_mode != LP55XX_CLOCK_EXT)
> +               val |= LP8501_INT_CLK;
> +
> +       ret = lp55xx_write(chip, LP8501_REG_CONFIG, val);
> +       if (ret)
> +               return ret;
> +
> +       /* Power selection for each output */
> +       return lp55xx_update_bits(chip, LP8501_REG_PWR_CONFIG,
> +                               LP8501_PWR_CONFIG_M, chip->pdata->pwr_sel);
> +}
> +
> +static void lp8501_load_engine(struct lp55xx_chip *chip)
> +{
> +       enum lp55xx_engine_index idx = chip->engine_idx;
> +       u8 mask[] = {
> +               [LP55XX_ENGINE_1] = LP8501_MODE_ENG1_M,
> +               [LP55XX_ENGINE_2] = LP8501_MODE_ENG2_M,
> +               [LP55XX_ENGINE_3] = LP8501_MODE_ENG3_M,
> +       };
> +
> +       u8 val[] = {
> +               [LP55XX_ENGINE_1] = LP8501_LOAD_ENG1,
> +               [LP55XX_ENGINE_2] = LP8501_LOAD_ENG2,
> +               [LP55XX_ENGINE_3] = LP8501_LOAD_ENG3,
> +       };
> +
> +       u8 page_sel[] = {
> +               [LP55XX_ENGINE_1] = LP8501_PAGE_ENG1,
> +               [LP55XX_ENGINE_2] = LP8501_PAGE_ENG2,
> +               [LP55XX_ENGINE_3] = LP8501_PAGE_ENG3,
> +       };
> +
> +       lp55xx_update_bits(chip, LP8501_REG_OP_MODE, mask[idx], val[idx]);
> +
> +       lp8501_wait_opmode_done();
> +
> +       lp55xx_write(chip, LP8501_REG_PROG_PAGE_SEL, page_sel[idx]);
> +}
> +
> +static void lp8501_stop_engine(struct lp55xx_chip *chip)
> +{
> +       lp55xx_write(chip, LP8501_REG_OP_MODE, 0);
> +       lp8501_wait_opmode_done();
> +}
> +
> +static void lp8501_turn_off_channels(struct lp55xx_chip *chip)
> +{
> +       int i;
> +
> +       for (i = 0; i < LP8501_MAX_LEDS; i++)
> +               lp55xx_write(chip, LP8501_REG_LED_PWM_BASE + i, 0);
> +}
> +
> +static void lp8501_run_engine(struct lp55xx_chip *chip, bool start)
> +{
> +       int ret;
> +       u8 mode;
> +       u8 exec;
> +
> +       /* stop engine */
> +       if (!start) {
> +               lp8501_stop_engine(chip);
> +               lp8501_turn_off_channels(chip);
> +               return;
> +       }
> +
> +       /*
> +        * To run the engine,
> +        * operation mode and enable register should updated at the same time
> +        */
> +
> +       ret = lp55xx_read(chip, LP8501_REG_OP_MODE, &mode);
> +       if (ret)
> +               return;
> +
> +       ret = lp55xx_read(chip, LP8501_REG_ENABLE, &exec);
> +       if (ret)
> +               return;
> +
> +       /* change operation mode to RUN only when each engine is loading */
> +       if (LP8501_ENG1_IS_LOADING(mode)) {
> +               mode = (mode & ~LP8501_MODE_ENG1_M) | LP8501_RUN_ENG1;
> +               exec = (exec & ~LP8501_EXEC_ENG1_M) | LP8501_RUN_ENG1;
> +       }
> +
> +       if (LP8501_ENG2_IS_LOADING(mode)) {
> +               mode = (mode & ~LP8501_MODE_ENG2_M) | LP8501_RUN_ENG2;
> +               exec = (exec & ~LP8501_EXEC_ENG2_M) | LP8501_RUN_ENG2;
> +       }
> +
> +       if (LP8501_ENG3_IS_LOADING(mode)) {
> +               mode = (mode & ~LP8501_MODE_ENG3_M) | LP8501_RUN_ENG3;
> +               exec = (exec & ~LP8501_EXEC_ENG3_M) | LP8501_RUN_ENG3;
> +       }
> +
> +       lp55xx_write(chip, LP8501_REG_OP_MODE, mode);
> +       lp8501_wait_opmode_done();
> +
> +       lp55xx_update_bits(chip, LP8501_REG_ENABLE, LP8501_EXEC_M, exec);
> +}
> +
> +static int lp8501_update_program_memory(struct lp55xx_chip *chip,
> +                                       const u8 *data, size_t size)
> +{
> +       u8 pattern[LP8501_PROGRAM_LENGTH] = {0};
> +       unsigned cmd;
> +       char c[3];
> +       int update_size;
> +       int nrchars;
> +       int offset = 0;
> +       int ret;
> +       int i;
> +
> +       /* clear program memory before updating */
> +       for (i = 0; i < LP8501_PROGRAM_LENGTH; i++)
> +               lp55xx_write(chip, LP8501_REG_PROG_MEM + i, 0);
> +
> +       i = 0;
> +       while ((offset < size - 1) && (i < LP8501_PROGRAM_LENGTH)) {
> +               /* separate sscanfs because length is working only for %s */
> +               ret = sscanf(data + offset, "%2s%n ", c, &nrchars);
> +               if (ret != 1)
> +                       goto err;
> +
> +               ret = sscanf(c, "%2x", &cmd);
> +               if (ret != 1)
> +                       goto err;
> +
> +               pattern[i] = (u8)cmd;
> +               offset += nrchars;
> +               i++;
> +       }
> +
> +       /* Each instruction is 16bit long. Check that length is even */
> +       if (i % 2)
> +               goto err;
> +
> +       update_size = i;
> +       for (i = 0; i < update_size; i++)
> +               lp55xx_write(chip, LP8501_REG_PROG_MEM + i, pattern[i]);
> +
> +       return 0;
> +
> +err:
> +       dev_err(&chip->cl->dev, "wrong pattern format\n");
> +       return -EINVAL;
> +}
> +
> +static void lp8501_firmware_loaded(struct lp55xx_chip *chip)
> +{
> +       const struct firmware *fw = chip->fw;
> +
> +       if (fw->size > LP8501_PROGRAM_LENGTH) {
> +               dev_err(&chip->cl->dev, "firmware data size overflow: %zu\n",
> +                       fw->size);
> +               return;
> +       }
> +
> +       /*
> +        * Program momery sequence
> +        *  1) set engine mode to "LOAD"
> +        *  2) write firmware data into program memory
> +        */
> +
> +       lp8501_load_engine(chip);
> +       lp8501_update_program_memory(chip, fw->data, fw->size);
> +}
> +
> +static void lp8501_led_brightness_work(struct work_struct *work)
> +{
> +       struct lp55xx_led *led = container_of(work, struct lp55xx_led,
> +                                             brightness_work);
> +       struct lp55xx_chip *chip = led->chip;
> +
> +       mutex_lock(&chip->lock);
> +       lp55xx_write(chip, LP8501_REG_LED_PWM_BASE + led->chan_nr,
> +                    led->brightness);
> +       mutex_unlock(&chip->lock);
> +}
> +
> +/* Chip specific configurations */
> +static struct lp55xx_device_config lp8501_cfg = {
> +       .reset = {
> +               .addr = LP8501_REG_RESET,
> +               .val  = LP8501_RESET,
> +       },
> +       .enable = {
> +               .addr = LP8501_REG_ENABLE,
> +               .val  = LP8501_ENABLE,
> +       },
> +       .max_channel  = LP8501_MAX_LEDS,
> +       .post_init_device   = lp8501_post_init_device,
> +       .brightness_work_fn = lp8501_led_brightness_work,
> +       .set_led_current    = lp8501_set_led_current,
> +       .firmware_cb        = lp8501_firmware_loaded,
> +       .run_engine         = lp8501_run_engine,
> +};
> +
> +static int lp8501_probe(struct i2c_client *client,
> +                       const struct i2c_device_id *id)
> +{
> +       int ret;
> +       struct lp55xx_chip *chip;
> +       struct lp55xx_led *led;
> +       struct lp55xx_platform_data *pdata;
> +       struct device_node *np = client->dev.of_node;
> +
> +       if (!client->dev.platform_data) {
> +               if (np) {
> +                       ret = lp55xx_of_populate_pdata(&client->dev, np);
> +                       if (ret < 0)
> +                               return ret;
> +               } else {
> +                       dev_err(&client->dev, "no platform data\n");
> +                       return -EINVAL;
> +               }
> +       }
> +       pdata = client->dev.platform_data;
> +
> +       chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
> +       if (!chip)
> +               return -ENOMEM;
> +
> +       led = devm_kzalloc(&client->dev,
> +                       sizeof(*led) * pdata->num_channels, GFP_KERNEL);
> +       if (!led)
> +               return -ENOMEM;
> +
> +       chip->cl = client;
> +       chip->pdata = pdata;
> +       chip->cfg = &lp8501_cfg;
> +
> +       mutex_init(&chip->lock);
> +
> +       i2c_set_clientdata(client, led);
> +
> +       ret = lp55xx_init_device(chip);
> +       if (ret)
> +               goto err_init;
> +
> +       dev_info(&client->dev, "%s Programmable led chip found\n", id->name);
> +
> +       ret = lp55xx_register_leds(led, chip);
> +       if (ret)
> +               goto err_register_leds;
> +
> +       ret = lp55xx_register_sysfs(chip);
> +       if (ret) {
> +               dev_err(&client->dev, "registering sysfs failed\n");
> +               goto err_register_sysfs;
> +       }
> +
> +       return 0;
> +
> +err_register_sysfs:
> +       lp55xx_unregister_leds(led, chip);
> +err_register_leds:
> +       lp55xx_deinit_device(chip);
> +err_init:
> +       return ret;
> +}
> +
> +static int lp8501_remove(struct i2c_client *client)
> +{
> +       struct lp55xx_led *led = i2c_get_clientdata(client);
> +       struct lp55xx_chip *chip = led->chip;
> +
> +       lp8501_stop_engine(chip);
> +       lp55xx_unregister_sysfs(chip);
> +       lp55xx_unregister_leds(led, chip);
> +       lp55xx_deinit_device(chip);
> +
> +       return 0;
> +}
> +
> +static const struct i2c_device_id lp8501_id[] = {
> +       { "lp8501",  0 },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(i2c, lp8501_id);
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id of_lp8501_leds_match[] = {
> +       { .compatible = "ti,lp8501", },
> +       {},
> +};
> +
> +MODULE_DEVICE_TABLE(of, of_lp8501_leds_match);
> +#endif
> +
> +static struct i2c_driver lp8501_driver = {
> +       .driver = {
> +               .name   = "lp8501",
> +               .of_match_table = of_match_ptr(of_lp8501_leds_match),
> +       },
> +       .probe          = lp8501_probe,
> +       .remove         = lp8501_remove,
> +       .id_table       = lp8501_id,
> +};
> +
> +module_i2c_driver(lp8501_driver);
> +
> +MODULE_DESCRIPTION("Texas Instruments LP8501 LED drvier");
> +MODULE_AUTHOR("Milo Kim");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/platform_data/leds-lp55xx.h b/include/linux/platform_data/leds-lp55xx.h
> index 202e290..51a2ff5 100644
> --- a/include/linux/platform_data/leds-lp55xx.h
> +++ b/include/linux/platform_data/leds-lp55xx.h
> @@ -36,6 +36,13 @@ struct lp55xx_predef_pattern {
>         u8 size_b;
>  };
>
> +enum lp8501_pwr_sel {
> +       LP8501_ALL_VDD,         /* D1~9 are connected to VDD */
> +       LP8501_6VDD_3VOUT,      /* D1~6 with VDD, D7~9 with VOUT */
> +       LP8501_3VDD_6VOUT,      /* D1~6 with VOUT, D7~9 with VDD */
> +       LP8501_ALL_VOUT,        /* D1~9 are connected to VOUT */
> +};
> +
>  /*
>   * struct lp55xx_platform_data
>   * @led_config        : Configurable led class device
> @@ -67,6 +74,9 @@ struct lp55xx_platform_data {
>         /* Predefined pattern data */
>         struct lp55xx_predef_pattern *patterns;
>         unsigned int num_patterns;
> +
> +       /* LP8501 specific */
> +       enum lp8501_pwr_sel pwr_sel;
>  };
>
>  #endif /* _LEDS_LP55XX_H */
> --
> 1.7.9.5
>
>
> Best Regards,
> Milo
>
>
