Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaAFHPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:15:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35735 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbaAFHPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:15:03 -0500
Message-ID: <52CA57DB.9040405@ti.com>
Date: Mon, 6 Jan 2014 12:44:35 +0530
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
Subject: Re: [PATCH v4 2/9] phy: core: Add devm_of_phy_get to phy-core
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com> <1387545857-9472-3-git-send-email-k.debski@samsung.com>
In-Reply-To: <1387545857-9472-3-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 December 2013 06:54 PM, Kamil Debski wrote:
> Adding devm_of_phy_get will allow to get phys by supplying a
> pointer to the struct device_node instead of struct device.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>   drivers/phy/phy-core.c  |   31 +++++++++++++++++++++++++++++++
>   include/linux/phy/phy.h |    2 ++
>   2 files changed, 33 insertions(+)
>
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index d6f8c34..0551cc3 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -450,6 +450,37 @@ struct phy *devm_phy_get(struct device *dev, const char *string)
>   EXPORT_SYMBOL_GPL(devm_phy_get);
>
>   /**
> + * devm_of_phy_get() - lookup and obtain a reference to a phy.
> + * @dev: device that requests this phy
> + * @np: node containing the phy
> + * @con_id: name of the phy from device's point of view
> + *
> + * Gets the phy using of_phy_get(), and associates a device with it using
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
>    * phy_create() - create a new phy
>    * @dev: device that is creating the new phy
>    * @ops: function pointers for performing phy operations
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index bcb6274..864914c 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -129,6 +129,8 @@ int phy_power_on(struct phy *phy);
>   int phy_power_off(struct phy *phy);
>   struct phy *phy_get(struct device *dev, const char *string);
>   struct phy *devm_phy_get(struct device *dev, const char *string);
> +struct phy *devm_of_phy_get(struct device *dev, struct device_node *np,
> +			    const char *con_id);

stub for devm_of_phy_get also..

Thanks
Kishon
>   void phy_put(struct phy *phy);
>   void devm_phy_put(struct device *dev, struct phy *phy);
>   struct phy *of_phy_get(struct device_node *np, const char *con_id);
>

