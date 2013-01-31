Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3AaBm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 20:42:26 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:31235
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365Ab3AaBmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 20:42:24 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I4015Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 31 Jan 2013 09:42:17 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: fsl: Fix multiple symbol definitions
Message-ID: <20130131014214.GD2765@S2101-09.ap.freescale.net>
References: <1359577471-15029-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1359577471-15029-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 09:24:31PM +0100, Thierry Reding wrote:
> Commit 25b8d31 (ASoC: fsl: fix multiple definition of init_module) fixed
> a build error due to multiple symbol definitions when building as a
> module. However, it causes the build to break when the driver is builtin
> because the imx-pcm.o object is included multiple times. Solve the issue
> by adding imx-pcm.o to each of the modules that require it, but only add
> it to the kernel once when one or both drivers are builtin.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Thanks, Thierry.  The Kconfig is already complex.  To avoid having them
even more complex, I have chosen to revert my patch and have a little
surgery on the code [1] to make it match the Kconfig rational.

Shawn

[1] http://thread.gmane.org/gmane.linux.alsa.devel/105018

> ---
>  sound/soc/fsl/Makefile | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/sound/soc/fsl/Makefile b/sound/soc/fsl/Makefile
> index ec14579..8446d49 100644
> --- a/sound/soc/fsl/Makefile
> +++ b/sound/soc/fsl/Makefile
> @@ -30,21 +30,24 @@ obj-$(CONFIG_SND_MPC52xx_SOC_EFIKA) += efika-audio-fabric.o
>  # i.MX Platform Support
>  snd-soc-imx-ssi-objs := imx-ssi.o
>  snd-soc-imx-audmux-objs := imx-audmux.o
> -snd-soc-imx-pcm-objs := imx-pcm.o
> -ifneq ($(CONFIG_SND_SOC_IMX_PCM_FIQ),)
> -	snd-soc-imx-pcm-objs += imx-pcm-fiq.o
> -endif
> -ifneq ($(CONFIG_SND_SOC_IMX_PCM_DMA),)
> -	snd-soc-imx-pcm-objs += imx-pcm-dma.o
> -endif
>  
>  obj-$(CONFIG_SND_SOC_IMX_SSI) += snd-soc-imx-ssi.o
>  obj-$(CONFIG_SND_SOC_IMX_AUDMUX) += snd-soc-imx-audmux.o
>  
>  obj-$(CONFIG_SND_SOC_IMX_PCM_FIQ) += snd-soc-imx-pcm-fiq.o
> -snd-soc-imx-pcm-fiq-y := imx-pcm-fiq.o imx-pcm.o
> +snd-soc-imx-pcm-fiq-y := imx-pcm-fiq.o
> +ifeq ($(CONFIG_SND_SOC_IMX_PCM_FIQ),m)
> +snd-soc-imx-pcm-fiq-y += imx-pcm.o
> +else
> +obj-$(CONFIG_SND_SOC_IMX_PCM_FIQ) += imx-pcm.o
> +endif
>  obj-$(CONFIG_SND_SOC_IMX_PCM_DMA) += snd-soc-imx-pcm-dma.o
> -snd-soc-imx-pcm-dma-y := imx-pcm-dma.o imx-pcm.o
> +snd-soc-imx-pcm-dma-y := imx-pcm-dma.o
> +ifeq ($(CONFIG_SND_SOC_IMX_PCM_DMA),m)
> +snd-soc-imx-pcm-dma-y := imx-pcm.o
> +else
> +obj-$(CONFIG_SND_SOC_IMX_PCM_DMA) += imx-pcm.o
> +endif
>  
>  # i.MX Machine Support
>  snd-soc-eukrea-tlv320-objs := eukrea-tlv320.o
> -- 
> 1.8.1.2
> 

