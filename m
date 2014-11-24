Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaKXWin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:38:43 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55901 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaKXWeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:34:10 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 02/14] of: Refactor __of_node_alloc() into __of_node_dup()
Date: Mon, 24 Nov 2014 22:33:30 +0000
Message-Id: <1416868422-22103-3-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a node argument to __of_node_alloc() and rename it to
__of_node_dup() so that it can also be used to duplicate a node with
its properties. This is important for the overlay code so that it can
create new nodes without using separate changeset items for every single
property.

At the same time rework the overlay code to use the new function and
drop the extra changeset items.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/dynamic.c    | 40 +++++++++++++++++++++++++++++-----------
 drivers/of/of_private.h |  2 +-
 drivers/of/unittest.c   | 14 ++++++++++----
 3 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index af1b1ecd6a3d..661ad2f5c00c 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -272,15 +272,16 @@ struct property *__of_prop_dup(const struct property *prop, gfp_t allocflags)
 }
 
 /**
- * __of_node_alloc() - Create an empty device node dynamically.
- * @full_name:	Full name of the new device node
+ * __of_node_dup() - Duplicate or create an empty device node dynamically.
+ * @fmt: Format string (plus vargs) for new full name of the device node
  *
- * Create an empty device tree node, suitable for further modification.
- * The node data are dynamically allocated and all the node flags
- * have the OF_DYNAMIC & OF_DETACHED bits set.
- * Returns the newly allocated node or NULL on out of memory error.
+ * Create an device tree node, either by duplicating an empty node or by allocating
+ * an empty one suitable for further modification.  The node data are
+ * dynamically allocated and all the node flags have the OF_DYNAMIC &
+ * OF_DETACHED bits set. Returns the newly allocated node or NULL on out of
+ * memory error.
  */
-struct device_node *__of_node_alloc(const char *fmt, ...)
+struct device_node *__of_node_dup(const struct device_node *np, const char *fmt, ...)
 {
 	va_list vargs;
 	struct device_node *node;
@@ -291,17 +292,34 @@ struct device_node *__of_node_alloc(const char *fmt, ...)
 	va_start(vargs, fmt);
 	node->full_name = kvasprintf(GFP_KERNEL, fmt, vargs);
 	va_end(vargs);
-	if (!node->full_name)
-		goto err_free;
+	if (!node->full_name) {
+		kfree(node);
+		return NULL;
+	}
 
 	of_node_set_flag(node, OF_DYNAMIC);
 	of_node_set_flag(node, OF_DETACHED);
 	of_node_init(node);
 
+	/* Iterate over and duplicate all properties */
+	if (np) {
+		struct property *pp, *new_pp;
+		for_each_property_of_node(np, pp) {
+			new_pp = __of_prop_dup(pp, GFP_KERNEL);
+			if (!new_pp)
+				goto err_prop;
+			if (__of_add_property(node, new_pp)) {
+				kfree(new_pp->name);
+				kfree(new_pp->value);
+				kfree(new_pp);
+				goto err_prop;
+			}
+		}
+	}
 	return node;
 
- err_free:
-	kfree(node);
+ err_prop:
+	of_node_put(node); /* Frees the node and properties */
 	return NULL;
 }
 
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 618abcad307e..8e882e706cd8 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -61,7 +61,7 @@ static inline int of_property_notify(int action, struct device_node *np,
  * own the devtree lock or work on detached trees only.
  */
 struct property *__of_prop_dup(const struct property *prop, gfp_t allocflags);
-__printf(1, 2) struct device_node *__of_node_alloc(const char *fmt, ...);
+__printf(2, 3) struct device_node *__of_node_dup(const struct device_node *np, const char *fmt, ...);
 
 extern const void *__of_get_property(const struct device_node *np,
 				     const char *name, int *lenp);
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 7634a17af1d5..1720b039cac7 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -445,15 +445,15 @@ static void __init of_selftest_changeset(void)
 	struct property *ppadd, padd = { .name = "prop-add", .length = 0, .value = "" };
 	struct property *ppupdate, pupdate = { .name = "prop-update", .length = 5, .value = "abcd" };
 	struct property *ppremove;
-	struct device_node *n1, *n2, *n21, *nremove, *parent;
+	struct device_node *n1, *n2, *n21, *nremove, *parent, *np;
 	struct of_changeset chgset;
 
 	of_changeset_init(&chgset);
-	n1 = __of_node_alloc("/testcase-data/changeset/n1");
+	n1 = __of_node_dup(NULL, "/testcase-data/changeset/n1");
 	selftest(n1, "testcase setup failure\n");
-	n2 = __of_node_alloc("/testcase-data/changeset/n2");
+	n2 = __of_node_dup(NULL, "/testcase-data/changeset/n2");
 	selftest(n2, "testcase setup failure\n");
-	n21 = __of_node_alloc("/testcase-data/changeset/n2/n21");
+	n21 = __of_node_dup(NULL, "%s/%s", "/testcase-data/changeset/n2", "n21");
 	selftest(n21, "testcase setup failure %p\n", n21);
 	nremove = of_find_node_by_path("/testcase-data/changeset/node-remove");
 	selftest(nremove, "testcase setup failure\n");
@@ -481,6 +481,12 @@ static void __init of_selftest_changeset(void)
 	selftest(!of_changeset_apply(&chgset), "apply failed\n");
 	mutex_unlock(&of_mutex);
 
+	/* Make sure node names are constructed correctly */
+	selftest((np = of_find_node_by_path("/testcase-data/changeset/n2/n21")),
+		 "'%s' not added\n", n21->full_name);
+	if (np)
+		of_node_put(np);
+
 	mutex_lock(&of_mutex);
 	selftest(!of_changeset_revert(&chgset), "revert failed\n");
 	mutex_unlock(&of_mutex);
-- 
1.9.1

