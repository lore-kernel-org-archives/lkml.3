Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab3LDUHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:07:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59412 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933314Ab3LDUHW (ORCPT
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
Subject: [PATCH 35/38] tools lib traceevent: Use pevent_print_func_field in hrtimer_start handler
Date: Wed,  4 Dec 2013 17:06:59 -0300
Message-Id: <1386187622-2928-36-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The pevent_print_func_field function encompasses all the functionality
used in the hrtimer_start handler. Change the handler to use this
function.

This also unifies the function field output with the
hrtimer_expire_entry handler.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-25-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/plugin_hrtimer.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
index e41d4cf9344f..0b0ebf30aa44 100644
--- a/tools/lib/traceevent/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -48,10 +48,6 @@ static int timer_start_handler(struct trace_seq *s,
 			       struct pevent_record *record,
 			       struct event_format *event, void *context)
 {
-	struct pevent *pevent = event->pevent;
-	struct format_field *fn = pevent_find_field(event, "function");
-	void *data = record->data;
-
 	trace_seq_printf(s, "hrtimer=");
 
 	if (pevent_print_num_field(s, "0x%llx", event, "timer",
@@ -59,19 +55,8 @@ static int timer_start_handler(struct trace_seq *s,
 		pevent_print_num_field(s, "0x%llx", event, "hrtimer",
 				       record, 1);
 
-	if (!fn) {
-		trace_seq_printf(s, " function=MISSING");
-	} else {
-		unsigned long long function;
-		const char *func;
-
-		if (pevent_read_number_field(fn, data, &function))
-			trace_seq_printf(s, " function=INVALID");
-
-		func = pevent_find_function(pevent, function);
-
-		trace_seq_printf(s, " function=%s", func);
-	}
+	pevent_print_func_field(s, " function=%s", event, "function",
+				record, 0);
 
 	trace_seq_printf(s, " expires=");
 	pevent_print_num_field(s, "%llu", event, "expires", record, 1);
-- 
1.8.1.4

