Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaBRWb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:31:56 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50309 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaBRWbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:31:53 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kevin Hao <haokexin@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 2/4] of: reimplement the matching method for __of_match_node()
Date: Tue, 18 Feb 2014 22:31:18 +0000
Message-Id: <1392762680-1498-3-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392762680-1498-1-git-send-email-grant.likely@linaro.org>
References: <1392762680-1498-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

In the current implementation of __of_match_node(), it will compare
each given match entry against all the node's compatible strings
with of_device_is_compatible().

To achieve multiple compatible strings per node with ordering from
specific to generic, this requires given matches to be ordered from
specific to generic. For most of the drivers this is not true and
also an alphabetical ordering is more sane there.

Therefore, we define a following priority order for the match, and
then scan all the entries to find the best match.
  1. specific compatible && type && name
  2. specific compatible && type
  3. specific compatible && name
  4. specific compatible
  5. general compatible && type && name
  6. general compatible && type
  7. general compatible && name
  8. general compatible
  9. type && name
  10. type
  11. name

This is based on some pseudo-codes provided by Grant Likely.

Signed-off-by: Kevin Hao <haokexin@gmail.com
[grant.likely: Changed multiplier to 4 which makes more sense]
Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/base.c | 87 +++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 68 insertions(+), 19 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index ba195fbce4c6..6e893f6f19a9 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -342,21 +342,28 @@ struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
 }
 EXPORT_SYMBOL(of_get_cpu_node);
 
-/** Checks if the given "compat" string matches one of the strings in
- * the device's "compatible" property
+/*
+ * Compare with the __of_device_is_compatible, this will return a score for the
+ * matching strings. The smaller value indicates the match for the more specific
+ * compatible string.
  */
-static int __of_device_is_compatible(const struct device_node *device,
-				     const char *compat)
+static int __of_device_is_compatible_score(const struct device_node *device,
+				     const char *compat, unsigned int *pscore)
 {
 	const char* cp;
 	int cplen, l;
+	unsigned int score = 0;
 
 	cp = __of_get_property(device, "compatible", &cplen);
 	if (cp == NULL)
 		return 0;
 	while (cplen > 0) {
-		if (of_compat_cmp(cp, compat, strlen(compat)) == 0)
+		score++;
+		if (of_compat_cmp(cp, compat, strlen(compat)) == 0) {
+			if (pscore)
+				*pscore = score;
 			return 1;
+		}
 		l = strlen(cp) + 1;
 		cp += l;
 		cplen -= l;
@@ -368,6 +375,15 @@ static int __of_device_is_compatible(const struct device_node *device,
 /** Checks if the given "compat" string matches one of the strings in
  * the device's "compatible" property
  */
+static int __of_device_is_compatible(const struct device_node *device,
+				     const char *compat)
+{
+	return __of_device_is_compatible_score(device, compat, NULL);
+}
+
+/** Checks if the given "compat" string matches one of the strings in
+ * the device's "compatible" property
+ */
 int of_device_is_compatible(const struct device_node *device,
 		const char *compat)
 {
@@ -734,25 +750,46 @@ static
 const struct of_device_id *__of_match_node(const struct of_device_id *matches,
 					   const struct device_node *node)
 {
+	const struct of_device_id *best_match = NULL;
+	unsigned int best_score = ~0;
+
 	if (!matches)
 		return NULL;
 
 	while (matches->name[0] || matches->type[0] || matches->compatible[0]) {
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
+		unsigned int score = ~0;
+
+		/*
+		 * Matching compatible is better than matching type and name,
+		 * and the specific compatible is better than the general.
+		 */
+		if (matches->compatible[0] &&
+			 __of_device_is_compatible_score(node,
+						matches->compatible, &score))
+			score *= 4;
+
+		/*
+		 * Matching type is better than matching name, but matching
+		 * both is even better than that.
+		 */
+		if (matches->type[0] && node->type &&
+			!strcmp(matches->type, node->type))
+			score -= 2;
+
+		/* Matching name is a bit better than not */
+		if (matches->name[0] && node->name &&
+			!strcmp(matches->name, node->name))
+			score--;
+
+		if (score < best_score) {
+			best_match = matches;
+			best_score = score;
+		}
+
 		matches++;
 	}
-	return NULL;
+
+	return best_match;
 }
 
 /**
@@ -760,7 +797,19 @@ const struct of_device_id *__of_match_node(const struct of_device_id *matches,
  *	@matches:	array of of device match structures to search in
  *	@node:		the of device structure to match against
  *
- *	Low level utility function used by device matching.
+ *	Low level utility function used by device matching. The priority order
+ *	for the matching is:
+ *	  1. specific compatible && type && name
+ *	  2. specific compatible && type
+ *	  3. specific compatible && name
+ *	  4. specific compatible
+ *	  5. general compatible && type && name
+ *	  6. general compatible && type
+ *	  7. general compatible && name
+ *	  8. general compatible
+ *	  9. type && name
+ *	  10. type
+ *	  11. name
  */
 const struct of_device_id *of_match_node(const struct of_device_id *matches,
 					 const struct device_node *node)
-- 
1.8.3.2

