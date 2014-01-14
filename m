Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaANTK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:10:59 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:41756 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaANTHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:15 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 06/14] locks: fix posix lock range overflow handling
Date: Tue, 14 Jan 2014 14:06:46 -0500
Message-Id: <1389726414-30990-7-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
References: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

In the 32-bit case fcntl assigns the 64-bit f_pos and i_size to a 32-bit
off_t.

The existing range checks also seem to depend on signed arithmetic
wrapping when it overflows.  In practice maybe that works, but we can be
more careful.  That also allows us to make a more reliable distinction
between -EINVAL and -EOVERFLOW.

Note that in the 32-bit case SEEK_CUR or SEEK_END might allow the caller
to set a lock with starting point no longer representable as a 32-bit
value.  We could return -EOVERFLOW in such cases, but the locks code is
capable of handling such ranges, so we choose to be lenient here.  The
only problem is that subsequent GETLK calls on such a lock will fail
with EOVERFLOW.

While we're here, do some cleanup including consolidating code for the
flock and flock64 cases.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/locks.c                       | 100 +++++++++++++--------------------------
 include/uapi/asm-generic/fcntl.h |   3 --
 2 files changed, 32 insertions(+), 71 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index dd30933..b49e853 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -344,48 +344,43 @@ static int assign_type(struct file_lock *fl, long type)
 	return 0;
 }
 
-/* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
- * style lock.
- */
-static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
-			       struct flock *l)
+static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
+				 struct flock64 *l)
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
+	if (l->l_start > OFFSET_MAX - fl->fl_start)
+		return -EOVERFLOW;
+	fl->fl_start += l->l_start;
+	if (fl->fl_start < 0)
+		return -EINVAL;
 
 	/* POSIX-1996 leaves the case l->l_len < 0 undefined;
 	   POSIX-2001 defines it. */
-	start += l->l_start;
-	if (start < 0)
-		return -EINVAL;
-	fl->fl_end = OFFSET_MAX;
 	if (l->l_len > 0) {
-		end = start + l->l_len - 1;
-		fl->fl_end = end;
+		if (l->l_len - 1 > OFFSET_MAX - fl->fl_start)
+			return -EOVERFLOW;
+		fl->fl_end = fl->fl_start + l->l_len - 1;
+
 	} else if (l->l_len < 0) {
-		end = start - 1;
-		fl->fl_end = end;
-		start += l->l_len;
-		if (start < 0)
+		if (fl->fl_start + l->l_len < 0)
 			return -EINVAL;
-	}
-	fl->fl_start = start;	/* we record the absolute position */
-	if (fl->fl_end < fl->fl_start)
-		return -EOVERFLOW;
-	
+		fl->fl_end = fl->fl_start - 1;
+		fl->fl_start += l->l_len;
+	} else
+		fl->fl_end = OFFSET_MAX;
+
 	fl->fl_owner = current->files;
 	fl->fl_pid = current->tgid;
 	fl->fl_file = filp;
@@ -396,52 +391,21 @@ static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
 	return assign_type(fl, l->l_type);
 }
 
-#if BITS_PER_LONG == 32
-static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
-				 struct flock64 *l)
+/* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
+ * style lock.
+ */
+static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
+			       struct flock *l)
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
+	struct flock64 ll = {
+		.l_type = l->l_type,
+		.l_whence = l->l_whence,
+		.l_start = l->l_start,
+		.l_len = l->l_len,
+	};
 
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
+	return flock64_to_posix_lock(filp, fl, &ll);
 }
-#endif
 
 /* default lease lock manager operations */
 static void lease_break_callback(struct file_lock *fl)
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

