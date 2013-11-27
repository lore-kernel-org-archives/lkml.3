Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab3K0UQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:16:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60943 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3K0UQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:16:50 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/34] tools lib traceevent: Use helper trace-seq in print functions like kernel does
Date: Wed, 27 Nov 2013 17:16:01 -0300
Message-Id: <1385583394-3703-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Jiri Olsa reported that his plugin for scsi was chopping off part of the
output. Investigating this, I found that Jiri used the same functions as
what is in the kernel, which adds the following:

	trace_seq_putc(p, 0);

This adds a '\0' to the output string. The reason this works in the
kernel is that the "p" that is passed to the function helper is a
temporary trace_seq. But in the libtraceevent library, it's the pointer
to the trace_seq used to output. By adding the '\0', it truncates the
line and nothing added after that will be printed.

We can solve this in two ways. One is to have the helper functions for
the library not add the unnecessary '\0'. The other is to change the
library to also use a helper trace_seq structure that gets copied to the
main trace_seq just like the kernel does.

The latter allows the helper functions in the plugins to be the same as
the kernel, which is the better solution.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131119182937.401668e3@gandalf.local.home
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 217c82ee3665..900fca01bdd3 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4099,6 +4099,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 	unsigned long long val;
 	struct func_map *func;
 	const char *saveptr;
+	struct trace_seq p;
 	char *bprint_fmt = NULL;
 	char format[32];
 	int show_func;
@@ -4306,8 +4307,12 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 				format[len] = 0;
 				if (!len_as_arg)
 					len_arg = -1;
-				print_str_arg(s, data, size, event,
+				/* Use helper trace_seq */
+				trace_seq_init(&p);
+				print_str_arg(&p, data, size, event,
 					      format, len_arg, arg);
+				trace_seq_terminate(&p);
+				trace_seq_puts(s, p.buffer);
 				arg = arg->next;
 				break;
 			default:
-- 
1.8.1.4

