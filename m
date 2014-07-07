Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaGGMes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:34:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:57651 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaGGMer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:34:47 -0400
Message-ID: <53BA9469.7000600@kernel.org>
Date: Mon, 07 Jul 2014 13:36:57 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
CC: julia.lawall@lip6.fr, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] staging: iio: Introduce the use of devm_ioremap_resource
References: <20140701184413.GA2980@himangi-Dell>
In-Reply-To: <20140701184413.GA2980@himangi-Dell>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/14 19:44, Himangi Saraogi wrote:
> This patch introduces the use of devm_ioremap_resource. It does away
> with call to request_mem_region and the error checking on
> platform_get_resource. Also, the calls to free the allocated resources
> like release_mem_region and iounmap are done away with. The ret variable
> in the probe function is also eliminated. Also, a bug is fixed as the
> goto in the error handling of request_mem_region should not have
> called release_mem_region which releases a resource that has not been
> allocated.
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Again, looks superficially fine, but I'd like an ack from someone
at Analog ideally.
Cc'd Lars
> ---
>   drivers/staging/iio/adc/ad7606_par.c | 37 ++++++------------------------------
>   1 file changed, 6 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/staging/iio/adc/ad7606_par.c b/drivers/staging/iio/adc/ad7606_par.c
> index 8a48d18..7511839 100644
> --- a/drivers/staging/iio/adc/ad7606_par.c
> +++ b/drivers/staging/iio/adc/ad7606_par.c
> @@ -53,7 +53,7 @@ static int ad7606_par_probe(struct platform_device *pdev)
>   	struct iio_dev *indio_dev;
>   	void __iomem *addr;
>   	resource_size_t remap_size;
> -	int ret, irq;
> +	int irq;
>
>   	irq = platform_get_irq(pdev, 0);
>   	if (irq < 0) {
> @@ -62,56 +62,31 @@ static int ad7606_par_probe(struct platform_device *pdev)
>   	}
>
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -ENODEV;
> +	addr = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(addr))
> +		return PTR_ERR(addr);
>
>   	remap_size = resource_size(res);
>
> -	/* Request the regions */
> -	if (!request_mem_region(res->start, remap_size, "iio-ad7606")) {
> -		ret = -EBUSY;
> -		goto out1;
> -	}
> -	addr = ioremap(res->start, remap_size);
> -	if (!addr) {
> -		ret = -ENOMEM;
> -		goto out1;
> -	}
> -
>   	indio_dev = ad7606_probe(&pdev->dev, irq, addr,
>   			  platform_get_device_id(pdev)->driver_data,
>   			  remap_size > 1 ? &ad7606_par16_bops :
>   			  &ad7606_par8_bops);
>
> -	if (IS_ERR(indio_dev))  {
> -		ret = PTR_ERR(indio_dev);
> -		goto out2;
> -	}
> +	if (IS_ERR(indio_dev))
> +		return PTR_ERR(indio_dev);
>
>   	platform_set_drvdata(pdev, indio_dev);
>
>   	return 0;
> -
> -out2:
> -	iounmap(addr);
> -out1:
> -	release_mem_region(res->start, remap_size);
> -
> -	return ret;
>   }
>
>   static int ad7606_par_remove(struct platform_device *pdev)
>   {
>   	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> -	struct resource *res;
> -	struct ad7606_state *st = iio_priv(indio_dev);
>
>   	ad7606_remove(indio_dev, platform_get_irq(pdev, 0));
>
> -	iounmap(st->base_address);
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(res->start, resource_size(res));
> -
>   	return 0;
>   }
>
>

