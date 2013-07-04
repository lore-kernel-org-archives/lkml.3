Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab3GDI71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:59:27 -0400
Received: from smtp-out-093.synserver.de ([212.40.185.93]:1074 "EHLO
	smtp-out-093.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3GDI7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:59:22 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29668
Message-ID: <51D53988.7040808@metafoo.de>
Date: Thu, 04 Jul 2013 10:59:52 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Kevin Tsai <ktsai@capellamicro.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/1] Added Capella CM3218 Ambient Light Sensor IIO Driver.
References: <1372894271-2592-1-git-send-email-ktsai@capellamicro.com>
In-Reply-To: <1372894271-2592-1-git-send-email-ktsai@capellamicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 01:31 AM, Kevin Tsai wrote:

Maybe write at least a short commit message which states the features of the
chip.

> Signed-off-by: Kevin Tsai <ktsai@capellamicro.com>
> ---
>  drivers/staging/iio/light/Kconfig  |   10 +
>  drivers/staging/iio/light/Makefile |    1 +
>  drivers/staging/iio/light/cm3218.c |  581 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 592 insertions(+)
>  create mode 100644 drivers/staging/iio/light/cm3218.c
> 
> diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
> index ca8d6e6..647af0c 100644
> --- a/drivers/staging/iio/light/Kconfig
> +++ b/drivers/staging/iio/light/Kconfig
> @@ -40,4 +40,14 @@ config TSL2x7x
>  	 tmd2672, tsl2772, tmd2772 devices.
>  	 Provides iio_events and direct access via sysfs.
>  
> +config SENSORS_CM3218
> +        tristate "CM3218 Ambient Light Sensor"
> +        depends on I2C
> +        help
> +         Say Y here if you have a Capella Micro CM3218 Ambient Light Sensor.
> +
> +         To compile this driver as a module, choose M here.  This module
> +         will be called to 'cm3218'.  It will access ALS data via iio sysfs.
> +         This is recommended.
> +

Keep the entries in alphabetical order.

>  endmenu
> diff --git a/drivers/staging/iio/light/Makefile b/drivers/staging/iio/light/Makefile
> index 9960fdf..63020ab 100644
> --- a/drivers/staging/iio/light/Makefile
> +++ b/drivers/staging/iio/light/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
>  obj-$(CONFIG_SENSORS_ISL29028)	+= isl29028.o
>  obj-$(CONFIG_TSL2583)	+= tsl2583.o
>  obj-$(CONFIG_TSL2x7x)	+= tsl2x7x_core.o
> +obj-$(CONFIG_SENSORS_CM3218)    += cm3218.o

Same here

> diff --git a/drivers/staging/iio/light/cm3218.c b/drivers/staging/iio/light/cm3218.c
> new file mode 100644
> index 0000000..9c2584d
> --- /dev/null
> +++ b/drivers/staging/iio/light/cm3218.c
> @@ -0,0 +1,581 @@
[...]
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>

delay.h seems to be unused

> +#include <linux/slab.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
[...]
> +
> +static int cm3218_write(struct i2c_client *client, u8 reg, u16 value)
> +{
> +	u16 regval;
> +	int ret;
> +	struct cm3218_chip *chip = iio_priv(i2c_get_clientdata(client));
> +
> +#ifdef	CM3218_DEBUG
> +	dev_err(&client->dev,
> +		"Write to device register 0x%02X with 0x%04X\n", reg, value);
> +#endif	/* CM3218_DEBUG */
> +	regval = cpu_to_le16(value);
> +	ret = i2c_smbus_write_word_data(client, reg, regval);

This looks wrong, with this code the on-wire byteorder will differ between
big endian and little endian systems. Maybe you want
i2c_smbus_write_word_swapped?

But as Peter said, just use regmap for all IO.

> +	if (ret) {
> +		dev_err(&client->dev, "Write to device fails: 0x%x\n", ret);
> +	} else {
> +		/* Update cache */
> +		if (reg < CM3218_MAX_CACHE_REGS)
> +			chip->reg_cache[reg] = value;
> +	}
> +
> +	return ret;
[...]
> +
> +static int cm3218_detect(struct i2c_client *client,
> +				   struct i2c_board_info *info)
> +{
> +	struct i2c_adapter *adapter = client->adapter;
> +	const char *name = NULL;
> +
> +	cm3218_read_ara(client);
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -ENODEV;
> +
> +	name = "cm3218";
> +	strlcpy(info->type, name, I2C_NAME_SIZE);
> +

Always returning zero means the chip will bind to any I2C devices which
happen to use the same address. I don't think you actually need detection,
so just remove it.

> +	return 0;
> +}
> +
> +static const struct i2c_device_id cm3218_id[] = {
> +	{"cm3218", 0},
> +	{}
> +};
> +

Nitpick: no need for the newline

> +MODULE_DEVICE_TABLE(i2c, cm3218_id);
> +
> +static const struct of_device_id cm3218_of_match[] = {
> +	{ .compatible = "invn,cm3218", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, cm3218_of_match);
> +
> +static struct i2c_driver cm3218_driver = {
> +	.class	= I2C_CLASS_HWMON,
> +	.driver	 = {
> +			.name = "cm3218",
> +			.pm = CM3218_PM_OPS,
> +			.owner = THIS_MODULE,
> +			.of_match_table = cm3218_of_match,
> +		    },

Indention looks a bit strange here. Please use one tab per level.

> +	.probe		= cm3218_probe,
> +	.remove		= cm3218_remove,
> +	.id_table       = cm3218_id,
> +	.detect	 = cm3218_detect,
> +	.address_list   = normal_i2c,
> +};
> +module_i2c_driver(cm3218_driver);
