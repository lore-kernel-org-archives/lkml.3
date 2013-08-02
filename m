Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab3HBMG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:06:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36518 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab3HBMGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:06:55 -0400
Message-ID: <51FBA0BB.6080408@ti.com>
Date: Fri, 2 Aug 2013 08:06:19 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Richard Zhao <rizhao@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vinod.koul@intel.com>,
        <djbw@fb.com>, <swarren@wwwdotorg.org>
Subject: Re: [PATCH] DMA: let filter functions of of_dma_simple_xlate possible
 check of_node
References: <1375408800-11789-1-git-send-email-rizhao@nvidia.com>
In-Reply-To: <1375408800-11789-1-git-send-email-rizhao@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 August 2013 10:00 PM, Richard Zhao wrote:
> pass of_phandle_args dma_spec to dma_request_channel in of_dma_simple_xlate,
> so the filter function could access of_node in of_phandle_args.
>
Am just curious the reasoning behind doing so. Can you please expand
above bit more with why you need to change it.
 
> It also remove restriction of #dma-cells has to be one.
> 
> Signed-off-by: Richard Zhao <rizhao@nvidia.com>
> ---
>  drivers/dma/edma.c     |  7 +++++--
>  drivers/dma/of-dma.c   | 10 ++++------
>  drivers/dma/omap-dma.c |  6 ++++--
>  3 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 4f6d87b..54582fd 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -23,6 +23,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
> +#include <linux/of_dma.h>
>  
>  #include <linux/platform_data/edma.h>
>  
> @@ -604,9 +605,11 @@ static struct platform_driver edma_driver = {
>  
>  bool edma_filter_fn(struct dma_chan *chan, void *param)
>  {
> -	if (chan->device->dev->driver == &edma_driver.driver) {
> +	struct of_phandle_args *dma_spec = param;
> +	if (chan->device->dev->driver == &edma_driver.driver &&
> +			dma_spec->np == chan->device->dev->of_node) {
>  		struct edma_chan *echan = to_edma_chan(chan);
> -		unsigned ch_req = *(unsigned *)param;
> +		unsigned ch_req = dma_spec->args[0];
>  		return ch_req == echan->ch_num;
>  	}
>  	return false;
> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> index 75334bd..e1c4d3b 100644
> --- a/drivers/dma/of-dma.c
> +++ b/drivers/dma/of-dma.c
> @@ -192,11 +192,9 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
>   * @dma_spec:	pointer to DMA specifier as found in the device tree
>   * @of_dma:	pointer to DMA controller data
>   *
> - * A simple translation function for devices that use a 32-bit value for the
> + * A simple translation function for devices that use dma_spec for the
>   * filter_param when calling the DMA engine dma_request_channel() function.
> - * Note that this translation function requires that #dma-cells is equal to 1
> - * and the argument of the dma specifier is the 32-bit filter_param. Returns
> - * pointer to appropriate dma channel on success or NULL on error.
> + * Returns pointer to appropriate dma channel on success or NULL on error.
>   */
>  struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
>  						struct of_dma *ofdma)
> @@ -207,10 +205,10 @@ struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
>  	if (!info || !info->filter_fn)
>  		return NULL;
>  
> -	if (count != 1)
> +	if (count < 1)
>  		return NULL;
>  
>  	return dma_request_channel(info->dma_cap, info->filter_fn,
> -			&dma_spec->args[0]);
> +			dma_spec);
>  }
>  EXPORT_SYMBOL_GPL(of_dma_simple_xlate);
> diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
> index ec3fc4f..32547ec 100644
> --- a/drivers/dma/omap-dma.c
> +++ b/drivers/dma/omap-dma.c
> @@ -693,9 +693,11 @@ static struct platform_driver omap_dma_driver = {
>  
>  bool omap_dma_filter_fn(struct dma_chan *chan, void *param)
>  {
> -	if (chan->device->dev->driver == &omap_dma_driver.driver) {
> +	struct of_phandle_args *dma_spec = param;
> +	if (chan->device->dev->driver == &omap_dma_driver.driver &&
> +			dma_spec->np == chan->device->dev->of_node) {
>  		struct omap_chan *c = to_omap_dma_chan(chan);
> -		unsigned req = *(unsigned *)param;
> +		unsigned req = dma_spec->args[0];
>  
>  		return req == c->dma_sig;
>  	}
> 

