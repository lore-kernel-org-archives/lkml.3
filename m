Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaAOBt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:49:29 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64925 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaAOBpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:45:44 -0500
X-AuditID: 9c930197-b7b7cae000000e34-54-52d5e846a846
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 05/17] tools lib traceevent: Make plugin unload function receive pevent
Date: Wed, 15 Jan 2014 10:45:28 +0900
Message-Id: <1389750340-15965-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PEVENT_PLUGIN_UNLOADER function might need some cleanup using
pevent like unregister some handlers.  So pass pevent as argument.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.h     | 7 ++++---
 tools/lib/traceevent/event-plugin.c    | 4 ++--
 tools/lib/traceevent/plugin_function.c | 2 +-
 tools/perf/util/trace-event.c          | 2 +-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 3c890cb28db7..a3beca56cb35 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -105,7 +105,7 @@ typedef int (*pevent_event_handler_func)(struct trace_seq *s,
 					 void *context);
 
 typedef int (*pevent_plugin_load_func)(struct pevent *pevent);
-typedef int (*pevent_plugin_unload_func)(void);
+typedef int (*pevent_plugin_unload_func)(struct pevent *pevent);
 
 struct plugin_option {
 	struct plugin_option		*next;
@@ -130,7 +130,7 @@ struct plugin_option {
  * PEVENT_PLUGIN_UNLOADER:  (optional)
  *   The function called just before unloading
  *
- *   int PEVENT_PLUGIN_UNLOADER(void)
+ *   int PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
  *
  * PEVENT_PLUGIN_OPTIONS:  (optional)
  *   Plugin options that can be set before loading
@@ -411,7 +411,8 @@ enum pevent_errno {
 struct plugin_list;
 
 struct plugin_list *traceevent_load_plugins(struct pevent *pevent);
-void traceevent_unload_plugins(struct plugin_list *plugin_list);
+void traceevent_unload_plugins(struct plugin_list *plugin_list,
+			       struct pevent *pevent);
 
 struct cmdline;
 struct cmdline_list;
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 125f5676bcb5..0c8bf6780e4d 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -197,7 +197,7 @@ traceevent_load_plugins(struct pevent *pevent)
 }
 
 void
-traceevent_unload_plugins(struct plugin_list *plugin_list)
+traceevent_unload_plugins(struct plugin_list *plugin_list, struct pevent *pevent)
 {
 	pevent_plugin_unload_func func;
 	struct plugin_list *list;
@@ -207,7 +207,7 @@ traceevent_unload_plugins(struct plugin_list *plugin_list)
 		plugin_list = list->next;
 		func = dlsym(list->handle, PEVENT_PLUGIN_UNLOADER_NAME);
 		if (func)
-			func();
+			func(pevent);
 		dlclose(list->handle);
 		free(list->name);
 		free(list);
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index aad92ad5e96f..39461485f9a7 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -144,7 +144,7 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(void)
+void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
 {
 	int i, x;
 
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
index d9f5f6137ab3..6322d37164c5 100644
--- a/tools/perf/util/trace-event.c
+++ b/tools/perf/util/trace-event.c
@@ -34,8 +34,8 @@ int trace_event__init(struct trace_event *t)
 
 void trace_event__cleanup(struct trace_event *t)
 {
+	traceevent_unload_plugins(t->plugin_list, t->pevent);
 	pevent_free(t->pevent);
-	traceevent_unload_plugins(t->plugin_list);
 }
 
 static struct event_format*
-- 
1.7.11.7

