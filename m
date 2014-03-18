Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbaCRVw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:52:59 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63001 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbaCRVwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:52:55 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
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
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH] OF: Utility helper functions for dynamic nodes
Date: Tue, 18 Mar 2014 23:52:50 +0200
Message-Id: <1395179570-31428-1-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper functions for working with the live DT tree,
all of them related to dynamically adding/removing nodes and
properties.

__of_free_property() frees a dynamically created property
__of_free_tree() recursively frees a device node tree
__of_copy_property() copies a property dynamically
__of_create_empty_node() creates an empty node

Bug fix about prop->len == 0 by Ionut Nicu <ioan.nicu.ext@nsn.com>

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/of/Makefile |   2 +-
 drivers/of/util.c   | 210 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of.h  |  55 ++++++++++++++
 3 files changed, 266 insertions(+), 1 deletion(-)
 create mode 100644 drivers/of/util.c

diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index ed9660a..26de2ed 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -1,4 +1,4 @@
-obj-y = base.o device.o platform.o
+obj-y = base.o device.o platform.o util.o
 obj-$(CONFIG_OF_FLATTREE) += fdt.o
 obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_ADDRESS)  += address.o
diff --git a/drivers/of/util.c b/drivers/of/util.c
new file mode 100644
index 0000000..df747af
--- /dev/null
+++ b/drivers/of/util.c
@@ -0,0 +1,210 @@
+/*
+ * Utility functions for working with device tree(s)
+ *
+ * Copyright (C) 2012 Pantelis Antoniou <panto@antoniou-consulting.com>
+ * Copyright (C) 2012 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
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
+/**
+ * __of_free_property - release the memory of an allocated property
+ * @prop:	Property to release
+ *
+ * Release the memory of an allocated property only after checking
+ * that the property has been marked as OF_DYNAMIC.
+ * Only call on known allocated properties.
+ */
+void __of_free_property(struct property *prop)
+{
+	if (prop == NULL)
+		return;
+
+	if (of_property_check_flag(prop, OF_DYNAMIC)) {
+		if (of_property_check_flag(prop, OF_ALLOCVALUE))
+			kfree(prop->value);
+		if (of_property_check_flag(prop, OF_ALLOCNAME))
+			kfree(prop->name);
+		kfree(prop);
+	}
+}
+
+/**
+ * __of_free_tree - release the memory of a device tree node and
+ *		    of all it's children + properties.
+ * @node:	Device Tree node to release
+ *
+ * Release the memory of a device tree node and of all it's children.
+ * Also release the properties and the dead properties.
+ * Only call on detached node trees, and you better be sure that
+ * no pointer exist for any properties. Only safe to do if you
+ * absolutely control the life cycle of the node.
+ * Also note that the node is not removed from the all_nodes list,
+ * neither from the parent's child list; this should be handled before
+ * calling this function.
+ */
+void __of_free_tree(struct device_node *node)
+{
+	struct property *prop;
+	struct device_node *noden;
+
+	/* sanity check */
+	if (!node)
+		return;
+
+	/* free recursively any children */
+	while ((noden = node->child) != NULL) {
+		node->child = noden->sibling;
+		__of_free_tree(noden);
+	}
+
+	/* free every property already allocated */
+	while ((prop = node->properties) != NULL) {
+		node->properties = prop->next;
+		__of_free_property(prop);
+	}
+
+	/* free dead properties already allocated */
+	while ((prop = node->deadprops) != NULL) {
+		node->deadprops = prop->next;
+		__of_free_property(prop);
+	}
+
+	if (of_node_check_flag(node, OF_DYNAMIC)) {
+		if (of_node_check_flag(node, OF_ALLOCFULL))
+			kfree(node->full_name);
+		if (of_node_check_flag(node, OF_ALLOCTYPE))
+			kfree(node->type);
+		if (of_node_check_flag(node, OF_ALLOCNAME))
+			kfree(node->name);
+		kfree(node);
+	}
+}
+
+/**
+ * __of_copy_property - Copy a property dynamically.
+ * @prop:	Property to copy
+ * @allocflags:	Allocation flags (typically pass GFP_KERNEL)
+ * @propflags:	Property flags
+ *
+ * Copy a property by dynamically allocating the memory of both the
+ * property stucture and the property name & contents. The property's
+ * flags have the OF_DYNAMIC bit set so that we can differentiate between
+ * dynamically allocated properties and not.
+ * Returns the newly allocated property or NULL on out of memory error.
+ */
+struct property *__of_copy_property(const struct property *prop,
+		gfp_t allocflags, unsigned long propflags)
+{
+	struct property *propn;
+
+	propn = kzalloc(sizeof(*prop), allocflags);
+	if (propn == NULL)
+		return NULL;
+
+	propn->_flags = propflags;
+
+	if (of_property_check_flag(propn, OF_ALLOCNAME)) {
+		propn->name = kstrdup(prop->name, allocflags);
+		if (propn->name == NULL)
+			goto err_fail_name;
+	} else
+		propn->name = prop->name;
+
+	if (prop->length > 0) {
+		if (of_property_check_flag(propn, OF_ALLOCVALUE)) {
+			propn->value = kmalloc(prop->length, allocflags);
+			if (propn->value == NULL)
+				goto err_fail_value;
+			memcpy(propn->value, prop->value, prop->length);
+		} else
+			propn->value = prop->value;
+
+		propn->length = prop->length;
+	}
+
+	/* mark the property as dynamic */
+	of_property_set_flag(propn, OF_DYNAMIC);
+
+	return propn;
+
+err_fail_value:
+	if (of_property_check_flag(propn, OF_ALLOCNAME))
+		kfree(propn->name);
+err_fail_name:
+	kfree(propn);
+	return NULL;
+}
+
+/**
+ * __of_create_empty_node - Create an empty device node dynamically.
+ * @name:	Name of the new device node
+ * @type:	Type of the new device node
+ * @full_name:	Full name of the new device node
+ * @phandle:	Phandle of the new device node
+ * @allocflags:	Allocation flags (typically pass GFP_KERNEL)
+ * @nodeflags:	Node flags
+ *
+ * Create an empty device tree node, suitable for further modification.
+ * The node data are dynamically allocated and all the node flags
+ * have the OF_DYNAMIC & OF_DETACHED bits set.
+ * Returns the newly allocated node or NULL on out of memory error.
+ */
+struct device_node *__of_create_empty_node(
+		const char *name, const char *type, const char *full_name,
+		phandle phandle, gfp_t allocflags, unsigned long nodeflags)
+{
+	struct device_node *node;
+
+	node = kzalloc(sizeof(*node), allocflags);
+	if (node == NULL)
+		return NULL;
+
+	node->_flags = nodeflags;
+
+	if (of_node_check_flag(node, OF_ALLOCNAME)) {
+		node->name = kstrdup(name, allocflags);
+		if (node->name == NULL)
+			goto err_return;
+	} else
+		node->name = name;
+
+	if (of_node_check_flag(node, OF_ALLOCTYPE)) {
+		node->type = kstrdup(type, allocflags);
+		if (node->type == NULL)
+			goto err_return;
+	} else
+		node->type = type;
+
+	if (of_node_check_flag(node, OF_ALLOCFULL)) {
+		node->full_name = kstrdup(full_name, allocflags);
+		if (node->full_name == NULL)
+			goto err_return;
+	} else
+		node->full_name = full_name;
+
+	node->phandle = phandle;
+	of_node_set_flag(node, OF_DYNAMIC);
+	of_node_set_flag(node, OF_DETACHED);
+
+	of_node_init(node);
+
+	return node;
+
+err_return:
+	__of_free_tree(node);
+	return NULL;
+}
diff --git a/include/linux/of.h b/include/linux/of.h
index bef3d5b..9a55889 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -197,6 +197,15 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 /* flag descriptions */
 #define OF_DYNAMIC	1 /* node and properties were allocated via kmalloc */
 #define OF_DETACHED	2 /* node has been detached from the device tree */
