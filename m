Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3G3Ldd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:33:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3G3Lby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:31:54 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=CVlx3W2nY-cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=bywy1vxgP7UA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=AAvYLDLOAAAA:8 a=ul9NfeeRlprL3ozlsnUA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=s2loLT2QvaoA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130730113152.994455018@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Jul 2013 07:27:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 6/8] tracing: Change remove_event_file_dir() to clear
 "d_subdirs"->i_private
References: <20130730112718.273490378@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Change-remove_event_file_dir-to-clear-d_subd.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

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
---
 kernel/trace/trace_events.c |   47 ++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 05d647e..a67c913 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -428,42 +428,26 @@ static void *event_file_data(struct file *filp)
 
 static void remove_event_file_dir(struct ftrace_event_file *file)
 {
+	struct dentry *dir = file->dir;
+	struct dentry *child;
+
+	if (dir) {
+		spin_lock(&dir->d_lock);	/* probably unneeded */
+		list_for_each_entry(child, &dir->d_subdirs, d_u.d_child) {
+			if (child->d_inode)	/* probably unneeded */
+				child->d_inode->i_private = NULL;
+		}
+		spin_unlock(&dir->d_lock);
+
+		debugfs_remove_recursive(dir);
+	}
+
 	list_del(&file->list);
-	debugfs_remove_recursive(file->dir);
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
@@ -1281,10 +1265,9 @@ static const struct file_operations ftrace_set_event_fops = {
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
1.7.10.4


