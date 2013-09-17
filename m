Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3IQFnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:43:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:24382 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab3IQFnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:43:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,920,1371106800"; 
   d="scan'208";a="295739432"
Date: Tue, 17 Sep 2013 10:23:59 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingchang Lu <b35083@freescale.com>
Cc: djbw@fb.com, shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Alison Wang <b18965@freescale.com>
Subject: Re: [PATCH 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20130917045359.GN17188@intel.com>
References: <1378374799-16357-1-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378374799-16357-1-git-send-email-b35083@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 05:53:19PM +0800, Jingchang Lu wrote:
> Add Freescale enhanced direct memory(eDMA) controller support.
> The eDMA controller deploys DMAMUXs routing DMA request sources(slot)
> to eDMA channels.
> This module can be found on Vybrid and LS-1 SoCs.
> 
> Signed-off-by: Alison Wang <b18965@freescale.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> ---
> changes in v5:
>   config slave_id when dmaengine_slave_config intead of channel request.
>   adding residue calculation and dma pause/resume device control.
> 
> changes in v4:
>   using exact compatible string in binding document.
> 
> changes in v3:
>   handle all pending interrupt one time.
>   add protect lock on dma transfer complete handling.
>   change desc and tcd alloc flag to GFP_NOWAIT.
>   add sanity check and error messages.
> 
> changes in v2:
>   using generic dma-channels property instead of fsl,dma-channel.
>   rename the binding document to fsl-edma.txt.
> 
>  Documentation/devicetree/bindings/dma/fsl-edma.txt |  84 ++
>  drivers/dma/Kconfig                                |  10 +
>  drivers/dma/Makefile                               |   1 +
>  drivers/dma/fsl-edma.c                             | 925 +++++++++++++++++++++
>  4 files changed, 1020 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/fsl-edma.txt
>  create mode 100644 drivers/dma/fsl-edma.c
> 
> diff --git a/Documentation/devicetree/bindings/dma/fsl-edma.txt b/Documentation/devicetree/bindings/dma/fsl-edma.txt
> new file mode 100644
> index 0000000..60a8cb2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/fsl-edma.txt
> @@ -0,0 +1,84 @@
> +* Freescale enhanced Direct Memory Access(eDMA) Controller
> +
> +The eDMA engine deploys DMAMUXs routing request sources(slot) to
> +eDMA controller channels.
> +
> +* eDMA Controller
> +Required properties:
> +- compatible :
> +  - "fsl,vf610-edma" for eDMA used similar to that on Vybrid vf610 SoC
> +- reg : Should contain eDMA registers location and length
> +- interrupts : Should contain eDMA interrupt
> +- interrupt-names : Should be "edma-tx" for tx interrupt and
> +  "edma-err" for err interrupt
> +- #dma-cells : Must be <2>.
> +  The first cell specifies the DMAMUX ID. Specific request source
> +  can only be routed by specific DMAMUXs.
> +  the second cell specifies the request source(slot) ID.
> +  See include/dt-bindings/dma/<soc>-edma.h for all the supported
> +  request source IDs.
> +- dma-channels : Number of channels supported by the controller
> +- fsl,dma-mux : Phandle of the DMAMUXs deployed by the controller
> +
> +
> +* DMAMUX
> +Required properties:
> +- reg : Should contain DMAMUX registers location and length
> +- fsl,dmamux-id : DMAMUX ID. DMAMUX IDs are unique in each eDMA controller.
> +  inside one eDMA controller, specific request source can only be routed by
> +  one of its DMAMUXs.
> +  However Specific request source may be routed to different eDMA controller,
> +  thus all the DMAMUXs sharing a the same request sources have the same ID.
> +- clocks : Phandle of the clock used by the DMAMUX
> +- clock-names : The clock names
> +
> +Below is the eDMA controller and DMAMUX association, and DMAMUX IDs assignment
> +On Vybrid vf610 SoC, DMAMUX0 and DMAMU3 share the same request source group,
> +and DMAMUX1 and DMAMU2 share the same request source group.
> +
> +eDMA controller		DMAMUXs		DMAMUX ID
> +-------------------------------------------------
> +eDMA0			DMAMUX0		0
> +			DMAMUX1		1
> +
> +eDMA1			DMAMUX2		1
> +			DMAMUX3		0
> +
> +Examples:
> +
> +edma0: dma-controller@40018000 {
> +	#dma-cells = <2>;
> +	compatible = "fsl,vf610-edma";
> +	reg = <0x40018000 0x2000>;
> +	interrupts = <0 8 0x04>, <0 9 0x04>;
> +	interrupt-names = "edma-tx", "edma-err";
> +	dma-channels = <32>;
> +	fsl,edma-mux = <&dmamux0>, <&dmamux1>;
> +};
> +
> +dmamux0: dmamux@40024000 {
> +	reg = <0x40024000 0x1000>;
> +	fsl,dmamux-id = <0>;
> +	clocks = <&clks VF610_CLK_DMAMUX0>;
> +	clock-names = "dmamux";
> +};
> +
> +
> +* DMA clients
> +DMA client drivers that uses the DMA function must use the format described
> +in the dma.txt file, using a three-cell specifier for each channel: a phandle
> +plus two integer cells as described above.
> +
> +Examples:
> +
> +sai2: sai@40031000 {
> +	compatible = "fsl,vf610-sai";
> +	reg = <0x40031000 0x1000>;
> +	interrupts = <0 86 0x04>;
> +	clocks = <&clks VF610_CLK_SAI2>;
> +	clock-names = "sai";
> +	dma-names = "tx", "rx";
> +	dmas = <&edma0 0 VF610_EDMA_MUXID0_SAI2_TX>,
> +		<&edma0 0 VF610_EDMA_MUXID0_SAI2_RX>;
> +	status = "disabled";
> +};
I need ACK from DT maintainers on the above parts

> +static int fsl_edma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +		unsigned long arg)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	struct dma_slave_config *cfg = (void *)arg;
> +
> +	switch (cmd) {
> +	case DMA_TERMINATE_ALL:
> +		fsl_edma_disable_request(fsl_chan);
> +		fsl_chan->edesc = NULL;
you need to hold the lock here to prevent race here!

> +		vchan_free_chan_resources(&fsl_chan->vchan);
> +		return 0;
> +
> +	case DMA_SLAVE_CONFIG:
> +		fsl_chan->fsc.dir = cfg->direction;
> +		if (cfg->direction == DMA_DEV_TO_MEM) {
> +			fsl_chan->fsc.dev_addr = cfg->src_addr;
> +			fsl_chan->fsc.addr_width = cfg->src_addr_width;
> +			fsl_chan->fsc.burst = cfg->src_maxburst;
> +			fsl_chan->fsc.attr = fsl_edma_get_tcd_attr(cfg->src_addr_width);
> +		} else if (cfg->direction == DMA_MEM_TO_DEV) {
> +			fsl_chan->fsc.dev_addr = cfg->dst_addr;
> +			fsl_chan->fsc.addr_width = cfg->dst_addr_width;
> +			fsl_chan->fsc.burst = cfg->dst_maxburst;
> +			fsl_chan->fsc.attr = fsl_edma_get_tcd_attr(cfg->dst_addr_width);
> +		} else {
> +			return -EINVAL;
> +		}
> +
> +		if (!cfg->slave_id) {
> +			return -EINVAL;
should you check for this first, you wrote the channel with config above and now
returning error?

> +		} else if (fsl_chan->fsc.slave_id != cfg->slave_id) {
> +			fsl_edmamux_disable_chan(fsl_chan);
> +			fsl_edmamux_enable_chan(fsl_chan, cfg->slave_id);
> +		}
> +		return 0;
> +
> +	case DMA_PAUSE:
> +		if (fsl_chan->edesc)
> +			fsl_edma_disable_request(fsl_chan);
racy here too...

> +		return 0;
> +
> +	case DMA_RESUME:
> +		if (fsl_chan->edesc)
> +			fsl_edma_enable_request(fsl_chan);
ditto
> +		return 0;
> +
> +	default:
> +		return -ENXIO;
> +	}
> +}
> +

> +static enum dma_status fsl_edma_tx_status(struct dma_chan *chan,
> +		dma_cookie_t cookie, struct dma_tx_state *txstate)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	struct virt_dma_desc *vdesc;
> +	enum dma_status status;
> +	unsigned long flags;
> +
> +	if (fsl_chan->status == DMA_ERROR)
> +		status = DMA_ERROR;
> +	else
> +		status = dma_cookie_status(chan, cookie, txstate);
> +
> +	if (status == DMA_SUCCESS || !txstate)
> +		return status;
> +
> +	spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
> +	vdesc = vchan_find_desc(&fsl_chan->vchan, cookie);
> +	if (fsl_chan->edesc && cookie == fsl_chan->edesc->vdesc.tx.cookie)
> +		txstate->residue = fsl_edma_desc_residue(fsl_chan, vdesc, 1);
why not use true/false for the last bool arg?

> +	else if (vdesc)
> +		txstate->residue = fsl_edma_desc_residue(fsl_chan, vdesc, 0);
> +	else
> +		txstate->residue = 0;
> +
> +	spin_unlock_irqrestore(&fsl_chan->vchan.lock, flags);
> +
> +	return status;
> +}
> 

~Vinod
-- 
