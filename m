Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab3LFFbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 00:31:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40955 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3LFFa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 00:30:58 -0500
Message-ID: <52A16104.3080704@ti.com>
Date: Fri, 6 Dec 2013 11:00:44 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <s.nawrocki@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>
Subject: Re: [PATCH 1/9] phy: core: Change the way of_phy_get is called
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com> <1386246579-25141-2-git-send-email-k.debski@samsung.com>
In-Reply-To: <1386246579-25141-2-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 05 December 2013 05:59 PM, Kamil Debski wrote:
> Previously the of_phy_get function took a struct device * and
> was declared static. It was impossible to call it from
> another driver and thus it was impossible to get phy defined

It was never intended to be called from other drivers. What's up with the
wrapper of of_phy_get, phy_get()/devm_phy_get()? Why isn't that enough?

Thanks
Kishon
> for a given node.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/phy/phy-core.c  |   12 +++++-------
>  include/linux/phy/phy.h |    1 +
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 03cf8fb..7fb3474 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -250,20 +250,17 @@ EXPORT_SYMBOL_GPL(phy_power_off);
>   * not yet loaded. This function uses of_xlate call back function provided
>   * while registering the phy_provider to find the phy instance.
>   */
> -static struct phy *of_phy_get(struct device *dev, int index)
> +struct phy *of_phy_get(struct device_node *np, int index)
>  {
>  	int ret;
>  	struct phy_provider *phy_provider;
>  	struct phy *phy = NULL;
>  	struct of_phandle_args args;
>  
> -	ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-cells",
> +	ret = of_parse_phandle_with_args(np, "phys", "#phy-cells",
>  		index, &args);
> -	if (ret) {
> -		dev_dbg(dev, "failed to get phy in %s node\n",
> -			dev->of_node->full_name);
> +	if (ret)
>  		return ERR_PTR(-ENODEV);
> -	}
>  
>  	mutex_lock(&phy_provider_mutex);
>  	phy_provider = of_phy_provider_lookup(args.np);
> @@ -281,6 +278,7 @@ err0:
>  
>  	return phy;
>  }
> +EXPORT_SYMBOL_GPL(of_phy_get);
>  
>  /**
>   * phy_put() - release the PHY
> @@ -370,7 +368,7 @@ struct phy *phy_get(struct device *dev, const char *string)
>  	if (dev->of_node) {
>  		index = of_property_match_string(dev->of_node, "phy-names",
>  			string);
> -		phy = of_phy_get(dev, index);
> +		phy = of_phy_get(dev->of_node, index);
>  		if (IS_ERR(phy)) {
>  			dev_err(dev, "unable to find phy\n");
>  			return phy;
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index 6d72269..169f572 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -131,6 +131,7 @@ struct phy *phy_get(struct device *dev, const char *string);
>  struct phy *devm_phy_get(struct device *dev, const char *string);
>  void phy_put(struct phy *phy);
>  void devm_phy_put(struct device *dev, struct phy *phy);
> +struct phy *of_phy_get(struct device_node *np, int index);
>  struct phy *of_phy_simple_xlate(struct device *dev,
>  	struct of_phandle_args *args);
>  struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
> 

