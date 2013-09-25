Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3IYDLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:11:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab3IYDLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:11:13 -0400
Message-ID: <52425444.204@suse.com>
Date: Tue, 24 Sep 2013 23:11:00 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] blktrace: fix race with open trace files and directory removal
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a bug in the blktrace client where it will stop and tear down
all of the tracing instances for devices it's opened whether it
successfully completed the setup or not.

By starting multiple blktrace processes on the same device, it's possible
to permanently disable blktrace on that device. The cause is that when
the first blktrace process to exit tears down the directory structure,
the trace files are still held open. Debugfs removes the dentries for the
open files just fine but the relay implementation doesn't remove the
dentries until all of the references to the file are dropped. This means
that if there are open files when debugfs_remove is called for the device
directory, the directory is not empty and can't be removed. Since the
shutdown of the blktrace structure xchg's the structure out, there's no
way to clean up the directory and any new blktrace processes will fail
to start because it can't create the directory.

This patch adds a kref to blk_trace so that we can release it after the
initial reference as well as all of the references accumulated by the
relay files are dropped.

I have a fix for the blktrace client to avoid the situation on older
kernels as well.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 include/linux/blktrace_api.h |    2 ++
 kernel/trace/blktrace.c      |   37 +++++++++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

--- a/include/linux/blktrace_api.h	2013-09-24 22:39:53.342710250 -0400
+++ b/include/linux/blktrace_api.h	2013-09-24 22:55:11.376936518 -0400
@@ -4,6 +4,7 @@
 #include <linux/blkdev.h>
 #include <linux/relay.h>
 #include <linux/compat.h>
+#include <linux/kref.h>
 #include <uapi/linux/blktrace_api.h>
 
 #if defined(CONFIG_BLK_DEV_IO_TRACE)
@@ -24,6 +25,7 @@ struct blk_trace {
 	struct dentry *dropped_file;
 	struct dentry *msg_file;
 	atomic_t dropped;
+	struct kref kref;
 };
 
 extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
--- a/kernel/trace/blktrace.c	2013-09-24 22:39:53.342710250 -0400
+++ b/kernel/trace/blktrace.c	2013-09-24 22:55:39.004572055 -0400
@@ -278,17 +278,33 @@ record_it:
 static struct dentry *blk_tree_root;
 static DEFINE_MUTEX(blk_tree_mutex);
 
-static void blk_trace_free(struct blk_trace *bt)
+static void blk_trace_release(struct kref *kref)
 {
+	struct blk_trace *bt = container_of(kref, struct blk_trace, kref);
 	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
-	relay_close(bt->rchan);
 	debugfs_remove(bt->dir);
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);
 	kfree(bt);
 }
 
+static void blk_trace_free(struct blk_trace *bt)
+{
+	/*
+	 * The directory can't be removed until it's empty.
+	 * The debugfs files created directly can be removed while
+	 * they're open. The debugfs files created by relay won't
+	 * be removed until they've been released. This drops our
+	 * references to the files but the directory (and the rest
+	 * of the blk_trace structure) won't be cleaned up until
+	 * all of the relay files are closed by the user.
+	 */
+	relay_close(bt->rchan);
+	bt->rchan = NULL;
+	kref_put(&bt->kref, blk_trace_release);
+}
+
 static void blk_trace_cleanup(struct blk_trace *bt)
 {
 	blk_trace_free(bt);
@@ -381,8 +397,10 @@ static int blk_subbuf_start_callback(str
 
 static int blk_remove_buf_file_callback(struct dentry *dentry)
 {
+	struct blk_trace *bt = dentry->d_parent->d_inode->i_private;
 	debugfs_remove(dentry);
 
+	kref_put(&bt->kref, blk_trace_release);
 	return 0;
 }
 
@@ -392,8 +410,15 @@ static struct dentry *blk_create_buf_fil
 						   struct rchan_buf *buf,
 						   int *is_global)
 {
-	return debugfs_create_file(filename, mode, parent, buf,
-					&relay_file_operations);
+	struct blk_trace *bt = parent->d_inode->i_private;
+	struct dentry *dentry;
+
+	dentry = debugfs_create_file(filename, mode, parent, buf,
+				     &relay_file_operations);
+	if (dentry)
+		kref_get(&bt->kref);
+
+	return dentry;
 }
 
 static struct rchan_callbacks blk_relay_callbacks = {
@@ -448,6 +473,8 @@ int do_blk_trace_setup(struct request_qu
 	if (!bt)
 		return -ENOMEM;
 
+	kref_init(&bt->kref);
+
 	ret = -ENOMEM;
 	bt->sequence = alloc_percpu(unsigned long);
 	if (!bt->sequence)
@@ -474,6 +501,8 @@ int do_blk_trace_setup(struct request_qu
 	if (!dir)
 		goto err;
 
+	dir->d_inode->i_private = bt;
+
 	bt->dir = dir;
 	bt->dev = dev;
 	atomic_set(&bt->dropped, 0);
