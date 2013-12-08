Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3LHNdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 08:33:41 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:33480 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3LHNdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 08:33:40 -0500
Message-ID: <52A4752C.6080600@kernel.org>
Date: Sun, 08 Dec 2013 13:33:32 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: lars@metafoo.de, Marek Vasut <marex@denx.de>, harald@ccbib.org,
        hector.palacios@digi.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 2/3] iio: mxs-lradc: add scale_available file to channels
References: <1386375840-24984-1-git-send-email-alexandre.belloni@free-electrons.com> <1386375840-24984-3-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1386375840-24984-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/13 00:23, Alexandre Belloni wrote:
> From: Hector Palacios <hector.palacios@digi.com>
>
> Adds in_voltageX_scale_available file for every channel to read
> the different available scales.
> There are two scales per channel:
>  [0] = divider_by_two disabled (default)
>  [1] = divider_by_two enabled
> The scale is a struct made of integer and nano parts to build
> a long decimal number.
>
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Hi Alexandre,

You introduce a few things in here that are not used until the next patch.
Please do a quick respin moving them over...

Otherwise, this looks good to me.   Whilst I wish I'd finished tidying
up my series reworking the _available attributes so that I could tell
you to use that, it is not ready and it would not be fair to hold your
series up on it!

Incidentally, thanks for breaking this up into the 3 patches. It makes
it a pleasure to review by keeping each one nice and focussed!

As this only adds new functionality, we won't introduced any regressions into the
imx23 so I'm not overly fussed about getting a tested by on that.
I'll be more than happy to add one though if someone does have time!

Jonathan
> ---
>  drivers/staging/iio/adc/mxs-lradc.c | 112 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 111 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
> index 22fef0a408db..eca766dce644 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -38,6 +38,7 @@
>  #include <linux/clk.h>
>
>  #include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
>  #include <linux/iio/buffer.h>
>  #include <linux/iio/trigger.h>
>  #include <linux/iio/trigger_consumer.h>
> @@ -184,6 +185,16 @@ enum lradc_ts_plate {
>  	LRADC_SAMPLE_VALID,
>  };
>
> +enum mxs_lradc_divbytwo {
> +	MXS_LRADC_DIV_DISABLED = 0,
> +	MXS_LRADC_DIV_ENABLED,
> +};
This enum isn't used until the next patch, so should not be here.
Whilst not used, it is sort of used in spirit as you loop over
the two elements of the array so if you prefer, leave this one here.

