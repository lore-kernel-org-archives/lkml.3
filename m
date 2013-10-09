Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab3JIBl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:41:56 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:6847
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494Ab3JIBly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:41:54 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 9 Oct 2013 09:42:09 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
CC: <cjb@laptop.org>, <festevam@gmail.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: Check the return value from
 clk_prepare_enable()
Message-ID: <20131009014208.GD8946@S2101-09.ap.freescale.net>
References: <1381240048-22685-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1381240048-22685-1-git-send-email-fabio.estevam@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:47:28AM -0300, Fabio Estevam wrote:
> clk_prepare_enable() may fail, so let's check its return value and propagate it
> in the case of error.
> 
> Also, fix the sequence for disabling the clock in the probe error path and 
> also in the remove function.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/mmc/host/sdhci-esdhc-imx.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index b9899e9..abc9836 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -877,9 +877,17 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
>  
>  	pltfm_host->clk = imx_data->clk_per;
>  
> -	clk_prepare_enable(imx_data->clk_per);
> -	clk_prepare_enable(imx_data->clk_ipg);
> -	clk_prepare_enable(imx_data->clk_ahb);
> +	err = clk_prepare_enable(imx_data->clk_per);
> +	if (err)
> +		goto free_sdhci;
> +
> +	err = clk_prepare_enable(imx_data->clk_ipg);
> +	if (err)
> +		goto err_ipg;
> +
> +	err = clk_prepare_enable(imx_data->clk_ahb);
> +	if (err)
> +		goto err_ahb;
>  
>  	imx_data->pinctrl = devm_pinctrl_get(&pdev->dev);
>  	if (IS_ERR(imx_data->pinctrl)) {
> @@ -995,9 +1003,11 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
>  	return 0;
>  
>  disable_clk:
> -	clk_disable_unprepare(imx_data->clk_per);
> -	clk_disable_unprepare(imx_data->clk_ipg);
>  	clk_disable_unprepare(imx_data->clk_ahb);
> +err_ahb:

Naming schema of the existing labels seems to be 'acting' rather than
'reasoning', so I guess 'disable_ipg:' might fit here better?

Shawn

> +	clk_disable_unprepare(imx_data->clk_ipg);
> +err_ipg:
> +	clk_disable_unprepare(imx_data->clk_per);
>  free_sdhci:
>  	sdhci_pltfm_free(pdev);
>  	return err;
> @@ -1012,9 +1022,9 @@ static int sdhci_esdhc_imx_remove(struct platform_device *pdev)
>  
>  	sdhci_remove_host(host, dead);
>  
> -	clk_disable_unprepare(imx_data->clk_per);
> -	clk_disable_unprepare(imx_data->clk_ipg);
>  	clk_disable_unprepare(imx_data->clk_ahb);
> +	clk_disable_unprepare(imx_data->clk_ipg);
> +	clk_disable_unprepare(imx_data->clk_per);
>  
>  	sdhci_pltfm_free(pdev);
>  
> -- 
> 1.8.1.2
> 
> 

