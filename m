Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3IULxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 07:53:37 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57340 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3IULxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 07:53:36 -0400
Message-ID: <523D96E3.40107@kernel.org>
Date: Sat, 21 Sep 2013 13:53:55 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 15/20] iio: pressure: st: Add support for new LPS001WP
 pressure sensor
References: <1379347346-823-1-git-send-email-lee.jones@linaro.org> <1379347346-823-16-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1379347346-823-16-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/13 17:02, Lee Jones wrote:
> Here we use existing practices to introduce support for another
> pressure/temperature sensor, the LPS001WP.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Applied to the togreg branch of iio.git

Thanks
> ---
>  drivers/iio/pressure/st_pressure.h      |  1 +
>  drivers/iio/pressure/st_pressure_core.c | 84 +++++++++++++++++++++++++++++++++
>  drivers/iio/pressure/st_pressure_i2c.c  |  1 +
>  3 files changed, 86 insertions(+)
> 
> diff --git a/drivers/iio/pressure/st_pressure.h b/drivers/iio/pressure/st_pressure.h
> index b0b6306..049c21a 100644
> --- a/drivers/iio/pressure/st_pressure.h
> +++ b/drivers/iio/pressure/st_pressure.h
> @@ -14,6 +14,7 @@
>  #include <linux/types.h>
>  #include <linux/iio/common/st_sensors.h>
>  
> +#define LPS001WP_PRESS_DEV_NAME		"lps001wp"
>  #define LPS331AP_PRESS_DEV_NAME		"lps331ap"
>  
>  /**
> diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
> index 4539953..e879542 100644
> --- a/drivers/iio/pressure/st_pressure_core.c
> +++ b/drivers/iio/pressure/st_pressure_core.c
> @@ -64,6 +64,21 @@
>  #define ST_PRESS_LPS331AP_OUT_XL_ADDR		0x28
>  #define ST_TEMP_LPS331AP_OUT_L_ADDR		0x2b
>  
> +/* CUSTOM VALUES FOR LPS001WP SENSOR */
> +#define ST_PRESS_LPS001WP_WAI_EXP		0xba
> +#define ST_PRESS_LPS001WP_ODR_ADDR		0x20
> +#define ST_PRESS_LPS001WP_ODR_MASK		0x30
> +#define ST_PRESS_LPS001WP_ODR_AVL_1HZ_VAL	0x01
> +#define ST_PRESS_LPS001WP_ODR_AVL_7HZ_VAL	0x02
> +#define ST_PRESS_LPS001WP_ODR_AVL_13HZ_VAL	0x03
> +#define ST_PRESS_LPS001WP_PW_ADDR		0x20
> +#define ST_PRESS_LPS001WP_PW_MASK		0x40
> +#define ST_PRESS_LPS001WP_BDU_ADDR		0x20
> +#define ST_PRESS_LPS001WP_BDU_MASK		0x04
> +#define ST_PRESS_LPS001WP_MULTIREAD_BIT		true
> +#define ST_PRESS_LPS001WP_OUT_L_ADDR		0x28
> +#define ST_TEMP_LPS001WP_OUT_L_ADDR		0x2a
> +
>  static const struct iio_chan_spec st_press_lps331ap_channels[] = {
>  	{
>  		.type = IIO_PRESSURE,
> @@ -100,6 +115,40 @@ static const struct iio_chan_spec st_press_lps331ap_channels[] = {
>  	IIO_CHAN_SOFT_TIMESTAMP(1)
>  };
>  
> +static const struct iio_chan_spec st_press_lps001wp_channels[] = {
> +	{
> +		.type = IIO_PRESSURE,
> +		.channel2 = IIO_NO_MOD,
> +		.address = ST_PRESS_LPS001WP_OUT_L_ADDR,
> +		.scan_index = ST_SENSORS_SCAN_X,
> +		.scan_type = {
> +			.sign = 'u',
> +			.realbits = 16,
> +			.storagebits = 16,
> +			.endianness = IIO_LE,
> +		},
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
> +		.modified = 0,
> +	},
> +	{
> +		.type = IIO_TEMP,
> +		.channel2 = IIO_NO_MOD,
> +		.address = ST_TEMP_LPS001WP_OUT_L_ADDR,
> +		.scan_index = -1,
> +		.scan_type = {
> +			.sign = 'u',
> +			.realbits = 16,
> +			.storagebits = 16,
> +			.endianness = IIO_LE,
> +		},
> +		.info_mask_separate =
> +			BIT(IIO_CHAN_INFO_RAW) |
> +			BIT(IIO_CHAN_INFO_OFFSET),
> +		.modified = 0,
> +	},
> +	IIO_CHAN_SOFT_TIMESTAMP(1)
> +};
> +
>  static const struct st_sensors st_press_sensors[] = {
>  	{
>  		.wai = ST_PRESS_LPS331AP_WAI_EXP,
> @@ -148,6 +197,41 @@ static const struct st_sensors st_press_sensors[] = {
>  		.multi_read_bit = ST_PRESS_LPS331AP_MULTIREAD_BIT,
>  		.bootime = 2,
>  	},
> +	{
> +		.wai = ST_PRESS_LPS001WP_WAI_EXP,
> +		.sensors_supported = {
> +			[0] = LPS001WP_PRESS_DEV_NAME,
> +		},
> +		.ch = (struct iio_chan_spec *)st_press_lps001wp_channels,
> +		.num_ch = ARRAY_SIZE(st_press_lps001wp_channels),
> +		.odr = {
> +			.addr = ST_PRESS_LPS001WP_ODR_ADDR,
> +			.mask = ST_PRESS_LPS001WP_ODR_MASK,
> +			.odr_avl = {
> +				{ 1, ST_PRESS_LPS001WP_ODR_AVL_1HZ_VAL, },
> +				{ 7, ST_PRESS_LPS001WP_ODR_AVL_7HZ_VAL, },
> +				{ 13, ST_PRESS_LPS001WP_ODR_AVL_13HZ_VAL, },
> +			},
> +		},
> +		.pw = {
> +			.addr = ST_PRESS_LPS001WP_PW_ADDR,
> +			.mask = ST_PRESS_LPS001WP_PW_MASK,
> +			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
> +			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
> +		},
> +		.fs = {
> +			.addr = 0,
> +		},
> +		.bdu = {
> +			.addr = ST_PRESS_LPS001WP_BDU_ADDR,
> +			.mask = ST_PRESS_LPS001WP_BDU_MASK,
> +		},
> +		.drdy_irq = {
> +			.addr = 0,
> +		},
> +		.multi_read_bit = ST_PRESS_LPS001WP_MULTIREAD_BIT,
> +		.bootime = 2,
> +	},
>  };
>  
>  static int st_press_read_raw(struct iio_dev *indio_dev,
> diff --git a/drivers/iio/pressure/st_pressure_i2c.c b/drivers/iio/pressure/st_pressure_i2c.c
> index 08aac5e..51eab7f 100644
> --- a/drivers/iio/pressure/st_pressure_i2c.c
> +++ b/drivers/iio/pressure/st_pressure_i2c.c
> @@ -49,6 +49,7 @@ static int st_press_i2c_remove(struct i2c_client *client)
>  }
>  
>  static const struct i2c_device_id st_press_id_table[] = {
> +	{ LPS001WP_PRESS_DEV_NAME },
>  	{ LPS331AP_PRESS_DEV_NAME },
>  	{},
>  };
> 
