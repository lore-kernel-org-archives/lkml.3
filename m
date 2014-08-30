Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaH3Kjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:39:53 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60840 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaH3Kjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:39:51 -0400
Message-ID: <5401A9F3.4090006@kernel.org>
Date: Sat, 30 Aug 2014 11:39:47 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Derek Basehore <dbasehore@chromium.org>,
        Teodora Baluta <teodora.baluta@intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: iio: light: isl29018: add ACPI support
References: <1409322382-30021-1-git-send-email-laurentiu.palcu@intel.com> <1409322382-30021-4-git-send-email-laurentiu.palcu@intel.com>
In-Reply-To: <1409322382-30021-4-git-send-email-laurentiu.palcu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 15:26, Laurentiu Palcu wrote:
> Add support for enumerating the device through ACPI.
>
> Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
Mostly fine, but I'm unclear on why we have a cast to a char * for name.

Maybe I just haven't had enough coffee this morning :)

Jonathan
> ---
>  drivers/staging/iio/light/isl29018.c | 46 +++++++++++++++++++++++++++++++-----
>  1 file changed, 40 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
> index b50f126..c54c6ae 100644
> --- a/drivers/staging/iio/light/isl29018.c
> +++ b/drivers/staging/iio/light/isl29018.c
> @@ -30,6 +30,7 @@
>  #include <linux/slab.h>
>  #include <linux/iio/iio.h>
>  #include <linux/iio/sysfs.h>
> +#include <linux/acpi.h>
>
>  #define CONVERSION_TIME_MS		100
>
> @@ -656,12 +657,28 @@ static const struct chip_info chip_info_tbl[] = {
>  	},
>  };
>
> +static char *isl29018_match_acpi_device(struct device *dev, int *data)
> +{
> +	const struct acpi_device_id *id;
> +
> +	id = acpi_match_device(dev->driver->acpi_match_table, dev);
> +
> +	if (!id)
> +		return NULL;
> +
> +	*data = (int) id->driver_data;
> +
> +	return (char *) dev_name(dev);
Silly question, but what is wrong with const char * as the return type?
Where this name ultimately ends up is a const char * anyway so you cast
the const away and then back again.
> +}
> +
>  static int isl29018_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *id)
>  {
>  	struct isl29018_chip *chip;
>  	struct iio_dev *indio_dev;
>  	int err;
> +	char *name = NULL;
const char *

> +	int dev_id = 0;
>
>  	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*chip));
>  	if (indio_dev == NULL) {
> @@ -673,9 +690,17 @@ static int isl29018_probe(struct i2c_client *client,
>  	i2c_set_clientdata(client, indio_dev);
>  	chip->dev = &client->dev;
>
> +	if (id) {
> +		name = (char *) id->name;
> +		dev_id = id->driver_data;
> +	}
> +
> +	if (ACPI_HANDLE(&client->dev))
> +		name = isl29018_match_acpi_device(&client->dev, &dev_id);
> +
>  	mutex_init(&chip->lock);
>
> -	chip->type = id->driver_data;
> +	chip->type = dev_id;
>  	chip->lux_scale = 1;
>  	chip->lux_uscale = 0;
>  	chip->range = 1000;
> @@ -683,7 +708,7 @@ static int isl29018_probe(struct i2c_client *client,
>  	chip->suspended = false;
>
>  	chip->regmap = devm_regmap_init_i2c(client,
> -				chip_info_tbl[id->driver_data].regmap_cfg);
> +				chip_info_tbl[dev_id].regmap_cfg);
>  	if (IS_ERR(chip->regmap)) {
>  		err = PTR_ERR(chip->regmap);
>  		dev_err(chip->dev, "regmap initialization failed: %d\n", err);
> @@ -694,10 +719,10 @@ static int isl29018_probe(struct i2c_client *client,
>  	if (err)
>  		return err;
>
> -	indio_dev->info = chip_info_tbl[id->driver_data].indio_info;
> -	indio_dev->channels = chip_info_tbl[id->driver_data].channels;
> -	indio_dev->num_channels = chip_info_tbl[id->driver_data].num_channels;
> -	indio_dev->name = id->name;
> +	indio_dev->info = chip_info_tbl[dev_id].indio_info;
> +	indio_dev->channels = chip_info_tbl[dev_id].channels;
> +	indio_dev->num_channels = chip_info_tbl[dev_id].num_channels;
> +	indio_dev->name = name;
>  	indio_dev->dev.parent = &client->dev;
>  	indio_dev->modes = INDIO_DIRECT_MODE;
>  	err = devm_iio_device_register(&client->dev, indio_dev);
> @@ -747,6 +772,14 @@ static SIMPLE_DEV_PM_OPS(isl29018_pm_ops, isl29018_suspend, isl29018_resume);
>  #define ISL29018_PM_OPS NULL
>  #endif
>
> +static const struct acpi_device_id isl29018_acpi_match[] = {
> +	{"ISL29018", isl29018},
> +	{"ISL29023", isl29023},
> +	{"ISL29035", isl29035},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(acpi, isl29018_acpi_match);
> +
>  static const struct i2c_device_id isl29018_id[] = {
>  	{"isl29018", isl29018},
>  	{"isl29023", isl29023},
> @@ -768,6 +801,7 @@ static struct i2c_driver isl29018_driver = {
>  	.class	= I2C_CLASS_HWMON,
>  	.driver	 = {
>  			.name = "isl29018",
> +			.acpi_match_table = ACPI_PTR(isl29018_acpi_match),
>  			.pm = ISL29018_PM_OPS,
>  			.owner = THIS_MODULE,
>  			.of_match_table = isl29018_of_match,
>
