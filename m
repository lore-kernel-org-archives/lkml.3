Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaEBPpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:45:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44231 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaEBPp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 099/151] dm transaction manager: fix corruption due to non-atomic transaction commit
Date: Fri,  2 May 2014 08:38:07 -0700
Message-Id: <1399045139-4531-100-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit a9d45396f5956d0b615c7ae3b936afd888351a47 upstream.

The persistent-data library used by dm-thin, dm-cache, etc is
transactional.  If anything goes wrong, such as an io error when writing
new metadata or a power failure, then we roll back to the last
transaction.

Atomicity when committing a transaction is achieved by:

a) Never overwriting data from the previous transaction.
b) Writing the superblock last, after all other metadata has hit the
   disk.

This commit and the following commit ("dm: take care to copy the space
map roots before locking the superblock") fix a bug associated with (b).
When committing it was possible for the superblock to still be written
in spite of an io error occurring during the preceeding metadata flush.
With these commits we're careful not to take the write lock out on the
superblock until after the metadata flush has completed.

Change the transaction manager's semantics for dm_tm_commit() to assume
all data has been flushed _before_ the single superblock that is passed
in.

As a prerequisite, split the block manager's block unlocking and
flushing by simplifying dm_bm_flush_and_unlock() to dm_bm_flush().  Now
the unlocking must be done separately.

This issue was discovered by forcing io errors at the crucial time
using dm-flakey.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-cache-metadata.c                      |  3 ++-
 drivers/md/persistent-data/dm-block-manager.c       | 15 ++-------------
 drivers/md/persistent-data/dm-block-manager.h       |  3 +--
 drivers/md/persistent-data/dm-transaction-manager.c |  5 +++--
 drivers/md/persistent-data/dm-transaction-manager.h | 17 ++++++++---------
 5 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 9ef0752..3e7fd7d 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -530,8 +530,9 @@ static int __begin_transaction_flags(struct dm_cache_metadata *cmd,
 	disk_super = dm_block_data(sblock);
 	update_flags(disk_super, mutator);
 	read_superblock_fields(cmd, disk_super);
+	dm_bm_unlock(sblock);
 
-	return dm_bm_flush_and_unlock(cmd->bm, sblock);
+	return dm_bm_flush(cmd->bm);
 }
 
 static int __begin_transaction(struct dm_cache_metadata *cmd)
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 064a3c2..30597f3 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -595,25 +595,14 @@ int dm_bm_unlock(struct dm_block *b)
 }
 EXPORT_SYMBOL_GPL(dm_bm_unlock);
 
-int dm_bm_flush_and_unlock(struct dm_block_manager *bm,
-			   struct dm_block *superblock)
+int dm_bm_flush(struct dm_block_manager *bm)
 {
-	int r;
-
 	if (bm->read_only)
 		return -EPERM;
 
-	r = dm_bufio_write_dirty_buffers(bm->bufio);
-	if (unlikely(r)) {
-		dm_bm_unlock(superblock);
-		return r;
-	}
-
-	dm_bm_unlock(superblock);
-
 	return dm_bufio_write_dirty_buffers(bm->bufio);
 }
-EXPORT_SYMBOL_GPL(dm_bm_flush_and_unlock);
+EXPORT_SYMBOL_GPL(dm_bm_flush);
 
 void dm_bm_prefetch(struct dm_block_manager *bm, dm_block_t b)
 {
diff --git a/drivers/md/persistent-data/dm-block-manager.h b/drivers/md/persistent-data/dm-block-manager.h
index 13cd58e..1b95dfc 100644
--- a/drivers/md/persistent-data/dm-block-manager.h
+++ b/drivers/md/persistent-data/dm-block-manager.h
@@ -105,8 +105,7 @@ int dm_bm_unlock(struct dm_block *b);
  *
  * This method always blocks.
  */
-int dm_bm_flush_and_unlock(struct dm_block_manager *bm,
-			   struct dm_block *superblock);
+int dm_bm_flush(struct dm_block_manager *bm);
 
 /*
  * Request data is prefetched into the cache.
diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index 81da1a2..3bc30a0 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -154,7 +154,7 @@ int dm_tm_pre_commit(struct dm_transaction_manager *tm)
 	if (r < 0)
 		return r;
 
-	return 0;
+	return dm_bm_flush(tm->bm);
 }
 EXPORT_SYMBOL_GPL(dm_tm_pre_commit);
 
@@ -164,8 +164,9 @@ int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *root)
 		return -EWOULDBLOCK;
 
 	wipe_shadow_table(tm);
+	dm_bm_unlock(root);
 
-	return dm_bm_flush_and_unlock(tm->bm, root);
+	return dm_bm_flush(tm->bm);
 }
 EXPORT_SYMBOL_GPL(dm_tm_commit);
 
diff --git a/drivers/md/persistent-data/dm-transaction-manager.h b/drivers/md/persistent-data/dm-transaction-manager.h
index b5b1390..2772ed2 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.h
+++ b/drivers/md/persistent-data/dm-transaction-manager.h
@@ -38,18 +38,17 @@ struct dm_transaction_manager *dm_tm_create_non_blocking_clone(struct dm_transac
 /*
  * We use a 2-phase commit here.
  *
- * i) In the first phase the block manager is told to start flushing, and
- * the changes to the space map are written to disk.  You should interrogate
- * your particular space map to get detail of its root node etc. to be
- * included in your superblock.
+ * i) Make all changes for the transaction *except* for the superblock.
+ * Then call dm_tm_pre_commit() to flush them to disk.
  *
- * ii) @root will be committed last.  You shouldn't use more than the
- * first 512 bytes of @root if you wish the transaction to survive a power
- * failure.  You *must* have a write lock held on @root for both stage (i)
- * and (ii).  The commit will drop the write lock.
+ * ii) Lock your superblock.  Update.  Then call dm_tm_commit() which will
+ * unlock the superblock and flush it.  No other blocks should be updated
+ * during this period.  Care should be taken to never unlock a partially
+ * updated superblock; perform any operations that could fail *before* you
+ * take the superblock lock.
  */
 int dm_tm_pre_commit(struct dm_transaction_manager *tm);
-int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *root);
+int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *superblock);
 
 /*
  * These methods are the only way to get hold of a writeable block.
-- 
1.9.1

