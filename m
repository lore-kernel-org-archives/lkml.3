Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab3GZRcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759144Ab3GZRbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:31:10 -0400
Date: Fri, 26 Jul 2013 19:25:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] tracing: Introduce remove_event_file_dir()
Message-ID: <20130726172547.GA3629@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726172513.GA3586@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation for the next patch. Extract the common code from
remove_event_from_tracers() and __trace_remove_event_dirs()
into the new helper, remove_event_file_dir().

The patch looks more complicated than it actually is, it also
moves remove_subsystem() up to avoid the forward declaration.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   47 +++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3de2aca..2a4f68a 100644
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
@@ -1545,33 +1565,16 @@ event_create_dir(struct dentry *parent,
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
@@ -2301,12 +2304,8 @@ __trace_remove_event_dirs(struct trace_array *tr)
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
1.5.5.1

