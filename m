Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab3LJTUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:20:09 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:49110 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3LJTSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:18:01 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [PATCH v3 4/6] locks: show private lock types in /proc/locks
Date: Tue, 10 Dec 2013 14:17:33 -0500
Message-Id: <1386703055-22308-5-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a later patch, we'll be adding a new type of lock that's owned by
the struct file instead of the files_struct. Those sorts of locks
will be flagged with a new IS_FILE_PVT flag.

Show "private" locks in /proc/locks with a 'P' suffix. This does mean
that we need to widen the column by one character.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c         | 9 ++++++---
 include/linux/fs.h | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index fb10d58..e163a30 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -135,6 +135,7 @@
 #define IS_POSIX(fl)	(fl->fl_flags & FL_POSIX)
 #define IS_FLOCK(fl)	(fl->fl_flags & FL_FLOCK)
 #define IS_LEASE(fl)	(fl->fl_flags & (FL_LEASE|FL_DELEG))
+#define IS_FILE_PVT(fl)	(fl->fl_flags & FL_FILE_PVT)
 
 static bool lease_breaking(struct file_lock *fl)
 {
@@ -2358,13 +2359,15 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 		seq_printf(f, "UNKNOWN UNKNOWN  ");
 	}
 	if (fl->fl_type & LOCK_MAND) {
-		seq_printf(f, "%s ",
+		seq_printf(f, "%s  ",
 			       (fl->fl_type & LOCK_READ)
 			       ? (fl->fl_type & LOCK_WRITE) ? "RW   " : "READ "
 			       : (fl->fl_type & LOCK_WRITE) ? "WRITE" : "NONE ");
+	} else if (IS_FILE_PVT(fl)) {
+		seq_printf(f, "%s ", fl->fl_type == F_WRLCK ?  "WRITEP" : "READP ");
 	} else {
-		seq_printf(f, "%s ",
-			       (lease_breaking(fl))
+		seq_printf(f, "%s  ",
+			       lease_breaking(fl)
 			       ? (fl->fl_type == F_UNLCK) ? "UNLCK" : "READ "
 			       : (fl->fl_type == F_WRLCK) ? "WRITE" : "READ ");
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 51974e0..639a3b7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -888,6 +888,7 @@ static inline int file_check_writeable(struct file *filp)
 #define FL_SLEEP	128	/* A blocking lock */
 #define FL_DOWNGRADE_PENDING	256 /* Lease is being downgraded */
 #define FL_UNLOCK_PENDING	512 /* Lease is being broken */
+#define FL_FILE_PVT	1024	/* lock is private to the file */
 
 /*
  * Special return value from posix_lock_file() and vfs_lock_file() for
-- 
1.8.4.2

