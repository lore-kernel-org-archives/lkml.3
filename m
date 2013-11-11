Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3KKJBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:01:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49069 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3KKJBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:01:16 -0500
Message-ID: <52809CD7.6080306@ti.com>
Date: Mon, 11 Nov 2013 14:31:11 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: phy: fix memory leak in error handling
References: <1383974928-20730-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1383974928-20730-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Saturday 09 November 2013 10:58 AM, Michael Opdenacker wrote:
> This fixes a memory leak in the phy_create() function.
> 
> If ida_simple_get() returns with an error, the code jumps
> to the "err0" label without freeing the "phy" pointer.
> 
> This patch introduces a new error management label to address this.
> 
> Issue found with Coverity (CID 1127219)
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

A patch has already been sent for fixing this.

https://git.kernel.org/cgit/linux/kernel/git/kishon/linux-phy.git/commit/?h=fixes

Thanks
Kishon

> ---
>  drivers/phy/phy-core.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 03cf8fb81554..8ddffe84d905 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -453,7 +453,7 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
>  	if (id < 0) {
>  		dev_err(dev, "unable to get id\n");
>  		ret = id;
> -		goto err0;
> +		goto err1;
>  	}
>  
>  	device_initialize(&phy->dev);
> @@ -468,11 +468,11 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
>  
>  	ret = dev_set_name(&phy->dev, "phy-%s.%d", dev_name(dev), id);
>  	if (ret)
> -		goto err1;
> +		goto err2;
>  
>  	ret = device_add(&phy->dev);
>  	if (ret)
> -		goto err1;
> +		goto err2;
>  
>  	if (pm_runtime_enabled(dev)) {
>  		pm_runtime_enable(&phy->dev);
> @@ -481,9 +481,11 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
>  
>  	return phy;
>  
> -err1:
> +err2:
>  	ida_remove(&phy_ida, phy->id);
>  	put_device(&phy->dev);
> +
> +err1:
>  	kfree(phy);
>  
>  err0:
> 

