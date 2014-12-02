Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbaLBKUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:20:12 -0500
Received: from h1.radempa.de ([176.9.142.194]:59828 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbaLBKUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:20:06 -0500
From: Harald Geyer <harald@ccbib.org>
To: Richard Weinberger <richard@nod.at>
cc: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iio: dht11: IRQ fixes
In-reply-to: <1417465651-16036-2-git-send-email-richard@nod.at>
References: <1417465651-16036-1-git-send-email-richard@nod.at> <1417465651-16036-2-git-send-email-richard@nod.at>
Comments: In-reply-to Richard Weinberger <richard@nod.at>
   message dated "Mon, 01 Dec 2014 21:27:31 +0100."
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4070.1417515595.1@stardust.g4.wien.funkfeuer.at>
Date: Tue, 02 Dec 2014 11:19:55 +0100
Message-Id: <E1XvkYl-00013g-VO@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

thanks for the patch.

I think (haven't tried yet) that your patch changes the number of
edges recorded per transmission. So probably the decoding function
needs to be adapted too...

I won't be able to ACK this before testing on real HW. Of course
confirmation that your changes work reliably on both DHT11 and DHT22
will do as well. The debuging code present in the initial submission
of the driver might be helpful to anybody trying to verify the
timing.

I'm doing kernel work in my free time and am quite busy with my day job
right now, so it will take a few days before I can test your code myself.
Sorry about that.

Thanks,
Harald

Richard Weinberger writes:
> We must not set an IRQ pin into output mode.
> Set the data GPIO only into IRQ mode if needed.
> This is a bit hacky but the only way to communicate in a sane
> way with the device.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/iio/humidity/dht11.c | 56 ++++++++++++++++++++++++--------------------
>  1 file changed, 30 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
> index 7636e66..b6c44ad 100644
> --- a/drivers/iio/humidity/dht11.c
> +++ b/drivers/iio/humidity/dht11.c
> @@ -139,6 +139,27 @@ static int dht11_decode(struct dht11 *dht11, int offset)
>  	return 0;
>  }
>  
> +/*
> + * IRQ handler called on GPIO edges
> + */
> +static irqreturn_t dht11_handle_irq(int irq, void *data)
> +{
> +	struct iio_dev *iio = data;
> +	struct dht11 *dht11 = iio_priv(iio);
> +
> +	/* TODO: Consider making the handler safe for IRQ sharing */
> +	if (dht11->num_edges < DHT11_EDGES_PER_READ && dht11->num_edges >= 0) {
> +		dht11->edges[dht11->num_edges].ts = iio_get_time_ns();
> +		dht11->edges[dht11->num_edges++].value =
> +						gpio_get_value(dht11->gpio);
> +
> +		if (dht11->num_edges >= DHT11_EDGES_PER_READ)
> +			complete(&dht11->completion);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
>  static int dht11_read_raw(struct iio_dev *iio_dev,
>  			const struct iio_chan_spec *chan,
>  			int *val, int *val2, long m)
> @@ -159,8 +180,17 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>  		if (ret)
>  			goto err_unlock;
>  
> +		ret = request_irq(dht11->irq, dht11_handle_irq,
> +				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> +				  iio_dev->name, iio_dev);
> +		if (ret)
> +			goto err_unlock;
> +
>  		ret = wait_for_completion_killable_timeout(&dht11->completion,
>  								 HZ);
> +
> +		free_irq(dht11->irq, iio_dev);
> +
>  		if (ret == 0 && dht11->num_edges < DHT11_EDGES_PER_READ - 1) {
>  			dev_err(&iio_dev->dev,
>  					"Only %d signal edges detected\n",
> @@ -201,27 +231,6 @@ static const struct iio_info dht11_iio_info = {
>  	.read_raw		= dht11_read_raw,
>  };
>  
> -/*
> - * IRQ handler called on GPIO edges
> -*/
> -static irqreturn_t dht11_handle_irq(int irq, void *data)
> -{
> -	struct iio_dev *iio = data;
> -	struct dht11 *dht11 = iio_priv(iio);
> -
> -	/* TODO: Consider making the handler safe for IRQ sharing */
> -	if (dht11->num_edges < DHT11_EDGES_PER_READ && dht11->num_edges >= 0) {
> -		dht11->edges[dht11->num_edges].ts = iio_get_time_ns();
> -		dht11->edges[dht11->num_edges++].value =
> -						gpio_get_value(dht11->gpio);
> -
> -		if (dht11->num_edges >= DHT11_EDGES_PER_READ)
> -			complete(&dht11->completion);
> -	}
> -
> -	return IRQ_HANDLED;
> -}
> -
>  static const struct iio_chan_spec dht11_chan_spec[] = {
>  	{ .type = IIO_TEMP,
>  		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED), },
> @@ -264,11 +273,6 @@ static int dht11_probe(struct platform_device *pdev)
>  		dev_err(dev, "GPIO %d has no interrupt\n", dht11->gpio);
>  		return -EINVAL;
>  	}
> -	ret = devm_request_irq(dev, dht11->irq, dht11_handle_irq,
> -				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> -				pdev->name, iio);
> -	if (ret)
> -		return ret;
>  
>  	dht11->timestamp = iio_get_time_ns() - DHT11_DATA_VALID_TIME - 1;
>  	dht11->num_edges = -1;
> -- 
> 2.1.0
> 
