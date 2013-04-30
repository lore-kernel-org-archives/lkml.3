Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab3D3HMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:12:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56083 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616Ab3D3HLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:11:31 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 1/4] OF: add a new phandle parsing function for grouped nodes
Date: Tue, 30 Apr 2013 09:11:20 +0200
Message-Id: <1367305883-2997-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
References: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:vHQbOrcZ34tI5B5b5aVIQYOJMEBOa+gim++xQ1bT384
 T6QsQVUv9f6z0IFdYAd/WVwDpJRr1+SnjkTJruXOE8QApn1iRL
 7LtmL7yJ+QkK7FT+cZMT+hhImc3xcJAmJHPb+PsKUO4Roc3auJ
 tBtraGWATMl3CvfnRtKpdiGvoucHNVr5eHi/ftsqzgDqqHKv47
 EhKdQKyoO/ZRfsiuys5V7Vm6hsyhVs9F3cJ1lbkoVzsLOFZ5rQ
 xijqw4zbeZUAqkcoEst2tOXIx/mV10ehE7jafY+kuBY4ZpRyAN
 sWsTqC0nEPvureb6ZPBRs036nrylCN8vj3jcBdpxs8ZT4I+6r9
 Bqinxeb066CewkqdqzcM8Fm2+mV7gAuMtFT6y1G28PksFQMLDE
 +26jp2/MzPs7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it is useful to group similar DT nodes under a common parent,
when a different node can reference the group, meaning, that any subnode
will do the job. An example of such a group is a DMA multiplexer, when a
DMA slave can be served by any DMA controller from the group. This patch
slightly extends an internal __of_parse_phandle_with_args() function to
accept one more optional parameter and exports a new API function
of_parse_phandle_with_child_args(), which allows the caller to provide a
compatibility string for a group. In this case the function returns the
first matching node. Once a matching node is found, standard DT iterators
can be used to look for further matches.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/of/base.c  |   28 +++++++++++++++++++++++++---
 include/linux/of.h |   16 ++++++++++++++++
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 321d3ef..d114515 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1066,11 +1066,16 @@ EXPORT_SYMBOL(of_parse_phandle);
  * @cells_name:	property name that specifies phandles' arguments count
  * @index:	index of a phandle to parse out
  * @out_args:	optional pointer to output arguments structure (will be filled)
+ * @parent:	optional parent-compatibility string
  *
  * This function is useful to parse lists of phandles and their arguments.
  * Returns 0 on success and fills out_args, on error returns appropriate
  * errno value.
  *
+ * If @parent is specified and the DT node, pointed by the currently iterated
+ * phandle is compatible with it, it is assumed, that the phandle is a parent of
+ * DT nodes with equal cell counts. In that case the first child is taken.
+ *
  * Caller is responsible to call of_node_put() on the returned out_args->node
  * pointer.
  *
@@ -1094,7 +1099,8 @@ EXPORT_SYMBOL(of_parse_phandle);
 static int __of_parse_phandle_with_args(const struct device_node *np,
 					const char *list_name,
 					const char *cells_name, int index,
-					struct of_phandle_args *out_args)
+					struct of_phandle_args *out_args,
+					const char *parent)
 {
 	const __be32 *list, *list_end;
 	int rc = 0, size, cur_index = 0;
@@ -1129,6 +1135,12 @@ static int __of_parse_phandle_with_args(const struct device_node *np,
 					 np->full_name);
 				goto err;
 			}
+			if (parent && of_device_is_compatible(node, parent)) {
+				struct device_node *child =
+					of_get_next_available_child(node, NULL);
+				of_node_put(node);
+				node = child;
+			}
 			if (of_property_read_u32(node, cells_name, &count)) {
 				pr_err("%s: could not get %s for %s\n",
 					 np->full_name, cells_name,
@@ -1199,10 +1211,20 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 {
 	if (index < 0)
 		return -EINVAL;
-	return __of_parse_phandle_with_args(np, list_name, cells_name, index, out_args);
+	return __of_parse_phandle_with_args(np, list_name, cells_name, index, out_args, NULL);
 }
 EXPORT_SYMBOL(of_parse_phandle_with_args);
 
+int of_parse_phandle_with_child_args(const struct device_node *np, const char *list_name,
+				     const char *cells_name, int index,
+				     struct of_phandle_args *out_args, const char *parent)
+{
+	if (index < 0)
+		return -EINVAL;
+	return __of_parse_phandle_with_args(np, list_name, cells_name, index, out_args, parent);
+}
+EXPORT_SYMBOL(of_parse_phandle_with_child_args);
+
 /**
  * of_count_phandle_with_args() - Find the number of phandles references in a property
  * @np:		pointer to a device tree node containing a list
@@ -1221,7 +1243,7 @@ EXPORT_SYMBOL(of_parse_phandle_with_args);
 int of_count_phandle_with_args(const struct device_node *np, const char *list_name,
 				const char *cells_name)
 {
-	return __of_parse_phandle_with_args(np, list_name, cells_name, -1, NULL);
+	return __of_parse_phandle_with_args(np, list_name, cells_name, -1, NULL, NULL);
 }
 EXPORT_SYMBOL(of_count_phandle_with_args);
 
diff --git a/include/linux/of.h b/include/linux/of.h
index a0f1292..30ae71f 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -277,6 +277,12 @@ extern struct device_node *of_parse_phandle(const struct device_node *np,
 extern int of_parse_phandle_with_args(const struct device_node *np,
 	const char *list_name, const char *cells_name, int index,
 	struct of_phandle_args *out_args);
+extern int of_parse_phandle_with_child_args(const struct device_node *np,
+					    const char *list_name,
+					    const char *cells_name,
+					    int index,
+					    struct of_phandle_args *out_args,
+					    const char *parent);
 extern int of_count_phandle_with_args(const struct device_node *np,
 	const char *list_name, const char *cells_name);
 
@@ -469,6 +475,16 @@ static inline int of_parse_phandle_with_args(struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline int of_parse_phandle_with_child_args(const struct device_node *np,
+						   const char *list_name,
+						   const char *cells_name,
+						   int index,
+						   struct of_phandle_args *out_args,
+						   const char *parent)
+{
+	return -ENOSYS;
+}
+
 static inline int of_count_phandle_with_args(struct device_node *np,
 					     const char *list_name,
 					     const char *cells_name)
-- 
1.7.2.5

