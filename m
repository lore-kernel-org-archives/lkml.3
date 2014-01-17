Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaAQO5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:57:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36289 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaAQO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:57:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/19] tools lib traceevent: Add pevent_unregister_print_function()
Date: Fri, 17 Jan 2014 11:57:08 -0300
Message-Id: <1389970645-12075-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389970645-12075-1-git-send-email-acme@infradead.org>
References: <1389970645-12075-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When a plugin unloaded it needs to unregister its print handler from
pevent.

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
Link: http://lkml.kernel.org/r/1389839478-5887-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 23 +++++++++++++++++++++++
 tools/lib/traceevent/event-parse.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index d1973cb8388b..1587ea392ad6 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5560,6 +5560,29 @@ int pevent_register_print_function(struct pevent *pevent,
 	return ret;
 }
 
+/**
+ * pevent_unregister_print_function - unregister a helper function
+ * @pevent: the handle to the pevent
+ * @func: the function to process the helper function
+ * @name: the name of the helper function
+ *
+ * This function removes existing print handler for function @name.
+ *
+ * Returns 0 if the handler was removed successully, -1 otherwise.
+ */
+int pevent_unregister_print_function(struct pevent *pevent,
+				     pevent_func_handler func, char *name)
+{
+	struct pevent_function_handler *func_handle;
+
+	func_handle = find_func_handler(pevent, name);
+	if (func_handle && func_handle->func == func) {
+		remove_func_handler(pevent, name);
+		return 0;
+	}
+	return -1;
+}
+
 static struct event_format *pevent_search_event(struct pevent *pevent, int id,
 						const char *sys_name,
 						const char *event_name)
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index c48acfbc6230..791c539374c7 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -631,6 +631,8 @@ int pevent_register_print_function(struct pevent *pevent,
 				   pevent_func_handler func,
 				   enum pevent_func_arg_type ret_type,
 				   char *name, ...);
+int pevent_unregister_print_function(struct pevent *pevent,
+				     pevent_func_handler func, char *name);
 
 struct format_field *pevent_find_common_field(struct event_format *event, const char *name);
 struct format_field *pevent_find_field(struct event_format *event, const char *name);
-- 
1.8.1.4

