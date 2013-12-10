Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3LJJWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:22:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3LJJWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:22:09 -0500
Date: Tue, 10 Dec 2013 01:21:38 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-39956e78010645ee9d121e6a6eb6d9892e3fc92e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386076182-14484-26-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-26-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Several cleanups for function plugin
Git-Commit-ID: 39956e78010645ee9d121e6a6eb6d9892e3fc92e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:21:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39956e78010645ee9d121e6a6eb6d9892e3fc92e
Gitweb:     http://git.kernel.org/tip/39956e78010645ee9d121e6a6eb6d9892e3fc92e
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 3 Dec 2013 14:09:39 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:37:24 -0300

tools lib traceevent: Several cleanups for function plugin

Several cleanups suggested by Namhyung:

  * Remove index field from struct func_stack as it's not needed.

  * Rename get_index into add_and_get_index.

  * Use '%*X' format string capability instead of the loop

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-26-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/plugin_function.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 8deb22e..87acf9c 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -25,7 +25,6 @@
 #include "event-utils.h"
 
 static struct func_stack {
-	int index;
 	int size;
 	char **stack;
 } *fstack;
@@ -57,7 +56,7 @@ static void add_child(struct func_stack *stack, const char *child, int pos)
 	stack->stack[pos] = strdup(child);
 }
 
-static int get_index(const char *parent, const char *child, int cpu)
+static int add_and_get_index(const char *parent, const char *child, int cpu)
 {
 	int i;
 
@@ -97,7 +96,7 @@ static int function_handler(struct trace_seq *s, struct pevent_record *record,
 	unsigned long long pfunction;
 	const char *func;
 	const char *parent;
-	int i, index;
+	int index;
 
 	if (pevent_get_field_val(s, event, "ip", record, &function, 1))
 		return trace_seq_putc(s, '!');
@@ -109,10 +108,9 @@ static int function_handler(struct trace_seq *s, struct pevent_record *record,
 
 	parent = pevent_find_function(pevent, pfunction);
 
-	index = get_index(parent, func, record->cpu);
+	index = add_and_get_index(parent, func, record->cpu);
 
-	for (i = 0; i < index; i++)
-		trace_seq_printf(s, "   ");
+	trace_seq_printf(s, "%*s", index*3, "");
 
 	if (func)
 		trace_seq_printf(s, "%s", func);
