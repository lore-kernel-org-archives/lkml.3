Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaGGMcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:32:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:57570 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbaGGMcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:32:48 -0400
Message-ID: <53BA93F2.2090200@kernel.org>
Date: Mon, 07 Jul 2014 13:34:58 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
CC: julia.lawall@lip6.fr, Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>
Subject: Re: [PATCH v2] iio:trigger: Introduce the use of devm_kzalloc
References: <20140701211908.GA23193@himangi-Dell>
In-Reply-To: <20140701211908.GA23193@himangi-Dell>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/14 22:19, Himangi Saraogi wrote:
> This patch introduces the use of the managed version of kzalloc and
> removes the kfrees in the probe and remove functions. More return
> paths are added and the labels are renamed to order them.
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Looks sane, but I'd like an ack or reviewed-by from someone as Analog for this one.
cc'd Lars and Michael.

> ---
> v2: add more return paths
> Not compile tested.
>   drivers/staging/iio/trigger/iio-trig-bfin-timer.c | 31 ++++++++---------------
>   1 file changed, 11 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/staging/iio/trigger/iio-trig-bfin-timer.c b/drivers/staging/iio/trigger/iio-trig-bfin-timer.c
> index 16f1a06..a21b7c5 100644
> --- a/drivers/staging/iio/trigger/iio-trig-bfin-timer.c
> +++ b/drivers/staging/iio/trigger/iio-trig-bfin-timer.c
> @@ -182,45 +182,40 @@ static int iio_bfin_tmr_trigger_probe(struct platform_device *pdev)
>   	unsigned int config;
>   	int ret;
>
> -	st = kzalloc(sizeof(*st), GFP_KERNEL);
> -	if (st == NULL) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> +	st = devm_kzalloc(&pdev->dev, sizeof(*st), GFP_KERNEL);
> +	if (st == NULL)
> +		return -ENOMEM;
>
>   	st->irq = platform_get_irq(pdev, 0);
>   	if (!st->irq) {
>   		dev_err(&pdev->dev, "No IRQs specified");
> -		ret = -ENODEV;
> -		goto out1;
> +		return -ENODEV;
>   	}
>
>   	ret = iio_bfin_tmr_get_number(st->irq);
>   	if (ret < 0)
> -		goto out1;
> +		return ret;
>
>   	st->timer_num = ret;
>   	st->t = &iio_bfin_timer_code[st->timer_num];
>
>   	st->trig = iio_trigger_alloc("bfintmr%d", st->timer_num);
> -	if (!st->trig) {
> -		ret = -ENOMEM;
> -		goto out1;
> -	}
> +	if (!st->trig)
> +		return -ENOMEM;
>
>   	st->trig->ops = &iio_bfin_tmr_trigger_ops;
>   	st->trig->dev.groups = iio_bfin_tmr_trigger_attr_groups;
>   	iio_trigger_set_drvdata(st->trig, st);
>   	ret = iio_trigger_register(st->trig);
>   	if (ret)
> -		goto out2;
> +		goto out;
>
>   	ret = request_irq(st->irq, iio_bfin_tmr_trigger_isr,
>   			  0, st->trig->name, st);
>   	if (ret) {
>   		dev_err(&pdev->dev,
>   			"request IRQ-%d failed", st->irq);
> -		goto out4;
> +		goto out1;
>   	}
>
>   	config = PWM_OUT | PERIOD_CNT | IRQ_ENA;
> @@ -260,13 +255,10 @@ static int iio_bfin_tmr_trigger_probe(struct platform_device *pdev)
>   	return 0;
>   out_free_irq:
>   	free_irq(st->irq, st);
> -out4:
> -	iio_trigger_unregister(st->trig);
> -out2:
> -	iio_trigger_put(st->trig);
>   out1:
> -	kfree(st);
> +	iio_trigger_unregister(st->trig);
>   out:
> +	iio_trigger_put(st->trig);
>   	return ret;
>   }
>
> @@ -280,7 +272,6 @@ static int iio_bfin_tmr_trigger_remove(struct platform_device *pdev)
>   	free_irq(st->irq, st);
>   	iio_trigger_unregister(st->trig);
>   	iio_trigger_put(st->trig);
> -	kfree(st);
>
>   	return 0;
>   }
>

