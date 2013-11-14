Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3KNKq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:46:57 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53738 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab3KNKq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:46:56 -0500
Date: Thu, 14 Nov 2013 10:46:20 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jingchang Lu <b35083@freescale.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alison Wang <b18965@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20131114104620.GB16396@e106331-lin.cambridge.arm.com>
References: <1379498279-16096-1-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379498279-16096-1-git-send-email-b35083@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 10:57:59AM +0100, Jingchang Lu wrote:
> Add Freescale enhanced direct memory(eDMA) controller support.
> The eDMA controller deploys DMAMUXs routing DMA request sources(slot)
> to eDMA channels.
> This module can be found on Vybrid and LS-1 SoCs.
> 
> Signed-off-by: Alison Wang <b18965@freescale.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> ---
> changes in v6:
>   holding lock in dma_control to prevent race.
> 
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
> 
>  Documentation/devicetree/bindings/dma/fsl-edma.txt |  84 ++
>  drivers/dma/Kconfig                                |  10 +
>  drivers/dma/Makefile                               |   1 +
>  drivers/dma/fsl-edma.c                             | 944 +++++++++++++++++++++
>  4 files changed, 1039 insertions(+)
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

- interrupts: A list of interrupt-specifiers, one for each entry in
  interrupt-names.

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

No compatible?

Where are DMAMUX nodes expected to live?

How to they relate to the eDMA controller in HW? Are they a
subcomponent, or a logically separate unit that happens to be connected?

> +- reg : Should contain DMAMUX registers location and length
> +- fsl,dmamux-id : DMAMUX ID. DMAMUX IDs are unique in each eDMA controller.
> +  inside one eDMA controller, specific request source can only be routed by
> +  one of its DMAMUXs.
> +  However Specific request source may be routed to different eDMA controller,
> +  thus all the DMAMUXs sharing a the same request sources have the same ID.
> +- clocks : Phandle of the clock used by the DMAMUX
> +- clock-names : The clock names

_which_ clock names do you expect? From the looks of the example, you
expect "dmamux".

>From the view of the DMAMUX, what is its clock input called? "dmamux"
doesn't look like what I'd expect for a clock name, but if the
documentation for the eDMA doesn't provide a name for it, "dmamux" is
fine.

If you're not using clock-names, it's useless. You _must_ define the set
of names you expect or it's unusable. If you do define a set of names,
then you should request clocks by name in the driver.

> +
> +Below is the eDMA controller and DMAMUX association, and DMAMUX IDs assignment
> +On Vybrid vf610 SoC, DMAMUX0 and DMAMU3 share the same request source group,
> +and DMAMUX1 and DMAMU2 share the same request source group.
> +
> +eDMA controller                DMAMUXs         DMAMUX ID
> +-------------------------------------------------
> +eDMA0                  DMAMUX0         0
> +                       DMAMUX1         1
> +
> +eDMA1                  DMAMUX2         1
> +                       DMAMUX3         0
> +
> +Examples:
> +
> +edma0: dma-controller@40018000 {
> +       #dma-cells = <2>;
> +       compatible = "fsl,vf610-edma";
> +       reg = <0x40018000 0x2000>;
> +       interrupts = <0 8 0x04>, <0 9 0x04>;
> +       interrupt-names = "edma-tx", "edma-err";
> +       dma-channels = <32>;
> +       fsl,edma-mux = <&dmamux0>, <&dmamux1>;
> +};
> +
> +dmamux0: dmamux@40024000 {
> +       reg = <0x40024000 0x1000>;
> +       fsl,dmamux-id = <0>;
> +       clocks = <&clks VF610_CLK_DMAMUX0>;
> +       clock-names = "dmamux";
> +};
> +
> +
> +* DMA clients
> +DMA client drivers that uses the DMA function must use the format described
> +in the dma.txt file, using a three-cell specifier for each channel: a phandle
> +plus two integer cells as described above.

Nit: the phandle isn't part of the specifier. The cells after the
phandle are the specifier associated with the phandle.

[...]

