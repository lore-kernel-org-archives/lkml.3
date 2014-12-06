Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaLFRVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:21:30 -0500
Received: from h1.radempa.de ([176.9.142.194]:46728 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaLFRV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:21:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 06 Dec 2014 18:21:18 +0100
From: <harald@ccbib.org>
To: Richard Weinberger <richard@nod.at>
Cc: <jic23@kernel.org>, <knaack.h@gmx.de>, <lars@metafoo.de>,
        <pmeerw@pmeerw.net>, <sanjeev_sharma@mentor.com>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] iio: dht11: IRQ fixes
In-Reply-To: <1417563176-31972-3-git-send-email-richard@nod.at>
References: <1417563176-31972-1-git-send-email-richard@nod.at> <1417563176-31972-3-git-send-email-richard@nod.at>
Message-ID: <bc157395b51e63648d1d1970e16ad6e7@imap.cosmopool.net>
User-Agent: RoundCube Webmail/0.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

finally got around to test this patch on all HW I have.

As expected the preamble needs to be shortend by two edges:
With your patch in its current form, the driver stops to work
reliably with DHT11. Also with DHT22 you get some delay when
reading the data, because you always wait for the timeout to
happen, before trying to decode the data.

Since your patch title includes "fix", the commit message
probably should mention that the patch as a side effect
changes behaviour - even if it's just diagnostic messages.

Thanks,
Harald

On Wed,  3 Dec 2014 00:32:54 +0100, Richard Weinberger <richard@nod.at>
wrote:
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/iio/humidity/dht11.c | 56
>  ++++++++++++++++++++++++--------------------
>  1 file changed, 30 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
> index 168ebc4..0023699 100644
> --- a/drivers/iio/humidity/dht11.c
> +++ b/drivers/iio/humidity/dht11.c
> @@ -140,6 +140,27 @@ static int dht11_decode(struct dht11 *dht11, int
> offset)
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
> +	if (dht11->num_edges < DHT11_EDGES_PER_READ && dht11->num_edges >= 0)
{
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
> @@ -160,8 +181,17 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>  		if (ret)
>  			goto err;
>  
> +		ret = request_irq(dht11->irq, dht11_handle_irq,
> +				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> +				  iio_dev->name, iio_dev);
> +		if (ret)
> +			goto err;
> +
>  		ret = wait_for_completion_killable_timeout(&dht11->completion,
>  								 HZ);
> +
> +		free_irq(dht11->irq, iio_dev);
> +
>  		if (ret == 0 && dht11->num_edges < DHT11_EDGES_PER_READ - 1) {
>  			dev_err(&iio_dev->dev,
>  					"Only %d signal edges detected\n",
> @@ -197,27 +227,6 @@ static const struct iio_info dht11_iio_info = {
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
> -	if (dht11->num_edges < DHT11_EDGES_PER_READ && dht11->num_edges >= 0)
{
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
> @@ -260,11 +269,6 @@ static int dht11_probe(struct platform_device
*pdev)
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
