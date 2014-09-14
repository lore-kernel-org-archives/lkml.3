Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaINRmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:42:38 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55778 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaINRmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:42:37 -0400
Message-ID: <5415D388.60300@kernel.org>
Date: Sun, 14 Sep 2014 18:42:32 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org, Denis CIOCCA <denis.ciocca@st.com>
Subject: Re: [PATCH] iio: gyro: bmi055 gyro sensor driver
References: <1409655597-28781-1-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1409655597-28781-1-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/14 11:59, Irina Tirdea wrote:
> Add support for the BMI055 gyroscope sensor. BMI055 is a package
> consisting of an acceleration sensor and a gyroscope. This patch
> adds support for the gyroscope only.
> 
> Spec downloaded from:
> http://ae-bst.resource.bosch.com/media/products/dokumente/bmi055/BST-BMI055-DS000-06.pdf
> 
> The BMI055 gyroscope uses the same register definition as BMG160,
> but does not specify a temp register. However, the temp register
> seems to be working in the same way as for BMG160, so this patch
> does not remove the temp channel for BMI055.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
I would have slightly preferred this as a two patch series. The first
would do the reworked sections of code, and the second actually add the device.
Still it is pretty simple, so I'll let it go

applied to the togreg branch of iio.git - pushed out initially as testing for the
autobuilders to play.

Thanks,

Jonathan
> ---
>  drivers/iio/gyro/Kconfig  |    2 +-
>  drivers/iio/gyro/bmg160.c |   39 +++++++++++++++++++++++++++------------
>  2 files changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/iio/gyro/Kconfig b/drivers/iio/gyro/Kconfig
> index d630ae9..b3d0e94 100644
> --- a/drivers/iio/gyro/Kconfig
> +++ b/drivers/iio/gyro/Kconfig
> @@ -56,7 +56,7 @@ config BMG160
>  	select IIO_TRIGGERED_BUFFER if IIO_BUFFER
>  	help
>  	  Say yes here to build support for Bosch BMG160 Tri-axis Gyro Sensor
> -	  driver.
> +	  driver. This driver also supports BMI055 gyroscope.
>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called bmg160.
> diff --git a/drivers/iio/gyro/bmg160.c b/drivers/iio/gyro/bmg160.c
> index 80f92a6..7524698 100644
> --- a/drivers/iio/gyro/bmg160.c
> +++ b/drivers/iio/gyro/bmg160.c
> @@ -947,10 +947,10 @@ static irqreturn_t bmg160_data_rdy_trig_poll(int irq, void *private)
>  
>  }
>  
> -static int bmg160_acpi_gpio_probe(struct i2c_client *client,
> -				  struct bmg160_data *data)
> +static int bmg160_gpio_probe(struct i2c_client *client,
> +			     struct bmg160_data *data)
> +
>  {
> -	const struct acpi_device_id *id;
>  	struct device *dev;
>  	struct gpio_desc *gpio;
>  	int ret;
> @@ -959,12 +959,6 @@ static int bmg160_acpi_gpio_probe(struct i2c_client *client,
>  		return -EINVAL;
>  
>  	dev = &client->dev;
> -	if (!ACPI_HANDLE(dev))
> -		return -ENODEV;
> -
> -	id = acpi_match_device(dev->driver->acpi_match_table, dev);
> -	if (!id)
> -		return -ENODEV;
>  
>  	/* data ready gpio interrupt pin */
>  	gpio = devm_gpiod_get_index(dev, BMG160_GPIO_NAME, 0);
> @@ -984,12 +978,24 @@ static int bmg160_acpi_gpio_probe(struct i2c_client *client,
>  	return ret;
>  }
>  
> +static const char *bmg160_match_acpi_device(struct device *dev)
> +{
> +	const struct acpi_device_id *id;
> +
> +	id = acpi_match_device(dev->driver->acpi_match_table, dev);
> +	if (!id)
> +		return NULL;
> +
> +	return dev_name(dev);
> +}
> +
>  static int bmg160_probe(struct i2c_client *client,
>  			const struct i2c_device_id *id)
>  {
>  	struct bmg160_data *data;
>  	struct iio_dev *indio_dev;
>  	int ret;
> +	const char *name = NULL;
>  
>  	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
>  	if (!indio_dev)
> @@ -1005,15 +1011,21 @@ static int bmg160_probe(struct i2c_client *client,
>  
>  	mutex_init(&data->mutex);
>  
> +	if (id)
> +		name = id->name;
> +
> +	if (ACPI_HANDLE(&client->dev))
> +		name = bmg160_match_acpi_device(&client->dev);
> +
>  	indio_dev->dev.parent = &client->dev;
>  	indio_dev->channels = bmg160_channels;
>  	indio_dev->num_channels = ARRAY_SIZE(bmg160_channels);
> -	indio_dev->name = BMG160_DRV_NAME;
> +	indio_dev->name = name;
>  	indio_dev->modes = INDIO_DIRECT_MODE;
>  	indio_dev->info = &bmg160_info;
>  
>  	if (client->irq <= 0)
> -		client->irq = bmg160_acpi_gpio_probe(client, data);
> +		client->irq = bmg160_gpio_probe(client, data);
>  
>  	if (client->irq > 0) {
>  		ret = devm_request_threaded_irq(&client->dev,
> @@ -1183,12 +1195,15 @@ static const struct dev_pm_ops bmg160_pm_ops = {
>  
>  static const struct acpi_device_id bmg160_acpi_match[] = {
>  	{"BMG0160", 0},
> -	{ },
> +	{"BMI055B", 0},
> +	{},
>  };
> +
>  MODULE_DEVICE_TABLE(acpi, bmg160_acpi_match);
>  
>  static const struct i2c_device_id bmg160_id[] = {
>  	{"bmg160", 0},
> +	{"bmi055_gyro", 0},
>  	{}
>  };
>  
> 
