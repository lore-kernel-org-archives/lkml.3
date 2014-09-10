Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaIJOcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:32:43 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:45125 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaIJO3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:29:08 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, bfields@fieldses.org
Subject: [RFC PATCH 07/12] ceph: convert to looking for locks in struct file_lock_context
Date: Wed, 10 Sep 2014 10:28:45 -0400
Message-Id: <1410359330-27564-8-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/ceph/locks.c      | 45 ++++++++++++++++++++++++++++-----------------
 fs/ceph/mds_client.c |  4 ----
 2 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index fbc39c47bacd..9246ce3c6161 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -203,16 +203,21 @@ int ceph_flock(struct file *file, int cmd, struct file_lock *fl)
 void ceph_count_locks(struct inode *inode, int *fcntl_count, int *flock_count)
 {
 	struct file_lock *lock;
+	struct file_lock_context *ctx;
 
 	*fcntl_count = 0;
 	*flock_count = 0;
 
-	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
-		if (lock->fl_flags & FL_POSIX)
+	ctx = inode->i_flctx;
+	if (ctx) {
+		spin_lock(&ctx->flc_lock);
+		list_for_each_entry(lock, &ctx->flc_posix, fl_list)
 			++(*fcntl_count);
-		else if (lock->fl_flags & FL_FLOCK)
+		list_for_each_entry(lock, &ctx->flc_flock, fl_list)
 			++(*flock_count);
+		spin_unlock(&ctx->flc_lock);
 	}
+
 	dout("counted %d flock locks and %d fcntl locks",
 	     *flock_count, *fcntl_count);
 }
@@ -227,6 +232,7 @@ int ceph_encode_locks_to_buffer(struct inode *inode,
 				int num_fcntl_locks, int num_flock_locks)
 {
 	struct file_lock *lock;
+	struct file_lock_context *ctx;
 	int err = 0;
 	int seen_fcntl = 0;
 	int seen_flock = 0;
@@ -235,33 +241,38 @@ int ceph_encode_locks_to_buffer(struct inode *inode,
 	dout("encoding %d flock and %d fcntl locks", num_flock_locks,
 	     num_fcntl_locks);
 
-	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
-		if (lock->fl_flags & FL_POSIX) {
-			++seen_fcntl;
-			if (seen_fcntl > num_fcntl_locks) {
+	ctx = inode->i_flctx;
+	if (ctx) {
+		spin_lock(&ctx->flc_lock);
+		list_for_each_entry(lock, &ctx->flc_flock, fl_list) {
+			++seen_flock;
+			if (seen_flock > num_flock_locks) {
 				err = -ENOSPC;
-				goto fail;
+				break;
 			}
 			err = lock_to_ceph_filelock(lock, &flocks[l]);
 			if (err)
-				goto fail;
+				break;
 			++l;
 		}
-	}
-	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
-		if (lock->fl_flags & FL_FLOCK) {
-			++seen_flock;
-			if (seen_flock > num_flock_locks) {
+
+		if (err)
+			goto fail;
+
+		list_for_each_entry(lock, &ctx->flc_posix, fl_list) {
+			++seen_fcntl;
+			if (seen_fcntl > num_fcntl_locks) {
 				err = -ENOSPC;
-				goto fail;
+				break;
 			}
 			err = lock_to_ceph_filelock(lock, &flocks[l]);
 			if (err)
-				goto fail;
+				break;
 			++l;
 		}
-	}
 fail:
+		spin_unlock(&ctx->flc_lock);
+	}
 	return err;
 }
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index bad07c09f91e..6778da54f7c8 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2612,20 +2612,16 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		struct ceph_filelock *flocks;
 
 encode_again:
-		spin_lock(&inode->i_lock);
 		ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
-		spin_unlock(&inode->i_lock);
 		flocks = kmalloc((num_fcntl_locks+num_flock_locks) *
 				 sizeof(struct ceph_filelock), GFP_NOFS);
 		if (!flocks) {
 			err = -ENOMEM;
 			goto out_free;
 		}
-		spin_lock(&inode->i_lock);
 		err = ceph_encode_locks_to_buffer(inode, flocks,
 						  num_fcntl_locks,
 						  num_flock_locks);
-		spin_unlock(&inode->i_lock);
 		if (err) {
 			kfree(flocks);
 			if (err == -ENOSPC)
-- 
1.9.3

