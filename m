Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3KTQpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:45:21 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:45681 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3KTQpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:45:17 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [RFC PATCH v2 2/5] locks: rename locks_remove_flock to locks_remove_filp
Date: Wed, 20 Nov 2013 11:45:03 -0500
Message-Id: <1384965906-27327-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
References: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function currently removes leases in addition to flock locks, so
the name is misleading. Rename it to locks_remove_filp to indicate that
it removes locks that are associated with a particular filp.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/file_table.c    | 2 +-
 fs/locks.c         | 2 +-
 include/linux/fs.h | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 5fff903..5c83bf3 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -234,7 +234,7 @@ static void __fput(struct file *file)
 	 * in the file cleanup chain.
 	 */
 	eventpoll_release(file);
-	locks_remove_flock(file);
+	locks_remove_filp(file);
 
 	if (unlikely(file->f_flags & FASYNC)) {
 		if (file->f_op->fasync)
diff --git a/fs/locks.c b/fs/locks.c
index a387ef7..86cafc3 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2198,7 +2198,7 @@ EXPORT_SYMBOL(locks_remove_posix);
 /*
  * This function is called on the last close of an open file.
  */
-void locks_remove_flock(struct file *filp)
+void locks_remove_filp(struct file *filp)
 {
 	struct inode * inode = file_inode(filp);
 	struct file_lock *fl;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bf5d574..2d890ce 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1012,7 +1012,7 @@ extern struct file_lock * locks_alloc_lock(void);
 extern void locks_copy_lock(struct file_lock *, struct file_lock *);
 extern void __locks_copy_lock(struct file_lock *, const struct file_lock *);
 extern void locks_remove_posix(struct file *, fl_owner_t);
-extern void locks_remove_flock(struct file *);
+extern void locks_remove_filp(struct file *);
 extern void locks_release_private(struct file_lock *);
 extern void posix_test_lock(struct file *, struct file_lock *);
 extern int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
@@ -1083,7 +1083,7 @@ static inline void locks_remove_posix(struct file *filp, fl_owner_t owner)
 	return;
 }
 
-static inline void locks_remove_flock(struct file *filp)
+static inline void locks_remove_filp(struct file *filp)
 {
 	return;
 }
-- 
1.8.3.1

