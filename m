Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3KLCiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:38:05 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55571 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3KLChN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:37:13 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 2/3] OF: Introduce DT overlay support.
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
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1383923170-24914-3-git-send-email-panto@antoniou-consulting.com>
References: <1383923170-24914-1-git-send-email-panto@antoniou-consulting.com> <1383923170-24914-3-git-send-email-panto@antoniou-consulting.com>
Date: Mon, 11 Nov 2013 18:42:45 +0000
Message-Id: <20131111184245.D569DC4234A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Nov 2013 17:06:09 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> Introduce DT overlay support.
> Using this functionality it is possible to dynamically overlay a part of
> the kernel's tree with another tree that's been dynamically loaded.
> It is also possible to remove node and properties.
> 
> Note that the I2C client devices are 'special', as in they're not platform
> devices. They need to be registered with an I2C specific method.
> 
> In general I2C is just no good platform device citizen and needs
> special casing.
> 
> PCI is another special case where PCI device insertion and removal
> is implemented in the PCI subsystem.

Actually. I2C isn't special in this regard; SPI, MDIO, PCI, USB are all
in the same boat. platform_device just happens to be able to make a few
assumptions. If anything, platform_device is the 'special' one. :-)

In all cases it must be the underlying subsystem that should be
responsible for creation/removal of devices described in the overlay.
Sometimes that will extend right down into the individual bus device
drivers, but it is better if that can be avoided.

> 
> Bug fixes & PCI support by Guenter Roeck <groeck@juniper.net>
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  Documentation/devicetree/overlay-notes.txt | 179 ++++++
>  drivers/of/Kconfig                         |  10 +
>  drivers/of/Makefile                        |   1 +
>  drivers/of/overlay.c                       | 886 +++++++++++++++++++++++++++++
>  include/linux/of.h                         | 113 ++++
>  5 files changed, 1189 insertions(+)
>  create mode 100644 Documentation/devicetree/overlay-notes.txt
>  create mode 100644 drivers/of/overlay.c
> 
> diff --git a/Documentation/devicetree/overlay-notes.txt b/Documentation/devicetree/overlay-notes.txt
> new file mode 100644
> index 0000000..5289cbb
> --- /dev/null
> +++ b/Documentation/devicetree/overlay-notes.txt
> @@ -0,0 +1,179 @@
> +Device Tree Overlay Notes
> +-------------------------
> +
> +This document describes the implementation of the in-kernel
> +device tree overlay functionality residing in drivers/of/overlay.c and is a
> +companion document to Documentation/devicetree/dt-object-internal.txt[1] &
> +Documentation/devicetree/dynamic-resolution-notes.txt[2]
> +
> +How overlays work
> +-----------------
> +
> +A Device Tree's overlay purpose is to modify the kernel's live tree, and
> +have the modification affecting the state of the the kernel in a way that
> +is reflecting the changes.
> +Since the kernel mainly deals with devices, any new device node that result
> +in an active device should have it created while if the device node is either
> +disabled or removed all together, the affected device should be deregistered.
> +
> +Lets take an example where we have a foo board with the following base tree
> +which is taken from [1].
> +
> +---- foo.dts -----------------------------------------------------------------
> +	/* FOO platform */
> +	/ {
> +		compatible = "corp,foo";
> +
> +		/* shared resources */
> +		res: res {
> +		};
> +
> +		/* On chip peripherals */
> +		ocp: ocp {
> +			/* peripherals that are always instantiated */
> +			peripheral1 { ... };
> +		}
> +	};
> +---- foo.dts -----------------------------------------------------------------
> +
> +The overlay bar.dts, when loaded (and resolved as described in [2]) should
> +
> +---- bar.dts -----------------------------------------------------------------
> +/plugin/;	/* allow undefined label references and record them */
> +/ {
> +	....	/* various properties for loader use; i.e. part id etc. */
> +	fragment@0 {
> +		target = <&ocp>;
> +		__overlay__ {
> +			/* bar peripheral */
> +			bar {
> +				compatible = "corp,bar";
> +				... /* various properties and child nodes */
> +			}
> +		};
> +	};
> +};
> +---- bar.dts -----------------------------------------------------------------
> +
> +result in foo+bar.dts
> +
> +---- foo+bar.dts -------------------------------------------------------------
> +	/* FOO platform + bar peripheral */
> +	/ {
> +		compatible = "corp,foo";
> +
> +		/* shared resources */
> +		res: res {
> +		};
> +
> +		/* On chip peripherals */
> +		ocp: ocp {
> +			/* peripherals that are always instantiated */
> +			peripheral1 { ... };
> +
> +			/* bar peripheral */
> +			bar {
> +				compatible = "corp,bar";
> +				... /* various properties and child nodes */
> +			}
> +		}
> +	};
> +---- foo+bar.dts -------------------------------------------------------------
> +
> +As a result of the the overlay, a new device node (bar) has been created
> +so a bar platform device will be registered and if a matching device driver
> +is loaded the device will be created as expected.
> +
> +Overlay in-kernel API
> +---------------------
> +
> +The steps typically required to get an overlay to work are as follows:
> +
> +1. Use of_build_overlay_info() to create an array of initialized and
> +ready to use of_overlay_info structures.
> +2. Call of_overlay() to apply the overlays declared in the array.
> +3. If the overlay needs to be removed, call of_overlay_revert().
> +4. Finally release the memory taken by the overlay info array by
> +of_free_overlay_info().

