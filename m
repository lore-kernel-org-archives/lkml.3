Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaJGKgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:36:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46219 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaJGKgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:36:16 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] of/selftest: Move hash table off stack to fix large frame size
Date: Tue,  7 Oct 2014 11:36:05 +0100
Message-Id: <1412678165-12087-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new testcase that checks phandle consistency was using a hash table
on the stack which made the frame size much large than it should be. Fix
the problem by moving the hash table into the file scope.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---

This patch applies on my devicetree/next branch, which I'm going to ask
Linux to pull later this week.

g.

 drivers/of/selftest.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index 4fed34bff5cf..78001270a598 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -198,20 +198,19 @@ struct node_hash {
 	struct device_node *np;
 };
 
+static DEFINE_HASHTABLE(phandle_ht, 8);
 static void __init of_selftest_check_phandles(void)
 {
 	struct device_node *np;
 	struct node_hash *nh;
 	struct hlist_node *tmp;
 	int i, dup_count = 0, phandle_count = 0;
-	DECLARE_HASHTABLE(ht, 8);
 
-	hash_init(ht);
 	for_each_of_allnodes(np) {
 		if (!np->phandle)
 			continue;
 
-		hash_for_each_possible(ht, nh, node, np->phandle) {
+		hash_for_each_possible(phandle_ht, nh, node, np->phandle) {
 			if (nh->np->phandle == np->phandle) {
 				pr_info("Duplicate phandle! %i used by %s and %s\n",
 					np->phandle, nh->np->full_name, np->full_name);
@@ -225,14 +224,14 @@ static void __init of_selftest_check_phandles(void)
 			return;
 
 		nh->np = np;
-		hash_add(ht, &nh->node, np->phandle);
+		hash_add(phandle_ht, &nh->node, np->phandle);
 		phandle_count++;
 	}
 	selftest(dup_count == 0, "Found %i duplicates in %i phandles\n",
 		 dup_count, phandle_count);
 
 	/* Clean up */
-	hash_for_each_safe(ht, i, tmp, nh, node) {
+	hash_for_each_safe(phandle_ht, i, tmp, nh, node) {
 		hash_del(&nh->node);
 		kfree(nh);
 	}
-- 
1.9.1

