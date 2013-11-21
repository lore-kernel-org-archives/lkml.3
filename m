Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab3KUOby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:31:54 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60718 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3KUObv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:31:51 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 04/10] staging/lustre/libcfs: remove filp_write
Date: Thu, 21 Nov 2013 22:28:25 +0800
Message-Id: <1385044111-3129-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
References: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vfs_write instead and call kmap/kunmap to ensure
that we can access high memory zone.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/linux-fs.h   |    3 ---
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |   16 ++++++++++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
index 573ab08..102afa2 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
@@ -52,9 +52,6 @@
 #include <linux/backing-dev.h>
 #include <linux/posix_acl_xattr.h>
 
-#define filp_write(fp, buf, size, pos)			\
-	((fp)->f_op->write((fp), (buf), (size), pos))
-
 #define flock_type(fl)			((fl)->fl_type)
 #define flock_set_type(fl, type)	do { (fl)->fl_type = (type); } while (0)
 #define flock_pid(fl)			((fl)->fl_pid)
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index 4c3dad6..54290ce 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -678,6 +678,7 @@ int cfs_tracefile_dump_all_pages(char *filename)
 	struct file		*filp;
 	struct cfs_trace_page	*tage;
 	struct cfs_trace_page	*tmp;
+	char			*buf;
 	int rc;
 
 	DECL_MMSPACE;
@@ -708,8 +709,11 @@ int cfs_tracefile_dump_all_pages(char *filename)
 
 		__LASSERT_TAGE_INVARIANT(tage);
 
-		rc = filp_write(filp, page_address(tage->page),
-				tage->used, &filp->f_pos);
+		buf = kmap(tage->page);
+		rc = vfs_write(filp, (__force const char __user *)buf,
+			       tage->used, &filp->f_pos);
+		kunmap(tage->page);
+
 		if (rc != (int)tage->used) {
 			printk(KERN_WARNING "wanted to write %u but wrote "
 			       "%d\n", tage->used, rc);
@@ -971,6 +975,7 @@ static int tracefiled(void *arg)
 	struct cfs_trace_page *tage;
 	struct cfs_trace_page *tmp;
 	struct file *filp;
+	char *buf;
 	int last_loop = 0;
 	int rc;
 
@@ -1023,8 +1028,11 @@ static int tracefiled(void *arg)
 			else if (f_pos > i_size_read(filp->f_dentry->d_inode))
 				f_pos = i_size_read(filp->f_dentry->d_inode);
 
-			rc = filp_write(filp, page_address(tage->page),
-					tage->used, &f_pos);
+			buf = kmap(tage->page);
+			rc = vfs_write(filp, (__force const char __user *)buf,
+				       tage->used, &f_pos);
+			kunmap(tage->page);
+
 			if (rc != (int)tage->used) {
 				printk(KERN_WARNING "wanted to write %u "
 				       "but wrote %d\n", tage->used, rc);
-- 
1.7.9.5

