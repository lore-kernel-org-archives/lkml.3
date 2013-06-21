Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3FUKNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:13:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55890 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3FUKNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:13:23 -0400
Message-ID: <51C42705.1060803@ti.com>
Date: Fri, 21 Jun 2013 15:42:21 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joel A Fernandes <joelagnel@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v12 03/11] ARM: edma: Add EDMA crossbar event mux support
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <1371762407-24544-4-git-send-email-joelagnel@ti.com>
In-Reply-To: <1371762407-24544-4-git-send-email-joelagnel@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/2013 2:36 AM, Joel A Fernandes wrote:
> From: Matt Porter <mporter@ti.com>
> 
> 

You should add a description apart from just documenting what you
changed in this patch.

Changes by Joel:
> * Split EDMA xbar support out of original EDMA DT parsing patch
> to keep it easier for review.
> * Rewrite shift and offset calculation.
> 
> Suggested-by: Sekhar Nori <nsekhar@ti.com>
> Suggested by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
> 
> Reference:
> [1] https://patchwork.kernel.org/patch/2226991/
> ---
>  arch/arm/common/edma.c             |   62 +++++++++++++++++++++++++++++++++++-
>  include/linux/platform_data/edma.h |    1 +
>  2 files changed, 62 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index 407e01e..a03d4f0 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -568,7 +568,7 @@ static int prepare_unused_channel_list(struct device *dev, void *data)
>  				(int)pdev->resource[i].start >= 0) {
>  			ctlr = EDMA_CTLR(pdev->resource[i].start);
>  			clear_bit(EDMA_CHAN_SLOT(pdev->resource[i].start),
> -					edma_cc[ctlr]->edma_unused);
> +						edma_cc[ctlr]->edma_unused);

There are two problems with this hunk:

1) It does not belong to this patch. I said that earlier.
2) It actually introduces a new checkpatch issue.

I dropped this hunk.

>  		}
>  	}
>  
> @@ -1393,6 +1393,52 @@ static int edma_of_read_u32_to_s16_array(const struct device_node *np,
>  	return 0;
>  }
>  
> +static int edma_xbar_event_map(struct device *dev,
> +			       struct device_node *node,
> +			       struct edma_soc_info *pdata, int len)
> +{
> +	int ret = 0;

No need to initialize ret here since you use it only after init.
I fixed that.

> +	int i;
> +	struct resource res;
> +	void __iomem *xbar;
> +	const s16 (*xbar_chans)[2];
> +	u32 shift, offset, mux;
> +
> +	xbar_chans = devm_kzalloc(dev,
> +				  len/sizeof(s16) + 2*sizeof(s16),
> +				  GFP_KERNEL);
> +	if (!xbar_chans)
> +		return -ENOMEM;
> +
> +	ret = of_address_to_resource(node, 1, &res);
> +	if (ret)
> +		return -EIO;
> +
> +	xbar = devm_ioremap(dev, res.start, resource_size(&res));
> +	if (!xbar)
> +		return -ENOMEM;
> +
> +	ret = edma_of_read_u32_to_s16_array(node,
> +					    "ti,edma-xbar-event-map",
> +					    (s16 *)xbar_chans,
> +					    len/sizeof(u32));
> +	if (ret)
> +		return -EIO;
> +
> +	for (i = 0; xbar_chans[i][0] != -1; i++) {
> +		shift = (xbar_chans[i][1] & 0x03) << 3;
> +		offset = xbar_chans[i][1] & 0xfffffffc;
> +		mux = readl(xbar + offset);
> +		mux &= ~(0xff << shift);
> +		mux |= xbar_chans[i][0] << shift;
> +		writel(mux, (xbar + offset));
> +	}
> +
> +	pdata->xbar_chans = xbar_chans;
> +
> +	return 0;
> +}
> +
>  static int edma_of_parse_dt(struct device *dev,
>  			    struct device_node *node,
>  			    struct edma_soc_info *pdata)
> @@ -1458,6 +1504,10 @@ static int edma_of_parse_dt(struct device *dev,
>  
>  	pdata->default_queue = 0;
>  
> +	prop = of_find_property(node, "ti,edma-xbar-event-map", &sz);
> +	if (prop)
> +		ret = edma_xbar_event_map(dev, node, pdata, sz);
> +
>  	return ret;
>  }
>  
> @@ -1476,6 +1526,7 @@ static int edma_probe(struct platform_device *pdev)
>  	int			status = -1;
>  	const s16		(*rsv_chans)[2];
>  	const s16		(*rsv_slots)[2];
> +	const s16		(*xbar_chans)[2];
>  	int			irq[EDMA_MAX_CC] = {0, 0};
>  	int			err_irq[EDMA_MAX_CC] = {0, 0};
>  	struct resource		*r[EDMA_MAX_CC] = {NULL};
> @@ -1591,6 +1642,15 @@ static int edma_probe(struct platform_device *pdev)
>  			}
>  		}
>  
> +		/* Clear the xbar mapped channels in unused list */
> +		xbar_chans = info[j]->xbar_chans;
> +		if (xbar_chans) {
> +			for (i = 0; xbar_chans[i][1] != -1; i++) {
> +				off = xbar_chans[i][1];
> +				clear_bits(off, 1,
> +					  edma_cc[j]->edma_unused);

You ignored my request to fix the alignment issue here. I will send the
updated patch separately.

Thanks,
Sekhar
