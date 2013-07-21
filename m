Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3GUWW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 18:22:29 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:34945 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3GUWW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 18:22:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v2 09/15] DMA: shdma: support referencing specific DMACs within a multiplexer in DT
Date: Mon, 22 Jul 2013 00:23:15 +0200
Message-ID: <1722625.6c1mAhWBWU@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1374251374-30186-10-git-send-email-g.liakhovetski@gmx.de>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de> <1374251374-30186-10-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

Thanks for the patch.

On Friday 19 July 2013 18:29:34 Guennadi Liakhovetski wrote:
> Currently shdma DT nodes have to be placed under a multiplexer node. DMA
> slave DT nodes then use that multiplexer's phandle in their "dmas"
> properties. However, sometimes it can be necessary to let DMA slaves only
> use a specific DMAC instance. In this case it would be logical to just use
> the respective phandle in that slave's "dmas" property. For this to work
> the referenced DMAC has to register a struct of_dma instance, which isn't
> presently done. Instead the driver currently only registers one struct
> of_dma for the multiplexer. This patch adds support for such
> configurations. To enable this option a "#dma-cells" property also must be
> added to the respective DMAC DT node.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> ---
>  Documentation/devicetree/bindings/dma/shdma.txt |   16 ++++++

Patches that touch DT bindings must be CC'ed to devicetree@vger.kernel.org 
(http://www.gossamer-threads.com/lists/linux/kernel/1750512).

>  drivers/dma/sh/shdma.h                          |    7 +++
>  drivers/dma/sh/shdmac.c                         |   66 ++++++++++++++++++++
>  3 files changed, 89 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/dma/shdma.txt
> b/Documentation/devicetree/bindings/dma/shdma.txt index 7702e35..69ff80f
> 100644
> --- a/Documentation/devicetree/bindings/dma/shdma.txt
> +++ b/Documentation/devicetree/bindings/dma/shdma.txt
> @@ -27,6 +27,22 @@ Required properties:
>  		"renesas,shdma-r8a7740" for the DMACs (not RTDMAC) on r8a7740
>  		"renesas,shdma" for a generic DMAC
> 
> +Optional properties:
> +- #dma-cells:	this property is only needed in one specific case: if DMA
> slaves
> +		have to be able to request channels specifically from this DMAC,
> +		not from anyone from the multiplexer. In such a case the board
> +		.dts file can contain code, similar to this:
> +
> +&dma1 {
> +	#dma-cells = <1>;
> +};
> +
> +&mmc0 {
> +	dmas = <&dma1 0xd1
> +		&dma1 0xd2>;
> +	dma-names = "tx", "rx";
> +};
> +
>  Example:
>  	dmac: dma-mux0 {
>  		compatible = "renesas,shdma-mux";
> diff --git a/drivers/dma/sh/shdma.h b/drivers/dma/sh/shdma.h
> index 8394424..991316f 100644
> --- a/drivers/dma/sh/shdma.h
> +++ b/drivers/dma/sh/shdma.h
> @@ -23,6 +23,7 @@
>  #define SH_DMAE_TCR_MAX 0x00FFFFFF	/* 16MB */
> 
>  struct device;
> +struct device_node;
> 
>  struct sh_dmae_chan {
>  	struct shdma_chan shdma_chan;
> @@ -33,6 +34,11 @@ struct sh_dmae_chan {
>  	int pm_error;
>  };
> 
> +struct sh_dmae_filter_info {
> +	u32			hw_req;
> +	struct device_node	*of_node;
> +};
> +
>  struct sh_dmae_device {
>  	struct shdma_dev shdma_dev;
>  	struct sh_dmae_chan *chan[SH_DMAE_MAX_CHANNELS];
> @@ -42,6 +48,7 @@ struct sh_dmae_device {
>  	void __iomem *dmars;
>  	unsigned int chcr_offset;
>  	u32 chcr_ie_bit;
> +	struct sh_dmae_filter_info filter_info;
>  };
> 
>  struct sh_dmae_regs {
> diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
> index ae89261..0ddcddf 100644
> --- a/drivers/dma/sh/shdmac.c
> +++ b/drivers/dma/sh/shdmac.c
> @@ -22,6 +22,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/of_dma.h>
>  #include <linux/slab.h>
>  #include <linux/interrupt.h>
>  #include <linux/dmaengine.h>
> @@ -665,6 +666,63 @@ static const struct shdma_ops sh_dmae_shdma_ops = {
>  	.get_partial = sh_dmae_get_partial,
>  };
> 
> +static bool sh_dmae_chan_filter(struct dma_chan *chan, void *arg)
> +{
> +	struct sh_dmae_filter_info *info = arg;
> +	struct shdma_chan *schan = to_shdma_chan(chan);
> +	int match = info->hw_req;
> +
> +	if (match < 0)
> +		/* No slave requested - arbitrary channel */
> +		return true;
> +
> +	dev_dbg(schan->dev, "%s(): trying %s for 0x%x\n", __func__,
> +		info->of_node->full_name, match);
> +
> +	if (schan->dev->of_node != info->of_node)
> +		return false;
> +
> +	return !sh_dmae_set_slave(schan, match, true);
> +}
> +
> +static struct dma_chan *sh_dmae_of_xlate(struct of_phandle_args *dma_spec,
> +					 struct of_dma *ofdma)
> +{
> +	struct sh_dmae_filter_info *info = ofdma->of_dma_data;
> +	u32 id = dma_spec->args[0];
> +	dma_cap_mask_t mask;
> +	struct dma_chan *chan;
> +
> +	if (dma_spec->args_count != 1)
> +		return NULL;
> +
> +	dma_cap_zero(mask);
> +	/* Only slave DMA channels can be allocated via DT */
> +	dma_cap_set(DMA_SLAVE, mask);
> +
> +	info->hw_req = id;
> +	info->of_node = dma_spec->np;
> +
> +	chan = dma_request_channel(mask, sh_dmae_chan_filter, info);
> +	if (chan)
> +		to_shdma_chan(chan)->hw_req = id;
> +
> +	return chan;
> +}

Would https://lkml.org/lkml/2013/3/25/250 help ?

> +static int sh_dmae_of_add(struct device *dev, struct sh_dmae_device *shdev)
> +{
> +	u32 cells;
> +	int ret = of_property_read_u32(dev->of_node, "#dma-cells", &cells);
> +
> +	dev_dbg(dev, "%s(): %u (%d)\n", __func__, cells, ret);
> +	if (ret < 0 || !cells)
> +		return 0;
> +
> +	return of_dma_controller_register(dev->of_node,
> +					  sh_dmae_of_xlate, &shdev->filter_info);
> +}
> +
>  static const struct of_device_id sh_dmae_of_match[] = {
>  	{.compatible = "renesas,shdma",},
>  	{.compatible = "renesas,shdma-r8a73a4", .data = r8a73a4_shdma_devid,},
> @@ -845,6 +903,10 @@ static int sh_dmae_probe(struct platform_device *pdev)
>  		} while (irq_cnt < pdata->channel_num && chanirq_res);
>  	}
> 
> +	err = sh_dmae_of_add(&pdev->dev, shdev);
> +	if (err < 0)
> +		goto of_add_err;
> +
>  	/* Create DMA Channel */
>  	for (i = 0; i < irq_cnt; i++) {
>  		err = sh_dmae_chan_probe(shdev, i, chan_irq[i], chan_flag[i]);
> @@ -869,6 +931,8 @@ edmadevreg:
>  	pm_runtime_get(&pdev->dev);
> 
>  chan_probe_err:
> +	of_dma_controller_free(pdev->dev.of_node);
> +of_add_err:
>  	sh_dmae_chan_remove(shdev);
> 
>  #if defined(CONFIG_CPU_SH4) || defined(CONFIG_ARCH_SHMOBILE)
> @@ -895,6 +959,8 @@ static int sh_dmae_remove(struct platform_device *pdev)
>  	struct sh_dmae_device *shdev = platform_get_drvdata(pdev);
>  	struct dma_device *dma_dev = &shdev->shdma_dev.dma_dev;
> 
> +	of_dma_controller_free(pdev->dev.of_node);
> +
>  	dma_async_device_unregister(dma_dev);
> 
>  	spin_lock_irq(&sh_dmae_lock);
-- 
Regards,

Laurent Pinchart

