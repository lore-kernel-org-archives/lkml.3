Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaIKRnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:43:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43531 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaIKRnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:43:23 -0400
Message-ID: <1410457391.4011.87.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH] [media] coda: Improve runtime PM support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 11 Sep 2014 19:43:11 +0200
In-Reply-To: <1410356613-16811-1-git-send-email-ulf.hansson@linaro.org>
References: <1410356613-16811-1-git-send-email-ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

thanks for the patch!

Am Mittwoch, den 10.09.2014, 15:43 +0200 schrieb Ulf Hansson:
> For several reasons it's good practice to leave devices in runtime PM
> active state while those have been probed.

It would be nice to mention those reasons.

> In this cases we also want to prevent the device from going inactive,
> until the firmware has been completely installed, especially when using
> a PM domain.
> 
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/media/platform/coda/coda-common.c | 42 ++++++++-----------------------
>  1 file changed, 11 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 0997b5c..361f28d 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1703,39 +1703,16 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
>  	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
>  	release_firmware(fw);
>  
> -	if (pm_runtime_enabled(&pdev->dev) && pdev->dev.pm_domain) {
> -		/*
> -		 * Enabling power temporarily will cause coda_hw_init to be
> -		 * called via coda_runtime_resume by the pm domain.
> -		 */
> -		ret = pm_runtime_get_sync(&dev->plat_dev->dev);
> -		if (ret < 0) {
> -			v4l2_err(&dev->v4l2_dev, "failed to power on: %d\n",
> -				 ret);
> -			return;
> -		}
> -
> -		ret = coda_check_firmware(dev);
> -		if (ret < 0)
> -			return;
> -
> -		pm_runtime_put_sync(&dev->plat_dev->dev);
> -	} else {
> -		/*
> -		 * If runtime pm is disabled or pm_domain is not set,
> -		 * initialize once manually.
> -		 */
> -		ret = coda_hw_init(dev);
> -		if (ret < 0) {
> -			v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
> -			return;
> -		}
> -
> -		ret = coda_check_firmware(dev);
> -		if (ret < 0)
> -			return;
> +	ret = coda_hw_init(dev);
> +	if (ret < 0) {
> +		v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
> +		return;
>  	}
>  
> +	ret = coda_check_firmware(dev);
> +	if (ret < 0)
> +		return;
> +

Won't this keep the PM domain active indefinitely if hw_init or
check_firmware fails? Other than that, this is a great change.

>  	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
>  	if (IS_ERR(dev->alloc_ctx)) {
>  		v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
> @@ -1771,6 +1748,7 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
>  	v4l2_info(&dev->v4l2_dev, "codec registered as /dev/video[%d-%d]\n",
>  		  dev->vfd[0].num, dev->vfd[1].num);
>  
> +	pm_runtime_put_sync(&pdev->dev);
>  	return;
>  
>  rel_m2m:
> @@ -1998,6 +1976,8 @@ static int coda_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, dev);
>  
> +	pm_runtime_get_noresume(&pdev->dev);
> +	pm_runtime_set_active(&pdev->dev);

Should we have a comment here why this is necessary?

regards
Philipp

