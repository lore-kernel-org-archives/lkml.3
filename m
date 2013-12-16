Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3LPN0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:26:05 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57209 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702Ab3LPN0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:26:02 -0500
Message-ID: <52AEFF61.2030609@ti.com>
Date: Mon, 16 Dec 2013 18:55:53 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <t.figa@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <matt.porter@linaro.org>
Subject: Re: [PATCH v3 2/2] phy: core: Add devm_of_phy_get to phy-core
References: <1387198338-10556-1-git-send-email-k.debski@samsung.com> <1387198338-10556-2-git-send-email-k.debski@samsung.com>
In-Reply-To: <1387198338-10556-2-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 December 2013 06:22 PM, Kamil Debski wrote:
> Adding devm_of_phy_get will allow to get phys by supplying the
> device_node instead of by name.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/phy/phy-core.c  |   31 +++++++++++++++++++++++++++++++
>  include/linux/phy/phy.h |    2 ++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 0107f71..d45ad87 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -450,6 +450,37 @@ struct phy *devm_phy_get(struct device *dev, const char *string)
>  EXPORT_SYMBOL_GPL(devm_phy_get);
>  
>  /**
> + * devm_of_phy_get() - lookup and obtain a reference to a phy.
> + * @dev: device that requests this phy
> + * @np: node containing the phy
> + * @con_id: name of the phy from device's point of view
> + *
> + * Gets the phy using phy_get(), and associates a device with it using

%s/phy_get/of_phy_get
> + * devres. On driver detach, release function is invoked on the devres data,
> + * then, devres data is freed.
> + */
> +struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
> +			    const char *con_id)
> +{
> +	struct phy **ptr, *phy;
> +
> +	ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	phy = of_phy_get(np, con_id);
> +	if (!IS_ERR(phy)) {
> +		*ptr = phy;
> +		devres_add(dev, ptr);
> +	} else {
> +		devres_free(ptr);
> +	}
> +
> +	return phy;
> +}
> +EXPORT_SYMBOL_GPL(devm_of_phy_get);
> +
> +/**
>   * phy_create() - create a new phy
>   * @dev: device that is creating the new phy
>   * @ops: function pointers for performing phy operations
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index bcb6274..864914c 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -129,6 +129,8 @@ int phy_power_on(struct phy *phy);
>  int phy_power_off(struct phy *phy);
>  struct phy *phy_get(struct device *dev, const char *string);
>  struct phy *devm_phy_get(struct device *dev, const char *string);
> +struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
> +			    const char *con_id);
>  void phy_put(struct phy *phy);
>  void devm_phy_put(struct device *dev, struct phy *phy);
>  struct phy *of_phy_get(struct device_node *np, const char *con_id);

Apart from that one minor comment, this patch series can go in.

Thanks
Kishon
> 

