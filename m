Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab3LKNO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:14:59 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:34114 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3LKNO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:14:57 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/3] OF: kobj ops should only happen on attached nodes
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1386684833-24112-4-git-send-email-panto@antoniou-consulting.com>
References: <1386684833-24112-1-git-send-email-panto@antoniou-consulting.com > <1386684833-24112-4-git-send-email-panto@antoniou-consulting.com>
Date: Wed, 11 Dec 2013 13:14:50 +0000
Message-Id: <20131211131450.EE33BC4061A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 16:13:53 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> kobject operation should only take place on already attached (live)
> device nodes. The same restriction applies to the invocation of
> device tree notifiers.
> 
> Introduce a simple of_node_is_attached() test which tests whether
> the given node is attached via means of the allnodes member.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/of/base.c | 87 ++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 64 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index db0de86..c6299bd 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -89,6 +89,13 @@ int __weak of_node_to_nid(struct device_node *np)
>  #endif
>  
>  #if defined(CONFIG_OF_DYNAMIC)
> +
> +/* simple test for figuring out if node is attached */
> +static inline int of_node_is_attached(struct device_node *np)
> +{
> +	return np && np->allnodes == &of_allnodes;
> +}
> +
>  /**
>   *	of_node_get - Increment refcount of a node
>   *	@node:	Node to inc refcount, NULL is supported to
> @@ -98,7 +105,7 @@ int __weak of_node_to_nid(struct device_node *np)
>   */
>  struct device_node *of_node_get(struct device_node *node)
>  {
> -	if (node && of_kset)
> +	if (node && of_kset && of_node_is_attached(node))
>  		kobject_get(&node->kobj);

Remind me, what is the reason for not wanting to refcount unattached
nodes? I would think that doing a refcount is still desirable, even if
it doesn't show up in sysfs.

I know we talked about this on IRC, but I don't remember the conclusion
we came to.

>  	return node;
>  }
> @@ -156,7 +163,7 @@ static void of_node_release(struct kobject *kobj)
>   */
>  void of_node_put(struct device_node *node)
>  {
> -	if (node && of_kset)
> +	if (node && of_kset && of_node_is_attached(node))
>  		kobject_put(&node->kobj);
>  }
>  EXPORT_SYMBOL(of_node_put);
> @@ -210,6 +217,10 @@ static int __of_add_property(struct device_node *np, struct property *pp)
>  	if (!of_kset)
>  		return 0;
>  
> +	/* don't do anything with a detached node */
> +	if (!of_node_is_attached(np))
> +		return 0;
> +

I'm concerned about this whole approach. It "feels" wrong to me.
Perhaps the mistake is to having the unflatten routine be the one also
adding the nodes to the tree. The whole thing could be sidestepped if
unflattening the data structure was a completely separate step from
attaching it to the live tree.

We could rework fdt.c (and pdt.c) to not touch allnodes at all and then
have a separate function that walks the unflattened device tree and
attaches the lot at once. That would make it easier for you to grab an
unflattened tree and work with it before adding nodes to the core tree.

