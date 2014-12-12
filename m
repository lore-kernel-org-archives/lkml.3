Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968023AbaLLNfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:35:50 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48205 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967589AbaLLNft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:35:49 -0500
Message-ID: <548AEF33.4060209@kernel.org>
Date: Fri, 12 Dec 2014 13:35:47 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, pmeerw@pmeerw.net,
        srinivas.pandruvada@linux.intel.com, knaack.h@gmx.de
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] iio: imu: kmx61: Add acpi support
References: <1417613513-28285-1-git-send-email-daniel.baluta@intel.com> <1417613513-28285-3-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1417613513-28285-3-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/14 13:31, Daniel Baluta wrote:
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Applied to the togreg branch of iio.git

Thanks,

Jonathan
> ---
>  drivers/iio/imu/kmx61.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index 5b44371..893f7c8 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -13,10 +13,13 @@
>  
>  #include <linux/module.h>
>  #include <linux/i2c.h>
> +#include <linux/acpi.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/iio/iio.h>
>  #include <linux/iio/sysfs.h>
>  
>  #define KMX61_DRV_NAME "kmx61"
> +#define KMX61_GPIO_NAME "kmx61_int"
>  
>  #define KMX61_REG_WHO_AM_I	0x00
>  
> @@ -573,6 +576,44 @@ static const struct iio_info kmx61_mag_info = {
>  	.attrs			= &kmx61_mag_attribute_group,
>  };
>  
> +static const char *kmx61_match_acpi_device(struct device *dev)
> +{
> +	const struct acpi_device_id *id;
> +
> +	id = acpi_match_device(dev->driver->acpi_match_table, dev);
> +	if (!id)
> +		return NULL;
> +	return dev_name(dev);
> +}
> +
> +static int kmx61_gpio_probe(struct i2c_client *client, struct kmx61_data *data)
> +{
> +	struct device *dev;
> +	struct gpio_desc *gpio;
> +	int ret;
> +
> +	if (!client)
> +		return -EINVAL;
> +
> +	dev = &client->dev;
> +
> +	/* data ready gpio interrupt pin */
> +	gpio = devm_gpiod_get_index(dev, KMX61_GPIO_NAME, 0);
> +	if (IS_ERR(gpio)) {
> +		dev_err(dev, "acpi gpio get index failed\n");
> +		return PTR_ERR(gpio);
> +	}
> +
> +	ret = gpiod_direction_input(gpio);
> +	if (ret)
> +		return ret;
> +
> +	ret = gpiod_to_irq(gpio);
> +
> +	dev_dbg(dev, "GPIO resource, no:%d irq:%d\n", desc_to_gpio(gpio), ret);
> +	return ret;
> +}
> +
>  static struct iio_dev *kmx61_indiodev_setup(struct kmx61_data *data,
>  					    const struct iio_info *info,
>  					    const struct iio_chan_spec *chan,
> @@ -613,6 +654,13 @@ static int kmx61_probe(struct i2c_client *client,
>  
>  	mutex_init(&data->lock);
>  
> +	if (id)
> +		name = id->name;
> +	else if (ACPI_HANDLE(&client->dev))
> +		name = kmx61_match_acpi_device(&client->dev);
> +	else
> +		return -ENODEV;
> +
>  	data->acc_indio_dev =
>  		kmx61_indiodev_setup(data, &kmx61_acc_info,
>  				     kmx61_acc_channels,
> @@ -633,6 +681,9 @@ static int kmx61_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		return ret;
>  
> +	if (client->irq < 0)
> +		client->irq = kmx61_gpio_probe(client, data);
> +
>  	ret = iio_device_register(data->acc_indio_dev);
>  	if (ret < 0) {
>  		dev_err(&client->dev, "Failed to register acc iio device\n");
> @@ -668,6 +719,13 @@ static int kmx61_remove(struct i2c_client *client)
>  	return 0;
>  }
>  
> +static const struct acpi_device_id kmx61_acpi_match[] = {
> +	{"KMX61021", 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(acpi, kmx61_acpi_match);
> +
>  static const struct i2c_device_id kmx61_id[] = {
>  	{"kmx611021", 0},
>  	{}
> @@ -678,6 +736,7 @@ MODULE_DEVICE_TABLE(i2c, kmx61_id);
>  static struct i2c_driver kmx61_driver = {
>  	.driver = {
>  		.name = KMX61_DRV_NAME,
> +		.acpi_match_table = ACPI_PTR(kmx61_acpi_match),
>  	},
>  	.probe		= kmx61_probe,
>  	.remove		= kmx61_remove,
> 

