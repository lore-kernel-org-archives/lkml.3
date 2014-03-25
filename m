Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbaCYRhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:37:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55922 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbaCYRVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 51/81] dm thin: avoid metadata commit if a pool's thin devices haven't changed
Date: Tue, 25 Mar 2014 10:16:04 -0700
Message-Id: <1395767794-5012-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 4d1662a30dde6e545086fe0e8fd7e474c4e0b639 upstream.

Commit 905e51b ("dm thin: commit outstanding data every second")
introduced a periodic commit.  This commit occurs regardless of whether
any thin devices have made changes.

Fix the periodic commit to check if any of a pool's thin devices have
changed using dm_pool_changed_this_transaction().

Reported-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-thin-metadata.c | 17 +++++++++++++++++
 drivers/md/dm-thin-metadata.h |  2 ++
 drivers/md/dm-thin.c          |  3 ++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 6727958..4f67945 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1489,6 +1489,23 @@ bool dm_thin_changed_this_transaction(struct dm_thin_device *td)
 	return r;
 }
 
+bool dm_pool_changed_this_transaction(struct dm_pool_metadata *pmd)
+{
+	bool r = false;
+	struct dm_thin_device *td, *tmp;
+
+	down_read(&pmd->root_lock);
+	list_for_each_entry_safe(td, tmp, &pmd->thin_devices, list) {
+		if (td->changed) {
+			r = td->changed;
+			break;
+		}
+	}
+	up_read(&pmd->root_lock);
+
+	return r;
+}
+
 bool dm_thin_aborted_changes(struct dm_thin_device *td)
 {
 	bool r;
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index 149d326..457dea1 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -160,6 +160,8 @@ int dm_thin_remove_block(struct dm_thin_device *td, dm_block_t block);
  */
 bool dm_thin_changed_this_transaction(struct dm_thin_device *td);
 
+bool dm_pool_changed_this_transaction(struct dm_pool_metadata *pmd);
+
 bool dm_thin_aborted_changes(struct dm_thin_device *td);
 
 int dm_thin_get_highest_mapped_block(struct dm_thin_device *td,
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 3bc2d39..e66e366 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1267,7 +1267,8 @@ static void process_deferred_bios(struct pool *pool)
 	bio_list_init(&pool->deferred_flush_bios);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-	if (bio_list_empty(&bios) && !need_commit_due_to_time(pool))
+	if (bio_list_empty(&bios) &&
+	    !(dm_pool_changed_this_transaction(pool->pmd) && need_commit_due_to_time(pool)))
 		return;
 
 	if (commit(pool)) {
-- 
1.8.3.2