+#define OF_ALLOCNAME	3 /* name was kmalloc-ed */
+#define OF_ALLOCTYPE	4 /* type was kmalloc-ed */
+#define OF_ALLOCFULL	5 /* full_name was kmalloc-ed */
+#define OF_ALLOCVALUE	6 /* value was kmalloc-ed */
+
+#define OF_NODE_ALLOCALL \
+	((1 << OF_ALLOCNAME) | (1 << OF_ALLOCTYPE) | (1 << OF_ALLOCFULL))
+#define OF_PROP_ALLOCALL \
+	((1 << OF_ALLOCNAME) | (1 << OF_ALLOCVALUE))
 
 #define OF_IS_DYNAMIC(x) test_bit(OF_DYNAMIC, &x->_flags)
 #define OF_MARK_DYNAMIC(x) set_bit(OF_DYNAMIC, &x->_flags)
@@ -680,4 +689,50 @@ static inline int of_get_available_child_count(const struct device_node *np)
 	return num;
 }
 
+/**
+ * General utilities for working with live trees.
+ *
+ * All functions with two leading underscores operate
+ * without taking node references, so you either have to
+ * own the devtree lock or work on detached trees only.
+ */
+
+#ifdef CONFIG_OF
+
+/* iterator for internal use; not references, neither affects devtree lock */
+#define __for_each_child_of_node(dn, chld) \
+	for (chld = (dn)->child; chld != NULL; chld = chld->sibling)
+
+void __of_free_property(struct property *prop);
+void __of_free_tree(struct device_node *node);
+struct property *__of_copy_property(const struct property *prop,
+		gfp_t allocflags, unsigned long propflags);
+struct device_node *__of_create_empty_node( const char *name,
+		const char *type, const char *full_name,
+		phandle phandle, gfp_t allocflags, unsigned long nodeflags);
+
+#else /* !CONFIG_OF */
+
+#define __for_each_child_of_node(dn, chld) \
+	while (0)
+
+static inline void __of_free_property(struct property *prop) { }
+
+static inline void __of_free_tree(struct device_node *node) { }
+
+static inline struct property *__of_copy_property(const struct property *prop,
+		gfp_t allocflags, unsigned long propflags)
+{
+	return NULL;
+}
+
+static inline struct device_node *__of_create_empty_node( const char *name,
+		const char *type, const char *full_name,
+		phandle phandle, gfp_t allocflags, unsigned long nodeflags)
+{
+	return NULL;
+}
+
+#endif	/* !CONFIG_OF */
+
 #endif /* _LINUX_OF_H */
-- 
1.7.12

