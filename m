Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab3GWVEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab3GWVEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:04:40 -0400
Date: Tue, 23 Jul 2013 22:59:23 +0200
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
Subject: [PATCH 5/6] tracing: Introduce remove_event_file_dir()
Message-ID: <20130723205923.GA9075@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723205854.GA9036@redhat.com>
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
 kernel/trace/trace_events.c |   66 +++++++++++++++++++++----------------------
 1 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 4b43111..3ae037c 100644
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
@@ -1542,40 +1562,22 @@ event_create_dir(struct dentry *parent,
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
-		if (file->event_call != call)
-			continue;
-
-		list_del(&file->list);
-		debugfs_remove_recursive(file->dir);
-		remove_subsystem(file->system);
-		kmem_cache_free(file_cachep, file);
-
-		/*
-		 * The do_for_each_event_file_safe() is
-		 * a double loop. After finding the call for this
-		 * trace_array, we use break to jump to the next
-		 * trace_array.
-		 */
-		break;
+		if (file->event_call == call) {
+			remove_event_file_dir(file);
+			/*
+			 * The do_for_each_event_file_safe() is
+			 * a double loop. After finding the call for this
+			 * trace_array, we use break to jump to the next
+			 * trace_array.
+			 */
+			break;
+		}
 	} while_for_each_event_file();
 }
 
@@ -2298,12 +2300,8 @@ __trace_remove_event_dirs(struct trace_array *tr)
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

