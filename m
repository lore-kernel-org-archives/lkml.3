Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3HHDGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 23:06:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39074 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab3HHDGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 23:06:41 -0400
X-IronPort-AV: E=Sophos;i="4.89,836,1367942400"; 
   d="scan'208";a="8150111"
Message-ID: <52030C37.3000106@cn.fujitsu.com>
Date: Thu, 08 Aug 2013 11:10:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        C.Emde@osadl.org
Subject: Re: [PATCH 0/8] rcu: Ensure rcu read site is deadlock-immunity
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com> <20130807123827.GB4306@linux.vnet.ibm.com> <20130808003635.GA9487@linux.vnet.ibm.com> <5202F8CC.2020703@cn.fujitsu.com> <1375927932.6848.33.camel@gandalf.local.home> <5203036B.2080606@cn.fujitsu.com> <20130808023356.GG4306@linux.vnet.ibm.com>
In-Reply-To: <20130808023356.GG4306@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 11:05:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 11:05:14,
	Serialize complete at 2013/08/08 11:05:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 10:33 AM, Paul E. McKenney wrote:
> On Thu, Aug 08, 2013 at 10:33:15AM +0800, Lai Jiangshan wrote:
>> On 08/08/2013 10:12 AM, Steven Rostedt wrote:
>>> On Thu, 2013-08-08 at 09:47 +0800, Lai Jiangshan wrote:
>>>
>>>>> [  393.641012]        CPU0
>>>>> [  393.641012]        ----
>>>>> [  393.641012]   lock(&lock->wait_lock);
>>>>> [  393.641012]   <Interrupt>
>>>>> [  393.641012]     lock(&lock->wait_lock);
>>>>
>>>> Patch2 causes it!
>>>> When I found all lock which can (chained) nested in rcu_read_unlock_special(),
>>>> I didn't notice rtmutex's lock->wait_lock is not nested in irq-disabled.
>>>>
>>>> Two ways to fix it:
>>>> 1) change rtmutex's lock->wait_lock, make it alwasys irq-disabled.
>>>> 2) revert my patch2
>>>
>>> Your patch 2 states:
>>>
>>> "After patch 10f39bb1, "special & RCU_READ_UNLOCK_BLOCKED" can't be true
>>> in irq nor softirq.(due to RCU_READ_UNLOCK_BLOCKED can only be set
>>> when preemption)"
>>
>> Patch5 adds "special & RCU_READ_UNLOCK_BLOCKED" back in irq nor softirq.
>> This new thing is handle in patch5 if I did not do wrong things in patch5.
>> (I don't notice rtmutex's lock->wait_lock is not irqs-disabled in patch5)
>>
>>>
>>> But then below we have:
>>>
>>>
>>>>
>>>>> [  393.641012] 
>>>>> [  393.641012]  *** DEADLOCK ***
>>>>> [  393.641012] 
>>>>> [  393.641012] no locks held by rcu_torture_rea/697.
>>>>> [  393.641012] 
>>>>> [  393.641012] stack backtrace:
>>>>> [  393.641012] CPU: 3 PID: 697 Comm: rcu_torture_rea Not tainted 3.11.0-rc1+ #1
>>>>> [  393.641012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
>>>>> [  393.641012]  ffffffff8586fea0 ffff88001fcc3a78 ffffffff8187b4cb ffffffff8104a261
>>>>> [  393.641012]  ffff88001e1a20c0 ffff88001fcc3ad8 ffffffff818773e4 0000000000000000
>>>>> [  393.641012]  ffff880000000000 ffff880000000001 ffffffff81010a0a 0000000000000001
>>>>> [  393.641012] Call Trace:
>>>>> [  393.641012]  <IRQ>  [<ffffffff8187b4cb>] dump_stack+0x4f/0x84
>>>>> [  393.641012]  [<ffffffff8104a261>] ? console_unlock+0x291/0x410
>>>>> [  393.641012]  [<ffffffff818773e4>] print_usage_bug+0x1f5/0x206
>>>>> [  393.641012]  [<ffffffff81010a0a>] ? save_stack_trace+0x2a/0x50
>>>>> [  393.641012]  [<ffffffff810ae603>] mark_lock+0x283/0x2e0
>>>>> [  393.641012]  [<ffffffff810ada10>] ? print_irq_inversion_bug.part.40+0x1f0/0x1f0
>>>>> [  393.641012]  [<ffffffff810aef66>] __lock_acquire+0x906/0x1d40
>>>>> [  393.641012]  [<ffffffff810ae94b>] ? __lock_acquire+0x2eb/0x1d40
>>>>> [  393.641012]  [<ffffffff810ae94b>] ? __lock_acquire+0x2eb/0x1d40
>>>>> [  393.641012]  [<ffffffff810b0a65>] lock_acquire+0x95/0x210
>>>>> [  393.641012]  [<ffffffff818860f3>] ? rt_mutex_unlock+0x53/0x100
>>>>> [  393.641012]  [<ffffffff81886d26>] _raw_spin_lock+0x36/0x50
>>>>> [  393.641012]  [<ffffffff818860f3>] ? rt_mutex_unlock+0x53/0x100
>>>>> [  393.641012]  [<ffffffff818860f3>] rt_mutex_unlock+0x53/0x100
>>>>> [  393.641012]  [<ffffffff810ee3ca>] rcu_read_unlock_special+0x17a/0x2a0
>>>>> [  393.641012]  [<ffffffff810ee803>] rcu_check_callbacks+0x313/0x950
>>>>> [  393.641012]  [<ffffffff8107a6bd>] ? hrtimer_run_queues+0x1d/0x180
>>>>> [  393.641012]  [<ffffffff810abb9d>] ? trace_hardirqs_off+0xd/0x10
>>>>> [  393.641012]  [<ffffffff8105bae3>] update_process_times+0x43/0x80
>>>>> [  393.641012]  [<ffffffff810a9801>] tick_sched_handle.isra.10+0x31/0x40
>>>>> [  393.641012]  [<ffffffff810a98f7>] tick_sched_timer+0x47/0x70
>>>>> [  393.641012]  [<ffffffff8107941c>] __run_hrtimer+0x7c/0x490
>>>>> [  393.641012]  [<ffffffff810a260d>] ? ktime_get_update_offsets+0x4d/0xe0
>>>>> [  393.641012]  [<ffffffff810a98b0>] ? tick_nohz_handler+0xa0/0xa0
>>>>> [  393.641012]  [<ffffffff8107a017>] hrtimer_interrupt+0x107/0x260
>>>
>>> The hrtimer_interrupt is calling a rt_mutex_unlock? How did that happen?
>>> Did it first call a rt_mutex_lock?
>>>
>>> If patch two was the culprit, I'm thinking the idea behind patch two is
>>> wrong. The only option is to remove patch number two!
>>
>> removing patch number two can solve the problem found be Paul, but it is not the best.
>> because I can't declare that rcu is deadlock-immunity
>> (it will be deadlock if rcu read site overlaps with rtmutex's lock->wait_lock
>> if I only remove patch2)
>> I must do more things, but I think it is still better than changing rtmutex's lock->wait_lock.
> 
> NP, I will remove your current patches and wait for an updated set.

Hi, Paul

Could you agree that moving the rt_mutex_unlock() to rcu_preempt_note_context_switch()?

thanks,
Lai

> 
> 							Thanx, Paul
> 
> 

