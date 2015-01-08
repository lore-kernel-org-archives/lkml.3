Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbbAHSLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:11:31 -0500
Received: from mail.kernel.org ([198.145.29.136]:58486 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbbAHSL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:11:28 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5/6] f2fs: add spin_lock to cover radix operations in IO tracer
Date: Thu,  8 Jan 2015 10:11:00 -0800
Message-Id: <1420740661-72288-5-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
References: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds spin_lock to cover radix tree operations in IO tracer.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/super.c |  2 ++
 fs/f2fs/trace.c | 18 +++++++++++++++---
 fs/f2fs/trace.h |  2 ++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 0ae6a2f..e6f035c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1222,6 +1222,8 @@ static int __init init_f2fs_fs(void)
 {
 	int err;
 
+	f2fs_build_trace_ios();
+
 	err = init_inodecache();
 	if (err)
 		goto fail;
diff --git a/fs/f2fs/trace.c b/fs/f2fs/trace.c
index 19f5216..92fa38a 100644
--- a/fs/f2fs/trace.c
+++ b/fs/f2fs/trace.c
@@ -15,7 +15,8 @@
 #include "f2fs.h"
 #include "trace.h"
 
-RADIX_TREE(pids, GFP_NOIO);
+RADIX_TREE(pids, GFP_ATOMIC);
+spinlock_t pids_lock;
 struct last_io_info last_io;
 
 static inline void __print_last_io(void)
@@ -58,9 +59,13 @@ void f2fs_trace_pid(struct page *page)
 
 	page->private = pid;
 
+	if (radix_tree_preload(GFP_NOFS))
+		return;
+
+	spin_lock(&pids_lock);
 	p = radix_tree_lookup(&pids, pid);
 	if (p == current)
-		return;
+		goto out;
 	if (p)
 		radix_tree_delete(&pids, pid);
 
@@ -69,7 +74,9 @@ void f2fs_trace_pid(struct page *page)
 	trace_printk("%3x:%3x %4x %-16s\n",
 			MAJOR(inode->i_sb->s_dev), MINOR(inode->i_sb->s_dev),
 			pid, current->comm);
-
+out:
+	spin_unlock(&pids_lock);
+	radix_tree_preload_end();
 }
 
 void f2fs_trace_ios(struct page *page, struct f2fs_io_info *fio, int flush)
@@ -108,3 +115,8 @@ void f2fs_trace_ios(struct page *page, struct f2fs_io_info *fio, int flush)
 	last_io.len = 1;
 	return;
 }
+
+void f2fs_build_trace_ios(void)
+{
+	spin_lock_init(&pids_lock);
+}
diff --git a/fs/f2fs/trace.h b/fs/f2fs/trace.h
index aa6663b..eb39fa0 100644
--- a/fs/f2fs/trace.h
+++ b/fs/f2fs/trace.h
@@ -34,9 +34,11 @@ struct last_io_info {
 
 extern void f2fs_trace_pid(struct page *);
 extern void f2fs_trace_ios(struct page *, struct f2fs_io_info *, int);
+extern void f2fs_build_trace_ios(void);
 #else
 #define f2fs_trace_pid(p)
 #define f2fs_trace_ios(p, i, n)
+#define f2fs_build_trace_ios()
 
 #endif
 #endif /* __F2FS_TRACE_H__ */
-- 
2.1.1

