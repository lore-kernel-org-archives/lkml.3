Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbaJ2XJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:09:25 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:58633 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbaJ2XJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:09:21 -0400
Date: Thu, 30 Oct 2014 00:09:13 +0100
From: Rabin Vincent <rabin@rab.in>
To: kishon@ti.com, tony@atomide.com
Cc: rogerq@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ghorbel@pivasoftware.com, linux-omap@vger.kernel.org
Subject: Re: [PATCHv2] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
Message-ID: <20141029230913.GA26977@debian>
References: <20141006194418.GA399@debian>
 <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless I'm missing something, this patch appears to have still not been
picked up.  It would be nice if it can go in for 3.18 so that we have
working USB on pandaboard again at least in that release.

Tony, would you mind carrying it as OMAP maintainer since we haven't
heard anything from Kishon (the PHY maintainer) about this?  It's been
acked by Roger (whose patch introduced the problem).

Thanks.

(leaving the patch intact below)

On Tue, Oct 07, 2014 at 12:02:51PM +0100, Oussama Ghorbel wrote:
> The USB OTG port does not work since v3.16 on omap platform.
> This is a regression introduced by the commit
> eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
>  and remove).
> This because the call to pm_runtime_enable() function is moved after the
> call to devm_phy_create() function, which has side effect since later in
> the subsequent calls of devm_phy_create() there is a check with
> pm_runtime_enabled() to configure few things.
> 
> Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
> ---
>  drivers/phy/phy-omap-usb2.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> index 93d7835..acc13f8 100644
> --- a/drivers/phy/phy-omap-usb2.c
> +++ b/drivers/phy/phy-omap-usb2.c
> @@ -262,14 +262,16 @@ static int omap_usb2_probe(struct platform_device *pdev)
>  	otg->phy		= &phy->phy;
>  
>  	platform_set_drvdata(pdev, phy);
> +	pm_runtime_enable(phy->dev);
>  
>  	generic_phy = devm_phy_create(phy->dev, NULL, &ops, NULL);
> -	if (IS_ERR(generic_phy))
> +	if (IS_ERR(generic_phy)) {
> +		pm_runtime_disable(phy->dev);
>  		return PTR_ERR(generic_phy);
> +	}
>  
>  	phy_set_drvdata(generic_phy, phy);
>  
> -	pm_runtime_enable(phy->dev);
>  	phy_provider = devm_of_phy_provider_register(phy->dev,
>  			of_phy_simple_xlate);
>  	if (IS_ERR(phy_provider)) {
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
