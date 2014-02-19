Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaBSOPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:15:13 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56255 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbaBSOPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:15:05 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kevin Hao <haokexin@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v4 2/4] of: reimplement the matching method for __of_match_node()
Date: Wed, 19 Feb 2014 14:14:48 +0000
Message-Id: <1392819290-1044-3-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392819290-1044-1-git-send-email-grant.likely@linaro.org>
References: <1392819290-1044-1-git-send-email-grant.likely@linaro.org>
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

v4: Short-circuit failure cases instead of mucking with score, and
    remove extra __of_device_is_compatible() wrapper stub.
    Move scoring logic directly into __of_device_is_compatible()

v3: Also need to bail out when there does have a compatible member in match
    entry, but it doesn't match with the device node's compatible.

v2: Fix the bug such as we get the same score for the following two match
    entries with the empty node 'name2 { };'
	struct of_device_id matches[] = {
		{.name = "name2", },
		{.name = "name2", .type = "type1", },
		{}
	};

Signed-off-by: Kevin Hao <haokexin@gmail.com>
[grant.likely: added v4 changes]
Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/base.c | 108 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 74 insertions(+), 34 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index ba195fbce4c6..30ffc291d0a0 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -342,27 +342,73 @@ struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
 }
 EXPORT_SYMBOL(of_get_cpu_node);
 
-/** Checks if the given "compat" string matches one of the strings in
- * the device's "compatible" property
+/**
+ * __of_device_is_compatible() - Check if the node matches given constraints
+ * @device: pointer to node
+ * @compat: required compatible string, NULL or "" for any match
+ * @type: required device_type value, NULL or "" for any match
+ * @name: required node name, NULL or "" for any match
+ *
+ * Checks if the given @compat, @type and @name strings match the
+ * properties of the given @device. A constraints can be skipped by
+ * passing NULL or an empty string as the constraint.
+ *
+ * Returns 0 for no match, and a positive integer on match. The return
+ * value is a relative score with larger values indicating better
+ * matches. The score is weighted for the most specific compatible value
+ * to get the highest score. Matching type is next, followed by matching
+ * name. Practically speaking, this results in the following priority
+ * order for matches:
+ *
+ * 1. specific compatible && type && name
+ * 2. specific compatible && type
+ * 3. specific compatible && name
+ * 4. specific compatible
+ * 5. general compatible && type && name
+ * 6. general compatible && type
+ * 7. general compatible && name
+ * 8. general compatible
+ * 9. type && name
+ * 10. type
+ * 11. name
  */
 static int __of_device_is_compatible(const struct device_node *device,
-				     const char *compat)
+				     const char *compat, const char *type, const char *name)
 {
 	const char* cp;
-	int cplen, l;
+	int cplen, l, index, score = 0;
 
-	cp = __of_get_property(device, "compatible", &cplen);
-	if (cp == NULL)
-		return 0;
-	while (cplen > 0) {
-		if (of_compat_cmp(cp, compat, strlen(compat)) == 0)
-			return 1;
-		l = strlen(cp) + 1;
-		cp += l;
-		cplen -= l;
+	/* Compatible match has highest priority */
+	if (compat && compat[0]) {
+		cp = __of_get_property(device, "compatible", &cplen);
+		if (!cp)
+			return 0;
+		for (index = 0; cplen > 0; index++, cp += l, cplen -= l) {
+			l = strlen(cp) + 1;
+			if (of_compat_cmp(cp, compat, strlen(compat)) == 0) {
+				score = INT_MAX/2 - (index << 2);
+				break;
+			}
+		}
+		if (!score)
+			return 0;
 	}
 
-	return 0;
+	/* Matching type is better than matching name */
+	if (type && type[0]) {
+		if (!device->type || of_node_cmp(type, device->type))
+			return 0;
+		score += 2;
+	}
+
+	/* Matching name is a bit better than not */
+	if (name && name[0]) {
+		if (!device->name || of_node_cmp(name, device->name))
+			return 0;
+		score++;
+	}
+
+	return score;
 }
 
 /** Checks if the given "compat" string matches one of the strings in
@@ -375,7 +421,7 @@ int of_device_is_compatible(const struct device_node *device,
 	int res;
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	res = __of_device_is_compatible(device, compat);
+	res = __of_device_is_compatible(device, compat, NULL, NULL);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return res;
 }
@@ -681,10 +727,7 @@ struct device_node *of_find_compatible_node(struct device_node *from,
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	np = from ? from->allnext : of_allnodes;
 	for (; np; np = np->allnext) {
-		if (type
-		    && !(np->type && (of_node_cmp(np->type, type) == 0)))
-			continue;
-		if (__of_device_is_compatible(np, compatible) &&
+		if (__of_device_is_compatible(np, compatible, type, NULL) &&
 		    of_node_get(np))
 			break;
 	}
@@ -734,25 +777,22 @@ static
 const struct of_device_id *__of_match_node(const struct of_device_id *matches,
 					   const struct device_node *node)
 {
+	const struct of_device_id *best_match = NULL;
+	int score, best_score = 0;
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
+	for (; matches->name[0] || matches->type[0] || matches->compatible[0]; matches++) {
+		score = __of_device_is_compatible(node, matches->compatible,
+						  matches->type, matches->name);
+		if (score > best_score) {
+			best_match = matches;
+			best_score = score;
+		}
 	}
-	return NULL;
+
+	return best_match;
 }
 
 /**
-- 
1.8.3.2

