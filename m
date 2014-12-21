Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaLUQgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 11:36:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:52596 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbaLUQfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 11:35:34 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5/6] f2fs: activate f2fs_trace_ios
Date: Sun, 21 Dec 2014 08:35:22 -0800
Message-Id: <1419179723-3234-5-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
References: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch activates f2fs_trace_ios.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c  | 3 +++
 fs/f2fs/file.c  | 2 ++
 fs/f2fs/super.c | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d86f8b1..20aa3c3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -22,6 +22,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include "trace.h"
 #include <trace/events/f2fs.h>
 
 static void f2fs_read_end_io(struct bio *bio, int err)
@@ -137,6 +138,7 @@ int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
 	struct bio *bio;
 
 	trace_f2fs_submit_page_bio(page, fio->blk_addr, fio->rw);
+	f2fs_trace_ios(page, fio, 0);
 
 	/* Allocate a new bio */
 	bio = __bio_alloc(sbi, fio->blk_addr, 1, is_read_io(fio->rw));
@@ -185,6 +187,7 @@ alloc_new:
 	}
 
 	io->last_block_in_bio = fio->blk_addr;
+	f2fs_trace_ios(page, fio, 0);
 
 	up_write(&io->io_rwsem);
 	trace_f2fs_submit_page_mbio(page, fio->rw, fio->type, fio->blk_addr);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5139f90..f172ddc4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -26,6 +26,7 @@
 #include "segment.h"
 #include "xattr.h"
 #include "acl.h"
+#include "trace.h"
 #include <trace/events/f2fs.h>
 
 static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
@@ -265,6 +266,7 @@ flush_out:
 	ret = f2fs_issue_flush(sbi);
 out:
 	trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
+	f2fs_trace_ios(NULL, NULL, 1);
 	return ret;
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index f71421d..cf68e44 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -30,6 +30,7 @@
 #include "segment.h"
 #include "xattr.h"
 #include "gc.h"
+#include "trace.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/f2fs.h>
@@ -493,6 +494,7 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 	} else {
 		f2fs_balance_fs(sbi);
 	}
+	f2fs_trace_ios(NULL, NULL, 1);
 
 	return 0;
 }
-- 
2.1.1

