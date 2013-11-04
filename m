Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3KDUXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:23:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50130 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3KDUXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:23:00 -0500
Date: Mon, 4 Nov 2013 12:22:33 -0800
From: "tip-bot for Steven Rostedt (Red Hat)" <tipbot@zytor.com>
Message-ID: <tip-18900af8292180151c82f0762506fa0740aa54a5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20131101215500.495619312@goodmis.org>
References: <20131101215500.495619312@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Update printk formats when entered
Git-Commit-ID: 18900af8292180151c82f0762506fa0740aa54a5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:22:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18900af8292180151c82f0762506fa0740aa54a5
Gitweb:     http://git.kernel.org/tip/18900af8292180151c82f0762506fa0740aa54a5
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Fri, 1 Nov 2013 17:53:54 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 14:33:59 -0300

tools lib traceevent: Update printk formats when entered

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
 
