Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3KAVzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:55:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56337 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754506Ab3KAVzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:55:01 -0400
Message-Id: <20131101215500.495619312@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Nov 2013 17:53:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 2/8] tools lib traceevent: Update printk formats when entered
References: <20131101215352.875376844@goodmis.org>
Content-Disposition: inline; filename=0002-tools-lib-traceevent-Update-printk-formats-when-ente.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of cropping off the '"' and '\n"' from a printk format every
time it is referenced, do it when it's added. This makes it easier
to reference a printk_map and should speed things up a little.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 29 ++++++++++++++---------------
 tools/lib/traceevent/event-parse.h |  2 +-
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index deedff9..856b791 100644
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
index 7503edf..9ab6367 100644
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
1.8.4.rc3


