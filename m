Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaASMXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:23:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55710 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaASMXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:23:15 -0500
Date: Sun, 19 Jan 2014 04:22:43 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-20c7e5abbd0cdfaa656f46af052a6e6a8ce94775@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1389839478-5887-3-git-send-email-namhyung@kernel.org>
References: <1389839478-5887-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Add pevent_unregister_print_function()
Git-Commit-ID: 20c7e5abbd0cdfaa656f46af052a6e6a8ce94775
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 19 Jan 2014 04:22:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20c7e5abbd0cdfaa656f46af052a6e6a8ce94775
Gitweb:     http://git.kernel.org/tip/20c7e5abbd0cdfaa656f46af052a6e6a8ce94775
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 16 Jan 2014 11:31:08 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Jan 2014 16:26:24 -0300

tools lib traceevent: Add pevent_unregister_print_function()

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
index d1973cb..1587ea39 100644
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
index c48acfb..791c539 100644
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
