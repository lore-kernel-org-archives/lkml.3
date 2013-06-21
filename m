Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3FUJic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:38:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47352 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab3FUJi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:38:29 -0400
Message-ID: <51C41ED1.5040509@ti.com>
Date: Fri, 21 Jun 2013 15:07:21 +0530
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
Subject: Re: [PATCH v12 02/11] ARM: edma: Add DT and runtime PM support to
 the private EDMA API
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <1371762407-24544-3-git-send-email-joelagnel@ti.com>
In-Reply-To: <1371762407-24544-3-git-send-email-joelagnel@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel,

Looks like you have not addressed all comments from last time.
For now, in the interest of time, I have fixed them myself. But next
time on, if you are not going to fix any comment, then please reply
upfront before sending out *any* new versions.

Also, *please* run checkpatch and fix all build warnings before you send
the patch out. You seem to have introduced new checkpatch errors and
compile warnings with this version.

On 6/21/2013 2:36 AM, Joel A Fernandes wrote:
> From: Matt Porter <mporter@ti.com>
> 
> Adds support for parsing the TI EDMA DT data into the required EDMA
> private API platform data. Enables runtime PM support to initialize
> the EDMA hwmod. Enables build on OMAP.
> 
> Changes by Joel:
> * Setup default one-to-one mapping for queue_priority and queue_tc
> mapping as discussed in [1].
> * Split out xbar stuff to separate patch. [1]
> * Dropped unused DT helper to convert to array
> 
> [1] https://patchwork.kernel.org/patch/2226761/
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
> ---
>  arch/arm/common/edma.c             |  180 +++++++++++++++++++++++++++++++++---
>  include/linux/platform_data/edma.h |    4 +-
>  2 files changed, 169 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index 7658874..407e01e 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -25,6 +25,13 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#include <linux/edma.h>
> +#include <linux/err.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/of_dma.h>
> +#include <linux/of_irq.h>
> +#include <linux/pm_runtime.h>
>  
>  #include <linux/platform_data/edma.h>
>  
> @@ -1369,13 +1376,102 @@ void edma_clear_event(unsigned channel)
>  }
>  EXPORT_SYMBOL(edma_clear_event);
>  
> -/*-----------------------------------------------------------------------*/
> +static int edma_of_read_u32_to_s16_array(const struct device_node *np,
> +					 const char *propname, s16 *out_values,
> +					 size_t sz)
> +{
> +	int ret;
> +
> +	ret = of_property_read_u16_array(np, propname, out_values, sz);
> +	if (ret)
> +		return ret;
> +
> +	/* Terminate it */
> +	*out_values++ = -1;
> +	*out_values++ = -1;
> +
> +	return 0;
> +}

I asked you to get rid of unused functions last time around. This
function is unused here.

