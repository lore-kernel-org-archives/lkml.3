Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaFJPTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:19:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55932 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752342AbaFJPTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:19:43 -0400
Date: Tue, 10 Jun 2014 17:19:40 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Robert Hodaszi <robert.hodaszi@digi.com>
Cc: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, marex@denx.de, jbe@pengutronix.de,
        hector.palacios@digi.com, fabio.estevam@freescale.com, lars@metafoo.de
Subject: Re: [PATCH 2/2] iio: mxs-lradc: add ADC channel 9 as a copy of
 channel 8
Message-ID: <20140610151939.GB3429@piout.net>
References: <1402407695-2984-1-git-send-email-robert.hodaszi@digi.com>
 <1402407695-2984-3-git-send-email-robert.hodaszi@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402407695-2984-3-git-send-email-robert.hodaszi@digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 at 15:41:35 +0200, Robert Hodaszi wrote :
> Commit c8231a9af8147f8a401fc55931ec44abfb937660 ("iio: mxs-lradc: compute
> temperature from channel 8 and 9") merged channel 8 and channel 9 to create an
> IIO_TEMP channel. It changed the number of LRADC channels, which could cause
> incompatibility with previous device-tree declarations, and also makes it
> illogical (e.g. channel 15 is <&lradc 14>).
> 
> Add channel 9 as a copy of channel 8. Reading channel 9 has the same output as
> reading channel 8.
> 
> Signed-off-by: Robert Hodaszi <robert.hodaszi@digi.com>

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
>  drivers/staging/iio/adc/mxs-lradc.c | 61 +++++++++++++++++++++----------------
>  1 file changed, 35 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
> index 52d7517..25c0519 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -1376,8 +1376,8 @@ static const struct iio_buffer_setup_ops mxs_lradc_buffer_ops = {
>   * Driver initialization
>   */
>  
> -#define MXS_ADC_CHAN(idx, chan_type) {				\
> -	.type = (chan_type),					\
> +#define MXS_ADC_VOLTAGE_CHAN(idx) {				\
> +	.type = IIO_VOLTAGE,					\
>  	.indexed = 1,						\
>  	.scan_index = (idx),					\
>  	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |		\
> @@ -1391,32 +1391,41 @@ static const struct iio_buffer_setup_ops mxs_lradc_buffer_ops = {
>  	},							\
>  }
>  
> +#define MXS_ADC_TEMP_CHAN(idx) {				\
> +	.type = IIO_TEMP,					\
> +	.indexed = 1,						\
> +	.scan_index = (idx),					\
> +	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |		\
> +			      BIT(IIO_CHAN_INFO_SCALE) |	\
> +			      BIT(IIO_CHAN_INFO_OFFSET),	\
> +	.channel = (idx),					\
> +	.address = (idx),					\
> +	.scan_type = {						\
> +		.sign = 'u',					\
> +		.realbits = 18,					\
> +		.storagebits = 32,				\
> +	},							\
> +}
> +
>  static const struct iio_chan_spec mxs_lradc_chan_spec[] = {
> -	MXS_ADC_CHAN(0, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(1, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(2, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(3, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(4, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(5, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(6, IIO_VOLTAGE),
> -	MXS_ADC_CHAN(7, IIO_VOLTAGE),	/* VBATT */
> +	MXS_ADC_VOLTAGE_CHAN(0),
> +	MXS_ADC_VOLTAGE_CHAN(1),
> +	MXS_ADC_VOLTAGE_CHAN(2),
> +	MXS_ADC_VOLTAGE_CHAN(3),
> +	MXS_ADC_VOLTAGE_CHAN(4),
> +	MXS_ADC_VOLTAGE_CHAN(5),
> +	MXS_ADC_VOLTAGE_CHAN(6),
> +	MXS_ADC_VOLTAGE_CHAN(7),	/* VBATT */
>  	/* Combined Temperature sensors */
> -	{
> -		.type = IIO_TEMP,
> -		.indexed = 1,
> -		.scan_index = 8,
> -		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
> -				      BIT(IIO_CHAN_INFO_OFFSET) |
> -				      BIT(IIO_CHAN_INFO_SCALE),
> -		.channel = 8,
> -		.scan_type = {.sign = 'u', .realbits = 18, .storagebits = 32,},
> -	},
> -	MXS_ADC_CHAN(10, IIO_VOLTAGE),	/* VDDIO */
> -	MXS_ADC_CHAN(11, IIO_VOLTAGE),	/* VTH */
> -	MXS_ADC_CHAN(12, IIO_VOLTAGE),	/* VDDA */
> -	MXS_ADC_CHAN(13, IIO_VOLTAGE),	/* VDDD */
> -	MXS_ADC_CHAN(14, IIO_VOLTAGE),	/* VBG */
> -	MXS_ADC_CHAN(15, IIO_VOLTAGE),	/* VDD5V */
> +	MXS_ADC_TEMP_CHAN(8),
> +	/* CH 9 is the same as CH 8. Declared to fix following channel indexes */
> +	MXS_ADC_TEMP_CHAN(9),
> +	MXS_ADC_VOLTAGE_CHAN(10),	/* VDDIO */
> +	MXS_ADC_VOLTAGE_CHAN(11),	/* VTH */
> +	MXS_ADC_VOLTAGE_CHAN(12),	/* VDDA */
> +	MXS_ADC_VOLTAGE_CHAN(13),	/* VDDD */
> +	MXS_ADC_VOLTAGE_CHAN(14),	/* VBG */
> +	MXS_ADC_VOLTAGE_CHAN(15),	/* VDD5V */
>  };
>  
>  static int mxs_lradc_hw_init(struct mxs_lradc *lradc)

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
