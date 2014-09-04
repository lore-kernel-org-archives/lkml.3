Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaIDO1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:27:45 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:43124 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaIDO1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:27:43 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] locks: flock_make_lock should return a struct file_lock (or PTR_ERR)
Date: Thu,  4 Sep 2014 10:27:35 -0400
Message-Id: <1409840855-10557-1-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the need for a return pointer.

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/locks.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 314135ad820b..735b8d3fa78c 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -326,17 +326,18 @@ static inline int flock_translate_cmd(int cmd) {
 }
 
 /* Fill in a file_lock structure with an appropriate FLOCK lock. */
-static int flock_make_lock(struct file *filp, struct file_lock **lock,
-		unsigned int cmd)
+static struct file_lock *
+flock_make_lock(struct file *filp, unsigned int cmd)
 {
 	struct file_lock *fl;
 	int type = flock_translate_cmd(cmd);
+
 	if (type < 0)
-		return type;
+		return ERR_PTR(type);
 	
 	fl = locks_alloc_lock();
 	if (fl == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	fl->fl_file = filp;
 	fl->fl_owner = filp;
@@ -345,8 +346,7 @@ static int flock_make_lock(struct file *filp, struct file_lock **lock,
 	fl->fl_type = type;
 	fl->fl_end = OFFSET_MAX;
 	
-	*lock = fl;
-	return 0;
+	return fl;
 }
 
 static int assign_type(struct file_lock *fl, long type)
@@ -1885,9 +1885,12 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
 	    !(f.file->f_mode & (FMODE_READ|FMODE_WRITE)))
 		goto out_putf;
 
-	error = flock_make_lock(f.file, &lock, cmd);
-	if (error)
+	lock = flock_make_lock(f.file, cmd);
+	if (IS_ERR(lock)) {
+		error = PTR_ERR(lock);
 		goto out_putf;
+	}
+
 	if (can_sleep)
 		lock->fl_flags |= FL_SLEEP;
 
-- 
1.9.3

