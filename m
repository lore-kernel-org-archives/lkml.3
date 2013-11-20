Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3KTQpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:45:31 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:42015 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab3KTQpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:45:22 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [RFC PATCH v2 5/5] locks: report l_pid as -1 for FL_FILP_PRIVATE locks
Date: Wed, 20 Nov 2013 11:45:06 -0500
Message-Id: <1384965906-27327-6-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
References: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FL_FILP_PRIVATE locks are no longer tied to a particular PID, and are
instead inheritable by child processes. Report a l_pid of '-1' for
these sorts of locks since the pid is somewhat meaningless for them.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index d5fb853..8a4d4e4 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1889,7 +1889,7 @@ EXPORT_SYMBOL_GPL(vfs_test_lock);
 
 static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
 {
-	flock->l_pid = fl->fl_pid;
+	flock->l_pid = IS_FILP_PVT(fl) ? -1 : fl->fl_pid;
 #if BITS_PER_LONG == 32
 	/*
 	 * Make sure we can represent the posix lock via
@@ -1911,7 +1911,7 @@ static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
 #if BITS_PER_LONG == 32
 static void posix_lock_to_flock64(struct flock64 *flock, struct file_lock *fl)
 {
-	flock->l_pid = fl->fl_pid;
+	flock->l_pid = IS_FILP_PVT(fl) ? -1 : fl->fl_pid;
 	flock->l_start = fl->fl_start;
 	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
 		fl->fl_end - fl->fl_start + 1;
-- 
1.8.3.1

