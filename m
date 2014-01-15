Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaAOWTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:19:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41157 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbaAOV6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:58:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 039/166] dm thin: allow pool in read-only mode to transition to read-write mode
Date: Wed, 15 Jan 2014 13:50:53 -0800
Message-Id: <1389822780-4729-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 9b7aaa64f96f7ca280d75326fca42f42017b89ef upstream.

A thin-pool may be in read-only mode because the pool's data or metadata
space was exhausted.  To allow for recovery, by adding more space to the
pool, we must allow a pool to transition from PM_READ_ONLY to PM_WRITE
mode.  Otherwise, running out of space will render the pool permanently
read-only.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-thin-metadata.c                 |  9 +++++++++
 drivers/md/dm-thin-metadata.h                 |  1 +
 drivers/md/dm-thin.c                          | 12 ++++++++++--
 drivers/md/persistent-data/dm-block-manager.c |  6 ++++++
 drivers/md/persistent-data/dm-block-manager.h |  1 +
 5 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 4d6e853..0368a69 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1684,3 +1684,12 @@ void dm_pool_metadata_read_only(struct dm_pool_metadata *pmd)
 	dm_bm_set_read_only(pmd->bm);
 	up_write(&pmd->root_lock);
 }
+
+void dm_pool_metadata_read_write(struct dm_pool_metadata *pmd)
+{
+	down_write(&pmd->root_lock);
+	pmd->read_only = false;
+	dm_bm_set_read_write(pmd->bm);
+	up_write(&pmd->root_lock);
+}
+
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index 0cecc37..050a9ad 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -191,6 +191,7 @@ int dm_pool_resize_data_dev(struct dm_pool_metadata *pmd, dm_block_t new_size);
  * that nothing is changing.
  */
 void dm_pool_metadata_read_only(struct dm_pool_metadata *pmd);
+void dm_pool_metadata_read_write(struct dm_pool_metadata *pmd);
 
 /*----------------------------------------------------------------*/
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index bc7d4a3..44a715f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1335,6 +1335,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode mode)
 		break;
 
 	case PM_WRITE:
+		dm_pool_metadata_read_write(pool->pmd);
 		pool->process_bio = process_bio;
 		pool->process_discard = process_discard;
 		pool->process_prepared_mapping = process_prepared_mapping;
@@ -1545,12 +1546,19 @@ static int bind_control_target(struct pool *pool, struct dm_target *ti)
 	struct pool_c *pt = ti->private;
 
 	/*
-	 * We want to make sure that degraded pools are never upgraded.
+	 * We want to make sure that a pool in PM_FAIL mode is never upgraded.
 	 */
 	enum pool_mode old_mode = pool->pf.mode;
 	enum pool_mode new_mode = pt->adjusted_pf.mode;
 
-	if (old_mode > new_mode)
+	/*
+	 * If we were in PM_FAIL mode, rollback of metadata failed.  We're
+	 * not going to recover without a thin_repair.  So we never let the
+	 * pool move out of the old mode.  On the other hand a PM_READ_ONLY
+	 * may have been due to a lack of metadata or data space, and may
+	 * now work (ie. if the underlying devices have been resized).
+	 */
+	if (old_mode == PM_FAIL)
 		new_mode = old_mode;
 
 	pool->ti = ti;
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 28c3ed0..53281f4 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -620,6 +620,12 @@ void dm_bm_set_read_only(struct dm_block_manager *bm)
 }
 EXPORT_SYMBOL_GPL(dm_bm_set_read_only);
 
+void dm_bm_set_read_write(struct dm_block_manager *bm)
+{
+	bm->read_only = false;
+}
+EXPORT_SYMBOL_GPL(dm_bm_set_read_write);
+
 u32 dm_bm_checksum(const void *data, size_t len, u32 init_xor)
 {
 	return crc32c(~(u32) 0, data, len) ^ init_xor;
diff --git a/drivers/md/persistent-data/dm-block-manager.h b/drivers/md/persistent-data/dm-block-manager.h
index be5bff6..84dbab5 100644
--- a/drivers/md/persistent-data/dm-block-manager.h
+++ b/drivers/md/persistent-data/dm-block-manager.h
@@ -120,6 +120,7 @@ int dm_bm_flush_and_unlock(struct dm_block_manager *bm,
  * be returned if you do.
  */
 void dm_bm_set_read_only(struct dm_block_manager *bm);
+void dm_bm_set_read_write(struct dm_block_manager *bm);
 
 u32 dm_bm_checksum(const void *data, size_t len, u32 init_xor);
 
-- 
1.8.3.2

