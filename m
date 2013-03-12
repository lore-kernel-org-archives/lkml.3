Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3CLGqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:46:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51008 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab3CLGqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:46:50 -0400
Message-ID: <513ECF1A.2020300@ti.com>
Date: Tue, 12 Mar 2013 12:15:46 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v9 3/9] ARM: edma: add AM33XX support to the private EDMA
 API
References: <1362586540-10393-1-git-send-email-mporter@ti.com> <1362586540-10393-4-git-send-email-mporter@ti.com>
In-Reply-To: <1362586540-10393-4-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 3/6/2013 9:45 PM, Matt Porter wrote:
> Adds support for parsing the TI EDMA DT data into the
> required EDMA private API platform data. Enables runtime
> PM support to initialize the EDMA hwmod. Adds AM33XX EDMA
> crossbar event mux support. Enables build on OMAP.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> ---
>  arch/arm/common/edma.c             |  300 ++++++++++++++++++++++++++++++++++--
>  arch/arm/mach-omap2/Kconfig        |    1 +
>  include/linux/platform_data/edma.h |    1 +
>  3 files changed, 292 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index a1db6cd..e68ac38 100644
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
> @@ -1369,31 +1376,278 @@ void edma_clear_event(unsigned channel)
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
> +
> +static int edma_xbar_event_map(struct device *dev,
> +			       struct device_node *node,
> +			       struct edma_soc_info *pdata, int len)
> +{

It will be nice to separate the xbar feature from DT'fication of the
existing driver. Right now because of the mix the patch has become
pretty big and its becoming tough to review in isolation.

> +	int ret = 0;
> +	int i;
> +	struct resource res;
> +	void *xbar;
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
> +		shift = (xbar_chans[i][1] % 4) * 8;
> +		offset = xbar_chans[i][1] >> 2;
> +		offset <<= 2;
> +		mux = readl((void *)((u32)xbar + offset));
> +		mux &= ~(0xff << shift);
> +		mux |= xbar_chans[i][0] << shift;
> +		writel(mux, (void *)((u32)xbar + offset));
> +	}
> +
> +	pdata->xbar_chans = xbar_chans;
> +
> +	return 0;
> +}
> +
> +static int edma_of_parse_dt(struct device *dev,
> +			    struct device_node *node,
> +			    struct edma_soc_info *pdata)
> +{
> +	int ret = 0;
> +	u32 value;
> +	struct property *prop;
> +	size_t sz;
> +	struct edma_rsv_info *rsv_info;
> +	const s16 (*rsv_chans)[2], (*rsv_slots)[2];
> +	const s8 (*queue_tc_map)[2], (*queue_priority_map)[2];
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

Will this mean the DT portion of this driver cannot be used on SoCs
where there are two CCs like DA850? If you are hard-coding this, will it
make sense to set to to EDMA_MAX_CC instead? Okay I see a comment down
below saying DT will support only one CC. Not sure why, but this is
probably related to that.

> +
> +	rsv_info =
> +		devm_kzalloc(dev, sizeof(struct edma_rsv_info), GFP_KERNEL);
> +	if (!rsv_info)
> +		return -ENOMEM;
> +	pdata->rsv = rsv_info;
> +
> +	/* Build the reserved channel/slots arrays */
> +	prop = of_find_property(node, "ti,edma-reserved-channels", &sz);
> +	if (prop) {
> +		rsv_chans = devm_kzalloc(dev,
> +					 sz/sizeof(s16) + 2*sizeof(s16),
> +					 GFP_KERNEL);
> +		if (!rsv_chans)
> +			return -ENOMEM;
> +		pdata->rsv->rsv_chans = rsv_chans;
> +
> +		ret = edma_of_read_u32_to_s16_array(node,
> +						    "ti,edma-reserved-channels",
> +						    (s16 *)rsv_chans,
> +						    sz/sizeof(u32));

Is this binding accepted? I cant find it in v3.9-rc1. IMHO, this
configuration should not be through DT. This is configuration material
for a given application (which channels should Linux running on ARM use
vs which channels should DSP use?) but not hardware description.
Probably configfs is useful here but I myself need to go through the
details.

On AM335x the usage of this is further limited use since applications
which need DMA from PRU or M3 are limited (at least I don't know of any).

I know its frustrating to get these comments piece by piece and after v9
has already been posted. Sorry about that. I think it will be easier to
drop this and some other may-not-really-be-a-hardware-description
bindings like "ti,edma-reserved-slots" for now and just get the basic
support in. The other ones can then be discussed/handled separately.


> +		if (ret < 0)
> +			return ret;
> +	}
>  
> -static int __init edma_probe(struct platform_device *pdev)
> +	prop = of_find_property(node, "ti,edma-reserved-slots", &sz);
> +	if (prop) {
> +		rsv_slots = devm_kzalloc(dev,
> +					 sz/sizeof(s16) + 2*sizeof(s16),
> +					 GFP_KERNEL);
> +		if (!rsv_slots)
> +			return -ENOMEM;
> +		pdata->rsv->rsv_slots = rsv_slots;
> +
> +		ret = edma_of_read_u32_to_s16_array(node,
> +						    "ti,edma-reserved-slots",
> +						    (s16 *)rsv_slots,
> +						    sz/sizeof(u32));
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	prop = of_find_property(node, "ti,edma-queue-tc-map", &sz);

Again, this is application-driven configuration from EDMA IP
point-of-view. For some of these may be you can leave some sane defaults
which will work on most systems (AM335x included) and then we can look
at how this can be configured when an actual need arises (and at that
time we can look at the best way of doing it). Same thing for a number
of other properties below.

> +	if (!prop)
> +		return -EINVAL;
> +
> +	queue_tc_map = devm_kzalloc(dev,
> +				    sz/sizeof(s8) + 2*sizeof(s8),
> +				    GFP_KERNEL);
> +	if (!queue_tc_map)
> +		return -ENOMEM;
> +	pdata->queue_tc_mapping = queue_tc_map;
> +
> +	ret = edma_of_read_u32_to_s8_array(node,
> +					   "ti,edma-queue-tc-map",
> +					   (s8 *)queue_tc_map,
> +					   sz/sizeof(u32));
> +	if (ret < 0)
> +		return ret;
> +
> +	prop = of_find_property(node, "ti,edma-queue-priority-map", &sz);
> +	if (!prop)
> +		return -EINVAL;
> +
> +	queue_priority_map = devm_kzalloc(dev,
> +					  sz/sizeof(s8) + 2*sizeof(s8),
> +					  GFP_KERNEL);
> +	if (!queue_priority_map)
> +		return -ENOMEM;
> +	pdata->queue_priority_mapping = queue_priority_map;
> +
> +	ret = edma_of_read_u32_to_s8_array(node,
> +					   "ti,edma-queue-tc-map",
> +					   (s8 *)queue_priority_map,
> +					   sz/sizeof(u32));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = of_property_read_u32(node, "ti,edma-default-queue", &value);
> +	if (ret < 0)
> +		return ret;
> +	pdata->default_queue = value;
> +
> +	prop = of_find_property(node, "ti,edma-xbar-event-map", &sz);
> +	if (prop)
> +		ret = edma_xbar_event_map(dev, node, pdata, sz);
> +
> +	return ret;
> +}

Thanks,
Sekhar
