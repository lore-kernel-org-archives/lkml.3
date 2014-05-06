Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934530AbaEFIsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:48:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51845 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934397AbaEFIsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:48:05 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-6c-5368a1c40c36
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/6] f2fs: add a tracepoint for f2fs_write_end
Date: Tue, 06 May 2014 16:47:23 +0800
Message-id: <004401cf6907$e584ffe0$b08effa0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9pB7u3fSt0TeuTRbGIU+l1nNaDPw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd0jCzOCDY5f07S4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+Pdg//MBV28Feen
	CDcwnubqYuTkkBAwkZgxdSsbhC0mceHeeiCbi0NIYDqjxNL729ghnB+MEu8OXWQGqWITUJFY
	3vGfCcQWEdCUeLx8M1icWSBT4l7TDDBbWMBDYsKq5ywgNouAqsS//VsYQWxeAUuJU2dXMEHY
	ghI/Jt9jgejVkli/8zgThC0vsXnNW2aIixQkdpx9zQixS0/i7vQNjBA14hIbj9ximcAoMAvJ
	qFlIRs1CMmoWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYID+ZnUDsaVDRaHGAU4
	GJV4eE+sTA8WYk0sK67MPcQowcGsJMJbn58RLMSbklhZlVqUH19UmpNafIhRmoNFSZz3QKt1
	oJBAemJJanZqakFqEUyWiYNTqoFxfdA3sY48r5/eBxROH4gzn5wZHpWezKIxb1ZUv84P9a/5
	sXd/7GjVtjwXbHj5dUGeNU+dmbXZgscLX4ltjmUU5z26/9zSJyZW5+uUZ2ns23Q07/zUJ2LB
	szbd1lsorL3fOZNtp+ztwH/7HoTdV0rd+6ui+ampqpfblveq5+Rv3XtymOXTld+7lViKMxIN
	tZiLihMBpu+tsWACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for f2fs_write_end to trace write op of user.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c              |    2 ++
 include/trace/events/f2fs.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index cde0d69..ea58fb6 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -989,6 +989,8 @@ static int f2fs_write_end(struct file *file,
 {
 	struct inode *inode = page->mapping->host;
 
+	trace_f2fs_write_end(inode, pos, len, copied);
+
 	SetPageUptodate(page);
 	set_page_dirty(page);
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 1e9375a..483804b 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -689,6 +689,36 @@ TRACE_EVENT(f2fs_write_begin,
 		__entry->flags)
 );
 
+TRACE_EVENT(f2fs_write_end,
+
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+				unsigned int copied),
+
+	TP_ARGS(inode, pos, len, copied),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	pos)
+		__field(unsigned int, len)
+		__field(unsigned int, copied)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= pos;
+		__entry->len	= len;
+		__entry->copied	= copied;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, pos = %llu, len = %u, copied = %u",
+		show_dev_ino(__entry),
+		(unsigned long long)__entry->pos,
+		__entry->len,
+		__entry->copied)
+);
+
 DECLARE_EVENT_CLASS(f2fs__page,
 
 	TP_PROTO(struct page *page, int type),
-- 
1.7.9.5


