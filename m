Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbaDVRxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:53:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:28969 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932927AbaDVRxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:53:42 -0400
Date: Tue, 22 Apr 2014 13:53:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: bsegall@google.com
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, <fweisbec@gmail.com>,
        <mingo@redhat.com>, <acme@ghostprotocols.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] sched/core: Skip wakeup when task is already
 running.
Message-ID: <20140422135339.55a7b799@gandalf.local.home>
In-Reply-To: <xm26sip55lyb.fsf@sword-of-the-dawn.mtv.corp.google.com>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
	<51238bf1648b1f4c66d3547a49cf949d1679d068.1397562542.git.yangds.fnst@cn.fujitsu.com>
	<20140415135326.GV11096@twins.programming.kicks-ass.net>
	<534E59FC.2090001@cn.fujitsu.com>
	<535658DB.2090801@cn.fujitsu.com>
	<xm26sip55lyb.fsf@sword-of-the-dawn.mtv.corp.google.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 10:10:52 -0700
bsegall@google.com wrote:


> This is all expected behavior, and the somewhat less than useful trace
> events are expected. A task setting p->state to TASK_RUNNING without
> locks is fine if and only p == current. The standard deschedule loop is

Sure, and if you are not current, then all you need is the rq lock of
the rq that p's CPU is for.

> basically:
> 
> while (1) {
>   set_current_state(TASK_(UN)INTERRUPTIBLE);

Yep, and set_current_state() implies a memory barrier.

>   if (should_still_sleep)
>     schedule();
> }
> set_current_state(TASK_RUNNING);

The above can use __set_current_state() as there's no races to deal
with when setting current's state to RUNNING.

> 
> Which can produce this in a race.
> 
> The only problem this causes is a wasted check_preempt_curr call in the
> racing case, and a somewhat inaccurate sched:sched_wakeup trace event.
> Note that even if you did recheck in ttwu_do_wakeup you could still race
> and get an "inaccurate" trace event. Heck, even if the ttwu is
> _necessary_ because p is currently trying to take rq->lock to
> deschedule, you won't get a matching sched_switch event, because the
> ttwu is running before schedule is.
> 
> You could sorta fix this I guess by tracking every write to p->state
> with trace events, but that would be a somewhat different change, and
> might be considered too expensive for all I know (and the trace events
> could /still/ be resolved in a different order across cpus compared to
> p->state's memory).

Yeah, let's not do that.

-- Steve

