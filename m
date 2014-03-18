Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbaCRVwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:52:39 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:56461 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbaCRVwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:52:36 -0400
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
Subject: [PATCH] of: Make of_find_node_by_path() handle /aliases
Date: Tue, 18 Mar 2014 23:52:29 +0200
Message-Id: <1395179549-31345-1-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_find_node_by_path() handle aliases as prefixes.

Originally by David Daney <ddaney@caviumnetworks.com>, but
reworked according to remark by Grant Likely.

Handles all cases without allocating memory as requested by
Grant Likely <grant.likely@linaro.org>

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/of/base.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 7083fad..19bcdb4 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -773,22 +773,83 @@ EXPORT_SYMBOL(of_get_child_by_name);
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
  */
 struct device_node *of_find_node_by_path(const char *path)
 {
-	struct device_node *np = of_allnodes;
+	struct device_node *np = NULL;
+	int len;
+	const char *p = NULL;
+	struct property *prop;
 	unsigned long flags;
 
+	/* under lock (not very nice) */
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	for (; np; np = np->allnext) {
-		if (np->full_name && (of_node_cmp(np->full_name, path) == 0)
-		    && of_node_get(np))
+
+	len = strlen(path);
+
+	/* path begins with an alias */
+	if (path[0] != '/') {
+
+		/* now find the relative path (if any)*/
+		p = strchr(path, '/');
+		if (p != NULL)
+			len = p - path;
+
+		/* of_aliases must not be NULL */
+		if (!of_aliases)
+			goto out;
+
+		/* find matching alias */
+		for_each_property_of_node(of_aliases, prop)
+			if (strlen(prop->name) == len &&
+					strncmp(prop->name, path, len) == 0)
+				break;
+
+		/* not found; bail */
+		if (prop == NULL)
+			goto out;
+
+		path = prop->value;
+	}
+
+	/* path lookup */
+	for_each_of_allnodes(np) {
+
+		if (!np->full_name)
+			continue;
+
+		if (p == NULL) {
+			/* full component */
+			if (strcasecmp(np->full_name, path) != 0)
+				continue;
+		} else {
+			/* last component (including '/') */
+			if (strncasecmp(np->full_name, path, len) != 0)
+				continue;
+
+			if (strcasecmp(np->full_name + len, p) != 0)
+				continue;
+		}
+
+		if (of_node_get(np))
 			break;
 	}
+
+out:
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
+
 	return np;
 }
 EXPORT_SYMBOL(of_find_node_by_path);
-- 
1.7.12

