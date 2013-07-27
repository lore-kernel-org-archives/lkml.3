Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3G0XdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 19:33:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54893 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3G0XdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 19:33:21 -0400
Message-ID: <51F4589E.5070108@ti.com>
Date: Sat, 27 Jul 2013 18:32:46 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Vinod Koul <vinod.koul@intel.com>,
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
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony or Sekhar,

If this patch looks ok, could you pick it up for -rc cycle?

It fixes DMA breakages after the merge window for devices for which DMA
resources are being populated in device tree instead pdev.

Thanks,

-Joel


On 07/22/2013 12:59 PM, Joel Fernandes wrote:
> HWMOD removal for MMC is breaking edma_start as the events are being manually
> triggered due to unused channel list not being clear, Thanks to Balaji TK for
> finding this issue.
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
>  		}
>  	}
>  
> 

