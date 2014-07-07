Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaGGNnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:43:19 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:47617 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaGGNnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:43:17 -0400
Date: Mon, 7 Jul 2014 14:43:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        antoine.tenart@free-electrons.com, kgene.kim@samsung.com,
        maxime.ripard@free-electrons.com
Subject: Re: [RFC PATCH 1/2] phy: core: Fix of_phy_provider_lookup to return
 PHY provider for sub node
Message-ID: <20140707134311.GJ6407@lee--X1>
References: <1404486474-28312-1-git-send-email-kishon@ti.com>
 <1404486474-28312-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404486474-28312-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2014, Kishon Vijay Abraham I wrote:

> Fixed of_phy_provider_lookup to return 'phy_provider' if _of_phy_get
> passes the node pointer of the sub-node of phy provider node. This is
> needed when phy provider implements multiple PHYs and each PHY is
> modelled as the sub-node of PHY provider device node.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/phy-core.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index c64a2f3..a4a1f783 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -86,10 +86,18 @@ static struct phy *phy_lookup(struct device *device, const char *port)
>  static struct phy_provider *of_phy_provider_lookup(struct device_node *node)
>  {
>  	struct phy_provider *phy_provider;
> +	struct device_node *child;
>  
>  	list_for_each_entry(phy_provider, &phy_provider_list, list) {
> -		if (phy_provider->dev->of_node == node)
> +		if (phy_provider->dev->of_node != node) {
> +			for_each_child_of_node(phy_provider->dev->of_node,
> +				child) {
> +				if (child == node)
> +					return phy_provider;
> +			}
> +		} else {
>  			return phy_provider;
> +		}
>  	}
>  
>  	return ERR_PTR(-EPROBE_DEFER);

How about this instead:

>  	list_for_each_entry(phy_provider, &phy_provider_list, list) {
> 		if (phy_provider->dev->of_node == node)
>  			return phy_provider;
> +
> +		for_each_child_of_node(phy_provider->dev->of_node, child)
> +			if (child == node)
> +				return phy_provider;
>  	}

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
