Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab3G2HCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:02:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43904 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab3G2HCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:02:10 -0400
Message-ID: <51F61359.1090309@ti.com>
Date: Mon, 29 Jul 2013 12:31:45 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Vinod Koul <vinod.koul@intel.com>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Balaji TK <balajitk@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Kridner <jkridner@beagleboard.org>,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v2] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1374515989-7391-1-git-send-email-joelf@ti.com>
In-Reply-To: <1374515989-7391-1-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 July 2013 11:29 PM, Joel Fernandes wrote:
> HWMOD removal for MMC is breaking edma_start as the events are being manually
> triggered due to unused channel list not being clear, Thanks to Balaji TK for
> finding this issue.

So, Reported-by: Balaji T K <balajitk@ti.com>

?

> 
> This patch fixes the issue, by reading the "dmas" property from the DT node if
> it exists and clearing the bits in the unused channel list.
> 
> Cc: Balaji T K <balajitk@ti.com>
> Cc: Pantel Antoniou <panto@antoniou-consulting.com>
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
> v2 changes: Fixed compiler warning
> 
>  arch/arm/common/edma.c |   31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index a432e6c..765d578 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -561,14 +561,29 @@ static int reserve_contiguous_slots(int ctlr, unsigned int id,
>  static int prepare_unused_channel_list(struct device *dev, void *data)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
> -	int i, ctlr;
> -
> -	for (i = 0; i < pdev->num_resources; i++) {
> -		if ((pdev->resource[i].flags & IORESOURCE_DMA) &&
> -				(int)pdev->resource[i].start >= 0) {
> -			ctlr = EDMA_CTLR(pdev->resource[i].start);
> -			clear_bit(EDMA_CHAN_SLOT(pdev->resource[i].start),
> -					edma_cc[ctlr]->edma_unused);
> +	int i = 0, ctlr;
> +	u32 dma_chan;
> +	const __be32 *dma_chan_p;
> +	struct property *prop;
> +
> +	if (dev->of_node) {
> +		of_property_for_each_u32(dev->of_node, "dmas", prop, \
> +					 dma_chan_p, dma_chan) {
> +			if (i++ & 1) {
> +				ctlr = EDMA_CTLR(dma_chan);
> +				clear_bit(EDMA_CHAN_SLOT(dma_chan),
> +						edma_cc[ctlr]->edma_unused);
> +			}

I think it will be cleaner if you use of_property_count_strings() on
dma-names to get the count of DMA channels for this device and then use
of_parse_phandle_with_args() to get access to the args. Honestly, I have
not used these APIs myself, so if this doesn’t work the way I think it
should then let me know and I will try to do some experiments myself.

The current way of skipping over even fields really depends on
#dma-cells for EDMA to be 1. That in itself is not such a bad
assumption, but if you have APIs which already take care of this for
you, why not use them?

> +		}
> +	} else {
> +		for (; i < pdev->num_resources; i++) {
> +			if ((pdev->resource[i].flags & IORESOURCE_DMA) &&
> +			    (int)pdev->resource[i].start >= 0) {
> +				ctlr = EDMA_CTLR(pdev->resource[i].start);
> +				clear_bit(EDMA_CHAN_SLOT(
> +					  pdev->resource[i].start),
> +					  edma_cc[ctlr]->edma_unused);
> +			}

So there is very little in common between OF and non-OF versions of this
function. Why not have two different versions of this function for the
two cases? The OF version can reside under the CONFIG_OF conditional
already in use in the file. This will also save you the ugly line breaks
you had to resort to due to too deep indentation.

Thanks,
Sekhar
