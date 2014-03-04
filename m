Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbaCDUEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:04:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964AbaCDUEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Larsson <alexl@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3.13 164/172] dm thin: avoid metadata commit if a pools thin devices havent changed
Date: Tue,  4 Mar 2014 12:04:08 -0800
Message-Id: <20140304200304.950307485@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin-metadata.c |   17 +++++++++++++++++
 drivers/md/dm-thin-metadata.h |    2 ++
 drivers/md/dm-thin.c          |    3 ++-
 3 files changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1489,6 +1489,23 @@ bool dm_thin_changed_this_transaction(st
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
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -161,6 +161,8 @@ int dm_thin_remove_block(struct dm_thin_
  */
 bool dm_thin_changed_this_transaction(struct dm_thin_device *td);
 
+bool dm_pool_changed_this_transaction(struct dm_pool_metadata *pmd);
+
 bool dm_thin_aborted_changes(struct dm_thin_device *td);
 
 int dm_thin_get_highest_mapped_block(struct dm_thin_device *td,
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1354,7 +1354,8 @@ static void process_deferred_bios(struct
 	bio_list_init(&pool->deferred_flush_bios);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-	if (bio_list_empty(&bios) && !need_commit_due_to_time(pool))
+	if (bio_list_empty(&bios) &&
+	    !(dm_pool_changed_this_transaction(pool->pmd) && need_commit_due_to_time(pool)))
 		return;
 
 	if (commit(pool)) {


