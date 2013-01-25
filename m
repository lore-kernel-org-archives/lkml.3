Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3AYCr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:47:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab3AYCrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:47:49 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zGco2qFrVVAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Sc5F7dUzuZoA:10 a=s_ri0LwvSNLNg172CZIA:9 a=PUjeQqilurYA:10 a=vMgOWTww3sdia1fe:21 a=3utvSKMhIOKDJAG0:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359082066.21576.198.camel@gandalf.local.home>
Subject: Re: [PATCH] sched/rt: Don't pull tasks of throttled rt_rq in
 pre_schedule_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 24 Jan 2013 21:47:46 -0500
In-Reply-To: <1286111356423652@web16f.yandex.ru>
References: <1286111356423652@web16f.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply.

On Tue, 2012-12-25 at 12:20 +0400, Kirill Tkhai wrote:
> The patch aims not to pull tasks of throttled rt_rqs
> in pre_schedule_rt() because thay are not able to be
> picked in pick_next_task_rt().
> 
> There are three places where pull_rt_task() is used:
> 
> 1)pre_schedule_rt()
> If we pull a task of a throttled rt_rq it won't be picked
> by pick_next_task_rt(), because throttled tasks are dequeued
> by sched_rt_runtime_exceeded(). So this action is unnecessary.
> 
> 2)prio_changed_rt()
> A pulled task of higher priority leads to reschedule of current
> rq's task. The schedule() will occur with the first hw interrupt
> so there is possibility the throttled rt_rq will unthrottle and
> it will be queued during this time.
> (In case of preemptable kernel schedule() occurs during
> preempt_enable() in call of __task_rq_unlock(). But its lock is
> unlocked so there is no guarantee the rt_rq won't be queued).
> 
> 3)switched_from_rt()
> The same as prio_changed_rt().

These are pretty much hot paths. They are done rather commonly. My
concern is that we are adding overhead here that can be done in a much
less common path.

I'm wondering if we couldn't use the pushable_task list for finding the
next highest rt task. That may even speed up the fast path if we do so.

Then, when an rq gets throttled, which shouldn't be often, we can remove
all the tasks from the pushable_task list, and add them back when the rq
is comes back up.

Then, by just using the pushable_task list, we can achieve this goal.

We have to look to see what prevents us from using that list.

-- Steve


