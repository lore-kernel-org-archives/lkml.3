Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaHLOsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:48:55 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:56258 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaHLOsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:48:24 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH 4/5] locks: move locks_free_lock calls in do_fcntl_add_lease outside spinlock
Date: Tue, 12 Aug 2014 10:48:12 -0400
Message-Id: <1407854893-2698-5-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407854893-2698-1-git-send-email-jlayton@primarydata.com>
References: <1407854893-2698-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to call locks_free_lock here while still holding the
i_lock. Defer that until the lock has been dropped.

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/locks.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 4ce087cca501..cb66fb05ad4a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1761,13 +1761,10 @@ static int do_fcntl_add_lease(unsigned int fd, struct file *filp, long arg)
 	ret = fl;
 	spin_lock(&inode->i_lock);
 	error = __vfs_setlease(filp, arg, &ret);
-	if (error) {
-		spin_unlock(&inode->i_lock);
-		locks_free_lock(fl);
-		goto out_free_fasync;
-	}
-	if (ret != fl)
-		locks_free_lock(fl);
+	if (error)
+		goto out_unlock;
+	if (ret == fl)
+		fl = NULL;
 
 	/*
 	 * fasync_insert_entry() returns the old entry if any.
@@ -1779,9 +1776,10 @@ static int do_fcntl_add_lease(unsigned int fd, struct file *filp, long arg)
 		new = NULL;
 
 	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
+out_unlock:
 	spin_unlock(&inode->i_lock);
-
-out_free_fasync:
+	if (fl)
+		locks_free_lock(fl);
 	if (new)
 		fasync_free(new);
 	return error;
-- 
1.9.3

