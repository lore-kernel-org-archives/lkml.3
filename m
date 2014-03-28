Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaC1O5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 10:57:32 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:53392 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbaC1O53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 10:57:29 -0400
MIME-Version: 1.0
In-Reply-To: <1395179766-31575-3-git-send-email-pantelis.antoniou@konsulko.com>
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1395179766-31575-3-git-send-email-pantelis.antoniou@konsulko.com>
Date: Fri, 28 Mar 2014 09:51:10 -0500
Message-ID: <CANk1AXTdZhHhyRDOZfbMm-1REx=PE-Z4Mgn1v+9WLw_tOzqGog@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] OF: Introduce DT overlay support.
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 4:56 PM, Pantelis Antoniou
<pantelis.antoniou@konsulko.com> wrote:
> Introduce DT overlay support.
> Using this functionality it is possible to dynamically overlay a part of
> the kernel's tree with another tree that's been dynamically loaded.
> It is also possible to remove node and properties.
>
> The creation/destruction of the devices is handled by calling in to
> bus specific handlers which can deal with the peculiarities of each
> device.
>
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> ---
>  Documentation/devicetree/overlay-notes.txt | 187 ++++++
>  drivers/of/Kconfig                         |  10 +
>  drivers/of/Makefile                        |   1 +
>  drivers/of/overlay.c                       | 895 +++++++++++++++++++++++++++++
>  include/linux/of.h                         | 153 +++++
>  5 files changed, 1246 insertions(+)
>  create mode 100644 Documentation/devicetree/overlay-notes.txt
>  create mode 100644 drivers/of/overlay.c
>
> diff --git a/Documentation/devicetree/overlay-notes.txt b/Documentation/devicetree/overlay-notes.txt
> new file mode 100644
> index 0000000..882d512
> --- /dev/null
> +++ b/Documentation/devicetree/overlay-notes.txt
> @@ -0,0 +1,187 @@
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
> +       /* FOO platform */
> +       / {
> +               compatible = "corp,foo";
> +
> +               /* shared resources */
> +               res: res {
> +               };
> +
> +               /* On chip peripherals */
> +               ocp: ocp {
> +                       /* peripherals that are always instantiated */
> +                       peripheral1 { ... };
> +               }
> +       };
> +---- foo.dts -----------------------------------------------------------------
> +
> +The overlay bar.dts, when loaded (and resolved as described in [2]) should
> +
> +---- bar.dts -----------------------------------------------------------------
> +/plugin/;      /* allow undefined label references and record them */
> +/ {
> +       ....    /* various properties for loader use; i.e. part id etc. */
> +       fragment@0 {
> +               target = <&ocp>;
> +               __overlay__ {
> +                       /* bar peripheral */
> +                       bar {
> +                               compatible = "corp,bar";
> +                               ... /* various properties and child nodes */
> +                       }
> +               };
> +       };
> +};
> +---- bar.dts -----------------------------------------------------------------
> +
> +result in foo+bar.dts
> +
> +---- foo+bar.dts -------------------------------------------------------------
> +       /* FOO platform + bar peripheral */
> +       / {
> +               compatible = "corp,foo";
> +
> +               /* shared resources */
> +               res: res {
> +               };
> +
> +               /* On chip peripherals */
> +               ocp: ocp {
> +                       /* peripherals that are always instantiated */
> +                       peripheral1 { ... };
> +
> +                       /* bar peripheral */
> +                       bar {
> +                               compatible = "corp,bar";
> +                               ... /* various properties and child nodes */
> +                       }
> +               }
> +       };
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
> +
> +/**
> + * of_build_overlay_info       - Build an overlay info array
> + * @tree:      Device node containing all the overlays
> + * @cntp:      Pointer to where the overlay info count will be help
> + * @ovinfop:   Pointer to the pointer of an overlay info structure.
> + *
> + * Helper function that given a tree containing overlay information,
> + * allocates and builds an overlay info array containing it, ready
> + * for use using of_overlay.
> + *
> + * Returns 0 on success with the @cntp @ovinfop pointers valid,
> + * while on error a negative error value is returned.
> + */
> +int of_build_overlay_info(struct device_node *tree,
> +               int *cntp, struct of_overlay_info **ovinfop);
> +
> +/**
> + * of_free_overlay_info        - Free an overlay info array
> + * @count:     Number of of_overlay_info's
> + * @ovinfo_tab:        Array of overlay_info's to free
> + *
> + * Releases the memory of a previously allocate ovinfo array
> + * by of_build_overlay_info.
> + * Returns 0, or an error if the arguments are bogus.
> + */
> +int of_free_overlay_info(int count, struct of_overlay_info *ovinfo_tab);
> +
> +/**
> + * of_overlay  - Apply @count overlays pointed at by @ovinfo_tab
> + * @count:     Number of of_overlay_info's
> + * @ovinfo_tab:        Array of overlay_info's to apply
> + *
> + * Applies the overlays given, while handling all error conditions
> + * appropriately. Either the operation succeeds, or if it fails the
> + * live tree is reverted to the state before the attempt.
> + * Returns 0, or an error if the overlay attempt failed.
> + */
> +int of_overlay(int count, struct of_overlay_info *ovinfo_tab);
> +
> +/**
> + * of_overlay_revert   - Revert a previously applied overlay
> + * @count:     Number of of_overlay_info's
> + * @ovinfo_tab:        Array of overlay_info's to apply
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
> +       /* ignored properties by the overlay */
> +
> +       fragment@0 {    /* first child node */
> +
> +               target=<phandle>;       /* phandle target of the overlay */
> +       or
> +               target-path="/path";    /* target path of the overlay */
> +       or
> +               target-alias="alias";   /* target alias of the overlay */
> +               __overlay__ {
> +                       property-a;     /* add property-a to the target */
> +                       -property-b;    /* remove property-b from target */
> +                       node-a {        /* add to an existing, or create a node-a */
> +                               ...
> +                       };
> +                       -node-b {       /* remove an existing node-b */
> +                               ...
> +                       };
> +               };
> +       }
> +       fragment@1 {    /* second child node */
> +               ...
> +       };
> +       /* more fragments follow */
> +}
> +
> +It should be noted that the DT overlay format described is the one expected
> +by the of_build_overlay_info() function, which is a helper function. There
> +is nothing stopping someone coming up with his own DTS format and that will
> +end up filling in the fields of the of_overlay_info array.
> +
> +Using the non-phandle based target method allows one to use a base DT which does
> +not contain a __symbols__ now, i.e. it was not compiled with the -@ option.
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index 33a8fef..7517be2 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -86,4 +86,14 @@ config OF_RESOLVE
>           Enable OF dynamic resolution support. This allows you to
>           load Device Tree object fragments are run time.
>
> +config OF_OVERLAY
> +       bool "OF overlay support"
> +       depends on OF
> +       select OF_DYNAMIC
> +       select OF_DEVICE
> +       select OF_RESOLVE
> +       help
> +         OpenFirmware overlay support. Allows you to modify on runtime the
> +         live tree using overlays.
> +
>  endmenu # OF
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index c241e79..d2a6e0d 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -11,3 +11,4 @@ obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
>  obj-$(CONFIG_OF_MTD)   += of_mtd.o
>  obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
>  obj-$(CONFIG_OF_RESOLVE)  += resolver.o
> +obj-$(CONFIG_OF_OVERLAY) += overlay.o
> diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
> new file mode 100644
> index 0000000..2179b9f
> --- /dev/null
> +++ b/drivers/of/overlay.c
> @@ -0,0 +1,895 @@
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
> +#include <linux/string.h>
> +#include <linux/ctype.h>
> +#include <linux/errno.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +
> +/* protect the handlers list */
> +static DEFINE_MUTEX(of_handler_mutex);
> +static struct list_head of_handler_list = LIST_HEAD_INIT(of_handler_list);
> +
> +int of_overlay_handler_register(struct of_overlay_handler *handler)
> +{
> +       /* guard against bad data */
> +       if (!handler || !handler->name || !handler->ops ||
> +               !handler->ops->create || !handler->ops->remove)
> +               return -EINVAL;
> +
> +       mutex_lock(&of_handler_mutex);
> +       list_add_tail(&handler->list, &of_handler_list);
> +       mutex_unlock(&of_handler_mutex);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_overlay_handler_register);
> +
> +void of_overlay_handler_unregister(struct of_overlay_handler *handler)
> +{
> +       struct of_overlay_handler *curr;
> +
> +       mutex_lock(&of_handler_mutex);
> +       list_for_each_entry(curr, &of_handler_list, list) {
> +               if (handler == curr) {
> +                       list_del(&handler->list);
> +                       break;
> +               }
> +       }
> +       mutex_unlock(&of_handler_mutex);
> +}
> +EXPORT_SYMBOL_GPL(of_overlay_handler_unregister);
> +
> +static int handler_create(struct of_overlay_device_entry *entry, int revert)
> +{
> +       struct of_overlay_handler *handler;
> +       int ret;
> +
> +       mutex_lock(&of_handler_mutex);
> +       list_for_each_entry(handler, &of_handler_list, list) {
> +               ret = (*handler->ops->create)(entry, revert);
> +               /* ENOTSUPP means try next */
> +               if (ret == -ENOTSUPP)
> +                       continue;
> +               /* anything else means something happened */
> +               break;
> +       }
> +       mutex_unlock(&of_handler_mutex);
> +
> +       return ret;
> +}
> +
> +static int handler_remove(struct of_overlay_device_entry *entry, int revert)
> +{
> +       struct of_overlay_handler *handler;
> +       int ret;
> +
> +       mutex_lock(&of_handler_mutex);
> +       list_for_each_entry(handler, &of_handler_list, list) {
> +               ret = (*handler->ops->remove)(entry, revert);
> +               /* ENOTSUPP means try next */
> +               if (ret == -ENOTSUPP)
> +                       continue;
> +               /* anything else means something happened */
> +               break;
> +       }
> +       mutex_unlock(&of_handler_mutex);
> +
> +       return ret;
> +}
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
> +               const struct device_node *overlay)
> +{
> +       const char *pname, *cname;
> +       struct device_node *child, *tchild;
> +       struct property *prop, *propn, *tprop;
> +       int remove;
> +       char *full_name;
> +       const char *suffix;
> +       int ret;
> +
> +       /* sanity checks */
> +       if (target == NULL || overlay == NULL)
> +               return -EINVAL;
> +
> +       for_each_property_of_node(overlay, prop) {
> +
> +               /* don't touch, 'name' */
> +               if (of_prop_cmp(prop->name, "name") == 0)
> +                       continue;
> +
> +               /* default is add */
> +               remove = 0;
> +               pname = prop->name;
> +               if (*pname == '-') {    /* skip, - notes removal */
> +                       pname++;
> +                       remove = 1;
> +                       propn = NULL;
> +               } else {
> +                       propn = __of_copy_property(prop, GFP_KERNEL,
> +                                       OF_PROP_ALLOCALL);
> +                       if (propn == NULL)
> +                               return -ENOMEM;
> +               }
> +
> +               tprop = of_find_property(target, pname, NULL);
> +
> +               /* found? */
> +               if (tprop != NULL) {
> +                       if (propn != NULL)
> +                               ret = of_update_property(target, propn);
> +                       else
> +                               ret = of_remove_property(target, tprop);
> +               } else {
> +                       if (propn != NULL)
> +                               ret = of_add_property(target, propn);
> +                       else
> +                               ret = 0;
> +               }
> +               if (ret != 0)
> +                       return ret;
> +       }
> +
> +       __for_each_child_of_node(overlay, child) {
> +
> +               /* default is add */
> +               remove = 0;
> +               cname = child->name;
> +               if (*cname == '-') {    /* skip, - notes removal */
> +                       cname++;
> +                       remove = 1;
> +               }
> +
> +               /* special case for nodes with a suffix */
> +               suffix = strrchr(child->full_name, '@');
> +               if (suffix != NULL) {
> +                       cname = kbasename(child->full_name);
> +                       WARN_ON(cname == NULL); /* sanity check */
> +                       if (cname == NULL)
> +                               continue;
> +                       if (*cname == '-')
> +                               cname++;
> +               }
> +
> +               tchild = of_get_child_by_name(target, cname);
> +               if (tchild != NULL) {
> +
> +                       if (!remove) {
> +
> +                               /* apply overlay recursively */
> +                               ret = of_overlay_apply_one(tchild, child);
> +                               of_node_put(tchild);
> +
> +                               if (ret != 0)
> +                                       return ret;
> +
> +                       } else {
> +
> +                               ret = of_detach_node(tchild);
> +                               of_node_put(tchild);
> +                       }
> +
> +               } else {
> +
> +                       if (!remove) {
> +                               full_name = kasprintf(GFP_KERNEL, "%s/%s",
> +                                               target->full_name, cname);
> +                               if (full_name == NULL)
> +                                       return -ENOMEM;
> +
> +                               /* create empty tree as a target */
> +                               tchild = __of_create_empty_node(cname,
> +                                               child->type, full_name,
> +                                               child->phandle, GFP_KERNEL,
> +                                               OF_NODE_ALLOCALL);
> +
> +                               /* free either way */
> +                               kfree(full_name);
> +
> +                               if (tchild == NULL)
> +                                       return -ENOMEM;
> +
> +                               /* point to parent */
> +                               tchild->parent = target;
> +
> +                               ret = of_attach_node(tchild);
> +                               if (ret != 0)
> +                                       return ret;
> +
> +                               /* apply the overlay */
> +                               ret = of_overlay_apply_one(tchild, child);
> +                               if (ret != 0) {
> +                                       __of_free_tree(tchild);
> +                                       return ret;
> +                               }
> +                       }
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * Lookup an overlay device entry
> + */
> +struct of_overlay_device_entry *of_overlay_device_entry_lookup(
> +               struct of_overlay_info *ovinfo, struct device_node *node)
> +{
> +       struct of_overlay_device_entry *de;
> +
> +       /* no need for locks, we'de under the ovinfo->lock */
> +       list_for_each_entry(de, &ovinfo->de_list, node) {
> +               if (de->np == node)
> +                       return de;
> +       }
> +       return NULL;
> +}
> +
> +/**
> + * Add an overlay log entry
> + */
> +static int of_overlay_log_entry_entry_add(struct of_overlay_info *ovinfo,
> +               unsigned long action, struct device_node *dn,
> +               struct property *prop)
> +{
> +       struct of_overlay_log_entry *le;
> +
> +       /* check */
> +       if (ovinfo == NULL || dn == NULL)
> +               return -EINVAL;
> +
> +       le = kzalloc(sizeof(*le), GFP_KERNEL);
> +       if (le == NULL) {
> +               pr_err("%s: Failed to allocate\n", __func__);
> +               return -ENOMEM;
> +       }
> +
> +       /* get a reference to the node */
> +       le->action = action;
> +       le->np = of_node_get(dn);
> +       le->prop = prop;
> +
> +       if (action == OF_RECONFIG_UPDATE_PROPERTY && prop)
> +               le->old_prop = of_find_property(dn, prop->name, NULL);
> +
> +       list_add_tail(&le->node, &ovinfo->le_list);
> +
> +       return 0;
> +}
> +
> +/**
> + * Add an overlay device entry
> + */
> +static void of_overlay_device_entry_entry_add(struct of_overlay_info *ovinfo,
> +               struct device_node *node,
> +               int prevstate, int state)
> +{
> +       struct of_overlay_device_entry *de;
> +       int fresh;
> +
> +       /* check */
> +       if (ovinfo == NULL)
> +               return;
> +
> +       fresh = 0;
> +       de = of_overlay_device_entry_lookup(ovinfo, node);
> +       if (de == NULL) {
> +               de = kzalloc(sizeof(*de), GFP_KERNEL);
> +               if (de == NULL) {
> +                       pr_err("%s: Failed to allocate\n", __func__);
> +                       return;
> +               }
> +               fresh = 1;
> +               de->prevstate = -1;
> +       }
> +
> +       if (de->np == NULL)
> +               de->np = of_node_get(node);
> +       if (fresh)
> +               de->prevstate = prevstate;
> +       de->state = state;
> +
> +       if (fresh)
> +               list_add_tail(&de->node, &ovinfo->de_list);
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
> +                               unsigned long action, void *arg)
> +{
> +       struct of_overlay_info *ovinfo;
> +       struct device_node *node;
> +       struct property *prop, *sprop, *cprop;
> +       struct of_prop_reconfig *pr;
> +       struct device_node *tnode;
> +       int depth;
> +       int prevstate, state;
> +       int err = 0;
> +
> +       ovinfo = container_of(nb, struct of_overlay_info, notifier);
> +
> +       /* prep vars */
> +       switch (action) {
> +       case OF_RECONFIG_ATTACH_NODE:
> +       case OF_RECONFIG_DETACH_NODE:
> +               node = arg;
> +               if (node == NULL)
> +                       return notifier_from_errno(-EINVAL);
> +               prop = NULL;
> +               break;
> +       case OF_RECONFIG_ADD_PROPERTY:
> +       case OF_RECONFIG_REMOVE_PROPERTY:
> +       case OF_RECONFIG_UPDATE_PROPERTY:
> +               pr = arg;
> +               if (pr == NULL)
> +                       return notifier_from_errno(-EINVAL);
> +               node = pr->dn;
> +               if (node == NULL)
> +                       return notifier_from_errno(-EINVAL);
> +               prop = pr->prop;
> +               if (prop == NULL)
> +                       return notifier_from_errno(-EINVAL);
> +               break;
> +       default:
> +               return notifier_from_errno(0);
> +       }
> +
> +       /* add to the log */
> +       err = of_overlay_log_entry_entry_add(ovinfo, action, node, prop);
> +       if (err != 0)
> +               return notifier_from_errno(err);
> +
> +       /* come up with the device entry (if any) */
> +       state = 0;
> +       prevstate = 0;
> +
> +       /* determine the state the node will end up */
> +       switch (action) {
> +       case OF_RECONFIG_ATTACH_NODE:
> +               /* we demand that a compatible node is present */
> +               state = of_find_property(node, "compatible", NULL) &&
> +                       of_device_is_available(node);
> +               break;
> +       case OF_RECONFIG_DETACH_NODE:
> +               prevstate = of_find_property(node, "compatible", NULL) &&
> +                       of_device_is_available(node);
> +               state = 0;
> +               break;
> +       case OF_RECONFIG_ADD_PROPERTY:
> +       case OF_RECONFIG_REMOVE_PROPERTY:
> +       case OF_RECONFIG_UPDATE_PROPERTY:
> +               /* either one cause a change in state */
> +               if (strcmp(prop->name, "status") != 0 &&
> +                               strcmp(prop->name, "compatible") != 0)
> +                       return notifier_from_errno(0);
> +
> +               if (strcmp(prop->name, "status") == 0) {
> +                       /* status */
> +                       cprop = of_find_property(node, "compatible", NULL);
> +                       sprop = action != OF_RECONFIG_REMOVE_PROPERTY ?
> +                               prop : NULL;
> +               } else {
> +                       /* compatible */
> +                       sprop = of_find_property(node, "status", NULL);
> +                       cprop = action != OF_RECONFIG_REMOVE_PROPERTY ?
> +                               prop : NULL;
> +               }
> +
> +               prevstate = of_find_property(node, "compatible", NULL) &&
> +                       of_device_is_available(node);
> +               state = cprop && cprop->length > 0 &&
> +                           (!sprop || (sprop->length > 0 &&
> +                               (strcmp(sprop->value, "okay") == 0 ||
> +                                strcmp(sprop->value, "ok") == 0)));
> +               break;
> +
> +       default:
> +               return notifier_from_errno(0);
> +       }
> +
> +       /* find depth */
> +       depth = 1;
> +       tnode = node;
> +       while (tnode != NULL && tnode != ovinfo->target) {
> +               tnode = tnode->parent;
> +               depth++;
> +       }
> +
> +       /* respect overlay's maximum depth */
> +       if (ovinfo->device_depth != 0 && depth > ovinfo->device_depth) {
> +               pr_debug("OF: skipping device creation for node=%s depth=%d\n",
> +                               node->name, depth);
> +               goto out;
> +       }
> +
> +       of_overlay_device_entry_entry_add(ovinfo, node, prevstate, state);
> +out:
> +
> +       return notifier_from_errno(err);
> +}
> +
> +/**
> + * Prepare for the overlay, for now it just registers the
> + * notifier.
> + */
> +static int of_overlay_prep_one(struct of_overlay_info *ovinfo)
> +{
> +       int err;
> +
> +       err = of_reconfig_notifier_register(&ovinfo->notifier);
> +       if (err != 0) {
> +               pr_err("%s: failed to register notifier for '%s'\n",
> +                       __func__, ovinfo->target->full_name);
> +               return err;
> +       }
> +       return 0;
> +}
> +
> +static int of_overlay_device_entry_change(struct of_overlay_info *ovinfo,
> +               struct of_overlay_device_entry *de, int revert)
> +{
> +       int state;
> +       int ret;
> +
> +       state = !!de->state ^ !!revert;
> +
> +       if (state)
> +               ret = handler_create(de, revert);
> +       else
> +               ret = handler_remove(de, revert);
> +
> +       if (ret != 0 && ret != -ENOTSUPP)

Build warning about ret might not be initialized.

Alan Tull

> +               pr_warn("%s: Failed to %s device "
> +                               "for node '%s'\n", __func__,
> +                               state ? "create" : "remove",
> +                               de->np->full_name);
> +       return 0;
> +}
