Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3KDUXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:23:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50187 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3KDUXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:23:44 -0500
Date: Mon, 4 Nov 2013 12:23:29 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-6d862b8c14ba539c7c87ffc77f2e1d6dc9630c4d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, srostedt@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, srostedt@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20131101215501.869542711@goodmis.org>
References: <20131101215501.869542711@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Add pevent_print_func_field
 () helper function
Git-Commit-ID: 6d862b8c14ba539c7c87ffc77f2e1d6dc9630c4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:23:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d862b8c14ba539c7c87ffc77f2e1d6dc9630c4d
Gitweb:     http://git.kernel.org/tip/6d862b8c14ba539c7c87ffc77f2e1d6dc9630c4d
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 1 Nov 2013 17:54:00 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 14:36:49 -0300

tools lib traceevent: Add pevent_print_func_field() helper function

Add the pevent_print_func_field() that will look up a field that is
expected to be a function pointer, and it will print the function name
and offset of the address given by the field.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131101215501.869542711@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 42 ++++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/event-parse.h |  4 ++++
 2 files changed, 46 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index fc6f35f..8f450ad 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5367,6 +5367,48 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 	return -1;
 }
 
+/**
+ * pevent_print_func_field - print a field and a format for function pointers
+ * @s: The seq to print to
+ * @fmt: The printf format to print the field with.
+ * @event: the event that the field is for
+ * @name: The name of the field
+ * @record: The record with the field name.
+ * @err: print default error if failed.
+ *
+ * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
+ */
+int pevent_print_func_field(struct trace_seq *s, const char *fmt,
+			    struct event_format *event, const char *name,
+			    struct pevent_record *record, int err)
+{
+	struct format_field *field = pevent_find_field(event, name);
+	struct pevent *pevent = event->pevent;
+	unsigned long long val;
+	struct func_map *func;
+	char tmp[128];
+
+	if (!field)
+		goto failed;
+
+	if (pevent_read_number_field(field, record->data, &val))
+		goto failed;
+
+	func = find_func(pevent, val);
+
+	if (func)
+		snprintf(tmp, 128, "%s/0x%llx", func->func, func->addr - val);
+	else
+		sprintf(tmp, "0x%08llx", val);
+
+	return trace_seq_printf(s, fmt, tmp);
+
+ failed:
+	if (err)
+		trace_seq_printf(s, "CAN'T FIND FIELD \"%s\"", name);
+	return -1;
+}
+
 static void free_func_handle(struct pevent_function_handler *func)
 {
 	struct pevent_func_params *params;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index dc8539e..8d73d25 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -569,6 +569,10 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
 			   struct pevent_record *record, int err);
 
+int pevent_print_func_field(struct trace_seq *s, const char *fmt,
+			   struct event_format *event, const char *name,
+			   struct pevent_record *record, int err);
+
 int pevent_register_event_handler(struct pevent *pevent, int id,
 				  const char *sys_name, const char *event_name,
 				  pevent_event_handler_func func, void *context);
