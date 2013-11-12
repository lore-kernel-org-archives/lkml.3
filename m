Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3KLI3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:29:11 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:33770 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931Ab3KLI3E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:29:04 -0500
Subject: Re: [PATCH v3 1/3] OF: Introduce Device Tree resolve support.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131111181739.06BC5C42348@trevor.secretlab.ca>
Date: Tue, 12 Nov 2013 09:28:42 +0100
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
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F60B2232-94D0-41C6-8D79-5A28FA282D4E@antoniou-consulting.com>
References: <1383923170-24914-1-git-send-email-panto@antoniou-consulting.com> <1383923170-24914-2-git-send-email-panto@antoniou-consulting.com> <20131111181739.06BC5C42348@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 11, 2013, at 7:17 PM, Grant Likely wrote:

> On Fri,  8 Nov 2013 17:06:08 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>> Introduce support for dynamic device tree resolution.
>> Using it, it is possible to prepare a device tree that's
>> been loaded on runtime to be modified and inserted at the kernel
>> live tree.
>> 
>> Export of of_resolve by Guenter Roeck <groeck@juniper.net>
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>> ---
>> .../devicetree/dynamic-resolution-notes.txt        |  25 ++
>> drivers/of/Kconfig                                 |   9 +
>> drivers/of/Makefile                                |   1 +
>> drivers/of/resolver.c                              | 396 +++++++++++++++++++++
>> include/linux/of.h                                 |  17 +
>> 5 files changed, 448 insertions(+)
>> create mode 100644 Documentation/devicetree/dynamic-resolution-notes.txt
>> create mode 100644 drivers/of/resolver.c
>> 
>> diff --git a/Documentation/devicetree/dynamic-resolution-notes.txt b/Documentation/devicetree/dynamic-resolution-notes.txt
>> new file mode 100644
>> index 0000000..0b396c4
>> --- /dev/null
>> +++ b/Documentation/devicetree/dynamic-resolution-notes.txt
>> @@ -0,0 +1,25 @@
>> +Device Tree Dynamic Resolver Notes
>> +----------------------------------
>> +
>> +This document describes the implementation of the in-kernel
>> +Device Tree resolver, residing in drivers/of/resolver.c and is a
>> +companion document to Documentation/devicetree/dt-object-internal.txt[1]
> 
> dt-object-internal.txt is in the DTC patch, not the kernel tree.
> 

Yes, good catch. I will fix the reference.

BTW, what about moving/copying some of the DTC docs in the kernel doc
directory? The dtc Documentation directory is missing from the kernel tree.


>> +
>> +How the resolver works
>> +----------------------
>> +
>> +The resolver is given as an input an arbitrary tree compiled with the
>> +proper dtc option and having a /plugin/ tag. This generates the
>> +appropriate __fixups__ & __local_fixups__ nodes as described in [1].
> 
> Missing footnote reference line for [1]?
> 

Yes.

>> +
>> +In sequence the resolver works by the following steps:
>> +
>> +1. Get the maximum device tree phandle value from the live tree + 1.
> 
> Is there a (realistic) worry about leaking phandle number space from
> plugging/unplugging trees repeated addition/removal of overlays?
> 

I think not. But doing it this way has the nice property of keeping all phandle
values the same each time you do a load-unload-load sequence. 

