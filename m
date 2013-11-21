Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3KUObo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:31:44 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56277 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3KUObm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:31:42 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 01/10] staging/lustre/libcfs: remove filp_size/filp_poff
Date: Thu, 21 Nov 2013 22:28:22 +0800
Message-Id: <1385044111-3129-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
References: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/linux-fs.h   |    5 -----
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |    6 +++---
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
index eebf138..8fabe4b 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
@@ -52,11 +52,6 @@
 #include <linux/backing-dev.h>
 #include <linux/posix_acl_xattr.h>
 
-#define filp_size(f)					\
-	(i_size_read((f)->f_dentry->d_inode))
-#define filp_poff(f)					\
-	(&(f)->f_pos)
-
 # define do_fsync(fp, flag)				\
 	((fp)->f_op->fsync(fp, 0, LLONG_MAX, flag))
 
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index f71a3cc..0ce4aac 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -709,7 +709,7 @@ int cfs_tracefile_dump_all_pages(char *filename)
 		__LASSERT_TAGE_INVARIANT(tage);
 
 		rc = filp_write(filp, page_address(tage->page),
-				tage->used, filp_poff(filp));
+				tage->used, &filp->f_pos);
 		if (rc != (int)tage->used) {
 			printk(KERN_WARNING "wanted to write %u but wrote "
 			       "%d\n", tage->used, rc);
@@ -1020,8 +1020,8 @@ static int tracefiled(void *arg)
 
 			if (f_pos >= (off_t)cfs_tracefile_size)
 				f_pos = 0;
-			else if (f_pos > (off_t)filp_size(filp))
-				f_pos = filp_size(filp);
+			else if (f_pos > i_size_read(filp->f_dentry->d_inode))
+				f_pos = i_size_read(filp->f_dentry->d_inode);
 
 			rc = filp_write(filp, page_address(tage->page),
 					tage->used, &f_pos);
-- 
1.7.9.5

