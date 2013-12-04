Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab3LDUH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:07:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59408 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312Ab3LDUHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 36/38] tools lib traceevent: Several cleanups for function plugin
Date: Wed,  4 Dec 2013 17:07:00 -0300
Message-Id: <1386187622-2928-37-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
index 8deb22e69361..87acf9c77948 100644
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
-- 
1.8.1.4

