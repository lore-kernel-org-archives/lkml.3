Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217Ab3GSOjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:39:03 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33301 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759069Ab3GSOjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:39:01 -0400
X-Auth-Info: E2qDwTroADPHn2Mh1BdWE2UciNf79TIfleGO4wLLpoI=
From: Marek Vasut <marex@denx.de>
To: Hector Palacios <hector.palacios@digi.com>
Subject: Re: [PATCH v2 5/5] iio: mxs-lradc: add write_raw function to modify scale
Date: Fri, 19 Jul 2013 16:39:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        alexandre.belloni@free-electrons.com, jic23@kernel.org,
        lars@metafoo.de, fabio.estevam@freescale.com
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <1374225208-28940-6-git-send-email-hector.palacios@digi.com>
In-Reply-To: <1374225208-28940-6-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307191639.01240.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hector Palacios,

> Added write_raw function to manipulate the optional divider_by_two
> through the scaling attribute out of the available scales.
> 
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> ---
>  drivers/staging/iio/adc/mxs-lradc.c | 55
> ++++++++++++++++++++++++++++++++++++- 1 file changed, 54 insertions(+), 1
> deletion(-)
> 
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c
> b/drivers/staging/iio/adc/mxs-lradc.c index c929733..286cde2 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -144,6 +144,7 @@ struct mxs_lradc {
> 
>  	uint32_t		vref_mv[LRADC_MAX_TOTAL_CHANS];
>  	unsigned int		scale_avail[LRADC_MAX_TOTAL_CHANS][2][2];
> +	unsigned int		is_divided[LRADC_MAX_TOTAL_CHANS];

Why not use bitfield ? ;-)

>  	/*
>  	 * Touchscreen LRADC channels receives a private slot in the CTRL4
> @@ -202,6 +203,7 @@ struct mxs_lradc {
>  #define	LRADC_CTRL1_LRADC_IRQ_OFFSET		0
> 
>  #define	LRADC_CTRL2				0x20
> +#define	LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET	24
>  #define	LRADC_CTRL2_TEMPSENSE_PWD		(1 << 15)
> 
>  #define	LRADC_STATUS				0x40
> @@ -310,7 +312,8 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>  		break;
>  	case IIO_CHAN_INFO_SCALE:
>  		*val = lradc->vref_mv[chan->channel];
> -		*val2 = chan->scan_type.realbits;
> +		*val2 = chan->scan_type.realbits -
> +			lradc->is_divided[chan->channel];
>  		ret = IIO_VAL_FRACTIONAL_LOG2;
>  		break;
>  	default:
> @@ -323,6 +326,54 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>  	return ret;
>  }
> 
> +static int mxs_lradc_write_raw(struct iio_dev *iio_dev,
> +			       const struct iio_chan_spec *chan,
> +			       int val, int val2, long m)
> +{
> +	struct mxs_lradc *lradc = iio_priv(iio_dev);
> +	int ret;
> +
> +	ret = mutex_trylock(&lradc->lock);
> +	if (!ret)
> +		return -EBUSY;
> +
> +	switch (m) {
> +	case IIO_CHAN_INFO_SCALE:
> +		ret = -EINVAL;
> +		if (val == lradc->scale_avail[chan->channel][0][0] &&
> +		    val2 == lradc->scale_avail[chan->channel][0][1]) {
> +			/* [0] -> divider by two disabled */

This comment is confusing, you use [0] in different dimensions of the array. So 
is the stuff below.

Still, how does this even work, can you show me and example how to set the 
divider from userland ? Sorry, I'm a bit confused with this 3D-business here, 
even if the comment in previous patch made it a bit clearer. Actually you can 
use some #define to specify if you're accessing div/2 or div/1 portion of the 
array to make it more readable.

Like ... scale_avail[chan->channel][LRADC_DIV_BY_2][LRADC_DECIMAL_PART] ... 
would by nice.

> +			writel(1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
> +			       lradc->base + LRADC_CTRL2 + STMP_OFFSET_REG_CLR);
> +			lradc->is_divided[chan->channel] = 0;
> +			ret = 0;
> +		} else if (val == lradc->scale_avail[chan->channel][1][0] &&
> +			   val2 == lradc->scale_avail[chan->channel][1][1]) {
> +			/* [1] -> divider by two enabled */
> +			writel(1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
> +			       lradc->base + LRADC_CTRL2 + STMP_OFFSET_REG_SET);
> +			lradc->is_divided[chan->channel] = 1;
> +			ret = 0;
> +		}
> +
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	mutex_unlock(&lradc->lock);
> +
> +	return ret;
> +}
> +
> +static int mxs_lradc_write_raw_get_fmt(struct iio_dev *iio_dev,
> +				       const struct iio_chan_spec *chan,
> +				       long m)
> +{
> +	return IIO_VAL_INT_PLUS_NANO;
> +}
> +
>  static ssize_t mxs_lradc_show_scale_available_ch(struct device *dev,
>  		struct device_attribute *attr,
>  		char *buf,
> @@ -400,6 +451,8 @@ static const struct attribute_group
> mxs_lradc_attribute_group = { static const struct iio_info
> mxs_lradc_iio_info = {
>  	.driver_module		= THIS_MODULE,
>  	.read_raw		= mxs_lradc_read_raw,
> +	.write_raw		= mxs_lradc_write_raw,
> +	.write_raw_get_fmt	= &mxs_lradc_write_raw_get_fmt,

Is this & needed here ?

>  	.attrs			= &mxs_lradc_attribute_group,
>  };

Best regards,
Marek Vasut
