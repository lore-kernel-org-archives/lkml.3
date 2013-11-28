Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029Ab3K1Len (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:34:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758594Ab3K1Leh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:34:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 19/29] tools lib traceevent: Several cleanups for function plugin
Date: Thu, 28 Nov 2013 12:33:18 +0100
Message-Id: <1385638408-23519-20-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several cleanups suggested by Namhyung:
  * removing index field from struct func_stack as
    it's not needed
  * renaming get_index into add_and_get_index
  * using '%*X' format string capability instead of
    the loop

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
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
-- 
1.8.3.1

