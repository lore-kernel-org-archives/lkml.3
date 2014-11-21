Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbaKUBgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:36:54 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39180 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbaKUBfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:35:31 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 1/8] of: Use vargs in __of_node_alloc
Date: Fri, 21 Nov 2014 01:35:08 +0000
Message-Id: <1416533715-9758-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
References: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The overlay code needs to construct a new full_name from the parent name
and the node name, but the current method has to allocate and then free
an temporary string which is wasteful. Fix this problem by using vargs
to pass in a format and arguments into __of_node_alloc().

At the same time remove the allocflags argument to __of_node_alloc().
The only users all use GFP_KERNEL, so there is no need to provide it as
an option. If there is ever a need later it can be added back.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/dynamic.c    | 16 ++++++++--------
 drivers/of/of_private.h |  2 +-
 drivers/of/unittest.c   |  6 +++---
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index da2509d639c8..2d452be1200b 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -274,33 +274,33 @@ struct property *__of_prop_dup(const struct property *prop, gfp_t allocflags)
 /**
  * __of_node_alloc() - Create an empty device node dynamically.
  * @full_name:	Full name of the new device node
- * @allocflags:	Allocation flags (typically pass GFP_KERNEL)
  *
  * Create an empty device tree node, suitable for further modification.
  * The node data are dynamically allocated and all the node flags
  * have the OF_DYNAMIC & OF_DETACHED bits set.
  * Returns the newly allocated node or NULL on out of memory error.
  */
-struct device_node *__of_node_alloc(const char *full_name, gfp_t allocflags)
+struct device_node *__of_node_alloc(const char *fmt, ...)
 {
+	va_list vargs;
 	struct device_node *node;
 
-	node = kzalloc(sizeof(*node), allocflags);
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
 	if (!node)
 		return NULL;
-
-	node->full_name = kstrdup(full_name, allocflags);
-	of_node_set_flag(node, OF_DYNAMIC);
-	of_node_set_flag(node, OF_DETACHED);
+	va_start(vargs, fmt);
+	node->full_name = kvasprintf(GFP_KERNEL, fmt, vargs);
+	va_end(vargs);
 	if (!node->full_name)
 		goto err_free;
 
+	of_node_set_flag(node, OF_DYNAMIC);
+	of_node_set_flag(node, OF_DETACHED);
 	of_node_init(node);
 
 	return node;
 
  err_free:
-	kfree(node->full_name);
 	kfree(node);
 	return NULL;
 }
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 858e0a5d9a11..1e21b1c6de71 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -61,7 +61,7 @@ static inline int of_property_notify(int action, struct device_node *np,
  * own the devtree lock or work on detached trees only.
  */
 struct property *__of_prop_dup(const struct property *prop, gfp_t allocflags);
-struct device_node *__of_node_alloc(const char *full_name, gfp_t allocflags);
+struct device_node *__of_node_alloc(const char *fmt, ...);
 
 extern const void *__of_get_property(const struct device_node *np,
 				     const char *name, int *lenp);
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 082bb2b6a5ad..79630760ea4f 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -449,11 +449,11 @@ static void __init of_selftest_changeset(void)
 	struct of_changeset chgset;
 
 	of_changeset_init(&chgset);
-	n1 = __of_node_alloc("/testcase-data/changeset/n1", GFP_KERNEL);
+	n1 = __of_node_alloc("/testcase-data/changeset/n1");
 	selftest(n1, "testcase setup failure\n");
-	n2 = __of_node_alloc("/testcase-data/changeset/n2", GFP_KERNEL);
+	n2 = __of_node_alloc("/testcase-data/changeset/n2");
 	selftest(n2, "testcase setup failure\n");
-	n21 = __of_node_alloc("/testcase-data/changeset/n2/n21", GFP_KERNEL);
+	n21 = __of_node_alloc("/testcase-data/changeset/n2/n21");
 	selftest(n21, "testcase setup failure %p\n", n21);
 	nremove = of_find_node_by_path("/testcase-data/changeset/node-remove");
 	selftest(nremove, "testcase setup failure\n");
-- 
1.9.1

