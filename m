Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaJ0HIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:08:42 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60710 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaJ0HIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:08:39 -0400
Message-ID: <544DEEC0.1000507@gmail.com>
Date: Mon, 27 Oct 2014 12:35:36 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: gyungoh@gmail.com, sameo@linux.intel.com, lee.jones@linaro.org,
        jg1.han@samsung.com, cooloney@gmail.com, broonie@kernel.org,
        lgirdwood@gmail.com
CC: jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v5 2/8] backlight: Add support Skyworks SKY81452
 backlight driver
References: <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com> <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com> <1414393369-31583-3-git-send-email-jack.yoo@skyworksinc.com>
In-Reply-To: <1414393369-31583-3-git-send-email-jack.yoo@skyworksinc.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 12:32 PM, gyungoh@gmail.com wrote:
> From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
>
> Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> ---
> Changes v5:
> Move sky81452-backlight.h to include/linux/platform_data
>
> Changes v4:
> Reordering header files for readability
> Removed calling to backlight_device_unregister()
> Removed MODULE_VERSION()
> Modified license to GPLv2
>
> Changes v3:
> Modified DBG messages
>
> Changes v2:
> Added 'compatible' attribute in the driver
> Added message for exception or errors
>
>   drivers/video/backlight/Kconfig                  |  10 +
>   drivers/video/backlight/Makefile                 |   1 +
>   drivers/video/backlight/sky81452-backlight.c     | 344 +++++++++++++++++++++++
>   include/linux/platform_data/sky81452-backlight.h |  47 ++++
>   4 files changed, 402 insertions(+)
>   create mode 100644 drivers/video/backlight/sky81452-backlight.c
>   create mode 100644 include/linux/platform_data/sky81452-backlight.h
>
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 8d03924..2586fdd 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -409,6 +409,16 @@ config BACKLIGHT_PANDORA
>   	  If you have a Pandora console, say Y to enable the
>   	  backlight driver.
>   
> +config BACKLIGHT_SKY81452
> +	tristate "Backlight driver for SKY81452"
> +	depends on BACKLIGHT_CLASS_DEVICE && MFD_SKY81452
> +	help
> +	  If you have a Skyworks SKY81452, say Y to enable the
> +	  backlight driver.
> +
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called sky81452-backlight
> +
>   config BACKLIGHT_TPS65217
>   	tristate "TPS65217 Backlight"
>   	depends on BACKLIGHT_CLASS_DEVICE && MFD_TPS65217
> diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
> index fcd50b73..d67073f 100644
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -50,6 +50,7 @@ obj-$(CONFIG_BACKLIGHT_PANDORA)		+= pandora_bl.o
>   obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
>   obj-$(CONFIG_BACKLIGHT_PWM)		+= pwm_bl.o
>   obj-$(CONFIG_BACKLIGHT_SAHARA)		+= kb3886_bl.o
> +obj-$(CONFIG_BACKLIGHT_SKY81452)	+= sky81452-backlight.o
>   obj-$(CONFIG_BACKLIGHT_TOSA)		+= tosa_bl.o
>   obj-$(CONFIG_BACKLIGHT_TPS65217)	+= tps65217_bl.o
>   obj-$(CONFIG_BACKLIGHT_WM831X)		+= wm831x_bl.o
> diff --git a/drivers/video/backlight/sky81452-backlight.c b/drivers/video/backlight/sky81452-backlight.c
> new file mode 100644
> index 0000000..a677be6
> --- /dev/null
> +++ b/drivers/video/backlight/sky81452-backlight.c
> @@ -0,0 +1,344 @@
> +/*
> + * sky81452-backlight.c	SKY81452 backlight driver
> + *
> + * Copyright 2014 Skyworks Solutions Inc.
> + * Author : Gyungoh Yoo <jack.yoo@skyworksinc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2, or (at your option) any
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/backlight.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/platform_data/sky81452-backlight.h>
> +#include <linux/slab.h>
> +
> +/* registers */
> +#define SKY81452_REG0	0x00
> +#define SKY81452_REG1	0x01
> +#define SKY81452_REG2	0x02
> +#define SKY81452_REG4	0x04
> +#define SKY81452_REG5	0x05
> +
> +/* bit mask */
> +#define SKY81452_CS	0xFF
> +#define SKY81452_EN	0x3F
> +#define SKY81452_IGPW	0x20
> +#define SKY81452_PWMMD	0x10
> +#define SKY81452_PHASE	0x08
> +#define SKY81452_ILIM	0x04
> +#define SKY81452_VSHRT	0x03
> +#define SKY81452_OCP	0x80
> +#define SKY81452_OTMP	0x40
> +#define SKY81452_SHRT	0x3F
> +#define SKY81452_OPN	0x3F
> +
> +#define SKY81452_DEFAULT_NAME "lcd-backlight"
> +#define SKY81452_MAX_BRIGHTNESS	(SKY81452_CS + 1)
> +
> +#define CTZ(b) __builtin_ctz(b)
> +
> +static int sky81452_bl_update_status(struct backlight_device *bd)
> +{
> +	const struct sky81452_bl_platform_data *pdata =
> +			dev_get_platdata(bd->dev.parent);
> +	const unsigned int brightness = (unsigned int)bd->props.brightness;
> +	struct regmap *regmap = bl_get_data(bd);
> +	int ret;
> +
> +	if (brightness > 0) {
> +		ret = regmap_write(regmap, SKY81452_REG0, brightness - 1);
> +		if (IS_ERR_VALUE(ret))
> +			return ret;
> +
> +		return regmap_update_bits(regmap, SKY81452_REG1, SKY81452_EN,
> +					pdata->enable << CTZ(SKY81452_EN));
> +	}
> +
> +	return regmap_update_bits(regmap, SKY81452_REG1, SKY81452_EN, 0);
> +}
> +
> +static int sky81452_bl_get_brightness(struct backlight_device *bd)
> +{
> +	return bd->props.brightness;
> +}
> +
> +static const struct backlight_ops sky81452_bl_ops = {
> +	.update_status = sky81452_bl_update_status,
> +	.get_brightness = sky81452_bl_get_brightness,
> +};
> +
> +static ssize_t sky81452_bl_store_enable(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct regmap *regmap = bl_get_data(to_backlight_device(dev));
> +	unsigned long value;
> +	int ret;
> +
> +	ret = kstrtoul(buf, 16, &value);
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	ret = regmap_update_bits(regmap, SKY81452_REG1, SKY81452_EN,
> +					value << CTZ(SKY81452_EN));
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	return count;
> +}
> +
> +static ssize_t sky81452_bl_show_open_short(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct regmap *regmap = bl_get_data(to_backlight_device(dev));
> +	unsigned int reg, value = 0;
> +	char tmp[3];
> +	int i, ret;
> +
> +	reg = !strcmp(attr->attr.name, "open") ? SKY81452_REG5 : SKY81452_REG4;
> +	ret = regmap_read(regmap, reg, &value);
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	if (value & SKY81452_SHRT) {
> +		*buf = 0;
> +		for (i = 0; i < 6; i++) {
> +			if (value & 0x01) {
> +				sprintf(tmp, "%d ", i + 1);
> +				strcat(buf, tmp);
> +			}
> +			value >>= 1;
> +		}
> +		strcat(buf, "\n");
> +	} else {
> +		strcpy(buf, "none\n");
> +	}
> +
> +	return strlen(buf);
> +}
> +
> +static ssize_t sky81452_bl_show_fault(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct regmap *regmap = bl_get_data(to_backlight_device(dev));
> +	unsigned int value = 0;
> +	int ret;
> +
> +	ret = regmap_read(regmap, SKY81452_REG4, &value);
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	*buf = 0;
> +
> +	if (value & SKY81452_OCP)
> +		strcat(buf, "over-current ");
> +
> +	if (value & SKY81452_OTMP)
> +		strcat(buf, "over-temperature");
> +
> +	strcat(buf, "\n");
> +	return strlen(buf);
> +}
> +
> +static DEVICE_ATTR(enable, S_IWGRP | S_IWUSR, NULL, sky81452_bl_store_enable);
> +static DEVICE_ATTR(open, S_IRUGO, sky81452_bl_show_open_short, NULL);
> +static DEVICE_ATTR(short, S_IRUGO, sky81452_bl_show_open_short, NULL);
> +static DEVICE_ATTR(fault, S_IRUGO, sky81452_bl_show_fault, NULL);
> +
> +static struct attribute *sky81452_bl_attribute[] = {
> +	&dev_attr_enable.attr,
> +	&dev_attr_open.attr,
> +	&dev_attr_short.attr,
> +	&dev_attr_fault.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group sky81452_bl_attr_group = {
> +	.attrs = sky81452_bl_attribute,
> +};
> +
> +#ifdef CONFIG_OF
> +static struct sky81452_bl_platform_data *sky81452_bl_parse_dt(
> +							struct device *dev)
> +{
> +	struct device_node *np = of_node_get(dev->of_node);
> +	struct sky81452_bl_platform_data *pdata;
> +	int ret;
> +
> +	if (!np) {
> +		dev_err(dev, "backlight node not found");

Missed terminating new line all over the driver for debug error messages..

-- 
Regards,
Varka Bhadram.

