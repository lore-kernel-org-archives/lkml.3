Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaBKHSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:18:53 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:21770
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762AbaBKHSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:18:52 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
Date: Tue, 11 Feb 2014 15:14:03 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ASoC: fsl-esai: big-endian support
Message-ID: <20140211071403.GB18803@MrMyself>
References: <1392097276-14705-1-git-send-email-Li.Xiubo@freescale.com>
 <1392097276-14705-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1392097276-14705-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 01:41:16PM +0800, Xiubo Li wrote:
> For most platforms, the CPU and ESAI device is in the same endianess
> mode. While for the LS1 platform, the CPU is in LE mode and the ESAI
> is in BE mode.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Nicolin Chen <Guangyu.Chen@freescale.com>
> ---
>  Documentation/devicetree/bindings/sound/fsl,esai.txt | 6 ++++++
>  sound/soc/fsl/fsl_esai.c                             | 7 ++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/sound/fsl,esai.txt b/Documentation/devicetree/bindings/sound/fsl,esai.txt
> index d7b99fa..c395371 100644
> --- a/Documentation/devicetree/bindings/sound/fsl,esai.txt
> +++ b/Documentation/devicetree/bindings/sound/fsl,esai.txt
> @@ -34,6 +34,11 @@ Required properties:
>      that ESAI would work in the synchronous mode, which means all the settings
>      for Receiving would be duplicated from Transmition related registers.
>  
> +  - big-endian : If this property is absent, the native endian mode will
> +    be in use as default, or the big endian mode will be in use for all the
> +    device registers.

> +
> +

Single blank line should be enough here :)

>  Example:
>  
>  esai: esai@02024000 {
> @@ -46,5 +51,6 @@ esai: esai@02024000 {
>  	dma-names = "rx", "tx";
>  	fsl,fifo-depth = <128>;
>  	fsl,esai-synchronous;
> +	big-endian;
>  	status = "disabled";
>  };
> diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
> index c84026c..e1f2669 100644
> --- a/sound/soc/fsl/fsl_esai.c
> +++ b/sound/soc/fsl/fsl_esai.c
> @@ -57,6 +57,7 @@ struct fsl_esai {
>  	bool sck_div[2];
>  	bool slave_mode;
>  	bool synchronous;
> +	bool big_endian;
>  	char name[32];
>  };
>  
> @@ -661,7 +662,7 @@ static bool fsl_esai_writeable_reg(struct device *dev, unsigned int reg)
>  	}
>  }
>  
> -static const struct regmap_config fsl_esai_regmap_config = {
> +static struct regmap_config fsl_esai_regmap_config = {
>  	.reg_bits = 32,
>  	.reg_stride = 4,
>  	.val_bits = 32,
> @@ -687,6 +688,10 @@ static int fsl_esai_probe(struct platform_device *pdev)
>  	esai_priv->pdev = pdev;
>  	strcpy(esai_priv->name, np->name);
>  
> +	esai_priv->big_endian = of_property_read_bool(np, "big-endian");
> +	if (esai_priv->big_endian)
> +		fsl_esai_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
> +

Same comments here. And please wait for Shawn's reply at the other patch
before you revise this part to V2.

Thanks.

>  	/* Get the addresses and IRQ */
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	regs = devm_ioremap_resource(&pdev->dev, res);
> -- 
> 1.8.4
> 
> 


