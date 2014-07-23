Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbaGWXqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:46:16 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:52341 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604AbaGWXok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:44:40 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, Nathan Fontenot <nfont@austin.ibm.com>,
        Tyrel Datwyler <turtle.in.the.kernel@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 06/10] of: Make devicetree sysfs update functions consistent.
Date: Wed, 23 Jul 2014 17:44:20 -0600
Message-Id: <1406159064-21366-7-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
References: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the DT modification functions are split into two parts, the first
part manipulates the DT data structure, and the second part updates
sysfs, but the code isn't very consistent about how the second half is
called. They don't all enforce the same rules about when it is valid to
update sysfs, and there isn't any clarity on locking.

The transactional DT modification feature that is coming also needs
access to these functions so that it can perform all the structure
changes together, and then all the sysfs updates as a second stage
instead of doing each one at a time.

Fix up the second have by creating a separate __of_*_sysfs() function
for each of the helpers. The new functions have consistent naming (ie.
of_node_add() becomes __of_attach_node_sysfs()) and all of them now
defer if of_init hasn't been called yet.

Callers of the new functions must hold the of_mutex to ensure there are
no race conditions with of_init(). The mutex ensures that there will
only ever be one writer to the tree at any given time. There can still
be any number of readers and the raw_spin_lock is still used to make
sure access to the data structure is still consistent.

Finally, put the function prototypes into of_private.h so they are
accessible to the transaction code.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
[grant.likely: Changed suffix from _post to _sysfs to match existing code]
[grant.likely: Reorganized to eliminate trivial wrappers]
Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/base.c       | 96 +++++++++++++++++++++++++------------------------
 drivers/of/dynamic.c    | 12 +++++--
 drivers/of/of_private.h | 10 ++++++
 include/linux/of.h      |  2 --
 4 files changed, 69 insertions(+), 51 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index b403f9d98461..ad4929cbd876 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -37,10 +37,13 @@ struct device_node *of_chosen;
 struct device_node *of_aliases;
 static struct device_node *of_stdout;
 
-static struct kset *of_kset;
+struct kset *of_kset;
 
 /*
- * Used to protect the of_aliases, to hold off addition of nodes to sysfs
+ * Used to protect the of_aliases, to hold off addition of nodes to sysfs.
+ * This mutex must be held whenever modifications are being made to the
+ * device tree. The of_{attach,detach}_node() and
+ * of_{add,remove,update}_property() helpers make sure this happens.
  */
 DEFINE_MUTEX(of_mutex);
 
@@ -127,13 +130,16 @@ static const char *safe_name(struct kobject *kobj, const char *orig_name)
 	return name;
 }
 
-static int __of_add_property_sysfs(struct device_node *np, struct property *pp)
+int __of_add_property_sysfs(struct device_node *np, struct property *pp)
 {
 	int rc;
 
 	/* Important: Don't leak passwords */
 	bool secure = strncmp(pp->name, "security-", 9) == 0;
 
+	if (!of_kset || !of_node_is_attached(np))
+		return 0;
+
 	sysfs_bin_attr_init(&pp->attr);
 	pp->attr.attr.name = safe_name(&np->kobj, pp->name);
 	pp->attr.attr.mode = secure ? S_IRUSR : S_IRUGO;
@@ -145,12 +151,15 @@ static int __of_add_property_sysfs(struct device_node *np, struct property *pp)
 	return rc;
 }
 
-static int __of_node_add(struct device_node *np)
+int __of_attach_node_sysfs(struct device_node *np)
 {
 	const char *name;
 	struct property *pp;
 	int rc;
 
+	if (!of_kset)
+		return 0;
+
 	np->kobj.kset = of_kset;
 	if (!np->parent) {
 		/* Nodes without parents are new top level trees */
@@ -172,26 +181,6 @@ static int __of_node_add(struct device_node *np)
 	return 0;
 }
 
-int of_node_add(struct device_node *np)
-{
-	int rc = 0;
-
-	BUG_ON(!of_node_is_initialized(np));
-
-	/*
-	 * Grab the mutex here so that in a race condition between of_init() and
-	 * of_node_add(), node addition will still be consistent.
-	 */
-	mutex_lock(&of_mutex);
-	if (of_kset)
-		rc = __of_node_add(np);
-	else
-		/* This scenario may be perfectly valid, but report it anyway */
-		pr_info("of_node_add(%s) before of_init()\n", np->full_name);
-	mutex_unlock(&of_mutex);
-	return rc;
-}
-
 static int __init of_init(void)
 {
 	struct device_node *np;
@@ -204,7 +193,7 @@ static int __init of_init(void)
 		return -ENOMEM;
 	}
 	for_each_of_allnodes(np)
-		__of_node_add(np);
+		__of_attach_node_sysfs(np);
 	mutex_unlock(&of_mutex);
 
 	/* Symlink in /proc as required by userspace ABI */
@@ -1689,15 +1678,17 @@ int of_add_property(struct device_node *np, struct property *prop)
 	if (rc)
 		return rc;
 
+	mutex_lock(&of_mutex);
+
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	rc = __of_add_property(np, prop);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
-	if (rc)
-		return rc;
 
-	if (of_node_is_attached(np))
+	if (!rc)
 		__of_add_property_sysfs(np, prop);
 
+	mutex_unlock(&of_mutex);
+
 	return rc;
 }
 
@@ -1720,6 +1711,13 @@ int __of_remove_property(struct device_node *np, struct property *prop)
 	return 0;
 }
 
