Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaLNMbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 07:31:41 -0500
Received: from mout.gmx.net ([212.227.15.19]:52768 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbaLNMbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 07:31:37 -0500
Message-ID: <548D8317.2070405@gmx.de>
Date: Sun, 14 Dec 2014 13:31:19 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, jic23@kernel.org
CC: harald@ccbib.org, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] iio: dht11: Add locking
References: <1417563176-31972-1-git-send-email-richard@nod.at> <1417563176-31972-2-git-send-email-richard@nod.at>
In-Reply-To: <1417563176-31972-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V03:K0:qujGH70nDI9/ezMf11tpxxkg9r/iVl/eo7Mzc8EGo9hEGcvhsZ2
 iZdDchaXwaO1yc+4q+5EaptOj/CAjgXdfowWufHgxn9ROsCe6frQlqFTw3vX4XHxAYMpoNx
 FCrCIdTUDa0gXxMRhPhH9CQ9Y2IBLBkJ3Pj27E475TGQJzUx1hKtpVpRYQ59Dh+kWkWXDP+
 N7NluUy5nnNr1Uz60w+rw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger schrieb am 03.12.2014 um 00:32:
> Make sure that the read function is not interrupted...
There is already a mutex iio_dev->info_exist_lock used to serialize
iio_channel_read(), which in turn accesses _read_raw(). See [1].

[1]http://lxr.free-electrons.com/ident?i=iio_channel_read
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/iio/humidity/dht11.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
> index d8771f5..168ebc4 100644
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
>  	int				irq;
>  
>  	struct completion		completion;
> +	struct mutex			lock;
>  
>  	s64				timestamp;
>  	int				temperature;
> @@ -145,6 +147,7 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>  	struct dht11 *dht11 = iio_priv(iio_dev);
>  	int ret;
>  
> +	mutex_lock(&dht11->lock);
>  	if (dht11->timestamp + DHT11_DATA_VALID_TIME < iio_get_time_ns()) {
>  		reinit_completion(&dht11->completion);
>  
> @@ -185,6 +188,7 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
>  		ret = -EINVAL;
>  err:
>  	dht11->num_edges = -1;
> +	mutex_unlock(&dht11->lock);
>  	return ret;
>  }
>  
> @@ -268,6 +272,7 @@ static int dht11_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, iio);
>  
>  	init_completion(&dht11->completion);
> +	mutex_init(&dht11->lock);
>  	iio->name = pdev->name;
>  	iio->dev.parent = &pdev->dev;
>  	iio->info = &dht11_iio_info;
> 

