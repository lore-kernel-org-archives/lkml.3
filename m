Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaAOBs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:48:57 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43403 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOBpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:45:44 -0500
X-AuditID: 9c930197-b7b7cae000000e34-57-52d5e8463723
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/17] tools lib traceevent: Add pevent_unregister_event_handler()
Date: Wed, 15 Jan 2014 10:45:29 +0900
Message-Id: <1389750340-15965-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a plugin unloaded it needs to unregister its handler from pevent.
So add unregister function to do it.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 113 ++++++++++++++++++++++++++++++++-----
 tools/lib/traceevent/event-parse.h |   3 +
 2 files changed, 102 insertions(+), 14 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 2ce565a73dd5..05ae4b4ed0c8 100644
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
+		pr_stat("overriding event (%d) %s:%s with default print handler",
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
1.7.11.7

