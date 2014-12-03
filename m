Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaLCLzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:55:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbaLCL1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:13 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 047/101] dm btree: fix a recursion depth bug in btree walking code
Date: Wed,  3 Dec 2014 12:26:09 +0100
Message-Id: <d0960e2100d219b38ac94bddcca37c04281f31e9.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9b460d3699324d570a4d4161c3741431887f102f upstream.

The walk code was using a 'ro_spine' to hold it's locked btree nodes.
But this data structure is designed for the rolling lock scheme, and
as such automatically unlocks blocks that are two steps up the call
chain.  This is not suitable for the simple recursive walk algorithm,
which retraces its steps.

This code is only used by the persistent array code, which in turn is
only used by dm-cache.  In order to trigger it you need to have a
mapping tree that is more than 2 levels deep; which equates to 8-16
million cache blocks.  For instance a 4T ssd with a very small block
size of 32k only just triggers this bug.

The fix just places the locked blocks on the stack, and stops using
the ro_spine altogether.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/persistent-data/dm-btree-internal.h |  6 ++++++
 drivers/md/persistent-data/dm-btree-spine.c    |  2 +-
 drivers/md/persistent-data/dm-btree.c          | 24 ++++++++++--------------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index 37d367bb9aa8..bf2b80d5c470 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -42,6 +42,12 @@ struct btree_node {
 } __packed;
 
 
+/*
+ * Locks a block using the btree node validator.
+ */
+int bn_read_lock(struct dm_btree_info *info, dm_block_t b,
+		 struct dm_block **result);
+
 void inc_children(struct dm_transaction_manager *tm, struct btree_node *n,
 		  struct dm_btree_value_type *vt);
 
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index cf9fd676ae44..1b5e13ec7f96 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -92,7 +92,7 @@ struct dm_block_validator btree_node_validator = {
 
 /*----------------------------------------------------------------*/
 
-static int bn_read_lock(struct dm_btree_info *info, dm_block_t b,
+int bn_read_lock(struct dm_btree_info *info, dm_block_t b,
 		 struct dm_block **result)
 {
 	return dm_tm_read_lock(info->tm, b, &btree_node_validator, result);
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 468e371ee9b2..9701d29c94e1 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -828,22 +828,26 @@ EXPORT_SYMBOL_GPL(dm_btree_find_highest_key);
  * FIXME: We shouldn't use a recursive algorithm when we have limited stack
  * space.  Also this only works for single level trees.
  */
-static int walk_node(struct ro_spine *s, dm_block_t block,
+static int walk_node(struct dm_btree_info *info, dm_block_t block,
 		     int (*fn)(void *context, uint64_t *keys, void *leaf),
 		     void *context)
 {
 	int r;
 	unsigned i, nr;
+	struct dm_block *node;
 	struct btree_node *n;
 	uint64_t keys;
 
-	r = ro_step(s, block);
-	n = ro_node(s);
+	r = bn_read_lock(info, block, &node);
+	if (r)
+		return r;
+
+	n = dm_block_data(node);
 
 	nr = le32_to_cpu(n->header.nr_entries);
 	for (i = 0; i < nr; i++) {
 		if (le32_to_cpu(n->header.flags) & INTERNAL_NODE) {
-			r = walk_node(s, value64(n, i), fn, context);
+			r = walk_node(info, value64(n, i), fn, context);
 			if (r)
 				goto out;
 		} else {
@@ -855,7 +859,7 @@ static int walk_node(struct ro_spine *s, dm_block_t block,
 	}
 
 out:
-	ro_pop(s);
+	dm_tm_unlock(info->tm, node);
 	return r;
 }
 
@@ -863,15 +867,7 @@ int dm_btree_walk(struct dm_btree_info *info, dm_block_t root,
 		  int (*fn)(void *context, uint64_t *keys, void *leaf),
 		  void *context)
 {
-	int r;
-	struct ro_spine spine;
-
 	BUG_ON(info->levels > 1);
-
-	init_ro_spine(&spine, info);
-	r = walk_node(&spine, root, fn, context);
-	exit_ro_spine(&spine);
-
-	return r;
+	return walk_node(info, root, fn, context);
 }
 EXPORT_SYMBOL_GPL(dm_btree_walk);
-- 
2.1.3

