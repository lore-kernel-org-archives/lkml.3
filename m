Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab3GTLTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 07:19:46 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45366 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3GTLTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 07:19:44 -0400
Message-ID: <51EA724F.2060805@kernel.org>
Date: Sat, 20 Jul 2013 12:19:43 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: Re: [PATCH 06/15] iio: ti_am335x_adc: Handle set to clear IRQENABLE
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com> <1374186086-5015-7-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1374186086-5015-7-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 11:21 PM, Zubair Lutfullah wrote:
> From: Russ Dill <Russ.Dill@ti.com>
> 
> The driver is currently mishandling the IRQENABLE register. The driver
> should write a 1 for bits it wishes to set, and a zero for bits it does not
> wish to change. The read of the current register contents is not
> necessary.
> 
> Write 0 = No action.
> Read 0 = Interrupt disabled (masked).
> Read 1 = Interrupt enabled.
> Write 1 = Enable interrupt.
> 
> The current read/update/write method is currently not causing any
> problems, but could cause confusion in the future.
> 
> Signed-off-by: Russ Dill <Russ.Dill@ti.com>
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>

I guess this makes sense as a separate patch to maintain history, but
I'd personally have preferred it rolled into the write places and
appropriate credit given as comments.

I don't like the fact that the code will be broken in a known fashion
at somepoints in this series...

Jonathan
> ---
>  drivers/iio/adc/ti_am335x_adc.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index c1b051c..b566e6a 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -207,7 +207,7 @@ static void tiadc_poll_handler(struct work_struct *work_s)
>  		container_of(work_s, struct tiadc_device, poll_work);
>  	struct iio_dev *idev = iio_priv_to_dev(adc_dev);
>  	struct iio_buffer *buffer = idev->buffer;
> -	unsigned int fifo1count, readx1, status;
> +	unsigned int fifo1count, readx1;
>  	int i;
>  	u32 *inputbuffer;
>  
> @@ -223,9 +223,8 @@ static void tiadc_poll_handler(struct work_struct *work_s)
>  	}
>  
>  	buffer->access->store_to(buffer, (u8 *) inputbuffer);
> -	status = tiadc_readl(adc_dev, REG_IRQENABLE);
>  	tiadc_writel(adc_dev, REG_IRQENABLE,
> -			(status | IRQENB_FIFO1THRES));
> +			IRQENB_FIFO1THRES);
>  
>  	kfree(inputbuffer);
>  }
> @@ -242,7 +241,7 @@ static int tiadc_buffer_postenable(struct iio_dev *idev)
>  {
>  	struct tiadc_device *adc_dev = iio_priv(idev);
>  	struct iio_buffer *buffer = idev->buffer;
> -	unsigned int enb, status, fifo1count;
> +	unsigned int enb, fifo1count;
>  	int stepnum, i;
>  	u8 bit;
>  
> @@ -250,11 +249,10 @@ static int tiadc_buffer_postenable(struct iio_dev *idev)
>  		pr_info("Data cannot be read continuously in one shot mode\n");
>  		return -EINVAL;
>  	} else {
> -		status = tiadc_readl(adc_dev, REG_IRQENABLE);
>  		tiadc_writel(adc_dev, REG_IRQENABLE,
> -				(status | IRQENB_FIFO1THRES)|
> -				 IRQENB_FIFO1OVRRUN |
> -				 IRQENB_FIFO1UNDRFLW);
> +				(IRQENB_FIFO1THRES |
> +				IRQENB_FIFO1OVRRUN |
> +				IRQENB_FIFO1UNDRFLW));
>  
>  		fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
>  		for (i = 0; i < fifo1count; i++)
> 
