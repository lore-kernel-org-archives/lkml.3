Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3LPLD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:03:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34287 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3LPLDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:03:25 -0500
Message-ID: <52AEDDE2.8060406@ti.com>
Date: Mon, 16 Dec 2013 16:32:58 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 2/5] phy: add support for indexed lookup
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com> <1386601737-8735-3-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1386601737-8735-3-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 09 December 2013 08:38 PM, Heikki Krogerus wrote:
> Removes the need for the consumer drivers requesting the
> phys to provide name for the phy. This should ease the use
> of the framework considerable when using only one phy, which
> is usually the case when except with USB, but it can also
> be useful with multiple phys.

If index has to be used with multiple PHYs, the controller should be aware of
the order in which it is populated in dt data. That's not good.
> This will also reduce noise from the framework when there is
> no phy by changing warnings to debug messages.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/phy/phy-core.c  | 106 ++++++++++++++++++++++++++++++++++--------------
>  include/linux/phy/phy.h |  14 +++++++
>  2 files changed, 89 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 1102aef..99dc046 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -53,7 +53,8 @@ static int devm_phy_match(struct device *dev, void *res, void *match_data)
>  	return res == match_data;
>  }
>  
> -static struct phy *phy_lookup(struct device *device, const char *con_id)
> +static struct phy *phy_lookup(struct device *device, const char *con_id,
> +			      unsigned int idx)
>  {
>  	unsigned int count;
>  	struct phy *phy;
> @@ -67,6 +68,10 @@ static struct phy *phy_lookup(struct device *device, const char *con_id)
>  		count = phy->init_data->num_consumers;
>  		consumers = phy->init_data->consumers;
>  		while (count--) {
> +			/* index must always match exactly */
> +			if (!con_id)
> +				if (idx != count)
> +					continue;
>  			if (!strcmp(consumers->dev_name, dev_name(device)) &&
>  					!strcmp(consumers->port, con_id)) {
>  				class_dev_iter_exit(&iter);
> @@ -242,7 +247,8 @@ EXPORT_SYMBOL_GPL(phy_power_off);
>  /**
>   * of_phy_get() - lookup and obtain a reference to a phy by phandle
>   * @dev: device that requests this phy
> - * @index: the index of the phy
> + * @con_id: name of the phy from device's point of view
> + * @idx: the index of the phy if name is not used
>   *
>   * Returns the phy associated with the given phandle value,
>   * after getting a refcount to it or -ENODEV if there is no such phy or
> @@ -250,12 +256,20 @@ EXPORT_SYMBOL_GPL(phy_power_off);
>   * not yet loaded. This function uses of_xlate call back function provided
>   * while registering the phy_provider to find the phy instance.
>   */
> -static struct phy *of_phy_get(struct device *dev, int index)
> +static struct phy *of_phy_get(struct device *dev, const char *con_id,
> +			      unsigned int idx)
>  {
>  	int ret;
>  	struct phy_provider *phy_provider;
>  	struct phy *phy = NULL;
>  	struct of_phandle_args args;
> +	int index;
> +
> +	if (!con_id)
> +		index = idx;
> +	else
> +		index = of_property_match_string(dev->of_node, "phy-names",
> +						 con_id);
>  
>  	ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-cells",
>  		index, &args);
> @@ -348,38 +362,36 @@ struct phy *of_phy_simple_xlate(struct device *dev, struct of_phandle_args
>  EXPORT_SYMBOL_GPL(of_phy_simple_xlate);
>  
>  /**
> - * phy_get() - lookup and obtain a reference to a phy.
> + * phy_get_index() - obtain a phy based on index

NAK. It still takes a 'char' argument and the name is misleading.
Btw are you replacing phy_get() or adding a new API in addition to phy_get()?
>   * @dev: device that requests this phy
>   * @con_id: name of the phy from device's point of view
> + * @idx: index of the phy to obtain in the consumer
>   *
> - * Returns the phy driver, after getting a refcount to it; or
> - * -ENODEV if there is no such phy.  The caller is responsible for
> - * calling phy_put() to release that count.
> + * This variant of phy_get() allows to access PHYs other than the first
> + * defined one for functions that define several PHYs.
>   */
> -struct phy *phy_get(struct device *dev, const char *con_id)
> +struct phy *phy_get_index(struct device *dev, const char *con_id,
> +			  unsigned int idx)
>  {
> -	int index = 0;
>  	struct phy *phy = NULL;
>  
> -	if (con_id == NULL) {
> -		dev_WARN(dev, "missing string\n");
> -		return ERR_PTR(-EINVAL);
> +	if (dev->of_node) {
> +		dev_dbg(dev, "using device tree for PHY lookup\n");
> +		phy = of_phy_get(dev, con_id, idx);
>  	}
>  
> -	if (dev->of_node) {
> -		index = of_property_match_string(dev->of_node, "phy-names",
> -						 con_id);
> -		phy = of_phy_get(dev, index);
> -		if (IS_ERR(phy)) {
> -			dev_err(dev, "unable to find phy\n");
> -			return phy;
> -		}
> -	} else {
> -		phy = phy_lookup(dev, con_id);
> -		if (IS_ERR(phy)) {
> -			dev_err(dev, "unable to find phy\n");
> -			return phy;
> -		}
> +	/**
> +	 * Either we are not using DT, or their lookup did not return
> +	 * a result. In that case, use platform lookup as a fallback.
> +	 */

In a dt boot, if it has not returned a result how will platform lookup help
since there wouldn't be be any board file in the case of dt boot (to populate
PHY consumers). Maybe your later patch will handle that.
> +	if (!phy || IS_ERR(phy)) {
> +		dev_dbg(dev, "using lookup tables for PHY lookup");
> +		phy = phy_lookup(dev, con_id, idx);
> +	}
> +
> +	if (IS_ERR(phy)) {
> +		dev_dbg(dev, "unable to find phy\n");
> +		return phy;
>  	}
>  
>  	if (!try_module_get(phy->ops->owner))
> @@ -389,18 +401,20 @@ struct phy *phy_get(struct device *dev, const char *con_id)
>  
>  	return phy;
>  }
> -EXPORT_SYMBOL_GPL(phy_get);
> +EXPORT_SYMBOL_GPL(phy_get_index);
>  
>  /**
> - * devm_phy_get() - lookup and obtain a reference to a phy.
> + * devm_phy_get_index() - obtain a phy based on index

I don't see the need of these 2 APIs.

Thanks
Kishon
