Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3A2HZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:25:37 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38147 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3A2HZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:25:34 -0500
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qin@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@alibaba-inc.com>
Subject: [PATCH] Tracepoint Event: Add 4 tracepoint events for vfs subsystem.
Date: Tue, 29 Jan 2013 15:25:08 +0800
Message-Id: <1359444308-3780-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang.qin@gmail.com

If the engineers want to analyze the file access behavior of some applications
without source code, perf tools with some appropriate tracepoints events in the
VFS subsystem are excellent choice.

The system engineers or developers of server software require to know what files
are accessed by the target processes with in a period of time. Then they can
find the hot applications and the hot files. For this requirements, we added 2
tracepoint events at the begin of generic_file_aio_read() and generic_file_aio_write().

Many database systems use their own page cache subsystems and use the direct IO
to access the disks. Sometimes, the system engineers want to know the misses
rate of the database system's page cache. This requirements can be satisfied by
recording the database's file access behavior through the way of direct IO. So,
we added 2 tracepoint events at the direct IO branch in generic_file_aio_read()
and generic_file_aio_write().

Then, we will extend the perf's function by python script to use these new tracepoint
events.

The 4 new tracepoint events are:
1) generic_file_aio_read
   Format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;
	field:int common_padding;	offset:8;	size:4;	signed:1;

	field:long long pos;	offset:16;	size:8;	signed:1;
	field:unsigned long bytes;	offset:24;	size:8;	signed:0;
	field:unsigned char fname[100];	offset:32;	size:100;	signed:0;

2) generic_file_aio_write
   Format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;
	field:int common_padding;	offset:8;	size:4;	signed:1;

	field:long long pos;	offset:16;	size:8;	signed:1;
	field:unsigned long bytes;	offset:24;	size:8;	signed:0;
	field:unsigned char fname[100];	offset:32;	size:100;	signed:0;

3) direct_io_read
   Format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;
	field:int common_padding;	offset:8;	size:4;	signed:1;

	field:long long pos;	offset:16;	size:8;	signed:1;
	field:unsigned long bytes;	offset:24;	size:8;	signed:0;
	field:unsigned char fname[100];	offset:32;	size:100;	signed:0;

4) direct_io_write
   Format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;
	field:int common_padding;	offset:8;	size:4;	signed:1;

	field:long long pos;	offset:16;	size:8;	signed:1;
	field:unsigned long bytes;	offset:24;	size:8;	signed:0;
	field:unsigned char fname[100];	offset:32;	size:100;	signed:0;

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@alibaba-inc.com>

---
 include/trace/events/vfs.h |  110 ++++++++++++++++++++++++++++++++++++++++++++
 mm/filemap.c               |   18 ++++++++
 2 files changed, 128 insertions(+)
 create mode 100644 include/trace/events/vfs.h

