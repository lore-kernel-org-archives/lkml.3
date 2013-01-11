Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3AKVHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:07:51 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:46329 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab3AKVG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:06:56 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, chavey@google.com, fengguang.wu@intel.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] block: add block_{touch|dirty}_buffer tracepoint
Date: Fri, 11 Jan 2013 13:06:36 -0800
Message-Id: <1357938397-5413-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357938397-5413-1-git-send-email-tj@kernel.org>
References: <1357938397-5413-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The former is triggered from touch_buffer() and the latter
mark_buffer_dirty().

This is part of tracepoint additions to improve visiblity into
dirtying / writeback operations for io tracer and userland.

v2: Transformed writeback_dirty_buffer to block_dirty_buffer and made
    it share TP definition with block_touch_buffer.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 fs/buffer.c                  |  4 ++++
 include/trace/events/block.h | 51 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index a8c2dfb..87ff335 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
+#include <trace/events/block.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 
@@ -55,6 +56,7 @@ EXPORT_SYMBOL(init_buffer);
 
 inline void touch_buffer(struct buffer_head *bh)
 {
+	trace_block_touch_buffer(bh);
 	mark_page_accessed(bh->b_page);
 }
 EXPORT_SYMBOL(touch_buffer);
@@ -1119,6 +1121,8 @@ void mark_buffer_dirty(struct buffer_head *bh)
 {
 	WARN_ON_ONCE(!buffer_uptodate(bh));
 
+	trace_block_dirty_buffer(bh);
+
 	/*
 	 * Very *carefully* optimize the it-is-already-dirty case.
 	 *
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index b408f51..9961726 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -6,10 +6,61 @@
 
 #include <linux/blktrace_api.h>
 #include <linux/blkdev.h>
+#include <linux/buffer_head.h>
 #include <linux/tracepoint.h>
 
 #define RWBS_LEN	8
 
+DECLARE_EVENT_CLASS(block_buffer,
+
+	TP_PROTO(struct buffer_head *bh),
+
+	TP_ARGS(bh),
+
+	TP_STRUCT__entry (
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  size_t,	size			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bh->b_bdev->bd_dev;
+		__entry->sector		= bh->b_blocknr;
+		__entry->size		= bh->b_size;
+	),
+
+	TP_printk("%d,%d sector=%llu size=%zu",
+		MAJOR(__entry->dev), MINOR(__entry->dev),
+		(unsigned long long)__entry->sector, __entry->size
+	)
+);
+
+/**
+ * block_touch_buffer - mark a buffer accessed
+ * @bh: buffer_head being touched
+ *
+ * Called from touch_buffer().
+ */
+DEFINE_EVENT(block_buffer, block_touch_buffer,
+
+	TP_PROTO(struct buffer_head *bh),
+
+	TP_ARGS(bh)
+);
+
+/**
+ * block_dirty_buffer - mark a buffer dirty
+ * @bh: buffer_head being dirtied
+ *
+ * Called from mark_buffer_dirty().
+ */
+DEFINE_EVENT(block_buffer, block_dirty_buffer,
+
+	TP_PROTO(struct buffer_head *bh),
+
+	TP_ARGS(bh)
+);
+
 DECLARE_EVENT_CLASS(block_rq_with_error,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
-- 
1.8.0.2

