Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaJ1UeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:34:10 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63827 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaJ1UeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:34:06 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 1/5] of: resolver: Switch to new local fixups format.
Date: Tue, 28 Oct 2014 22:33:49 +0200
Message-Id: <1414528433-9650-2-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1414528433-9650-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1414528433-9650-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original resolver format is way too cryptic, switch
to using a tree based format that gets rid of repetitions,
is more compact and readable.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/of/resolver.c | 191 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 165 insertions(+), 26 deletions(-)

diff --git a/drivers/of/resolver.c b/drivers/of/resolver.c
index aed7959..0224348 100644
--- a/drivers/of/resolver.c
+++ b/drivers/of/resolver.c
@@ -111,7 +111,8 @@ static void __of_adjust_tree_phandles(struct device_node *node,
 		__of_adjust_tree_phandles(child, phandle_delta);
 }
 
-static int __of_adjust_phandle_ref(struct device_node *node, struct property *rprop, int value, bool is_delta)
+static int __of_adjust_phandle_ref(struct device_node *node,
+		struct property *rprop, int value)
 {
 	phandle phandle;
 	struct device_node *refnode;
@@ -181,7 +182,7 @@ static int __of_adjust_phandle_ref(struct device_node *node, struct property *rp
 			goto err_fail;
 		}
 
-		phandle = is_delta ? be32_to_cpup(sprop->value + offset) + value : value;
+		phandle = value;
 		*(__be32 *)(sprop->value + offset) = cpu_to_be32(phandle);
 	}
 
@@ -190,42 +191,166 @@ err_fail:
 	return err;
 }
 
+/* compare nodes taking into account that 'name' strips out the @ part */
+static int __of_node_name_cmp(const struct device_node *dn1,
+		const struct device_node *dn2)
+{
+	const char *n1;
+	const char *n2;
+
+	n1 = strrchr(dn1->full_name, '/');
+	if (n1 == NULL)
+		n1 = "/";
+
+	n2 = strrchr(dn2->full_name, '/');
+	if (n2 == NULL)
+		n2 = "/";
+
+	return of_node_cmp(n1, n2);
+}
+
 /*
- * Adjust the local phandle references by the given phandle delta.
- * Assumes the existances of a __local_fixups__ node at the root
+ * Verify that the local phandle references are correct.
+ * Assumes the existence of a __local_fixups__ node at the root
  * of the tree. Does not take any devtree locks so make sure you
  * call this on a tree which is at the detached state.
  */
