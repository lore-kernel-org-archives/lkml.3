Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab3K1Lit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:38:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979Ab3K1Leg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:34:36 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 18/29] tools lib traceevent: Use pevent_print_func_field in hrtimer_start handler
Date: Thu, 28 Nov 2013 12:33:17 +0100
Message-Id: <1385638408-23519-19-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pevent_print_func_field function encompasses all the
functionality used in the hrtimer_start handler. Changing
the handler to use this function.

This also unifies the function field output with the
hrtimer_expire_entry handler.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
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
 tools/lib/traceevent/plugin_hrtimer.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
index e41d4cf..0b0ebf3 100644
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
1.8.3.1

