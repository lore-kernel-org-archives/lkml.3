Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3H0BHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3H0BHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 30/74] tracing: Introduce remove_event_file_dir()
Date: Mon, 26 Aug 2013 18:08:28 -0700
Message-Id: <20130827010430.947291028@linuxfoundation.org>
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

commit f6a84bdc75b5c11621dec58db73fe102cbaf40cc upstream.

Preparation for the next patch. Extract the common code from
remove_event_from_tracers() and __trace_remove_event_dirs()
into the new helper, remove_event_file_dir().

The patch looks more complicated than it actually is, it also
moves remove_subsystem() up to avoid the forward declaration.

Link: http://lkml.kernel.org/r/20130726172547.GA3629@redhat.com

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events.c |   47 +++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -407,11 +407,31 @@ static void put_system(struct ftrace_sub
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
@@ -1571,33 +1591,16 @@ event_create_dir(struct dentry *parent,
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
@@ -2330,12 +2333,8 @@ __trace_remove_event_dirs(struct trace_a
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


