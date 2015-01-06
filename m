Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbbAFFln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 00:41:43 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:63312 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbAFFll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 00:41:41 -0500
MIME-Version: 1.0
In-Reply-To: <E1Y884W-0001G0-7b@stardust.g4.wien.funkfeuer.at>
References: <E1Y884W-0001G0-7b@stardust.g4.wien.funkfeuer.at>
Date: Tue, 6 Jan 2015 11:11:40 +0530
Message-ID: <CAGUYZuQCUj2+yTaB_UHOSJ3-15gegpUsDZMdC0fgG9jd6CcCfg@mail.gmail.com>
Subject: Re: [PATCHv2 2/3] iio: dht11: Add locking
From: sanjeev sharma <sanjeevsharmaengg@gmail.com>
To: Harald Geyer <harald@ccbib.org>
Cc: Jonathan Cameron <jic23@kernel.org>, Richard Weinberger <richard@nod.at>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        sanjeevs1 <sanjeev_sharma@mentor.com>, linux-iio@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 7:21 PM, Harald Geyer <harald@ccbib.org> wrote:
> Make sure that the read function is not interrupted...
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Acked-by: Harald Geyer <harald@ccbib.org>
   Reviewed-by: Sanjeev Sharma <sanjeev_sharma@mentor.com>
> ---
> Resending for Richard Weinberger.
> No changes since v1 except reordering.
>
>  drivers/iio/humidity/dht11.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
> index f546eca..7717f5c 100644
> --- a/drivers/iio/humidity/dht11.c
> +++ b/drivers/iio/humidity/dht11.c
> @@ -29,6 +29,7 @@
>  #include <linux/wait.h>
>  #include <linux/bitops.h>
>  #include <linux/completion.h>
> +#include <linux/mutex.h>
>  #include <linux/delay.h>
>  #include <linux/gpio.h>
>  #include <linux/of_gpio.h>
> @@ -57,6 +58,7 @@ struct dht11 {
>         int                             irq;
>
>         struct completion               completion;
> +       struct mutex                    lock;
>
>         s64                             timestamp;
>         int                             temperature;
> @@ -145,6 +147,7 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>         struct dht11 *dht11 = iio_priv(iio_dev);
>         int ret;
>
> +       mutex_lock(&dht11->lock);
>         if (dht11->timestamp + DHT11_DATA_VALID_TIME < iio_get_time_ns()) {
>                 reinit_completion(&dht11->completion);
>
> @@ -185,6 +188,7 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>                 ret = -EINVAL;
>  err:
>         dht11->num_edges = -1;
> +       mutex_unlock(&dht11->lock);
>         return ret;
>  }
>
> @@ -268,6 +272,7 @@ static int dht11_probe(struct platform_device *pdev)
>         platform_set_drvdata(pdev, iio);
>
>         init_completion(&dht11->completion);
> +       mutex_init(&dht11->lock);
>         iio->name = pdev->name;
>         iio->dev.parent = &pdev->dev;
>         iio->info = &dht11_iio_info;
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
