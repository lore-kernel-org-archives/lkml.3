Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbbAIJ4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:56:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:51406 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbbAIJ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:56:07 -0500
Date: Fri, 9 Jan 2015 10:56:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vaibhav Shinde <v.bhav.shinde@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        tj@kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Preemptionirqsoff latency issue
Message-ID: <20150109095603.GB22386@worktop.programming.kicks-ass.net>
References: <CAB5gottA3D_eJsHcGwO62fJtEqMqivX2kS5D-JhHphW9ADV88A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB5gottA3D_eJsHcGwO62fJtEqMqivX2kS5D-JhHphW9ADV88A@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 02:31:35PM +0530, Vaibhav Shinde wrote:
> Hi All,
> 
> I have been checking preemption/irqs off latency with ftrace to find out
> the reason for scheduling latency for my application -
> 
> echo 0 > options/function-trace
> echo preemptirqsoff > current_tracer
> echo 1 > tracing_on
> echo 0 > tracing_max_latency
> ./a.out                          /* Running my application */
> echo 0 > tracing_on
> 
> #
> # preemptirqsoff latency trace v1.1.5 on 3.10.33-g36cc57c-dirty
> # --------------------------------------------------------------------
> # latency: 5184 us, #4/4, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:1)
> #    -----------------
> #    | task: kworker/0:3-67 (uid:0 nice:0 policy:0 rt_prio:0)
> #    -----------------
> #  => started at: __mutex_lock_slowpath
> #  => ended at:   schedule_preempt_disabled
> #
> #
> #                  _------=> CPU#
> #                 / _-----=> irqs-off
> #                | / _----=> need-resched
> #                || / _---=> hardirq/softirq
> #                ||| / _--=> preempt-depth
> #                |||| /     delay
> #  cmd     pid   ||||| time  |   caller
> #     \   /      |||||  \    |   /
> kworker/-67      0...1    1us!: __mutex_lock_slowpath
> kworker/-67      0.N.1 5183us+: schedule_preempt_disabled
> kworker/-67      0.N.1 5186us+: trace_preempt_on <-schedule_preempt_disabled
> kworker/-67      0.N.1 5223us : <stack trace>
> => sub_preempt_count
> => schedule_preempt_disabled
> => __mutex_lock_slowpath
> => mutex_lock
> 
> 
> - As per the traces, I am getting a preemption off in mutex_lock for
> 5184ms, which is really big value.
> - The mutext lock is called from my code,
> - what could be the issue that caused such a big latency ?

mutex_lock will spin wait for the owner of the lock IFF the owner is on
(another) CPU and the current CPU doesn't need to resched. And from the
trace we can see N (need_resched) is only set at the 5ms and then we
call schedule_preempt_disable() almost immediately.

If you're interested in scheduling latency you should be looking at the
delay between tasks waking up and tasks getting on the CPU. The above
few lines simply do not provide enough information.
