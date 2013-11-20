Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3KTQp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:45:28 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:44066 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3KTQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:45:19 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [RFC PATCH v2 3/5] locks: add new "private" lock type that is owned by the filp
Date: Wed, 20 Nov 2013 11:45:04 -0500
Message-Id: <1384965906-27327-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
References: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to some unfortunate history, POSIX locks have very strange and
unhelpful semantics. The thing that usually catches people by surprise
is that they are dropped whenever the process closes any file descriptor
associated with the inode.

This is extremely problematic for people developing file servers that
need to implement byte-range locks. Developers often need a "lock
management" facility to ensure that file descriptors are not closed
until all of the locks associated with the inode are finished.

This patchset adds a new type of lock that attempts to address this
issue. These locks work just like "normal" POSIX read/write locks, but
have semantics that are more like BSD locks with respect to inheritance
and behavior on close.

This is implemented primarily by changing how fl_owner field is set for
these locks. Instead of having them owned by the files_struct of the
process, they are instead owned by the filp on which they were acquired.
Thus, they are inherited across fork() and are only released when the
last reference to a filp is put.

These new semantics prevent them from being merged with "classic" POSIX
locks, even if they are acquired by the same process. These locks will
also conflict with "classic" POSIX locks even if they are acquired by
the same process or on the same file descriptor.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c                       | 22 +++++++++++++++++++++-
 include/uapi/asm-generic/fcntl.h | 15 +++++++++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index 86cafc3..3b278a6 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -348,6 +348,26 @@ static int posix_assign_type(struct file_lock *fl, long type)
 {
 	int err;
 
+	/*
+	 * FL_FILP_PRIVATE locks are "owned" by the filp upon which they were
+	 * acquired, regardless of what task is dealing with them. Set the
+	 * fl_owner appropriately.
+	 */
+	switch (type) {
+	case F_RDLCKP:
+		type = F_RDLCK;
+		fl->fl_owner = (fl_owner_t)fl->fl_file;
+		break;
+	case F_WRLCKP:
+		type = F_WRLCK;
+		fl->fl_owner = (fl_owner_t)fl->fl_file;
+		break;
+	case F_UNLCKP:
+		type = F_UNLCK;
+		fl->fl_owner = (fl_owner_t)fl->fl_file;
+		break;
+	}
+
 	err = assign_type(fl, type);
 	if (err)
 		return err;
@@ -2225,7 +2245,7 @@ void locks_remove_filp(struct file *filp)
 
 	while ((fl = *before) != NULL) {
 		if (fl->fl_file == filp) {
-			if (IS_FLOCK(fl)) {
+			if (IS_FLOCK(fl) || IS_POSIX(fl)) {
 				locks_delete_lock(before);
 				continue;
 			}
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 95e46c8..6b7b68a 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -151,6 +151,21 @@ struct f_owner_ex {
 #define F_UNLCK		2
 #endif
 
+/*
+ * fd "private" POSIX locks.
+ *
+ * Usually POSIX locks held by a process are released on *any* close and are
+ * not inherited across a fork().
+ *
+ * These lock types will conflict with normal POSIX locks, but are "owned"
+ * by the fd, not the process. This means that they are inherited across
+ * fork() like BSD (flock) locks, and they are only closed when the last
+ * reference to the the filp against which were acquired is closed.
+ */
+#define F_RDLCKP	5
+#define F_WRLCKP	6
+#define F_UNLCKP	7
+
 /* for old implementation of bsd flock () */
 #ifndef F_EXLCK
 #define F_EXLCK		4	/* or 3 */
-- 
1.8.3.1

