Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbaAIOYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:24:46 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:33124 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaAIOUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:20:12 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/14] locks: rename locks_remove_flock to locks_remove_file
Date: Thu,  9 Jan 2014 09:19:42 -0500
Message-Id: <1389277187-18211-10-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function currently removes leases in addition to flock locks and in
a later patch we'll have it deal with a new type of POSIX lock too.
Rename it to locks_remove_file to indicate that it removes locks that
are associated with a particular struct file, and not just flock locks.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/file_table.c    | 2 +-
 fs/locks.c         | 2 +-
 include/linux/fs.h | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 5fff903..468543c 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -234,7 +234,7 @@ static void __fput(struct file *file)
 	 * in the file cleanup chain.
 	 */
 	eventpoll_release(file);
-	locks_remove_flock(file);
+	locks_remove_file(file);
 
 	if (unlikely(file->f_flags & FASYNC)) {
 		if (file->f_op->fasync)
diff --git a/fs/locks.c b/fs/locks.c
index 4cd2578..4d4e790 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2196,7 +2196,7 @@ EXPORT_SYMBOL(locks_remove_posix);
 /*
  * This function is called on the last close of an open file.
  */
-void locks_remove_flock(struct file *filp)
+void locks_remove_file(struct file *filp)
 {
 	struct inode * inode = file_inode(filp);
 	struct file_lock *fl;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 04be202..51974e0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1012,7 +1012,7 @@ extern struct file_lock * locks_alloc_lock(void);
 extern void locks_copy_lock(struct file_lock *, struct file_lock *);
 extern void __locks_copy_lock(struct file_lock *, const struct file_lock *);
 extern void locks_remove_posix(struct file *, fl_owner_t);
-extern void locks_remove_flock(struct file *);
+extern void locks_remove_file(struct file *);
 extern void locks_release_private(struct file_lock *);
 extern void posix_test_lock(struct file *, struct file_lock *);
 extern int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
@@ -1083,7 +1083,7 @@ static inline void locks_remove_posix(struct file *filp, fl_owner_t owner)
 	return;
 }
 
-static inline void locks_remove_flock(struct file *filp)
+static inline void locks_remove_file(struct file *filp)
 {
 	return;
 }
-- 
1.8.4.2

