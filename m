Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3LSNjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:39:07 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:40525 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab3LSNez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:34:55 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 06/13] locks: consolidate common code in the flock_to_posix_lock routines
Date: Thu, 19 Dec 2013 08:34:18 -0500
Message-Id: <1387460065-28269-7-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387460065-28269-1-git-send-email-jlayton@redhat.com>
References: <1387460065-28269-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@fieldses.org>

Currently, there's a lot of copy and paste between the two.  Add some
functions to do the initialization of the file_lock from values
passed in, and turn the flock/flock64 variants of those functions into
wrappers around them.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@fieldses.org>
---
 fs/locks.c                       | 112 +++++++++++++++------------------------
 include/uapi/asm-generic/fcntl.h |   3 --
 2 files changed, 44 insertions(+), 71 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index dd30933..863f4df 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -344,48 +344,42 @@ static int assign_type(struct file_lock *fl, long type)
 	return 0;
 }
 
-/* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
- * style lock.
- */
-static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
-			       struct flock *l)
+static int flock_to_posix_lock_common(struct file *filp, struct file_lock *fl,
+					struct flock64 *l, loff_t offset_max)
 {
-	off_t start, end;
-
 	switch (l->l_whence) {
 	case SEEK_SET:
-		start = 0;
+		fl->fl_start = 0;
 		break;
 	case SEEK_CUR:
-		start = filp->f_pos;
+		fl->fl_start = filp->f_pos;
 		break;
 	case SEEK_END:
-		start = i_size_read(file_inode(filp));
+		fl->fl_start = i_size_read(file_inode(filp));
 		break;
 	default:
 		return -EINVAL;
 	}
+	if (l->l_start > offset_max - fl->fl_start)
+		return -EOVERFLOW;
+	fl->fl_start += l->l_start;
+	if (fl->fl_start < 0)
+		return -EINVAL;
+	if (l->l_len > offset_max - fl->fl_start)
+		return -EOVERFLOW;
+	if (fl->fl_start + l->l_len < 0)
+		return -EINVAL;
 
 	/* POSIX-1996 leaves the case l->l_len < 0 undefined;
 	   POSIX-2001 defines it. */
-	start += l->l_start;
-	if (start < 0)
-		return -EINVAL;
-	fl->fl_end = OFFSET_MAX;
-	if (l->l_len > 0) {
-		end = start + l->l_len - 1;
-		fl->fl_end = end;
-	} else if (l->l_len < 0) {
-		end = start - 1;
-		fl->fl_end = end;
-		start += l->l_len;
-		if (start < 0)
-			return -EINVAL;
-	}
-	fl->fl_start = start;	/* we record the absolute position */
-	if (fl->fl_end < fl->fl_start)
-		return -EOVERFLOW;
-	
+	if (l->l_len > 0)
+		fl->fl_end = fl->fl_start + l->l_len - 1;
+	else if (l->l_len < 0) {
+		fl->fl_end = fl->fl_start - 1;
+		fl->fl_start += l->l_len;
+	} else
+		fl->fl_end = OFFSET_MAX;
+
 	fl->fl_owner = current->files;
 	fl->fl_pid = current->tgid;
 	fl->fl_file = filp;
@@ -396,50 +390,32 @@ static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
 	return assign_type(fl, l->l_type);
 }
 
+/* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
+ * style lock.
+ */
+static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
+			       struct flock *l)
+{
+	struct flock64 ll = {
+		.l_type = l->l_type,
+		.l_whence = l->l_whence,
+		.l_start = l->l_start,
+		.l_len = l->l_len,
+	};
+
+	/*
+	 * The use of OFFT_OFFSET_MAX here ensures we return -EOVERFLOW
+	 * if the start or end of the lock could not be represented as
+	 * an off_t, following SUSv3.
+	 */
+	return flock_to_posix_lock_common(filp, fl, &ll, OFFT_OFFSET_MAX);
+}
+
 #if BITS_PER_LONG == 32
 static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
 				 struct flock64 *l)
 {
-	loff_t start;
-
-	switch (l->l_whence) {
-	case SEEK_SET:
-		start = 0;
-		break;
-	case SEEK_CUR:
-		start = filp->f_pos;
-		break;
-	case SEEK_END:
-		start = i_size_read(file_inode(filp));
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	start += l->l_start;
-	if (start < 0)
-		return -EINVAL;
-	fl->fl_end = OFFSET_MAX;
-	if (l->l_len > 0) {
-		fl->fl_end = start + l->l_len - 1;
-	} else if (l->l_len < 0) {
-		fl->fl_end = start - 1;
-		start += l->l_len;
-		if (start < 0)
-			return -EINVAL;
-	}
-	fl->fl_start = start;	/* we record the absolute position */
-	if (fl->fl_end < fl->fl_start)
-		return -EOVERFLOW;
-	
-	fl->fl_owner = current->files;
-	fl->fl_pid = current->tgid;
-	fl->fl_file = filp;
-	fl->fl_flags = FL_POSIX;
-	fl->fl_ops = NULL;
-	fl->fl_lmops = NULL;
-
-	return assign_type(fl, l->l_type);
+	return flock_to_posix_lock_common(filp, fl, l, OFFSET_MAX);
 }
 #endif
 
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 95e46c8..36025f7 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -186,8 +186,6 @@ struct flock {
 };
 #endif
 
-#ifndef CONFIG_64BIT
-
 #ifndef HAVE_ARCH_STRUCT_FLOCK64
 #ifndef __ARCH_FLOCK64_PAD
 #define __ARCH_FLOCK64_PAD
@@ -202,6 +200,5 @@ struct flock64 {
 	__ARCH_FLOCK64_PAD
 };
 #endif
-#endif /* !CONFIG_64BIT */
 
 #endif /* _ASM_GENERIC_FCNTL_H */
-- 
1.8.4.2

