Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaIJOeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:34:20 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:36991 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaIJO3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:29:02 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, bfields@fieldses.org
Subject: [RFC PATCH 03/12] locks: have locks_release_file use flock_lock_file to release generic flock locks
Date: Wed, 10 Sep 2014 10:28:41 -0400
Message-Id: <1410359330-27564-4-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/locks.c | 49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index af55bd35be5f..5e8b865814a2 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2393,6 +2393,30 @@ void locks_remove_posix(struct file *filp, fl_owner_t owner)
 
 EXPORT_SYMBOL(locks_remove_posix);
 
+static void
+locks_remove_flock(struct file *filp)
+{
+	struct file_lock fl = {
+		.fl_owner = filp,
+		.fl_pid = current->tgid,
+		.fl_file = filp,
+		.fl_flags = FL_FLOCK,
+		.fl_type = F_UNLCK,
+		.fl_end = OFFSET_MAX,
+	};
+
+	if (!file_inode(filp)->i_flock)
+		return;
+
+	if (filp->f_op->flock)
+		filp->f_op->flock(filp, F_SETLKW, &fl);
+	else
+		flock_lock_file(filp, &fl);
+
+	if (fl.fl_ops && fl.fl_ops->fl_release_private)
+		fl.fl_ops->fl_release_private(&fl);
+}
+
 /*
  * This function is called on the last close of an open file.
  */
@@ -2403,24 +2427,14 @@ void locks_remove_file(struct file *filp)
 	struct file_lock **before;
 	LIST_HEAD(dispose);
 
-	if (!inode->i_flock)
-		return;
-
+	/* remove any OFD locks */
 	locks_remove_posix(filp, filp);
 
-	if (filp->f_op->flock) {
-		struct file_lock fl = {
-			.fl_owner = filp,
-			.fl_pid = current->tgid,
-			.fl_file = filp,
-			.fl_flags = FL_FLOCK,
-			.fl_type = F_UNLCK,
-			.fl_end = OFFSET_MAX,
-		};
-		filp->f_op->flock(filp, F_SETLKW, &fl);
-		if (fl.fl_ops && fl.fl_ops->fl_release_private)
-			fl.fl_ops->fl_release_private(&fl);
-	}
+	/* remove flock locks */
+	locks_remove_flock(filp);
+
+	if (!inode->i_flock)
+		return;
 
 	spin_lock(&inode->i_lock);
 	before = &inode->i_flock;
@@ -2440,8 +2454,7 @@ void locks_remove_file(struct file *filp)
 			 * some info about it and then just remove it from
 			 * the list.
 			 */
-			WARN(!IS_FLOCK(fl),
-				"leftover lock: dev=%u:%u ino=%lu type=%hhd flags=0x%x start=%lld end=%lld\n",
+			WARN(1, "leftover lock: dev=%u:%u ino=%lu type=%hhd flags=0x%x start=%lld end=%lld\n",
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino,
 				fl->fl_type, fl->fl_flags,
-- 
1.9.3