> +static bool fsl_edma_filter_fn(struct dma_chan *chan, void *mux_id)
> +{
> +       struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +
> +       if (fsl_chan->edmamux->mux_id != (u32)mux_id)
> +               return false;
> +
> +       return true;

Why not:

return fsl_chan->edmamux->mux_id == (u32)mux_id;

[...]

> +static int
> +fsl_init_edmamux(struct platform_device *pdev, struct fsl_edma_engine *fsl_edma)
> +{
> +       struct device_node *np = pdev->dev.of_node;
> +       struct fsl_edma_dmamux *fsl_edmamux;
> +       struct device_node *phandle;

That's confusing, a node is not a phandle. Why not mux_np?

> +       const void *prop;
> +       struct resource res;
> +       int len, n_muxes, chans_per_mux, ch_off;
> +       int i, j;
> +       int ret;
> +
> +       prop = of_get_property(np, "fsl,dma-mux", &len);
> +       if (!prop) {
> +               dev_err(&pdev->dev, "Can't get DMAMUX.\n");
> +               return -EINVAL;
> +       }
> +
> +       n_muxes = len / sizeof(u32);

It would be nicer if we had a variant of of_count_phandle_with_args that
cound handle a fixed count of 0 args for this sort of thing.

> +       chans_per_mux = fsl_edma->n_chans / n_muxes;
> +       fsl_edmamux = devm_kzalloc(&pdev->dev,
> +                       sizeof(struct fsl_edma_dmamux) * n_muxes, GFP_KERNEL);
> +       if (!fsl_edmamux)
> +               return -ENOMEM;
> +
> +       fsl_edma->n_muxes = 0;
> +       fsl_edma->edmamux = fsl_edmamux;
> +       for (i = 0; i < n_muxes; i++) {
> +               phandle = of_parse_phandle(np, "fsl,dma-mux", i);
> +               ret = of_address_to_resource(phandle, 0, &res);
> +               if (ret)
> +                       return ret;
> +               fsl_edmamux->membase = devm_ioremap_resource(&pdev->dev, &res);
> +               if (IS_ERR(fsl_edmamux->membase))
> +                       return PTR_ERR(fsl_edmamux->membase);
> +
> +               fsl_edmamux->clk = of_clk_get(phandle, 0);
> +               if (IS_ERR(fsl_edmamux->clk)) {
> +                       dev_err(&pdev->dev, "Missing DMAMUX clock.\n");
> +                       return PTR_ERR(fsl_edmamux->clk);
> +               }

Please acquire the clock by name:

fsl_edmamux->clk = of_clk_get_byname(phandle, "dmamux");

> +
> +               ret = clk_prepare_enable(fsl_edmamux->clk);
> +               if (ret) {
> +                       dev_err(&pdev->dev, "DMAMUX clk enable failed.\n");
> +                       return ret;
> +               }
> +
> +               ret = of_property_read_u32_index(phandle, "fsl,dmamux-id", 0,
> +                               &fsl_edmamux->mux_id);

Why not just of_property_read_u32?

> +               if (ret) {
> +                       dev_err(&pdev->dev, "Can't get dmamux-id.\n");
> +                       return ret;
> +               }
> +
> +               ch_off = fsl_edma->n_muxes * chans_per_mux;
> +               for (j = 0; j < chans_per_mux; j++)
> +                       fsl_edma->chans[ch_off + j].edmamux = fsl_edmamux;
> +
> +               fsl_edmamux++;
> +               fsl_edma->n_muxes++;
> +       }
> +       return 0;
> +}

[...]

> +static int fsl_edma_probe(struct platform_device *pdev)
> +{
> +       struct device_node *np = pdev->dev.of_node;
> +       struct fsl_edma_engine *fsl_edma;
> +       struct fsl_edma_chan *fsl_chan;
> +       struct resource *res;
> +       int len, chans;
> +       int ret, i;
> +
> +       ret = of_property_read_u32_index(np, "dma-channels", 0, &chans);

Use of_property_read_u32.

Thanks,
Mark.
