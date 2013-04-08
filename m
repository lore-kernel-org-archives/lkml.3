Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935437Ab3DHKyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:54:24 -0400
Received: from smtp-out-082.synserver.de ([212.40.185.82]:1032 "EHLO
	smtp-out-082.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934521Ab3DHKyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:54:23 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28095
Message-ID: <5162A017.8010102@metafoo.de>
Date: Mon, 08 Apr 2013 12:46:47 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Anatolij Gustschin <agust@denx.de>, Vinod Koul <vinod.koul@intel.com>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] dmaengine: mpc512x_dma: use generic DMA DT bindings
References: <1364746680-6564-1-git-send-email-agust@denx.de>
In-Reply-To: <1364746680-6564-1-git-send-email-agust@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2013 06:17 PM, Anatolij Gustschin wrote:
> Add generic DMA bindings and register the DMA controller
> to DT DMA helpers.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> ---
>  arch/powerpc/boot/dts/mpc5121.dtsi |    5 ++-
>  drivers/dma/mpc512x_dma.c          |   63 ++++++++++++++++++++++++++++++++++--
>  2 files changed, 64 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/boot/dts/mpc5121.dtsi b/arch/powerpc/boot/dts/mpc5121.dtsi
> index 723e292..d1fe070 100644
> --- a/arch/powerpc/boot/dts/mpc5121.dtsi
> +++ b/arch/powerpc/boot/dts/mpc5121.dtsi
> @@ -384,10 +384,13 @@
>  			interrupts = <40 0x8>;
>  		};
>  
> -		dma@14000 {
> +		dma0: dma@14000 {
>  			compatible = "fsl,mpc5121-dma";
>  			reg = <0x14000 0x1800>;
>  			interrupts = <65 0x8>;
> +			#dma-cells = <1>;
> +			#dma-channels = <64>;
> +			#dma-requests = <64>;
>  		};
>  	};
>  
> diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
> index 2d95673..bc6c356 100644
> --- a/drivers/dma/mpc512x_dma.c
> +++ b/drivers/dma/mpc512x_dma.c
> @@ -40,6 +40,7 @@
>  #include <linux/io.h>
>  #include <linux/slab.h>
>  #include <linux/of_device.h>
> +#include <linux/of_dma.h>
>  #include <linux/of_platform.h>
>  
>  #include <linux/random.h>
> @@ -641,6 +642,44 @@ mpc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
>  	return &mdesc->desc;
>  }
>  
> +struct mpc_dma_filter_args {
> +	struct mpc_dma *mdma;
> +	unsigned int chan_id;
> +};
> +
> +static bool mpc_dma_filter(struct dma_chan *chan, void *param)
> +{
> +	struct mpc_dma_filter_args *fargs = param;
> +
> +	if (chan->device != &fargs->mdma->dma)
> +		return false;
> +
> +	return (chan->chan_id == fargs->chan_id);
> +}
> +
> +static struct dma_chan *mpc_dma_xlate(struct of_phandle_args *dma_spec,
> +						struct of_dma *ofdma)
> +{
> +	int count = dma_spec->args_count;
> +	struct mpc_dma *mdma = ofdma->of_dma_data;
> +	struct mpc_dma_filter_args fargs;
> +	dma_cap_mask_t cap;
> +
> +	if (!mdma)
> +		return NULL;
> +
> +	if (count != 1)
> +		return NULL;
> +
> +	fargs.mdma = mdma;
> +	fargs.chan_id = dma_spec->args[0];
> +
> +	dma_cap_zero(cap);
> +	dma_cap_set(DMA_SLAVE, cap);
> +
> +	return dma_request_channel(cap, mpc_dma_filter, &fargs);
> +}
> +

This is more or less the same as the generic of_dma_xlate_by_chan_id
function I posted about two weeks ago:
https://patchwork.kernel.org/patch/2331091/

Vinod, can you take a look at that patch again? I'm not quite sure what you
meant by your question 'how will the client know which "id" to request?'.

- Lars
