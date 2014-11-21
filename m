Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbaKUBfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:35:38 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42104 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652AbaKUBfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:35:33 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 5/8] of/overlay: Introduce DT overlay support
Date: Fri, 21 Nov 2014 01:35:12 +0000
Message-Id: <1416533715-9758-6-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
References: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

Overlays are a method to dynamically modify part of the kernel's
device tree with dynamically loaded data. Add the core functionality to
parse, apply and remove an overlay changeset. The core functionality
takes care of managing the overlay data format and performing the add
and remove. Drivers are expected to use the overlay functionality to
support custom expansion busses commonly found on consumer development
boards like the BeagleBone or Raspberry Pi.

The overlay code uses CONFIG_OF_DYNAMIC changesets to perform the low
level work of modifying the devicetree.

Documentation about internal and APIs is provided in
	Documentation/devicetree/overlay-notes.txt

v2:
- Switch from __of_node_alloc() to __of_node_dup()
- Documentation fixups
- Remove 2-pass processing of properties
- Remove separate ov_lock; just use the DT mutex.
v1:
- Drop delete capability using '-' prefix. The '-' prefixed names
are valid properties and nodes and there is no need for it just yet.
- Do not update special properties - name & phandle ones.
- Change order of node attachment, so that the special property update
works.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 Documentation/devicetree/overlay-notes.txt | 133 +++++++
 drivers/of/Kconfig                         |   7 +
 drivers/of/Makefile                        |   1 +
 drivers/of/overlay.c                       | 562 +++++++++++++++++++++++++++++
 include/linux/of.h                         |  31 ++
 5 files changed, 734 insertions(+)
 create mode 100644 Documentation/devicetree/overlay-notes.txt
 create mode 100644 drivers/of/overlay.c

diff --git a/Documentation/devicetree/overlay-notes.txt b/Documentation/devicetree/overlay-notes.txt
new file mode 100644
index 000000000000..30ae758e3eef
--- /dev/null
+++ b/Documentation/devicetree/overlay-notes.txt
@@ -0,0 +1,133 @@
+Device Tree Overlay Notes
+-------------------------
+
+This document describes the implementation of the in-kernel
+device tree overlay functionality residing in drivers/of/overlay.c and is a
+companion document to Documentation/devicetree/dt-object-internal.txt[1] &
+Documentation/devicetree/dynamic-resolution-notes.txt[2]
+
+How overlays work
+-----------------
+
+A Device Tree's overlay purpose is to modify the kernel's live tree, and
+have the modification affecting the state of the the kernel in a way that
+is reflecting the changes.
+Since the kernel mainly deals with devices, any new device node that result
+in an active device should have it created while if the device node is either
+disabled or removed all together, the affected device should be deregistered.
+
+Lets take an example where we have a foo board with the following base tree
+which is taken from [1].
+
+---- foo.dts -----------------------------------------------------------------
+	/* FOO platform */
+	/ {
+		compatible = "corp,foo";
+
+		/* shared resources */
+		res: res {
+		};
+
+		/* On chip peripherals */
+		ocp: ocp {
+			/* peripherals that are always instantiated */
+			peripheral1 { ... };
+		}
+	};
+---- foo.dts -----------------------------------------------------------------
+
+The overlay bar.dts, when loaded (and resolved as described in [2]) should
+
+---- bar.dts -----------------------------------------------------------------
+/plugin/;	/* allow undefined label references and record them */
+/ {
+	....	/* various properties for loader use; i.e. part id etc. */
+	fragment@0 {
+		target = <&ocp>;
+		__overlay__ {
+			/* bar peripheral */
+			bar {
+				compatible = "corp,bar";
+				... /* various properties and child nodes */
+			}
+		};
+	};
+};
+---- bar.dts -----------------------------------------------------------------
+
+result in foo+bar.dts
+
+---- foo+bar.dts -------------------------------------------------------------
+	/* FOO platform + bar peripheral */
+	/ {
+		compatible = "corp,foo";
+
+		/* shared resources */
+		res: res {
+		};
+
+		/* On chip peripherals */
+		ocp: ocp {
+			/* peripherals that are always instantiated */
+			peripheral1 { ... };
+
+			/* bar peripheral */
+			bar {
+				compatible = "corp,bar";
+				... /* various properties and child nodes */
+			}
+		}
+	};
+---- foo+bar.dts -------------------------------------------------------------
+
+As a result of the the overlay, a new device node (bar) has been created
+so a bar platform device will be registered and if a matching device driver
+is loaded the device will be created as expected.
+
+Overlay in-kernel API
+--------------------------------
+
+The API is quite easy to use.
+
+1. Call of_overlay_create() to create and apply an overlay. The return value
+is a cookie identifying this overlay.
+
+2. Call of_overlay_destroy() to remove and cleanup the overlay previously
+created via the call to of_overlay_create(). Removal of an overlay that
+is stacked by another will not be permitted.
+
+Finally, if you need to remove all overlays in one-go, just call
+of_overlay_destroy_all() which will remove every single one in the correct
+order.
+
+Overlay DTS Format
+------------------
+
+The DTS of an overlay should have the following format:
+
+{
+	/* ignored properties by the overlay */
+
+	fragment@0 {	/* first child node */
+
+		target=<phandle>;	/* phandle target of the overlay */
+	or
+		target-path="/path";	/* target path of the overlay */
+
+		__overlay__ {
+			property-a;	/* add property-a to the target */
+			node-a {	/* add to an existing, or create a node-a */
+				...
+			};
+		};
+	}
+	fragment@1 {	/* second child node */
+		...
+	};
+	/* more fragments follow */
+}
+
+Using the non-phandle based target method allows one to use a base DT which does
+not contain a __symbols__ node, i.e. it was not compiled with the -@ option.
+The __symbols__ node is only required for the target=<phandle> method, since it
+contains the information required to map from a phandle to a tree location.
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index fbe8f8d418f7..18b2e2539f84 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -84,4 +84,11 @@ config OF_RESERVED_MEM
 config OF_RESOLVE
 	bool
 