>  	/* Important: Don't leak passwords */
>  	secure = strncmp(pp->name, "security-", 9) == 0;
>  
> @@ -235,6 +246,9 @@ static int __of_node_add(struct device_node *np)
>  	if (!of_kset)
>  		return 0;
>  
> +	if (!of_node_is_attached(np))
> +		return 0;
> +
>  	np->kobj.kset = of_kset;
>  	if (!np->parent) {
>  		/* Nodes without parents are new top level trees */
> @@ -259,6 +273,9 @@ int of_node_add(struct device_node *np)
>  {
>  	int rc = 0;
>  
> +	if (!of_node_is_attached(np))
> +		return 0;
> +
>  	/* fake the return while of_init is not yet called */
>  	mutex_lock(&of_aliases_mutex);
>  	kobject_init(&np->kobj, &of_node_ktype);
> @@ -274,10 +291,16 @@ static void of_node_remove(struct device_node *np)
>  {
>  	struct property *pp;
>  
> +	/* don't do anything with a detached node */
> +	if (!of_node_is_attached(np))
> +		return;
> +
>  	for_each_property_of_node(np, pp)
>  		sysfs_remove_bin_file(&np->kobj, &pp->attr);
>  
>  	kobject_del(&np->kobj);
> +
> +	of_node_put(np);
>  }
>  #endif
>  
> @@ -1626,9 +1649,11 @@ int of_add_property(struct device_node *np, struct property *prop)
>  	unsigned long flags;
>  	int rc;
>  
> -	rc = of_property_notify(OF_RECONFIG_ADD_PROPERTY, np, prop);
> -	if (rc)
> -		return rc;
> +	if (of_node_is_attached(np)) {
> +		rc = of_property_notify(OF_RECONFIG_ADD_PROPERTY, np, prop);
> +		if (rc)
> +			return rc;
> +	}
>  
>  	prop->next = NULL;
>  	raw_spin_lock_irqsave(&devtree_lock, flags);
> @@ -1664,9 +1689,11 @@ int of_remove_property(struct device_node *np, struct property *prop)
>  	int found = 0;
>  	int rc;
>  
> -	rc = of_property_notify(OF_RECONFIG_REMOVE_PROPERTY, np, prop);
> -	if (rc)
> -		return rc;
> +	if (of_node_is_attached(np)) {
> +		rc = of_property_notify(OF_RECONFIG_REMOVE_PROPERTY, np, prop);
> +		if (rc)
> +			return rc;
> +	}
>  
>  	raw_spin_lock_irqsave(&devtree_lock, flags);
>  	next = &np->properties;
> @@ -1686,7 +1713,8 @@ int of_remove_property(struct device_node *np, struct property *prop)
>  	if (!found)
>  		return -ENODEV;
>  
> -	sysfs_remove_bin_file(&np->kobj, &prop->attr);
> +	if (of_node_is_attached(np))
> +		sysfs_remove_bin_file(&np->kobj, &prop->attr);
>  
>  	return 0;
>  }
> @@ -1706,9 +1734,11 @@ int of_update_property(struct device_node *np, struct property *newprop)
>  	unsigned long flags;
>  	int rc, found = 0;
>  
> -	rc = of_property_notify(OF_RECONFIG_UPDATE_PROPERTY, np, newprop);
> -	if (rc)
> -		return rc;
> +	if (of_node_is_attached(np)) {
> +		rc = of_property_notify(OF_RECONFIG_UPDATE_PROPERTY, np, newprop);
> +		if (rc)
> +			return rc;
> +	}
>  
>  	if (!newprop->name)
>  		return -EINVAL;
> @@ -1736,9 +1766,11 @@ int of_update_property(struct device_node *np, struct property *newprop)
>  	if (!found)
>  		return -ENODEV;
>  
> -	/* Update the sysfs attribute */
> -	sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
> -	__of_add_property(np, newprop);
> +	if (of_node_is_attached(np)) {
> +		/* Update the sysfs attribute */
> +		sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
> +		__of_add_property(np, newprop);
> +	}
>  
>  	return 0;
>  }
> @@ -1782,10 +1814,6 @@ int of_attach_node(struct device_node *np)
>  	unsigned long flags;
>  	int rc;
>  
> -	rc = of_reconfig_notify(OF_RECONFIG_ATTACH_NODE, np);
> -	if (rc)
> -		return rc;
> -
>  	raw_spin_lock_irqsave(&devtree_lock, flags);
>  	np->sibling = np->parent->child;
>  	np->allnext = of_allnodes;
> @@ -1794,7 +1822,18 @@ int of_attach_node(struct device_node *np)
>  	np->allnodes = &of_allnodes;
>  	raw_spin_unlock_irqrestore(&devtree_lock, flags);
>  
> -	of_node_add(np);
> +	rc = of_node_add(np);
> +	if (rc != 0)
> +		goto err_detach;
> +
> +	rc = of_reconfig_notify(OF_RECONFIG_ATTACH_NODE, np);
> +	if (rc)
> +		goto err_detach;
> +

I'm pretty sure the notifier is where it is to allow a notifier callback
to intercepted it before it gets attached to the tree. I suspect this
change will break prom_reconfig_notifier. Notifying after
attachment, or before removal will require a separate set of notifiers.

> +	return 0;
> +
> +err_detach:
> +	of_node_remove(np);
>  	return 0;
>  }
>  
> @@ -1810,9 +1849,11 @@ int of_detach_node(struct device_node *np)
>  	unsigned long flags;
>  	int rc = 0;
>  
> -	rc = of_reconfig_notify(OF_RECONFIG_DETACH_NODE, np);
> -	if (rc)
> -		return rc;
> +	if (of_node_is_attached(np)) {
> +		rc = of_reconfig_notify(OF_RECONFIG_DETACH_NODE, np);
> +		if (rc)
> +			return rc;
> +	}
>  
>  	raw_spin_lock_irqsave(&devtree_lock, flags);
>  
> -- 
> 1.7.12
> 

