Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3KKRxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:53:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46639 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab3KKRxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:53:00 -0500
Date: Mon, 11 Nov 2013 09:52:24 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-e5137b50a0640009fd63a3e65c14bc6e1be8796a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ying.huang@intel.com,
        yuanhan.liu@linux.intel.com, rostedt@goodmis.org, tglx@linutronix.de,
        fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ying.huang@intel.com,
        yuanhan.liu@linux.intel.com, rostedt@goodmis.org, tglx@linutronix.de,
        fengguang.wu@intel.com
In-Reply-To: <20131004152826.GP3081@twins.programming.kicks-ass.net>
References: <20131004152826.GP3081@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
Git-Commit-ID: e5137b50a0640009fd63a3e65c14bc6e1be8796a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 11 Nov 2013 09:52:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5137b50a0640009fd63a3e65c14bc6e1be8796a
Gitweb:     http://git.kernel.org/tip/e5137b50a0640009fd63a3e65c14bc6e1be8796a
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 4 Oct 2013 17:28:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Nov 2013 12:43:39 +0100

ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED

Since the introduction of PREEMPT_NEED_RESCHED in:

  f27dde8deef3 ("sched: Add NEED_RESCHED to the preempt_count")

we need to be able to look at both TIF_NEED_RESCHED and
PREEMPT_NEED_RESCHED to understand the full preemption behaviour.

Add it to the trace output.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Link: http://lkml.kernel.org/r/20131004152826.GP3081@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/trace/ftrace.txt |  6 +++++-
 kernel/trace/trace.c           |  3 ++-
 kernel/trace/trace.h           |  1 +
 kernel/trace/trace_output.c    | 19 +++++++++++++++++--
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index ea2d35d..bd36598 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -655,7 +655,11 @@ explains which is which.
 		  read the irq flags variable, an 'X' will always
 		  be printed here.
 
-  need-resched: 'N' task need_resched is set, '.' otherwise.
+  need-resched:
+	'N' both TIF_NEED_RESCHED and PREEMPT_NEED_RESCHED is set,
+	'n' only TIF_NEED_RESCHED is set,
+	'p' only PREEMPT_NEED_RESCHED is set,
+	'.' otherwise.
 
   hardirq/softirq:
 	'H' - hard irq occurred inside a softirq.
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7974ba2..d9fea7d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1509,7 +1509,8 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 #endif
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
-		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
+		(tif_need_resched() ? TRACE_FLAG_NEED_RESCHED : 0) |
+		(test_preempt_need_resched() ? TRACE_FLAG_PREEMPT_RESCHED : 0);
 }
 EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 10c86fb..73d08aa 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -124,6 +124,7 @@ enum trace_flag_type {
 	TRACE_FLAG_NEED_RESCHED		= 0x04,
 	TRACE_FLAG_HARDIRQ		= 0x08,
 	TRACE_FLAG_SOFTIRQ		= 0x10,
+	TRACE_FLAG_PREEMPT_RESCHED	= 0x20,
 };
 
 #define TRACE_BUF_SIZE		1024
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 34e7cba..ed32284 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -618,8 +618,23 @@ int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 		(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
 		(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' :
 		'.';
-	need_resched =
-		(entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.';
+
+	switch (entry->flags & (TRACE_FLAG_NEED_RESCHED |
+				TRACE_FLAG_PREEMPT_RESCHED)) {
+	case TRACE_FLAG_NEED_RESCHED | TRACE_FLAG_PREEMPT_RESCHED:
+		need_resched = 'N';
+		break;
+	case TRACE_FLAG_NEED_RESCHED:
+		need_resched = 'n';
+		break;
+	case TRACE_FLAG_PREEMPT_RESCHED:
+		need_resched = 'p';
+		break;
+	default:
+		need_resched = '.';
+		break;
+	}
+
 	hardsoft_irq =
 		(hardirq && softirq) ? 'H' :
 		hardirq ? 'h' :
