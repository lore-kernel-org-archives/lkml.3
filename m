Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaEVOuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 10:50:37 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:53006 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaEVOug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 10:50:36 -0400
X-Greylist: delayed 1860 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 May 2014 10:50:36 EDT
Date: Thu, 22 May 2014 16:47:58 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: uio_dmem_genirq: Fix memory leak in
 uio_dmem_genirq_probe()
Message-ID: <20140522144758.GA4500@silverbox.local>
References: <20140522004611.GA1216@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522004611.GA1216@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 09:46:12AM +0900, Daeseok Youn wrote:
> When platform_get_irq() is failed after "priv" allocated,
> it need to free "priv". But the label of bad0 doesn't try
> to free about "priv". So this patch changes that lable to "bad1".
> But "bad1" has pm_runtime_disable() call, this function should
> be called when uio_register_device() is failed. So it is moved
> into handling error for uio_register_device().

Looks alright to me. Thanks for your contribution.

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>

> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/uio/uio_dmem_genirq.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
> index 1270f3b..8d0bba4 100644
> --- a/drivers/uio/uio_dmem_genirq.c
> +++ b/drivers/uio/uio_dmem_genirq.c
> @@ -204,7 +204,7 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
>  		ret = platform_get_irq(pdev, 0);
>  		if (ret < 0) {
>  			dev_err(&pdev->dev, "failed to get IRQ\n");
> -			goto bad0;
> +			goto bad1;
>  		}
>  		uioinfo->irq = ret;
>  	}
> @@ -275,6 +275,7 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
>  	ret = uio_register_device(&pdev->dev, priv->uioinfo);
>  	if (ret) {
>  		dev_err(&pdev->dev, "unable to register uio device\n");
> +		pm_runtime_disable(&pdev->dev);
>  		goto bad1;
>  	}
>  
> @@ -282,7 +283,6 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
>  	return 0;
>   bad1:
>  	kfree(priv);
> -	pm_runtime_disable(&pdev->dev);
>   bad0:
>  	/* kfree uioinfo for OF */
>  	if (pdev->dev.of_node)
> -- 
> 1.7.1
> 
> 