+void __of_remove_property_sysfs(struct device_node *np, struct property *prop)
+{
+	/* at early boot, bail here and defer setup to of_init() */
+	if (of_kset && of_node_is_attached(np))
+		sysfs_remove_bin_file(&np->kobj, &prop->attr);
+}
+
 /**
  * of_remove_property - Remove a property from a node.
  *
@@ -1737,20 +1735,18 @@ int of_remove_property(struct device_node *np, struct property *prop)
 	if (rc)
 		return rc;
 
+	mutex_lock(&of_mutex);
+
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	rc = __of_remove_property(np, prop);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
-	if (rc)
-		return rc;
-
-	/* at early boot, bail hear and defer setup to of_init() */
-	if (!of_kset)
-		return 0;
+	if (!rc)
+		__of_remove_property_sysfs(np, prop);
 
-	sysfs_remove_bin_file(&np->kobj, &prop->attr);
+	mutex_unlock(&of_mutex);
 
-	return 0;
+	return rc;
 }
 
 int __of_update_property(struct device_node *np, struct property *newprop,
@@ -1779,6 +1775,18 @@ int __of_update_property(struct device_node *np, struct property *newprop,
 	return 0;
 }
 
+void __of_update_property_sysfs(struct device_node *np, struct property *newprop,
+		struct property *oldprop)
+{
+	/* At early boot, bail out and defer setup to of_init() */
+	if (!of_kset)
+		return;
+
+	if (oldprop)
+		sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
+	__of_add_property_sysfs(np, newprop);
+}
+
 /*
  * of_update_property - Update a property in a node, if the property does
  * not exist, add it.
@@ -1801,22 +1809,18 @@ int of_update_property(struct device_node *np, struct property *newprop)
 	if (rc)
 		return rc;
 
+	mutex_lock(&of_mutex);
+
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	rc = __of_update_property(np, newprop, &oldprop);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
-	if (rc)
-		return rc;
 
-	/* At early boot, bail out and defer setup to of_init() */
-	if (!of_kset)
-		return 0;
+	if (!rc)
+		__of_update_property_sysfs(np, newprop, oldprop);
 
-	/* Update the sysfs attribute */
-	if (oldprop)
-		sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
-	__of_add_property_sysfs(np, newprop);
+	mutex_unlock(&of_mutex);
 
-	return 0;
+	return rc;
 }
 
 static void of_alias_add(struct alias_prop *ap, struct device_node *np,
diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index 75fcc66fcefd..c875787fa394 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -41,11 +41,13 @@ void of_node_put(struct device_node *node)
 }
 EXPORT_SYMBOL(of_node_put);
 
-static void of_node_remove(struct device_node *np)
+void __of_detach_node_sysfs(struct device_node *np)
 {
 	struct property *pp;
 
 	BUG_ON(!of_node_is_initialized(np));
+	if (!of_kset)
+		return;
 
 	/* only remove properties if on sysfs */
 	if (of_node_is_attached(np)) {
@@ -115,11 +117,13 @@ int of_attach_node(struct device_node *np)
 	if (rc)
 		return rc;
 
+	mutex_lock(&of_mutex);
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	__of_attach_node(np);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
-	of_node_add(np);
+	__of_attach_node_sysfs(np);
+	mutex_unlock(&of_mutex);
 	return 0;
 }
 
@@ -174,11 +178,13 @@ int of_detach_node(struct device_node *np)
 	if (rc)
 		return rc;
 
+	mutex_lock(&of_mutex);
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	__of_detach_node(np);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
-	of_node_remove(np);
+	__of_detach_node_sysfs(np);
+	mutex_unlock(&of_mutex);
 	return rc;
 }
 
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 0f6089722af9..0d99ba8caeed 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -33,6 +33,8 @@ struct alias_prop {
 
 extern struct mutex of_mutex;
 extern struct list_head aliases_lookup;
+extern struct kset *of_kset;
+
 
 static inline struct device_node *kobj_to_device_node(struct kobject *kobj)
 {
@@ -62,11 +64,19 @@ struct property *__of_prop_dup(const struct property *prop, gfp_t allocflags);
 struct device_node *__of_node_alloc(const char *full_name, gfp_t allocflags);
 
 extern int __of_add_property(struct device_node *np, struct property *prop);
+extern int __of_add_property_sysfs(struct device_node *np,
+		struct property *prop);
 extern int __of_remove_property(struct device_node *np, struct property *prop);
+extern void __of_remove_property_sysfs(struct device_node *np,
+		struct property *prop);
 extern int __of_update_property(struct device_node *np,
 		struct property *newprop, struct property **oldprop);
+extern void __of_update_property_sysfs(struct device_node *np,
+		struct property *newprop, struct property *oldprop);
 
 extern void __of_attach_node(struct device_node *np);
+extern int __of_attach_node_sysfs(struct device_node *np);
 extern void __of_detach_node(struct device_node *np);
+extern void __of_detach_node_sysfs(struct device_node *np);
 
 #endif /* _LINUX_OF_PRIVATE_H */
diff --git a/include/linux/of.h b/include/linux/of.h
index abf829a1f150..705fa12fca7f 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -74,8 +74,6 @@ struct of_phandle_args {
 	uint32_t args[MAX_PHANDLE_ARGS];
 };
 
-extern int of_node_add(struct device_node *node);
-
 /* initialize a node */
 extern struct kobj_type of_node_ktype;
 static inline void of_node_init(struct device_node *node)
-- 
1.9.1

