Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaBDRWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:22:15 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39532 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBDRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:22:13 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv2 1/2] of: add __of_add_property() without lock operations
To: Xiubo Li <Li.Xiubo@freescale.com>, robh+dt@kernel.org
Cc: panto@antoniou-consulting.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
In-Reply-To: <1390370260-11273-1-git-send-email-Li.Xiubo@freescale.com>
References: <1390370260-11273-1-git-send-email-Li.Xiubo@freescale.com>
Date: Tue, 04 Feb 2014 17:22:05 +0000
Message-Id: <20140204172205.C1EFFC4050F@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014 13:57:39 +0800, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> There two places will use the same code for adding one new property to
> the DT node. Adding __of_add_property() and prepare for fixing
> of_update_property()'s bug.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>

Applied, thanks.

g.

> ---
>  drivers/of/base.c | 38 ++++++++++++++++++++++++--------------
>  1 file changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index f807d0e..b86b77a 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1469,11 +1469,31 @@ static int of_property_notify(int action, struct device_node *np,
>  #endif
>  
>  /**
> + * __of_add_property - Add a property to a node without lock operations
> + */
> +static int __of_add_property(struct device_node *np, struct property *prop)
> +{
> +	struct property **next;
> +
> +	prop->next = NULL;
> +	next = &np->properties;
> +	while (*next) {
> +		if (strcmp(prop->name, (*next)->name) == 0)
> +			/* duplicate ! don't insert it */
> +			return -EEXIST;
> +
> +		next = &(*next)->next;
> +	}
> +	*next = prop;
> +
> +	return 0;
> +}
> +
> +/**
>   * of_add_property - Add a property to a node
>   */
>  int of_add_property(struct device_node *np, struct property *prop)
>  {
> -	struct property **next;
>  	unsigned long flags;
>  	int rc;
>  
> @@ -1481,27 +1501,17 @@ int of_add_property(struct device_node *np, struct property *prop)
>  	if (rc)
>  		return rc;
>  
> -	prop->next = NULL;
>  	raw_spin_lock_irqsave(&devtree_lock, flags);
> -	next = &np->properties;
> -	while (*next) {
> -		if (strcmp(prop->name, (*next)->name) == 0) {
> -			/* duplicate ! don't insert it */
> -			raw_spin_unlock_irqrestore(&devtree_lock, flags);
> -			return -1;
> -		}
> -		next = &(*next)->next;
> -	}
> -	*next = prop;
> +	rc = __of_add_property(np, prop);
>  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
>  
>  #ifdef CONFIG_PROC_DEVICETREE
>  	/* try to add to proc as well if it was initialized */
> -	if (np->pde)
> +	if (!rc && np->pde)
>  		proc_device_tree_add_prop(np->pde, prop);
>  #endif /* CONFIG_PROC_DEVICETREE */
>  
> -	return 0;
> +	return rc;
>  }
>  
>  /**
> -- 
> 1.8.4
> 
> 

