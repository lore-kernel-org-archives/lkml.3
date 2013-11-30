Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3K3M5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:57:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3K3Mtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:49:41 -0500
Date: Sat, 30 Nov 2013 04:49:10 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-12e55569a244996a23cb401e8116e5a060b664f0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20131119182937.401668e3@gandalf.local.home>
References: <20131119182937.401668e3@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Use helper trace-seq in print functions like kernel does
Git-Commit-ID: 12e55569a244996a23cb401e8116e5a060b664f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:49:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12e55569a244996a23cb401e8116e5a060b664f0
Gitweb:     http://git.kernel.org/tip/12e55569a244996a23cb401e8116e5a060b664f0
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Tue, 19 Nov 2013 18:29:37 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:34 -0300

tools lib traceevent: Use helper trace-seq in print functions like kernel does

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
index 217c82e..900fca0 100644
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
