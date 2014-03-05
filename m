Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbaCEPDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:03:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496AbaCEO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 098/131] dm thin: avoid metadata commit if a pool's thin devices haven't changed
Date: Wed,  5 Mar 2014 14:23:42 +0000
Message-Id: <1394029455-23128-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin-metadata.c | 17 +++++++++++++++++
 drivers/md/dm-thin-metadata.h |  2 ++
 drivers/md/dm-thin.c          |  3 ++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 7da3476..3bb4506 100644
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
index 2edf5db..c6d123b 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -161,6 +161,8 @@ int dm_thin_remove_block(struct dm_thin_device *td, dm_block_t block);
  */
 bool dm_thin_changed_this_transaction(struct dm_thin_device *td);
 
+bool dm_pool_changed_this_transaction(struct dm_pool_metadata *pmd);
+
 bool dm_thin_aborted_changes(struct dm_thin_device *td);
 
 int dm_thin_get_highest_mapped_block(struct dm_thin_device *td,
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 0a9b087..9189838 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1346,7 +1346,8 @@ static void process_deferred_bios(struct pool *pool)
 	bio_list_init(&pool->deferred_flush_bios);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-	if (bio_list_empty(&bios) && !need_commit_due_to_time(pool))
+	if (bio_list_empty(&bios) &&
+	    !(dm_pool_changed_this_transaction(pool->pmd) && need_commit_due_to_time(pool)))
 		return;
 
 	if (commit(pool)) {
-- 
1.9.0

