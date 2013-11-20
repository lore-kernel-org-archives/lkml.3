Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3KTQqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:46:52 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:64257 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3KTQpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:45:16 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [RFC PATCH v2 1/5] locks: consolidate checks for compatible filp->f_mode values in setlk handlers
Date: Wed, 20 Nov 2013 11:45:02 -0500
Message-Id: <1384965906-27327-2-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
References: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a wrapper around assign_type that does this instead of duplicating
this check in two places. This also fixes a minor wart in the code where
we continue referring to the struct flock after converting it to struct
file_lock.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 61 +++++++++++++++++++++++++------------------------------------
 1 file changed, 25 insertions(+), 36 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 92a0f0a..a387ef7 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -344,6 +344,29 @@ static int assign_type(struct file_lock *fl, long type)
 	return 0;
 }
 
+static int posix_assign_type(struct file_lock *fl, long type)
+{
+	int err;
+
+	err = assign_type(fl, type);
+	if (err)
+		return err;
+
+	/* Ensure that fl->fl_filp has compatible f_mode */
+	switch (fl->fl_type) {
+	case F_RDLCK:
+		if (!(fl->fl_file->f_mode & FMODE_READ))
+			return -EBADF;
+		break;
+	case F_WRLCK:
+		if (!(fl->fl_file->f_mode & FMODE_WRITE))
+			return -EBADF;
+		break;
+	}
+
+	return 0;
+}
+
 /* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
  * style lock.
  */
@@ -393,7 +416,7 @@ static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
 	fl->fl_ops = NULL;
 	fl->fl_lmops = NULL;
 
-	return assign_type(fl, l->l_type);
+	return posix_assign_type(fl, l->l_type);
 }
 
 #if BITS_PER_LONG == 32
@@ -439,7 +462,7 @@ static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
 	fl->fl_ops = NULL;
 	fl->fl_lmops = NULL;
 
-	return assign_type(fl, l->l_type);
+	return posix_assign_type(fl, l->l_type);
 }
 #endif
 
@@ -2016,23 +2039,6 @@ again:
 		file_lock->fl_flags |= FL_SLEEP;
 	}
 	
-	error = -EBADF;
-	switch (flock.l_type) {
-	case F_RDLCK:
-		if (!(filp->f_mode & FMODE_READ))
-			goto out;
-		break;
-	case F_WRLCK:
-		if (!(filp->f_mode & FMODE_WRITE))
-			goto out;
-		break;
-	case F_UNLCK:
-		break;
-	default:
-		error = -EINVAL;
-		goto out;
-	}
-
 	error = do_lock_file_wait(filp, cmd, file_lock);
 
 	/*
@@ -2134,23 +2140,6 @@ again:
 		file_lock->fl_flags |= FL_SLEEP;
 	}
 	
-	error = -EBADF;
-	switch (flock.l_type) {
-	case F_RDLCK:
-		if (!(filp->f_mode & FMODE_READ))
-			goto out;
-		break;
-	case F_WRLCK:
-		if (!(filp->f_mode & FMODE_WRITE))
-			goto out;
-		break;
-	case F_UNLCK:
-		break;
-	default:
-		error = -EINVAL;
-		goto out;
-	}
-
 	error = do_lock_file_wait(filp, cmd, file_lock);
 
 	/*
-- 
1.8.3.1