diff --git a/include/trace/events/vfs.h b/include/trace/events/vfs.h
new file mode 100644
index 0000000..33498e1
--- /dev/null
+++ b/include/trace/events/vfs.h
@@ -0,0 +1,110 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vfs
+#define TRACE_INCLUDE_FILE vfs
+
+#if !defined(_TRACE_EVENTS_VFS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_EVENTS_VFS_H
+
+#include <linux/tracepoint.h>
+
+#include <asm/ptrace.h>
+
+TRACE_EVENT(generic_file_aio_read,
+
+	TP_PROTO(long long pos, unsigned long bytes, unsigned char *fname),
+
+	TP_ARGS(pos, bytes, fname),
+
+	TP_STRUCT__entry(
+		__field(	long long,	pos		)
+		__field(	unsigned long,	bytes		)
+		__array(	unsigned char,	fname,	100	)
+	),
+
+	TP_fast_assign(
+		__entry->pos	= pos;
+		__entry->bytes	= bytes;
+		strncpy(__entry->fname, fname, 100);
+	),
+
+	TP_printk("aio read(Filename: %s Pos: %lld Bytes: %lu)",
+		  __entry->fname, __entry->pos, __entry->bytes)
+);
+
+TRACE_EVENT_FLAGS(generic_file_aio_read, TRACE_EVENT_FL_CAP_ANY)
+
+TRACE_EVENT(generic_file_aio_write,
+
+	TP_PROTO(long long pos, unsigned long bytes, unsigned char *fname),
+
+	TP_ARGS(pos, bytes, fname),
+
+	TP_STRUCT__entry(
+		__field(	long long,	pos		)
+		__field(	unsigned long,	bytes		)
+		__array(	unsigned char,	fname,	100	)
+	),
+
+	TP_fast_assign(
+		__entry->pos	= pos;
+		__entry->bytes	= bytes;
+		strncpy(__entry->fname, fname, 100);
+	),
+
+	TP_printk("aio write(Filename: %s Pos: %lld Bytes: %lu)",
+		  __entry->fname, __entry->pos, __entry->bytes)
+);
+
+TRACE_EVENT_FLAGS(generic_file_aio_write, TRACE_EVENT_FL_CAP_ANY)
+
+TRACE_EVENT(direct_io_read,
+	TP_PROTO(long long pos, unsigned long bytes, unsigned char *fname),
+
+	TP_ARGS(pos, bytes, fname),
+
+	TP_STRUCT__entry(
+		__field(	long long,	pos		)
+		__field(	unsigned long,  bytes		)
+		__array(	unsigned char,	fname,  100	)
+	),
+
+	TP_fast_assign(
+		__entry->pos	= pos;
+		__entry->bytes  = bytes;
+		strncpy(__entry->fname, fname, 100);
+	),
+
+	TP_printk("direct io read(Filename: %s Pos: %lld Bytes: %lu)",
+		  __entry->fname, __entry->pos, __entry->bytes)
+);
+
+TRACE_EVENT_FLAGS(direct_io_read, TRACE_EVENT_FL_CAP_ANY)
+
+TRACE_EVENT(direct_io_write,
+	TP_PROTO(long long pos, unsigned long bytes, unsigned char *fname),
+
+	TP_ARGS(pos, bytes, fname),
+
+	TP_STRUCT__entry(
+		__field(	long long,	pos		)
+		__field(	unsigned long,  bytes		)
+		__array(	unsigned char,	fname,	100	)
+	),
+
+	TP_fast_assign(
+		__entry->pos	= pos;
+		__entry->bytes	= bytes;
+		strncpy(__entry->fname, fname, 100);
+	),
+
+	TP_printk("direct io write(Filename: %s Pos: %lld Bytes: %lu)",
+		  __entry->fname, __entry->pos, __entry->bytes)
+);
+
+TRACE_EVENT_FLAGS(direct_io_write, TRACE_EVENT_FL_CAP_ANY)
+
+#endif /* _TRACE_EVENTS_SYSCALLS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/mm/filemap.c b/mm/filemap.c
index 83efee7..0310e7b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -42,6 +42,9 @@
 
 #include <asm/mman.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/vfs.h>
+
 /*
  * Shared mappings implemented 30.11.1994. It's not fully working yet,
  * though.
@@ -1390,6 +1393,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	ssize_t retval;
 	unsigned long seg = 0;
 	size_t count;
+	unsigned char *f_name;
 	loff_t *ppos = &iocb->ki_pos;
 
 	count = 0;
@@ -1397,6 +1401,9 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	if (retval)
 		return retval;
 
+	f_name = (unsigned char *)filp->f_path.dentry->d_name.name;
+	trace_generic_file_aio_read(pos, iov_length(iov, nr_segs), f_name);
+
 	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
 	if (filp->f_flags & O_DIRECT) {
 		loff_t size;
@@ -1407,6 +1414,9 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 		inode = mapping->host;
 		if (!count)
 			goto out; /* skip atime */
+
+		trace_direct_io_read(pos, iov_length(iov, nr_segs), f_name);
+
 		size = i_size_read(inode);
 		if (pos < size) {
 			retval = filemap_write_and_wait_range(mapping, pos,
@@ -2453,6 +2463,10 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (unlikely(file->f_flags & O_DIRECT)) {
 		loff_t endbyte;
 		ssize_t written_buffered;
+		unsigned char *f_name;
+
+		f_name = (unsigned char *)file->f_path.dentry->d_name.name;
+		trace_direct_io_write(pos, iov_length(iov, nr_segs), f_name);
 
 		written = generic_file_direct_write(iocb, iov, &nr_segs, pos,
 							ppos, count, ocount);
@@ -2524,9 +2538,13 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
+	unsigned char *f_name;
 
 	BUG_ON(iocb->ki_pos != pos);
 
+	f_name = (unsigned char *)file->f_path.dentry->d_name.name;
+	trace_generic_file_aio_write(pos, iov_length(iov, nr_segs), f_name);
+
 	sb_start_write(inode->i_sb);
 	mutex_lock(&inode->i_mutex);
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
-- 
1.7.9.5

