Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbaCRVwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:52:49 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:63736 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbaCRVwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:52:46 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
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
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH] OF: Add [__]of_find_node_by_full_name
Date: Tue, 18 Mar 2014 23:52:40 +0200
Message-Id: <1395179560-31384-1-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__of_find_node_by_full_name recursively searches for a matching node
with the given full name without taking any locks.

of_find_node_by_full_name takes locks and takes a reference on the
matching node.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/of/base.c  | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of.h |  4 ++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 19bcdb4..08156e6 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1142,6 +1142,64 @@ static void *of_find_property_value_of_size(const struct device_node *np,
 }
 
 /**
+ * __of_find_node_by_full_name - Find a node with the full name recursively
+ * @node:	Root of the tree to perform the search
+ * @full_name:	Full name of the node to find.
+ *
+ * Find a node with the give full name by recursively following any of
+ * the child node links.
+ * Returns the matching node, or NULL if not found.
+ * Note that the devtree lock is not taken, so this function is only
+ * safe to call on either detached trees, or when devtree lock is already
+ * taken.
+ */
+struct device_node *__of_find_node_by_full_name(struct device_node *node,
+		const char *full_name)
+{
+	struct device_node *child, *found;
+
+	if (node == NULL)
+		return NULL;
+
+	/* check */
+	if (of_node_cmp(node->full_name, full_name) == 0)
+		return node;
+
+	__for_each_child_of_node(node, child) {
+		found = __of_find_node_by_full_name(child, full_name);
+		if (found != NULL)
+			return found;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(__of_find_node_by_full_name);
+
+/**
+ * of_find_node_by_full_name - Find a node with the full name recursively
+ * @node:	Root of the tree to perform the search
+ * @full_name:	Full name of the node to find.
+ *
+ * Find a node with the give full name by recursively following any of
+ * the child node links.
+ * Returns the matching node (with a ref taken), or NULL if not found.
+ */
+struct device_node *of_find_node_by_full_name(struct device_node *node,
+		const char *full_name)
+{
+	unsigned long flags;
+	struct device_node *np;
+
+	raw_spin_lock_irqsave(&devtree_lock, flags);
+	np = of_find_node_by_full_name(node, full_name);
+	of_node_get(np);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
+
+	return np;
+}
+EXPORT_SYMBOL(of_find_node_by_full_name);
+
+/**
  * of_property_read_u32_index - Find and read a u32 from a multi-value property.
  *
  * @np:		device node from which the property value is to be read.
diff --git a/include/linux/of.h b/include/linux/of.h
index a8b9dad..bef3d5b 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -223,6 +223,10 @@ extern struct device_node *of_find_matching_node_and_match(
 
 extern struct device_node *of_find_node_by_path(const char *path);
 extern struct device_node *of_find_node_by_phandle(phandle handle);
+struct device_node *__of_find_node_by_full_name(struct device_node *node,
+						const char *full_name);
+struct device_node *of_find_node_by_full_name(struct device_node *node,
+						const char *full_name);
 extern struct device_node *of_get_parent(const struct device_node *node);
 extern struct device_node *of_get_next_parent(struct device_node *node);
 extern struct device_node *of_get_next_child(const struct device_node *node,
-- 
1.7.12

