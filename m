Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbbAZCGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 21:06:45 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:46567 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751009AbbAZCGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 21:06:43 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56601590"
Message-ID: <54C5A184.20105@cn.fujitsu.com>
Date: Mon, 26 Jan 2015 10:08:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "davej@codemonkey.org.uk >> Dave Jones" <davej@codemonkey.org.uk>
Subject: Re: rcu, sched: WARNING: CPU: 30 PID: 23771 at kernel/rcu/tree_plugin.h:337
 rcu_read_unlock_special+0x369/0x550()
References: <20150121025754.GV9719@linux.vnet.ibm.com> <54BFC979.8040107@oracle.com> <20150122004305.GJ9719@linux.vnet.ibm.com> <54C1BFFD.9060707@oracle.com> <20150123035158.GP9719@linux.vnet.ibm.com> <54C1C7D2.906@oracle.com> <54C1C899.8000106@oracle.com> <20150123065542.GQ9719@linux.vnet.ibm.com> <20150123093644.GA11175@linux.vnet.ibm.com> <54C300DD.9070608@cn.fujitsu.com> <20150124211834.GD9719@linux.vnet.ibm.com>
In-Reply-To: <20150124211834.GD9719@linux.vnet.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2015 05:18 AM, Paul E. McKenney wrote:

> 
> Good point!  In my scenario, CPU 0 would not yet have switched away from
> Task A.  Hmmm...  Yet Sasha really does see this failure.  Will give it
> some more thought.
> 
> Any ideas?

I don't known which commit was merged from the rcu-git-tree in Sasha's test
I try to review it.

We can fallback to git-bitsect if the reviews fails.

Thanks,
Lai

> 
> 							Thanx, Paul
> 
>> Thanks,
>> Lai
>>
>>>     
>>> 6.	Once in rcu_read_unlock_special(), the fact that
>>>     	current->rcu_read_unlock_special.b.need_qs is true becomes
>>>     	apparent, so rcu_read_unlock_special() invokes rcu_preempt_qs().
>>>     	Recursively, given that we interrupted out of that same
>>>     	function in the preceding step.
>>>     
>>> 7.	Because rcu_preempt_data.passed_quiesce is now true,
>>>     	rcu_preempt_qs() does nothing, and simply returns.
>>>     
>>> 8.	Upon return to rcu_read_unlock_special(), it is noted that
>>>     	current->rcu_read_unlock_special is still nonzero (because
>>>     	the interrupted rcu_preempt_qs() had not yet gotten around
>>>     	to clearing current->rcu_read_unlock_special.b.need_qs).
>>>     
>>> 9.	Execution proceeds to the WARN_ON_ONCE(), which notes that
>>>     	we are in an interrupt handler and thus duly splats.
>>>
>>> The solution, as noted above, is to make rcu_read_unlock_special()
>>> clear out current->rcu_read_unlock_special.b.need_qs after calling
>>> rcu_preempt_qs().  The interrupted rcu_preempt_qs() will clear it again,
>>> but this is harmless.  The worst that happens is that we clobber another
>>> attempt to set this field, but this is not a problem because we just
>>> got done reporting a quiescent state.
>>>
>>> Reported-by: Sasha Levin <sasha.levin@oracle.com>
>>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>>
>>> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
>>> index 8669de884445..ec99dc16aa38 100644
>>> --- a/kernel/rcu/tree_plugin.h
>>> +++ b/kernel/rcu/tree_plugin.h
>>> @@ -322,6 +322,7 @@ void rcu_read_unlock_special(struct task_struct *t)
>>>  	special = t->rcu_read_unlock_special;
>>>  	if (special.b.need_qs) {
>>>  		rcu_preempt_qs();
>>> +		t->rcu_read_unlock_special.need_qs = false;
>>>  		if (!t->rcu_read_unlock_special.s) {
>>>  			local_irq_restore(flags);
>>>  			return;
>>>
>>> .
>>>
>>
> 
> .
> 

