Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab3KDSD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:03:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38151 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3KDSD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:03:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/29] tools lib traceevent: Update printk formats when entered
Date: Mon,  4 Nov 2013 14:59:01 -0300
Message-Id: <1383587947-17419-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of cropping off the '"' and '\n"' from a printk format every
time it is referenced, do it when it's added. This makes it easier to
reference a printk_map and should speed things up a little.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131101215500.495619312@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 29 ++++++++++++++---------------
 tools/lib/traceevent/event-parse.h |  2 +-
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index deedff9d06af..856b79105abc 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -604,10 +604,11 @@ find_printk(struct pevent *pevent, unsigned long long addr)
  * This registers a string by the address it was stored in the kernel.
  * The @fmt passed in is duplicated.
  */
-int pevent_register_print_string(struct pevent *pevent, char *fmt,
+int pevent_register_print_string(struct pevent *pevent, const char *fmt,
 				 unsigned long long addr)
 {
 	struct printk_list *item = malloc(sizeof(*item));
+	char *p;
 
 	if (!item)
 		return -1;
@@ -615,10 +616,21 @@ int pevent_register_print_string(struct pevent *pevent, char *fmt,
 	item->next = pevent->printklist;
 	item->addr = addr;
 
+	/* Strip off quotes and '\n' from the end */
+	if (fmt[0] == '"')
+		fmt++;
 	item->printk = strdup(fmt);
 	if (!item->printk)
 		goto out_free;
 
+	p = item->printk + strlen(item->printk) - 1;
+	if (*p == '"')
+		*p = 0;
+
+	p -= 2;
+	if (strcmp(p, "\\n") == 0)
+		*p = 0;
+
 	pevent->printklist = item;
 	pevent->printk_count++;
 
@@ -3887,7 +3899,6 @@ get_bprint_format(void *data, int size __maybe_unused,
 	struct format_field *field;
 	struct printk_map *printk;
 	char *format;
-	char *p;
 
 	field = pevent->bprint_fmt_field;
 
@@ -3909,20 +3920,8 @@ get_bprint_format(void *data, int size __maybe_unused,
 		return format;
 	}
 
-	p = printk->printk;
-	/* Remove any quotes. */
-	if (*p == '"')
-		p++;
-	if (asprintf(&format, "%s : %s", "%pf", p) < 0)
+	if (asprintf(&format, "%s : %s", "%pf", printk->printk) < 0)
 		return NULL;
-	/* remove ending quotes and new line since we will add one too */
-	p = format + strlen(format) - 1;
-	if (*p == '"')
-		*p = 0;
-
-	p -= 2;
-	if (strcmp(p, "\\n") == 0)
-		*p = 0;
 
 	return format;
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 7503edf5ac6a..9ab6367f2fe9 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -533,7 +533,7 @@ int pevent_register_comm(struct pevent *pevent, const char *comm, int pid);
 void pevent_register_trace_clock(struct pevent *pevent, char *trace_clock);
 int pevent_register_function(struct pevent *pevent, char *name,
 			     unsigned long long addr, char *mod);
-int pevent_register_print_string(struct pevent *pevent, char *fmt,
+int pevent_register_print_string(struct pevent *pevent, const char *fmt,
 				 unsigned long long addr);
 int pevent_pid_is_registered(struct pevent *pevent, int pid);
 
-- 
1.8.1.4

