Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaGGRCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbaGGRCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:02:02 -0400
Date: Mon, 7 Jul 2014 19:00:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf stat: events inheritance can break task targets
Message-ID: <20140707170040.GB2070@krava.redhat.com>
References: <874myt86ju.wl%yarygin@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874myt86ju.wl%yarygin@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 08:41:57PM +0400, Alexander Yarygin wrote:

SNIP

> ^C
> 
> When perf is running, every invoke of pthread_create() returns -EPERM.
> 
> On the kernel side, copy_process() creates a task, scheduled it,
> than perf_event_init_task() (kernel/events/core.c) returns an error,
> and the kernel cleans task's resources.
> 
> It looks like child process doesn't have access to trace events,
> so perf_trace_event_perm() (kernel/trace/trace_event_perf.c)
> returns -EPERM:
> 
> static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
> 				 struct perf_event *p_event)
> {
> ...
>     /*
>      * ...otherwise raw tracepoint data can be a severe data leak,
>      * only allow root to have these.
>      */
>     if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
>         return -EPERM;
> ...
> }

right, so normaly it's done the check is done in current context
via syscall and the current task is the tracer

while in inheriting we are checking the tracee here,
we want to check the owner instead like in attached
patch.. totaly untested, just to ilustrate the point

we might have same issue for other event types

jirka


---
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 5d12bb4..b44184b 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -24,6 +24,9 @@ static int	total_ref_count;
 static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 				 struct perf_event *p_event)
 {
+	struct task_struct owner = p_event->parent ? p_event->parent->owner :
+						     p_event->owner;
+
 	if (tp_event->perf_perm) {
 		int ret = tp_event->perf_perm(tp_event, p_event);
 		if (ret)
@@ -32,7 +35,7 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event)) {
-		if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_tracepoint_raw() && !has_capability(owner, CAP_SYS_ADMIN))
 			return -EPERM;
 
 		/*
@@ -65,7 +68,7 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 	 * ...otherwise raw tracepoint data can be a severe data leak,
 	 * only allow root to have these.
 	 */
-	if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
+	if (perf_paranoid_tracepoint_raw() && !has_capability(owner, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	return 0;
