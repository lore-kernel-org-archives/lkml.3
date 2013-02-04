Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3BDQGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:06:06 -0500
Received: from mail.windriver.com ([147.11.1.11]:56593 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab3BDQGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:06:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Sam Ravnborg <sam@ravnborg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH next] OF: convert devtree lock from rw_lock to raw spinlock
Date: Mon,  4 Feb 2013 11:05:21 -0500
Message-Id: <1359993921-18145-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

With the locking cleanup in place (from "OF: Fixup resursive
locking code paths"), we can now do the conversion from the
rw_lock to a raw spinlock as required for preempt-rt.

The previous cleanup and the this conversion were originally
separate since they predated when mainline got raw spinlock (in
commit c2f21ce2e31286a "locking: Implement new raw_spinlock").

So, at that point in time, the cleanup was considered plausible
for mainline, but not this conversion.  In any case, we've kept
them separate as it makes for easier review and better bisection.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[PG: taken from preempt-rt, update subject & add a commit log]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[ Patch against linux-next of Feb4, where the recursive
  locking cleanup currently is.  Boot tested on ppc 8548,
  compile tested for sparc and arm defconfigs ]

 arch/sparc/kernel/prom_common.c |  4 +-
 drivers/of/base.c               | 96 +++++++++++++++++++++++------------------
 include/linux/of.h              |  2 +-
 3 files changed, 57 insertions(+), 45 deletions(-)

diff --git a/arch/sparc/kernel/prom_common.c b/arch/sparc/kernel/prom_common.c
index 1303021..9f20566 100644
--- a/arch/sparc/kernel/prom_common.c
+++ b/arch/sparc/kernel/prom_common.c
@@ -64,7 +64,7 @@ int of_set_property(struct device_node *dp, const char *name, void *val, int len
 	err = -ENODEV;
 
 	mutex_lock(&of_set_property_mutex);
-	write_lock(&devtree_lock);
+	raw_spin_lock(&devtree_lock);
 	prevp = &dp->properties;
 	while (*prevp) {
 		struct property *prop = *prevp;
@@ -91,7 +91,7 @@ int of_set_property(struct device_node *dp, const char *name, void *val, int len
 		}
 		prevp = &(*prevp)->next;
 	}
-	write_unlock(&devtree_lock);
+	raw_spin_unlock(&devtree_lock);
 	mutex_unlock(&of_set_property_mutex);
 
 	/* XXX Upate procfs if necessary... */
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 16ee7a0..4a2f58b 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -55,7 +55,7 @@ static DEFINE_MUTEX(of_aliases_mutex);
 /* use when traversing tree through the allnext, child, sibling,
  * or parent members of struct device_node.
  */
-DEFINE_RWLOCK(devtree_lock);
+DEFINE_RAW_SPINLOCK(devtree_lock);
 
 int of_n_addr_cells(struct device_node *np)
 {
@@ -188,10 +188,11 @@ struct property *of_find_property(const struct device_node *np,
 				  int *lenp)
 {
 	struct property *pp;
+	unsigned long flags;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	pp = __of_find_property(np, name, lenp);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
 	return pp;
 }
@@ -209,13 +210,13 @@ struct device_node *of_find_all_nodes(struct device_node *prev)
 {
 	struct device_node *np;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock(&devtree_lock);
 	np = prev ? prev->allnext : of_allnodes;
 	for (; np != NULL; np = np->allnext)
 		if (of_node_get(np))
 			break;
 	of_node_put(prev);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock(&devtree_lock);
 	return np;
 }
 EXPORT_SYMBOL(of_find_all_nodes);
@@ -274,11 +275,12 @@ static int __of_device_is_compatible(const struct device_node *device,
 int of_device_is_compatible(const struct device_node *device,
 		const char *compat)
 {
+	unsigned long flags;
 	int res;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	res = __of_device_is_compatible(device, compat);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return res;
 }
 EXPORT_SYMBOL(of_device_is_compatible);
@@ -340,13 +342,14 @@ EXPORT_SYMBOL(of_device_is_available);
 struct device_node *of_get_parent(const struct device_node *node)
 {
 	struct device_node *np;
+	unsigned long flags;
 
 	if (!node)
 		return NULL;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	np = of_node_get(node->parent);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
 EXPORT_SYMBOL(of_get_parent);
@@ -365,14 +368,15 @@ EXPORT_SYMBOL(of_get_parent);
 struct device_node *of_get_next_parent(struct device_node *node)
 {
 	struct device_node *parent;
+	unsigned long flags;
 
 	if (!node)
 		return NULL;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	parent = of_node_get(node->parent);
 	of_node_put(node);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return parent;
 }
 
@@ -388,14 +392,15 @@ struct device_node *of_get_next_child(const struct device_node *node,
 	struct device_node *prev)
 {
 	struct device_node *next;
+	unsigned long flags;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	next = prev ? prev->sibling : node->child;
 	for (; next; next = next->sibling)
 		if (of_node_get(next))
 			break;
 	of_node_put(prev);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return next;
 }
 EXPORT_SYMBOL(of_get_next_child);
@@ -413,7 +418,7 @@ struct device_node *of_get_next_available_child(const struct device_node *node,
 {
 	struct device_node *next;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock(&devtree_lock);
 	next = prev ? prev->sibling : node->child;
 	for (; next; next = next->sibling) {
 		if (!of_device_is_available(next))
@@ -422,7 +427,7 @@ struct device_node *of_get_next_available_child(const struct device_node *node,
 			break;
 	}
 	of_node_put(prev);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock(&devtree_lock);
 	return next;
 }
 EXPORT_SYMBOL(of_get_next_available_child);
@@ -460,14 +465,15 @@ EXPORT_SYMBOL(of_get_child_by_name);
 struct device_node *of_find_node_by_path(const char *path)
 {
 	struct device_node *np = of_allnodes;
+	unsigned long flags;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	for (; np; np = np->allnext) {
 		if (np->full_name && (of_node_cmp(np->full_name, path) == 0)
 		    && of_node_get(np))
 			break;
 	}
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
 EXPORT_SYMBOL(of_find_node_by_path);
@@ -487,15 +493,16 @@ struct device_node *of_find_node_by_name(struct device_node *from,
 	const char *name)
 {
 	struct device_node *np;
+	unsigned long flags;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	np = from ? from->allnext : of_allnodes;
 	for (; np; np = np->allnext)
 		if (np->name && (of_node_cmp(np->name, name) == 0)
 		    && of_node_get(np))
 			break;
 	of_node_put(from);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
 EXPORT_SYMBOL(of_find_node_by_name);
@@ -516,15 +523,16 @@ struct device_node *of_find_node_by_type(struct device_node *from,
 	const char *type)
 {
 	struct device_node *np;
+	unsigned long flags;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	np = from ? from->allnext : of_allnodes;
 	for (; np; np = np->allnext)
 		if (np->type && (of_node_cmp(np->type, type) == 0)
 		    && of_node_get(np))
 			break;
 	of_node_put(from);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
 EXPORT_SYMBOL(of_find_node_by_type);
@@ -547,8 +555,9 @@ struct device_node *of_find_compatible_node(struct device_node *from,
 	const char *type, const char *compatible)
 {
 	struct device_node *np;
+	unsigned long flags;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	np = from ? from->allnext : of_allnodes;
 	for (; np; np = np->allnext) {
 		if (type
@@ -559,7 +568,7 @@ struct device_node *of_find_compatible_node(struct device_node *from,
 			break;
 	}
 	of_node_put(from);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
 EXPORT_SYMBOL(of_find_compatible_node);
@@ -581,8 +590,9 @@ struct device_node *of_find_node_with_property(struct device_node *from,
 {
 	struct device_node *np;
 	struct property *pp;
+	unsigned long flags;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	np = from ? from->allnext : of_allnodes;
 	for (; np; np = np->allnext) {
 		for (pp = np->properties; pp; pp = pp->next) {
@@ -594,7 +604,7 @@ struct device_node *of_find_node_with_property(struct device_node *from,
 	}
 out:
 	of_node_put(from);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
 EXPORT_SYMBOL(of_find_node_with_property);
@@ -635,10 +645,11 @@ const struct of_device_id *of_match_node(const struct of_device_id *matches,
 					 const struct device_node *node)
 {
 	const struct of_device_id *match;
+	unsigned long flags;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	match = __of_match_node(matches, node);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return match;
 }
 EXPORT_SYMBOL(of_match_node);
@@ -662,11 +673,12 @@ struct device_node *of_find_matching_node_and_match(struct device_node *from,
 {
 	struct device_node *np;
 	const struct of_device_id *m;
+	unsigned long flags;
 
 	if (match)
 		*match = NULL;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	np = from ? from->allnext : of_allnodes;
 	for (; np; np = np->allnext) {
 		m = __of_match_node(matches, np);
@@ -677,7 +689,7 @@ struct device_node *of_find_matching_node_and_match(struct device_node *from,
 		}
 	}
 	of_node_put(from);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
 EXPORT_SYMBOL(of_find_matching_node_and_match);
@@ -720,12 +732,12 @@ struct device_node *of_find_node_by_phandle(phandle handle)
 {
 	struct device_node *np;
 
-	read_lock(&devtree_lock);
+	raw_spin_lock(&devtree_lock);
 	for (np = of_allnodes; np; np = np->allnext)
 		if (np->phandle == handle)
 			break;
 	of_node_get(np);
-	read_unlock(&devtree_lock);
+	raw_spin_unlock(&devtree_lock);
 	return np;
 }
 EXPORT_SYMBOL(of_find_node_by_phandle);
@@ -1197,18 +1209,18 @@ int of_add_property(struct device_node *np, struct property *prop)
 		return rc;
 
 	prop->next = NULL;
-	write_lock_irqsave(&devtree_lock, flags);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	next = &np->properties;
 	while (*next) {
 		if (strcmp(prop->name, (*next)->name) == 0) {
 			/* duplicate ! don't insert it */
-			write_unlock_irqrestore(&devtree_lock, flags);
+			raw_spin_unlock_irqrestore(&devtree_lock, flags);
 			return -1;
 		}
 		next = &(*next)->next;
 	}
 	*next = prop;
-	write_unlock_irqrestore(&devtree_lock, flags);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
 #ifdef CONFIG_PROC_DEVICETREE
 	/* try to add to proc as well if it was initialized */
@@ -1238,7 +1250,7 @@ int of_remove_property(struct device_node *np, struct property *prop)
 	if (rc)
 		return rc;
 
-	write_lock_irqsave(&devtree_lock, flags);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	next = &np->properties;
 	while (*next) {
 		if (*next == prop) {
@@ -1251,7 +1263,7 @@ int of_remove_property(struct device_node *np, struct property *prop)
 		}
 		next = &(*next)->next;
 	}
-	write_unlock_irqrestore(&devtree_lock, flags);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
 	if (!found)
 		return -ENODEV;
@@ -1291,7 +1303,7 @@ int of_update_property(struct device_node *np, struct property *newprop)
 	if (!oldprop)
 		return of_add_property(np, newprop);
 
-	write_lock_irqsave(&devtree_lock, flags);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	next = &np->properties;
 	while (*next) {
 		if (*next == oldprop) {
@@ -1305,7 +1317,7 @@ int of_update_property(struct device_node *np, struct property *newprop)
 		}
 		next = &(*next)->next;
 	}
-	write_unlock_irqrestore(&devtree_lock, flags);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
 	if (!found)
 		return -ENODEV;
@@ -1378,12 +1390,12 @@ int of_attach_node(struct device_node *np)
 	if (rc)
 		return rc;
 
-	write_lock_irqsave(&devtree_lock, flags);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	np->sibling = np->parent->child;
 	np->allnext = of_allnodes;
 	np->parent->child = np;
 	of_allnodes = np;
-	write_unlock_irqrestore(&devtree_lock, flags);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
 	of_add_proc_dt_entry(np);
 	return 0;
@@ -1426,7 +1438,7 @@ int of_detach_node(struct device_node *np)
 	if (rc)
 		return rc;
 
-	write_lock_irqsave(&devtree_lock, flags);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 
 	if (of_node_check_flag(np, OF_DETACHED)) {
 		/* someone already detached it */
@@ -1463,7 +1475,7 @@ int of_detach_node(struct device_node *np)
 	}
 
 	of_node_set_flag(np, OF_DETACHED);
-	write_unlock_irqrestore(&devtree_lock, flags);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
 	of_remove_proc_dt_entry(np);
 	return rc;
diff --git a/include/linux/of.h b/include/linux/of.h
index 5ebcc5c..bb35c42 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -92,7 +92,7 @@ static inline void of_node_put(struct device_node *node) { }
 extern struct device_node *of_allnodes;
 extern struct device_node *of_chosen;
 extern struct device_node *of_aliases;
-extern rwlock_t devtree_lock;
+extern raw_spinlock_t devtree_lock;
 
 static inline bool of_have_populated_dt(void)
 {
-- 
1.8.1.2

