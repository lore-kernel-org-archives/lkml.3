Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbaFWQxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:53:13 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:44807 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbaFWQxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:53:10 -0400
X-Greylist: delayed 1420 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2014 12:53:08 EDT
Message-ID: <53A85549.7040809@nsn.com>
Date: Mon, 23 Jun 2014 18:26:49 +0200
From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: ext Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>
CC: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH 5/6] OF: Utility helper functions for dynamic nodes
References: <1403430039-15085-1-git-send-email-pantelis.antoniou@konsulko.com> <1403430039-15085-6-git-send-email-pantelis.antoniou@konsulko.com>
In-Reply-To: <1403430039-15085-6-git-send-email-pantelis.antoniou@konsulko.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 8290
X-purgate-ID: 151667::1403540816-00007A71-C5C94495/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pantelis!

On 22/06/14 11:40, ext Pantelis Antoniou wrote:
> Introduce helper functions for working with the live DT tree,
> all of them related to dynamically adding/removing nodes and
> properties.
> 
> __of_copy_property() copies a property dynamically
> __of_create_empty_node() creates an empty node
> 
> Bug fix about prop->len == 0 by Ionut Nicu <ioan.nicu.ext@nsn.com>

Are you sure about this? (see below...)
 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> ---
>  drivers/of/Makefile |   2 +-
>  drivers/of/util.c   | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of.h  |  42 ++++++++++++++++
>  3 files changed, 184 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/of/util.c
> 
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index 099b1fb..734d3e2 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -1,4 +1,4 @@
> -obj-y = base.o device.o platform.o
> +obj-y = base.o device.o platform.o util.o
>  obj-$(CONFIG_OF_FLATTREE) += fdt.o
>  obj-$(CONFIG_OF_EARLY_FLATTREE) += fdt_address.o
>  obj-$(CONFIG_OF_PROMTREE) += pdt.o
> diff --git a/drivers/of/util.c b/drivers/of/util.c
> new file mode 100644
> index 0000000..f4211f8
> --- /dev/null
> +++ b/drivers/of/util.c
> @@ -0,0 +1,141 @@
> +/*
> + * Utility functions for working with device tree(s)
> + *
> + * Copyright (C) 2012 Pantelis Antoniou <panto@antoniou-consulting.com>
> + * Copyright (C) 2012 Texas Instruments Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/string.h>
> +#include <linux/ctype.h>
> +#include <linux/errno.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +
> +/**
> + * __of_copy_property - Copy a property dynamically.
> + * @prop:	Property to copy
> + * @allocflags:	Allocation flags (typically pass GFP_KERNEL)
> + * @propflags:	Property flags
> + *
> + * Copy a property by dynamically allocating the memory of both the
> + * property stucture and the property name & contents. The property's
> + * flags have the OF_DYNAMIC bit set so that we can differentiate between
> + * dynamically allocated properties and not.
> + * Returns the newly allocated property or NULL on out of memory error.
> + */
> +struct property *__of_copy_property(const struct property *prop,
> +		gfp_t allocflags, unsigned long propflags)
> +{
> +	struct property *propn;
> +
> +	propn = kzalloc(sizeof(*prop), allocflags);
> +	if (propn == NULL)
> +		return NULL;
> +
> +	propn->_flags = propflags;
> +
> +	if (of_property_check_flag(propn, OF_ALLOCNAME)) {
> +		propn->name = kstrdup(prop->name, allocflags);
> +		if (propn->name == NULL)
> +			goto err_fail_name;
> +	} else
> +		propn->name = prop->name;
> +
> +	if (prop->length > 0) {
        ^^^^^^^^^^^^^^^^^^^^^
Seems, that length==0 case will still produce value==NULL results,
which will brake some checks in the kernel... Or am I missing something in
the new version?


> +		if (of_property_check_flag(propn, OF_ALLOCVALUE)) {
> +			propn->value = kmalloc(prop->length, allocflags);
> +			if (propn->value == NULL)
> +				goto err_fail_value;
> +			memcpy(propn->value, prop->value, prop->length);
> +		} else
> +			propn->value = prop->value;
> +
> +		propn->length = prop->length;
> +	}
> +
> +	/* mark the property as dynamic */
> +	of_property_set_flag(propn, OF_DYNAMIC);
> +
> +	return propn;
> +
> +err_fail_value:
> +	if (of_property_check_flag(propn, OF_ALLOCNAME))
> +		kfree(propn->name);
> +err_fail_name:
> +	kfree(propn);
> +	return NULL;
> +}
> +
> +/**
> + * __of_create_empty_node - Create an empty device node dynamically.
> + * @name:	Name of the new device node
> + * @type:	Type of the new device node
> + * @full_name:	Full name of the new device node
> + * @phandle:	Phandle of the new device node
> + * @allocflags:	Allocation flags (typically pass GFP_KERNEL)
> + * @nodeflags:	Node flags
> + *
> + * Create an empty device tree node, suitable for further modification.
> + * The node data are dynamically allocated and all the node flags
> + * have the OF_DYNAMIC & OF_DETACHED bits set.
> + * Returns the newly allocated node or NULL on out of memory error.
> + */
> +struct device_node *__of_create_empty_node(
> +		const char *name, const char *type, const char *full_name,
> +		phandle phandle, gfp_t allocflags, unsigned long nodeflags)
> +{
> +	struct device_node *node;
> +
> +	node = kzalloc(sizeof(*node), allocflags);
> +	if (node == NULL)
> +		return NULL;
> +
> +	node->_flags = nodeflags;
> +
> +	if (of_node_check_flag(node, OF_ALLOCNAME)) {
> +		node->name = kstrdup(name, allocflags);
> +		if (node->name == NULL)
> +			goto err_free_node;
> +	} else
> +		node->name = name;
> +
> +	if (of_node_check_flag(node, OF_ALLOCTYPE)) {
> +		node->type = kstrdup(type, allocflags);
> +		if (node->type == NULL)
> +			goto err_free_name;
> +	} else
> +		node->type = type;
> +
> +	if (of_node_check_flag(node, OF_ALLOCFULL)) {
> +		node->full_name = kstrdup(full_name, allocflags);
> +		if (node->full_name == NULL)
> +			goto err_free_type;
> +	} else
> +		node->full_name = full_name;
> +
> +	node->phandle = phandle;
> +	of_node_set_flag(node, OF_DYNAMIC);
> +	of_node_set_flag(node, OF_DETACHED);
> +
> +	of_node_init(node);
> +
> +	return node;
> +err_free_type:
> +	if (of_node_check_flag(node, OF_ALLOCTYPE))
> +		kfree(node->type);
> +err_free_name:
> +	if (of_node_check_flag(node, OF_ALLOCNAME))
> +		kfree(node->name);
> +err_free_node:
> +	kfree(node);
> +	return NULL;
> +}
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 5e4e1b3..d381eb5 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -211,6 +211,15 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
>  #define OF_DYNAMIC	1 /* node and properties were allocated via kmalloc */
>  #define OF_DETACHED	2 /* node has been detached from the device tree */
>  #define OF_POPULATED	3 /* device already created for the node */
> +#define OF_ALLOCNAME	4 /* name was kmalloc-ed */
> +#define OF_ALLOCTYPE	5 /* type was kmalloc-ed */
> +#define OF_ALLOCFULL	6 /* full_name was kmalloc-ed */
> +#define OF_ALLOCVALUE	7 /* value was kmalloc-ed */
> +
> +#define OF_NODE_ALLOCALL \
> +	((1 << OF_ALLOCNAME) | (1 << OF_ALLOCTYPE) | (1 << OF_ALLOCFULL))
> +#define OF_PROP_ALLOCALL \
> +	((1 << OF_ALLOCNAME) | (1 << OF_ALLOCVALUE))
>  
>  #define OF_IS_DYNAMIC(x) test_bit(OF_DYNAMIC, &x->_flags)
>  #define OF_MARK_DYNAMIC(x) set_bit(OF_DYNAMIC, &x->_flags)
> @@ -824,4 +833,37 @@ typedef void (*of_init_fn_1)(struct device_node *);
>  #define OF_DECLARE_2(table, name, compat, fn) \
>  		_OF_DECLARE(table, name, compat, fn, of_init_fn_2)
>  
> +/**
> + * General utilities for working with live trees.
> + *
> + * All functions with two leading underscores operate
> + * without taking node references, so you either have to
> + * own the devtree lock or work on detached trees only.
> + */
> +
> +#ifdef CONFIG_OF
> +
> +struct property *__of_copy_property(const struct property *prop,
> +		gfp_t allocflags, unsigned long propflags);
> +struct device_node *__of_create_empty_node(const char *name,
> +		const char *type, const char *full_name,
> +		phandle phandle, gfp_t allocflags, unsigned long nodeflags);
> +
> +#else /* !CONFIG_OF */
> +
> +static inline struct property *__of_copy_property(const struct property *prop,
> +		gfp_t allocflags, unsigned long propflags)
> +{
> +	return NULL;
> +}
> +
> +static inline struct device_node *__of_create_empty_node(const char *name,
> +		const char *type, const char *full_name,
> +		phandle phandle, gfp_t allocflags, unsigned long nodeflags)
> +{
> +	return NULL;
> +}
> +
> +#endif	/* !CONFIG_OF */
> +
>  #endif /* _LINUX_OF_H */
> 

-- 
Best regards,
Alexander Sverdlin.
