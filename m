Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3HDNzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 09:55:06 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:57777
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763Ab3HDNzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 09:55:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 4 Aug 2013 21:55:51 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jingchang Lu <b35083@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alison Wang <b18965@freescale.com>, Xiaochun Li <b41219@freescale.com>
Subject: Re: [PATCH 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20130804135550.GH18119@S2101-09.ap.freescale.net>
References: <1375430148-4550-1-git-send-email-b35083@freescale.com>
 <1375430148-4550-3-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1375430148-4550-3-git-send-email-b35083@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 03:55:48PM +0800, Jingchang Lu wrote:
> Add Freescale enhanced direct memory(eDMA) controller support.
> The eDMA controller deploys DMAMUXs routing DMA request sources(slot)
> to eDMA channels.
> This module can be found on Vybrid and LS-1 SoCs.
> 
> Signed-off-by: Alison Wang <b18965@freescale.com>
> Signed-off-by: Xiaochun Li <b41219@freescale.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> ---
>  .../devicetree/bindings/dma/fsl-vf610-edma.txt     |  84 +++
>  drivers/dma/Kconfig                                |  10 +
>  drivers/dma/Makefile                               |   1 +
>  drivers/dma/fsl-edma.c                             | 826 +++++++++++++++++++++
>  4 files changed, 921 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/fsl-vf610-edma.txt
>  create mode 100644 drivers/dma/fsl-edma.c
> 
> diff --git a/Documentation/devicetree/bindings/dma/fsl-vf610-edma.txt b/Documentation/devicetree/bindings/dma/fsl-vf610-edma.txt
> new file mode 100644
> index 0000000..e6dc5cd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/fsl-vf610-edma.txt
> @@ -0,0 +1,84 @@
> +* Freescale enhanced direct memory access(eDMA) Controller
> +
> +The eDMA engine deploys DMAMUXs routing request sources(slot) to
> +eDMA controller channels.
> +
> +* eDMA Controller
> +Required properties:
> +- compatible : Should be "fsl,<chip>-edma"
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
> +- fsl,dma-channels : Number of channels supported by the controller

The generic dma bindings Documentation/devicetree/bindings/dma/dma.txt
defines property dma-channels.  You shouldn't need a vendor specific
definition.

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
> +edma0: edma@40018000 {
> +	#dma-cells = <2>;
> +	compatible = "fsl,vf610-edma";
> +	reg = <0x40018000 0x2000>;
> +	interrupts = <0 8 0x04>, <0 9 0x04>;
> +	interrupt-names = "edma-tx", "edma-err";
> +	fsl,edma-channels = <32>;
> +	fsl,edma-mux = <&dmamux0>, <&dmamux1>;
> +	};

Broken indentation.

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
> +	fsl,sai-dma-events = <21 20>;

This should be dropped, right?

Shawn

> +	dma-names = "tx", "rx";
> +	dmas = <&edma0 0 DMA_MUXID0_SAI2_TX>,
> +		<&edma0 0 DMA_MUXID0_SAI2_RX>;
> +	status = "disabled";
> +};

