Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaAAObf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 09:31:35 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47085 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbaAAObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 09:31:34 -0500
Message-ID: <52C426C7.8090706@kernel.org>
Date: Wed, 01 Jan 2014 14:31:35 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: lars@metafoo.de, Marek Vasut <marex@denx.de>, harald@ccbib.org,
        hector.palacios@digi.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 RESEND 4/4] iio: mxs-lradc: convert is_divided to a
 bitmap
References: <1387820884-28140-1-git-send-email-alexandre.belloni@free-electrons.com> <1387820884-28140-5-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1387820884-28140-5-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/12/13 17:48, Alexandre Belloni wrote:
> mxs_lradc.is_divided was an unsigned long array. Convert it to a bitmap to save
> some memory.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Hi Alexandre,

I've applied this patch, but would have prefered that you post this one 
in separate series. It is a perfectly valid cleanup, but introducing it
late in a series leads to uneven reviewing.  Anyhow, as it's trivial and
I doubt Marek will mind, I've applied it anyway in a new years burst of
trying to clear the outstanding stuff in my in box ;)

Applied to the togreg branch of iio.git

Thanks,

Jonathan
> ---
>   drivers/staging/iio/adc/mxs-lradc.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
> index a58c6aaa94d3..df71669bb60e 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -211,7 +211,7 @@ struct mxs_lradc {
>
>   	const uint32_t		*vref_mv;
>   	struct mxs_lradc_scale	scale_avail[LRADC_MAX_TOTAL_CHANS][2];
> -	unsigned int		is_divided[LRADC_MAX_TOTAL_CHANS];
> +	unsigned long		is_divided;
>
>   	/*
>   	 * Touchscreen LRADC channels receives a private slot in the CTRL4
> @@ -920,7 +920,7 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>
>   		*val = lradc->vref_mv[chan->channel];
>   		*val2 = chan->scan_type.realbits -
> -			lradc->is_divided[chan->channel];
> +			test_bit(chan->channel, &lradc->is_divided);
>   		return IIO_VAL_FRACTIONAL_LOG2;
>
>   	case IIO_CHAN_INFO_OFFSET:
> @@ -965,14 +965,14 @@ static int mxs_lradc_write_raw(struct iio_dev *iio_dev,
>   			/* divider by two disabled */
>   			writel(1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
>   			       lradc->base + LRADC_CTRL2 + STMP_OFFSET_REG_CLR);
> -			lradc->is_divided[chan->channel] = 0;
> +			clear_bit(chan->channel, &lradc->is_divided);
>   			ret = 0;
>   		} else if (val == scale_avail[MXS_LRADC_DIV_ENABLED].integer &&
>   			   val2 == scale_avail[MXS_LRADC_DIV_ENABLED].nano) {
>   			/* divider by two enabled */
>   			writel(1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
>   			       lradc->base + LRADC_CTRL2 + STMP_OFFSET_REG_SET);
> -			lradc->is_divided[chan->channel] = 1;
> +			set_bit(chan->channel, &lradc->is_divided);
>   			ret = 0;
>   		}
>
>
