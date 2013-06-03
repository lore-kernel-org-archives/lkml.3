Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab3FCKFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:05:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:24925 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757169Ab3FCKFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:05:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,791,1363158000"; 
   d="scan'208";a="249941859"
From: Huajun Li <huajun.li@intel.com>
To: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        huajun.li.lee@gmail.com
Cc: namjae.jeon@samsung.com, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Huajun Li <huajun.li@intel.com>
Subject: [RFC 5/5] f2fs: add tracepoints to debug inline data operations
Date: Mon,  3 Jun 2013 18:04:14 +0800
Message-Id: <1370253854-15084-6-git-send-email-huajun.li@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
References: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haicheng Li <haicheng.li@linux.intel.com>

Add tracepoints for: f2fs_read_inline_data(), f2fs_convert_inline_data(),
f2fs_write_inline_data().

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Huajun Li <huajun.li@intel.com>
---
 fs/f2fs/inline.c            |    4 +++
 include/trace/events/f2fs.h |   69 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index a2aa056..9ec66e5 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -14,6 +14,7 @@
 #include <linux/f2fs_fs.h>
 
 #include "f2fs.h"
+#include <trace/events/f2fs.h>
 
 void f2fs_clear_inode_inline_flag(struct f2fs_inode *raw_inode)
 {
@@ -44,6 +45,7 @@ static int f2fs_read_inline_data(struct inode *inode, struct page *page)
 	if (IS_ERR(ipage))
 		return PTR_ERR(ipage);
 
+	trace_f2fs_read_inline_data(inode, page);
 	src_addr = page_address(ipage);
 	dst_addr = page_address(page);
 
@@ -107,6 +109,7 @@ int f2fs_convert_inline_data(struct page *p,
 	set_page_dirty(ipage);
 	f2fs_put_page(ipage, 1);
 
+	trace_f2fs_convert_inline_data(inode, page);
 	if (!p->index) {
 		SetPageUptodate(page);
 	} else {
@@ -138,6 +141,7 @@ int f2fs_write_inline_data(struct inode *inode,
 	if (IS_ERR(ipage))
 		return PTR_ERR(ipage);
 
+	trace_f2fs_write_inline_data(inode, page);
 	src_addr = page_address(page);
 	dst_addr = page_address(ipage);
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 52ae548..bc7a84e 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -676,6 +676,75 @@ TRACE_EVENT(f2fs_write_checkpoint,
 		__entry->msg)
 );
 
+TRACE_EVENT(f2fs_read_inline_data,
+
+	TP_PROTO(struct inode *inode, struct page *page),
+
+	TP_ARGS(inode, page),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(pgoff_t, index)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->index	= page->index;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, index = %lu",
+		show_dev_ino(__entry),
+		(unsigned long)__entry->index)
+);
+
+TRACE_EVENT(f2fs_convert_inline_data,
+
+	TP_PROTO(struct inode *inode, struct page *page),
+
+	TP_ARGS(inode, page),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(pgoff_t, index)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->index	= page->index;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, index = %lu",
+		show_dev_ino(__entry),
+		(unsigned long)__entry->index)
+);
+
+TRACE_EVENT(f2fs_write_inline_data,
+
+	TP_PROTO(struct inode *inode, struct page *page),
+
+	TP_ARGS(inode, page),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(pgoff_t, index)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->index	= page->index;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, index = %lu",
+		show_dev_ino(__entry),
+		(unsigned long)__entry->index)
+);
+
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