-static int __of_adjust_tree_phandle_references(struct device_node *node,
-		int phandle_delta)
+static int __of_verify_tree_phandle_references(struct device_node *node,
+		struct device_node *target)
 {
-	struct device_node *child;
-	struct property *rprop;
-	int err;
+	struct device_node *child, *childtarget;
+	struct property *rprop, *sprop;
+	int err, i, count;
+	unsigned int off;
 
-	/* locate the symbols & fixups nodes on resolve */
-	for_each_child_of_node(node, child)
-		if (of_node_cmp(child->name, "__local_fixups__") == 0)
-			break;
-
-	/* no local fixups */
-	if (!child)
+	if (node == NULL)
 		return 0;
 
-	/* find the local fixups property */
-	for_each_property_of_node(child, rprop) {
+	for_each_property_of_node(node, rprop) {
+
 		/* skip properties added automatically */
-		if (of_prop_cmp(rprop->name, "name") == 0)
+		if (of_prop_cmp(rprop->name, "name") == 0 ||
+		    of_prop_cmp(rprop->name, "phandle") == 0 ||
+		    of_prop_cmp(rprop->name, "linux,phandle") == 0)
 			continue;
 
-		err = __of_adjust_phandle_ref(node, rprop, phandle_delta, true);
-		if (err)
+		if ((rprop->length % 4) != 0 || rprop->length == 0) {
+			pr_err("%s: Illegal property (size) '%s' @%s\n",
+					__func__, rprop->name, node->full_name);
+			return -EINVAL;
+		}
+		count = rprop->length / sizeof(__be32);
+
+		/* now find the target property */
+		for_each_property_of_node(target, sprop) {
+			if (of_prop_cmp(sprop->name, rprop->name) == 0)
+				break;
+		}
+
+		if (sprop == NULL) {
+			pr_err("%s: Could not find target property '%s' @%s\n",
+					__func__, rprop->name, node->full_name);
+			return -EINVAL;
+		}
+
+		for (i = 0; i < count; i++) {
+			off = be32_to_cpu(((__be32 *)rprop->value)[i]);
+			/* make sure the offset doesn't overstep (even wrap) */
+			if (off >= sprop->length ||
+					(off + 4) > sprop->length) {
+				pr_err("%s: Illegal property '%s' @%s\n",
+						__func__, rprop->name,
+						node->full_name);
+				return -EINVAL;
+			}
+		}
+	}
+
+	for_each_child_of_node(node, child) {
+
+		for_each_child_of_node(target, childtarget)
+			if (__of_node_name_cmp(child, childtarget) == 0)
+				break;
+
+		if (!childtarget) {
+			pr_err("%s: Could not find target child '%s' @%s\n",
+					__func__, child->name, node->full_name);
+			return -EINVAL;
+		}
+
+		err = __of_verify_tree_phandle_references(child, childtarget);
+		if (err != 0)
 			return err;
 	}
 
 	return 0;
 }
 
+/*
+ * Adjust the local phandle references by the given phandle delta.
+ * Assumes the existances of a __local_fixups__ node at the root.
+ * Assumes that __of_verify_tree_phandle_references has been called.
+ * Does not take any devtree locks so make sure you call this on a tree
+ * which is at the detached state.
+ */
+static void __of_adjust_tree_phandle_references(struct device_node *node,
+		struct device_node *target, int phandle_delta)
+{
+	struct device_node *child, *childtarget;
+	struct property *rprop, *sprop;
+	int i, count;
+	unsigned int off;
+	phandle phandle;
+
+	if (node == NULL)
+		return;
+
+	for_each_property_of_node(node, rprop) {
+
+		/* skip properties added automatically */
+		if (of_prop_cmp(rprop->name, "name") == 0 ||
+		    of_prop_cmp(rprop->name, "phandle") == 0 ||
+		    of_prop_cmp(rprop->name, "linux,phandle") == 0)
+			continue;
+
+		BUG_ON((rprop->length % 4) != 0 || rprop->length == 0);
+
+		count = rprop->length / sizeof(__be32);
+
+		/* now find the target property */
+		for_each_property_of_node(target, sprop) {
+			if (of_prop_cmp(sprop->name, rprop->name) == 0)
+				break;
+		}
+
+		BUG_ON(sprop == NULL);
+
+		for (i = 0; i < count; i++) {
+			off = be32_to_cpu(((__be32 *)rprop->value)[i]);
+			/* make sure the offset doesn't overstep (even wrap) */
+			BUG_ON(off >= sprop->length ||
+					(off + 4) > sprop->length);
+
+			/* adjust */
+			phandle = be32_to_cpu(*(__be32 *)(sprop->value + off));
+			phandle += phandle_delta;
+			*(__be32 *)(sprop->value + off) = cpu_to_be32(phandle);
+		}
+	}
+
+	for_each_child_of_node(node, child) {
+
+		for_each_child_of_node(target, childtarget)
+			if (__of_node_name_cmp(child, childtarget) == 0)
+				break;
+
+		BUG_ON(childtarget == NULL);
+
+		__of_adjust_tree_phandle_references(child, childtarget,
+				phandle_delta);
+	}
+}
+
 /**
  * of_resolve	- Resolve the given node against the live tree.
  *
@@ -241,7 +366,7 @@ static int __of_adjust_tree_phandle_references(struct device_node *node,
  */
 int of_resolve_phandles(struct device_node *resolve)
 {
-	struct device_node *child, *refnode;
+	struct device_node *child, *childroot, *refnode;
 	struct device_node *root_sym, *resolve_sym, *resolve_fix;
 	struct property *rprop;
 	const char *refpath;
@@ -255,9 +380,23 @@ int of_resolve_phandles(struct device_node *resolve)
 	/* first we need to adjust the phandles */
 	phandle_delta = of_get_tree_max_phandle() + 1;
 	__of_adjust_tree_phandles(resolve, phandle_delta);
-	err = __of_adjust_tree_phandle_references(resolve, phandle_delta);
-	if (err != 0)
-		return err;
+
+	/* locate the local fixups */
+	childroot = NULL;
+	for_each_child_of_node(resolve, childroot)
+		if (of_node_cmp(childroot->name, "__local_fixups__") == 0)
+			break;
+
+	if (childroot != NULL) {
+		/* resolve root is guaranteed to be the '/' */
+		err = __of_verify_tree_phandle_references(childroot,
+				resolve);
+		if (err != 0)
+			return err;
+
+		__of_adjust_tree_phandle_references(childroot,
+				resolve, phandle_delta);
+	}
 
 	root_sym = NULL;
 	resolve_sym = NULL;
@@ -322,7 +461,7 @@ int of_resolve_phandles(struct device_node *resolve)
 		pr_debug("%s: %s phandle is 0x%08x\n",
 				__func__, rprop->name, phandle);
 
-		err = __of_adjust_phandle_ref(resolve, rprop, phandle, false);
+		err = __of_adjust_phandle_ref(resolve, rprop, phandle);
 		if (err)
 			break;
 	}
-- 
1.7.12

