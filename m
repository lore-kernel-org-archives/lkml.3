Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3LPLFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:05:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34349 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3LPLFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:05:02 -0500
Message-ID: <52AEDE43.8030005@ti.com>
Date: Mon, 16 Dec 2013 16:34:35 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 4/5] arm: omap3: twl: use the new lookup method with usb
 phy
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com> <1386601737-8735-5-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1386601737-8735-5-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 09 December 2013 08:38 PM, Heikki Krogerus wrote:
> Provide a complete association for the phy and it's user
> (musb) with the new phy_lookup_table.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  arch/arm/mach-omap2/twl-common.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
> index b0d54da..972430b 100644
> --- a/arch/arm/mach-omap2/twl-common.c
> +++ b/arch/arm/mach-omap2/twl-common.c
> @@ -91,18 +91,13 @@ void __init omap_pmic_late_init(void)
>  }
>  
>  #if defined(CONFIG_ARCH_OMAP3)
> -struct phy_consumer consumers[] = {
> -	PHY_CONSUMER("musb-hdrc.0", "usb"),
> -};
> -
> -struct phy_init_data init_data = {
> -	.consumers = consumers,
> -	.num_consumers = ARRAY_SIZE(consumers),
> +static struct phy_lookup_table twl4030_usb_lookup = {
> +	.dev_id = "musb-hdrc.0",
> +	.table = PHY_LOOKUP("phy-twl4030_usb.0", NULL),
>  };

had a similar approach during the initial version of phy framework [1] (see
phy_bind) but changed it later [2] . Here you should know the device names of
two devices and even if one of them started using DEVID_AUTO, it'll start
breaking. Such an approach needs to reviewed carefully.

[1] -> https://lkml.org/lkml/2013/4/3/258
[2] -> http://www.spinics.net/lists/linux-usb/msg85299.html (removed phy_bind)

Cheers
Kishon
>  
>  static struct twl4030_usb_data omap3_usb_pdata = {
>  	.usb_mode	= T2_USB_MODE_ULPI,
> -	.init_data	= &init_data,
>  };
>  
>  static int omap3_batt_table[] = {
> @@ -225,8 +220,10 @@ void __init omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
>  	}
>  
>  	/* Common platform data configurations */
> -	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb)
> +	if (pdata_flags & TWL_COMMON_PDATA_USB && !pmic_data->usb) {
> +		phy_add_lookup_table(&twl4030_usb_lookup);
>  		pmic_data->usb = &omap3_usb_pdata;
> +	}
>  
>  	if (pdata_flags & TWL_COMMON_PDATA_BCI && !pmic_data->bci)
>  		pmic_data->bci = &omap3_bci_pdata;
> 

