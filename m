Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab3K1ShF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:37:05 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:58644 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3K1Sgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:36:35 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] OF: base: match each node compatible against all given matches first
Date: Thu, 28 Nov 2013 19:36:25 +0100
Message-Id: <1385663785-8643-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, of_match_node compares each given match against all node's
compatible strings with of_device_is_compatible.

To achieve multiple compatible strings per node with ordering from
specific to generic, this requires given matches to be ordered from
specific to generic. For most of the drivers this is not true and also
an alphabetical ordering is more sane there.

Therefore, this patch modifies of_match_node to match each of the node's
compatible strings against all given matches first, before checking the
next compatible string. This implies that node's compatibles are ordered
from specific to generic while given matches can be in any order.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/of/base.c |   47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 7d4c70f..183a9c7 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -713,23 +713,37 @@ static
 const struct of_device_id *__of_match_node(const struct of_device_id *matches,
 					   const struct device_node *node)
 {
+	const char *cp;
+	int cplen, l;
+
 	if (!matches)
 		return NULL;
 
-	while (matches->name[0] || matches->type[0] || matches->compatible[0]) {
-		int match = 1;
-		if (matches->name[0])
-			match &= node->name
-				&& !strcmp(matches->name, node->name);
-		if (matches->type[0])
-			match &= node->type
-				&& !strcmp(matches->type, node->type);
-		if (matches->compatible[0])
-			match &= __of_device_is_compatible(node,
-							   matches->compatible);
-		if (match)
-			return matches;
-		matches++;
+	cp = __of_get_property(node, "compatible", &cplen);
+	if (!cp)
+		return NULL;
+
+	while (cplen > 0) {
+		const struct of_device_id *m = matches;
+
+		while (m->name[0] || m->type[0] || m->compatible[0]) {
+			int match = 1;
+			if (m->name[0])
+				match &= node->name
+					&& !strcmp(m->name, node->name);
+			if (m->type[0])
+				match &= node->type
+					&& !strcmp(m->type, node->type);
+			if (m->compatible[0])
+				match &= !of_compat_cmp(cp, m->compatible,
+							strlen(m->compatible));
+			if (match)
+				return m;
+			m++;
+		}
+		l = strlen(cp) + 1;
+		cp += l;
+		cplen -= l;
 	}
 	return NULL;
 }
@@ -739,7 +753,10 @@ const struct of_device_id *__of_match_node(const struct of_device_id *matches,
  *	@matches:	array of of device match structures to search in
  *	@node:		the of device structure to match against
  *
- *	Low level utility function used by device matching.
+ *	Low level utility function used by device matching. Matching order
+ *	is to compare each of the node's compatibles with all given matches
+ *	first. This implies node's compatible is sorted from specific to
+ *	generic while matches can be in any order.
  */
 const struct of_device_id *of_match_node(const struct of_device_id *matches,
 					 const struct device_node *node)
-- 
1.7.10.4

