Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3H0BHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3H0BHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 31/74] tracing: Change remove_event_file_dir() to clear "d_subdirs"->i_private
Date: Mon, 26 Aug 2013 18:08:29 -0700
Message-Id: <20130827010431.096943152@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit bf682c3159c4d298d1126a56793ed3f5e80395f7 upstream.

Change remove_event_file_dir() to clear ->i_private for every
file we are going to remove.

We need to check file->dir != NULL because event_create_dir()
can fail. debugfs_remove_recursive(NULL) is fine but the patch
moves it under the same check anyway for readability.

spin_lock(d_lock) and "d_inode != NULL" check are not needed
afaics, but I do not understand this code enough.

tracing_open_generic_file() and tracing_release_generic_file()
can go away, ftrace_enable_fops and ftrace_event_filter_fops()
use tracing_open_generic() but only to check tracing_disabled.

This fixes all races with event_remove() or instance_delete().
f_op->read/write/whatever can never use the freed file/call,
all event/* files were changed to check and use ->i_private
under event_mutex.

Note: this doesn't not fix other problems, event_remove() can
destroy the active ftrace_event_call, we need more changes but
those changes are completely orthogonal.

Link: http://lkml.kernel.org/r/20130728183527.GB16723@redhat.com

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events.c |   47 ++++++++++++++------------------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -426,39 +426,23 @@ static void *event_file_data(struct file
 
 static void remove_event_file_dir(struct ftrace_event_file *file)
 {
-	list_del(&file->list);
-	debugfs_remove_recursive(file->dir);
-	remove_subsystem(file->system);
-	kmem_cache_free(file_cachep, file);
-}
+	struct dentry *dir = file->dir;
+	struct dentry *child;
 
-/*
- * Open and update trace_array ref count.
- * Must have the current trace_array passed to it.
- */
-static int tracing_open_generic_file(struct inode *inode, struct file *filp)
-{
-	struct ftrace_event_file *file = inode->i_private;
-	struct trace_array *tr = file->tr;
-	int ret;
-
-	if (trace_array_get(tr) < 0)
-		return -ENODEV;
-
-	ret = tracing_open_generic(inode, filp);
-	if (ret < 0)
-		trace_array_put(tr);
-	return ret;
-}
-
-static int tracing_release_generic_file(struct inode *inode, struct file *filp)
-{
-	struct ftrace_event_file *file = inode->i_private;
-	struct trace_array *tr = file->tr;
+	if (dir) {
+		spin_lock(&dir->d_lock);	/* probably unneeded */
+		list_for_each_entry(child, &dir->d_subdirs, d_u.d_child) {
+			if (child->d_inode)	/* probably unneeded */
+				child->d_inode->i_private = NULL;
+		}
+		spin_unlock(&dir->d_lock);
 
-	trace_array_put(tr);
+		debugfs_remove_recursive(dir);
+	}
 
-	return 0;
+	list_del(&file->list);
+	remove_subsystem(file->system);
+	kmem_cache_free(file_cachep, file);
 }
 
 /*
@@ -1303,10 +1287,9 @@ static const struct file_operations ftra
 };
 
 static const struct file_operations ftrace_enable_fops = {
-	.open = tracing_open_generic_file,
+	.open = tracing_open_generic,
 	.read = event_enable_read,
 	.write = event_enable_write,
-	.release = tracing_release_generic_file,
 	.llseek = default_llseek,
 };
 