>> +2. Adjust all the local phandles of the tree to resolve by that amount.
>> +3. Using the __local__fixups__ node information adjust all local references
>> +   by the same amount.
>> +4. For each property in the __fixups__ node locate the node it references
>> +   in the live tree. This is the label used to tag the node.
>> +5. Retrieve the phandle of the target of the fixup.
>> +5. For each fixup in the property locate the node:property:offset location
>> +   and replace it with the phandle value.
>> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
>> index 78cc760..2a00ae5 100644
>> --- a/drivers/of/Kconfig
>> +++ b/drivers/of/Kconfig
>> @@ -74,4 +74,13 @@ config OF_MTD
>> 	depends on MTD
>> 	def_bool y
>> 
>> +config OF_RESOLVE
>> +	bool "OF Dynamic resolution support"
>> +	depends on OF
>> +	select OF_DYNAMIC
>> +	select OF_DEVICE
>> +	help
>> +	  Enable OF dynamic resolution support. This allows you to
>> +	  load Device Tree object fragments are run time.
>> +
>> endmenu # OF
>> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
>> index 9bc6d8c..93da457 100644
>> --- a/drivers/of/Makefile
>> +++ b/drivers/of/Makefile
>> @@ -9,3 +9,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
>> obj-$(CONFIG_OF_PCI)	+= of_pci.o
>> obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
>> obj-$(CONFIG_OF_MTD)	+= of_mtd.o
>> +obj-$(CONFIG_OF_RESOLVE)  += resolver.o
>> diff --git a/drivers/of/resolver.c b/drivers/of/resolver.c
>> new file mode 100644
>> index 0000000..dfbb51a
>> --- /dev/null
>> +++ b/drivers/of/resolver.c
>> @@ -0,0 +1,396 @@
>> +/*
>> + * Functions for dealing with DT resolution
>> + *
>> + * Copyright (C) 2012 Pantelis Antoniou <panto@antoniou-consulting.com>
>> + * Copyright (C) 2012 Texas Instruments Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_fdt.h>
>> +#include <linux/string.h>
>> +#include <linux/ctype.h>
>> +#include <linux/errno.h>
>> +#include <linux/string.h>
>> +#include <linux/slab.h>
>> +
>> +/**
>> + * Find a subtree's maximum phandle value.
>> + */
>> +static phandle __of_get_tree_max_phandle(struct device_node *node,
>> +		phandle max_phandle)
>> +{
>> +	struct device_node *child;
>> +
>> +	if (node->phandle != 0 && node->phandle != OF_PHANDLE_ILLEGAL &&
>> +			node->phandle > max_phandle)
>> +		max_phandle = node->phandle;
>> +
>> +	__for_each_child_of_node(node, child)
>> +		max_phandle = __of_get_tree_max_phandle(child, max_phandle);
>> +
>> +	return max_phandle;
>> +}
>> +
>> +/**
>> + * Find live tree's maximum phandle value.
>> + */
>> +static phandle of_get_tree_max_phandle(void)
>> +{
>> +	struct device_node *node;
>> +	phandle phandle;
>> +	unsigned long flags;
>> +
>> +	/* get root node */
>> +	node = of_find_node_by_path("/");
>> +	if (node == NULL)
>> +		return OF_PHANDLE_ILLEGAL;
>> +
>> +	/* now search recursively */
>> +	raw_spin_lock_irqsave(&devtree_lock, flags);
>> +	phandle = __of_get_tree_max_phandle(node, 0);
>> +	raw_spin_unlock_irqrestore(&devtree_lock, flags);
> 
> I don't see another user. What is the reason for the __ version of
> of_get_tree_max_phandle?
> 
>> +
>> +	of_node_put(node);
>> +
>> +	return phandle;
>> +}
>> +
>> +/**
>> + * Adjust a subtree's phandle values by a given delta.
>> + * Makes sure not to just adjust the device node's phandle value,
>> + * but modify the phandle properties values as well.
>> + */
>> +static void __of_adjust_tree_phandles(struct device_node *node,
>> +		int phandle_delta)
>> +{
>> +	struct device_node *child;
>> +	struct property *prop;
>> +	phandle phandle;
>> +
>> +	/* first adjust the node's phandle direct value */
>> +	if (node->phandle != 0 && node->phandle != OF_PHANDLE_ILLEGAL)
>> +		node->phandle += phandle_delta;
>> +
>> +	/* now adjust phandle & linux,phandle values */
>> +	for_each_property_of_node(node, prop) {
>> +
>> +		/* only look for these two */
>> +		if (of_prop_cmp(prop->name, "phandle") != 0 &&
>> +		    of_prop_cmp(prop->name, "linux,phandle") != 0)
>> +			continue;
>> +
>> +		/* must be big enough */
>> +		if (prop->length < 4)
>> +			continue;
>> +
>> +		/* read phandle value */
>> +		phandle = be32_to_cpu(*(uint32_t *)prop->value);
> 
> Unnecessary cast if you use:
> 	phandle = be32_to_cpup(prop->value);

OK.

> 
>> +		if (phandle == OF_PHANDLE_ILLEGAL)	/* unresolved */
>> +			continue;
> 
> Isn't this an error condition? Should never have OF_PHANDLE_ILLEGAL in
> the property here.

Hmm, I think so. I'll see if there's anything special there.

> 
>> +
>> +		/* adjust */
>> +		*(uint32_t *)prop->value = cpu_to_be32(node->phandle);
> 
> *(__be32*)prop->value = ...


It is the same for the compiler, but you're right. 
> 
>> +	}
>> +
>> +	/* now do the children recursively */
>> +	__for_each_child_of_node(node, child)
>> +		__of_adjust_tree_phandles(child, phandle_delta);
>> +}
>> +
>> +/**
>> + * Adjust the local phandle references by the given phandle delta.
>> + * Assumes the existances of a __local_fixups__ node at the root
>> + * of the tree. Does not take any devtree locks so make sure you
>> + * call this on a tree which is at the detached state.
>> + */
>> +static int __of_adjust_tree_phandle_references(struct device_node *node,
>> +		int phandle_delta)
>> +{
>> +	phandle phandle;
>> +	struct device_node *refnode, *child;
>> +	struct property *rprop, *sprop;
>> +	char *propval, *propcur, *propend, *nodestr, *propstr, *s;
>> +	int offset, propcurlen;
>> +	int err;
>> +
>> +	/* locate the symbols & fixups nodes on resolve */
>> +	__for_each_child_of_node(node, child)
>> +		if (of_node_cmp(child->name, "__local_fixups__") == 0)
>> +			break;
>> +
>> +	/* no local fixups */
>> +	if (child == NULL)
>> +		return 0;
>> +
>> +	/* find the local fixups property */
>> +	for_each_property_of_node(child, rprop) {
>> +
>> +		/* skip properties added automatically */
>> +		if (of_prop_cmp(rprop->name, "name") == 0)
>> +			continue;
>> +
>> +		/* make a copy */
>> +		propval = kmalloc(rprop->length, GFP_KERNEL);
>> +		if (propval == NULL) {
>> +			pr_err("%s: Could not copy value of '%s'\n",
>> +					__func__, rprop->name);
>> +			return -ENOMEM;
>> +		}
>> +		memcpy(propval, rprop->value, rprop->length);
>> +
>> +		propend = propval + rprop->length;
>> +		for (propcur = propval; propcur < propend;
>> +				propcur += propcurlen + 1) {
>> +
>> +			propcurlen = strlen(propcur);
>> +
>> +			nodestr = propcur;
>> +			s = strchr(propcur, ':');
>> +			if (s == NULL) {
>> +				pr_err("%s: Illegal symbol entry '%s' (1)\n",
>> +					__func__, propcur);
>> +				err = -EINVAL;
>> +				goto err_fail;
>> +			}
>> +			*s++ = '\0';
>> +
>> +			propstr = s;
>> +			s = strchr(s, ':');
>> +			if (s == NULL) {
>> +				pr_err("%s: Illegal symbol entry '%s' (2)\n",
>> +					__func__, (char *)rprop->value);
>> +				err = -EINVAL;
>> +				goto err_fail;
>> +			}
>> +
>> +			*s++ = '\0';
>> +			offset = simple_strtoul(s, NULL, 10);
>> +
>> +			/* look into the resolve node for the full path */
>> +			refnode = __of_find_node_by_full_name(node, nodestr);
>> +			if (refnode == NULL) {
>> +				pr_warn("%s: Could not find refnode '%s'\n",
>> +					__func__, (char *)rprop->value);
>> +				continue;
>> +			}
>> +
>> +			/* now find the property */
>> +			for_each_property_of_node(refnode, sprop) {
>> +				if (of_prop_cmp(sprop->name, propstr) == 0)
>> +					break;
>> +			}
>> +
>> +			if (sprop == NULL) {
>> +				pr_err("%s: Could not find property '%s'\n",
>> +					__func__, (char *)rprop->value);
>> +				err = -ENOENT;
>> +				goto err_fail;
>> +			}
>> +
>> +			phandle = be32_to_cpu(*(uint32_t *)
>> +					(sprop->value + offset));
>> +			*(uint32_t *)(sprop->value + offset) =
>> +				cpu_to_be32(phandle + phandle_delta);
>> +		}
>> +
>> +		kfree(propval);
>> +	}
>> +
>> +	return 0;
>> +
>> +err_fail:
>> +	kfree(propval);
>> +	return err;
>> +}
>> +
>> +/**
>> + * of_resolve	- Resolve the given node against the live tree.
>> + *
>> + * @resolve:	Node to resolve
>> + *
>> + * Perform dynamic Device Tree resolution against the live tree
>> + * to the given node to resolve. This depends on the live tree
>> + * having a __symbols__ node, and the resolve node the __fixups__ &
>> + * __local_fixups__ nodes (if needed).
>> + * The result of the operation is a resolve node that it's contents
>> + * are fit to be inserted or operate upon the live tree.
>> + * Returns 0 on success or a negative error value on error.
>> + */
>> +int of_resolve(struct device_node *resolve)
>> +{
>> +	struct device_node *child, *refnode;
>> +	struct device_node *root_sym, *resolve_sym, *resolve_fix;
>> +	struct property *rprop, *sprop;
>> +	const char *refpath;
>> +	char *propval, *propcur, *propend, *nodestr, *propstr, *s;
>> +	int offset, propcurlen;
>> +	phandle phandle, phandle_delta;
>> +	int err;
>> +
>> +	/* the resolve node must exist, and be detached */
>> +	if (resolve == NULL ||
>> +			!of_node_check_flag(resolve, OF_DETACHED)) {
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* first we need to adjust the phandles */
>> +	phandle_delta = of_get_tree_max_phandle() + 1;
> 
> Probably need to grab the devtree lock before doing the above, and not
> release it until after the trees are merged. Otherwise there is the
> potential of trying to merge two trees at once and getting phandle
> conflicts.

No, because the device tree being passed it it guaranteed to be
in detached state, it is not part of the live device tree; 
the check in the beginning of the function makes sure.

When we apply the overlay the devtree lock is taken properly.

> 
> Overall the patch looks pretty nice. I'm looking forward to hearing back
> on the questions above.
> 

Thank you
> g.
> 

Regards

-- Pantelis

