Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaBJTwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:52:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35124 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbaBJTrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:47:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 033/124] dm thin: fix discard support to a previously shared block
Date: Mon, 10 Feb 2014 11:39:33 -0800
Message-Id: <1392061264-28124-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 19fa1a6756ed9e92daa9537c03b47d6b55cc2316 upstream.

If a snapshot is created and later deleted the origin dm_thin_device's
snapshotted_time will have been updated to reflect the snapshot's
creation time.  The 'shared' flag in the dm_thin_lookup_result struct
returned from dm_thin_find_block() is an approximation based on
snapshotted_time -- this is done to avoid 0(n), or worse, time
complexity.  In this case, the shared flag would be true.

But because the 'shared' flag reflects an approximation a block can be
incorrectly assumed to be shared (e.g. false positive for 'shared'
because the snapshot no longer exists).  This could result in discards
issued to a thin device not being passed down to the pool's underlying
data device.

To fix this we double check that a thin block is really still in-use
after a mapping is removed using dm_pool_block_is_used().  If the
reference count for a block is now zero the discard is allowed to be
passed down.

Also add a 'definitely_not_shared' member to the dm_thin_new_mapping
structure -- reflects that the 'shared' flag in the response from
dm_thin_find_block() can only be held as definitive if false is
returned.

Resolves: https://bugzilla.redhat.com/show_bug.cgi?id=1043527

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-thin-metadata.c | 20 ++++++++++++++++++++
 drivers/md/dm-thin-metadata.h |  2 ++
 drivers/md/dm-thin.c          | 14 ++++++++++++--
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 0368a69..6727958 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1349,6 +1349,12 @@ dm_thin_id dm_thin_dev_id(struct dm_thin_device *td)
 	return td->id;
 }
 
+/*
+ * Check whether @time (of block creation) is older than @td's last snapshot.
+ * If so then the associated block is shared with the last snapshot device.
+ * Any block on a device created *after* the device last got snapshotted is
+ * necessarily not shared.
+ */
 static bool __snapshotted_since(struct dm_thin_device *td, uint32_t time)
 {
 	return td->snapshotted_time > time;
@@ -1458,6 +1464,20 @@ int dm_thin_remove_block(struct dm_thin_device *td, dm_block_t block)
 	return r;
 }
 
+int dm_pool_block_is_used(struct dm_pool_metadata *pmd, dm_block_t b, bool *result)
+{
+	int r;
+	uint32_t ref_count;
+
+	down_read(&pmd->root_lock);
+	r = dm_sm_get_count(pmd->data_sm, b, &ref_count);
+	if (!r)
+		*result = (ref_count != 0);
+	up_read(&pmd->root_lock);
+
+	return r;
+}
+
 bool dm_thin_changed_this_transaction(struct dm_thin_device *td)
 {
 	int r;
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index 050a9ad..149d326 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -180,6 +180,8 @@ int dm_pool_get_data_block_size(struct dm_pool_metadata *pmd, sector_t *result);
 
 int dm_pool_get_data_dev_size(struct dm_pool_metadata *pmd, dm_block_t *result);
 
+int dm_pool_block_is_used(struct dm_pool_metadata *pmd, dm_block_t b, bool *result);
+
 /*
  * Returns -ENOSPC if the new size is too small and already allocated
  * blocks would be lost.
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index b6fdaf7..5e62738 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -440,6 +440,7 @@ struct dm_thin_new_mapping {
 	unsigned quiesced:1;
 	unsigned prepared:1;
 	unsigned pass_discard:1;
+	unsigned definitely_not_shared:1;
 
 	struct thin_c *tc;
 	dm_block_t virt_block;
@@ -610,7 +611,15 @@ static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
 	cell_defer_no_holder(tc, m->cell2);
 
 	if (m->pass_discard)
-		remap_and_issue(tc, m->bio, m->data_block);
+		if (m->definitely_not_shared)
+			remap_and_issue(tc, m->bio, m->data_block);
+		else {
+			bool used = false;
+			if (dm_pool_block_is_used(tc->pool->pmd, m->data_block, &used) || used)
+				bio_endio(m->bio, 0);
+			else
+				remap_and_issue(tc, m->bio, m->data_block);
+		}
 	else
 		bio_endio(m->bio, 0);
 
@@ -957,7 +966,8 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 			 */
 			m = get_next_mapping(pool);
 			m->tc = tc;
-			m->pass_discard = (!lookup_result.shared) && pool->pf.discard_passdown;
+			m->pass_discard = pool->pf.discard_passdown;
+			m->definitely_not_shared = !lookup_result.shared;
 			m->virt_block = block;
 			m->data_block = lookup_result.block;
 			m->cell = cell;
-- 
1.8.3.2

