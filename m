Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbaCNRMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:12:10 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60061 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaCNRME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:12:04 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Grant Likely <grant.likely@linaro.org>,
        David Daney <david.daney@cavium.com>
Subject: [RFC v3 3/3] of: Make of_find_node_by_path() handle /aliases
Date: Fri, 14 Mar 2014 17:11:49 +0000
Message-Id: <1394817109-26199-4-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394817109-26199-1-git-send-email-grant.likely@linaro.org>
References: <1394817109-26199-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_find_node_by_path() handle aliases as prefixes. To make this
work the name search is refactored to search by path component instead
of by full string. This should be a more efficient search, and it makes
it possible to start a search at a subnode of a tree.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
[grant.likely: Rework to not require allocating at runtime]
Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/base.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 7083fad079a6..b8b673526dbd 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -770,9 +770,38 @@ struct device_node *of_get_child_by_name(const struct device_node *node,
 }
 EXPORT_SYMBOL(of_get_child_by_name);
 
+static struct device_node *__of_find_node_by_path(struct device_node *parent,
+						const char *path)
+{
+	struct device_node *child;
+	int len = strchrnul(path, '/') - path;
+
+	if (!len)
+		return parent;
+
+	for_each_child_of_node(parent, child) {
+		const char *name = strrchr(child->full_name, '/');
+		if (WARN(!name, "malformed device_node %s\n", child->full_name))
+			continue;
+		name++;
+		if (strncmp(path, name, len) == 0 && (strlen(name) == len))
+			return child;
+	}
+	return NULL;
+}
+
 /**
  *	of_find_node_by_path - Find a node matching a full OF path
  *	@path:	The full path to match
+ *	@path: Either the full path to match, or if the path does not
+ *	       start with '/', the name of a property of the /aliases
+ *	       node (an alias).  In the case of an alias, the node
+ *	       matching the alias' value will be returned.
+ *
+ *	Valid paths:
+ *		/foo/bar	Full path
+ *		foo		Valid alias
+ *		foo/bar		Valid alias + relative path
  *
  *	Returns a node pointer with refcount incremented, use
  *	of_node_put() on it when done.
@@ -780,13 +809,36 @@ EXPORT_SYMBOL(of_get_child_by_name);
 struct device_node *of_find_node_by_path(const char *path)
 {
 	struct device_node *np = of_allnodes;
+	struct property *pp;
 	unsigned long flags;
 
+	/* The path could begin with an alias */
+	if (*path != '/') {
+		char *p = strchrnul(path, '/');
+		int len = p - path;
+
+		/* of_aliases must not be NULL */
+		if (!of_aliases)
+			return NULL;
+
+		np = NULL;
+		for_each_property_of_node(of_aliases, pp) {
+			if (strlen(pp->name) == len && !strncmp(pp->name, path, len)) {
+				np = of_find_node_by_path(pp->value);
+				break;
+			}
+		}
+		if (!np)
+			return NULL;
+		path = p;
+	}
+
+	/* Step down the tree matching path components */
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	for (; np; np = np->allnext) {
-		if (np->full_name && (of_node_cmp(np->full_name, path) == 0)
-		    && of_node_get(np))
-			break;
+	while (np && *path == '/') {
+		path++; /* Increment past '/' delimiter */
+		np = __of_find_node_by_path(np, path);
+		path = strchrnul(path, '/');
 	}
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
-- 
1.8.3.2

