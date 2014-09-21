Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbaIUM1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 08:27:04 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49048 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaIUM1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 08:27:02 -0400
Message-ID: <541EC414.5050505@kernel.org>
Date: Sun, 21 Sep 2014 13:27:00 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Sanchayan Maity <maitysanchayan@gmail.com>
CC: stefan@agner.ch, shawn.guo@freescale.com, B38611@freescale.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] drivers/iio/adc/vf610-adc: Add temperature sensor
 support
References: <cover.1411128738.git.maitysanchayan@gmail.com> <0d7ce38f3f0550a485293d854832304463e215cf.1411128738.git.maitysanchayan@gmail.com>
In-Reply-To: <0d7ce38f3f0550a485293d854832304463e215cf.1411128738.git.maitysanchayan@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/14 13:58, Sanchayan Maity wrote:
> Vybrid ADC peripheral includes a temperature sensor
> which is connected to channel number 26. This patch
> adds support for the sensor. The raw value is read
> and the temperature calculated in milli degree Celsius,
> which is returned using IIO_CHAN_INFO_PROCESSED option.
> 
> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
Applied to the togreg branch of iio.git initially pushed out as testing
for the autobuilders to play.

Amended the patch title to fit with the style we have somehow
ended up with for IIO patches.

Thanks,

Jonathan
> ---
>  drivers/iio/adc/vf610_adc.c |   28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/adc/vf610_adc.c b/drivers/iio/adc/vf610_adc.c
> index 44799eb5..52af611 100644
> --- a/drivers/iio/adc/vf610_adc.c
> +++ b/drivers/iio/adc/vf610_adc.c
> @@ -91,7 +91,7 @@
>  #define VF610_ADC_CAL			0x80
>  
>  /* Other field define */
> -#define VF610_ADC_ADCHC(x)		((x) & 0xF)
> +#define VF610_ADC_ADCHC(x)		((x) & 0x1F)
>  #define VF610_ADC_AIEN			(0x1 << 7)
>  #define VF610_ADC_CONV_DISABLE		0x1F
>  #define VF610_ADC_HS_COCO0		0x1
> @@ -153,6 +153,12 @@ struct vf610_adc {
>  				BIT(IIO_CHAN_INFO_SAMP_FREQ),	\
>  }
>  
> +#define VF610_ADC_TEMPERATURE_CHAN(_idx, _chan_type) {	\
> +	.type = (_chan_type),	\
> +	.channel = (_idx),		\
> +	.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),	\
> +}
> +
>  static const struct iio_chan_spec vf610_adc_iio_channels[] = {
>  	VF610_ADC_CHAN(0, IIO_VOLTAGE),
>  	VF610_ADC_CHAN(1, IIO_VOLTAGE),
> @@ -170,6 +176,7 @@ static const struct iio_chan_spec vf610_adc_iio_channels[] = {
>  	VF610_ADC_CHAN(13, IIO_VOLTAGE),
>  	VF610_ADC_CHAN(14, IIO_VOLTAGE),
>  	VF610_ADC_CHAN(15, IIO_VOLTAGE),
> +	VF610_ADC_TEMPERATURE_CHAN(26, IIO_TEMP),
>  	/* sentinel */
>  };
>  
> @@ -451,6 +458,7 @@ static int vf610_read_raw(struct iio_dev *indio_dev,
>  
>  	switch (mask) {
>  	case IIO_CHAN_INFO_RAW:
> +	case IIO_CHAN_INFO_PROCESSED:
>  		mutex_lock(&indio_dev->mlock);
>  		reinit_completion(&info->completion);
>  
> @@ -468,7 +476,23 @@ static int vf610_read_raw(struct iio_dev *indio_dev,
>  			return ret;
>  		}
>  
> -		*val = info->value;
> +		switch (chan->type) {
> +		case IIO_VOLTAGE:
> +			*val = info->value;
> +			break;
> +		case IIO_TEMP:
> +			/*
> +			* Calculate in degree Celsius times 1000
> +			* Using sensor slope of 1.84 mV/°C and
> +			* V at 25°C of 696 mV
> +			*/
> +			*val = 25000 - ((int)info->value - 864) * 1000000 / 1840;
> +			break;
> +		default:
> +			mutex_unlock(&indio_dev->mlock);
> +			return -EINVAL;
> +		}
> +
>  		mutex_unlock(&indio_dev->mlock);
>  		return IIO_VAL_INT;
>  
> 
