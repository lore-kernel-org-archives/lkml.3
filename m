Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3GAWbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:31:47 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:40574 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3GAWbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:31:46 -0400
From: Alexander Z Lam <azl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Subject: [PATCH 3/3] tracing: Protect ftrace_trace_arrays list in trace_events.c
Date: Mon,  1 Jul 2013 15:31:25 -0700
Message-Id: <1372717885-4543-3-git-send-email-azl@google.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1372717885-4543-1-git-send-email-azl@google.com>
References: <1372717885-4543-1-git-send-email-azl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are multiple places where the ftrace_trace_arrays list is accessed in
trace_events.c without the trace_types_lock held.

Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Alexander Z Lam <azl@google.com>
---
 kernel/trace/trace_events.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6db3290..26351cc 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1586,6 +1586,7 @@ static void __add_event_to_tracers(struct ftrace_event_call *call,
 int trace_add_event_call(struct ftrace_event_call *call)
 {
 	int ret;
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 
 	ret = __register_event(call, NULL);
@@ -1593,11 +1594,13 @@ int trace_add_event_call(struct ftrace_event_call *call)
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
@@ -1609,11 +1612,13 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
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
@@ -1757,6 +1762,7 @@ static int trace_module_notify(struct notifier_block *self,
 {
 	struct module *mod = data;
 
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	switch (val) {
 	case MODULE_STATE_COMING:
@@ -1767,6 +1773,7 @@ static int trace_module_notify(struct notifier_block *self,
 		break;
 	}
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 
 	return 0;
 }
-- 
1.8.3

