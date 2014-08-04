Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaHDGll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 02:41:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47101 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaHDGlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 02:41:40 -0400
Message-ID: <53DF2B0D.7060002@ti.com>
Date: Mon, 4 Aug 2014 12:11:17 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Yaniv Gardi <ygardi@codeaurora.org>
CC: <linux-arm-msm@vger.kernel>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] phy: extend APIs of the generic phy framework
References: <1406810222-19365-1-git-send-email-ygardi@codeaurora.org>
In-Reply-To: <1406810222-19365-1-git-send-email-ygardi@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 31 July 2014 06:07 PM, Yaniv Gardi wrote:
> This change adds a few more APIs to the phy_ops structure:
> advertise_quirks - API for setting the phy quirks

What are these phy quirks? An explanation on what you are are planning to do
with these quirks might help.
> suspend - API for the implementation of phy suspend sequence
> resume - API for the implementation of phy resume sequence

Why not use the existing pm_runtime's suspend/resume callbacks?

> 
> Change-Id: I44dd77f2603d20acb02ccb0cc0d20ade884f97c2
Remove this..

> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> ---
>  Documentation/phy.txt   |  6 ++---
>  drivers/phy/phy-core.c  | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/phy/phy.h | 33 ++++++++++++++++++++++++++++
>  3 files changed, 94 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/phy.txt b/Documentation/phy.txt
> index c6594af..f0dc28e 100644
> --- a/Documentation/phy.txt
> +++ b/Documentation/phy.txt
> @@ -63,9 +63,9 @@ struct phy *devm_phy_create(struct device *dev, struct device_node *node,
>  The PHY drivers can use one of the above 2 APIs to create the PHY by passing
>  the device pointer, phy ops and init_data.
>  phy_ops is a set of function pointers for performing PHY operations such as
> -init, exit, power_on and power_off. *init_data* is mandatory to get a reference
> -to the PHY in the case of non-dt boot. See section *Board File Initialization*
> -on how init_data should be used.
> +init, exit, power_on and power_off, , suspend, resume and advertise_quirks.
> +*init_data* is mandatory to get a reference to the PHY in the case of non-dt
> +boot. See section *Board File Initialization* on how init_data should be used.
>  
>  Inorder to dereference the private data (in phy_ops), the phy provider driver
>  can use phy_set_drvdata() after creating the PHY and use phy_get_drvdata() in
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index ff5eec5..77abaab 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -293,6 +293,64 @@ int phy_power_off(struct phy *phy)
>  }
>  EXPORT_SYMBOL_GPL(phy_power_off);
>  
> +int phy_suspend(struct phy *phy)
> +{
> +	int ret = 0;
> +
> +	if (!phy->ops->suspend)
> +		return -ENOTSUPP;
> +
> +	mutex_lock(&phy->mutex);
> +
> +	if (--phy->resume_count == 0) {
> +		ret =  phy->ops->suspend(phy);
> +		if (ret) {
> +			dev_err(&phy->dev, "phy suspend failed --> %d\n", ret);
> +			/* reverting the resume_count since suspend failed */
> +			phy->resume_count++;
> +			goto out;
> +		}
> +	}
> +out:
> +	mutex_unlock(&phy->mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL(phy_suspend);
> +
> +int phy_resume(struct phy *phy)
> +{
> +	int ret = 0;
> +
> +	if (!phy->ops->resume)
> +		return -ENOTSUPP;
> +
> +	mutex_lock(&phy->mutex);
> +
> +	if (phy->resume_count++ == 0) {
> +		ret =  phy->ops->resume(phy);
> +		if (ret) {
> +			dev_err(&phy->dev, "phy resume failed --> %d\n", ret);
> +			/* reverting the resume_count since resume failed */
> +			phy->resume_count--;
> +			goto out;
> +		}
> +	}
> +out:
> +	mutex_unlock(&phy->mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL(phy_resume);
> +
> +void phy_advertise_quirks(struct phy *phy)
> +{
> +	if (phy->ops->advertise_quirks) {
> +		mutex_lock(&phy->mutex);
> +		phy->ops->advertise_quirks(phy);
> +		mutex_unlock(&phy->mutex);
> +	}
> +}
> +EXPORT_SYMBOL(phy_advertise_quirks);
> +
>  /**
>   * _of_phy_get() - lookup and obtain a reference to a phy by phandle
>   * @np: device_node for which to get the phy
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index 8cb6f81..5b96d65 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -28,6 +28,14 @@ struct phy;
>   * @exit: operation to be performed while exiting
>   * @power_on: powering on the phy
>   * @power_off: powering off the phy
> + * @advertise_quirks: setting specific phy quirks. this api is for an
> +		      internal use of the device driver, and its
> +		      purpose is to exteriorize the driver's phy quirks
> +		      according to phy version (or other parameters),
> +		      so further behaviour of the driver's phy is based
> +		      on those quirks.

Can you be more specific on what you do with this? This looks more like a
candidate for flags than callback to me?

Thanks
Kishon
