Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbbANSDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:03:06 -0500
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:44862 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751085AbbANSDE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:03:04 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::,RULES_HIT:2:41:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1513:1515:1516:1518:1521:1535:1593:1594:1605:1606:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2859:2898:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4117:4321:5007:6119:6261:7576:7875:7903:8660:9025:9391:9545:9592:9707:10004:10848:10913:10967:11026:11232:11473:11658:11914:12043:12262:12291:12294:12296:12438:12517:12519:12555:12679:12683:12740:12783:13148:13221:13229:13230:13972:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: copy14_54a81e63f8e5d
X-Filterd-Recvd-Size: 6718
Date: Wed, 14 Jan 2015 13:03:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@osdl.org>,
        tglx@linutronix.de, mathieu.desnoyers@efficios.com,
        xiakaixu@huawei.com
Subject: Re: [PATCH] tracing: Allow raw_syscall tracepoints to work from
 boot
Message-ID: <20150114130300.75c5d2ce@gandalf.local.home>
In-Reply-To: <1421188517-18312-1-git-send-email-mpe@ellerman.id.au>
References: <1421188517-18312-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 09:35:17 +1100
Michael Ellerman <mpe@ellerman.id.au> wrote:

> In commit 5f893b2639b2 "tracing: Move enabling tracepoints to just after
> rcu_init()", tracing was enabled earlier in boot.
> 
> This broke tracing of the raw_syscall tracepoints from boot using the
> trace_event kernel parameter.
> 
> When the registration function for the raw_syscall tracepoints runs, it
> iterates over all tasks setting TIF_SYSCALL_TRACEPOINT. However now that
> this happens earlier in boot, the loop has no effect because there are
> no tasks in existence other than init_task, which is skipped by the
> for_each_process_thread() macro.
> 
> We can fix it by explicitly setting TIF_SYSCALL_TRACEPOINT for the
> init_task. That way when pid 1 is cloned from init_task it will inherit
> TIF_SYSCALL_TRACEPOINT.
> 
> Fixes: 5f893b2639b2 ("tracing: Move enabling tracepoints to just after rcu_init()")

I don't like setting the swap task flag for syscall tracing, as nothing
will unset it.


> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  kernel/tracepoint.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> It feels a bit naughty to be whacking init_task like this, but it also
> seems like the right fix?

No, I tried the following instead.

> 
> Should we also clear it in the unregfunc? I can't see how that would
> ever be needed in practice?

It just seems hacky to set swapper in the first place.

Try my patch and let me know if it works for you?

-- Steve

>From aae3b6410d536d65204cce7654887095dc41e1cf Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Wed, 14 Jan 2015 12:53:45 -0500
Subject: [PATCH] tracing: Fix enabling of syscall events on the command line

Commit 5f893b2639b2 "tracing: Move enabling tracepoints to just after
rcu_init()" broke the enabling of system call events from the command
line. The reason was that the enabling of command line trace events
was moved before PID 1 started, and the syscall tracepoints require
that all tasks have the TIF_SYSCALL_TRACEPOINT flag set. But the
swapper task (pid 0) is not part of that. Since the swapper task is the
only task that is running at this early in boot, no task gets the
flag set, and the tracepoint never gets reached.

Instead of setting the swapper task flag (there should be no reason to
do that), re-enabled trace events again after the init thread (PID 1)
has been started. It requires disabling all command line events and
re-enabling them, as just enabling them again will not reset the logic
to set the TIF_SYSCALL_TRACEPOINT flag, as the syscall tracepoint will
be fooled into thinking that it was already set, and wont try setting
it again. For this reason, we must first disable it and re-enable it.

Link: http://lkml.kernel.org/r/1421188517-18312-1-git-send-email-mpe@ellerman.id.au

Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 69 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 366a78a3e61e..b03a0ea77b99 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2429,12 +2429,39 @@ static __init int event_trace_memsetup(void)
 	return 0;
 }
 
+static __init void
+early_enable_events(struct trace_array *tr, bool disable_first)
+{
+	char *buf = bootup_event_buf;
+	char *token;
+	int ret;
+
+	while (true) {
+		token = strsep(&buf, ",");
+
+		if (!token)
+			break;
+		if (!*token)
+			continue;
+
+		/* Restarting syscalls requires that we stop them first */
+		if (disable_first)
+			ftrace_set_clr_event(tr, token, 0);
+
+		ret = ftrace_set_clr_event(tr, token, 1);
+		if (ret)
+			pr_warn("Failed to enable trace event: %s\n", token);
+
+		/* Put back the comma to allow this to be called again */
+		if (buf)
+			*(buf - 1) = ',';
+	}
+}
+
 static __init int event_trace_enable(void)
 {
 	struct trace_array *tr = top_trace_array();
 	struct ftrace_event_call **iter, *call;
-	char *buf = bootup_event_buf;
-	char *token;
 	int ret;
 
 	if (!tr)
@@ -2456,18 +2483,7 @@ static __init int event_trace_enable(void)
 	 */
 	__trace_early_add_events(tr);
 
-	while (true) {
-		token = strsep(&buf, ",");
-
-		if (!token)
-			break;
-		if (!*token)
-			continue;
-
-		ret = ftrace_set_clr_event(tr, token, 1);
-		if (ret)
-			pr_warn("Failed to enable trace event: %s\n", token);
-	}
+	early_enable_events(tr, false);
 
 	trace_printk_start_comm();
 
@@ -2478,6 +2494,31 @@ static __init int event_trace_enable(void)
 	return 0;
 }
 
+/*
+ * event_trace_enable() is called from trace_event_init() first to
+ * initialize events and perhaps start any events that are on the
+ * command line. Unfortunately, there are some events that will not
+ * start this early, like the system call tracepoints that need
+ * to set the TIF_SYSCALL_TRACEPOINT flag of pid 1. But event_trace_enable()
+ * is called before pid 1 starts, and this flag is never set, making
+ * the syscall tracepoint never get reached, but the event is enabled
+ * regardless (and not doing anything).
+ */
+static __init int event_trace_enable_again(void)
+{
+	struct trace_array *tr;
+
+	tr = top_trace_array();
+	if (!tr)
+		return -ENODEV;
+
+	early_enable_events(tr, true);
+
+	return 0;
+}
+
+early_initcall(event_trace_enable_again);
+
 static __init int event_trace_init(void)
 {
 	struct trace_array *tr;
-- 
1.8.1.4

