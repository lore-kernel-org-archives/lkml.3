Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbaGQUrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:47:13 -0400
Received: from smtp-out-180.synserver.de ([212.40.185.180]:1067 "EHLO
	smtp-out-180.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaGQUrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:47:10 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29258
Message-ID: <53C8364D.6010908@metafoo.de>
Date: Thu, 17 Jul 2014 22:47:09 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
CC: julia.lawall@lip6.fr
Subject: Re: [PATCH] staging: iio: adis16203: Use devm_iio_device_register
References: <20140717204040.GA22788@himangi-Dell>
In-Reply-To: <20140717204040.GA22788@himangi-Dell>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 10:40 PM, Himangi Saraogi wrote:
> This patch introduces the use of iio_device_register and does away with
> the call to the corressponding unregister function in the probe and
> remove functions of the driver respectively.
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

No, you changed the relative order in which iio_device_unregister() and 
adis_cleanup_buffer_and_trigger() are called, this opens up the way for race 
conditions. Rule of thumb: Don't convert drivers to managed functions if 
this will change the order in which functions will called on device removal.

- Lars

> ---
>   drivers/staging/iio/accel/adis16203_core.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/iio/accel/adis16203_core.c b/drivers/staging/iio/accel/adis16203_core.c
> index 409a28e..5077779 100644
> --- a/drivers/staging/iio/accel/adis16203_core.c
> +++ b/drivers/staging/iio/accel/adis16203_core.c
> @@ -175,7 +175,7 @@ static int adis16203_probe(struct spi_device *spi)
>   	if (ret)
>   		goto error_cleanup_buffer_trigger;
>
> -	ret = iio_device_register(indio_dev);
> +	ret = devm_iio_device_register(&spi->dev, indio_dev);
>   	if (ret)
>   		goto error_cleanup_buffer_trigger;
>
> @@ -191,7 +191,6 @@ static int adis16203_remove(struct spi_device *spi)
>   	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>   	struct adis *st = iio_priv(indio_dev);
>
> -	iio_device_unregister(indio_dev);
>   	adis_cleanup_buffer_and_trigger(st, indio_dev);
>
>   	return 0;
>