> +
> +static int edma_of_parse_dt(struct device *dev,
> +			    struct device_node *node,
> +			    struct edma_soc_info *pdata)
> +{
> +	int ret = 0, i;
> +	u32 value;
> +	struct property *prop;
> +	size_t sz;

sz and prop are not used in this function and result in unused variable
warnings.

> +	struct edma_rsv_info *rsv_info;
> +	s8 (*queue_tc_map)[2], (*queue_priority_map)[2];
> +
> +	memset(pdata, 0, sizeof(struct edma_soc_info));
> +
> +	ret = of_property_read_u32(node, "dma-channels", &value);
> +	if (ret < 0)
> +		return ret;
> +	pdata->n_channel = value;
> +
> +	ret = of_property_read_u32(node, "ti,edma-regions", &value);
> +	if (ret < 0)
> +		return ret;
> +	pdata->n_region = value;
> +
> +	ret = of_property_read_u32(node, "ti,edma-slots", &value);
> +	if (ret < 0)
> +		return ret;
> +	pdata->n_slot = value;
> +
> +	pdata->n_cc = 1;
> +	pdata->n_tc = 3;

n_tc setting is not used in driver as I mentioned last time. I dropped
this line.

> +
> +	rsv_info =
> +		devm_kzalloc(dev, sizeof(struct edma_rsv_info), GFP_KERNEL);
> +	if (!rsv_info)
> +		return -ENOMEM;
> +	pdata->rsv = rsv_info;
> +
> +	queue_tc_map = devm_kzalloc(dev, 8*sizeof(s8), GFP_KERNEL);
> +	if (!queue_tc_map)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < 3; i++) {
> +		queue_tc_map[i][0] = i;
> +		queue_tc_map[i][1] = i;
> +	}
> +	queue_tc_map[i][0] = -1;
> +	queue_tc_map[i][1] = -1;
> +
> +	pdata->queue_tc_mapping = queue_tc_map;
> +
> +	queue_priority_map = devm_kzalloc(dev, 8*sizeof(s8), GFP_KERNEL);
> +	if (!queue_priority_map)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < 3; i++) {
> +		queue_priority_map[i][0] = i;
> +		queue_priority_map[i][1] = i;
> +	}
> +	queue_priority_map[i][0] = -1;
> +	queue_priority_map[i][1] = -1;
> +
> +	pdata->queue_priority_mapping = queue_priority_map;
> +
> +	pdata->default_queue = 0;
> +
> +	return ret;
> +}
> +
> +static struct of_dma_filter_info edma_filter_info = {
> +	.filter_fn = edma_filter_fn,
> +};
>  
> -static int __init edma_probe(struct platform_device *pdev)
> +static int edma_probe(struct platform_device *pdev)
>  {
>  	struct edma_soc_info	**info = pdev->dev.platform_data;
> -	const s8		(*queue_priority_mapping)[2];
> -	const s8		(*queue_tc_mapping)[2];
> +	struct edma_soc_info	*ninfo[EDMA_MAX_CC] = {NULL};
> +	struct edma_soc_info	tmpinfo;
> +	s8		(*queue_priority_mapping)[2];
> +	s8		(*queue_tc_mapping)[2];
>  	int			i, j, off, ln, found = 0;
>  	int			status = -1;
>  	const s16		(*rsv_chans)[2];
> @@ -1383,17 +1479,56 @@ static int __init edma_probe(struct platform_device *pdev)
>  	int			irq[EDMA_MAX_CC] = {0, 0};
>  	int			err_irq[EDMA_MAX_CC] = {0, 0};
>  	struct resource		*r[EDMA_MAX_CC] = {NULL};
> +	struct resource		res[EDMA_MAX_CC];
>  	char			res_name[10];
>  	char			irq_name[10];
> +	struct device_node	*node = pdev->dev.of_node;
> +	struct device		*dev = &pdev->dev;
> +	int			ret;
> +
> +	if (node) {
> +		/* Check if this is a second instance registered */
> +		if (arch_num_cc) {
> +			dev_err(dev, "only one EDMA instance is supported via DT\n");
> +			return -ENODEV;
> +		}
> +		info = ninfo;
> +		edma_of_parse_dt(dev, node, &tmpinfo);

As I mentioned last time, this potentially leaks memory since you need
to return error for the memory allocated through devres APIs to get freed.

> +		info[0] = &tmpinfo;
> +
> +		dma_cap_set(DMA_SLAVE, edma_filter_info.dma_cap);
> +		of_dma_controller_register(dev->of_node,
> +					   of_dma_simple_xlate,
> +					   &edma_filter_info);

It turns out this patch fails to build if CONFIG_DMADEVICES is not
enabled. I fixed that in my version. And no, forcing DMADEVICES to be
on all the time is not right. More on that later.

> +	}
>  
>  	if (!info)
>  		return -ENODEV;
>  
> +	pm_runtime_enable(dev);
> +	ret = pm_runtime_get_sync(dev);
> +	if (ret < 0) {
> +		dev_err(dev, "pm_runtime_get_sync() failed\n");
> +		return ret;
> +	}
> +
>  	for (j = 0; j < EDMA_MAX_CC; j++) {
> -		sprintf(res_name, "edma_cc%d", j);
> -		r[j] = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +		if (!info[j]) {
> +			if (!found)
> +				return -ENODEV;
> +			break;
> +		}
> +		if (node) {
> +			ret = of_address_to_resource(node, j, &res[j]);
> +			if (!ret)
> +				r[j] = &res[j];
> +		} else {
> +			sprintf(res_name, "edma_cc%d", j);
> +			r[j] = platform_get_resource_byname(pdev,
> +						IORESOURCE_MEM,
>  						res_name);
> -		if (!r[j] || !info[j]) {
> +		}
> +		if (!r[j]) {
>  			if (found)
>  				break;
>  			else
> @@ -1440,7 +1575,7 @@ static int __init edma_probe(struct platform_device *pdev)
>  					off = rsv_chans[i][0];
>  					ln = rsv_chans[i][1];
>  					clear_bits(off, ln,
> -						edma_cc[j]->edma_unused);
> +						  edma_cc[j]->edma_unused);
>  				}
>  			}
>  
> @@ -1456,8 +1591,14 @@ static int __init edma_probe(struct platform_device *pdev)
>  			}
>  		}
>  
> -		sprintf(irq_name, "edma%d", j);
> -		irq[j] = platform_get_irq_byname(pdev, irq_name);
> +
> +		if (node) {
> +			irq[j] = irq_of_parse_and_map(node, 0);
> +		}
> +		else {
> +			sprintf(irq_name, "edma%d", j);
> +			irq[j] = platform_get_irq_byname(pdev, irq_name);
> +		}

