Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3BAPiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 10:38:09 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36430 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3BAPiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 10:38:07 -0500
From: chenggang.qin@gmail.com
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qcg@alibaba-inc.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] Tracepoint: Add 'file name' as a parameter of tracepoint events ext4:ext4_direct_IO_enter&ext4:ext4_direct_IO_exit
Date: Fri,  1 Feb 2013 23:37:38 +0800
Message-Id: <510be15d.29bf440a.56c6.ffffb82e@mx.google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@alibaba-inc.com>

Yesterday, I implemented these tracepoint events in VFS subsystem. 
It is not a good idea.
Now, I modified two existing tracepoint events in ext4 subsystem to implement 
the same function.

Many database systems use their own page cache subsystems and use the direct IO
to access the disks. Sometimes, the system engineers want to know the misses
rate of the database system's page cache. They also require to know what files 
are accessed by the target processes with the direct IO method. These requirements 
can be satisfied by recording the database's file access behavior through the way
of direct IO. So, we add 'file name' as a parameter of tracepoint events: 
ext4:ext4_direct_IO_enter & ext4:ext4_direct_IO_exit.

Then, we will extend the perf or blktrace's function to use these tracepoint events.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Chenggang Qin <chenggang.qcg@alibaba-inc.com>

---
 fs/ext4/inode.c             |    7 +++++--
 include/trace/events/ext4.h |   22 ++++++++++++++--------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cbfe13b..92a379f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3202,6 +3202,7 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
+	const unsigned char *fname;
 
 	/*
 	 * If we are doing data journalling we don't support O_DIRECT
@@ -3213,13 +3214,15 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	if (ext4_has_inline_data(inode))
 		return 0;
 
-	trace_ext4_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
+	fname = file->f_path.dentry->d_name.name;
+	trace_ext4_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw,
+				   fname);
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		ret = ext4_ext_direct_IO(rw, iocb, iov, offset, nr_segs);
 	else
 		ret = ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
 	trace_ext4_direct_IO_exit(inode, offset,
-				iov_length(iov, nr_segs), rw, ret);
+				iov_length(iov, nr_segs), rw, ret, fname);
 	return ret;
 }
 
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 7e8c36b..532bbb4 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -1211,9 +1211,10 @@ DEFINE_EVENT(ext4__bitmap_load, ext4_load_inode_bitmap,
 );
 
 TRACE_EVENT(ext4_direct_IO_enter,
-	TP_PROTO(struct inode *inode, loff_t offset, unsigned long len, int rw),
+	TP_PROTO(struct inode *inode, loff_t offset, unsigned long len, int rw,
+		 const unsigned char *fname),
 
-	TP_ARGS(inode, offset, len, rw),
+	TP_ARGS(inode, offset, len, rw, fname),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
@@ -1221,6 +1222,7 @@ TRACE_EVENT(ext4_direct_IO_enter,
 		__field(	loff_t,	pos			)
 		__field(	unsigned long,	len		)
 		__field(	int,	rw			)
+		__string(	fname,	fname			)
 	),
 
 	TP_fast_assign(
@@ -1229,19 +1231,20 @@ TRACE_EVENT(ext4_direct_IO_enter,
 		__entry->pos	= offset;
 		__entry->len	= len;
 		__entry->rw	= rw;
+		__assign_str(fname, fname);
 	),
 
-	TP_printk("dev %d,%d ino %lu pos %lld len %lu rw %d",
+	TP_printk("dev %d,%d ino %lu pos %lld len %lu rw %d fname %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
-		  __entry->pos, __entry->len, __entry->rw)
+		  __entry->pos, __entry->len, __entry->rw, __get_str(fname))
 );
 
 TRACE_EVENT(ext4_direct_IO_exit,
 	TP_PROTO(struct inode *inode, loff_t offset, unsigned long len,
-		 int rw, int ret),
+		 int rw, int ret, const unsigned char *fname),
 
-	TP_ARGS(inode, offset, len, rw, ret),
+	TP_ARGS(inode, offset, len, rw, ret, fname),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
@@ -1250,6 +1253,7 @@ TRACE_EVENT(ext4_direct_IO_exit,
 		__field(	unsigned long,	len		)
 		__field(	int,	rw			)
 		__field(	int,	ret			)
+		__string(	fname,	fname			)
 	),
 
 	TP_fast_assign(
@@ -1259,13 +1263,15 @@ TRACE_EVENT(ext4_direct_IO_exit,
 		__entry->len	= len;
 		__entry->rw	= rw;
 		__entry->ret	= ret;
+		__assign_str(fname, fname);
 	),
 
-	TP_printk("dev %d,%d ino %lu pos %lld len %lu rw %d ret %d",
+	TP_printk("dev %d,%d ino %lu pos %lld len %lu rw %d ret %d fname %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  __entry->pos, __entry->len,
-		  __entry->rw, __entry->ret)
+		  __entry->rw, __entry->ret,
+		  __get_str(fname))
 );
 
 TRACE_EVENT(ext4_fallocate_enter,
-- 
1.7.9.5

