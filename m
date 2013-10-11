Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab3JKM0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:26:33 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:51505 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3JKMZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:25:29 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [RFC PATCH 2/5] locks: add definitions for F_RDLCKP and F_WRLCKP
Date: Fri, 11 Oct 2013 08:25:19 -0400
Message-Id: <1381494322-2426-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No arch seems to use these values for anything, so defining them
globally should be ok. When they are specified, translate them into
their non-P variants, and set the FL_FILP_PRIVATE flag to indicate
that they should get the proper behavior on close.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c                       | 11 +++++++++++
 include/linux/fs.h               |  1 +
 include/uapi/asm-generic/fcntl.h |  9 +++++++++
 3 files changed, 21 insertions(+)

diff --git a/fs/locks.c b/fs/locks.c
index 389382c..086c3b4 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -348,6 +348,17 @@ static int posix_assign_type(struct file_lock *fl, long type)
 {
 	int err;
 
+	switch(type) {
+	case F_RDLCKP:
+		type = F_RDLCK;
+		fl->fl_flags |= FL_FILP_PRIVATE;
+		break;
+	case F_WRLCKP:
+		type = F_WRLCK;
+		fl->fl_flags |= FL_FILP_PRIVATE;
+		break;
+	}
+
 	err = assign_type(fl, type);
 	if (err)
 		return err;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b46bfa5..df502bf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -889,6 +889,7 @@ static inline int file_check_writeable(struct file *filp)
 #define FL_SLEEP	128	/* A blocking lock */
 #define FL_DOWNGRADE_PENDING	256 /* Lease is being downgraded */
 #define FL_UNLOCK_PENDING	512 /* Lease is being broken */
+#define FL_FILP_PRIVATE	1024	/* only release on close of filp on which it was set */
 
 /*
  * Special return value from posix_lock_file() and vfs_lock_file() for
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 95e46c8..0a4be0d 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -151,6 +151,15 @@ struct f_owner_ex {
 #define F_UNLCK		2
 #endif
 
+/*
+ * fd "private" POSIX locks. Usually POSIX locks held by a process are
+ * released on *any* close. If they are acquired using these l_type
+ * values, then they are only released on close of the fd on which they
+ * were acquired, similar to how BSD locks work.
+ */
+#define F_RDLCKP	5
+#define F_WRLCKP	6
+
 /* for old implementation of bsd flock () */
 #ifndef F_EXLCK
 #define F_EXLCK		4	/* or 3 */
-- 
1.8.3.1

