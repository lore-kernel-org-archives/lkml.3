Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbaEFIrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:47:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51685 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbaEFIrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:47:05 -0400
X-AuditID: cbfee61b-b7f766d00000646c-1e-5368a186e684
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/6] f2fs: add a tracepoint for f2fs_write_begin
Date: Tue, 06 May 2014 16:46:04 +0800
Message-id: <004301cf6907$bdd25740$397705c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9pB5BVTXvG4WizSyKRLaLYBajkFA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQd22hRnBBk3fRCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytj55QxbwXPeiqbz
	+1gbGOdxdzFyckgImEh83nCRBcIWk7hwbz1bFyMXh5DAdEaJKdO/s0I4Pxglzs7uYQKpYhNQ
	kVje8R/MFhHQlHi8fDMziM0skClxr2kGmC0s4CWx/s97NhCbRUBV4nbff0YQm1fAUmLXwdns
	ELagxI/J91ggerUk1u88zgRhy0tsXvOWGeIiBYkdZ18zQuzSk9jcsRmqRlxi45FbLBMYBWYh
	GTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwKD+T3sG4qsHiEKMA
	B6MSD++JlenBQqyJZcWVuYcYJTiYlUR46/MzgoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1
	DhQSSE8sSc1OTS1ILYLJMnFwSjUwWvq1H/3NObe36UB7+QrmrXllq6dn1YS0v3n+zD3ghff0
	qPD6tRemHLsv7f9EKp49QqlrxeNlL3Zfiww88LQtMsBfeemfPR5a2r9Xd9rGvfWvOnRoRhqX
	jXnq5MV2/HsYdc8dPpFiK7JF+XPJjxfc1usyL2/zWj1b39/s1YIdWwMyO7W0J/UnK7EUZyQa
	ajEXFScCAH0nHdxhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for f2fs_write_begin to trace write op of user.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c              |    2 ++
 include/trace/events/f2fs.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a7bb98f..cde0d69 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -900,6 +900,8 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 	struct dnode_of_data dn;
 	int err = 0;
 
+	trace_f2fs_write_begin(inode, pos, len, flags);
+
 	f2fs_balance_fs(sbi);
 repeat:
 	err = f2fs_convert_inline_data(inode, pos + len);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 67f38fa..1e9375a 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -659,6 +659,36 @@ DEFINE_EVENT_CONDITION(f2fs__submit_bio, f2fs_submit_read_bio,
 	TP_CONDITION(bio)
 );
 
+TRACE_EVENT(f2fs_write_begin,
+
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+				unsigned int flags),
+
+	TP_ARGS(inode, pos, len, flags),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	pos)
+		__field(unsigned int, len)
+		__field(unsigned int, flags)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= pos;
+		__entry->len	= len;
+		__entry->flags	= flags;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, pos = %llu, len = %u, flags = %u",
+		show_dev_ino(__entry),
+		(unsigned long long)__entry->pos,
+		__entry->len,
+		__entry->flags)
+);
+
 DECLARE_EVENT_CLASS(f2fs__page,
 
 	TP_PROTO(struct page *page, int type),
-- 
1.7.9.5


