Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaBKHPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:15:25 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:1705
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752508AbaBKHPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:15:18 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097h84d07hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
Date: Tue, 11 Feb 2014 15:10:35 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Xiubo Li <Li.Xiubo@freescale.com>, <shawn.guo@linaro.org>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: fsl-spdif: big-endian support
Message-ID: <20140211071034.GA18803@MrMyself>
References: <1392097276-14705-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1392097276-14705-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 01:41:15PM +0800, Xiubo Li wrote:
> For most platforms, the CPU and SPDIF device is in the same endianess
> mode. While for the LS1 platform, the CPU is in LE mode and the SPDIF
> is in BE mode.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Nicolin Chen <Guangyu.Chen@freescale.com>
> ---
>  Documentation/devicetree/bindings/sound/fsl,spdif.txt | 4 ++++
>  sound/soc/fsl/fsl_spdif.c                             | 8 +++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/sound/fsl,spdif.txt b/Documentation/devicetree/bindings/sound/fsl,spdif.txt
> index f2ae335..433ad00 100644
> --- a/Documentation/devicetree/bindings/sound/fsl,spdif.txt
> +++ b/Documentation/devicetree/bindings/sound/fsl,spdif.txt
> @@ -29,6 +29,10 @@ Required properties:
>  			can also be referred to TxClk_Source
>  			bit of register SPDIF_STC.
>  
> +   - big-endian : If this property is absent, the native endian mode will
> +   be in use as default, or the big endian mode will be in use for all the
> +   device registers.
> +

@Shawn
Does DT have an existing approach to determine if the current SoC this IP
uses is BE or LE? I am thinking the scenario that if all drivers support
BE/LE while the SoC is big-endian, all the nodes in the DT would have to
include a duplicated property (big-endian).

>  Example:
>  
>  spdif: spdif@02004000 {
> diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
> index 8f36f49..2f8ad75 100644
> --- a/sound/soc/fsl/fsl_spdif.c
> +++ b/sound/soc/fsl/fsl_spdif.c
> @@ -83,6 +83,8 @@ struct fsl_spdif_priv {
>  	struct snd_dmaengine_dai_dma_data dma_params_tx;
>  	struct snd_dmaengine_dai_dma_data dma_params_rx;
>  
> +	bool big_endian;
> +
>  	/* The name space will be allocated dynamically */
>  	char name[0];
>  };
> @@ -985,7 +987,7 @@ static bool fsl_spdif_writeable_reg(struct device *dev, unsigned int reg)
>  	}
>  }
>  
> -static const struct regmap_config fsl_spdif_regmap_config = {
> +static struct regmap_config fsl_spdif_regmap_config = {
>  	.reg_bits = 32,
>  	.reg_stride = 4,
>  	.val_bits = 32,
> @@ -1105,6 +1107,10 @@ static int fsl_spdif_probe(struct platform_device *pdev)
>  	memcpy(&spdif_priv->cpu_dai_drv, &fsl_spdif_dai, sizeof(fsl_spdif_dai));
>  	spdif_priv->cpu_dai_drv.name = spdif_priv->name;
>  
> +	spdif_priv->big_endian = of_property_read_bool(np, "big-endian");
> +	if (spdif_priv->big_endian)
> +		fsl_spdif_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;

Why not just:
	if (of_property_read_bool(np, "big-endian"))
		fsl_spdif_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;

> +
>  	/* Get the addresses and IRQ */
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	regs = devm_ioremap_resource(&pdev->dev, res);
> -- 
> 1.8.4
> 
> 


