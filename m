Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3KKOhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:37:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36076 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab3KKOh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:37:28 -0500
Message-ID: <5280EB9F.1050003@ti.com>
Date: Mon, 11 Nov 2013 20:07:19 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [patch] drivers: phy: tweaks to phy_create()
References: <20131106075412.GB13475@elgon.mountain>
In-Reply-To: <20131106075412.GB13475@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Wednesday 06 November 2013 01:24 PM, Dan Carpenter wrote:
> If this was called with a NULL "dev" then it lead to a NULL dereference
> when we called dev_WARN().  I have changed it to WARN_ON() so that we
> get a stack dump and can fix the caller.
> 
> If ida_simple_get() failed then there was a missing call to kfree(phy).
> 
> The rest of this patch is just cleanup like returning directly instead
> of having do-nothing gotos.  Using descriptive labels instead of
> GW-BASIC style "err0" and "err1".  I also flipped the order of
> put_device() and ida_remove() so they are a mirror reflection of the
> order they were allocated.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Can you create this patch on top of
git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git fixes ?

Thanks
Kishon

> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 03cf8fb..18b9de7 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -437,23 +437,18 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
>  	int id;
>  	struct phy *phy;
>  
> -	if (!dev) {
> -		dev_WARN(dev, "no device provided for PHY\n");
> -		ret = -EINVAL;
> -		goto err0;
> -	}
> +	if (WARN_ON(!dev))
> +		return ERR_PTR(-EINVAL);
>  
>  	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
> -	if (!phy) {
> -		ret = -ENOMEM;
> -		goto err0;
> -	}
> +	if (!phy)
> +		return ERR_PTR(-ENOMEM);
>  
>  	id = ida_simple_get(&phy_ida, 0, 0, GFP_KERNEL);
>  	if (id < 0) {
>  		dev_err(dev, "unable to get id\n");
>  		ret = id;
> -		goto err0;
> +		goto free_phy;
>  	}
>  
>  	device_initialize(&phy->dev);
> @@ -468,11 +463,11 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
>  
>  	ret = dev_set_name(&phy->dev, "phy-%s.%d", dev_name(dev), id);
>  	if (ret)
> -		goto err1;
> +		goto put_dev;
>  
>  	ret = device_add(&phy->dev);
>  	if (ret)
> -		goto err1;
> +		goto put_dev;
>  
>  	if (pm_runtime_enabled(dev)) {
>  		pm_runtime_enable(&phy->dev);
> @@ -481,12 +476,12 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
>  
>  	return phy;
>  
> -err1:
> -	ida_remove(&phy_ida, phy->id);
> +put_dev:
>  	put_device(&phy->dev);
> +	ida_remove(&phy_ida, phy->id);
> +free_phy:
>  	kfree(phy);
>  
> -err0:
>  	return ERR_PTR(ret);
>  }
>  EXPORT_SYMBOL_GPL(phy_create);
> 

