Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbbAHSLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:11:33 -0500
Received: from mail.kernel.org ([198.145.29.136]:58514 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbbAHSLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:11:31 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6/6] f2fs: add f2fs_destroy_trace_ios to free radix tree
Date: Thu,  8 Jan 2015 10:11:01 -0800
Message-Id: <1420740661-72288-6-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
References: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes radix tree after finishing tracing IOs.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/super.c |  1 +
 fs/f2fs/trace.c | 37 +++++++++++++++++++++++++++++++++++++
 fs/f2fs/trace.h |  2 ++
 3 files changed, 40 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index e6f035c..0e97974 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1272,6 +1272,7 @@ static void __exit exit_f2fs_fs(void)
 	destroy_node_manager_caches();
 	destroy_inodecache();
 	kset_unregister(f2fs_kset);
+	f2fs_destroy_trace_ios();
 }
 
 module_init(init_f2fs_fs)
diff --git a/fs/f2fs/trace.c b/fs/f2fs/trace.c
index 92fa38a..b3570dc 100644
--- a/fs/f2fs/trace.c
+++ b/fs/f2fs/trace.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/f2fs_fs.h>
 #include <linux/sched.h>
+#include <linux/radix-tree.h>
 
 #include "f2fs.h"
 #include "trace.h"
@@ -120,3 +121,39 @@ void f2fs_build_trace_ios(void)
 {
 	spin_lock_init(&pids_lock);
 }
+
+#define PIDVEC_SIZE	128
+static unsigned int gang_lookup_pids(pid_t *results, unsigned long first_index,
+							unsigned int max_items)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+	unsigned int ret = 0;
+
+	if (unlikely(!max_items))
+		return 0;
+
+	radix_tree_for_each_slot(slot, &pids, &iter, first_index) {
+		results[ret] = iter.index;
+		if (++ret == PIDVEC_SIZE)
+			break;
+	}
+	return ret;
+}
+
+void f2fs_destroy_trace_ios(void)
+{
+	pid_t pid[PIDVEC_SIZE];
+	pid_t next_pid = 0;
+	unsigned int found;
+
+	spin_lock(&pids_lock);
+	while ((found = gang_lookup_pids(pid, next_pid, PIDVEC_SIZE))) {
+		unsigned idx;
+
+		next_pid = pid[found - 1] + 1;
+		for (idx = 0; idx < found; idx++)
+			radix_tree_delete(&pids, pid[idx]);
+	}
+	spin_unlock(&pids_lock);
+}
diff --git a/fs/f2fs/trace.h b/fs/f2fs/trace.h
index eb39fa0..1041dbe 100644
--- a/fs/f2fs/trace.h
+++ b/fs/f2fs/trace.h
@@ -35,10 +35,12 @@ struct last_io_info {
 extern void f2fs_trace_pid(struct page *);
 extern void f2fs_trace_ios(struct page *, struct f2fs_io_info *, int);
 extern void f2fs_build_trace_ios(void);
+extern void f2fs_destroy_trace_ios(void);
 #else
 #define f2fs_trace_pid(p)
 #define f2fs_trace_ios(p, i, n)
 #define f2fs_build_trace_ios()
+#define f2fs_destroy_trace_ios()
 
 #endif
 #endif /* __F2FS_TRACE_H__ */
-- 
2.1.1

