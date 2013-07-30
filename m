Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3G3LcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:32:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3G3Lb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:31:56 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=wZX6bLAhSg4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=0Zlrqf90RdoA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=TAV5yd5sUnrUJazBUAMA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130730113152.747026204@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Jul 2013 07:27:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 5/8] tracing: Introduce remove_event_file_dir()
References: <20130730112718.273490378@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Introduce-remove_event_file_dir.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Preparation for the next patch. Extract the common code from
remove_event_from_tracers() and __trace_remove_event_dirs()
into the new helper, remove_event_file_dir().

The patch looks more complicated than it actually is, it also
moves remove_subsystem() up to avoid the forward declaration.

Link: http://lkml.kernel.org/r/20130726172547.GA3629@redhat.com

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   47 +++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 50dc8b2..05d647e 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -409,11 +409,31 @@ static void put_system(struct ftrace_subsystem_dir *dir)
 	mutex_unlock(&event_mutex);
 }
 
+static void remove_subsystem(struct ftrace_subsystem_dir *dir)
+{
+	if (!dir)
+		return;
+
+	if (!--dir->nr_events) {
+		debugfs_remove_recursive(dir->entry);
+		list_del(&dir->list);
+		__put_system_dir(dir);
+	}
+}
+
 static void *event_file_data(struct file *filp)
 {
 	return ACCESS_ONCE(file_inode(filp)->i_private);
 }
 
+static void remove_event_file_dir(struct ftrace_event_file *file)
+{
+	list_del(&file->list);
+	debugfs_remove_recursive(file->dir);
+	remove_subsystem(file->system);
+	kmem_cache_free(file_cachep, file);
+}
+
 /*
  * Open and update trace_array ref count.
  * Must have the current trace_array passed to it.
@@ -1549,33 +1569,16 @@ event_create_dir(struct dentry *parent,
 	return 0;
 }
 
-static void remove_subsystem(struct ftrace_subsystem_dir *dir)
-{
-	if (!dir)
-		return;
-
-	if (!--dir->nr_events) {
-		debugfs_remove_recursive(dir->entry);
-		list_del(&dir->list);
-		__put_system_dir(dir);
-	}
-}
-
 static void remove_event_from_tracers(struct ftrace_event_call *call)
 {
 	struct ftrace_event_file *file;
 	struct trace_array *tr;
 
 	do_for_each_event_file_safe(tr, file) {
-
 		if (file->event_call != call)
 			continue;
 
-		list_del(&file->list);
-		debugfs_remove_recursive(file->dir);
-		remove_subsystem(file->system);
-		kmem_cache_free(file_cachep, file);
-
+		remove_event_file_dir(file);
 		/*
 		 * The do_for_each_event_file_safe() is
 		 * a double loop. After finding the call for this
@@ -2305,12 +2308,8 @@ __trace_remove_event_dirs(struct trace_array *tr)
 {
 	struct ftrace_event_file *file, *next;
 
-	list_for_each_entry_safe(file, next, &tr->events, list) {
-		list_del(&file->list);
-		debugfs_remove_recursive(file->dir);
-		remove_subsystem(file->system);
-		kmem_cache_free(file_cachep, file);
-	}
+	list_for_each_entry_safe(file, next, &tr->events, list)
+		remove_event_file_dir(file);
 }
 
 static void
-- 
1.7.10.4


