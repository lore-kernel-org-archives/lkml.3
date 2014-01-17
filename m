Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaAQPBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:01:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36287 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaAQO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:57:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/19] tools lib traceevent: Add pevent_unregister_event_handler()
Date: Fri, 17 Jan 2014 11:57:07 -0300
Message-Id: <1389970645-12075-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389970645-12075-1-git-send-email-acme@infradead.org>
References: <1389970645-12075-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When a plugin is unloaded it needs to unregister its handler from pevent.

So add an unregister function to do it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389839478-5887-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 113 ++++++++++++++++++++++++++++++++-----
 tools/lib/traceevent/event-parse.h |   3 +
 2 files changed, 102 insertions(+), 14 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 2ce565a73dd5..d1973cb8388b 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5560,6 +5560,29 @@ int pevent_register_print_function(struct pevent *pevent,
 	return ret;
 }
 
+static struct event_format *pevent_search_event(struct pevent *pevent, int id,
+						const char *sys_name,
+						const char *event_name)
+{
+	struct event_format *event;
+
+	if (id >= 0) {
+		/* search by id */
+		event = pevent_find_event(pevent, id);
+		if (!event)
+			return NULL;
+		if (event_name && (strcmp(event_name, event->name) != 0))
+			return NULL;
+		if (sys_name && (strcmp(sys_name, event->system) != 0))
+			return NULL;
+	} else {
+		event = pevent_find_event_by_name(pevent, sys_name, event_name);
+		if (!event)
+			return NULL;
+	}
+	return event;
+}
+
 /**
  * pevent_register_event_handler - register a way to parse an event
  * @pevent: the handle to the pevent
@@ -5584,20 +5607,9 @@ int pevent_register_event_handler(struct pevent *pevent, int id,
 	struct event_format *event;
 	struct event_handler *handle;
 
-	if (id >= 0) {
-		/* search by id */
-		event = pevent_find_event(pevent, id);
-		if (!event)
-			goto not_found;
-		if (event_name && (strcmp(event_name, event->name) != 0))
-			goto not_found;
-		if (sys_name && (strcmp(sys_name, event->system) != 0))
-			goto not_found;
-	} else {
-		event = pevent_find_event_by_name(pevent, sys_name, event_name);
-		if (!event)
-			goto not_found;
-	}
+	event = pevent_search_event(pevent, id, sys_name, event_name);
+	if (event == NULL)
+		goto not_found;
 
 	pr_stat("overriding event (%d) %s:%s with new print handler",
 		event->id, event->system, event->name);
@@ -5637,6 +5649,79 @@ int pevent_register_event_handler(struct pevent *pevent, int id,
 	return -1;
 }
 
+static int handle_matches(struct event_handler *handler, int id,
+			  const char *sys_name, const char *event_name,
+			  pevent_event_handler_func func, void *context)
+{
+	if (id >= 0 && id != handler->id)
+		return 0;
+
+	if (event_name && (strcmp(event_name, handler->event_name) != 0))
+		return 0;
+
+	if (sys_name && (strcmp(sys_name, handler->sys_name) != 0))
+		return 0;
+
+	if (func != handler->func || context != handler->context)
+		return 0;
+
+	return 1;
+}
+
+/**
+ * pevent_unregister_event_handler - unregister an existing event handler
+ * @pevent: the handle to the pevent
+ * @id: the id of the event to unregister
+ * @sys_name: the system name the handler belongs to
+ * @event_name: the name of the event handler
+ * @func: the function to call to parse the event information
+ * @context: the data to be passed to @func
+ *
+ * This function removes existing event handler (parser).
+ *
+ * If @id is >= 0, then it is used to find the event.
+ * else @sys_name and @event_name are used.
+ *
+ * Returns 0 if handler was removed successfully, -1 if event was not found.
+ */
+int pevent_unregister_event_handler(struct pevent *pevent, int id,
+				    const char *sys_name, const char *event_name,
+				    pevent_event_handler_func func, void *context)
+{
+	struct event_format *event;
+	struct event_handler *handle;
+	struct event_handler **next;
+
+	event = pevent_search_event(pevent, id, sys_name, event_name);
+	if (event == NULL)
+		goto not_found;
+
+	if (event->handler == func && event->context == context) {
+		pr_stat("removing override handler for event (%d) %s:%s. Going back to default handler.",
+			event->id, event->system, event->name);
+
+		event->handler = NULL;
+		event->context = NULL;
+		return 0;
+	}
+
+not_found:
+	for (next = &pevent->handlers; *next; next = &(*next)->next) {
+		handle = *next;
+		if (handle_matches(handle, id, sys_name, event_name,
+				   func, context))
+			break;
+	}
+
+	if (!(*next))
+		return -1;
+
+	*next = handle->next;
+	free_handler(handle);
+
+	return 0;
+}
+
 /**
  * pevent_alloc - create a pevent handle
  */
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index a3beca56cb35..c48acfbc6230 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -624,6 +624,9 @@ int pevent_print_func_field(struct trace_seq *s, const char *fmt,
 int pevent_register_event_handler(struct pevent *pevent, int id,
 				  const char *sys_name, const char *event_name,
 				  pevent_event_handler_func func, void *context);
+int pevent_unregister_event_handler(struct pevent *pevent, int id,
+				    const char *sys_name, const char *event_name,
+				    pevent_event_handler_func func, void *context);
 int pevent_register_print_function(struct pevent *pevent,
 				   pevent_func_handler func,
 				   enum pevent_func_arg_type ret_type,
-- 
1.8.1.4

