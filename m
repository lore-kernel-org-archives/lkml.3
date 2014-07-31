Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaGaNMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:12:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44603 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaGaNMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:12:18 -0400
X-AuditID: cbfee61b-f79f86d00000144c-17-53da40b0674d
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/2] f2fs: add tracepoint for f2fs_direct_IO
Date: Thu, 31 Jul 2014 21:11:22 +0800
Message-id: <017201cfacc1$0b3a7600$21af6200$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: Ac+swACRhHMMl5icTpKB6FKlDw/zUg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQd0NDreCDSad17K4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Vh9uYy94JFKxfvUz9gbGewJdjJwcEgImEkc2zGKHsMUkLtxbz9bFyMUhJDCdUWLSkeUsEM4P
	Romtb5azgVSxCahILO/4zwRiiwh4SUzaf4IFxGYWyJS41zSDGcQWFnCT2NX0gBXEZhFQlfj8
	5xTQBg4OXgFLiS2ny0HCvAKCEj8m34Nq1ZJYv/M4E4QtL7F5zVtmiIMUJHacfc0IEReX2Hjk
	FgvIGBEBPYmN12QnMArMQjJpFpJJs5BMmoWkewEjyypG0dSC5ILipPRcI73ixNzi0rx0veT8
	3E2M4NB+Jr2DcVWDxSFGAQ5GJR7eHyY3g4VYE8uKK3MPMUpwMCuJ8EZZ3goW4k1JrKxKLcqP
	LyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwLhVRWqnuMW9Ps83l75Jmdyb
	FjBbXu9ke8hONbVfHXxTDnk8Wige8bVSazv7qsBmliKGZdGH6gXDTh9qFY94U9B0mvl/+l+5
	RUvzfQrlzx8OW7XGaktLfuVR1z1K8m937r5Yu1Fnu1o1s02/3iFZHcHSq92XBXy+fLwYwjCr
	I7ffSj6JIadXXomlOCPRUIu5qDgRAA+8QlZpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a tracepoint for f2fs_direct_IO.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c              |  5 ++++
 include/trace/events/f2fs.h | 63 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ec3c886..03313099 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1086,9 +1086,14 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 	/* clear fsync mark to recover these blocks */
 	fsync_mark_clear(F2FS_SB(inode->i_sb), inode->i_ino);
 
+	trace_f2fs_direct_IO_enter(inode, offset, count, rw);
+
 	err = blockdev_direct_IO(rw, iocb, inode, iter, offset, get_data_block);
 	if (err < 0 && (rw & WRITE))
 		f2fs_write_failed(mapping, offset + count);
+
+	trace_f2fs_direct_IO_exit(inode, offset, count, rw, err);
+
 	return err;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 7d2e70e..d06d443 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -587,6 +587,69 @@ TRACE_EVENT(f2fs_fallocate,
 		__entry->ret)
 );
 
+TRACE_EVENT(f2fs_direct_IO_enter,
+
+	TP_PROTO(struct inode *inode, loff_t offset, unsigned long len, int rw),
+
+	TP_ARGS(inode, offset, len, rw),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	pos)
+		__field(unsigned long,	len)
+		__field(int,	rw)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= offset;
+		__entry->len	= len;
+		__entry->rw	= rw;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu pos = %lld len = %lu rw = %d",
+		show_dev_ino(__entry),
+		__entry->pos,
+		__entry->len,
+		__entry->rw)
+);
+
+TRACE_EVENT(f2fs_direct_IO_exit,
+
+	TP_PROTO(struct inode *inode, loff_t offset, unsigned long len,
+		 int rw, int ret),
+
+	TP_ARGS(inode, offset, len, rw, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	pos)
+		__field(unsigned long,	len)
+		__field(int,	rw)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= offset;
+		__entry->len	= len;
+		__entry->rw	= rw;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu pos = %lld len = %lu "
+		"rw = %d ret = %d",
+		show_dev_ino(__entry),
+		__entry->pos,
+		__entry->len,
+		__entry->rw,
+		__entry->ret)
+);
+
 TRACE_EVENT(f2fs_reserve_new_block,
 
 	TP_PROTO(struct inode *inode, nid_t nid, unsigned int ofs_in_node),
-- 
2.0.1.474.g72c7794


