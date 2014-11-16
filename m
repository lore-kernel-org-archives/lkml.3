Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbaKPCuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 21:50:11 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:61726 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbaKPCuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 21:50:09 -0500
From: Zhihui Zhang <zzhsuny@gmail.com>
To: akpm@linux-foundation.org, mgorman@suse.de, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [mempolicy] remove unnecessary is_valid_nodemask()
Date: Sat, 15 Nov 2014 21:49:57 -0500
Message-Id: <1416106197-8784-1-git-send-email-zzhsuny@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When nodes is true, nsc->mask2 has already been filtered by nsc->mask1, which has
already factored in node_states[N_MEMORY].

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
---
 mm/mempolicy.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e58725a..f22c559 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -162,12 +162,6 @@ static const struct mempolicy_operations {
 			enum mpol_rebind_step step);
 } mpol_ops[MPOL_MAX];
 
-/* Check that the nodemask contains at least one populated zone */
-static int is_valid_nodemask(const nodemask_t *nodemask)
-{
-	return nodes_intersects(*nodemask, node_states[N_MEMORY]);
-}
-
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
 {
 	return pol->flags & MPOL_MODE_FLAGS;
@@ -202,7 +196,7 @@ static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
 
 static int mpol_new_bind(struct mempolicy *pol, const nodemask_t *nodes)
 {
-	if (!is_valid_nodemask(nodes))
+	if (nodes_empty(*nodes))
 		return -EINVAL;
 	pol->v.nodes = *nodes;
 	return 0;
@@ -234,7 +228,7 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 		nodes = NULL;	/* explicit local allocation */
 	else {
 		if (pol->flags & MPOL_F_RELATIVE_NODES)
-			mpol_relative_nodemask(&nsc->mask2, nodes,&nsc->mask1);
+			mpol_relative_nodemask(&nsc->mask2, nodes, &nsc->mask1);
 		else
 			nodes_and(nsc->mask2, *nodes, nsc->mask1);
 
-- 
1.9.1

