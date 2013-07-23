Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3GWVEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:04:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758152Ab3GWVEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:04:43 -0400
Date: Tue, 23 Jul 2013 22:59:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] tracing: Change remove_event_file_dir() to clear
	"d_subdirs"->i_private
Message-ID: <20130723205927.GA9082@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723205854.GA9036@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change remove_event_file_dir() ->i_private for every file we
are going to remove.

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

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   40 ++++++++--------------------------------
 1 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3ae037c..298e4fa 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -428,42 +428,19 @@ static void *event_file_data(struct file *filp)
 
 static void remove_event_file_dir(struct ftrace_event_file *file)
 {
+	struct dentry *dir = file->dir;
+	struct dentry *child;
+	/* ->i_mutex is not needed, nodody can create/remove a file */
+	list_for_each_entry(child, &dir->d_subdirs, d_u.d_child)
+		child->d_inode->i_private = NULL;
+
 	list_del(&file->list);
-	debugfs_remove_recursive(file->dir);
+	debugfs_remove_recursive(dir);
 	remove_subsystem(file->system);
 	kmem_cache_free(file_cachep, file);
 }
 
 /*
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
-
-	trace_array_put(tr);
-
-	return 0;
-}
-
-/*
  * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
  */
 static int
@@ -1274,10 +1251,9 @@ static const struct file_operations ftrace_set_event_fops = {
 };
 
 static const struct file_operations ftrace_enable_fops = {
-	.open = tracing_open_generic_file,
+	.open = tracing_open_generic,
 	.read = event_enable_read,
 	.write = event_enable_write,
-	.release = tracing_release_generic_file,
 	.llseek = default_llseek,
 };
 
-- 
1.5.5.1

