Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaAPCb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:31:26 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:62884 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaAPCbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:31:21 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-ca-52d744775e3d
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 02/12] tools lib traceevent: Add pevent_unregister_print_function()
Date: Thu, 16 Jan 2014 11:31:08 +0900
Message-Id: <1389839478-5887-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
References: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a plugin unloaded it needs to unregister its print handler from
pevent.  So add unregister function to do it.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
1.7.11.7

