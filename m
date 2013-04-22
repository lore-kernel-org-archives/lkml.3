Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3DVKWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:22:34 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:43315 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab3DVKWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:22:32 -0400
Message-ID: <51750F68.4040701@atmel.com>
Date: Mon, 22 Apr 2013 12:22:32 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: <ludovic.desroches@atmel.com>, "Koul, Vinod" <vinod.koul@intel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] at_hdmac: move to generic DMA binding
References: <1366362683-14496-1-git-send-email-ludovic.desroches@atmel.com> <1366362683-14496-2-git-send-email-ludovic.desroches@atmel.com>
In-Reply-To: <1366362683-14496-2-git-send-email-ludovic.desroches@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 11:11 AM, ludovic.desroches@atmel.com :
> From: Ludovic Desroches <ludovic.desroches@atmel.com>
> 
> Update at_hdmac driver to support generic DMA device tree binding. Devices
> can still request channel with dma_request_channel() then it doesn't break
> DMA for non DT boards.
> 
> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Hi Vinod,

As you were not in copy of the patch, I send you a little reminder for
it. It is part of a series by Ludovic and is adding the generic slave
DMA device tree binding for our at_hdmac dmaengine driver.

Here is the only patch of the series that should go through your tree.
Other maintainers and ourselves have taken the other patches (no strong
synchronization needed between them).

Here is the Linux arm kernel patchwork reference:
https://patchwork.kernel.org/patch/2463601/

But for sure, Ludovic or myself can send it again to you if you need.

Thanks, best regards,