> +
> +struct mxs_lradc_scale {
> +	unsigned int		integer;
> +	unsigned int		nano;
> +};
> +
>  struct mxs_lradc {
>  	struct device		*dev;
>  	void __iomem		*base;
> @@ -199,6 +210,8 @@ struct mxs_lradc {
>  	struct completion	completion;
>
>  	const uint32_t		*vref_mv;
> +	struct mxs_lradc_scale	scale_avail[LRADC_MAX_TOTAL_CHANS][2];
> +	unsigned int		is_divided[LRADC_MAX_TOTAL_CHANS];

It strikes me that a array of integers to represent a set of boolean
values is overkill!  It would add a little more complexity to the
get and set, but I would use a bitmap.

(and this highlights why you should be careful about when stuff is
introduced given I had to read the next patch to review this one and I
am lazy!)
>
>  	/*
>  	 * Touchscreen LRADC channels receives a private slot in the CTRL4
> @@ -929,9 +942,84 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>  	return -EINVAL;
>  }
>
> +static ssize_t mxs_lradc_show_scale_available_ch(struct device *dev,
> +		struct device_attribute *attr,
> +		char *buf,
> +		int ch)
> +{
> +	struct iio_dev *iio = dev_to_iio_dev(dev);
> +	struct mxs_lradc *lradc = iio_priv(iio);
> +	int i, len = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(lradc->scale_avail[ch]); i++)
> +		len += sprintf(buf + len, "%d.%09u ",
> +			       lradc->scale_avail[ch][i].integer,
> +			       lradc->scale_avail[ch][i].nano);
> +
> +	len += sprintf(buf + len, "\n");
> +
> +	return len;
> +}
> +
> +static ssize_t mxs_lradc_show_scale_available(struct device *dev,
> +		struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct iio_dev_attr *iio_attr = to_iio_dev_attr(attr);
> +
> +	return mxs_lradc_show_scale_available_ch(dev, attr, buf,
> +						 iio_attr->address);
> +}
> +
> +#define SHOW_SCALE_AVAILABLE_ATTR(ch)					\
> +static IIO_DEVICE_ATTR(in_voltage##ch##_scale_available, S_IRUGO,	\
> +		       mxs_lradc_show_scale_available, NULL, ch)
> +
> +SHOW_SCALE_AVAILABLE_ATTR(0);
> +SHOW_SCALE_AVAILABLE_ATTR(1);
> +SHOW_SCALE_AVAILABLE_ATTR(2);
> +SHOW_SCALE_AVAILABLE_ATTR(3);
> +SHOW_SCALE_AVAILABLE_ATTR(4);
> +SHOW_SCALE_AVAILABLE_ATTR(5);
> +SHOW_SCALE_AVAILABLE_ATTR(6);
> +SHOW_SCALE_AVAILABLE_ATTR(7);
> +SHOW_SCALE_AVAILABLE_ATTR(8);
> +SHOW_SCALE_AVAILABLE_ATTR(9);
> +SHOW_SCALE_AVAILABLE_ATTR(10);
> +SHOW_SCALE_AVAILABLE_ATTR(11);
> +SHOW_SCALE_AVAILABLE_ATTR(12);
> +SHOW_SCALE_AVAILABLE_ATTR(13);
> +SHOW_SCALE_AVAILABLE_ATTR(14);
> +SHOW_SCALE_AVAILABLE_ATTR(15);
> +
> +static struct attribute *mxs_lradc_attributes[] = {
> +	&iio_dev_attr_in_voltage0_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage1_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage2_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage3_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage4_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage5_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage6_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage7_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage8_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage9_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage10_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage11_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage12_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage13_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage14_scale_available.dev_attr.attr,
> +	&iio_dev_attr_in_voltage15_scale_available.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group mxs_lradc_attribute_group = {
> +	.attrs = mxs_lradc_attributes,
> +};
> +
>  static const struct iio_info mxs_lradc_iio_info = {
>  	.driver_module		= THIS_MODULE,
>  	.read_raw		= mxs_lradc_read_raw,
> +	.attrs			= &mxs_lradc_attribute_group,
>  };
>
>  static int mxs_lradc_ts_open(struct input_dev *dev)
> @@ -1241,6 +1329,7 @@ static const struct iio_buffer_setup_ops mxs_lradc_buffer_ops = {
>  	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |		\
>  			      BIT(IIO_CHAN_INFO_SCALE),		\
>  	.channel = (idx),					\
> +	.address = (idx),					\
>  	.scan_type = {						\
>  		.sign = 'u',					\
>  		.realbits = LRADC_RESOLUTION,			\
> @@ -1386,7 +1475,8 @@ static int mxs_lradc_probe(struct platform_device *pdev)
>  	struct iio_dev *iio;
>  	struct resource *iores;
>  	int ret = 0, touch_ret;
> -	int i;
> +	int i, s;
> +	unsigned int scale_uv;
>
>  	/* Allocate the IIO device. */
>  	iio = devm_iio_device_alloc(dev, sizeof(*lradc));
> @@ -1456,6 +1546,26 @@ static int mxs_lradc_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto err_trig;
>
> +	/* Populate available ADC input ranges */
> +	for (i = 0; i < LRADC_MAX_TOTAL_CHANS; i++) {
> +		for (s = 0; s < ARRAY_SIZE(lradc->scale_avail[i]); s++) {
> +			/*
> +			 * [s=0] = optional divider by two disabled (default)
> +			 * [s=1] = optional divider by two enabled
> +			 *
> +			 * The scale is calculated by doing:
> +			 *   Vref >> (realbits - s)
> +			 * which multiplies by two on the second component
> +			 * of the array.
> +			 */
> +			scale_uv = ((u64)lradc->vref_mv[i] * 100000000) >>
> +				   (iio->channels[i].scan_type.realbits - s);
> +			lradc->scale_avail[i][s].nano =
> +					do_div(scale_uv, 100000000) * 10;
> +			lradc->scale_avail[i][s].integer = scale_uv;
> +		}
> +	}
> +
>  	/* Configure the hardware. */
>  	ret = mxs_lradc_hw_init(lradc);
>  	if (ret)
>
