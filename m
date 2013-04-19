Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968448Ab3DSQ33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:29:29 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39903 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967799Ab3DSQ30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:29:26 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH v4 4/7] f2fs: add tracepoints for GC threads
Date: Sat, 20 Apr 2013 01:29:18 +0900
Message-Id: <1366388958-18915-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints for tracing the garbage collector
threads in f2fs with status of collection & type.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/f2fs/gc.c                |    2 ++
 include/trace/events/f2fs.h |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 37b05e1..935ca8c 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -23,6 +23,7 @@
 #include "node.h"
 #include "segment.h"
 #include "gc.h"
+#include <trace/events/f2fs.h>
 
 static struct kmem_cache *winode_slab;
 
@@ -304,6 +305,7 @@ got_it:
 	}
 	mutex_unlock(&dirty_i->seglist_lock);
 
+	trace_f2fs_get_victim(sbi->sb, gc_type, type, &p, sbi->cur_victim_sec);
 	return (p.min_segno == NULL_SEGNO) ? 0 : 1;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index c7e71f9..57b6487 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -6,6 +6,7 @@
 
 #include <linux/tracepoint.h>
 
+struct victim_sel_policy;
 
 TRACE_EVENT(f2fs_sync_file_enter,
 	TP_PROTO(struct file *file, char advise, int datasync),
@@ -471,6 +472,43 @@ TRACE_EVENT(f2fs_get_data_block,
 			 (unsigned long long) __entry->bh_block,
 					__entry->size,  __entry->ret)
 );
+
+TRACE_EVENT(f2fs_get_victim,
+	TP_PROTO(struct super_block *sb, int gc_type, int type,
+			 struct victim_sel_policy *p, unsigned int victim),
+
+	TP_ARGS(sb, gc_type, type, p, victim),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int,	gc_type)
+		__field(int,	type)
+		__field(int,	alloc_mode)
+		__field(int,	gc_mode)
+		__field(unsigned int,	ofs_unit)
+		__field(unsigned int,	min_segno)
+		__field(unsigned int,	victim)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= sb->s_dev;
+		__entry->gc_type	= gc_type;
+		__entry->type		= type;
+		__entry->alloc_mode	= p->alloc_mode;
+		__entry->gc_mode	= p->gc_mode;
+		__entry->ofs_unit	= p->ofs_unit;
+		__entry->min_segno	= p->min_segno;
+		__entry->victim		= victim;
+	),
+
+	TP_printk("dev %d,%d  GC_type %d Data type %d Alloc_mode %d Gc_mode %d "
+			"Bitmap %u Segment No %u Victim %u" ,
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->gc_type, __entry->type, __entry->alloc_mode,
+		 __entry->gc_mode, __entry->ofs_unit, __entry->min_segno,
+			__entry->victim)
+);
+
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

