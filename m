Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaJFI7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 04:59:22 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63753 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJFI7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 04:59:20 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Gaurav Minocha <gaurav.minocha.os@gmail.com>
Subject: [PATCH] of: Eliminate of_allnodes list
Date: Mon,  6 Oct 2014 09:59:14 +0100
Message-Id: <1412585954-21172-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree structure is composed of two lists; the 'allnodes' list
which is a singly linked list containing every node in the tree, and the
child->parent structure where each parent node has a singly linked list
of children. All of the data in the allnodes list can be easily
reproduced with the parent-child lists, so of_allnodes is actually
unnecessary. Remove it entirely which saves a bit of memory and
simplifies the data structure quite a lot.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Gaurav Minocha <gaurav.minocha.os@gmail.com>
---

This applies against my current devicetree/next branch on git.secretlab.ca/git/linux

I'm not going to try and merge this in v3.18. It's too risky a patch and
I only just wrote it. I'll try to get it in for v3.19.

 Documentation/devicetree/of_selftest.txt | 20 ++-------
 Documentation/devicetree/todo.txt        |  1 -
 drivers/mfd/vexpress-sysreg.c            |  2 +-
 drivers/of/base.c                        | 53 ++++++++++++++----------
 drivers/of/dynamic.c                     | 13 ------
 drivers/of/fdt.c                         | 29 +++++++------
 drivers/of/pdt.c                         | 27 ++++--------
 drivers/of/selftest.c                    | 71 +++++++++++++++-----------------
 include/linux/of.h                       | 11 ++---
 include/linux/of_pdt.h                   |  3 +-
 10 files changed, 98 insertions(+), 132 deletions(-)

diff --git a/Documentation/devicetree/of_selftest.txt b/Documentation/devicetree/of_selftest.txt
index 1e3d5c92b5e3..57a808b588bf 100644
--- a/Documentation/devicetree/of_selftest.txt
+++ b/Documentation/devicetree/of_selftest.txt
@@ -63,7 +63,6 @@ struct device_node {
     struct  device_node *parent;
     struct  device_node *child;
     struct  device_node *sibling;
-    struct  device_node *allnext;   /* next in list of all nodes */
     ...
  };
 
@@ -99,12 +98,6 @@ child11 -> sibling12 -> sibling13 -> sibling14 -> null
 Figure 1: Generic structure of un-flattened device tree
 
 
-*allnext: it is used to link all the nodes of DT into a list. So, for the
- above tree the list would be as follows:
-
-root->child1->child11->sibling12->sibling13->child131->sibling14->sibling2->
-child21->sibling22->sibling23->sibling3->child31->sibling32->sibling4->null
-
 Before executing OF selftest, it is required to attach the test data to
 machine's device tree (if present). So, when selftest_data_add() is called,
 at first it reads the flattened device tree data linked into the kernel image
@@ -131,11 +124,6 @@ root ('/')
  test-child01      null             null             null
 
 
-allnext list:
-
-root->testcase-data->test-child0->test-child01->test-sibling1->test-sibling2
-->test-sibling3->null
-
 Figure 2: Example test data tree to be attached to live tree.
 
 According to the scenario above, the live tree is already present so it isn't
@@ -204,8 +192,6 @@ detached and then moving up the parent nodes are removed, and eventually the
 whole tree). selftest_data_remove() calls detach_node_and_children() that uses
 of_detach_node() to detach the nodes from the live device tree.
 
-To detach a node, of_detach_node() first updates all_next linked list, by
-attaching the previous node's allnext to current node's allnext pointer. And
-then, it either updates the child pointer of given node's parent to its
-sibling or attaches the previous sibling to the given node's sibling, as
-appropriate. That is it :)
+To detach a node, of_detach_node() either updates the child pointer of given
+node's parent to its sibling or attaches the previous sibling to the given
+node's sibling, as appropriate. That is it :)
diff --git a/Documentation/devicetree/todo.txt b/Documentation/devicetree/todo.txt
index c3cf0659bd19..b5139d1de811 100644
--- a/Documentation/devicetree/todo.txt
+++ b/Documentation/devicetree/todo.txt
@@ -2,7 +2,6 @@ Todo list for devicetree:
 
 === General structure ===
 - Switch from custom lists to (h)list_head for nodes and properties structure
