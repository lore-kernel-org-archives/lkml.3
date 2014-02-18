Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaBRWbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:31:32 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39012 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaBRWb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:31:29 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kevin Hao <haokexin@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 1/4] Revert "of: search the best compatible match first in __of_match_node()"
Date: Tue, 18 Feb 2014 22:31:17 +0000
Message-Id: <1392762680-1498-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392762680-1498-1-git-send-email-grant.likely@linaro.org>
References: <1392762680-1498-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

This reverts commit 06b29e76a74b2373e6f8b5a7938b3630b9ae98b2.
As pointed out by Grant Likely, we should also take the type and name
into account when searching the best compatible match. That means the
match with compatible, type and name should be better than the match
just with the same compatible string. So revert this and we will
implement another method to find the best match entry.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/base.c | 43 +------------------------------------------
 1 file changed, 1 insertion(+), 42 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 10b51106c854..ba195fbce4c6 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -730,49 +730,13 @@ out:
 }
 EXPORT_SYMBOL(of_find_node_with_property);
 
-static const struct of_device_id *
-of_match_compatible(const struct of_device_id *matches,
-			const struct device_node *node)
-{
-	const char *cp;
-	int cplen, l;
-	const struct of_device_id *m;
-
-	cp = __of_get_property(node, "compatible", &cplen);
-	while (cp && (cplen > 0)) {
-		m = matches;
-		while (m->name[0] || m->type[0] || m->compatible[0]) {
-			/* Only match for the entries without type and name */
-			if (m->name[0] || m->type[0] ||
-				of_compat_cmp(m->compatible, cp,
-					 strlen(m->compatible)))
-				m++;
-			else
-				return m;
-		}
-
-		/* Get node's next compatible string */
-		l = strlen(cp) + 1;
-		cp += l;
-		cplen -= l;
-	}
-
-	return NULL;
-}
-
 static
 const struct of_device_id *__of_match_node(const struct of_device_id *matches,
 					   const struct device_node *node)
 {
-	const struct of_device_id *m;
-
 	if (!matches)
 		return NULL;
 
-	m = of_match_compatible(matches, node);
-	if (m)
-		return m;
-
 	while (matches->name[0] || matches->type[0] || matches->compatible[0]) {
 		int match = 1;
 		if (matches->name[0])
@@ -796,12 +760,7 @@ const struct of_device_id *__of_match_node(const struct of_device_id *matches,
  *	@matches:	array of of device match structures to search in
  *	@node:		the of device structure to match against
  *
- *	Low level utility function used by device matching. We have two ways
- *	of matching:
- *	- Try to find the best compatible match by comparing each compatible
- *	  string of device node with all the given matches respectively.
- *	- If the above method failed, then try to match the compatible by using
- *	  __of_device_is_compatible() besides the match in type and name.
+ *	Low level utility function used by device matching.
  */
 const struct of_device_id *of_match_node(const struct of_device_id *matches,
 					 const struct device_node *node)
-- 
1.8.3.2