> ---
>  .../devicetree/bindings/dma/atmel-dma.txt          | 35 ++++++--
>  drivers/dma/at_hdmac.c                             | 93 ++++++++++++++++++++--
>  drivers/dma/at_hdmac_regs.h                        |  4 +
>  3 files changed, 121 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/dma/atmel-dma.txt b/Documentation/devicetree/bindings/dma/atmel-dma.txt
> index 3c046ee..c80e8a3 100644
> --- a/Documentation/devicetree/bindings/dma/atmel-dma.txt
> +++ b/Documentation/devicetree/bindings/dma/atmel-dma.txt
> @@ -1,14 +1,39 @@
>  * Atmel Direct Memory Access Controller (DMA)
>  
>  Required properties:
> -- compatible: Should be "atmel,<chip>-dma"
> -- reg: Should contain DMA registers location and length
> -- interrupts: Should contain DMA interrupt
> +- compatible: Should be "atmel,<chip>-dma".
> +- reg: Should contain DMA registers location and length.
> +- interrupts: Should contain DMA interrupt.
> +- #dma-cells: Must be <2>, used to represent the number of integer cells in
> +the dmas property of client devices.
>  
> -Examples:
> +Example:
>  
> -dma@ffffec00 {
> +dma0: dma@ffffec00 {
>  	compatible = "atmel,at91sam9g45-dma";
>  	reg = <0xffffec00 0x200>;
>  	interrupts = <21>;
> +	#dma-cells = <2>;
> +};
> +
> +DMA clients connected to the Atmel DMA controller must use the format
> +described in the dma.txt file, using a three-cell specifier for each channel:
> +a phandle plus two interger cells.
> +The three cells in order are:
> +
> +1. A phandle pointing to the DMA controller.
> +2. The memory interface (16 most significant bits), the peripheral interface
> +(16 less significant bits).
> +3. The peripheral identifier for the hardware handshaking interface. The
> +identifier can be different for tx and rx.
> +
> +Example:
> +
> +i2c0@i2c@f8010000 {
> +	compatible = "atmel,at91sam9x5-i2c";
> +	reg = <0xf8010000 0x100>;
> +	interrupts = <9 4 6>;
> +	dmas = <&dma0 1 7>,
> +	       <&dma0 1 8>;
> +	dma-names = "tx", "rx";
>  };
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index de4e930..fda2661 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -24,6 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/of_dma.h>
>  
>  #include "at_hdmac_regs.h"
>  #include "dmaengine.h"
> @@ -677,7 +678,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  		ctrlb |=  ATC_DST_ADDR_MODE_FIXED
>  			| ATC_SRC_ADDR_MODE_INCR
>  			| ATC_FC_MEM2PER
> -			| ATC_SIF(AT_DMA_MEM_IF) | ATC_DIF(AT_DMA_PER_IF);
> +			| ATC_SIF(atchan->mem_if) | ATC_DIF(atchan->per_if);
>  		reg = sconfig->dst_addr;
>  		for_each_sg(sgl, sg, sg_len, i) {
>  			struct at_desc	*desc;
> @@ -716,7 +717,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  		ctrlb |=  ATC_DST_ADDR_MODE_INCR
>  			| ATC_SRC_ADDR_MODE_FIXED
>  			| ATC_FC_PER2MEM
> -			| ATC_SIF(AT_DMA_PER_IF) | ATC_DIF(AT_DMA_MEM_IF);
> +			| ATC_SIF(atchan->per_if) | ATC_DIF(atchan->mem_if);
>  
>  		reg = sconfig->src_addr;
>  		for_each_sg(sgl, sg, sg_len, i) {
> @@ -822,8 +823,8 @@ atc_dma_cyclic_fill_desc(struct dma_chan *chan, struct at_desc *desc,
>  		desc->lli.ctrlb = ATC_DST_ADDR_MODE_FIXED
>  				| ATC_SRC_ADDR_MODE_INCR
>  				| ATC_FC_MEM2PER
> -				| ATC_SIF(AT_DMA_MEM_IF)
> -				| ATC_DIF(AT_DMA_PER_IF);
> +				| ATC_SIF(atchan->mem_if)
> +				| ATC_DIF(atchan->per_if);
>  		break;
>  
>  	case DMA_DEV_TO_MEM:
> @@ -833,8 +834,8 @@ atc_dma_cyclic_fill_desc(struct dma_chan *chan, struct at_desc *desc,
>  		desc->lli.ctrlb = ATC_DST_ADDR_MODE_INCR
>  				| ATC_SRC_ADDR_MODE_FIXED
>  				| ATC_FC_PER2MEM
> -				| ATC_SIF(AT_DMA_PER_IF)
> -				| ATC_DIF(AT_DMA_MEM_IF);
> +				| ATC_SIF(atchan->per_if)
> +				| ATC_DIF(atchan->mem_if);
>  		break;
>  
>  	default:
> @@ -1190,6 +1191,67 @@ static void atc_free_chan_resources(struct dma_chan *chan)
>  	dev_vdbg(chan2dev(chan), "free_chan_resources: done\n");
>  }
>  
> +#ifdef CONFIG_OF
> +static bool at_dma_filter(struct dma_chan *chan, void *slave)
> +{
> +	struct at_dma_slave *atslave = slave;
> +
> +	if (atslave->dma_dev == chan->device->dev) {
> +		chan->private = atslave;
> +		return true;
> +	} else {
> +		return false;
> +	}
> +}
> +
> +static struct dma_chan *at_dma_xlate(struct of_phandle_args *dma_spec,
> +				     struct of_dma *of_dma)
> +{
> +	struct dma_chan *chan;
> +	struct at_dma_chan *atchan;
> +	struct at_dma_slave *atslave;
> +	dma_cap_mask_t mask;
> +	unsigned int per_id;
> +	struct platform_device *dmac_pdev;
> +
> +	if (dma_spec->args_count != 2)
> +		return NULL;
> +
> +	dmac_pdev = of_find_device_by_node(dma_spec->np);
> +
> +	dma_cap_zero(mask);
> +	dma_cap_set(DMA_SLAVE, mask);
> +
> +	atslave = devm_kzalloc(&dmac_pdev->dev, sizeof(*atslave), GFP_KERNEL);
> +	if (!atslave)
> +		return NULL;
> +	/*
> +	 * We can fill both SRC_PER and DST_PER, one of these fields will be
> +	 * ignored depending on DMA transfer direction.
> +	 */
> +	per_id = dma_spec->args[1];
> +	atslave->cfg = ATC_FIFOCFG_HALFFIFO | ATC_DST_H2SEL_HW
> +		      | ATC_SRC_H2SEL_HW | ATC_DST_PER(per_id)
> +		      | ATC_SRC_PER(per_id);
> +	atslave->dma_dev = &dmac_pdev->dev;
> +
> +	chan = dma_request_channel(mask, at_dma_filter, atslave);
> +	if (!chan)
> +		return NULL;
> +
> +	atchan = to_at_dma_chan(chan);
> +	atchan->per_if = dma_spec->args[0] & 0xff;
> +	atchan->mem_if = (dma_spec->args[0] >> 16) & 0xff;
> +
> +	return chan;
> +}
> +#else
> +static struct dma_chan *at_dma_xlate(struct of_phandle_args *dma_spec,
> +				     struct of_dma *of_dma)
> +{
> +	return NULL;
> +}
> +#endif
>  
>  /*--  Module Management  -----------------------------------------------*/
>  
> @@ -1344,6 +1406,8 @@ static int __init at_dma_probe(struct platform_device *pdev)
>  	for (i = 0; i < plat_dat->nr_channels; i++) {
>  		struct at_dma_chan	*atchan = &atdma->chan[i];
>  
> +		atchan->mem_if = AT_DMA_MEM_IF;
> +		atchan->per_if = AT_DMA_PER_IF;
>  		atchan->chan_common.device = &atdma->dma_common;
>  		dma_cookie_init(&atchan->chan_common);
>  		list_add_tail(&atchan->chan_common.device_node,
> @@ -1390,8 +1454,25 @@ static int __init at_dma_probe(struct platform_device *pdev)
>  
>  	dma_async_device_register(&atdma->dma_common);
>  
> +	/*
> +	 * Do not return an error if the dmac node is not present in order to
> +	 * not break the existing way of requesting channel with
> +	 * dma_request_channel().
> +	 */
> +	if (pdev->dev.of_node) {
> +		err = of_dma_controller_register(pdev->dev.of_node,
> +						 at_dma_xlate, atdma);
> +		if (err) {
> +			dev_err(&pdev->dev, "could not register of_dma_controller\n");
> +			goto err_of_dma_controller_register;
> +		}
> +	}
> +
>  	return 0;
>  
> +err_of_dma_controller_register:
> +	dma_async_device_unregister(&atdma->dma_common);
> +	dma_pool_destroy(atdma->dma_desc_pool);
>  err_pool_create:
>  	platform_set_drvdata(pdev, NULL);
>  	free_irq(platform_get_irq(pdev, 0), atdma);
> diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
> index 0eb3c13..c604d26 100644
> --- a/drivers/dma/at_hdmac_regs.h
> +++ b/drivers/dma/at_hdmac_regs.h
> @@ -220,6 +220,8 @@ enum atc_status {
>   * @device: parent device
>   * @ch_regs: memory mapped register base
>   * @mask: channel index in a mask
> + * @per_if: peripheral interface
> + * @mem_if: memory interface
>   * @status: transmit status information from irq/prep* functions
>   *                to tasklet (use atomic operations)
>   * @tasklet: bottom half to finish transaction work
> @@ -238,6 +240,8 @@ struct at_dma_chan {
>  	struct at_dma		*device;
>  	void __iomem		*ch_regs;
>  	u8			mask;
> +	u8			per_if;
> +	u8			mem_if;
>  	unsigned long		status;
>  	struct tasklet_struct	tasklet;
>  	u32			save_cfg;
> 


-- 
Nicolas Ferre
