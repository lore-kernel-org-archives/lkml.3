Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaFJPTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:19:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55924 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752494AbaFJPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:19:15 -0400
Date: Tue, 10 Jun 2014 17:19:13 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Robert Hodaszi <robert.hodaszi@digi.com>
Cc: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, marex@denx.de, jbe@pengutronix.de,
        hector.palacios@digi.com, fabio.estevam@freescale.com, lars@metafoo.de
Subject: Re: [PATCH 1/2] iio: mxs-lradc: fix divider
Message-ID: <20140610151912.GA3429@piout.net>
References: <1402407695-2984-1-git-send-email-robert.hodaszi@digi.com>
 <1402407695-2984-2-git-send-email-robert.hodaszi@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402407695-2984-2-git-send-email-robert.hodaszi@digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 at 15:41:34 +0200, Robert Hodaszi wrote :
> All channels' single measurement are happening on CH 0. So enabling / disabling
> the divider once is not enough, because it has impact on all channels.
> 
> Set only a flag, then check this on each measurement, and enable / disable the
> divider as required.
> 
> Signed-off-by: Robert Hodaszi <robert.hodaszi@digi.com>

It makes perfect sense.

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
>  drivers/staging/iio/adc/mxs-lradc.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
> index dae8d1a..52d7517 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -846,6 +846,14 @@ static int mxs_lradc_read_single(struct iio_dev *iio_dev, int chan, int *val)
>  			LRADC_CTRL1);
>  	mxs_lradc_reg_clear(lradc, 0xff, LRADC_CTRL0);
>  
> +	/* Enable / disable the divider per requirement */
> +	if (test_bit(chan, &lradc->is_divided))
> +		mxs_lradc_reg_set(lradc, 1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
> +			LRADC_CTRL2);
> +	else
> +		mxs_lradc_reg_clear(lradc,
> +			1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET, LRADC_CTRL2);
> +
>  	/* Clean the slot's previous content, then set new one. */
>  	mxs_lradc_reg_clear(lradc, LRADC_CTRL4_LRADCSELECT_MASK(0),
>  			LRADC_CTRL4);
> @@ -961,15 +969,11 @@ static int mxs_lradc_write_raw(struct iio_dev *iio_dev,
>  		if (val == scale_avail[MXS_LRADC_DIV_DISABLED].integer &&
>  		    val2 == scale_avail[MXS_LRADC_DIV_DISABLED].nano) {
>  			/* divider by two disabled */
> -			writel(1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
> -			       lradc->base + LRADC_CTRL2 + STMP_OFFSET_REG_CLR);
>  			clear_bit(chan->channel, &lradc->is_divided);
>  			ret = 0;
>  		} else if (val == scale_avail[MXS_LRADC_DIV_ENABLED].integer &&
>  			   val2 == scale_avail[MXS_LRADC_DIV_ENABLED].nano) {
>  			/* divider by two enabled */
> -			writel(1 << LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET,
> -			       lradc->base + LRADC_CTRL2 + STMP_OFFSET_REG_SET);
>  			set_bit(chan->channel, &lradc->is_divided);
>  			ret = 0;
>  		}

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
