Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaKQAm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 19:42:29 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46472 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaKQAm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:42:27 -0500
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: rostedt@goodmis.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, seungho1.park@lge.com, jolsa@redhat.com,
        Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v3 3/3] tracing: add additional marks to signal very large delay
Date: Mon, 17 Nov 2014 09:41:58 +0900
Message-Id: <1416184918-10471-4-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416184918-10471-1-git-send-email-byungchul.park@lge.com>
References: <1416184918-10471-1-git-send-email-byungchul.park@lge.com>
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
 kernel/trace/trace_output.c    |   20 +++++++++++++++-----
 2 files changed, 20 insertions(+), 8 deletions(-)

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
index c6977d5..73db60b 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -124,7 +124,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 
 	if (ret == (const char *)(trace_seq_buffer_ptr(p)))
 		trace_seq_printf(p, "0x%lx", val);
-		
+
 	trace_seq_putc(p, 0);
 
 	return ret;
@@ -471,7 +471,18 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 	return trace_print_lat_fmt(s, entry);
 }
 
-static unsigned long preempt_mark_thresh_us = 100;
+static const struct trace_mark mark[] = {
+	MARK(0ULL		, ' '), /* 0 usecs */
+	MARK(10000ULL		, '+'), /* 10 usecs */
+	MARK(100000ULL		, '!'), /* 100 usecs */
+	MARK(1000000ULL		, '#'), /* 1000 usecs */
+	MARK(1000000000ULL	, '$'), /* 1 sec */
+};
+
+static inline char find_trace_mark(unsigned long long d)
+{
+	return trace_duration_mark(d, mark, ARRAY_SIZE(mark));
+}
 
 static int
 lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
@@ -506,8 +517,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
 		return trace_seq_printf(
 				s, " %4lldus%c: ",
 				abs_ts,
-				rel_ts > preempt_mark_thresh_us ? '!' :
-				  rel_ts > 1 ? '+' : ' ');
+				find_trace_mark(rel_ts * NSEC_PER_USEC));
 	} else { /* !verbose && !in_ns */
 		return trace_seq_printf(s, " %4lld: ", abs_ts);
 	}
@@ -692,7 +702,7 @@ int register_ftrace_event(struct trace_event *event)
 				goto out;
 
 		} else {
-			
+
 			event->type = next_event_type++;
 			list = &ftrace_event_list;
 		}
-- 
1.7.9.5

