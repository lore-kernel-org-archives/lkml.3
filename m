Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3LJTSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:18:00 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:35190 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3LJTR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:17:57 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [PATCH v3 2/6] locks: consolidate checks for compatible filp->f_mode values in setlk handlers
Date: Tue, 10 Dec 2013 14:17:31 -0500
Message-Id: <1386703055-22308-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move this check into the posix_lock_setup_common handler instead of
duplicating this check in two places. This also fixes a minor wart in
the code where we continue referring to the struct flock after
converting it to struct file_lock.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 46 ++++++++++++----------------------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index a5848ed..f96c455 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -354,6 +354,18 @@ flock_to_posix_lock_common(struct file_lock *fl, struct file *filp, short type)
 	fl->fl_ops = NULL;
 	fl->fl_lmops = NULL;
 
+	/* Ensure that fl->fl_filp has compatible f_mode */
+	switch (type) {
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
 	return assign_type(fl, type);
 }
 
@@ -2060,23 +2072,6 @@ again:
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
@@ -2178,23 +2173,6 @@ again:
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

