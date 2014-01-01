Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaAAO3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 09:29:23 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47044 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbaAAO3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 09:29:21 -0500
Message-ID: <52C42642.80708@kernel.org>
Date: Wed, 01 Jan 2014 14:29:22 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: lars@metafoo.de, Marek Vasut <marex@denx.de>, harald@ccbib.org,
        hector.palacios@digi.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 RESEND 3/4] iio: mxs-lradc: add write_raw function to
 modify scale
References: <1387820884-28140-1-git-send-email-alexandre.belloni@free-electrons.com> <1387820884-28140-4-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1387820884-28140-4-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/12/13 17:48, Alexandre Belloni wrote:
> From: Hector Palacios <hector.palacios@digi.com>
>
> Added write_raw function to manipulate the optional divider_by_two
> through the scaling attribute out of the available scales.
>
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Marek Vasut <marex@denx.de>
Applied to the togreg branch of iio.git

Thanks for your hard work on these!

Jonathan
>
> ---
>   drivers/staging/iio/adc/mxs-lradc.c | 62 ++++++++++++++++++++++++++++++++++++-
>   1 file changed, 61 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
> index c63b312e54fd..a58c6aaa94d3 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -185,6 +185,11 @@ enum lradc_ts_plate {
>   	LRADC_SAMPLE_VALID,
>   };
>
> +enum mxs_lradc_divbytwo {
> +	MXS_LRADC_DIV_DISABLED = 0,
> +	MXS_LRADC_DIV_ENABLED,
> +};
> +
>   struct mxs_lradc_scale {
>   	unsigned int		integer;
>   	unsigned int		nano;
> @@ -206,6 +211,7 @@ struct mxs_lradc {
>
>   	const uint32_t		*vref_mv;
>   	struct mxs_lradc_scale	scale_avail[LRADC_MAX_TOTAL_CHANS][2];
> +	unsigned int		is_divided[LRADC_MAX_TOTAL_CHANS];
>
>   	/*
>   	 * Touchscreen LRADC channels receives a private slot in the CTRL4
> @@ -295,6 +301,7 @@ struct mxs_lradc {
>   #define	LRADC_CTRL1_LRADC_IRQ_OFFSET		0
>
>   #define	LRADC_CTRL2				0x20
> +#define	LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET	24
>   #define	LRADC_CTRL2_TEMPSENSE_PWD		(1 << 15)
>
>   #define	LRADC_STATUS				0x40
> @@ -912,7 +919,8 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>   		}
>
>   		*val = lradc->vref_mv[chan->channel];
> -		*val2 = chan->scan_type.realbits;
> +		*val2 = chan->scan_type.realbits -
> +			lradc->is_divided[chan->channel];
>   		return IIO_VAL_FRACTIONAL_LOG2;
>
>   	case IIO_CHAN_INFO_OFFSET:
> @@ -936,6 +944,56 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>   	return -EINVAL;
>   }
>
> +static int mxs_lradc_write_raw(struct iio_dev *iio_dev,
> +			       const struct iio_chan_spec *chan,
> +			       int val, int val2, long m)
> +{
> +	struct mxs_lradc *lradc = iio_priv(iio_dev);
> +	struct mxs_lradc_scale *scale_avail =
> +			lradc->scale_avail[chan->channel];
> +	int ret;
> +
> +	ret = mutex_trylock(&lradc->lock);
> +	if (!ret)
> +		return -EBUSY;
> +
> +	switch (m) {
> +	case IIO_CHAN_INFO_SCALE:
> +		ret = -EINVAL;
> +		if (val == scale_avail[MXS_LRADC_DIV_DISABLED].integer &&
> +		    val2 == scale_avail[MXS_LRADC_DIV_DISABLED].nano) {
> +			/* divider by two disabled */
> +			writel(1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
> +			       lradc->base + LRADC_CTRL2 + STMP_OFFSET_REG_CLR);
> +			lradc->is_divided[chan->channel] = 0;
> +			ret = 0;
> +		} else if (val == scale_avail[MXS_LRADC_DIV_ENABLED].integer &&
> +			   val2 == scale_avail[MXS_LRADC_DIV_ENABLED].nano) {
> +			/* divider by two enabled */
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
>   static ssize_t mxs_lradc_show_scale_available_ch(struct device *dev,
>   		struct device_attribute *attr,
>   		char *buf,
> @@ -1013,6 +1071,8 @@ static const struct attribute_group mxs_lradc_attribute_group = {
>   static const struct iio_info mxs_lradc_iio_info = {
>   	.driver_module		= THIS_MODULE,
>   	.read_raw		= mxs_lradc_read_raw,
> +	.write_raw		= mxs_lradc_write_raw,
> +	.write_raw_get_fmt	= mxs_lradc_write_raw_get_fmt,
>   	.attrs			= &mxs_lradc_attribute_group,
>   };
>
>
