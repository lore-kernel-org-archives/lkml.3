Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3FRJkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:40:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57137 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab3FRJkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:40:45 -0400
Message-ID: <51C02AE3.5030603@ti.com>
Date: Tue, 18 Jun 2013 15:09:47 +0530
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
Subject: Re: [PATCH v11 2/8] ARM: edma: Add DT and runtime PM support to the
 private EDMA API
References: <1371537499-12970-1-git-send-email-joelagnel@ti.com> <1371537499-12970-3-git-send-email-joelagnel@ti.com>
In-Reply-To: <1371537499-12970-3-git-send-email-joelagnel@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/18/2013 12:08 PM, Joel A Fernandes wrote:
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
> 
> [1] https://patchwork.kernel.org/patch/2226761/
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
> ---
>  arch/arm/common/edma.c             |  190 +++++++++++++++++++++++++++++++++---
>  arch/arm/mach-omap2/Kconfig        |    1 +
>  include/linux/platform_data/edma.h |    4 +-
>  3 files changed, 181 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index a1db6cd..9823b79 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -24,6 +24,13 @@
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
> @@ -1369,31 +1376,173 @@ void edma_clear_event(unsigned channel)
>  EXPORT_SYMBOL(edma_clear_event);
>  
>  /*-----------------------------------------------------------------------*/
> +static int edma_of_read_u32_to_s8_array(const struct device_node *np,
> +					 const char *propname, s8 *out_values,
> +					 size_t sz)
> +{
> +	int ret;
> +
> +	ret = of_property_read_u8_array(np, propname, out_values, sz);
> +	if (ret)
> +		return ret;
> +
> +	/* Terminate it */
> +	*out_values++ = -1;
> +	*out_values++ = -1;
> +
> +	return 0;
> +}
> +
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

These functions dont get used here. Can you introduce them when you
actually need them?

>  
> -static int __init edma_probe(struct platform_device *pdev)
> +static int edma_of_parse_dt(struct device *dev,
> +			    struct device_node *node,
> +			    struct edma_soc_info *pdata)
> +{
> +	int ret = 0, i;
> +	u32 value;
> +	struct property *prop;
> +	size_t sz;
> +	struct edma_rsv_info *rsv_info;
> +	const s16 (*rsv_chans)[2], (*rsv_slots)[2];

rsv_slots is unused. You get an unused variable warning here. rsv_chans
is also unused.

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

n_tc is not used in the driver AFAICS. You can drop this line and also
possibly remove the platform data member as well.

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
> +	for (i = 0; i < 3; i++)
> +		queue_tc_map[i][0] = queue_tc_map[i][1] = i;
> +	queue_tc_map[i][0] = queue_tc_map[i][1] = -1;
> +
> +	pdata->queue_tc_mapping = queue_tc_map;
> +
> +	queue_priority_map = devm_kzalloc(dev, 8*sizeof(s8), GFP_KERNEL);
> +	if (!queue_priority_map)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < 3; i++)
> +		queue_priority_map[i][0] = queue_priority_map[i][1] = i;
> +	queue_priority_map[i][0] = queue_priority_map[i][1] = -1;
> +
> +	pdata->queue_priority_mapping = queue_priority_map;
> +
> +	pdata->default_queue = 0;
> +
> +

Extra empty line here.

> +	return ret;
> +}

Usage of devres APIs in this function is nice, but, there is no check
for return value of edma_of_parse_dt() in the probe down below. So in
effect it leaks memory on error.

> +
> +static struct of_dma_filter_info edma_filter_info = {
> +	.filter_fn = edma_filter_fn,
> +};
> +
> +static int edma_probe(struct platform_device *pdev)
>  {
>  	struct edma_soc_info	**info = pdev->dev.platform_data;
> -	const s8		(*queue_priority_mapping)[2];
> -	const s8		(*queue_tc_mapping)[2];
> +	struct edma_soc_info	*ninfo[EDMA_MAX_CC] = {NULL, NULL};

Nit: just {NULL} is enough.

> +	struct edma_soc_info	tmpinfo;
> +	s8		(*queue_priority_mapping)[2];
> +	s8		(*queue_tc_mapping)[2];
>  	int			i, j, off, ln, found = 0;
>  	int			status = -1;
>  	const s16		(*rsv_chans)[2];
>  	const s16		(*rsv_slots)[2];
>  	int			irq[EDMA_MAX_CC] = {0, 0};
>  	int			err_irq[EDMA_MAX_CC] = {0, 0};
> -	struct resource		*r[EDMA_MAX_CC] = {NULL};
> +	struct resource		*r[EDMA_MAX_CC] = {NULL, NULL};

No need for this change. C array initialization will initialize missing
values to 0.

> +	struct resource		res[EDMA_MAX_CC];
>  	resource_size_t		len[EDMA_MAX_CC];

res and len should disappear once you rebase to Prabhakar's patch. That
patch is present in v3.11/soc-2 branch of my tree. Please rebase your
series to that.

> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index f49cd51..f91b07f 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -17,6 +17,7 @@ config ARCH_OMAP2PLUS
>  	select PROC_DEVICETREE if PROC_FS
>  	select SOC_BUS
>  	select SPARSE_IRQ
> +	select TI_PRIV_EDMA
>  	select USE_OF
>  	help
>  	  Systems based on OMAP2, OMAP3, OMAP4 or OMAP5

This hunk doesnt really belong here. You can merge it with the patch
which introduces EDMA support to AM335x.

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

This causes a bunch of gcc and sparse warnings in devices-da8xx.c (and
probably elsewhere in mach-davinci). Can you please check those and fix?

See: http://paste.ubuntu.com/5776604/

Thanks,
Sekhar
