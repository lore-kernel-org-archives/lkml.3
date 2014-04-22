Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbaDVUCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:02:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbaDVUCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:02:33 -0400
Date: Tue, 22 Apr 2014 20:18:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: bsegall@google.com
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] sched/core: Skip wakeup when task is already running.
Message-ID: <20140422181820.GT26782@laptop.programming.kicks-ass.net>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
 <51238bf1648b1f4c66d3547a49cf949d1679d068.1397562542.git.yangds.fnst@cn.fujitsu.com>
 <20140415135326.GV11096@twins.programming.kicks-ass.net>
 <534E59FC.2090001@cn.fujitsu.com>
 <535658DB.2090801@cn.fujitsu.com>
 <xm26sip55lyb.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm26sip55lyb.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:10:52AM -0700, bsegall@google.com wrote:
> This is all expected behavior, and the somewhat less than useful trace
> events are expected. A task setting p->state to TASK_RUNNING without
> locks is fine if and only p == current. The standard deschedule loop is
> basically:
> 
> while (1) {
>   set_current_state(TASK_(UN)INTERRUPTIBLE);
>   if (should_still_sleep)
>     schedule();
> }
> set_current_state(TASK_RUNNING);
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

Ah, you're saying that a second task could try a spurious wakeup between
set_current_state() and schedule(). Yes, that'll trigger this indeed.


