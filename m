Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab3A1QZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:25:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:9470 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab3A1QZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:25:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,551,1355126400"; 
   d="scan'208";a="283120412"
Date: Mon, 28 Jan 2013 08:00:20 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 07/33] dma: Convert to devm_ioremap_resource()
Message-ID: <20130128160020.GY26562@intel.com>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-8-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358762966-20791-8-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:09:00AM +0100, Thierry Reding wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
Where is this symbol, applying this results in build failures for me?

> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Vinod Koul <vinod.koul@intel.com>
> ---
>  drivers/dma/dw_dmac.c         |  7 ++++---
>  drivers/dma/imx-dma.c         |  7 ++++---
>  drivers/dma/mmp_pdma.c        |  7 ++++---
>  drivers/dma/mmp_tdma.c        |  7 ++++---
>  drivers/dma/tegra20-apb-dma.c | 10 ++++------
>  5 files changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 3e8ba02..b33d1f6 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -14,6 +14,7 @@
>  #include <linux/delay.h>
>  #include <linux/dmaengine.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> @@ -1489,9 +1490,9 @@ static int dw_probe(struct platform_device *pdev)
>  	if (irq < 0)
>  		return irq;
>  
> -	regs = devm_request_and_ioremap(&pdev->dev, io);
> -	if (!regs)
> -		return -EBUSY;
> +	regs = devm_ioremap_resource(&pdev->dev, io);
> +	if (IS_ERR(regs))
> +		return PTR_ERR(regs);
>  
>  	dw_params = dma_read_byaddr(regs, DW_PARAMS);
>  	autocfg = dw_params >> DW_PARAMS_EN & 0x1;
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index dbf0e6f..84ae491 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -14,6 +14,7 @@
>   * http://www.opensource.org/licenses/gpl-license.html
>   * http://www.gnu.org/copyleft/gpl.html
>   */
> +#include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/mm.h>
> @@ -1011,9 +1012,9 @@ static int __init imxdma_probe(struct platform_device *pdev)
>  	imxdma->devtype = pdev->id_entry->driver_data;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	imxdma->base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!imxdma->base)
> -		return -EADDRNOTAVAIL;
> +	imxdma->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(imxdma->base))
> +		return PTR_ERR(imxdma->base);
>  
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0)
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index c6d98c0..dc74665 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -5,6 +5,7 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> +#include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> @@ -782,9 +783,9 @@ static int mmp_pdma_probe(struct platform_device *op)
>  	if (!iores)
>  		return -EINVAL;
>  
> -	pdev->base = devm_request_and_ioremap(pdev->dev, iores);
> -	if (!pdev->base)
> -		return -EADDRNOTAVAIL;
> +	pdev->base = devm_ioremap_resource(pdev->dev, iores);
> +	if (IS_ERR(pdev->base))
> +		return PTR_ERR(pdev->base);
>  
>  	of_id = of_match_device(mmp_pdma_dt_ids, pdev->dev);
>  	if (of_id)
> diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
> index a9f1cd5..43d5a6c 100644
> --- a/drivers/dma/mmp_tdma.c
> +++ b/drivers/dma/mmp_tdma.c
> @@ -9,6 +9,7 @@
>   *
>   */
>  
> +#include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> @@ -547,9 +548,9 @@ static int mmp_tdma_probe(struct platform_device *pdev)
>  	if (!iores)
>  		return -EINVAL;
>  
> -	tdev->base = devm_request_and_ioremap(&pdev->dev, iores);
> -	if (!tdev->base)
> -		return -EADDRNOTAVAIL;
> +	tdev->base = devm_ioremap_resource(&pdev->dev, iores);
> +	if (IS_ERR(tdev->base))
> +		return PTR_ERR(tdev->base);
>  
>  	INIT_LIST_HEAD(&tdev->device.channels);
>  
> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> index c39e61b..7d6d8b4 100644
> --- a/drivers/dma/tegra20-apb-dma.c
> +++ b/drivers/dma/tegra20-apb-dma.c
> @@ -21,6 +21,7 @@
>  #include <linux/delay.h>
>  #include <linux/dmaengine.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> @@ -1236,12 +1237,9 @@ static int tegra_dma_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	tdma->base_addr = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!tdma->base_addr) {
> -		dev_err(&pdev->dev,
> -			"Cannot request memregion/iomap dma address\n");
> -		return -EADDRNOTAVAIL;
> -	}
> +	tdma->base_addr = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(tdma->base_addr))
> +		return PTR_ERR(tdma->base_addr);
>  
>  	tdma->dma_clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(tdma->dma_clk)) {
> -- 
> 1.8.1.1
> 
