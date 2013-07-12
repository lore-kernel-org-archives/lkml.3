Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087Ab3GLQhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 12:37:12 -0400
Received: from smtp-out-076.synserver.de ([212.40.185.76]:1112 "EHLO
	smtp-out-075.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965004Ab3GLQhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 12:37:10 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13498
Message-ID: <51E030D2.9070603@metafoo.de>
Date: Fri, 12 Jul 2013 18:37:38 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] iio: mxs-lradc: compute temperature from channel 8 and
 9
References: <1372699018-17436-1-git-send-email-alexandre.belloni@free-electrons.com> <51DFCB8F.2080608@free-electrons.com>
In-Reply-To: <51DFCB8F.2080608@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 11:25 AM, Alexandre Belloni wrote:
> Hi,
> 
> On 01/07/2013 19:16, Alexandre Belloni wrote:
>> The mxs LRADC is able to read an internal die temperature sensor. The
>> temperature has to be calculated from the value read on channel 8 and channel 9.
>> To be able to expose the result to hwmon, implement iio channel 8 as
>> (channel 9 - channel 8). Then, implement IIO_CHAN_INFO_SCALE and
>> IIO_CHAN_INFO_OFFSET so that it can be processed by hwmon through the in kernel
>> provider/consumer mechanism.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> I didn't get any review on that patch. I know it will already conflict
> with what Hector has been working on but would that be the good way to go ?

Yes, looks good to me. If you don't make any other fixes than resolving the
conflict you can add my

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

> 
> 
>> ---
>>  drivers/staging/iio/adc/mxs-lradc.c | 99 ++++++++++++++++++++++++++++++-------
>>  1 file changed, 82 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
>> index 163c638..df1d81e 100644
>> --- a/drivers/staging/iio/adc/mxs-lradc.c
>> +++ b/drivers/staging/iio/adc/mxs-lradc.c
>> @@ -225,26 +225,14 @@ struct mxs_lradc {
>>  #define	LRADC_CTRL4_LRADCSELECT_MASK(n)		(0xf << ((n) * 4))
>>  #define	LRADC_CTRL4_LRADCSELECT_OFFSET(n)	((n) * 4)
>>  
>> -/*
>> - * Raw I/O operations
>> - */
>> -static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>> -			const struct iio_chan_spec *chan,
>> -			int *val, int *val2, long m)
>> +static int mxs_lradc_read_single(struct iio_dev *iio_dev, int chan, int *val)
>>  {
>>  	struct mxs_lradc *lradc = iio_priv(iio_dev);
>>  	int ret;
>>  	unsigned long mask;
>>  
>> -	if (m != IIO_CHAN_INFO_RAW)
>> -		return -EINVAL;
>> -
>> -	/* Check for invalid channel */
>> -	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
>> -		return -EINVAL;
>> -
>>  	/* Validate the channel if it doesn't intersect with reserved chans. */
>> -	bitmap_set(&mask, chan->channel, 1);
>> +	bitmap_set(&mask, chan, 1);
>>  	ret = iio_validate_scan_mask_onehot(iio_dev, &mask);
>>  	if (ret)
>>  		return -EINVAL;
>> @@ -273,7 +261,7 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>>  	/* Clean the slot's previous content, then set new one. */
>>  	writel(LRADC_CTRL4_LRADCSELECT_MASK(0),
>>  		lradc->base + LRADC_CTRL4 + STMP_OFFSET_REG_CLR);
>> -	writel(chan->channel, lradc->base + LRADC_CTRL4 + STMP_OFFSET_REG_SET);
>> +	writel(chan, lradc->base + LRADC_CTRL4 + STMP_OFFSET_REG_SET);
>>  
>>  	writel(0, lradc->base + LRADC_CH(0));
>>  
>> @@ -302,6 +290,74 @@ err:
>>  	return ret;
>>  }
>>  
>> +static int mxs_lradc_read_temp(struct iio_dev *iio_dev, int *val)
>> +{
>> +	int ret, min, max;
>> +
>> +	ret = mxs_lradc_read_single(iio_dev, 8, &min);
>> +	if (ret != IIO_VAL_INT)
>> +		return ret;
>> +
>> +	ret = mxs_lradc_read_single(iio_dev, 9, &max);
>> +	if (ret != IIO_VAL_INT)
>> +		return ret;
>> +
>> +	*val = max - min;
>> +
>> +	return IIO_VAL_INT;
>> +}
>> +
>> +/*
>> + * Raw I/O operations
>> + */
>> +static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>> +			const struct iio_chan_spec *chan,
>> +			int *val, int *val2, long m)
>> +{
>> +	/* Check for invalid channel */
>> +	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
>> +		return -EINVAL;
>> +
>> +	switch (m) {
>> +	case IIO_CHAN_INFO_RAW:
>> +		if (chan->type == IIO_TEMP)
>> +			return mxs_lradc_read_temp(iio_dev, val);
>> +
>> +		return mxs_lradc_read_single(iio_dev, chan->channel, val);
>> +
>> +	case IIO_CHAN_INFO_SCALE:
>> +		if (chan->type == IIO_TEMP) {
>> +			/* From the datasheet, we have to multiply by 1.012 and
>> +			 * divide by 4
>> +			 */
>> +			*val = 0;
>> +			*val2 = 253000;
>> +			return IIO_VAL_INT_PLUS_MICRO;
>> +		}
>> +
>> +		return -EINVAL;
>> +
>> +	case IIO_CHAN_INFO_OFFSET:
>> +		if (chan->type == IIO_TEMP) {
>> +			/* The calculated value from the ADC is in Kelvin, we
>> +			 * want Celsius for hwmon so the offset is
>> +			 * -272.15 * scale
>> +			 */
>> +			*val = -1075;
>> +			*val2 = 691699;
>> +
>> +			return IIO_VAL_INT_PLUS_MICRO;
>> +		}
>> +
>> +		return -EINVAL;
>> +
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>>  static const struct iio_info mxs_lradc_iio_info = {
>>  	.driver_module		= THIS_MODULE,
>>  	.read_raw		= mxs_lradc_read_raw,
>> @@ -836,8 +892,17 @@ static const struct iio_chan_spec mxs_lradc_chan_spec[] = {
>>  	MXS_ADC_CHAN(5, IIO_VOLTAGE),
>>  	MXS_ADC_CHAN(6, IIO_VOLTAGE),
>>  	MXS_ADC_CHAN(7, IIO_VOLTAGE),	/* VBATT */
>> -	MXS_ADC_CHAN(8, IIO_TEMP),	/* Temp sense 0 */
>> -	MXS_ADC_CHAN(9, IIO_TEMP),	/* Temp sense 1 */
>> +	/* Combined Temperature sensors */
>> +	{
>> +		.type = IIO_TEMP,
>> +		.indexed = 1,
>> +		.scan_index = 8,
>> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
>> +				      BIT(IIO_CHAN_INFO_OFFSET) |
>> +				      BIT(IIO_CHAN_INFO_SCALE),
>> +		.channel = 8,
>> +		.scan_type = {.sign = 'u', .realbits = 18, .storagebits = 32,},
>> +	},
>>  	MXS_ADC_CHAN(10, IIO_VOLTAGE),	/* VDDIO */
>>  	MXS_ADC_CHAN(11, IIO_VOLTAGE),	/* VTH */
>>  	MXS_ADC_CHAN(12, IIO_VOLTAGE),	/* VDDA */
> 
> 

