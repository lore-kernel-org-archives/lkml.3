Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbaGCNcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:32:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55411 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbaGCNcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:32:13 -0400
Message-ID: <53B55B4A.8020709@ti.com>
Date: Thu, 3 Jul 2014 19:01:54 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <nsekhar@ti.com>, <nm@ti.com>, <george.cherian@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] phy: omap-usb2: Balance pm_runtime_enable() on probe
 failure
References: <1404302638-3003-1-git-send-email-rogerq@ti.com> <1404302638-3003-6-git-send-email-rogerq@ti.com>
In-Reply-To: <1404302638-3003-6-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Wednesday 02 July 2014 05:33 PM, Roger Quadros wrote:
> If probe fails then we need to call pm_runtime_disable() to balance
> out the previous pm_runtime_enable() call. Else it will cause
> unbalanced pm_runtime_enable() call in the succeding probe call.
> 
> This anomaly was observed when the call to devm_phy_create() failed
> with -EPROBE_DEFER.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/phy/phy-omap-usb2.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> index 7007c11..c6f9809 100644
> --- a/drivers/phy/phy-omap-usb2.c
> +++ b/drivers/phy/phy-omap-usb2.c
> @@ -265,15 +265,19 @@ static int omap_usb2_probe(struct platform_device *pdev)
>  	pm_runtime_enable(phy->dev);
>  
>  	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
> -	if (IS_ERR(generic_phy))
> +	if (IS_ERR(generic_phy)) {
> +		pm_runtime_disable(phy->dev);
>  		return PTR_ERR(generic_phy);
> +	}

Maybe we can move pm_runtime_enable to just before phy_provider_register?
>  
>  	phy_set_drvdata(generic_phy, phy);
>  
>  	phy_provider = devm_of_phy_provider_register(phy->dev,
>  			of_phy_simple_xlate);
> -	if (IS_ERR(phy_provider))
> +	if (IS_ERR(phy_provider)) {
> +		pm_runtime_disable(phy->dev);
>  		return PTR_ERR(phy_provider);
> +	}

Noticed pm_runtime_disable was missing in omap_usb2_remove too. Would be good
to fix it here.

Cheers
Kishon
