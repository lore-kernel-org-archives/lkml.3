Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaKCLVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:21:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58564 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbaKCLVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:21:50 -0500
Message-ID: <54576545.8030300@ti.com>
Date: Mon, 3 Nov 2014 16:51:41 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Oussama Ghorbel <ghorbel@pivasoftware.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Rabin Vincent <rabin@rab.in>, <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
References: <20141006194418.GA399@debian> <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
In-Reply-To: <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tuesday 07 October 2014 04:32 PM, Oussama Ghorbel wrote:
> The USB OTG port does not work since v3.16 on omap platform.
> This is a regression introduced by the commit
> eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
>  and remove).
> This because the call to pm_runtime_enable() function is moved after the
> call to devm_phy_create() function, which has side effect since later in
> the subsequent calls of devm_phy_create() there is a check with
> pm_runtime_enabled() to configure few things.

This is the only fix for this -rc cycle in the PHY susbsystem. So can you take
this directly? Or else I can prepare a pull request. Let me know.

Acked-by: Kishon Vijay Abraham I <kishon@ti.com>

Thanks
Kishon
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
> 