Make of_overlay_info a kobject and use a release method to free it when
all users go away. Freeing directly is a dangerous thing to do.

> +
> +/**
> + * of_build_overlay_info	- Build an overlay info array
> + * @tree:	Device node containing all the overlays
> + * @cntp:	Pointer to where the overlay info count will be help
> + * @ovinfop:	Pointer to the pointer of an overlay info structure.
> + *
> + * Helper function that given a tree containing overlay information,
> + * allocates and builds an overlay info array containing it, ready
> + * for use using of_overlay.
> + *
> + * Returns 0 on success with the @cntp @ovinfop pointers valid,
> + * while on error a negative error value is returned.
> + */
> +int of_build_overlay_info(struct device_node *tree,
> +		int *cntp, struct of_overlay_info **ovinfop);
> +
> +/**
> + * of_free_overlay_info	- Free an overlay info array
> + * @count:	Number of of_overlay_info's
> + * @ovinfo_tab:	Array of overlay_info's to free
> + *
> + * Releases the memory of a previously allocate ovinfo array
> + * by of_build_overlay_info.
> + * Returns 0, or an error if the arguments are bogus.
> + */
> +int of_free_overlay_info(int count, struct of_overlay_info *ovinfo_tab);
> +
> +/**
> + * of_overlay	- Apply @count overlays pointed at by @ovinfo_tab
> + * @count:	Number of of_overlay_info's
> + * @ovinfo_tab:	Array of overlay_info's to apply
> + *
> + * Applies the overlays given, while handling all error conditions
> + * appropriately. Either the operation succeeds, or if it fails the
> + * live tree is reverted to the state before the attempt.
> + * Returns 0, or an error if the overlay attempt failed.
> + */
> +int of_overlay(int count, struct of_overlay_info *ovinfo_tab);
> +
> +/**
> + * of_overlay_revert	- Revert a previously applied overlay
> + * @count:	Number of of_overlay_info's
> + * @ovinfo_tab:	Array of overlay_info's to apply
> + *
> + * Revert a previous overlay. The state of the live tree
> + * is reverted to the one before the overlay.
> + * Returns 0, or an error if the overlay table is not given.
> + */
> +int of_overlay_revert(int count, struct of_overlay_info *ovinfo_tab);
> +
> +Overlay DTS Format
> +------------------
> +
> +The DTS of an overlay should have the following format:
> +
> +{
> +	/* ignored properties by the overlay */
> +
> +	fragment@0 {	/* first child node */
> +		target=<phandle>;	/* target of the overlay */
> +		__overlay__ {
> +			property-a;	/* add property-a to the target */
> +			-property-b;	/* remove property-b from target */
> +			node-a {	/* add to an existing, or create a node-a */
> +				...
> +			};
> +			-node-b {	/* remove an existing node-b */
> +				...
> +			};

Are the node & property removals reversable? What about property
modifications? If they are not, then it would be better to not support
removals at all for now. Otherwise we'll end up with overlays that
cannot be removed and I don't want to inadvertently put users into that
situation.

> +		};
> +	}
> +	fragment@1 {	/* second child node */
> +		...
> +	};
> +	/* more fragments follow */
> +}
> +
> +It should be noted that the DT overlay format described is the one expected
> +by the of_build_overlay_info() function, which is a helper function. There
> +is nothing stopping someone coming up with his own DTS format and that will
> +end up filling in the fields of the of_overlay_info array. 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index 2a00ae5..c2d5596 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -83,4 +83,14 @@ config OF_RESOLVE
>  	  Enable OF dynamic resolution support. This allows you to
>  	  load Device Tree object fragments are run time.
>  
> +config OF_OVERLAY
> +	bool "OF overlay support"
> +	depends on OF
> +	select OF_DYNAMIC
> +	select OF_DEVICE
> +	select OF_RESOLVE
> +	help
> +	  OpenFirmware overlay support. Allows you to modify on runtime the
> +	  live tree using overlays.
> +
>  endmenu # OF
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index 93da457..ca466e4 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -10,3 +10,4 @@ obj-$(CONFIG_OF_PCI)	+= of_pci.o
>  obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
>  obj-$(CONFIG_OF_MTD)	+= of_mtd.o
>  obj-$(CONFIG_OF_RESOLVE)  += resolver.o
> +obj-$(CONFIG_OF_OVERLAY) += overlay.o
> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
> new file mode 100644
> index 0000000..7d14881
> --- /dev/null
> +++ b/drivers/of/overlay.c
> @@ -0,0 +1,886 @@
> +/*
> + * Functions for working with device tree overlays
> + *
> + * Copyright (C) 2012 Pantelis Antoniou <panto@antoniou-consulting.com>
> + * Copyright (C) 2012 Texas Instruments Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + */
> +#undef DEBUG
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/i2c.h>
> +#include <linux/string.h>
> +#include <linux/ctype.h>
> +#include <linux/errno.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +
> +/**
> + * Apply a single overlay node recursively.
> + *
> + * Property or node names that start with '-' signal that
> + * the property/node is to be removed.
> + *
> + * All the property notifiers are appropriately called.
> + * Note that the in case of an error the target node is left
> + * in a inconsistent state. Error recovery should be performed
> + * by recording the modification using the of notifiers.
> + */
> +static int of_overlay_apply_one(struct device_node *target,
> +		const struct device_node *overlay)
> +{
> +	const char *pname, *cname;
> +	struct device_node *child, *tchild;
> +	struct property *prop, *propn, *tprop;
> +	int remove;
> +	char *full_name;
> +	const char *suffix;
> +	int ret;
> +
> +	/* sanity checks */
> +	if (target == NULL || overlay == NULL)
> +		return -EINVAL;
> +
> +	for_each_property_of_node(overlay, prop) {
> +
> +		/* don't touch, 'name' */
> +		if (of_prop_cmp(prop->name, "name") == 0)
> +			continue;
> +
> +		/* default is add */
> +		remove = 0;
> +		pname = prop->name;
> +		if (*pname == '-') {	/* skip, - notes removal */
> +			pname++;
> +			remove = 1;
> +			propn = NULL;
> +		} else {
> +			propn = __of_copy_property(prop,
> +					GFP_KERNEL);
> +			if (propn == NULL)
> +				return -ENOMEM;
> +		}
> +
> +		tprop = of_find_property(target, pname, NULL);
> +
> +		/* found? */
> +		if (tprop != NULL) {
> +			if (propn != NULL)
> +				ret = of_update_property(target, propn);
> +			else
> +				ret = of_remove_property(target, tprop);
> +		} else {
> +			if (propn != NULL)
> +				ret = of_add_property(target, propn);
> +			else
> +				ret = 0;
> +		}
> +		if (ret != 0)
> +			return ret;
> +	}
> +
> +	__for_each_child_of_node(overlay, child) {
> +
> +		/* default is add */
> +		remove = 0;
> +		cname = child->name;
> +		if (*cname == '-') {	/* skip, - notes removal */
> +			cname++;
> +			remove = 1;
> +		}
> +
> +		/* special case for nodes with a suffix */
> +		suffix = strrchr(child->full_name, '@');
> +		if (suffix != NULL) {
> +			cname = kbasename(child->full_name);
> +			WARN_ON(cname == NULL);	/* sanity check */
> +			if (cname == NULL)
> +				continue;
> +			if (*cname == '-')
> +				cname++;
> +		}
> +
> +		tchild = of_get_child_by_name(target, cname);
> +		if (tchild != NULL) {
> +
> +			if (!remove) {
> +
> +				/* apply overlay recursively */
> +				ret = of_overlay_apply_one(tchild, child);
> +				of_node_put(tchild);
> +
> +				if (ret != 0)
> +					return ret;
> +
> +			} else {
> +
> +				ret = of_detach_node(tchild);
> +				of_node_put(tchild);
> +			}
> +
> +		} else {
> +
> +			if (!remove) {
> +				full_name = kasprintf(GFP_KERNEL, "%s/%s",
> +						target->full_name, cname);
> +				if (full_name == NULL)
> +					return -ENOMEM;
> +
> +				/* create empty tree as a target */
> +				tchild = __of_create_empty_node(cname,
> +						child->type, full_name,
> +						child->phandle, GFP_KERNEL);
> +
> +				/* free either way */
> +				kfree(full_name);
> +
> +				if (tchild == NULL)
> +					return -ENOMEM;
> +
> +				/* point to parent */
> +				tchild->parent = target;
> +
> +				ret = of_attach_node(tchild);
> +				if (ret != 0)
> +					return ret;
> +
> +				/* apply the overlay */
> +				ret = of_overlay_apply_one(tchild, child);
> +				if (ret != 0) {
> +					__of_free_tree(tchild);
> +					return ret;
> +				}
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * Lookup an overlay device entry
> + */
> +struct of_overlay_device_entry *of_overlay_device_entry_lookup(
> +		struct of_overlay_info *ovinfo, struct device_node *node)
> +{
> +	struct of_overlay_device_entry *de;
> +
> +	/* no need for locks, we'de under the ovinfo->lock */
> +	list_for_each_entry(de, &ovinfo->de_list, node) {
> +		if (de->np == node)
> +			return de;
> +	}
> +	return NULL;
> +}
> +
> +/**
> + * Add an overlay log entry
> + */
> +static int of_overlay_log_entry_entry_add(struct of_overlay_info *ovinfo,
> +		unsigned long action, struct device_node *dn,
> +		struct property *prop)
> +{
> +	struct of_overlay_log_entry *le;
> +
> +	/* check */
> +	if (ovinfo == NULL || dn == NULL)
> +		return -EINVAL;
> +
> +	le = kzalloc(sizeof(*le), GFP_KERNEL);
> +	if (le == NULL) {
> +		pr_err("%s: Failed to allocate\n", __func__);
> +		return -ENOMEM;
> +	}
> +
> +	/* get a reference to the node */
> +	le->action = action;
> +	le->np = of_node_get(dn);
> +	le->prop = prop;
> +
> +	if (action == OF_RECONFIG_UPDATE_PROPERTY && prop)
> +		le->old_prop = of_find_property(dn, prop->name, NULL);
> +
> +	list_add_tail(&le->node, &ovinfo->le_list);
> +
> +	return 0;
> +}
> +
> +/**
> + * Add an overlay device entry
> + */
> +static void of_overlay_device_entry_entry_add(struct of_overlay_info *ovinfo,
> +		struct device_node *node,
> +		struct platform_device *pdev, struct i2c_client *client,
> +		int prevstate, int state)
> +{
> +	struct of_overlay_device_entry *de;
> +	int fresh;
> +
> +	/* check */
> +	if (ovinfo == NULL)
> +		return;
> +
> +	fresh = 0;
> +	de = of_overlay_device_entry_lookup(ovinfo, node);
> +	if (de == NULL) {
> +		de = kzalloc(sizeof(*de), GFP_KERNEL);
> +		if (de == NULL) {
> +			pr_err("%s: Failed to allocate\n", __func__);
> +			return;
> +		}
> +		fresh = 1;
> +		de->prevstate = -1;
> +	}
> +
> +	if (de->np == NULL)
> +		de->np = of_node_get(node);
> +	if (de->pdev == NULL && pdev)
> +		de->pdev = of_dev_get(pdev);
> +	if (de->client == NULL && client)
> +		de->client = i2c_use_client(client);
> +	if (fresh)
> +		de->prevstate = prevstate;
> +	de->state = state;
> +
> +	if (fresh)
> +		list_add_tail(&de->node, &ovinfo->de_list);
> +}
> +
> +/**
> + * Overlay OF notifier
> + *
> + * Called every time there's a property/node modification
> + * Every modification causes a log entry addition, while
> + * any modification that causes a node's state to change
> + * from/to disabled to/from enabled causes a device entry
> + * addition.
> + */
> +static int of_overlay_notify(struct notifier_block *nb,
> +				unsigned long action, void *arg)
> +{
> +	struct of_overlay_info *ovinfo;
> +	struct device_node *node;
> +	struct property *prop, *sprop, *cprop;
> +	struct of_prop_reconfig *pr;
> +	struct platform_device *pdev;
> +	struct i2c_client *client;
> +	struct device_node *tnode;
> +	int depth;
> +	int prevstate, state;
> +	int err = 0;
> +
> +	ovinfo = container_of(nb, struct of_overlay_info, notifier);
> +
> +	/* prep vars */
> +	switch (action) {
> +	case OF_RECONFIG_ATTACH_NODE:
> +	case OF_RECONFIG_DETACH_NODE:
> +		node = arg;
> +		if (node == NULL)
> +			return notifier_from_errno(-EINVAL);
> +		prop = NULL;
> +		break;
> +	case OF_RECONFIG_ADD_PROPERTY:
> +	case OF_RECONFIG_REMOVE_PROPERTY:
> +	case OF_RECONFIG_UPDATE_PROPERTY:
> +		pr = arg;
> +		if (pr == NULL)
> +			return notifier_from_errno(-EINVAL);
> +		node = pr->dn;
> +		if (node == NULL)
> +			return notifier_from_errno(-EINVAL);
> +		prop = pr->prop;
> +		if (prop == NULL)
> +			return notifier_from_errno(-EINVAL);
> +		break;
> +	default:
> +		return notifier_from_errno(0);
> +	}
> +
> +	/* add to the log */
> +	err = of_overlay_log_entry_entry_add(ovinfo, action, node, prop);
> +	if (err != 0)
> +		return notifier_from_errno(err);
> +
> +	/* come up with the device entry (if any) */
> +	pdev = NULL;
> +	client = NULL;
> +	state = 0;
> +	prevstate = 0;
> +
> +	/* determine the state the node will end up */
> +	switch (action) {
> +	case OF_RECONFIG_ATTACH_NODE:
> +		/* we demand that a compatible node is present */
> +		state = of_find_property(node, "compatible", NULL) &&
> +			of_device_is_available(node);
> +		break;
> +	case OF_RECONFIG_DETACH_NODE:
> +		prevstate = of_find_property(node, "compatible", NULL) &&
> +			of_device_is_available(node);
> +		state = 0;
> +		pdev = of_find_device_by_node(node);
> +		client = of_find_i2c_device_by_node(node);
> +		break;
> +	case OF_RECONFIG_ADD_PROPERTY:
> +	case OF_RECONFIG_REMOVE_PROPERTY:
> +	case OF_RECONFIG_UPDATE_PROPERTY:
> +		/* either one cause a change in state */
> +		if (strcmp(prop->name, "status") != 0 &&
> +				strcmp(prop->name, "compatible") != 0)
> +			return notifier_from_errno(0);
> +
> +		if (strcmp(prop->name, "status") == 0) {
> +			/* status */
> +			cprop = of_find_property(node, "compatible", NULL);
> +			sprop = action != OF_RECONFIG_REMOVE_PROPERTY ?
> +				prop : NULL;
> +		} else {
> +			/* compatible */
> +			sprop = of_find_property(node, "status", NULL);
> +			cprop = action != OF_RECONFIG_REMOVE_PROPERTY ?
> +				prop : NULL;
> +		}
> +
> +		prevstate = of_find_property(node, "compatible", NULL) &&
> +			of_device_is_available(node);
> +		state = cprop && cprop->length > 0 &&
> +			    (!sprop || (sprop->length > 0 &&
> +				(strcmp(sprop->value, "okay") == 0 ||
> +				 strcmp(sprop->value, "ok") == 0)));
> +		break;
> +
> +	default:
> +		return notifier_from_errno(0);
> +	}
> +
> +	/* find depth */
> +	depth = 1;
> +	tnode = node;
> +	while (tnode != NULL && tnode != ovinfo->target) {
> +		tnode = tnode->parent;
> +		depth++;
> +	}
> +
> +	/* respect overlay's maximum depth */
> +	if (ovinfo->device_depth != 0 && depth > ovinfo->device_depth) {
> +		pr_debug("OF: skipping device creation for node=%s depth=%d\n",
> +				node->name, depth);
> +		goto out;
> +	}
> +
> +	if (state == 0) {
> +		pdev = of_find_device_by_node(node);
> +		client = of_find_i2c_device_by_node(node);
> +	}
> +
> +	of_overlay_device_entry_entry_add(ovinfo, node, pdev, client,
> +			prevstate, state);
> +out:
> +
> +	return notifier_from_errno(err);
> +}
> +
> +/**
> + * Prepare for the overlay, for now it just registers the
> + * notifier.
> + */
> +static int of_overlay_prep_one(struct of_overlay_info *ovinfo)
> +{
> +	int err;
> +
> +	err = of_reconfig_notifier_register(&ovinfo->notifier);
> +	if (err != 0) {
> +		pr_err("%s: failed to register notifier for '%s'\n",
> +			__func__, ovinfo->target->full_name);
> +		return err;
> +	}
> +	return 0;
> +}
> +
> +static int of_overlay_device_entry_change(struct of_overlay_info *ovinfo,
> +		struct of_overlay_device_entry *de, int revert)
> +{

I've got big problems here. This is entirely the wrong place to create
and delete devices. Each subsystem needs to create and remove its own
device types. To begin with, only the subsystem knows which busses are
appropriate for creating child devices.

Second, it is incorrect to create a platform_device for every single
node by default. Some nodes aren't devices at all. Just looking for a
compatible property isn't sufficient either.

The solution here is for each subsystem to have it's own notifier, and
only create a child device if the changed node has a parent the
subsystem already knows about (because it's already populated device
tree devices from that parent). This is also true for platform_devices.

Finally, sometimes the tips of the tree will get populated, but not
until after some parent nodes have been delt with. In that case the
creation of devices needs to be deferred back to the driver for the
parent bus.

> +
> +/**
> + * Revert one overlay
> + * Either due to an error, or due to normal overlay removal.
> + * Using the log entries, we revert any change to the live tree.
> + * In the same manner, using the device entries we enable/disable
> + * the platform devices appropriately.
> + */
> +static void of_overlay_revert_one(struct of_overlay_info *ovinfo)
> +{
> +	struct of_overlay_device_entry *de, *den;
> +	struct of_overlay_log_entry *le, *len;
> +	struct property *prop, **propp;
> +	int ret;
> +	unsigned long flags;
> +
> +	if (!ovinfo || !ovinfo->target || !ovinfo->overlay)
> +		return;
> +
> +	pr_debug("%s: Reverting overlay on '%s'\n", __func__,
> +			ovinfo->target->full_name);
> +
> +	/* overlay applied correctly, now create/destroy pdevs */
> +	list_for_each_entry_safe_reverse(de, den, &ovinfo->de_list, node) {
> +		of_overlay_device_entry_change(ovinfo, de, 1);
> +		of_node_put(de->np);
> +		list_del(&de->node);
> +		kfree(de);
> +	}

Can overlays interact in bad ways? If overlay 1 is installed before
overlay 2, what happens if overlay 1 is removed?

Okay, my brain is tired. It's a complicated series and I don't see any
obvious bits that can be split off and be independently useful. I would
*really* like to see some test cases for this functionality. It's
complicated enough to make me quite nervous.... in fact I would really
like to see drivers/of/selftest.c become an early user of overlays. That
would make the DT selftests executable on any platform.

g.

