Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbaLKOSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:18:00 -0500
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:43697 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754498AbaLKOR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:17:58 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:5007:6261:7875:9040:10004:10400:10429:10430:10431:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12663:12740:13069:13161:13229:13255:13311:13357:14096:14097:19903:19997:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sky64_45745b3d5b619
X-Filterd-Recvd-Size: 2778
Date: Thu, 11 Dec 2014 09:17:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] tracing/sched: Check preempt_count() for current when
 reading task->state
Message-ID: <20141211091747.6cecf1ef@gandalf.local.home>
In-Reply-To: <20141211123121.GB18538@gmail.com>
References: <20141210174428.3cb7542a@gandalf.local.home>
	<20141211063811.GD5059@gmail.com>
	<20141211063712.5cf4d240@gandalf.local.home>
	<20141211123121.GB18538@gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014 13:31:21 +0100
Ingo Molnar <mingo@kernel.org> wrote:

 
> > What overhead are you worried about? Note, this is in the 
> > schedule tracepoint and does not affect the scheduler itself 
> > (as long as the tracepoint is not enabled).
> 
> Scheduler tracepoints are pretty popular, so I'm worried about 
> their complexity when they are activated.

Understood.

> 
> > I'm also thinking that as long as "prev" is always guaranteed 
> > to be "current" we can remove the check and just use 
> > preempt_count() always. But I'm worried that we can't 
> > guaranteed that.
> 
> You could add a WARN_ON_ONCE() or so to double check that 
> assumption?

I actually thought about that, but that gives us the same overhead as
the branch we want to remove.

But if you are going for simpler, then that would make sense.

> 
> > What other ideas do you have? Because wrong data is worse than 
> > the overhead of the above code. If Thomas taught me anything, 
> > it's that!
> 
> My idea is to have simpler, yet correct code. And ponies!


So something like this instead?

-- Steve


diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 0a68d5ae584e..782018b135ff 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -97,10 +97,12 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 	long state = p->state;
 
 #ifdef CONFIG_PREEMPT
+	WARN_ON_ONCE(p != current);
+
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_preempt_count(p) & PREEMPT_ACTIVE)
+	if (preempt_count() & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
 #endif
 

