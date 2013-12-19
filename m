Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3LSNhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:37:22 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:55352 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3LSNfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:35:01 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 09/13] locks: don't reference original flock struct in F_GETLK handlers
Date: Thu, 19 Dec 2013 08:34:21 -0500
Message-Id: <1387460065-28269-10-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387460065-28269-1-git-send-email-jlayton@redhat.com>
References: <1387460065-28269-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The locks code currently sanity checks the type values in the flock
struct before doing the flock->file_lock conversion. That will be
problematic when new l_type values are introduced in a later patch.

Instead, do the flock_to_posix_lock conversion first, and then sanity
check the values in the file_lock instead.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 820322d..8180141 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1905,14 +1905,15 @@ int fcntl_getlk(struct file *filp, struct flock __user *l)
 	error = -EFAULT;
 	if (copy_from_user(&flock, l, sizeof(flock)))
 		goto out;
-	error = -EINVAL;
-	if ((flock.l_type != F_RDLCK) && (flock.l_type != F_WRLCK))
-		goto out;
 
 	error = flock_to_posix_lock(filp, &file_lock, &flock);
 	if (error)
 		goto out;
 
+	error = -EINVAL;
+	if ((file_lock.fl_type != F_RDLCK) && (file_lock.fl_type != F_WRLCK))
+		goto out;
+
 	error = vfs_test_lock(filp, &file_lock);
 	if (error)
 		goto out;
@@ -2073,14 +2074,15 @@ int fcntl_getlk64(struct file *filp, struct flock64 __user *l)
 	error = -EFAULT;
 	if (copy_from_user(&flock, l, sizeof(flock)))
 		goto out;
-	error = -EINVAL;
-	if ((flock.l_type != F_RDLCK) && (flock.l_type != F_WRLCK))
-		goto out;
 
 	error = flock64_to_posix_lock(filp, &file_lock, &flock);
 	if (error)
 		goto out;
 
+	error = -EINVAL;
+	if ((file_lock.fl_type != F_RDLCK) && (file_lock.fl_type != F_WRLCK))
+		goto out;
+
 	error = vfs_test_lock(filp, &file_lock);
 	if (error)
 		goto out;
-- 
1.8.4.2

