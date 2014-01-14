Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaANTH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:07:28 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:48571 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaANTHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:18 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 07/14] locks: consolidate checks for compatible filp->f_mode values in setlk handlers
Date: Tue, 14 Jan 2014 14:06:47 -0500
Message-Id: <1389726414-30990-8-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
References: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move this check into flock64_to_posix_lock instead of duplicating it in
two places. This also fixes a minor wart in the code where we continue
referring to the struct flock after converting it to struct file_lock.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 46 ++++++++++++----------------------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index b49e853..4cd2578 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -388,6 +388,18 @@ static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
 	fl->fl_ops = NULL;
 	fl->fl_lmops = NULL;
 
+	/* Ensure that fl->fl_filp has compatible f_mode */
+	switch (l->l_type) {
+	case F_RDLCK:
+		if (!(filp->f_mode & FMODE_READ))
+			return -EBADF;
+		break;
+	case F_WRLCK:
+		if (!(filp->f_mode & FMODE_WRITE))
+			return -EBADF;
+		break;
+	}
+
 	return assign_type(fl, l->l_type);
 }
 
@@ -2025,23 +2037,6 @@ again:
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
@@ -2143,23 +2138,6 @@ again:
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
1.8.4.2

