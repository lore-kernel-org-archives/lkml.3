Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaAFHNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:13:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57136 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbaAFHNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:13:14 -0500
Message-ID: <52CA5772.1010300@ti.com>
Date: Mon, 6 Jan 2014 12:42:50 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <s.nawrocki@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>,
        <tjakobi@math.uni-bielefeld.de>, <stern@rowland.harvard.edu>
Subject: Re: [PATCH v4 1/9] phy: core: Add an exported of_phy_get function
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com> <1387545857-9472-2-git-send-email-k.debski@samsung.com>
In-Reply-To: <1387545857-9472-2-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 20 December 2013 06:54 PM, Kamil Debski wrote:
> Previously the of_phy_get function took a struct device * and
> was declared static. It was impossible to call it from
> another driver and thus it was impossible to get phy defined
> for a given node. The old function was renamed to _of_phy_get
> and was left for internal use. of_phy_get function was added
> and it was exported. The function enables to get a phy for
> a given device tree node.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>   drivers/phy/phy-core.c  |   45 ++++++++++++++++++++++++++++++++++++---------
>   include/linux/phy/phy.h |    1 +
>   2 files changed, 37 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 03cf8fb..d6f8c34 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -240,8 +240,8 @@ out:
>   EXPORT_SYMBOL_GPL(phy_power_off);
>
>   /**
> - * of_phy_get() - lookup and obtain a reference to a phy by phandle
> - * @dev: device that requests this phy
> + * _of_phy_get() - lookup and obtain a reference to a phy by phandle
> + * @np: device_node for which to get the phy
>    * @index: the index of the phy
>    *
>    * Returns the phy associated with the given phandle value,
> @@ -250,20 +250,17 @@ EXPORT_SYMBOL_GPL(phy_power_off);
>    * not yet loaded. This function uses of_xlate call back function provided
>    * while registering the phy_provider to find the phy instance.
>    */
> -static struct phy *of_phy_get(struct device *dev, int index)
> +static struct phy *_of_phy_get(struct device_node *np, int index)
>   {
>   	int ret;
>   	struct phy_provider *phy_provider;
>   	struct phy *phy = NULL;
>   	struct of_phandle_args args;
>
> -	ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-cells",
> +	ret = of_parse_phandle_with_args(np, "phys", "#phy-cells",
>   		index, &args);
> -	if (ret) {
> -		dev_dbg(dev, "failed to get phy in %s node\n",
> -			dev->of_node->full_name);
> +	if (ret)
>   		return ERR_PTR(-ENODEV);
> -	}
>
>   	mutex_lock(&phy_provider_mutex);
>   	phy_provider = of_phy_provider_lookup(args.np);
> @@ -283,6 +280,36 @@ err0:
>   }
>
>   /**
> + * of_phy_get() - lookup and obtain a reference to a phy using a device_node.
> + * @np: device_node for which to get the phy
> + * @con_id: name of the phy from device's point of view
> + *
> + * Returns the phy driver, after getting a refcount to it; or
> + * -ENODEV if there is no such phy. The caller is responsible for
> + * calling phy_put() to release that count.
> + */
> +struct phy *of_phy_get(struct device_node *np, const char *con_id)
> +{
> +	struct phy *phy = NULL;
> +	int index = 0;
> +
> +	if (con_id)
> +		index = of_property_match_string(np, "phy-names", con_id);
> +
> +	phy = _of_phy_get(np, index);
> +	if (IS_ERR(phy))
> +		return phy;
> +
> +	if (!try_module_get(phy->ops->owner))
> +		return ERR_PTR(-EPROBE_DEFER);
> +
> +	get_device(&phy->dev);
> +
> +	return phy;
> +}
> +EXPORT_SYMBOL_GPL(of_phy_get);
> +
> +/**
>    * phy_put() - release the PHY
>    * @phy: the phy returned by phy_get()
>    *
> @@ -370,7 +397,7 @@ struct phy *phy_get(struct device *dev, const char *string)
>   	if (dev->of_node) {
>   		index = of_property_match_string(dev->of_node, "phy-names",
>   			string);
> -		phy = of_phy_get(dev, index);
> +		phy = _of_phy_get(dev->of_node, index);
>   		if (IS_ERR(phy)) {
>   			dev_err(dev, "unable to find phy\n");
>   			return phy;
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index 6d72269..bcb6274 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -131,6 +131,7 @@ struct phy *phy_get(struct device *dev, const char *string);
>   struct phy *devm_phy_get(struct device *dev, const char *string);
>   void phy_put(struct phy *phy);
>   void devm_phy_put(struct device *dev, struct phy *phy);
> +struct phy *of_phy_get(struct device_node *np, const char *con_id);

Add a stub for of_phy_get if CONFIG_GENERIC_PHY is not set and this 
patch should be ready for merge.

Thanks
Kishon
