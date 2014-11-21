Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbaKUILl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 03:11:41 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39341 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbaKUILi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:11:38 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Dave Hansen <dave@sr71.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 5/7] stacktrace: introduce snprint_stack_trace for buffer output
Date: Fri, 21 Nov 2014 17:14:04 +0900
Message-Id: <1416557646-21755-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416557646-21755-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1416557646-21755-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current stacktrace only have the function for console output.
page_owner that will be introduced in following patch needs to print
the output of stacktrace into the buffer for our own output format
so so new function, snprint_stack_trace(), is needed.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/stacktrace.h |    3 +++
 kernel/stacktrace.c        |   24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 115b570..5948c67 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -20,6 +20,8 @@ extern void save_stack_trace_tsk(struct task_struct *tsk,
 				struct stack_trace *trace);
 
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
+extern int  snprint_stack_trace(char *buf, int buf_len,
+				struct stack_trace *trace, int spaces);
 
 #ifdef CONFIG_USER_STACKTRACE_SUPPORT
 extern void save_stack_trace_user(struct stack_trace *trace);
@@ -32,6 +34,7 @@ extern void save_stack_trace_user(struct stack_trace *trace);
 # define save_stack_trace_tsk(tsk, trace)		do { } while (0)
 # define save_stack_trace_user(trace)			do { } while (0)
 # define print_stack_trace(trace, spaces)		do { } while (0)
+# define snprint_stack_trace(buf, len, trace, spaces)	do { } while (0)
 #endif
 
 #endif
diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 00fe55c..61088ff 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -25,6 +25,30 @@ void print_stack_trace(struct stack_trace *trace, int spaces)
 }
 EXPORT_SYMBOL_GPL(print_stack_trace);
 
+int snprint_stack_trace(char *buf, int buf_len, struct stack_trace *trace,
+			int spaces)
+{
+	int i, printed;
+	unsigned long ip;
+	int ret = 0;
+
+	if (WARN_ON(!trace->entries))
+		return 0;
+
+	for (i = 0; i < trace->nr_entries && buf_len; i++) {
+		ip = trace->entries[i];
+		printed = snprintf(buf, buf_len, "%*c[<%p>] %pS\n",
+				1 + spaces, ' ', (void *) ip, (void *) ip);
+
+		buf_len -= printed;
+		ret += printed;
+		buf += printed;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(snprint_stack_trace);
+
 /*
  * Architectures that do not implement save_stack_trace_tsk or
  * save_stack_trace_regs get this weak alias and a once-per-bootup warning
-- 
1.7.9.5

