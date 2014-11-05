Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaKEHTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:19:03 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54844 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaKEHSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:18:54 -0500
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: rostedt@goodmis.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, seungho1.park@lge.com, jolsa@redhat.com,
        Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v2 3/3] tracing: add additional marks to signal very large delay
Date: Wed,  5 Nov 2014 16:18:46 +0900
Message-Id: <1415171926-9782-4-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415171926-9782-1-git-send-email-byungchul.park@lge.com>
References: <1415171926-9782-1-git-send-email-byungchul.park@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

Currently, some tracers tracing latency print "!" or "+" just after time
to signal overhead, depending on the interval between events. Even it is
usually enough to do that, we sometimes need to be signaled for bigger
interval than 100 micro seconds.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 Documentation/trace/ftrace.txt |    8 +++++---
 kernel/trace/trace_output.c    |   15 ++++++++++-----
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index f827e2f..64efb3e 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -680,9 +680,11 @@ The above is mostly meaningful for kernel developers.
 	 needs to be fixed to be only relative to the same CPU.
 	 The marks are determined by the difference between this
 	 current trace and the next trace.
-	  '!' - greater than preempt_mark_thresh (default 100)
-	  '+' - greater than 1 microsecond
-	  ' ' - less than or equal to 1 microsecond.
+	  '$' - greater than 1 second
+	  '#' - greater than 1000 microsecond
+	  '!' - greater than 100 microsecond
+	  '+' - greater than 10 microsecond
+	  ' ' - less than or equal to 10 microsecond.
 
   The rest is the same as the 'trace' file.
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index c6977d5..e63fac3 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -124,7 +124,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 
 	if (ret == (const char *)(trace_seq_buffer_ptr(p)))
 		trace_seq_printf(p, "0x%lx", val);
-		
+
 	trace_seq_putc(p, 0);
 
 	return ret;
@@ -471,7 +471,13 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 	return trace_print_lat_fmt(s, entry);
 }
 
-static unsigned long preempt_mark_thresh_us = 100;
+DEFINE_MARK_STRUCT = {
+	DEFINE_MARK(0ULL		, ' '), /* 0 usecs */
+	DEFINE_MARK(10000ULL		, '+'), /* 10 usecs */
+	DEFINE_MARK(100000ULL		, '!'), /* 100 usecs */
+	DEFINE_MARK(1000000ULL		, '#'), /* 1000 usecs */
+	DEFINE_MARK(1000000000ULL	, '$'), /* 1 sec */
+};
 
 static int
 lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
@@ -506,8 +512,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
 		return trace_seq_printf(
 				s, " %4lldus%c: ",
 				abs_ts,
-				rel_ts > preempt_mark_thresh_us ? '!' :
-				  rel_ts > 1 ? '+' : ' ');
+				MARK(rel_ts * NSEC_PER_USEC));
 	} else { /* !verbose && !in_ns */
 		return trace_seq_printf(s, " %4lld: ", abs_ts);
 	}
@@ -692,7 +697,7 @@ int register_ftrace_event(struct trace_event *event)
 				goto out;
 
 		} else {
-			
+
 			event->type = next_event_type++;
 			list = &ftrace_event_list;
 		}
-- 
1.7.9.5

