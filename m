Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaEOIxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:53:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51129 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaEOIxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:53:39 -0400
Message-ID: <53748070.4080706@ti.com>
Date: Thu, 15 May 2014 14:23:04 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <joelf@ti.com>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v2 2/5] ARM: edma: Get IP information from HW when booting
 with DT
References: <1399977032-26469-1-git-send-email-peter.ujfalusi@ti.com> <1399977032-26469-3-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1399977032-26469-3-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tuesday 13 May 2014 04:00 PM, Peter Ujfalusi wrote:
> From CCCFG register of eDMA3 we can get all the needed information for the
> driver about the IP:
> Number of channels: NUM_DMACH
> Number of regions: NUM_REGN
> Number of slots (PaRAM sets): NUM_PAENTRY
> Number of TC/EQ: NUM_EVQUE
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  arch/arm/common/edma.c | 128 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 79 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index fade9ada81f8..1a98f3cd4cd9 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -102,7 +102,16 @@
>  #define PARM_OFFSET(param_no)	(EDMA_PARM + ((param_no) << 5))
>  
>  #define EDMA_DCHMAP	0x0100  /* 64 registers */
> -#define CHMAP_EXIST	BIT(24)
> +
> +/* CCCFG register */
> +#define GET_NUM_DMACH(x)	(x & 0x7) /* bits 0-2 */
> +#define GET_NUM_QDMACH(x)	((x & 0x70) >> 4) /* bits 4-6 */
> +#define GET_NUM_INTCH(x)	((x & 0x700) >> 8) /* bits 8-10 */
> +#define GET_NUM_PAENTRY(x)	((x & 0x7000) >> 12) /* bits 12-14 */
> +#define GET_NUM_EVQUE(x)	((x & 0x70000) >> 16) /* bits 16-18 */
> +#define GET_NUM_REGN(x)		((x & 0x300000) >> 20) /* bits 20-21 */
> +#define CHMAP_EXIST		BIT(24)
> +#define MP_EXIST		BIT(25)

Of these new defines, you do not use GET_NUM_QDMACH(), GET_NUM_INTCH()
and MP_EXIST (at least in this patch). Can you please get rid of them if
not needed? May be its just me but its pretty annoying to search for a
define only to find its never used :)

>  
>  #define EDMA_MAX_DMACH           64
>  #define EDMA_MAX_PARAMENTRY     512
> @@ -1415,6 +1424,68 @@ void edma_clear_event(unsigned channel)
>  }
>  EXPORT_SYMBOL(edma_clear_event);
>  
> +static int edma_setup_info_from_hw(struct device *dev,
> +				   struct edma_soc_info *pdata)
> +{
> +	int i;
> +	u32 value, cccfg, n_tc;
> +	s8 (*queue_tc_map)[2], (*queue_priority_map)[2];
> +
> +	/* Decode the eDMA3 configuration from CCCFG register */
> +	cccfg = edma_read(0, EDMA_CCCFG);

You do not handle the second controller here, but its pretty straight
forward to add that by passing the controller number to this function.

I was wondering why we never read the hardware for this information
before, and strangely enough cannot find any SoC where the CCCFG
register does not publish this information correctly. I have tested on
DA850, DA830, DM365, DM355 and DM6467.

Instead of keeping this specific to OF case, the code can be simplified
much better if we read from hardware all the time. We can directly
populate the equivalent variables in the internal structure 'struct
edma' instead of populating them in 'struct edma_soc_info' and then
copying then over.

> +
> +	value = GET_NUM_DMACH(cccfg);
> +	pdata->n_channel = BIT(value + 1);
> +
> +	value = GET_NUM_REGN(cccfg);
> +	pdata->n_region = BIT(value);
> +
> +	value = GET_NUM_PAENTRY(cccfg);
> +	pdata->n_slot = BIT(value + 4);
> +
> +	value = GET_NUM_EVQUE(cccfg);
> +	n_tc = value + 1;
> +
> +	dev_dbg(dev, "eDMA3 HW configuration (cccfg: 0x%08x):\n", cccfg);
> +	dev_dbg(dev, "n_channel: %u\n", pdata->n_channel);
> +	dev_dbg(dev, "n_region: %u\n", pdata->n_region);
> +	dev_dbg(dev, "n_slot: %u\n", pdata->n_slot);
> +	dev_dbg(dev, "n_tc: %u\n", n_tc);
> +

[snip]

> +	pdata->n_cc = 1;
> +
> +	queue_tc_map = devm_kzalloc(dev, (n_tc + 1) * sizeof(s8), GFP_KERNEL);
> +	if (!queue_tc_map)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < n_tc; i++) {
> +		queue_tc_map[i][0] = i;
> +		queue_tc_map[i][1] = i;
> +	}
> +	queue_tc_map[i][0] = -1;
> +	queue_tc_map[i][1] = -1;
> +
> +	pdata->queue_tc_mapping = queue_tc_map;
> +
> +	queue_priority_map = devm_kzalloc(dev, (n_tc + 1) * sizeof(s8),
> +					  GFP_KERNEL);
> +	if (!queue_priority_map)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < n_tc; i++) {
> +		queue_priority_map[i][0] = i;
> +		queue_priority_map[i][1] = i;
> +	}
> +	queue_priority_map[i][0] = -1;
> +	queue_priority_map[i][1] = -1;
> +
> +	pdata->queue_priority_mapping = queue_priority_map;
> +
> +	pdata->default_queue = 0;

This is part is not really setting up from hardware (rather falling back
to some sane defaults for the DT case). Could you leave them in
edma_of_parse_dt()?

> @@ -1655,6 +1679,12 @@ static int edma_probe(struct platform_device *pdev)
>  		if (IS_ERR(edmacc_regs_base[j]))
>  			return PTR_ERR(edmacc_regs_base[j]);
>  
> +		if (node) {
> +			/* Get eDMA3 configuration from IP */
> +			ret = edma_setup_info_from_hw(dev, info[j]);
> +			if (ret)
> +				return ret;

No need to do this only for the DT case, I think. Also, once we get rid
of the edma_soc_info dependency, just pass edma_cc[] directly

		edma_setup_info_from_hw(dev, j, edma_cc[j]);

Thanks,
Sekhar
