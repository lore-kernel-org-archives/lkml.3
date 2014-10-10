Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaJJJ4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:56:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaJJJ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:56:37 -0400
Date: Fri, 10 Oct 2014 11:56:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sched: fix the PREEMPT_ACTIVE check in
 __trace_sched_switch_state()
Message-ID: <20141010095633.GD14547@worktop.programming.kicks-ass.net>
References: <20141007195046.GA28002@redhat.com>
 <20141007195108.GB28002@redhat.com>
 <20141010095452.GH10832@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010095452.GH10832@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:54:52AM +0200, Peter Zijlstra wrote:
> On Tue, Oct 07, 2014 at 09:51:08PM +0200, Oleg Nesterov wrote:
> > task_preempt_count() has nothing to do with the actual preempt counter,
> > thread_info->saved_preempt_count is only valid right after switch_to().
> > 
> > __trace_sched_switch_state() can use preempt_count(), prev is still the
> > current task when trace_sched_switch() is called.
> 
> This is true, but the paranoid in me would like a BUG_ON(p != current)
> right along with that to make sure we don't accidentally change this.
> 
> But yes, its good to get rid of task_preempt_count(), its horrible.

Like so then?

---
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -97,16 +97,19 @@ static inline long __trace_sched_switch_
 	long state = p->state;
 
 #ifdef CONFIG_PREEMPT
+#ifdef CONFIG_SCHED_DEBUG
+	BUG_ON(p != current);
+#endif /* CONFIG_SCHED_DEBUG */
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_preempt_count(p) & PREEMPT_ACTIVE)
+	if (preempt_count() & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
-#endif
+#endif /* CONFIG_PREEMPT */
 
 	return state;
 }
-#endif
+#endif /* CREATE_TRACE_POINTS */
 
 /*
  * Tracepoint for task switches, performed by the scheduler:
