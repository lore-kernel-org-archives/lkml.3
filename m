Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab3JNWiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 18:38:18 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:34460 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab3JNWiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:38:15 -0400
Date: Tue, 15 Oct 2013 00:38:13 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: =?UTF-8?Q?Maximilian_G=C3=BCntner?= <maximilian.guentner@gmail.com>
cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-leds <linux-leds@vger.kernel.org>
Subject: Re: [PATCH] leds: Added driver for the NXP PCA9685 I2C chip
In-Reply-To: <2819232.mPNW6mO2uH@titan>
Message-ID: <alpine.DEB.2.01.1310150015370.26447@pmeerw.net>
References: <2819232.mPNW6mO2uH@titan>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1985424466-1406653067-1381790293=:26447"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1985424466-1406653067-1381790293=:26447
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


> The NXP PCA9685 supports 16 channels/leds using a 12-bit PWM (4095
> levels of brightness)
> This driver supports configuration using platform_data.

some nitpicking inline
 
> Signed-off-by: Maximilian Güntner <maximilian.guentner@gmail.com>
> ---
>  drivers/leds/Kconfig                       |  10 ++
>  drivers/leds/Makefile                      |   1 +
>  drivers/leds/leds-pca9685.c                | 219 +++++++++++++++++++++++++++++
>  include/linux/platform_data/leds-pca9685.h |  34 +++++
>  4 files changed, 264 insertions(+)
>  create mode 100644 drivers/leds/leds-pca9685.c
>  create mode 100644 include/linux/platform_data/leds-pca9685.h
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 875bbe4..98268b3 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -300,6 +300,16 @@ config LEDS_PCA963X
>  	  LED driver chip accessed via the I2C bus. Supported
>  	  devices include PCA9633 and PCA9634
>  
> +config LEDS_PCA9685
> +	tristate "LED support for PCA9685 I2C chip"
> +	depends on LEDS_CLASS
> +	depends on I2C
> +	help
> +	  This option enables support for LEDs connected to the PCA9685
> +	  LED driver chips accessed via the I2C bus.

chip

> +	  The PCA9685 offers 12-bit PWM (4095 levels of brightness) on
> +	  16 individual channels.
> +
>  config LEDS_WM831X_STATUS
>  	tristate "LED support for status LEDs on WM831x PMICs"
>  	depends on LEDS_CLASS
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 8979b0b..3cd76db 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_LEDS_OT200)		+= leds-ot200.o
>  obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
>  obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
>  obj-$(CONFIG_LEDS_PCA963X)		+= leds-pca963x.o
> +obj-$(CONFIG_LEDS_PCA9685)		+= leds-pca9685.o
>  obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
>  obj-$(CONFIG_LEDS_DA9052)		+= leds-da9052.o
>  obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
> diff --git a/drivers/leds/leds-pca9685.c b/drivers/leds/leds-pca9685.c
> new file mode 100644
> index 0000000..a2078bf
> --- /dev/null
> +++ b/drivers/leds/leds-pca9685.c
> @@ -0,0 +1,219 @@
> +/*
> + * Copyright 2013 Maximilian Güntner <maximilian.guentner@gmail.com>
> + *
> + * This file is subject to the terms and conditions of version 2 of
> + * the GNU General Public License.  See the file COPYING in the main
> + * directory of this archive for more details.
> + *
> + * Based on leds-pca963x.c driver by
> + * Peter Meerwald <p.meerwald@bct-electronic.com>
> + *
> + * Driver for the NXP PCA9685 12-Bit I2C chip.

this could be more descriptive: 12-bit PWM LED driver chip

> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <linux/delay.h>
> +#include <linux/ctype.h>
> +#include <linux/leds.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/workqueue.h>
> +#include <linux/slab.h>
> +
> +#include <linux/platform_data/leds-pca9685.h>
> +
> +/* Register Addresses */
> +#define PCA9685_MODE1 0x00
> +#define PCA9685_MODE2 0x01
> +#define PCA9685_LED0_ON_L 0x06
> +#define PCA9685_ALL_LED_ON_L 0xFA
> +
> +/* MODE1 Register */
> +#define PCA9685_ALLCALL 0x00
> +#define PCA9685_SLEEP   0x04
> +#define PCA9685_AI      0x05
> +
> +/* MODE2 Register */
> +#define PCA9685_INVRT   0x04
> +#define PCA9685_OUTDRV  0x02
> +
> +static const struct i2c_device_id pca9685_id[] = {
> +	{ "pca9685", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, pca9685_id);
> +
> +struct pca9685_led {
> +	struct i2c_client *client;
> +	struct work_struct work;
> +	u16 brightness;
> +	struct led_classdev led_cdev;
> +	int led_num; /* 0-15 */
> +	char name[32];
> +};
> +
> +static void pca9685_write_msg(struct i2c_client *client, u8 *buf, u8 len)
> +{
> +	struct i2c_msg msg = {
> +		.addr = client->addr,
> +		.flags = 0x00,
> +		.len = len,
> +		.buf = buf
> +	};
> +	i2c_transfer(client->adapter, &msg, 1);
> +}
> +
> +static void pca9685_all_off(struct i2c_client *client)
> +{
> +	u8 i2c_buffer[5] = {PCA9685_ALL_LED_ON_L, 0x00, 0x00, 0x00, 0x10};
> +	pca9685_write_msg(client, i2c_buffer, 5);
> +}
> +
> +static void pca9685_led_work(struct work_struct *work)
> +{
> +	struct pca9685_led *pca9685;
> +	u16 brightness;
> +	u8 i2c_buffer[5];
> +	pca9685 = container_of(work, struct pca9685_led, work);
> +	/*
> +	 * 4095 is the maximum brightness, so we set the ON time to 0x1000
> +	 * which disables the PWM generator for that LED
> +	 */
> +	if (pca9685->brightness == 4095)
> +		brightness = 4096;

why not check for 4095 instead of 4096 below and save this if statement?

> +	else
> +		brightness = pca9685->brightness;
> +
> +	i2c_buffer[0] = PCA9685_LED0_ON_L + 4 * pca9685->led_num;
> +
> +	if (brightness == 4096)
> +		*((u16 *)(i2c_buffer+1)) = cpu_to_le16(0x1000);
> +	else
> +		*((u16 *)(i2c_buffer+1)) = 0x0000;
> +	if (brightness == 0)
> +		*((u16 *)(i2c_buffer+3)) = cpu_to_le16(0x1000);
> +	else if (brightness == 4096)
> +		*((u16 *)(i2c_buffer+3)) = 0x0000;
> +	else
> +		*((u16 *)(i2c_buffer+3)) = cpu_to_le16(brightness);
> +
> +	pca9685_write_msg(pca9685->client, i2c_buffer, 5);
> +}
> +
> +static void pca9685_led_set(struct led_classdev *led_cdev,
> +		enum led_brightness value)
> +{
> +	struct pca9685_led *pca9685;
> +	pca9685 = container_of(led_cdev, struct pca9685_led, led_cdev);
> +	pca9685->brightness = value;
> +
> +	schedule_work(&pca9685->work);
> +}
> +
> +static int pca9685_probe(struct i2c_client *client,
> +		const struct i2c_device_id *id)
> +{
> +	struct pca9685_led *pca9685;
> +	struct pca9685_platform_data *pdata;
> +	int err;
> +	u8 i;
> +
> +	pdata = dev_get_platdata(&client->dev);
> +
> +	if (pdata) {
> +		if (pdata->leds.num_leds < 1 || pdata->leds.num_leds > 15) {
> +			dev_err(&client->dev, "board info must claim 1-16 LEDs");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	pca9685 = devm_kzalloc(&client->dev, 16 * sizeof(*pca9685), GFP_KERNEL);
> +
> +	if (!pca9685)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(client, pca9685);
> +	pca9685_all_off(client);
> +
> +	for (i = 0; i < 16; i++) {
> +		pca9685[i].client = client;
> +		pca9685[i].led_num = i;
> +		pca9685[i].name[0] = '\0';
> +		if (pdata && i < pdata->leds.num_leds) {
> +			if (pdata->leds.leds[i].name)
> +				strncpy(pca9685[i].name,
> +					pdata->leds.leds[i].name,
> +					sizeof(pca9685[i].name)-1);
> +			if (pdata->leds.leds[i].default_trigger)
> +				pca9685[i].led_cdev.default_trigger =
> +					pdata->leds.leds[i].default_trigger;
> +		}
> +		if (strlen(pca9685[i].name) == 0) {
> +			/*
> +			 * Write adapter and address to the name as well.
> +			 * Otherwise multiple chips attached to one host would
> +			 * not work.
> +			 */
> +			snprintf(pca9685[i].name, sizeof(pca9685[i].name),
> +					"pca9685:%d:x%.2x:%d",
> +					client->adapter->nr, client->addr, i);
> +		}
> +		pca9685[i].led_cdev.name = pca9685[i].name;
> +		pca9685[i].led_cdev.max_brightness = 0xfff;
> +		pca9685[i].led_cdev.brightness_set = pca9685_led_set;
> +
> +		INIT_WORK(&pca9685[i].work, pca9685_led_work);
> +		err = led_classdev_register(&client->dev, &pca9685[i].led_cdev);
> +		if (err < 0)
> +			goto exit;
> +	}
> +	if (pdata)
> +		i2c_smbus_write_byte_data(client, PCA9685_MODE2,
> +			pdata->outdrv << PCA9685_OUTDRV |
> +			pdata->inverted << PCA9685_INVRT);
> +	else
> +		i2c_smbus_write_byte_data(client, PCA9685_MODE2,
> +			PCA9685_TOTEM_POLE << PCA9685_OUTDRV);
> +	/* Enable Auto-Increment, enable oscillator, ALLCALL/SUBADDR disabled */
> +	i2c_smbus_write_byte_data(client, PCA9685_MODE1, 1 << PCA9685_AI);

maybe BIT(PCA9685_AI)

> +
> +	return 0;
> +
> +exit:
> +	while (i--) {
> +		led_classdev_unregister(&pca9685[i].led_cdev);
> +		cancel_work_sync(&pca9685[i].work);
> +	}
> +	return err;
> +}
> +
> +static int pca9685_remove(struct i2c_client *client)
> +{
> +	struct pca9685_led *pca9685 = i2c_get_clientdata(client);
> +	u8 i;
> +
> +	for (i = 0; i < 16; i++) {
> +		led_classdev_unregister(&pca9685[i].led_cdev);
> +		cancel_work_sync(&pca9685[i].work);
> +	}
> +	pca9685_all_off(client);
> +	return 0;
> +}
> +
> +static struct i2c_driver pca9685_driver = {
> +	.driver = {
> +		.name = "leds-pca9685",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = pca9685_probe,
> +	.remove = pca9685_remove,
> +	.id_table = pca9685_id,
> +};
> +
> +module_i2c_driver(pca9685_driver);
> +
> +MODULE_AUTHOR("Maximilian Güntner <maximilian.guentner@gmail.com>");
> +MODULE_DESCRIPTION("PCA9685 LED Driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/platform_data/leds-pca9685.h b/include/linux/platform_data/leds-pca9685.h
> new file mode 100644
> index 0000000..cce28b8
> --- /dev/null
> +++ b/include/linux/platform_data/leds-pca9685.h
> @@ -0,0 +1,34 @@
> +/*
> + * Copyright 2013 Maximilian Güntner <maximilian.guentner@gmail.com>
> + *
> + * This file is subject to the terms and conditions of version 2 of
> + * the GNU General Public License.  See the file COPYING in the main
> + * directory of this archive for more details.
> + *
> + * Based on leds-pca963x.h by Peter Meerwald <p.meerwald@bct-electronic.com>
> + *
> + * LED driver for the NXP PCA9685 PWM chip
> + *
> + */
> +
> +#ifndef __LINUX_PCA9685_H
> +#define __LINUX_PCA9685_H
> +#include <linux/leds.h>
> +
> +enum pca9685_outdrv {
> +	PCA9685_OPEN_DRAIN,
> +	PCA9685_TOTEM_POLE,
> +};
> +
> +enum pca9685_inverted {
> +	PCA9685_NOT_INVERTED,
> +	PCA9685_INVERTED,
> +};
> +
> +struct pca9685_platform_data {
> +	struct led_platform_data leds;
> +	enum pca9685_outdrv outdrv;
> +	enum pca9685_inverted inverted;
> +};
> +
> +#endif /* __LINUX_PCA9685_H */
> 

-- 

Peter Meerwald
+43-664-2444418 (mobile)
--1985424466-1406653067-1381790293=:26447--
