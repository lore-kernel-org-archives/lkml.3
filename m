Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaANTKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:10:17 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:62707 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaANTHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:20 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 10/14] locks: make /proc/locks show IS_FILE_PVT locks with a P suffix
Date: Tue, 14 Jan 2014 14:06:50 -0500
Message-Id: <1389726414-30990-11-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
References: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a later patch, we'll be adding a new type of lock that's owned by
the struct file instead of the files_struct. Those sorts of locks
will be flagged with a new IS_FILE_PVT flag.

Add a "P" suffix to the POSIX lock output in /proc/locks for locks that
have FL_FILE_PVT set to distinguish them from "classic" POSIX locks.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c         | 9 +++++++--
 include/linux/fs.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 4d4e790..f1b9b14 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -135,6 +135,7 @@
 #define IS_POSIX(fl)	(fl->fl_flags & FL_POSIX)
 #define IS_FLOCK(fl)	(fl->fl_flags & FL_FLOCK)
 #define IS_LEASE(fl)	(fl->fl_flags & (FL_LEASE|FL_DELEG))
+#define IS_FILE_PVT(fl)	(fl->fl_flags & FL_FILE_PVT)
 
 static bool lease_breaking(struct file_lock *fl)
 {
@@ -2313,8 +2314,12 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 
 	seq_printf(f, "%lld:%s ", id, pfx);
 	if (IS_POSIX(fl)) {
-		seq_printf(f, "%6s %s ",
-			     (fl->fl_flags & FL_ACCESS) ? "ACCESS" : "POSIX ",
+		if (fl->fl_flags & FL_ACCESS)
+			seq_printf(f, "ACCESS");
+		else
+			seq_printf(f, "POSIX%c", IS_FILE_PVT(fl) ? 'P' : ' ');
+
+		seq_printf(f, " %s ",
 			     (inode == NULL) ? "*NOINODE*" :
 			     mandatory_lock(inode) ? "MANDATORY" : "ADVISORY ");
 	} else if (IS_FLOCK(fl)) {
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

