Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3HZGvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 02:51:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:45655 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892Ab3HZGvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 02:51:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,956,1367996400"; 
   d="scan'208";a="368411337"
Subject: [PATCH] Fix the race between the fget() and close()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Aug 2013 00:12:49 +0800
Message-ID: <1377533569.26153.3.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When one thread is calling sys_ioctl(), and another thread is calling
sys_close(), current code has protected most cases.

But for the below case, it will cause issue:
T1                                T2                             T3
sys_close(oldfile)                sys_open(newfile)              sys_ioctl(oldfile)
 -> __close_fd()
   lock file_lock
    assign NULL file
    put fd to be unused
   unlock file_lock
				   get new fd is same as old
				   assign newfile to same fd
								   fget_flight()
                                                                    get the newfile!!!
    decrease file->f_count
     file->f_count == 0
      --> try to release file

The race is when T1 try to close one oldFD, T3 is trying to ioctl the oldFD,
if currently the new T2 is trying to open a newfile, it maybe get the newFD is
same as oldFD.

And normal case T3 should get NULL file pointer due to released by T1, but T3
get the newfile pointer, and continue the ioctl accessing.

It maybe causes unexpectable error, we hit one system panic at do_vfs_ioctl().

Here we can fix it that putting "put_unused_fd()" after filp_close(),
it can avoid this case.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 fs/file.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 4a78f98..3f9b825 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -590,6 +590,7 @@ int __close_fd(struct files_struct *files, unsigned fd)
 {
 	struct file *file;
 	struct fdtable *fdt;
+	int ret;
 
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
@@ -600,9 +601,17 @@ int __close_fd(struct files_struct *files, unsigned fd)
 		goto out_unlock;
 	rcu_assign_pointer(fdt->fd[fd], NULL);
 	__clear_close_on_exec(fd, fdt);
+	spin_unlock(&files->file_lock);
+	ret = filp_close(file, files);
+
+	/* Delaying put_unused_fd after flip_close, otherwise
+	 * when race happening between fget() and close(),
+	 * the fget() may get one wrong file pointer.
+	 */
+	spin_lock(&files->file_lock);
 	__put_unused_fd(files, fd);
 	spin_unlock(&files->file_lock);
-	return filp_close(file, files);
+	return ret;
 
 out_unlock:
 	spin_unlock(&files->file_lock);
-- 
1.7.0.4



