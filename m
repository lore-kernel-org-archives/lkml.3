Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176Ab3A1CMN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 21:12:13 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:50231 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab3A1CMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 21:12:09 -0500
Message-ID: <5105DE72.6000109@gmail.com>
Date: Sun, 27 Jan 2013 20:12:02 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] OF: Fixup resursive locking code paths
References: <1359138107-14159-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1359138107-14159-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 12:21 PM, Paul Gortmaker wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> There is no real reason to use a rwlock for devtree_lock. It even
> could be a mutex, but unfortunately it's locked from cpu hotplug
> paths which can't schedule :(
> 
> So it needs to become a raw lock on rt as well.  The devtree_lock would
> be the only user of a raw_rw_lock, so we are better off cleaning up the
> recursive locking paths which allows us to convert devtree_lock to a
> read_lock.
> 
> Here we do the standard thing of introducing __foo() as the "raw"
> version of foo(), so that we can take better control of the locking.
> The "raw" versions are not exported and are for internal use within
> the file itself.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---

Applied for 3.9.

Rob

> 
> [This has been living in the RT tree for several releases, and I've
>  put it on top of 3.8-rc4 mainline and tested it independently there
>  on a ppc sbc8548 board as well.  So it would be nice to get this in 3.9]
> 
>  drivers/of/base.c | 91 ++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 70 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 2390ddb..21195a1 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -164,16 +164,14 @@ void of_node_put(struct device_node *node)
>  EXPORT_SYMBOL(of_node_put);
>  #endif /* CONFIG_OF_DYNAMIC */
>  
> -struct property *of_find_property(const struct device_node *np,
> -				  const char *name,
> -				  int *lenp)
> +static struct property *__of_find_property(const struct device_node *np,
> +					   const char *name, int *lenp)
>  {
>  	struct property *pp;
>  
>  	if (!np)
>  		return NULL;
>  
> -	read_lock(&devtree_lock);
>  	for (pp = np->properties; pp; pp = pp->next) {
>  		if (of_prop_cmp(pp->name, name) == 0) {
>  			if (lenp)
> @@ -181,6 +179,18 @@ struct property *of_find_property(const struct device_node *np,
>  			break;
>  		}
>  	}
> +
> +	return pp;
> +}
> +
> +struct property *of_find_property(const struct device_node *np,
> +				  const char *name,
> +				  int *lenp)
> +{
> +	struct property *pp;
> +
> +	read_lock(&devtree_lock);
> +	pp = __of_find_property(np, name, lenp);
>  	read_unlock(&devtree_lock);
>  
>  	return pp;
> @@ -214,8 +224,20 @@ EXPORT_SYMBOL(of_find_all_nodes);
>   * Find a property with a given name for a given node
>   * and return the value.
>   */
> +static const void *__of_get_property(const struct device_node *np,
> +				     const char *name, int *lenp)
> +{
> +	struct property *pp = __of_find_property(np, name, lenp);
> +
> +	return pp ? pp->value : NULL;
> +}
> +
> +/*
> + * Find a property with a given name for a given node
> + * and return the value.
> + */
>  const void *of_get_property(const struct device_node *np, const char *name,
> -			 int *lenp)
> +			    int *lenp)
>  {
>  	struct property *pp = of_find_property(np, name, lenp);
>  
> @@ -226,13 +248,13 @@ EXPORT_SYMBOL(of_get_property);
>  /** Checks if the given "compat" string matches one of the strings in
>   * the device's "compatible" property
>   */
> -int of_device_is_compatible(const struct device_node *device,
> -		const char *compat)
> +static int __of_device_is_compatible(const struct device_node *device,
> +				     const char *compat)
>  {
>  	const char* cp;
>  	int cplen, l;
>  
> -	cp = of_get_property(device, "compatible", &cplen);
> +	cp = __of_get_property(device, "compatible", &cplen);
>  	if (cp == NULL)
>  		return 0;
>  	while (cplen > 0) {
> @@ -245,6 +267,20 @@ int of_device_is_compatible(const struct device_node *device,
>  
>  	return 0;
>  }
> +
> +/** Checks if the given "compat" string matches one of the strings in
> + * the device's "compatible" property
> + */
> +int of_device_is_compatible(const struct device_node *device,
> +		const char *compat)
> +{
> +	int res;
> +
> +	read_lock(&devtree_lock);
> +	res = __of_device_is_compatible(device, compat);
> +	read_unlock(&devtree_lock);
> +	return res;
> +}
>  EXPORT_SYMBOL(of_device_is_compatible);
>  
>  /**
> @@ -518,7 +554,8 @@ struct device_node *of_find_compatible_node(struct device_node *from,
>  		if (type
>  		    && !(np->type && (of_node_cmp(np->type, type) == 0)))
>  			continue;
> -		if (of_device_is_compatible(np, compatible) && of_node_get(np))
> +		if (__of_device_is_compatible(np, compatible) &&
> +		    of_node_get(np))
>  			break;
>  	}
>  	of_node_put(from);
> @@ -562,15 +599,9 @@ out:
>  }
>  EXPORT_SYMBOL(of_find_node_with_property);
>  
> -/**
> - * of_match_node - Tell if an device_node has a matching of_match structure
> - *	@matches:	array of of device match structures to search in
> - *	@node:		the of device structure to match against
> - *
> - *	Low level utility function used by device matching.
> - */
> -const struct of_device_id *of_match_node(const struct of_device_id *matches,
> -					 const struct device_node *node)
> +static
> +const struct of_device_id *__of_match_node(const struct of_device_id *matches,
> +					   const struct device_node *node)
>  {
>  	if (!matches)
>  		return NULL;
> @@ -584,14 +615,32 @@ const struct of_device_id *of_match_node(const struct of_device_id *matches,
>  			match &= node->type
>  				&& !strcmp(matches->type, node->type);
>  		if (matches->compatible[0])
> -			match &= of_device_is_compatible(node,
> -						matches->compatible);
> +			match &= __of_device_is_compatible(node,
> +							   matches->compatible);
>  		if (match)
>  			return matches;
>  		matches++;
>  	}
>  	return NULL;
>  }
> +
> +/**
> + * of_match_node - Tell if an device_node has a matching of_match structure
> + *	@matches:	array of of device match structures to search in
> + *	@node:		the of device structure to match against
> + *
> + *	Low level utility function used by device matching.
> + */
> +const struct of_device_id *of_match_node(const struct of_device_id *matches,
> +					 const struct device_node *node)
> +{
> +	const struct of_device_id *match;
> +
> +	read_lock(&devtree_lock);
> +	match = __of_match_node(matches, node);
> +	read_unlock(&devtree_lock);
> +	return match;
> +}
>  EXPORT_SYMBOL(of_match_node);
>  
>  /**
> @@ -619,7 +668,7 @@ struct device_node *of_find_matching_node_and_match(struct device_node *from,
>  	read_lock(&devtree_lock);
>  	np = from ? from->allnext : of_allnodes;
>  	for (; np; np = np->allnext) {
> -		if (of_match_node(matches, np) && of_node_get(np)) {
> +		if (__of_match_node(matches, np) && of_node_get(np)) {
>  			if (match)
>  				*match = matches;
>  			break;
> 

