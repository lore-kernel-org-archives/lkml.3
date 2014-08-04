Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaHDAgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:36:15 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:48820 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751871AbaHDAgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:36:14 -0400
X-IronPort-AV: E=Sophos;i="5.04,258,1406563200"; 
   d="scan'208";a="34121744"
Message-ID: <53DED5D1.6030504@cn.fujitsu.com>
Date: Mon, 4 Aug 2014 08:37:37 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: Oleg Nesterov <oleg@redhat.com>, <linux-kernel@vger.kernel.org>,
        <mingo@kernel.org>, <dipankar@in.ibm.com>, <akpm@linux-foundation.org>,
        <mathieu.desnoyers@efficios.com>, <josh@joshtriplett.org>,
        <tglx@linutronix.de>, <peterz@infradead.org>, <rostedt@goodmis.org>,
        <dhowells@redhat.com>, <edumazet@google.com>, <dvhart@linux.intel.com>,
        <fweisbec@gmail.com>, <bobby.prani@gmail.com>
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com> <20140802145616.GA18195@redhat.com> <20140802225757.GB8101@linux.vnet.ibm.com> <20140803133318.GB671@redhat.com> <20140803220535.GH8101@linux.vnet.ibm.com>
In-Reply-To: <20140803220535.GH8101@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 06:05 AM, Paul E. McKenney wrote:
> On Sun, Aug 03, 2014 at 03:33:18PM +0200, Oleg Nesterov wrote:
>> On 08/02, Paul E. McKenney wrote:
>>>
>>> On Sat, Aug 02, 2014 at 04:56:16PM +0200, Oleg Nesterov wrote:
>>>> On 07/31, Paul E. McKenney wrote:
>>>>>
>>>>> +		rcu_read_lock();
>>>>> +		for_each_process_thread(g, t) {
>>>>> +			if (t != current && ACCESS_ONCE(t->on_rq) &&
>>>>> +			    !is_idle_task(t)) {
>>>>
>>>> I didn't notice this check before, but it is not needed. for_each_process()
>>>> can see the idle threads, there are not on process/thread lists.
>>     ^^^^^^^
>>
>> argh, I mean't "can't see" of course...
>>
>>> Good to know.  Any other important tasks I am missing?
>>
>> Nothing else.
> 
> Whew!  ;-)
> 
>>> I am guessing that I need to do something like this:
>>>
>>> 	for_each_process(g) {
>>> 		/* Do build step. */
>>> 		for_each_thread(g, t) {
>>> 			if (g == t)
>>> 				continue;
>>> 			/* Do build step. */
>>> 		}
>>> 	}
>>
>> Sorry, I don't understand... This is equivalent to
>>
>> 	for_each_process_thread(g, t) {
>> 		/* Do build step. */
>> 	}
> 
> OK, got it.
> 
>>> Your point about exiting tasks I get, and I believe I can solve it.
>>> I am hoping that the above sort of construction takes care of the
>>> idle threads.
>>
>> It is simple to find the idle threads, just
>>
>> 	for_each_cpu(cpu) {
>> 		do_something(cpu_rq(cpu)->idle);
>> 	}
>>
>> but it is not clear to me what else you need to do with the idle threads.
>> Probably not too much, they mostly run under preempt_disable().
> 
> OK, looks easy enough.  And yes, one good question is what, if anything,
> we need to do with the idle threads.
> 
>>> I might also need to do something to handle changes in
>>> process/thread hierarchy -- but hopefully without having to read-acquire
>>> the task-list lock.
>>
>> It seems that you need another global list, a task should be visible on that
>> list until exit_rcu().
> 
> As in create another global list that all tasks are added to when created
> and then remved from when they exit?

An alternative solution:
srcu_read_lock() before exit_notify(), srcu_read_unlock() after the last preempt_disable()
in the do_exit, and synchronize_srcu() in rcu_tasks_kthread().




