Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864Ab3CZPCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:02:54 -0400
Received: from smtp-out-226.synserver.de ([212.40.185.226]:1068 "EHLO
	smtp-out-226.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934581Ab3CZPCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:02:51 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8713
Message-ID: <5151B91B.7060404@metafoo.de>
Date: Tue, 26 Mar 2013 16:04:59 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH v2 3/4] dw_dmac: make wrapper on of_dma_controller_register()
References: <1364309637-25860-1-git-send-email-andriy.shevchenko@linux.intel.com> <1364309637-25860-4-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1364309637-25860-4-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 03:53 PM, Andy Shevchenko wrote:
> This patch introduces new method dw_dma_of_controller_register() and adds
> checks of the of_node presence together with CONFIG_OF before calling the
> wrapper. It helps to distinguish the real -ENODEV return code of fake one when
> of_dma_controller_register is not implemented.

If CONFIG_OF is not set the of_node of the device will always be NULL. Which
means of_dma_controller_register() will only be called if it is implemented.
So you'll never get the -ENODEV from the of_dma_controller_register() stub.

- Lars

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 274fd7d..c1f017b 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1303,6 +1303,16 @@ static struct dma_chan *dw_dma_of_xlate(struct of_phandle_args *dma_spec,
>  	return dma_request_channel(cap, dw_dma_of_filter, &fargs);
>  }
>  
> +static void dw_dma_of_controller_register(struct dw_dma *dw)
> +{
> +	struct device *dev = dw->dma.dev;
> +	int err;
> +
> +	err = of_dma_controller_register(dev->of_node, dw_dma_of_xlate, dw);
> +	if (err)
> +		dev_err(dev, "could not register of_dma_controller\n");
> +}
> +
>  /* --------------------- Cyclic DMA API extensions -------------------- */
>  
>  /**
> @@ -1843,13 +1853,8 @@ static int dw_probe(struct platform_device *pdev)
>  
>  	dma_async_device_register(&dw->dma);
>  
> -	if (pdev->dev.of_node) {
> -		err = of_dma_controller_register(pdev->dev.of_node,
> -						 dw_dma_of_xlate, dw);
> -		if (err && err != -ENODEV)
> -			dev_err(&pdev->dev,
> -				"could not register of_dma_controller\n");
> -	}
> +	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node)
> +		dw_dma_of_controller_register(dw);
>  
>  	return 0;
>  }

