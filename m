Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3HAVQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:16:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57327 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3HAVQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:16:20 -0400
Message-ID: <51FAD020.8090306@wwwdotorg.org>
Date: Thu, 01 Aug 2013 15:16:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu
Subject: Re: [PATCH 4/6] usb: phy: tegra: Program new PHY parameters
References: <1375292522-7855-1-git-send-email-ttynkkynen@nvidia.com> <1375292522-7855-5-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1375292522-7855-5-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 11:42 AM, Tuomas Tynkkynen wrote:
> The Tegra30 TRM recommends configuration of certain PHY parameters for
> optimal quality. Program the following registers based on device tree
> parameters:
> 
> - UTMIP_XCVR_HSSLEW: HS slew rate control.
> - UTMIP_HSSQUELCH_LEVEL: HS squelch detector level
> - UTMIP_HSDISCON_LEVEL: HS disconnect detector level.
> 
> These registers exist in Tegra20, but programming them hasn't been
> necessary, so these parameters won't be set on Tegra20 to keep the
> device trees backward compatible.
> 
> Additionally, the UTMIP_XCVR_SETUP parameter can be set from fuses
> instead of a software-programmed value, as the optimal value can
> vary between invidual boards. The boolean property
> nvidia,xcvr-setup-use-fuses can be used to enable this behaviour.

> diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c

> -#define   UTMIP_XCVR_HSSLEW_MSB(x)		(((x) & 0x7f) << 25)
> +#define   UTMIP_XCVR_HSSLEW(x)			(((x) & 0x3) << 4)
> +#define   UTMIP_XCVR_HSSLEW_MSB(x)		((((x) & 0x1ff) >> 2) << 25)

Similarly, may as well s/0x1ff/0x1fc/ there too.

> @@ -262,7 +267,14 @@ static void utmip_pad_power_on(struct tegra_usb_phy *phy)
>  
>  	if (utmip_pad_count++ == 0) {
>  		val = readl(base + UTMIP_BIAS_CFG0);
> -		val &= ~(UTMIP_OTGPD | UTMIP_BIASPD);
> +		val &= ~(UTMIP_OTGPD | UTMIP_BIASPD |
> +			UTMIP_HSSQUELCH_LEVEL(~0) |
> +			UTMIP_HSDISCON_LEVEL(~0) |
> +			UTMIP_HSDISCON_LEVEL_MSB(~0));
> +
> +		val |= UTMIP_HSSQUELCH_LEVEL(config->hssquelch_level);
> +		val |= UTMIP_HSDISCON_LEVEL(config->hsdiscon_level);
> +		val |= UTMIP_HSDISCON_LEVEL_MSB(config->hsdiscon_level);
>  		writel(val, base + UTMIP_BIAS_CFG0);
>  	}
>  
> @@ -432,11 +444,16 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
>  		 UTMIP_FORCE_PDZI_POWERDOWN | UTMIP_XCVR_LSBIAS_SEL |
>  		 UTMIP_XCVR_SETUP(~0) | UTMIP_XCVR_SETUP_MSB(~0) |
>  		 UTMIP_XCVR_LSFSLEW(~0) | UTMIP_XCVR_LSRSLEW(~0) |
> -		 UTMIP_XCVR_HSSLEW_MSB(~0));
> -	val |= UTMIP_XCVR_SETUP(config->xcvr_setup);
> -	val |= UTMIP_XCVR_SETUP_MSB(config->xcvr_setup);
> +		 UTMIP_XCVR_HSSLEW(~0) | UTMIP_XCVR_HSSLEW_MSB(~0));
> +
> +	if (!config->xcvr_setup_use_fuses) {
> +		val |= UTMIP_XCVR_SETUP(config->xcvr_setup);
> +		val |= UTMIP_XCVR_SETUP_MSB(config->xcvr_setup);
> +	}
>  	val |= UTMIP_XCVR_LSFSLEW(config->xcvr_lsfslew);
>  	val |= UTMIP_XCVR_LSRSLEW(config->xcvr_lsrslew);
> +	val |= UTMIP_XCVR_HSSLEW(config->xcvr_hsslew);
> +	val |= UTMIP_XCVR_HSSLEW_MSB(config->xcvr_hsslew);

Those two chunks end up clearing some fields in the register now even on
earlier chips, whereas before their values were maintained when doing
the read/modify/write. Yet, the commit description says the new fields
aren't changed on Tegra20. Do the changes above need to be guarded by if
(requires_extra_tuning_parameters)?

(When I tested this series, I only tested Tegra30/114; I didn't any
Tegra20 devices...)
