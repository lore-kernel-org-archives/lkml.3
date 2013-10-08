Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3JHGpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:45:34 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:38885 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696Ab3JHGpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:45:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1102I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 8 Oct 2013 14:45:43 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
CC: <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc: sdhci-esdhc-imx: Remove custom properties
Message-ID: <20131008064537.GE7480@S2101-09.ap.freescale.net>
References: <1381167144-18098-1-git-send-email-fabio.estevam@freescale.com>
 <1381167144-18098-2-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1381167144-18098-2-git-send-email-fabio.estevam@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 02:32:24PM -0300, Fabio Estevam wrote:
> According to Documentation/devicetree/bindings/mmc/mmc.txt:
> 
> "Card detection:
> If no property below is supplied, host native card detect is used.
> Only one of the properties in this section should be supplied:
>   - broken-cd: There is no card detection available; polling must be used.
>   - cd-gpios: Specify GPIOs for card detection, see gpio binding
>   - non-removable: non-removable slot (like eMMC); assume always present. "
> 
> So remove the custom fsl,cd-controller and fsl,wp-controller properties, as the
> mmc core can take care of it.
> 
> Tested on mx51babbage, mx53qsb boards and mx6qsabresd boards.
> 
> Cc: Chris Ball <cjb@laptop.org>
> Cc: <linux-mmc@vger.kernel.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt | 6 ------
>  drivers/mmc/host/sdhci-esdhc-imx.c                      | 6 ------
>  2 files changed, 12 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
> index 1dd6225..5da8ab0 100644
> --- a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
> +++ b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
> @@ -9,18 +9,12 @@ by mmc.txt and the properties used by the sdhci-esdhc-imx driver.
>  Required properties:
>  - compatible : Should be "fsl,<chip>-esdhc"
>  
> -Optional properties:
> -- fsl,cd-controller : Indicate to use controller internal card detection
> -- fsl,wp-controller : Indicate to use controller internal write protection
> -
>  Examples:
>  
>  esdhc@70004000 {
>  	compatible = "fsl,imx51-esdhc";
>  	reg = <0x70004000 0x4000>;
>  	interrupts = <1>;
> -	fsl,cd-controller;
> -	fsl,wp-controller;
>  };
>  
>  esdhc@70008000 {
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index b9899e9..07662d1 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -796,12 +796,6 @@ sdhci_esdhc_imx_probe_dt(struct platform_device *pdev,
>  	if (of_get_property(np, "non-removable", NULL))
>  		boarddata->cd_type = ESDHC_CD_PERMANENT;
>  
> -	if (of_get_property(np, "fsl,cd-controller", NULL))
> -		boarddata->cd_type = ESDHC_CD_CONTROLLER;

Without this removed, flag SDHCI_QUIRK_BROKEN_CARD_DETECTION will be
kept for the host controller.  Consequently, MMC_CAP_NEEDS_POLL is set,
and we will use polling for card-detection.

Shawn

> -
> -	if (of_get_property(np, "fsl,wp-controller", NULL))
> -		boarddata->wp_type = ESDHC_WP_CONTROLLER;
> -
>  	boarddata->cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
>  	if (gpio_is_valid(boarddata->cd_gpio))
>  		boarddata->cd_type = ESDHC_CD_GPIO;
> -- 
> 1.8.1.2
> 
> 

