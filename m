Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaCWSoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:44:32 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60530 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaCWSob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:44:31 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: Use RCU_INIT_POINTER(x, NULL) in file.c
Date: Mon, 24 Mar 2014 00:13:31 +0530
Message-Id: <1395600211-9034-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 fs/file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 60a45e9..f87f265 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -499,7 +499,7 @@ repeat:
 	/* Sanity check */
 	if (rcu_dereference_raw(fdt->fd[fd]) != NULL) {
 		printk(KERN_WARNING "alloc_fd: slot %d not NULL!\n", fd);
-		rcu_assign_pointer(fdt->fd[fd], NULL);
+		RCU_INIT_POINTER(fdt->fd[fd], NULL);
 	}
 #endif
 
@@ -590,7 +590,7 @@ int __close_fd(struct files_struct *files, unsigned fd)
 	file = fdt->fd[fd];
 	if (!file)
 		goto out_unlock;
-	rcu_assign_pointer(fdt->fd[fd], NULL);
+	RCU_INIT_POINTER(fdt->fd[fd], NULL);
 	__clear_close_on_exec(fd, fdt);
 	__put_unused_fd(files, fd);
 	spin_unlock(&files->file_lock);
@@ -625,7 +625,7 @@ void do_close_on_exec(struct files_struct *files)
 			file = fdt->fd[fd];
 			if (!file)
 				continue;
-			rcu_assign_pointer(fdt->fd[fd], NULL);
+			RCU_INIT_POINTER(fdt->fd[fd], NULL);
 			__put_unused_fd(files, fd);
 			spin_unlock(&files->file_lock);
 			filp_close(file, files);
-- 
1.7.9.5

