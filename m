Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbbAWJPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:15:35 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:33821 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752031AbbAWJPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:15:31 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56521426"
Message-ID: <54C2117E.50601@cn.fujitsu.com>
Date: Fri, 23 Jan 2015 17:16:46 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>, Sasha Levin <sasha.levin@oracle.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "davej@codemonkey.org.uk >> Dave Jones" <davej@codemonkey.org.uk>
Subject: Re: rcu, sched: WARNING: CPU: 30 PID: 23771 at kernel/rcu/tree_plugin.h:337
 rcu_read_unlock_special+0x369/0x550()
References: <54BBC084.2030604@oracle.com> <20150118232255.GD9719@linux.vnet.ibm.com> <54BE76B9.7070907@oracle.com> <20150121025754.GV9719@linux.vnet.ibm.com> <54BFC979.8040107@oracle.com> <20150122004305.GJ9719@linux.vnet.ibm.com> <54C1BFFD.9060707@oracle.com> <20150123035158.GP9719@linux.vnet.ibm.com> <54C1C7D2.906@oracle.com> <54C1C899.8000106@oracle.com> <20150123065542.GQ9719@linux.vnet.ibm.com>
In-Reply-To: <20150123065542.GQ9719@linux.vnet.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 02:55 PM, Paul E. McKenney wrote:
> On Thu, Jan 22, 2015 at 11:05:45PM -0500, Sasha Levin wrote:
>> On 01/22/2015 11:02 PM, Sasha Levin wrote:
>>> On 01/22/2015 10:51 PM, Paul E. McKenney wrote:
>>>> On Thu, Jan 22, 2015 at 10:29:01PM -0500, Sasha Levin wrote:
>>>>>> On 01/21/2015 07:43 PM, Paul E. McKenney wrote:
>>>>>>>> On Wed, Jan 21, 2015 at 10:44:57AM -0500, Sasha Levin wrote:
>>>>>>>>>> On 01/20/2015 09:57 PM, Paul E. McKenney wrote:
>>>>>>>>>>>>>>>> So RCU believes that an RCU read-side critical section that ended within
>>>>>>>>>>>>>>>>>>>> an interrupt handler (in this case, an hrtimer) somehow got preempted.
>>>>>>>>>>>>>>>>>>>> Which is not supposed to happen.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> Do you have CONFIG_PROVE_RCU enabled?  If not, could you please enable it
>>>>>>>>>>>>>>>>>>>> and retry?
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> I did have CONFIG_PROVE_RCU, and didn't see anything else besides what I pasted here.
>>>>>>>>>>>> OK, fair enough.  I do have a stack of RCU CPU stall-warning changes on
>>>>>>>>>>>> their way in, please see v3.19-rc1..630181c4a915 in -rcu, which is at:
>>>>>>>>>>>>
>>>>>>>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
>>>>>>>>>>>>
>>>>>>>>>>>> These handle the problems that Dave Jones, yourself, and a few others
>>>>>>>>>>>> located this past December.  Could you please give them a spin?
>>>>>>>>>>
>>>>>>>>>> They seem to be a part of -next already, so this testing already includes them.
>>>>>>>>>>
>>>>>>>>>> I seem to be getting them about once a day, anything I can add to debug it?
>>>>>>>>
>>>>>>>> Could you please try reproducing with the following patch?
>>>>>>
>>>>>> Yes, and I've got mixed results. It reproduced, and all I got was:
>>>>>>
>>>>>> [  717.645572] ===============================
>>>>>> [  717.645572] [ INFO: suspicious RCU usage. ]
>>>>>> [  717.645572] 3.19.0-rc5-next-20150121-sasha-00064-g3c37e35-dirty #1809 Tainted: G        W
>>>>>> [  717.645572] -------------------------------
>>>>>> [  717.645572] kernel/rcu/tree_plugin.h:337 rcu_read_unlock() from irq or softirq with blocking in critical section!!!
>>>>>> [  717.645572] !
>>>>>> [  717.645572]
>>>>>> [  717.645572] other info that might help us debug this:
>>>>>> [  717.645572]
>>>>>> [  717.645572]
>>>>>> [  717.645572] rcu_scheduler_active = 1, debug_locks = 1
>>>>>> [  717.645572] 3 locks held by trinity-c29/16497:
>>>>>> [  717.645572]  #0:  (&sb->s_type->i_mutex_key){+.+.+.}, at: [<ffffffff81bec373>] lookup_slow+0xd3/0x420
>>>>>> [  717.645572]  #1:
>>>>>> [hang]
>>>>>>
>>>>>> So the rest of the locks/stack trace didn't get printed, nor the pr_alert() which
>>>>>> should follow that.
>>>>>>
>>>>>> I've removed the lockdep call and will re-run it.
>>>> Thank you!  You are keeping the pr_alert(), correct?
>>>
>>> Yup, just the lockdep call goes away.
>>
>> Okay, this reproduced faster than I anticipated:
>>
>> [  786.160131] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
>> [  786.239513] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
>> [  786.240503] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
>> [  786.242575] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
>> [  786.243565] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
>> [  786.243565] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
>> [  786.243565] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
>> [  786.243565] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
>> [  786.243565] ->rcu_read_unlock_special: 0x100 (b: 0, nq: 1)
>>
>> It seems like the WARN_ON_ONCE was hiding the fact it actually got hit couple
>> of times in a very short interval. Maybe that would also explain lockdep crapping
>> itself.
> 
> OK, that was what I thought was the situation.  I have not yet fully
> worked out how RCU gets into that state, but in the meantime, here
> is a patch that should prevent the splats.  (It requires a subtle
> interaction of quiescent-state detection and the scheduling-clock
> interrupt.)
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Clear need_qs flag to prevent splat
> 
> If the scheduling-clock interrupt sets the current tasks need_qs flag,
> but if the current CPU passes through a quiescent state in the meantime,
> then rcu_preempt_qs() will fail to clear the need_qs flag, which can fool
> RCU into thinking that additional rcu_read_unlock_special() processing
> is needed.  This commit therefore clears the need_qs flag before checking
> for additional processing.
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 8669de884445..ec99dc16aa38 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -322,6 +322,7 @@ void rcu_read_unlock_special(struct task_struct *t)
>  	special = t->rcu_read_unlock_special;
>  	if (special.b.need_qs) {
>  		rcu_preempt_qs();
> +		t->rcu_read_unlock_special.need_qs = false;
>  		if (!t->rcu_read_unlock_special.s) {
>  			local_irq_restore(flags);
>  			return;
> 
> .


rcu_preempt_qs() can be called from rcu_preempt_note_context_switch()
without irq-disabled. I think it is dangerous, since it touches need_qs and
passed_quiesce directly and touches rcu_read_unlock_special.b.blocked and
qs_pending indirectly.  At least it addes burden for me to understand them all.


