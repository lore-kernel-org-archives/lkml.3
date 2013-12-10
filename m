Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3LJTTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:19:46 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:38822 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3LJTSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:18:03 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [PATCH v3 5/6] locks: report l_pid as -1 for FL_FILE_PVT locks
Date: Tue, 10 Dec 2013 14:17:34 -0500
Message-Id: <1386703055-22308-6-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FL_FILE_PVT locks are no longer tied to a particular pid, and are
instead inheritable by child processes. Report a l_pid of '-1' for
these sorts of locks since the pid is somewhat meaningless for them.

This precedent comes from FreeBSD. There, POSIX and flock() locks can
conflict with one another. If fcntl(F_GETLK, ...) returns a lock set
with flock() then the l_pid member cannot be a process ID because the
lock is not held by a process as such.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index e163a30..5372ddd 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1899,7 +1899,7 @@ EXPORT_SYMBOL_GPL(vfs_test_lock);
 
 static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
 {
-	flock->l_pid = fl->fl_pid;
+	flock->l_pid = IS_FILE_PVT(fl) ? -1 : fl->fl_pid;
 #if BITS_PER_LONG == 32
 	/*
 	 * Make sure we can represent the posix lock via
@@ -1921,7 +1921,7 @@ static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
 #if BITS_PER_LONG == 32
 static void posix_lock_to_flock64(struct flock64 *flock, struct file_lock *fl)
 {
-	flock->l_pid = fl->fl_pid;
+	flock->l_pid = IS_FILE_PVT(fl) ? -1 : fl->fl_pid;
 	flock->l_start = fl->fl_start;
 	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
 		fl->fl_end - fl->fl_start + 1;
-- 
1.8.4.2

