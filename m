Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaHEAqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 20:46:35 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:30598 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752583AbaHEAqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 20:46:34 -0400
X-IronPort-AV: E=Sophos;i="5.04,265,1406563200"; 
   d="scan'208";a="34178920"
Message-ID: <53E029BB.2010200@cn.fujitsu.com>
Date: Tue, 5 Aug 2014 08:47:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, <mingo@kernel.org>,
        <dipankar@in.ibm.com>, <akpm@linux-foundation.org>,
        <mathieu.desnoyers@efficios.com>, <josh@joshtriplett.org>,
        <tglx@linutronix.de>, <rostedt@goodmis.org>, <dhowells@redhat.com>,
        <edumazet@google.com>, <dvhart@linux.intel.com>, <fweisbec@gmail.com>,
        <oleg@redhat.com>, <bobby.prani@gmail.com>
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com> <53DEE1CD.4000705@cn.fujitsu.com> <20140804074620.GH9918@twins.programming.kicks-ass.net> <53DF41ED.2020508@cn.fujitsu.com> <20140804115043.GA31903@linux.vnet.ibm.com> <20140804122515.GR19379@twins.programming.kicks-ass.net> <20140804145648.GE3588@twins.programming.kicks-ass.net>
In-Reply-To: <20140804145648.GE3588@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 10:56 PM, Peter Zijlstra wrote:
> On Mon, Aug 04, 2014 at 02:25:15PM +0200, Peter Zijlstra wrote:
>> On Mon, Aug 04, 2014 at 04:50:44AM -0700, Paul E. McKenney wrote:
>>> OK, I will bite...
>>>
>>> What kinds of tasks are on a runqueue, but neither ->on_cpu nor
>>> PREEMPT_ACTIVE?
>>
>> Userspace tasks, they don't necessarily get PREEMPT_ACTIVE when
>> preempted. Now obviously you're not _that_ interested in userspace tasks
>> for this, so that might be ok.
>>
>> But the main point was, you cannot use ->on_cpu or PREEMPT_ACTIVE
>> without holding rq->lock.
> 
> Hmm, maybe you can, we have the context switch in between setting
> ->on_cpu and clearing PREEMPT_ACTIVE and vice-versa.
> 
> The context switch (obviously) provides a full barrier, so we might be
> able to -- with careful consideration -- read these two separate values
> and construct something usable from them.
> 
> Something like:
> 
> 	task_preempt_count(tsk) & PREEMPT_ACTIVE
	the @tsk is running on_cpu, the above result is false.
> 	smp_rmb();
> 	tsk->on_cpu
	now the @tsk is preempted, the above result also is false.

	so it is useless if we fetch the preempt_count and on_cpu in two separated
instructions.  Maybe it would work if we also take tsk->nivcsw in consideration.
(I just noticed that tsk->n[i]vcsw are the version numbers for the tsk->on_cpu)

bool task_on_cpu_or_preempted(tsk)
{
	unsigned long saved_nivcsw;

	saved_nivcsw = task->nivcsw;
	if (tsk->on_cpu)
		return true;

	smp_rmb();

	if (task_preempt_count(tsk) & PREEMPT_ACTIVE)
		return true;

	smp_rmb();

	if (tsk->on_cpu || task->nivcsw != saved_nivcsw)
		return true;

	return false;
}

> 
> And because we set PREEMPT_ACTIVE before clearing on_cpu, this should
> race the right way (err towards the inclusive side).
> 
> Obviously that wants a big fat comment...