-- Remove of_allnodes list and iterate using list of child nodes alone
 
 === CONFIG_OF_DYNAMIC ===
 - Switch to RCU for tree updates and get rid of global spinlock
diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index 9e21e4fc9599..8f43ab8fd2d6 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -223,7 +223,7 @@ static int vexpress_sysreg_probe(struct platform_device *pdev)
 	vexpress_config_set_master(vexpress_sysreg_get_master());
 
 	/* Confirm board type against DT property, if available */
-	if (of_property_read_u32(of_allnodes, "arm,hbi", &dt_hbi) == 0) {
+	if (of_property_read_u32(of_root, "arm,hbi", &dt_hbi) == 0) {
 		u32 id = vexpress_get_procid(VEXPRESS_SITE_MASTER);
 		u32 hbi = (id >> SYS_PROCIDx_HBI_SHIFT) & SYS_HBI_MASK;
 
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 2305dc0382bc..b86beff7b167 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -32,8 +32,8 @@
 
 LIST_HEAD(aliases_lookup);
 
-struct device_node *of_allnodes;
-EXPORT_SYMBOL(of_allnodes);
+struct device_node *of_root;
+EXPORT_SYMBOL(of_root);
 struct device_node *of_chosen;
 struct device_node *of_aliases;
 struct device_node *of_stdout;
@@ -48,7 +48,7 @@ struct kset *of_kset;
  */
 DEFINE_MUTEX(of_mutex);
 
-/* use when traversing tree through the allnext, child, sibling,
+/* use when traversing tree through the child, sibling,
  * or parent members of struct device_node.
  */
 DEFINE_RAW_SPINLOCK(devtree_lock);
@@ -204,7 +204,7 @@ static int __init of_init(void)
 	mutex_unlock(&of_mutex);
 
 	/* Symlink in /proc as required by userspace ABI */
-	if (of_allnodes)
+	if (of_root)
 		proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base");
 
 	return 0;
@@ -245,6 +245,23 @@ struct property *of_find_property(const struct device_node *np,
 }
 EXPORT_SYMBOL(of_find_property);
 
+struct device_node *__of_find_all_nodes(struct device_node *prev)
+{
+	struct device_node *np;
+	if (!prev)
+		np = of_root;
+	else if (prev->child) {
+		np = prev->child;
+	} else {
+		/* Walk back up looking for a sibling, or the end of the structure */
+		np = prev;
+		while (np->parent && !np->sibling)
+			np = np->parent;
+		np = np->sibling; /* Might be null at the end of the tree */
+	}
+	return np;
+}
+
 /**
  * of_find_all_nodes - Get next node in global list
  * @prev:	Previous node or NULL to start iteration
@@ -259,10 +276,8 @@ struct device_node *of_find_all_nodes(struct device_node *prev)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	np = prev ? prev->allnext : of_allnodes;
-	for (; np != NULL; np = np->allnext)
-		if (of_node_get(np))
-			break;
+	np = __of_find_all_nodes(prev);
+	of_node_get(np);
 	of_node_put(prev);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
@@ -736,7 +751,7 @@ struct device_node *of_find_node_by_path(const char *path)
 	unsigned long flags;
 
 	if (strcmp(path, "/") == 0)
-		return of_node_get(of_allnodes);
+		return of_node_get(of_root);
 
 	/* The path could begin with an alias */
 	if (*path != '/') {
@@ -761,7 +776,7 @@ struct device_node *of_find_node_by_path(const char *path)
 	/* Step down the tree matching path components */
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	if (!np)
-		np = of_node_get(of_allnodes);
+		np = of_node_get(of_root);
 	while (np && *path == '/') {
 		path++; /* Increment past '/' delimiter */
 		np = __of_find_node_by_path(np, path);
@@ -790,8 +805,7 @@ struct device_node *of_find_node_by_name(struct device_node *from,
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	np = from ? from->allnext : of_allnodes;
-	for (; np; np = np->allnext)
+	for_each_of_allnodes_from(from, np)
 		if (np->name && (of_node_cmp(np->name, name) == 0)
 		    && of_node_get(np))
 			break;
@@ -820,8 +834,7 @@ struct device_node *of_find_node_by_type(struct device_node *from,
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	np = from ? from->allnext : of_allnodes;
-	for (; np; np = np->allnext)
+	for_each_of_allnodes_from(from, np)
 		if (np->type && (of_node_cmp(np->type, type) == 0)
 		    && of_node_get(np))
 			break;
@@ -852,12 +865,10 @@ struct device_node *of_find_compatible_node(struct device_node *from,
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	np = from ? from->allnext : of_allnodes;
-	for (; np; np = np->allnext) {
+	for_each_of_allnodes_from(from, np)
 		if (__of_device_is_compatible(np, compatible, type, NULL) &&
 		    of_node_get(np))
 			break;
-	}
 	of_node_put(from);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
@@ -884,8 +895,7 @@ struct device_node *of_find_node_with_property(struct device_node *from,
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	np = from ? from->allnext : of_allnodes;
-	for (; np; np = np->allnext) {
+	for_each_of_allnodes_from(from, np) {
 		for (pp = np->properties; pp; pp = pp->next) {
 			if (of_prop_cmp(pp->name, prop_name) == 0) {
 				of_node_get(np);
@@ -967,8 +977,7 @@ struct device_node *of_find_matching_node_and_match(struct device_node *from,
 		*match = NULL;
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	np = from ? from->allnext : of_allnodes;
-	for (; np; np = np->allnext) {
+	for_each_of_allnodes_from(from, np) {
 		m = __of_match_node(matches, np);
 		if (m && of_node_get(np)) {
 			if (match)
@@ -1025,7 +1034,7 @@ struct device_node *of_find_node_by_phandle(phandle handle)
 		return NULL;
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	for (np = of_allnodes; np; np = np->allnext)
+	for_each_of_allnodes(np)
 		if (np->phandle == handle)
 			break;
 	of_node_get(np);
diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index f297891d8529..da2509d639c8 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -117,8 +117,6 @@ void __of_attach_node(struct device_node *np)
 
 	np->child = NULL;
 	np->sibling = np->parent->child;
-	np->allnext = np->parent->allnext;
-	np->parent->allnext = np;
 	np->parent->child = np;
 	of_node_clear_flag(np, OF_DETACHED);
 }
@@ -154,17 +152,6 @@ void __of_detach_node(struct device_node *np)
 	if (WARN_ON(!parent))
 		return;
 
-	if (of_allnodes == np)
-		of_allnodes = np->allnext;
-	else {
-		struct device_node *prev;
-		for (prev = of_allnodes;
-		     prev->allnext != np;
-		     prev = prev->allnext)
-			;
-		prev->allnext = np->allnext;
-	}
-
 	if (parent->child == np)
 		parent->child = np->sibling;
 	else {
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index d1ffca8b34ea..fab81c81d590 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -152,8 +152,9 @@ static void * unflatten_dt_node(void *blob,
 				void *mem,
 				int *poffset,
 				struct device_node *dad,
-				struct device_node ***allnextpp,
-				unsigned long fpsize)
+				struct device_node **nodepp,
+				unsigned long fpsize,
+				bool dryrun)
 {
 	const __be32 *p;
 	struct device_node *np;
@@ -200,7 +201,7 @@ static void * unflatten_dt_node(void *blob,
 
 	np = unflatten_dt_alloc(&mem, sizeof(struct device_node) + allocl,
 				__alignof__(struct device_node));
-	if (allnextpp) {
+	if (!dryrun) {
 		char *fn;
 		of_node_init(np);
 		np->full_name = fn = ((char *)np) + sizeof(*np);
@@ -222,8 +223,6 @@ static void * unflatten_dt_node(void *blob,
 		memcpy(fn, pathp, l);
 
 		prev_pp = &np->properties;
-		**allnextpp = np;
-		*allnextpp = &np->allnext;
 		if (dad != NULL) {
 			np->parent = dad;
 			/* we temporarily use the next field as `last_child'*/
@@ -254,7 +253,7 @@ static void * unflatten_dt_node(void *blob,
 			has_name = 1;
 		pp = unflatten_dt_alloc(&mem, sizeof(struct property),
 					__alignof__(struct property));
-		if (allnextpp) {
+		if (!dryrun) {
 			/* We accept flattened tree phandles either in
 			 * ePAPR-style "phandle" properties, or the
 			 * legacy "linux,phandle" properties.  If both
@@ -296,7 +295,7 @@ static void * unflatten_dt_node(void *blob,
 		sz = (pa - ps) + 1;
 		pp = unflatten_dt_alloc(&mem, sizeof(struct property) + sz,
 					__alignof__(struct property));
-		if (allnextpp) {
+		if (!dryrun) {
 			pp->name = "name";
 			pp->length = sz;
 			pp->value = pp + 1;
@@ -308,7 +307,7 @@ static void * unflatten_dt_node(void *blob,
 				(char *)pp->value);
 		}
 	}
-	if (allnextpp) {
+	if (!dryrun) {
 		*prev_pp = NULL;
 		np->name = of_get_property(np, "name", NULL);
 		np->type = of_get_property(np, "device_type", NULL);
@@ -324,11 +323,13 @@ static void * unflatten_dt_node(void *blob,
 	if (depth < 0)
 		depth = 0;
 	while (*poffset > 0 && depth > old_depth)
-		mem = unflatten_dt_node(blob, mem, poffset, np, allnextpp,
-					fpsize);
+		mem = unflatten_dt_node(blob, mem, poffset, np, NULL,
+					fpsize, dryrun);
 
 	if (*poffset < 0 && *poffset != -FDT_ERR_NOTFOUND)
 		pr_err("unflatten: error %d processing FDT\n", *poffset);
+	if (nodepp)
+		*nodepp = np;
 
 	return mem;
 }
@@ -352,7 +353,6 @@ static void __unflatten_device_tree(void *blob,
 	unsigned long size;
 	int start;
 	void *mem;
-	struct device_node **allnextp = mynodes;
 
 	pr_debug(" -> unflatten_device_tree()\n");
 
@@ -373,7 +373,7 @@ static void __unflatten_device_tree(void *blob,
 
 	/* First pass, scan for size */
 	start = 0;
-	size = (unsigned long)unflatten_dt_node(blob, NULL, &start, NULL, NULL, 0);
+	size = (unsigned long)unflatten_dt_node(blob, NULL, &start, NULL, NULL, 0, true);
 	size = ALIGN(size, 4);
 
 	pr_debug("  size is %lx, allocating...\n", size);
@@ -388,11 +388,10 @@ static void __unflatten_device_tree(void *blob,
 
 	/* Second pass, do actual unflattening */
 	start = 0;
-	unflatten_dt_node(blob, mem, &start, NULL, &allnextp, 0);
+	unflatten_dt_node(blob, mem, &start, NULL, mynodes, 0, false);
 	if (be32_to_cpup(mem + size) != 0xdeadbeef)
 		pr_warning("End of tree marker overwritten: %08x\n",
 			   be32_to_cpup(mem + size));
-	*allnextp = NULL;
 
 	pr_debug(" <- unflatten_device_tree()\n");
 }
@@ -1041,7 +1040,7 @@ bool __init early_init_dt_scan(void *params)
  */
 void __init unflatten_device_tree(void)
 {
-	__unflatten_device_tree(initial_boot_params, &of_allnodes,
+	__unflatten_device_tree(initial_boot_params, &of_root,
 				early_init_dt_alloc_memory_arch);
 
 	/* Get pointer to "/chosen" and "/aliases" nodes for use everywhere */
diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 36b4035881b0..d2acae825af9 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -25,8 +25,7 @@
 
 static struct of_pdt_ops *of_pdt_prom_ops __initdata;
 
-void __initdata (*of_pdt_build_more)(struct device_node *dp,
-		struct device_node ***nextp);
+void __initdata (*of_pdt_build_more)(struct device_node *dp);
 
 #if defined(CONFIG_SPARC)
 unsigned int of_pdt_unique_id __initdata;
@@ -192,8 +191,7 @@ static struct device_node * __init of_pdt_create_node(phandle node,
 }
 
 static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
-						   phandle node,
-						   struct device_node ***nextp)
+						   phandle node)
 {
 	struct device_node *ret = NULL, *prev_sibling = NULL;
 	struct device_node *dp;
@@ -210,16 +208,12 @@ static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
 			ret = dp;
 		prev_sibling = dp;
 
-		*(*nextp) = dp;
-		*nextp = &dp->allnext;
-
 		dp->full_name = of_pdt_build_full_name(dp);
 
-		dp->child = of_pdt_build_tree(dp,
-				of_pdt_prom_ops->getchild(node), nextp);
+		dp->child = of_pdt_build_tree(dp, of_pdt_prom_ops->getchild(node));
 
 		if (of_pdt_build_more)
-			of_pdt_build_more(dp, nextp);
+			of_pdt_build_more(dp);
 
 		node = of_pdt_prom_ops->getsibling(node);
 	}
@@ -234,20 +228,17 @@ static void * __init kernel_tree_alloc(u64 size, u64 align)
 
 void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
 {
-	struct device_node **nextp;
-
 	BUG_ON(!ops);
 	of_pdt_prom_ops = ops;
 
-	of_allnodes = of_pdt_create_node(root_node, NULL);
+	of_root = of_pdt_create_node(root_node, NULL);
 #if defined(CONFIG_SPARC)
-	of_allnodes->path_component_name = "";
+	of_root->path_component_name = "";
 #endif
-	of_allnodes->full_name = "/";
+	of_root->full_name = "/";
 
-	nextp = &of_allnodes->allnext;
-	of_allnodes->child = of_pdt_build_tree(of_allnodes,
-			of_pdt_prom_ops->getchild(of_allnodes->phandle), &nextp);
+	of_root->child = of_pdt_build_tree(of_root,
+				of_pdt_prom_ops->getchild(of_root->phandle));
 
 	/* Get pointer to "/chosen" and "/aliases" nodes for use everywhere */
 	of_alias_scan(kernel_tree_alloc);
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index 4fed34bff5cf..9cc2363a9077 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -148,7 +148,7 @@ static void __init of_selftest_dynamic(void)
 
 static int __init of_selftest_check_node_linkage(struct device_node *np)
 {
-	struct device_node *child, *allnext_index = np;
+	struct device_node *child;
 	int count = 0, rc;
 
 	for_each_child_of_node(np, child) {
@@ -158,14 +158,6 @@ static int __init of_selftest_check_node_linkage(struct device_node *np)
 			return -EINVAL;
 		}
 
-		while (allnext_index && allnext_index != child)
-			allnext_index = allnext_index->allnext;
-		if (allnext_index != child) {
-			pr_err("Node %s is ordered differently in sibling and allnode lists\n",
-				 child->name);
-			return -EINVAL;
-		}
-
 		rc = of_selftest_check_node_linkage(child);
 		if (rc < 0)
 			return rc;
@@ -180,12 +172,12 @@ static void __init of_selftest_check_tree_linkage(void)
 	struct device_node *np;
 	int allnode_count = 0, child_count;
 
-	if (!of_allnodes)
+	if (!of_root)
 		return;
 
 	for_each_of_allnodes(np)
 		allnode_count++;
-	child_count = of_selftest_check_node_linkage(of_allnodes);
+	child_count = of_selftest_check_node_linkage(of_root);
 
 	selftest(child_count > 0, "Device node data structure is corrupted\n");
 	selftest(child_count == allnode_count, "allnodes list size (%i) doesn't match"
@@ -722,33 +714,29 @@ static void update_node_properties(struct device_node *np,
  */
 static int attach_node_and_children(struct device_node *np)
 {
-	struct device_node *next, *root = np, *dup;
+	struct device_node *next, *dup, *child;
 
-	/* skip root node */
-	np = np->child;
-	/* storing a copy in temporary node */
-	dup = np;
+	dup = of_find_node_by_path(np->full_name);
+	if (dup) {
+		update_node_properties(np, dup);
+		return 0;
+	}
 
-	while (dup) {
+	/* Children of the root need to be remembered for removal */
+	if (np->parent == of_root) {
 		if (WARN_ON(last_node_index >= NO_OF_NODES))
 			return -EINVAL;
-		nodes[last_node_index++] = dup;
-		dup = dup->sibling;
+		nodes[last_node_index++] = np;
 	}
-	dup = NULL;
 
-	while (np) {
-		next = np->allnext;
-		dup = of_find_node_by_path(np->full_name);
-		if (dup)
-			update_node_properties(np, dup);
-		else {
-			np->child = NULL;
-			if (np->parent == root)
-				np->parent = of_allnodes;
-			of_attach_node(np);
-		}
-		np = next;
+	child = np->child;
+	np->child = NULL;
+	np->sibling = NULL;
+	of_attach_node(np);
+	while (child) {
+		next = child->sibling;
+		attach_node_and_children(child);
+		child = next;
 	}
 
 	return 0;
@@ -793,10 +781,10 @@ static int __init selftest_data_add(void)
 		return -EINVAL;
 	}
 
-	if (!of_allnodes) {
+	if (!of_root) {
 		/* enabling flag for removing nodes */
 		selftest_live_tree = true;
-		of_allnodes = selftest_data_node;
+		of_root = selftest_data_node;
 
 		for_each_of_allnodes(np)
 			__of_attach_node_sysfs(np);
@@ -806,7 +794,14 @@ static int __init selftest_data_add(void)
 	}
 
 	/* attach the sub-tree to live tree */
-	return attach_node_and_children(selftest_data_node);
+	np = selftest_data_node->child;
+	while (np) {
+		struct device_node *next = np->sibling;
+		np->parent = of_root;
+		attach_node_and_children(np);
+		np = next;
+	}
+	return 0;
 }
 
 /**
@@ -836,10 +831,10 @@ static void selftest_data_remove(void)
 		of_node_put(of_chosen);
 		of_aliases = NULL;
 		of_chosen = NULL;
-		for_each_child_of_node(of_allnodes, np)
+		for_each_child_of_node(of_root, np)
 			detach_node_and_children(np);
-		__of_detach_node_sysfs(of_allnodes);
-		of_allnodes = NULL;
+		__of_detach_node_sysfs(of_root);
+		of_root = NULL;
 		return;
 	}
 
diff --git a/include/linux/of.h b/include/linux/of.h
index 6545e7aec7bb..8fea40ac6b25 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -56,7 +56,6 @@ struct device_node {
 	struct	device_node *child;
 	struct	device_node *sibling;
 	struct	device_node *next;	/* next device of same type */
-	struct	device_node *allnext;	/* next in list of all nodes */
 	struct	kobject kobj;
 	unsigned long _flags;
 	void	*data;
@@ -108,7 +107,7 @@ static inline void of_node_put(struct device_node *node) { }
 #ifdef CONFIG_OF
 
 /* Pointer for first entry in chain of all nodes. */
-extern struct device_node *of_allnodes;
+extern struct device_node *of_root;
 extern struct device_node *of_chosen;
 extern struct device_node *of_aliases;
 extern struct device_node *of_stdout;
@@ -116,7 +115,7 @@ extern raw_spinlock_t devtree_lock;
 
 static inline bool of_have_populated_dt(void)
 {
-	return of_allnodes != NULL;
+	return of_root != NULL;
 }
 
 static inline bool of_node_is_root(const struct device_node *node)
@@ -160,6 +159,7 @@ static inline void of_property_clear_flag(struct property *p, unsigned long flag
 	clear_bit(flag, &p->_flags);
 }
 
+extern struct device_node *__of_find_all_nodes(struct device_node *prev);
 extern struct device_node *of_find_all_nodes(struct device_node *prev);
 
 /*
@@ -215,8 +215,9 @@ static inline const char *of_node_full_name(const struct device_node *np)
 	return np ? np->full_name : "<no-node>";
 }
 
-#define for_each_of_allnodes(dn) \
-	for (dn = of_allnodes; dn; dn = dn->allnext)
+#define for_each_of_allnodes_from(from, dn) \
+	for (dn = __of_find_all_nodes(from); dn; dn = __of_find_all_nodes(dn))
+#define for_each_of_allnodes(dn) for_each_of_allnodes_from(NULL, dn)
 extern struct device_node *of_find_node_by_name(struct device_node *from,
 	const char *name);
 extern struct device_node *of_find_node_by_type(struct device_node *from,
diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
index c65a18a0cfdf..7e09244bb679 100644
--- a/include/linux/of_pdt.h
+++ b/include/linux/of_pdt.h
@@ -39,7 +39,6 @@ extern void *prom_early_alloc(unsigned long size);
 /* for building the device tree */
 extern void of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops);
 
-extern void (*of_pdt_build_more)(struct device_node *dp,
-		struct device_node ***nextp);
+extern void (*of_pdt_build_more)(struct device_node *dp);
 
 #endif /* _LINUX_OF_PDT_H */
-- 
1.9.1

