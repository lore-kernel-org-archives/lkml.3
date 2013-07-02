Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab3GBCiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 22:38:17 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:59951 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3GBCiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 22:38:16 -0400
From: Alexander Z Lam <azl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Subject: [PATCH v2] tracing: Protect ftrace_trace_arrays list in trace_events.c
Date: Mon,  1 Jul 2013 19:37:54 -0700
Message-Id: <1372732674-22726-1-git-send-email-azl@google.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are multiple places where the ftrace_trace_arrays list is accessed in
trace_events.c without the trace_types_lock held.

Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Alexander Z Lam <azl@google.com>
---
 kernel/trace/trace.c        |  2 +-
 kernel/trace/trace.h        |  2 ++
 kernel/trace/trace_events.c | 11 ++++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2f7307e..35e5e55 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -245,7 +245,7 @@ static struct tracer		*trace_types __read_mostly;
 /*
  * trace_types_lock is used to protect the trace_types list.
  */
-static DEFINE_MUTEX(trace_types_lock);
+DEFINE_MUTEX(trace_types_lock);
 
 /*
  * serialize the access of the ring buffer
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3de07e0..334dc85 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -225,6 +225,8 @@ enum {
 
 extern struct list_head ftrace_trace_arrays;
 
+extern struct mutex trace_types_lock;
+
 /*
  * The global tracer (top) should be the first trace array added,
  * but we check the flag anyway.
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6db3290..1b14751 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -987,6 +987,7 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	int ret;
 
 	/* Make sure the system still exists */
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 		list_for_each_entry(dir, &tr->systems, list) {
@@ -1002,6 +1003,7 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	}
  exit_loop:
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 
 	if (!system)
 		return -ENODEV;
@@ -1586,6 +1588,7 @@ static void __add_event_to_tracers(struct ftrace_event_call *call,
 int trace_add_event_call(struct ftrace_event_call *call)
 {
 	int ret;
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 
 	ret = __register_event(call, NULL);
@@ -1593,11 +1596,13 @@ int trace_add_event_call(struct ftrace_event_call *call)
 		__add_event_to_tracers(call, NULL);
 
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 	return ret;
 }
 
 /*
- * Must be called under locking both of event_mutex and trace_event_sem.
+ * Must be called under locking of trace_types_lock, event_mutex and
+ * trace_event_sem.
  */
 static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
@@ -1609,11 +1614,13 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 /* Remove an event_call */
 void trace_remove_event_call(struct ftrace_event_call *call)
 {
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
 	__trace_remove_event_call(call);
 	up_write(&trace_event_sem);
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 }
 
 #define for_each_event(event, start, end)			\
@@ -1757,6 +1764,7 @@ static int trace_module_notify(struct notifier_block *self,
 {
 	struct module *mod = data;
 
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	switch (val) {
 	case MODULE_STATE_COMING:
@@ -1767,6 +1775,7 @@ static int trace_module_notify(struct notifier_block *self,
 		break;
 	}
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 
 	return 0;
 }
-- 
1.8.3

