Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3IULwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 07:52:00 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57309 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3IULv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 07:51:59 -0400
Message-ID: <523D9682.5060808@kernel.org>
Date: Sat, 21 Sep 2013 13:52:18 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, arnd@arndb.de, linus.walleij@linaro.org,
        denis.ciocca@st.com, linux-iio@vger.kernel.org
Subject: Re: [PATCH 14/20] iio: pressure-core: st: Clean-up probe() function
References: <1379347346-823-1-git-send-email-lee.jones@linaro.org> <1379347346-823-15-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1379347346-823-15-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/13 17:02, Lee Jones wrote:
> This patch contains some pretty basic clean-ups in probe() pertaining to
> the simplification of error handling and a couple of readability adaptions.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Applied to the togreg branch of iio.git

Thanks Lee,

> ---
>  drivers/iio/pressure/st_pressure_core.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
> index 3abada2..4539953 100644
> --- a/drivers/iio/pressure/st_pressure_core.c
> +++ b/drivers/iio/pressure/st_pressure_core.c
> @@ -232,21 +232,23 @@ static const struct iio_trigger_ops st_press_trigger_ops = {
>  int st_press_common_probe(struct iio_dev *indio_dev,
>  				struct st_sensors_platform_data *plat_data)
>  {
> -	int err;
>  	struct st_sensor_data *pdata = iio_priv(indio_dev);
> +	int irq = pdata->get_irq_data_ready(indio_dev);
> +	int err;
>  
>  	indio_dev->modes = INDIO_DIRECT_MODE;
>  	indio_dev->info = &press_info;
>  
>  	err = st_sensors_check_device_support(indio_dev,
> -				ARRAY_SIZE(st_press_sensors), st_press_sensors);
> +					      ARRAY_SIZE(st_press_sensors),
> +					      st_press_sensors);
>  	if (err < 0)
> -		goto st_press_common_probe_error;
> +		return err;
>  
>  	pdata->num_data_channels = ST_PRESS_NUMBER_DATA_CHANNELS;
> -	pdata->multiread_bit = pdata->sensor->multi_read_bit;
> -	indio_dev->channels = pdata->sensor->ch;
> -	indio_dev->num_channels = pdata->sensor->num_ch;
> +	pdata->multiread_bit     = pdata->sensor->multi_read_bit;
> +	indio_dev->channels      = pdata->sensor->ch;
> +	indio_dev->num_channels  = pdata->sensor->num_ch;
>  
>  	if (pdata->sensor->fs.addr != 0)
>  		pdata->current_fullscale = (struct st_sensor_fullscale_avl *)
> @@ -261,15 +263,15 @@ int st_press_common_probe(struct iio_dev *indio_dev,
>  
>  	err = st_sensors_init_sensor(indio_dev, plat_data);
>  	if (err < 0)
> -		goto st_press_common_probe_error;
> +		return err;
>  
> -	if (pdata->get_irq_data_ready(indio_dev) > 0) {
> +	if (irq > 0) {
>  		err = st_press_allocate_ring(indio_dev);
>  		if (err < 0)
> -			goto st_press_common_probe_error;
> +			return err;
>  
>  		err = st_sensors_allocate_trigger(indio_dev,
> -							ST_PRESS_TRIGGER_OPS);
> +						  ST_PRESS_TRIGGER_OPS);
>  		if (err < 0)
>  			goto st_press_probe_trigger_error;
>  	}
> @@ -281,12 +283,12 @@ int st_press_common_probe(struct iio_dev *indio_dev,
>  	return err;
>  
>  st_press_device_register_error:
> -	if (pdata->get_irq_data_ready(indio_dev) > 0)
> +	if (irq > 0)
>  		st_sensors_deallocate_trigger(indio_dev);
>  st_press_probe_trigger_error:
> -	if (pdata->get_irq_data_ready(indio_dev) > 0)
> +	if (irq > 0)
>  		st_press_deallocate_ring(indio_dev);
> -st_press_common_probe_error:
> +
>  	return err;
>  }
>  EXPORT_SYMBOL(st_press_common_probe);
> 
