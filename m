Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3DFFqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 01:46:32 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46435 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3DFFq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 01:46:28 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH v3 4/7] f2fs: add tracepoints for GC threads
Date: Sat,  6 Apr 2013 14:46:21 +0900
Message-Id: <1365227181-15492-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints for tracing the garbage collector
threads in f2fs with status of collection & type.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/gc.c                |    2 ++
 include/trace/events/f2fs.h |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 54ac13d..93bb0f9 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -23,6 +23,7 @@
 #include "node.h"
 #include "segment.h"
 #include "gc.h"
+#include <trace/events/f2fs.h>
 
 static struct kmem_cache *winode_slab;
 
@@ -239,6 +240,7 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 	struct victim_sel_policy p;
 	int nsearched = 0;
 
+	trace_f2fs_get_victim(sbi->sb, gc_type);
 	p.alloc_mode = alloc_mode;
 	select_policy(sbi, gc_type, type, &p);
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 3df0525..f9efe99 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -327,6 +327,26 @@ DEFINE_EVENT(f2fs_data_block, f2fs_get_data_block_exit,
 	TP_ARGS(inode, block, ret)
 );
 
+TRACE_EVENT(f2fs_get_victim,
+	TP_PROTO(struct super_block *sb, int gc_type),
+
+	TP_ARGS(sb, gc_type),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int,	type)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->type	= gc_type;
+	),
+
+	TP_printk("dev %d,%d  GC_type %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->type)
+);
+
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

