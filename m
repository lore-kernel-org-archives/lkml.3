Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3LJJWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:22:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44610 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3LJJWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:22:05 -0500
Date: Tue, 10 Dec 2013 01:21:28 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-b32cea650a16092a654baa2095c78fa917bad4da@git.kernel.org>
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
In-Reply-To: <1386076182-14484-25-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-25-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Use pevent_print_func_field in hrtimer_start handler
Git-Commit-ID: b32cea650a16092a654baa2095c78fa917bad4da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:21:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b32cea650a16092a654baa2095c78fa917bad4da
Gitweb:     http://git.kernel.org/tip/b32cea650a16092a654baa2095c78fa917bad4da
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 3 Dec 2013 14:09:38 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:36:50 -0300

tools lib traceevent: Use pevent_print_func_field in hrtimer_start handler

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
