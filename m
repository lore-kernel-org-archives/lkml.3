Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3LMSJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 13:09:11 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:38217 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489Ab3LMSJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:09:08 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
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
        linux-kernel@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH] OF: kobj node lifecycle fixes
Date: Fri, 13 Dec 2013 20:08:59 +0200
Message-Id: <1386958139-6130-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the move to having device nodes be proper kobjects the lifecycle
of the node needs to be controlled better.

At first convert of_add_node() in the unflattened functions to
of_init_node() which initializes the kobject so that of_node_get/put
work correctly even before of_init is called.

Afterwards introduce of_node_is_initialized & of_node_is_attached that
query the underlying kobject about the state (attached means kobj
is visible in sysfs)

Using that make sure the lifecycle of the tree is correct at all
times.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/of/base.c  | 96 ++++++++++++++++++++++++++++++++++++++++++++----------
 drivers/of/fdt.c   |  3 +-
 include/linux/of.h | 15 +++++++++
 3 files changed, 95 insertions(+), 19 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 78cd546..39dda4c 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -245,45 +245,104 @@ static int __of_node_add(struct device_node *np)
 int of_node_add(struct device_node *np)
 {
 	int rc = 0;
-	kobject_init(&np->kobj, &of_node_ktype);
+
+	BUG_ON(!of_node_is_initialized(np));
+
+	if (!of_kset) {
+		pr_warn("%s: of_node_add before of_init on %s\n",
+				__func__, np->full_name);
+		return 0;
+	}
+
 	mutex_lock(&of_aliases_mutex);
-	if (of_kset)
-		rc = __of_node_add(np);
+	rc = __of_node_add(np);
 	mutex_unlock(&of_aliases_mutex);
 	return rc;
 }
 
+/*
+ * Initialize a new device node
+ *
+ * At the moment it is just initializing the kobj of the node.
+ * This occurs during unflattening and when creating dynamic nodes.
+ */
+void of_node_init(struct device_node *np)
+{
+	kobject_init(&np->kobj, &of_node_ktype);
+}
+
 #if defined(CONFIG_OF_DYNAMIC)
 static void of_node_remove(struct device_node *np)
 {
 	struct property *pp;
 
-	for_each_property_of_node(np, pp)
-		sysfs_remove_bin_file(&np->kobj, &pp->attr);
+	BUG_ON(!of_node_is_initialized(np));
+
+	/* only remove properties if on sysfs */
+	if (of_node_is_attached(np)) {
+		for_each_property_of_node(np, pp)
+			sysfs_remove_bin_file(&np->kobj, &pp->attr);
+		/* delete from sysfs */
+		kobject_del(&np->kobj);
+	}
 
-	kobject_del(&np->kobj);
+	/* finally remove the kobj_init ref */
+	of_node_put(np);
 }
 #endif
 
+/* recursively attach the tree */
+static __init int __of_populate(struct device_node *np)
+{
+	struct device_node *child;
+	int rc;
+
+	/* add the parent first */
+	rc = __of_node_add(np);
+	if (rc)
+		return rc;
+
+	/* the children afterwards */
+	__for_each_child_of_node(np, child) {
+		rc = __of_populate(child);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 static int __init of_init(void)
 {
 	struct device_node *np;
+	int rc;
 
 	of_kset = kset_create_and_add("devicetree", NULL, firmware_kobj);
 	if (!of_kset)
 		return -ENOMEM;
 
-	/* Make sure all nodes added before this time get added to sysfs */
 	mutex_lock(&of_aliases_mutex);
-	for_each_of_allnodes(np)
-		__of_node_add(np);
-	mutex_unlock(&of_aliases_mutex);
+
+	/* find root */
+	np = of_find_node_by_path("/");
+	if (np == NULL) {
+		rc = -EINVAL;
+		goto out;
+	}
+	/* populate */
+	rc = __of_populate(np);
+	of_node_put(np);
 
 	/* Symlink in /proc as required by userspace ABI */
-	if (of_allnodes)
-		proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base");
+	if (rc != 0)
+		goto out;
 
-	return 0;
+	proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base");
+
+out:
+	mutex_unlock(&of_aliases_mutex);
+
+	return rc;
 }
 core_initcall(of_init);
 
@@ -1587,6 +1646,10 @@ static int of_property_notify(int action, struct device_node *np,
 {
 	struct of_prop_reconfig pr;
 
+	/* only call notifiers if the node is attached */
+	if (!of_node_is_attached(np))
+		return 0;
+
 	pr.dn = np;
 	pr.prop = prop;
 	return of_reconfig_notify(action, &pr);
@@ -1626,11 +1689,8 @@ int of_add_property(struct device_node *np, struct property *prop)
 	*next = prop;
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
-	/* at early boot, bail hear and defer setup to of_init() */
-	if (!of_kset)
-		return 0;
-
-	__of_add_property(np, prop);
+	if (of_node_is_attached(np))
+		__of_add_property(np, prop);
 
 	return 0;
 }
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index d5d62cd..3ca75fb 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -327,7 +327,8 @@ static void * unflatten_dt_node(struct boot_param_header *blob,
 		if (!np->type)
 			np->type = "<NULL>";
 
-		of_node_add(np);
+		/* initialize node (do not add) */
+		of_node_init(np);
 	}
 	while (tag == OF_DT_BEGIN_NODE || tag == OF_DT_NOP) {
 		if (tag == OF_DT_NOP)
diff --git a/include/linux/of.h b/include/linux/of.h
index f285222..f13e773 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -76,6 +76,21 @@ struct of_phandle_args {
 
 extern int of_node_add(struct device_node *node);
 
+/* initialize a node */
+extern void of_node_init(struct device_node *node);
+
+/* true when node is initialized */
+static inline int of_node_is_initialized(struct device_node *node)
+{
+	return node && node->kobj.state_initialized;
+}
+
+/* true when node is attached (i.e. present on sysfs) */
+static inline int of_node_is_attached(struct device_node *node)
+{
+	return node && node->kobj.state_in_sysfs;
+}
+
 #ifdef CONFIG_OF_DYNAMIC
 extern struct device_node *of_node_get(struct device_node *node);
 extern void of_node_put(struct device_node *node);
-- 
1.7.12