+config OF_OVERLAY
+	bool
+	depends on OF
+	select OF_DYNAMIC
+	select OF_DEVICE
+	select OF_RESOLVE
+
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index d90553fcd37f..7563f36c71db 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
 obj-$(CONFIG_OF_RESOLVE)  += resolver.o
+obj-$(CONFIG_OF_OVERLAY) += overlay.o
 
 CFLAGS_fdt.o = -I$(src)/../../scripts/dtc/libfdt
 CFLAGS_fdt_address.o = -I$(src)/../../scripts/dtc/libfdt
diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
new file mode 100644
index 000000000000..ea63fbd228ed
--- /dev/null
+++ b/drivers/of/overlay.c
@@ -0,0 +1,562 @@
+/*
+ * Functions for working with device tree overlays
+ *
+ * Copyright (C) 2012 Pantelis Antoniou <panto@antoniou-consulting.com>
+ * Copyright (C) 2012 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+#undef DEBUG
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+
+#include "of_private.h"
+
+/**
+ * struct of_overlay_info - Holds a single overlay info
+ * @target:	target of the overlay operation
+ * @overlay:	pointer to the overlay contents node
+ *
+ * Holds a single overlay state, including all the overlay logs &
+ * records.
+ */
+struct of_overlay_info {
+	struct device_node *target;
+	struct device_node *overlay;
+};
+
+/**
+ * struct of_overlay - Holds a complete overlay transaction
+ * @node:	List on which we are located
+ * @count:	Count of ovinfo structures
+ * @ovinfo_tab:	Overlay info table (count sized)
+ * @cset:	Changeset to be used
+ *
+ * Holds a complete overlay transaction
+ */
+struct of_overlay {
+	int id;
+	struct list_head node;
+	int count;
+	struct of_overlay_info *ovinfo_tab;
+	struct of_changeset cset;
+};
+
+static int of_overlay_apply_one(struct of_overlay *ov,
+		struct device_node *target, const struct device_node *overlay);
+
+static int of_overlay_apply_single_property(struct of_overlay *ov,
+		struct device_node *target, struct property *prop)
+{
+	struct property *propn, *tprop;
+
+	/* NOTE: Multiple changes of single properties not supported */
+	tprop = of_find_property(target, prop->name, NULL);
+
+	/* special properties are not meant to be updated (silent NOP) */
+	if (of_prop_cmp(prop->name, "name") == 0 ||
+	    of_prop_cmp(prop->name, "phandle") == 0 ||
+	    of_prop_cmp(prop->name, "linux,phandle") == 0)
+		return 0;
+
+	propn = __of_prop_dup(prop, GFP_KERNEL);
+	if (propn == NULL)
+		return -ENOMEM;
+
+	/* not found? add */
+	if (tprop == NULL)
+		return of_changeset_add_property(&ov->cset, target, propn);
+
+	/* found? update */
+	return of_changeset_update_property(&ov->cset, target, propn);
+}
+
+static int of_overlay_apply_single_device_node(struct of_overlay *ov,
+		struct device_node *target, struct device_node *child)
+{
+	const char *cname;
+	struct device_node *tchild, *grandchild;
+	int ret = 0;
+
+	cname = kbasename(child->full_name);
+	if (cname == NULL)
+		return -ENOMEM;
+
+	/* NOTE: Multiple mods of created nodes not supported */
+	tchild = of_get_child_by_name(target, cname);
+	if (tchild != NULL) {
+		/* apply overlay recursively */
+		ret = of_overlay_apply_one(ov, tchild, child);
+		of_node_put(tchild);
+	} else {
+		/* create empty tree as a target */
+		tchild = __of_node_dup(child, "%s/%s", target->full_name, cname);
+		if (!tchild)
+			return -ENOMEM;
+
+		/* point to parent */
+		tchild->parent = target;
+
+		ret = of_changeset_attach_node(&ov->cset, tchild);
+		if (ret)
+			return ret;
+
+		ret = of_overlay_apply_one(ov, tchild, child);
+		if (ret)
+			return ret;
+
+		/* The properties are already copied, now do the child nodes */
+		for_each_child_of_node(child, grandchild) {
+			ret = of_overlay_apply_single_device_node(ov, tchild, grandchild);
+			if (ret) {
+				pr_err("%s: Failed to apply single node @%s/%s\n",
+					__func__, tchild->full_name,
+					grandchild->name);
+				return ret;
+			}
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * Apply a single overlay node recursively.
+ *
+ * Note that the in case of an error the target node is left
+ * in a inconsistent state. Error recovery should be performed
+ * by using the changeset.
+ */
+static int of_overlay_apply_one(struct of_overlay *ov,
+		struct device_node *target, const struct device_node *overlay)
+{
+	struct device_node *child;
+	struct property *prop;
+	int ret;
+
+	for_each_property_of_node(overlay, prop) {
+		ret = of_overlay_apply_single_property(ov, target, prop);
+		if (ret) {
+			pr_err("%s: Failed to apply prop @%s/%s\n",
+				__func__, target->full_name, prop->name);
+			return ret;
+		}
+	}
+
+	for_each_child_of_node(overlay, child) {
+		ret = of_overlay_apply_single_device_node(ov, target, child);
+		if (ret != 0) {
+			pr_err("%s: Failed to apply single node @%s/%s\n",
+					__func__, target->full_name,
+					child->name);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * of_overlay_apply() - Apply @count overlays pointed at by @ovinfo_tab
+ * @ov:		Overlay to apply
+ *
+ * Applies the overlays given, while handling all error conditions
+ * appropriately. Either the operation succeeds, or if it fails the
+ * live tree is reverted to the state before the attempt.
+ * Returns 0, or an error if the overlay attempt failed.
+ */
+static int of_overlay_apply(struct of_overlay *ov)
+{
+	int i, err;
+
+	/* first we apply the overlays atomically */
+	for (i = 0; i < ov->count; i++) {
+		struct of_overlay_info *ovinfo = &ov->ovinfo_tab[i];
+
+		err = of_overlay_apply_one(ov, ovinfo->target, ovinfo->overlay);
+		if (err != 0) {
+			pr_err("%s: overlay failed '%s'\n",
+				__func__, ovinfo->target->full_name);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Find the target node using a number of different strategies
+ * in order of preference
+ *
+ * "target" property containing the phandle of the target
+ * "target-path" property containing the path of the target
+ */
+static struct device_node *find_target_node(struct device_node *info_node)
+{
+	const char *path;
+	u32 val;
+	int ret;
+
+	/* first try to go by using the target as a phandle */
+	ret = of_property_read_u32(info_node, "target", &val);
+	if (ret == 0)
+		return of_find_node_by_phandle(val);
+
+	/* now try to locate by path */
+	ret = of_property_read_string(info_node, "target-path", &path);
+	if (ret == 0)
+		return of_find_node_by_path(path);
+
+	pr_err("%s: Failed to find target for node %p (%s)\n", __func__,
+		info_node, info_node->name);
+
+	return NULL;
+}
+
+/**
+ * of_fill_overlay_info() - Fill an overlay info structure
+ * @ov		Overlay to fill
+ * @info_node:	Device node containing the overlay
+ * @ovinfo:	Pointer to the overlay info structure to fill
+ *
+ * Fills an overlay info structure with the overlay information
+ * from a device node. This device node must have a target property
+ * which contains a phandle of the overlay target node, and an
+ * __overlay__ child node which has the overlay contents.
+ * Both ovinfo->target & ovinfo->overlay have their references taken.
+ *
+ * Returns 0 on success, or a negative error value.
+ */
+static int of_fill_overlay_info(struct of_overlay *ov,
+		struct device_node *info_node, struct of_overlay_info *ovinfo)
+{
+	ovinfo->overlay = of_get_child_by_name(info_node, "__overlay__");
+	if (ovinfo->overlay == NULL)
+		goto err_fail;
+
+	ovinfo->target = find_target_node(info_node);
+	if (ovinfo->target == NULL)
+		goto err_fail;
+
+	return 0;
+
+err_fail:
+	of_node_put(ovinfo->target);
+	of_node_put(ovinfo->overlay);
+
+	memset(ovinfo, 0, sizeof(*ovinfo));
+	return -EINVAL;
+}
+
+/**
+ * of_build_overlay_info() - Build an overlay info array
+ * @ov		Overlay to build
+ * @tree:	Device node containing all the overlays
+ *
+ * Helper function that given a tree containing overlay information,
+ * allocates and builds an overlay info array containing it, ready
+ * for use using of_overlay_apply.
+ *
+ * Returns 0 on success with the @cntp @ovinfop pointers valid,
+ * while on error a negative error value is returned.
+ */
+static int of_build_overlay_info(struct of_overlay *ov,
+		struct device_node *tree)
+{
+	struct device_node *node;
+	struct of_overlay_info *ovinfo;
+	int cnt, err;
+
+	/* worst case; every child is a node */
+	cnt = 0;
+	for_each_child_of_node(tree, node)
+		cnt++;
+
+	ovinfo = kcalloc(cnt, sizeof(*ovinfo), GFP_KERNEL);
+	if (ovinfo == NULL)
+		return -ENOMEM;
+
+	cnt = 0;
+	for_each_child_of_node(tree, node) {
+		memset(&ovinfo[cnt], 0, sizeof(*ovinfo));
+		err = of_fill_overlay_info(ov, node, &ovinfo[cnt]);
+		if (err == 0)
+			cnt++;
+	}
+
+	/* if nothing filled, return error */
+	if (cnt == 0) {
+		kfree(ovinfo);
+		return -ENODEV;
+	}
+
+	ov->count = cnt;
+	ov->ovinfo_tab = ovinfo;
+
+	return 0;
+}
+
+/**
+ * of_free_overlay_info() - Free an overlay info array
+ * @ov		Overlay to free the overlay info from
+ * @ovinfo_tab:	Array of overlay_info's to free
+ *
+ * Releases the memory of a previously allocated ovinfo array
+ * by of_build_overlay_info.
+ * Returns 0, or an error if the arguments are bogus.
+ */
+static int of_free_overlay_info(struct of_overlay *ov)
+{
+	struct of_overlay_info *ovinfo;
+	int i;
+
+	/* do it in reverse */
+	for (i = ov->count - 1; i >= 0; i--) {
+		ovinfo = &ov->ovinfo_tab[i];
+
+		of_node_put(ovinfo->target);
+		of_node_put(ovinfo->overlay);
+	}
+	kfree(ov->ovinfo_tab);
+
+	return 0;
+}
+
+static LIST_HEAD(ov_list);
+static DEFINE_IDR(ov_idr);
+
+/**
+ * of_overlay_create() - Create and apply an overlay
+ * @tree:	Device node containing all the overlays
+ *
+ * Creates and applies an overlay while also keeping track
+ * of the overlay in a list. This list can be used to prevent
+ * illegal overlay removals.
+ *
+ * Returns the id of the created overlay, or an negative error number
+ */
+int of_overlay_create(struct device_node *tree)
+{
+	struct of_overlay *ov;
+	int err, id;
+
+	/* allocate the overlay structure */
+	ov = kzalloc(sizeof(*ov), GFP_KERNEL);
+	if (ov == NULL)
+		return -ENOMEM;
+	ov->id = -1;
+
+	INIT_LIST_HEAD(&ov->node);
+
+	of_changeset_init(&ov->cset);
+
+	mutex_lock(&of_mutex);
+
+	id = idr_alloc(&ov_idr, ov, 0, 0, GFP_KERNEL);
+	if (id < 0) {
+		pr_err("%s: idr_alloc() failed for tree@%s\n",
+				__func__, tree->full_name);
+		err = id;
+		goto err_destroy_trans;
+	}
+	ov->id = id;
+
+	/* build the overlay info structures */
+	err = of_build_overlay_info(ov, tree);
+	if (err) {
+		pr_err("%s: of_build_overlay_info() failed for tree@%s\n",
+				__func__, tree->full_name);
+		goto err_free_idr;
+	}
+
+	/* apply the overlay */
+	err = of_overlay_apply(ov);
+	if (err) {
+		pr_err("%s: of_overlay_apply() failed for tree@%s\n",
+				__func__, tree->full_name);
+		goto err_abort_trans;
+	}
+
+	/* apply the changeset */
+	err = of_changeset_apply(&ov->cset);
+	if (err) {
+		pr_err("%s: of_changeset_apply() failed for tree@%s\n",
+				__func__, tree->full_name);
+		goto err_revert_overlay;
+	}
+
+	/* add to the tail of the overlay list */
+	list_add_tail(&ov->node, &ov_list);
+
+	mutex_unlock(&of_mutex);
+
+	return id;
+
+err_revert_overlay:
+err_abort_trans:
+	of_free_overlay_info(ov);
+err_free_idr:
+	idr_remove(&ov_idr, ov->id);
+err_destroy_trans:
+	of_changeset_destroy(&ov->cset);
+	kfree(ov);
+	mutex_unlock(&of_mutex);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(of_overlay_create);
+
+/* check whether the given node, lies under the given tree */
+static int overlay_subtree_check(struct device_node *tree,
+		struct device_node *dn)
+{
+	struct device_node *child;
+
+	/* match? */
+	if (tree == dn)
+		return 1;
+
+	for_each_child_of_node(tree, child) {
+		if (overlay_subtree_check(child, dn))
+			return 1;
+	}
+
+	return 0;
+}
+
+/* check whether this overlay is the topmost */
+static int overlay_is_topmost(struct of_overlay *ov, struct device_node *dn)
+{
+	struct of_overlay *ovt;
+	struct of_changeset_entry *ce;
+
+	list_for_each_entry_reverse(ovt, &ov_list, node) {
+		/* if we hit ourselves, we're done */
+		if (ovt == ov)
+			break;
+
+		/* check against each subtree affected by this overlay */
+		list_for_each_entry(ce, &ovt->cset.entries, node) {
+			if (overlay_subtree_check(ce->np, dn)) {
+				pr_err("%s: #%d clashes #%d @%s\n",
+					__func__, ov->id, ovt->id,
+					dn->full_name);
+				return 0;
+			}
+		}
+	}
+
+	/* overlay is topmost */
+	return 1;
+}
+
+/*
+ * We can safely remove the overlay only if it's the top-most one.
+ * Newly applied overlays are inserted at the tail of the overlay list,
+ * so a top most overlay is the one that is closest to the tail.
+ *
+ * The topmost check is done by exploiting this property. For each
+ * affected device node in the log list we check if this overlay is
+ * the one closest to the tail. If another overlay has affected this
+ * device node and is closest to the tail, then removal is not permited.
+ */
+static int overlay_removal_is_ok(struct of_overlay *ov)
+{
+	struct of_changeset_entry *ce;
+
+	list_for_each_entry(ce, &ov->cset.entries, node) {
+		if (!overlay_is_topmost(ov, ce->np)) {
+			pr_err("%s: overlay #%d is not topmost\n",
+					__func__, ov->id);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+/**
+ * of_overlay_destroy() - Removes an overlay
+ * @id:	Overlay id number returned by a previous call to of_overlay_create
+ *
+ * Removes an overlay if it is permissible.
+ *
+ * Returns 0 on success, or an negative error number
+ */
+int of_overlay_destroy(int id)
+{
+	struct of_overlay *ov;
+	int err;
+
+	mutex_lock(&of_mutex);
+
+	ov = idr_find(&ov_idr, id);
+	if (ov == NULL) {
+		err = -ENODEV;
+		pr_err("%s: Could not find overlay #%d\n",
+				__func__, id);
+		goto out;
+	}
+
+	/* check whether the overlay is safe to remove */
+	if (!overlay_removal_is_ok(ov)) {
+		err = -EBUSY;
+		pr_err("%s: removal check failed for overlay #%d\n",
+				__func__, id);
+		goto out;
+	}
+
+
+	list_del(&ov->node);
+	of_changeset_revert(&ov->cset);
+	of_free_overlay_info(ov);
+	idr_remove(&ov_idr, id);
+	of_changeset_destroy(&ov->cset);
+	kfree(ov);
+
+	err = 0;
+
+out:
+	mutex_unlock(&of_mutex);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(of_overlay_destroy);
+
+/**
+ * of_overlay_destroy_all() - Removes all overlays from the system
+ *
+ * Removes all overlays from the system in the correct order.
+ *
+ * Returns 0 on success, or an negative error number
+ */
+int of_overlay_destroy_all(void)
+{
+	struct of_overlay *ov, *ovn;
+
+	mutex_lock(&of_mutex);
+
+	/* the tail of list is guaranteed to be safe to remove */
+	list_for_each_entry_safe_reverse(ov, ovn, &ov_list, node) {
+		list_del(&ov->node);
+		of_changeset_revert(&ov->cset);
+		of_free_overlay_info(ov);
+		idr_remove(&ov_idr, ov->id);
+		kfree(ov);
+	}
+
+	mutex_unlock(&of_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_overlay_destroy_all);
diff --git a/include/linux/of.h b/include/linux/of.h
index 96f678515d8f..eedff4685fba 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/topology.h>
 #include <linux/notifier.h>
+#include <linux/list.h>
 
 #include <asm/byteorder.h>
 #include <asm/errno.h>
@@ -931,4 +932,34 @@ static inline int of_changeset_update_property(struct of_changeset *ocs,
 /* CONFIG_OF_RESOLVE api */
 extern int of_resolve_phandles(struct device_node *tree);
 
+/**
+ * Overlay support
+ */
+
+#ifdef CONFIG_OF_OVERLAY
+
+/* ID based overlays; the API for external users */
+int of_overlay_create(struct device_node *tree);
+int of_overlay_destroy(int id);
+int of_overlay_destroy_all(void);
+
+#else
+
+static inline int of_overlay_create(struct device_node *tree)
+{
+	return -ENOTSUPP;
+}
+
+static inline int of_overlay_destroy(int id)
+{
+	return -ENOTSUPP;
+}
+
+static inline int of_overlay_destroy_all(void)
+{
+	return -ENOTSUPP;
+}
+
+#endif
+
 #endif /* _LINUX_OF_H */
-- 
1.9.1

