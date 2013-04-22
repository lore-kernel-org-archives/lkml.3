Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab3DVKeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:34:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:48369 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab3DVKeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:34:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="322859805"
Date: Mon, 22 Apr 2013 15:32:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 23/32] dmaengine: ste_dma40: Allow driver to be
 probe()able when DT is enabled
Message-ID: <20130422100257.GO24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-24-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-24-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:12:05AM +0100, Lee Jones wrote:
> When booting using Device Tree, devices aren't registered in the normal
> way. Instead, they need to be provided with a compatible string which is
> held in an OF Match Table for comparison during start-up. Here we provide
> the compatible string and prepare the driver to not receive a platform
> data pointer.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
> ---
>  drivers/dma/ste_dma40.c |   42 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 6f9f801..4782ee7 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -17,6 +17,7 @@
>  #include <linux/pm.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/err.h>
> +#include <linux/of.h>
>  #include <linux/amba/bus.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/platform_data/dma-ste-dma40.h>
> @@ -3452,17 +3453,48 @@ failure:
>  	return ret;
>  }
>  
> +static int __init d40_of_probe(struct platform_device *pdev,
> +			       struct device_node *np)
> +{
> +	/*
> +	 * FIXME: Fill in this routine as more support is added.
> +	 * First platform enabled (u8500) doens't need any extra
> +	 * properties to run, so this is fairly sparce currently.
> +	 */
> +	pdev->dev.platform_data =
> +		devm_kzalloc(&pdev->dev,
> +			     sizeof(struct stedma40_platform_data),
> +			     GFP_KERNEL);
> +	if (!pdev->dev.platform_data)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
>  static int __init d40_probe(struct platform_device *pdev)
>  {
> +	struct stedma40_platform_data *plat_data = pdev->dev.platform_data;
> +	struct device_node *np = pdev->dev.of_node;
>  	int err;
>  	int ret = -ENOENT;
> -	struct d40_base *base;
> +	struct d40_base *base = NULL;
>  	struct resource *res = NULL;
>  	int num_reserved_chans;
>  	u32 val;
>  
> -	base = d40_hw_detect_init(pdev);
> +	if (!plat_data) {
> +		if (np) {
> +			if(d40_of_probe(pdev, np)) {
> +				ret = -ENOMEM;
> +				goto failure;
> +			}
> +		} else {
> +			d40_err(&pdev->dev, "No pdata or Device Tree provided\n");
> +			goto failure;
> +		}
> +	}
>  
> +	base = d40_hw_detect_init(pdev);
>  	if (!base)
>  		goto failure;
>  
> @@ -3636,11 +3668,17 @@ failure:
>  	return ret;
>  }
>  
> +static const struct of_device_id d40_match[] = {
> +        { .compatible = "stericsson,dma40", },
> +        {}
> +};
> +
>  static struct platform_driver d40_driver = {
>  	.driver = {
>  		.owner = THIS_MODULE,
>  		.name  = D40_NAME,
>  		.pm = DMA40_PM_OPS,
> +		.of_match_table = d40_match,
>  	},
>  };
>  
> -- 
> 1.7.10.4
> 
