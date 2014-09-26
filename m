Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaIZNR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:17:59 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:56648 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbaIZNRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:17:54 -0400
Message-ID: <5425677B.9030700@pivasoftware.com>
Date: Fri, 26 Sep 2014 14:17:47 +0100
From: Oussama Ghorbel <ghorbel@pivasoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly
References: <1411575303-18858-1-git-send-email-ghorbel@pivasoftware.com>
In-Reply-To: <1411575303-18858-1-git-send-email-ghorbel@pivasoftware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:5VhaIhGYwit4rHKj1KKqSiNjaDFIT64Y+j4zd6/e8Hm
 YoER+5VOO/J1jcTKu6ggXwJkoIVM2QlkOmUIVaoTmUM9tHraUr
 HKy8dbDiT5ztVAMXCa8yWZaB7bHz+uLfX3CBAbX/gHHl4NZspJ
 3FcuthfYmmJ3TIvMkkZfOzG8xz3FTl4M58j43zzL2S5/deXLvY
 7YggmxEkjOg1f2Ugmngl/ofKzaVwqnxS4tXq5WilolE8hfOAe+
 3Xo31I1CitZeAKyofkO8G1HoyCBTwjo8z5n8Fu2aq0SHI/ajsk
 U+A6Bdja8T+BYY/pJJdSx7VzR3E1I1ChakLdFuueTqnNB6Lser
 XnLp+D8u/VRXJkaixz/kD/rM1wPebUHQSO/PydddD
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You may find merge conflict since v3.17-rc5.
If necessary I can send a re-based version of this patch on v3.17-rc5 
for seamless integration.
In short the line
generic_phy = devm_phy_create(phy->dev, &ops, NULL);
became
generic_phy = devm_phy_create(phy->dev, NULL, &ops, NULL);

Oussama

On 09/24/2014 05:15 PM, Oussama Ghorbel wrote:
> The USB OTG port does not work since v3.16 on omap platform.
> This is a regression introduced by the commit
> eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
>   and remove).
> This because the call to pm_runtime_enable() function is moved after the
> call to devm_phy_create() function, which has side effect since later in
> the subsequent calls of devm_phy_create() there is a check with
> pm_runtime_enabled() to configure few things.
>
> Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
> ---
>   drivers/phy/phy-omap-usb2.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> index 34b3961..3fb9293 100644
> --- a/drivers/phy/phy-omap-usb2.c
> +++ b/drivers/phy/phy-omap-usb2.c
> @@ -262,14 +262,16 @@ static int omap_usb2_probe(struct platform_device *pdev)
>   	otg->phy		= &phy->phy;
>   
>   	platform_set_drvdata(pdev, phy);
> +	pm_runtime_enable(phy->dev);
>   
>   	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
> -	if (IS_ERR(generic_phy))
> +	if (IS_ERR(generic_phy)) {
> +		pm_runtime_disable(phy->dev);
>   		return PTR_ERR(generic_phy);
> +	}
>   
>   	phy_set_drvdata(generic_phy, phy);
>   
> -	pm_runtime_enable(phy->dev);
>   	phy_provider = devm_of_phy_provider_register(phy->dev,
>   			of_phy_simple_xlate);
>   	if (IS_ERR(phy_provider)) {

