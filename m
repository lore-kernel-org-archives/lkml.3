Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbaEEL6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:58:04 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:39714 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbaEEL6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:58:01 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>
Subject: [PATCH] locks: add some tracepoints in the lease handling code
Date: Mon,  5 May 2014 07:57:55 -0400
Message-Id: <1399291075-16122-1-git-send-email-jlayton@poochiereds.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: add a __break_lease tracepoint for non-blocking case

Recently, I needed these to help track down a softlockup when recalling a
delegation, but they might be helpful in other situations as well.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
---
 fs/locks.c                      | 10 +++++
 include/trace/events/filelock.h | 93 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+)
 create mode 100644 include/trace/events/filelock.h

diff --git a/fs/locks.c b/fs/locks.c
index 6b01d5a1de4a..2367f3118662 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -130,6 +130,9 @@
 #include <linux/percpu.h>
 #include <linux/lglock.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/filelock.h>
+
 #include <asm/uaccess.h>
 
 #define IS_POSIX(fl)	(fl->fl_flags & FL_POSIX)
@@ -1386,6 +1389,7 @@ int __break_lease(struct inode *inode, unsigned int mode, unsigned int type)
 	}
 
 	if (i_have_this_lease || (mode & O_NONBLOCK)) {
+		trace_break_lease_noblock(inode, new_fl);
 		error = -EWOULDBLOCK;
 		goto out;
 	}
@@ -1397,10 +1401,12 @@ restart:
 	if (break_time == 0)
 		break_time++;
 	locks_insert_block(flock, new_fl);
+	trace_break_lease_block(inode, new_fl);
 	spin_unlock(&inode->i_lock);
 	error = wait_event_interruptible_timeout(new_fl->fl_wait,
 						!new_fl->fl_next, break_time);
 	spin_lock(&inode->i_lock);
+	trace_break_lease_unblock(inode, new_fl);
 	locks_delete_block(new_fl);
 	if (error >= 0) {
 		if (error == 0)
@@ -1522,6 +1528,8 @@ static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp
 	int error;
 
 	lease = *flp;
+	trace_generic_add_lease(inode, lease);
+
 	/*
 	 * In the delegation case we need mutual exclusion with
 	 * a number of operations that take the i_mutex.  We trylock
@@ -1611,6 +1619,8 @@ static int generic_delete_lease(struct file *filp, struct file_lock **flp)
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 
+	trace_generic_delete_lease(inode, *flp);
+
 	for (before = &inode->i_flock;
 			((fl = *before) != NULL) && IS_LEASE(fl);
 			before = &fl->fl_next) {
diff --git a/include/trace/events/filelock.h b/include/trace/events/filelock.h
new file mode 100644
index 000000000000..d1e9d3eaa8ce
--- /dev/null
+++ b/include/trace/events/filelock.h
@@ -0,0 +1,93 @@
+/*
+ * Events for filesystem locks
+ *
+ * Copyright 2013 Jeff Layton <jlayton@poochiereds.net>
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM filelock
+
+#if !defined(_TRACE_FILELOCK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FILELOCK_H
+
+#include <linux/tracepoint.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/kdev_t.h>
+
+#define show_fl_flags(val)						\
+	__print_flags(val, "|", 					\
+		{ FL_POSIX,		"FL_POSIX" },			\
+		{ FL_FLOCK,		"FL_FLOCK" },			\
+		{ FL_DELEG,		"FL_DELEG" },			\
+		{ FL_ACCESS,		"FL_ACCESS" },			\
+		{ FL_EXISTS,		"FL_EXISTS" },			\
+		{ FL_LEASE,		"FL_LEASE" },			\
+		{ FL_CLOSE,		"FL_CLOSE" },			\
+		{ FL_SLEEP,		"FL_SLEEP" },			\
+		{ FL_DOWNGRADE_PENDING,	"FL_DOWNGRADE_PENDING" },	\
+		{ FL_UNLOCK_PENDING,	"FL_UNLOCK_PENDING" },		\
+		{ FL_OFDLCK,		"FL_OFDLCK" })
+
+#define show_fl_type(val)				\
+	__print_symbolic(val,				\
+			{ F_RDLCK, "F_RDLCK" },		\
+			{ F_WRLCK, "F_WRLCK" },		\
+			{ F_UNLCK, "F_UNLCK" })
+
+DECLARE_EVENT_CLASS(filelock_lease,
+
+	TP_PROTO(struct inode *inode, struct file_lock *fl),
+
+	TP_ARGS(inode, fl),
+
+	TP_STRUCT__entry(
+		__field(struct file_lock *, fl)
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(struct file_lock *, fl_next)
+		__field(fl_owner_t, fl_owner)
+		__field(unsigned int, fl_flags)
+		__field(unsigned char, fl_type)
+		__field(unsigned long, fl_break_time)
+		__field(unsigned long, fl_downgrade_time)
+	),
+
+	TP_fast_assign(
+		__entry->fl = fl;
+		__entry->s_dev = inode->i_sb->s_dev;
+		__entry->i_ino = inode->i_ino;
+		__entry->fl_next = fl->fl_next;
+		__entry->fl_owner = fl->fl_owner;
+		__entry->fl_flags = fl->fl_flags;
+		__entry->fl_type = fl->fl_type;
+		__entry->fl_break_time = fl->fl_break_time;
+		__entry->fl_downgrade_time = fl->fl_downgrade_time;
+	),
+
+	TP_printk("fl=0x%p dev=0x%x:0x%x ino=0x%lx fl_next=0x%p fl_owner=0x%p fl_flags=%s fl_type=%s fl_break_time=%lu fl_downgrade_time=%lu",
+		__entry->fl, MAJOR(__entry->s_dev), MINOR(__entry->s_dev),
+		__entry->i_ino, __entry->fl_next, __entry->fl_owner,
+		show_fl_flags(__entry->fl_flags),
+		show_fl_type(__entry->fl_type),
+		__entry->fl_break_time, __entry->fl_downgrade_time)
+);
+
+DEFINE_EVENT(filelock_lease, break_lease_noblock, TP_PROTO(struct inode *inode, struct file_lock *fl),
+		TP_ARGS(inode, fl));
+
+DEFINE_EVENT(filelock_lease, break_lease_block, TP_PROTO(struct inode *inode, struct file_lock *fl),
+		TP_ARGS(inode, fl));
+
+DEFINE_EVENT(filelock_lease, break_lease_unblock, TP_PROTO(struct inode *inode, struct file_lock *fl),
+		TP_ARGS(inode, fl));
+
+DEFINE_EVENT(filelock_lease, generic_add_lease, TP_PROTO(struct inode *inode, struct file_lock *fl),
+		TP_ARGS(inode, fl));
+
+DEFINE_EVENT(filelock_lease, generic_delete_lease, TP_PROTO(struct inode *inode, struct file_lock *fl),
+		TP_ARGS(inode, fl));
+
+#endif /* _TRACE_FILELOCK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.9.0

