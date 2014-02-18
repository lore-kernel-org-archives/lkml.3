Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbaBROhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:37:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59887 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874AbaBROhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:37:20 -0500
Message-ID: <53036FFD.1040008@ti.com>
Date: Tue, 18 Feb 2014 20:06:45 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Chris Ball <chris@printf.net>,
        <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH V2 1/2] mmc: omap_hsmmc: Add support for quirky omap3
 hsmmc controller
References: <1392356749-32091-1-git-send-email-nm@ti.com> <1392356749-32091-2-git-send-email-nm@ti.com>
In-Reply-To: <1392356749-32091-2-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 February 2014 11:15 AM, Nishanth Menon wrote:
> When device is booted using devicetree, platforms impacted by Erratum
> 2.1.1.128 is not detected easily in the mmc driver. This erratum
> indicates that the module cannot do multi-block transfers. Platforms
> such as LDP which use OMAP3 ES revision prior to ES3.0 are impacted by
> this.
>
> Provide a new compatible property "ti,omap3-pre-es3-hsmmc" to allow
> driver to determine if driver needs to implement quirks associated
> with the specific module version (primarily because the IP revision
> information is not sufficient for the same).
>
> Signed-off-by: Nishanth Menon <nm@ti.com>

looks good to me
Acked-by: Balaji T K <balajitk@ti.com>

> ---
> Changes since v1:
> 	- new compatible flag as suggested by Tony which contains
> 	  the relevant controller flag to work around the erratum
>
> V1: https://patchwork.kernel.org/patch/3514851/
>
>   .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |    1 +
>   drivers/mmc/host/omap_hsmmc.c                      |   26 +++++++++++++++++---
>   2 files changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> index 8c8908a..ce80561 100644
> --- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> +++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> @@ -10,6 +10,7 @@ Required properties:
>   - compatible:
>    Should be "ti,omap2-hsmmc", for OMAP2 controllers
>    Should be "ti,omap3-hsmmc", for OMAP3 controllers
> + Should be "ti,omap3-pre-es3-hsmmc" for OMAP3 controllers pre ES3.0
>    Should be "ti,omap4-hsmmc", for OMAP4 controllers
>   - ti,hwmods: Must be "mmc<n>", n is controller instance starting 1
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 575f9cc..390f421 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -192,6 +192,11 @@ struct omap_hsmmc_host {
>   	struct	omap_mmc_platform_data	*pdata;
>   };
>
> +struct omap_mmc_of_data {
> +	u32 reg_offset;
> +	u8 controller_flags;
> +};
> +
>   static int omap_hsmmc_card_detect(struct device *dev, int slot)
>   {
>   	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
> @@ -1678,18 +1683,29 @@ static void omap_hsmmc_debugfs(struct mmc_host *mmc)
>   #endif
>
>   #ifdef CONFIG_OF
> -static u16 omap4_reg_offset = 0x100;
> +static const struct omap_mmc_of_data omap3_pre_es3_mmc_of_data = {
> +	/* See 35xx errata 2.1.1.128 in SPRZ278F */
> +	.controller_flags = OMAP_HSMMC_BROKEN_MULTIBLOCK_READ,
> +};
> +
> +static const struct omap_mmc_of_data omap4_mmc_of_data = {
> +	.reg_offset = 0x100,
> +};
>
>   static const struct of_device_id omap_mmc_of_match[] = {
>   	{
>   		.compatible = "ti,omap2-hsmmc",
>   	},
>   	{
> +		.compatible = "ti,omap3-pre-es3-hsmmc",
> +		.data = &omap3_pre_es3_mmc_of_data,
> +	},
> +	{
>   		.compatible = "ti,omap3-hsmmc",
>   	},
>   	{
>   		.compatible = "ti,omap4-hsmmc",
> -		.data = &omap4_reg_offset,
> +		.data = &omap4_mmc_of_data,
>   	},
>   	{},
>   };
> @@ -1759,6 +1775,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
>   	dma_cap_mask_t mask;
>   	unsigned tx_req, rx_req;
>   	struct pinctrl *pinctrl;
> +	const struct omap_mmc_of_data *data;
>
>   	match = of_match_device(of_match_ptr(omap_mmc_of_match), &pdev->dev);
>   	if (match) {
> @@ -1768,8 +1785,9 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
>   			return PTR_ERR(pdata);
>
>   		if (match->data) {
> -			const u16 *offsetp = match->data;
> -			pdata->reg_offset = *offsetp;
> +			data = match->data;
> +			pdata->reg_offset = data->reg_offset;
> +			pdata->controller_flags |= data->controller_flags;
>   		}
>   	}
>
>

