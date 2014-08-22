Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbaHVOCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:02:35 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58164 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbaHVOC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:02:29 -0400
Date: Fri, 22 Aug 2014 17:02:20 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] fs: file: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140822140220.GA31576@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uses of "rcu_assign_pointer()" are NULLing out the pointers.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 fs/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 66923fe..cd6a471 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -491,7 +491,7 @@ repeat:
 	/* Sanity check */
 	if (rcu_access_pointer(fdt->fd[fd]) != NULL) {
 		printk(KERN_WARNING "alloc_fd: slot %d not NULL!\n", fd);
-		rcu_assign_pointer(fdt->fd[fd], NULL);
+		RCU_INIT_POINTER(fdt->fd[fd], NULL);
 	}
 #endif
 
@@ -582,7 +582,7 @@ int __close_fd(struct files_struct *files, unsigned fd)
 	file = fdt->fd[fd];
 	if (!file)
 		goto out_unlock;
-	rcu_assign_pointer(fdt->fd[fd], NULL);
+	RCU_INIT_POINTER(fdt->fd[fd], NULL);
 	__clear_close_on_exec(fd, fdt);
 	__put_unused_fd(files, fd);
 	spin_unlock(&files->file_lock);
@@ -617,7 +617,7 @@ void do_close_on_exec(struct files_struct *files)
 			file = fdt->fd[fd];
 			if (!file)
 				continue;
-			rcu_assign_pointer(fdt->fd[fd], NULL);
+			RCU_INIT_POINTER(fdt->fd[fd], NULL);
 			__put_unused_fd(files, fd);
 			spin_unlock(&files->file_lock);
 			filp_close(file, files);
-- 
1.9.1

