Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbaKUBic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:38:32 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65374 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbaKUBfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:35:31 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 3/8] of/resolver: Switch to new local fixups format.
Date: Fri, 21 Nov 2014 01:35:10 +0000
Message-Id: <1416533715-9758-4-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
References: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

The original resolver format is way too cryptic, switch
to using a tree based format that gets rid of repetitions,
is more compact and readable.

At the same time, update the selftests to using the new local fixups
format.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
[grant.likely: Squashed in testcase changes and merged similar functions]
Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/resolver.c                  | 128 ++++++++++++++++++++++++++-------
 drivers/of/unittest-data/testcases.dts |  61 +++++++++-------
 2 files changed, 139 insertions(+), 50 deletions(-)

diff --git a/drivers/of/resolver.c b/drivers/of/resolver.c
index aed7959f800d..640eb4cb46e3 100644
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
 
@@ -190,36 +191,97 @@ err_fail:
 	return err;
 }
 
+/* compare nodes taking into account that 'name' strips out the @ part */
+static int __of_node_name_cmp(const struct device_node *dn1,
+		const struct device_node *dn2)
+{
+	const char *n1 = strrchr(dn1->full_name, '/') ? : "/";
+	const char *n2 = strrchr(dn2->full_name, '/') ? : "/";
+
+	return of_node_cmp(n1, n2);
+}
+
 /*
  * Adjust the local phandle references by the given phandle delta.
- * Assumes the existances of a __local_fixups__ node at the root
- * of the tree. Does not take any devtree locks so make sure you
- * call this on a tree which is at the detached state.
+ * Assumes the existances of a __local_fixups__ node at the root.
+ * Assumes that __of_verify_tree_phandle_references has been called.
+ * Does not take any devtree locks so make sure you call this on a tree
+ * which is at the detached state.
  */
 static int __of_adjust_tree_phandle_references(struct device_node *node,
-		int phandle_delta)
+		struct device_node *target, int phandle_delta)
 {
-	struct device_node *child;
-	struct property *rprop;
-	int err;
-
-	/* locate the symbols & fixups nodes on resolve */
-	for_each_child_of_node(node, child)
-		if (of_node_cmp(child->name, "__local_fixups__") == 0)
-			break;
+	struct device_node *child, *childtarget;
+	struct property *rprop, *sprop;
+	int err, i, count;
+	unsigned int off;
+	phandle phandle;
 
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
+
+			if (phandle_delta) {
+				/* adjust */
+				phandle = be32_to_cpu(*(__be32 *)(sprop->value + off));
+				phandle += phandle_delta;
+				*(__be32 *)(sprop->value + off) = cpu_to_be32(phandle);
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
+		err = __of_adjust_tree_phandle_references(child, childtarget,
+				phandle_delta);
+		if (err != 0)
 			return err;
 	}
 
@@ -241,7 +303,7 @@ static int __of_adjust_tree_phandle_references(struct device_node *node,
  */
 int of_resolve_phandles(struct device_node *resolve)
 {
-	struct device_node *child, *refnode;
+	struct device_node *child, *childroot, *refnode;
 	struct device_node *root_sym, *resolve_sym, *resolve_fix;
 	struct property *rprop;
 	const char *refpath;
@@ -255,9 +317,23 @@ int of_resolve_phandles(struct device_node *resolve)
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
+		err = __of_adjust_tree_phandle_references(childroot,
+				resolve, 0);
+		if (err != 0)
+			return err;
+
+		BUG_ON(__of_adjust_tree_phandle_references(childroot,
+				resolve, phandle_delta));
+	}
 
 	root_sym = NULL;
 	resolve_sym = NULL;
@@ -322,7 +398,7 @@ int of_resolve_phandles(struct device_node *resolve)
 		pr_debug("%s: %s phandle is 0x%08x\n",
 				__func__, rprop->name, phandle);
 
-		err = __of_adjust_phandle_ref(resolve, rprop, phandle, false);
+		err = __of_adjust_phandle_ref(resolve, rprop, phandle);
 		if (err)
 			break;
 	}
diff --git a/drivers/of/unittest-data/testcases.dts b/drivers/of/unittest-data/testcases.dts
index 6994e15c24bf..b6bc41b2a185 100644
--- a/drivers/of/unittest-data/testcases.dts
+++ b/drivers/of/unittest-data/testcases.dts
@@ -23,28 +23,41 @@
  * this a kernel-internal data format.
  */
 / { __local_fixups__ {
-	fixup = "/testcase-data/testcase-device2:interrupt-parent:0",
-		"/testcase-data/testcase-device1:interrupt-parent:0",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:60",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:52",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:44",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:36",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:24",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:8",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:0",
-		"/testcase-data/interrupts/interrupts1:interrupt-parent:0",
-		"/testcase-data/interrupts/interrupts0:interrupt-parent:0",
-		"/testcase-data/interrupts/intmap1:interrupt-map:12",
-		"/testcase-data/interrupts/intmap0:interrupt-map:52",
-		"/testcase-data/interrupts/intmap0:interrupt-map:36",
-		"/testcase-data/interrupts/intmap0:interrupt-map:16",
-		"/testcase-data/interrupts/intmap0:interrupt-map:4",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list-bad-args:12",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list-bad-args:0",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:56",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:52",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:40",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:24",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:8",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:0";
+	testcase-data {
+		phandle-tests {
+			consumer-a {
+				phandle-list = <0x00000000 0x00000008
+						0x00000018 0x00000028
+						0x00000034 0x00000038>;
+				phandle-list-bad-args = <0x00000000 0x0000000c>;
+			};
+		};
+		interrupts {
+			intmap0 {
+				interrupt-map = <0x00000004 0x00000010
+						 0x00000024 0x00000034>;
+			};
+			intmap1 {
+				interrupt-map = <0x0000000c>;
+			};
+			interrupts0 {
+				interrupt-parent = <0x00000000>;
+			};
+			interrupts1 {
+				interrupt-parent = <0x00000000>;
+			};
+			interrupts-extended0 {
+				interrupts-extended = <0x00000000 0x00000008
+						       0x00000018 0x00000024
+						       0x0000002c 0x00000034
+						       0x0000003c>;
+			};
+		};
+		testcase-device1 {
+			interrupt-parent = <0x00000000>;
+		};
+		testcase-device2 {
+			interrupt-parent = <0x00000000>;
+		};
+	};
 }; };
-- 
1.9.1

