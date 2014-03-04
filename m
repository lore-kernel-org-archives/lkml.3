Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbaCDIlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:41:32 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43626 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbaCDIla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:41:30 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv2 2/2] of: fix of_update_property()
To: Xiubo Li <Li.Xiubo@freescale.com>, robh+dt@kernel.org
Cc: panto@antoniou-consulting.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
In-Reply-To: <1390370260-11273-2-git-send-email-Li.Xiubo@freescale.com>
References: <1390370260-11273-1-git-send-email-Li.Xiubo@freescale.com> < 1390370260-11273-2-git-send-email-Li.Xiubo@freescale.com>
Date: Tue, 04 Mar 2014 16:41:22 +0800
Message-Id: <20140304084122.E3353C4308B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014 13:57:40 +0800, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> The of_update_property() is intented to update a property in a node
> and if the property does not exist, will add it.
> 
> The second search of the property is possibly won't be found, that
> maybe removed by other thread just before the second search begain.
> 
> Using the __of_find_property() and __of_add_property() instead and
> move them into lock operations.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Pantelis Antoniou <panto@antoniou-consulting.com>

I've had to revert this patch. See below...

> ---
>  drivers/of/base.c | 36 ++++++++++++++----------------------
>  1 file changed, 14 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index b86b77a..458072d 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1573,7 +1573,7 @@ int of_update_property(struct device_node *np, struct property *newprop)
>  {
>  	struct property **next, *oldprop;
>  	unsigned long flags;
> -	int rc, found = 0;
> +	int rc = 0;
>  
>  	rc = of_property_notify(OF_RECONFIG_UPDATE_PROPERTY, np, newprop);
>  	if (rc)
> @@ -1582,36 +1582,28 @@ int of_update_property(struct device_node *np, struct property *newprop)
>  	if (!newprop->name)
>  		return -EINVAL;
>  
> -	oldprop = of_find_property(np, newprop->name, NULL);
> -	if (!oldprop)
> -		return of_add_property(np, newprop);
> -
>  	raw_spin_lock_irqsave(&devtree_lock, flags);
> -	next = &np->properties;
> -	while (*next) {
> -		if (*next == oldprop) {
> -			/* found the node */
> -			newprop->next = oldprop->next;
> -			*next = newprop;
> -			oldprop->next = np->deadprops;
> -			np->deadprops = oldprop;
> -			found = 1;
> -			break;
> -		}
> -		next = &(*next)->next;
> +	oldprop = __of_find_property(np, newprop->name, NULL);
> +	if (!oldprop) {
> +		/* add the node */
> +		rc = __of_add_property(np, newprop);
> +	} else {
> +		/* replace the node */
> +		next = &oldprop;

Ugh. I just looked closer and the above line is completely broken.
&oldprop is the address of 'oldprop' on the stack, *not* the address of
the previous item in the list. The while loop is still required to find it.

g.

> +		newprop->next = oldprop->next;
> +		*next = newprop;
> +		oldprop->next = np->deadprops;
> +		np->deadprops = oldprop;
>  	}
>  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
>  
> -	if (!found)
> -		return -ENODEV;
> -
>  #ifdef CONFIG_PROC_DEVICETREE
>  	/* try to add to proc as well if it was initialized */
> -	if (np->pde)
> +	if (!rc && np->pde)
>  		proc_device_tree_update_prop(np->pde, newprop, oldprop);
>  #endif /* CONFIG_PROC_DEVICETREE */
>  
> -	return 0;
> +	return rc;
>  }
>  
>  #if defined(CONFIG_OF_DYNAMIC)
> -- 
> 1.8.4
> 
> 

