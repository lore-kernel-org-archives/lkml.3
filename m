Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3GQRtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:49:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3GQRtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:49:18 -0400
Date: Wed, 17 Jul 2013 10:36:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        koen@dominion.thruhere.net
Subject: Re: [PATCH 03/21] iio: ti_am335x_adc: Added iio_voltageX_scale
Message-ID: <20130717173630.GC17882@kroah.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374082010-28095-4-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374082010-28095-4-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 06:26:32PM +0100, Zubair Lutfullah wrote:
> in_voltageX_scale is supposed to give scaled voltages. This was
> missing in the driver and has been added.
> Current patch is fixed to scale for 1.8V AVDD.
> 
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> ---
>  drivers/iio/adc/ti_am335x_adc.c |   17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index 1f83cf7..8a63203 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -26,7 +26,7 @@
>  #include <linux/of_device.h>
>  #include <linux/iio/machine.h>
>  #include <linux/iio/driver.h>
> -
> +#include <linux/math64.h>
>  #include <linux/mfd/ti_am335x_tscadc.h>
>  
>  struct tiadc_device {
> @@ -118,7 +118,8 @@ static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
>  		chan->type = IIO_VOLTAGE;
>  		chan->indexed = 1;
>  		chan->channel = adc_dev->channel_line[i];
> -		chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW);
> +		chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
> +						BIT(IIO_CHAN_INFO_SCALE);
>  		chan->datasheet_name = chan_name_ain[chan->channel];
>  		chan->scan_type.sign = 'u';
>  		chan->scan_type.realbits = 12;
> @@ -190,6 +191,18 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
>  		}
>  	}
>  
> +	switch (mask){
> +		case IIO_CHAN_INFO_RAW : /*Do nothing. Above code works fine.*/

What "above code"?


> +					break;

Please fix the indentation.

> +		case IIO_CHAN_INFO_SCALE : {
> +			/*12 Bit adc. Scale value for 1800mV AVDD. Ideally
> +			AVDD should come from DT.*/

Did you run this patch through the scripts/codingstyle tool?  Please be
generous in your spaces, there's no need to conserve them.

> +			*val = div_u64( (u64)(*val) * 1800 , 4096);
> +			break;
> +		}
> +		default: break;
> +	}

thanks,

greg k-h
