Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaIJO3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:29:17 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62845 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaIJO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:29:13 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, bfields@fieldses.org
Subject: [RFC PATCH 10/12] lockd: convert it to use file_lock_context
Date: Wed, 10 Sep 2014 10:28:48 -0400
Message-Id: <1410359330-27564-11-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/lockd/svcsubs.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index b6f3b84b6e99..93448f5357f0 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -164,12 +164,15 @@ nlm_traverse_locks(struct nlm_host *host, struct nlm_file *file,
 {
 	struct inode	 *inode = nlmsvc_file_inode(file);
 	struct file_lock *fl;
+	struct file_lock_context *flctx = inode->i_flctx;
 	struct nlm_host	 *lockhost;
 
+	if (!flctx)
+		return 0;
 again:
 	file->f_locks = 0;
-	spin_lock(&inode->i_lock);
-	for (fl = inode->i_flock; fl; fl = fl->fl_next) {
+	spin_lock(&flctx->flc_lock);
+	list_for_each_entry(fl, &flctx->flc_posix, fl_list) {
 		if (fl->fl_lmops != &nlmsvc_lock_operations)
 			continue;
 
@@ -180,7 +183,7 @@ again:
 		if (match(lockhost, host)) {
 			struct file_lock lock = *fl;
 
-			spin_unlock(&inode->i_lock);
+			spin_unlock(&flctx->flc_lock);
 			lock.fl_type  = F_UNLCK;
 			lock.fl_start = 0;
 			lock.fl_end   = OFFSET_MAX;
@@ -192,7 +195,7 @@ again:
 			goto again;
 		}
 	}
-	spin_unlock(&inode->i_lock);
+	spin_unlock(&flctx->flc_lock);
 
 	return 0;
 }
@@ -223,18 +226,21 @@ nlm_file_inuse(struct nlm_file *file)
 {
 	struct inode	 *inode = nlmsvc_file_inode(file);
 	struct file_lock *fl;
+	struct file_lock_context *flctx = inode->i_flctx;
 
 	if (file->f_count || !list_empty(&file->f_blocks) || file->f_shares)
 		return 1;
 
-	spin_lock(&inode->i_lock);
-	for (fl = inode->i_flock; fl; fl = fl->fl_next) {
-		if (fl->fl_lmops == &nlmsvc_lock_operations) {
-			spin_unlock(&inode->i_lock);
-			return 1;
+	if (flctx) {
+		spin_lock(&flctx->flc_lock);
+		list_for_each_entry(fl, &flctx->flc_posix, fl_list) {
+			if (fl->fl_lmops == &nlmsvc_lock_operations) {
+				spin_unlock(&flctx->flc_lock);
+				return 1;
+			}
 		}
+		spin_unlock(&flctx->flc_lock);
 	}
-	spin_unlock(&inode->i_lock);
 	file->f_locks = 0;
 	return 0;
 }
-- 
1.9.3

