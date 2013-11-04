Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3KDSD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:03:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38147 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3KDSDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:03:54 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/29] tools lib traceevent: If %s is a pointer, check printk formats
Date: Mon,  4 Nov 2013 14:59:02 -0300
Message-Id: <1383587947-17419-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If the format string of TP_printk() contains a %s, and the argument is
not a string, check if the argument is a pointer that might match the
printk_formats that were stored.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131101215500.698924777@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 856b79105abc..013c8d3db806 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3505,6 +3505,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	struct pevent *pevent = event->pevent;
 	struct print_flag_sym *flag;
 	struct format_field *field;
+	struct printk_map *printk;
 	unsigned long long val, fval;
 	unsigned long addr;
 	char *str;
@@ -3540,7 +3541,12 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		if (!(field->flags & FIELD_IS_ARRAY) &&
 		    field->size == pevent->long_size) {
 			addr = *(unsigned long *)(data + field->offset);
-			trace_seq_printf(s, "%lx", addr);
+			/* Check if it matches a print format */
+			printk = find_printk(pevent, addr);
+			if (printk)
+				trace_seq_puts(s, printk->printk);
+			else
+				trace_seq_printf(s, "%lx", addr);
 			break;
 		}
 		str = malloc(len + 1);
-- 
1.8.1.4

