Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab3KSX3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:29:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:15029 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752211Ab3KSX3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:29:39 -0500
Date: Tue, 19 Nov 2013 18:29:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] tools lib traceevent: Use helper trace-seq in print
 functions like kernel does
Message-ID: <20131119182937.401668e3@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olso reported that his plugin for scsi was chopping off part of
the output. Investigating this, I found that Jiri used the same
functions as what is in the kernel, which adds the following:

	trace_seq_putc(p, 0);

This adds a '\0' to the output string. The reason this works in the
kernel is that the "p" that is passed to the function helper is a
temporary trace_seq. But in the libtraceevent library, it's the pointer
to the trace_seq used to output. By adding the '\0', it truncates the
line and nothing added after that will be printed.

We can solve this in two ways. One is to have the helper functions for
the library not add the unnecessary '\0'. The other is to change the
library to also use a helper trace_seq structure that gets copied to
the main trace_seq just like the kernel does.

The latter allows the helper functions in the plugins to be the same as
the kernel, which is the better solution.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 0362d57..27d2940 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4080,6 +4080,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 	unsigned long long val;
 	struct func_map *func;
 	const char *saveptr;
+	struct trace_seq p;
 	char *bprint_fmt = NULL;
 	char format[32];
 	int show_func;
@@ -4287,8 +4288,12 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
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