You ended up introducing checkpatch error here..

>  		edma_cc[j]->irq_res_start = irq[j];
>  		status = devm_request_irq(&pdev->dev, irq[j],
>  					  dma_irq_handler, 0, "edma",
> @@ -1469,8 +1610,13 @@ static int __init edma_probe(struct platform_device *pdev)
>  			return status;
>  		}
>  
> -		sprintf(irq_name, "edma%d_err", j);
> -		err_irq[j] = platform_get_irq_byname(pdev, irq_name);
> +		if (node) {
> +			err_irq[j] = irq_of_parse_and_map(node, 2);
> +		}
> +		else {
> +			sprintf(irq_name, "edma%d_err", j);
> +			err_irq[j] = platform_get_irq_byname(pdev, irq_name);
> +		}

.. and here.

>  		edma_cc[j]->irq_res_end = err_irq[j];
>  		status = devm_request_irq(&pdev->dev, err_irq[j],
>  					  dma_ccerr_handler, 0,
> @@ -1516,9 +1662,17 @@ static int __init edma_probe(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static const struct of_device_id edma_of_ids[] = {
> +	{ .compatible = "ti,edma3", },
> +	{}
> +};
>  
>  static struct platform_driver edma_driver = {
> -	.driver.name	= "edma",
> +	.driver = {
> +		.name	= "edma",
> +		.of_match_table = edma_of_ids,
> +	},
> +	.probe = edma_probe,
>  };
>  
>  static int __init edma_init(void)
> diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
> index 2344ea2..317f2be 100644
> --- a/include/linux/platform_data/edma.h
> +++ b/include/linux/platform_data/edma.h
> @@ -175,8 +175,8 @@ struct edma_soc_info {
>  	/* Resource reservation for other cores */
>  	struct edma_rsv_info	*rsv;
>  
> -	const s8	(*queue_tc_mapping)[2];
> -	const s8	(*queue_priority_mapping)[2];
> +	s8	(*queue_tc_mapping)[2];
> +	s8	(*queue_priority_mapping)[2];

So the warnings/errors introduced in this patch must be fixed in this
patch only. I merged your 07/11 into this. But that does not solve all
the problems since you ignored non-DA8XX platforms. I fixed those.

Also, Arnd acked the whole series so I added his ack to this.

I have tested the updated on non-DT DM644x board. That means a large
part of the patch is actually untested. Can you please test it and let
me know it works? I will sent the patch as a reply to this mail.

Thanks,
Sekhar
