Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaINOKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 10:10:39 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:54579 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaINOKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 10:10:37 -0400
Message-ID: <5415A1DB.40103@kernel.org>
Date: Sun, 14 Sep 2014 15:10:35 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>
CC: knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: accel: kxcjk-1013: add support for kxtj2-1009
References: <1409729595-16665-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1409729595-16665-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 08:33, Daniel Baluta wrote:
> This patch adds support for KXTJ2-1009 3-axis acceleromenter sensor.
> KXTJ2-1009 uses the same register definitions as KXCJK-1013.
> 
> The specification for KXTJ2-1009 can be downloaded from:
> http://www.kionix.com/sites/default/files/KXTJ2-1009%20Specifications%20Rev%204.pdf
> 
> Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Applied to the togreg branch of iio.git - initially pushed out as testing for the
autobuilders to play.

Thanks,

Jonathan
> ---
>  drivers/iio/accel/Kconfig      |   3 +-
>  drivers/iio/accel/kxcjk-1013.c | 111 +++++++++++++++++++++++++++++++++--------
>  2 files changed, 92 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
> index 01b857e..df930ae 100644
> --- a/drivers/iio/accel/Kconfig
> +++ b/drivers/iio/accel/Kconfig
> @@ -97,7 +97,8 @@ config KXCJK1013
>  	select IIO_TRIGGERED_BUFFER
>  	help
>  	  Say Y here if you want to build a driver for the Kionix KXCJK-1013
> -	  triaxial acceleration sensor. This driver also supports KXCJ9-1008.
> +	  triaxial acceleration sensor. This driver also supports KXCJ9-1008
> +	  and KXTJ2-1009.
>  
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called kxcjk-1013.
> diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
> index 736231d..615fce2 100644
> --- a/drivers/iio/accel/kxcjk-1013.c
> +++ b/drivers/iio/accel/kxcjk-1013.c
> @@ -85,6 +85,13 @@
>  
>  #define KXCJK1013_DEFAULT_WAKE_THRES	1
>  
> +enum kx_chipset {
> +	KXCJK1013,
> +	KXCJ91008,
> +	KXTJ21009,
> +	KX_MAX_CHIPS /* this must be last */
> +};
> +
>  struct kxcjk1013_data {
>  	struct i2c_client *client;
>  	struct iio_trigger *dready_trig;
> @@ -100,6 +107,7 @@ struct kxcjk1013_data {
>  	int ev_enable_state;
>  	bool motion_trigger_on;
>  	int64_t timestamp;
> +	enum kx_chipset chipset;
>  };
>  
>  enum kxcjk1013_axis {
> @@ -133,10 +141,53 @@ static const struct {
>  static const struct {
>  	int odr_bits;
>  	int usec;
> -} odr_start_up_times[] = { {0x08, 100000}, {0x09, 100000}, {0x0A, 100000},
> -			   {0x0B, 100000}, { 0, 80000}, {0x01, 41000},
> -			   {0x02, 21000}, {0x03, 11000}, {0x04, 6400},
> -			   {0x05, 3900}, {0x06, 2700}, {0x07, 2100} };
> +} odr_start_up_times[KX_MAX_CHIPS][12] = {
> +	/* KXCJK-1013 */
> +	{
> +		{0x08, 100000},
> +		{0x09, 100000},
> +		{0x0A, 100000},
> +		{0x0B, 100000},
> +		{0, 80000},
> +		{0x01, 41000},
> +		{0x02, 21000},
> +		{0x03, 11000},
> +		{0x04, 6400},
> +		{0x05, 3900},
> +		{0x06, 2700},
> +		{0x07, 2100},
> +	},
> +	/* KXCJ9-1008 */
> +	{
> +		{0x08, 100000},
> +		{0x09, 100000},
> +		{0x0A, 100000},
> +		{0x0B, 100000},
> +		{0, 80000},
> +		{0x01, 41000},
> +		{0x02, 21000},
> +		{0x03, 11000},
> +		{0x04, 6400},
> +		{0x05, 3900},
> +		{0x06, 2700},
> +		{0x07, 2100},
> +	},
> +	/* KXCTJ2-1009 */
> +	{
> +		{0x08, 1240000},
> +		{0x09, 621000},
> +		{0x0A, 309000},
> +		{0x0B, 151000},
> +		{0, 80000},
> +		{0x01, 41000},
> +		{0x02, 21000},
> +		{0x03, 11000},
> +		{0x04, 6000},
> +		{0x05, 4000},
> +		{0x06, 3000},
> +		{0x07, 2000},
> +	},
> +};
>  
>  static const struct {
>  	u16 scale;
> @@ -310,10 +361,11 @@ static int kxcjk1013_chip_init(struct kxcjk1013_data *data)
>  static int kxcjk1013_get_startup_times(struct kxcjk1013_data *data)
>  {
>  	int i;
> +	int idx = data->chipset;
>  
> -	for (i = 0; i < ARRAY_SIZE(odr_start_up_times); ++i) {
> -		if (odr_start_up_times[i].odr_bits == data->odr_bits)
> -			return odr_start_up_times[i].usec;
> +	for (i = 0; i < ARRAY_SIZE(odr_start_up_times[idx]); ++i) {
> +		if (odr_start_up_times[idx][i].odr_bits == data->odr_bits)
> +			return odr_start_up_times[idx][i].usec;
>  	}
>  
>  	return KXCJK1013_MAX_STARTUP_TIME_US;
> @@ -1074,10 +1126,21 @@ static irqreturn_t kxcjk1013_data_rdy_trig_poll(int irq, void *private)
>  		return IRQ_HANDLED;
>  }
>  
> -static int kxcjk1013_acpi_gpio_probe(struct i2c_client *client,
> -				     struct kxcjk1013_data *data)
> +static const char *kxcjk1013_match_acpi_device(struct device *dev,
> +					       enum kx_chipset *chipset)
>  {
>  	const struct acpi_device_id *id;
> +	id = acpi_match_device(dev->driver->acpi_match_table, dev);
> +	if (!id)
> +		return NULL;
> +	*chipset = (enum kx_chipset)id->driver_data;
> +
> +	return dev_name(dev);
> +}
> +
> +static int kxcjk1013_gpio_probe(struct i2c_client *client,
> +				struct kxcjk1013_data *data)
> +{
>  	struct device *dev;
>  	struct gpio_desc *gpio;
>  	int ret;
> @@ -1086,12 +1149,6 @@ static int kxcjk1013_acpi_gpio_probe(struct i2c_client *client,
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
>  	gpio = devm_gpiod_get_index(dev, "kxcjk1013_int", 0);
> @@ -1117,6 +1174,7 @@ static int kxcjk1013_probe(struct i2c_client *client,
>  	struct kxcjk1013_data *data;
>  	struct iio_dev *indio_dev;
>  	struct kxcjk_1013_platform_data *pdata;
> +	const char *name;
>  	int ret;
>  
>  	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
> @@ -1133,6 +1191,15 @@ static int kxcjk1013_probe(struct i2c_client *client,
>  	else
>  		data->active_high_intr = true; /* default polarity */
>  
> +	if (id) {
> +		data->chipset = (enum kx_chipset)(id->driver_data);
> +		name = id->name;
> +	} else if (ACPI_HANDLE(&client->dev)) {
> +		name = kxcjk1013_match_acpi_device(&client->dev,
> +						   &data->chipset);
> +	} else
> +		return -ENODEV;
> +
>  	ret = kxcjk1013_chip_init(data);
>  	if (ret < 0)
>  		return ret;
> @@ -1142,12 +1209,12 @@ static int kxcjk1013_probe(struct i2c_client *client,
>  	indio_dev->dev.parent = &client->dev;
>  	indio_dev->channels = kxcjk1013_channels;
>  	indio_dev->num_channels = ARRAY_SIZE(kxcjk1013_channels);
> -	indio_dev->name = KXCJK1013_DRV_NAME;
> +	indio_dev->name = name;
>  	indio_dev->modes = INDIO_DIRECT_MODE;
>  	indio_dev->info = &kxcjk1013_info;
>  
>  	if (client->irq < 0)
> -		client->irq = kxcjk1013_acpi_gpio_probe(client, data);
> +		client->irq = kxcjk1013_gpio_probe(client, data);
>  
>  	if (client->irq >= 0) {
>  		ret = devm_request_threaded_irq(&client->dev, client->irq,
> @@ -1325,15 +1392,17 @@ static const struct dev_pm_ops kxcjk1013_pm_ops = {
>  };
>  
>  static const struct acpi_device_id kx_acpi_match[] = {
> -	{"KXCJ1013", 0},
> -	{"KXCJ1008", 0},
> +	{"KXCJ1013", KXCJK1013},
> +	{"KXCJ1008", KXCJ91008},
> +	{"KXTJ1009", KXTJ21009},
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(acpi, kx_acpi_match);
>  
>  static const struct i2c_device_id kxcjk1013_id[] = {
> -	{"kxcjk1013", 0},
> -	{"kxcj91008", 0},
> +	{"kxcjk1013", KXCJK1013},
> +	{"kxcj91008", KXCJ91008},
> +	{"kxtj21009", KXTJ21009},
>  	{}
>  };
>  
> 
