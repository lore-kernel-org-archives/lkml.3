Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3GWLcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:32:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab3GWLcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:32:31 -0400
Date: Tue, 23 Jul 2013 13:32:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        devicetree-discuss@lists.ozlabs.org, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v4 09/15] DMA: shdma: support referencing specific
 DMACs within a multiplexer in DT
In-Reply-To: <1374576609-27748-10-git-send-email-g.liakhovetski@gmx.de>
Message-ID: <Pine.LNX.4.64.1307231328390.19465@axis700.grange>
References: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
 <1374576609-27748-10-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:NyT3ekzIW0CYA029XVZtSUm7gbixd+qUb5jNiMh80fF
 /ua5Tby8Xs7pMZh+UMlO6nm7vAW038kU1Dz/WiL9VIQ1+5wgTe
 XYTEey7QyOBKlLhr+w16wTk6zHx3oBDDdMjg2gS23qIY9bN63V
 NBLFCoxoxhIREu4lp+RuoN5rykjh6vg2Hcvk9zT+vhMcBtXqwr
 KxgAsDISYiKr7Or7N6Vkq3FkSTYSy/aLiVCNpH3mN5K8ahHaeI
 jdB72JMvmuc+NMGQC7+zh19EmrvM0leOI2/McmFdx/gSvK31xQ
 sWZbCLHFlL73E+RzsoIjsn83TDmKtt8oLARStRu9LaVgb1VikZ
 hp/HK/WRISGP3cjmMtH/SGyJ0UL0YAqFWgGvsEtxv/CtOeycGR
 uWa62XzVkWjZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the only patch in the series, non-trivially touching 
Documentation/devicetree/bindings, let's cc it to devicetree mailing 
lists.

Thanks
Guennadi

On Tue, 23 Jul 2013, Guennadi Liakhovetski wrote:

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
> 
> As mentioned in the cover letter patch, this is an RFC. We are certain,
> that we want to be able to reference specific DMACs within multiplexers.
> However, with the current implementation this cannot work, because single
> DMAC DT nodes don't have of_dma objects associated with them, currently
> there is only one such object per multiplexer. The proposal is to
> implement such direct referencing by adding a "#dma-cells" property to
> respective DT nodes, in which case an of_dma object will be allocated for
> them too.
> 
>  Documentation/devicetree/bindings/dma/shdma.txt |   16 ++++++
>  drivers/dma/sh/shdma.h                          |    7 +++
>  drivers/dma/sh/shdmac.c                         |   66 +++++++++++++++++++++++
>  3 files changed, 89 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/dma/shdma.txt b/Documentation/devicetree/bindings/dma/shdma.txt
> index 6b015d6..aeed9b8 100644
> --- a/Documentation/devicetree/bindings/dma/shdma.txt
> +++ b/Documentation/devicetree/bindings/dma/shdma.txt
> @@ -27,6 +27,22 @@ Required properties:
>  		"renesas,shdma-r8a7740" for the DMACs (not RTDMAC) on r8a7740
>  		"renesas,shdma-sh73a0" for the DMACs on sh73a0
>  
> +Optional properties:
> +- #dma-cells:	this property is only needed in one specific case: if DMA slaves
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
> index 9ee3c28..fcaed8d 100644
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
> +
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
>  	{.compatible = "renesas,shdma-r8a73a4", .data = r8a73a4_shdma_devid,},
>  	{.compatible = "renesas,shdma-r8a7740", .data = r8a7740_shdma_devid,},
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
> -- 
> 1.7.2.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
