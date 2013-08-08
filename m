Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab3HHCMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:12:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8647 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab3HHCMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:12:15 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=K3AfDgtOciEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XDao0TA1N8EA:10 a=Hgpwg-0C_eL4Oa7nk6IA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375927932.6848.33.camel@gandalf.local.home>
Subject: Re: [PATCH 0/8] rcu: Ensure rcu read site is deadlock-immunity
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, C.Emde@osadl.org
Date: Wed, 07 Aug 2013 22:12:12 -0400
In-Reply-To: <5202F8CC.2020703@cn.fujitsu.com>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
	 <20130807123827.GB4306@linux.vnet.ibm.com>
	 <20130808003635.GA9487@linux.vnet.ibm.com>
	 <5202F8CC.2020703@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 09:47 +0800, Lai Jiangshan wrote:

> > [  393.641012]        CPU0
> > [  393.641012]        ----
> > [  393.641012]   lock(&lock->wait_lock);
> > [  393.641012]   <Interrupt>
> > [  393.641012]     lock(&lock->wait_lock);
> 
> Patch2 causes it!
> When I found all lock which can (chained) nested in rcu_read_unlock_special(),
> I didn't notice rtmutex's lock->wait_lock is not nested in irq-disabled.
> 
> Two ways to fix it:
> 1) change rtmutex's lock->wait_lock, make it alwasys irq-disabled.
> 2) revert my patch2

Your patch 2 states:

"After patch 10f39bb1, "special & RCU_READ_UNLOCK_BLOCKED" can't be true
in irq nor softirq.(due to RCU_READ_UNLOCK_BLOCKED can only be set
when preemption)"

But then below we have:


> 
> > [  393.641012] 
> > [  393.641012]  *** DEADLOCK ***
> > [  393.641012] 
> > [  393.641012] no locks held by rcu_torture_rea/697.
> > [  393.641012] 
> > [  393.641012] stack backtrace:
> > [  393.641012] CPU: 3 PID: 697 Comm: rcu_torture_rea Not tainted 3.11.0-rc1+ #1
> > [  393.641012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> > [  393.641012]  ffffffff8586fea0 ffff88001fcc3a78 ffffffff8187b4cb ffffffff8104a261
> > [  393.641012]  ffff88001e1a20c0 ffff88001fcc3ad8 ffffffff818773e4 0000000000000000
> > [  393.641012]  ffff880000000000 ffff880000000001 ffffffff81010a0a 0000000000000001
> > [  393.641012] Call Trace:
> > [  393.641012]  <IRQ>  [<ffffffff8187b4cb>] dump_stack+0x4f/0x84
> > [  393.641012]  [<ffffffff8104a261>] ? console_unlock+0x291/0x410
> > [  393.641012]  [<ffffffff818773e4>] print_usage_bug+0x1f5/0x206
> > [  393.641012]  [<ffffffff81010a0a>] ? save_stack_trace+0x2a/0x50
> > [  393.641012]  [<ffffffff810ae603>] mark_lock+0x283/0x2e0
> > [  393.641012]  [<ffffffff810ada10>] ? print_irq_inversion_bug.part.40+0x1f0/0x1f0
> > [  393.641012]  [<ffffffff810aef66>] __lock_acquire+0x906/0x1d40
> > [  393.641012]  [<ffffffff810ae94b>] ? __lock_acquire+0x2eb/0x1d40
> > [  393.641012]  [<ffffffff810ae94b>] ? __lock_acquire+0x2eb/0x1d40
> > [  393.641012]  [<ffffffff810b0a65>] lock_acquire+0x95/0x210
> > [  393.641012]  [<ffffffff818860f3>] ? rt_mutex_unlock+0x53/0x100
> > [  393.641012]  [<ffffffff81886d26>] _raw_spin_lock+0x36/0x50
> > [  393.641012]  [<ffffffff818860f3>] ? rt_mutex_unlock+0x53/0x100
> > [  393.641012]  [<ffffffff818860f3>] rt_mutex_unlock+0x53/0x100
> > [  393.641012]  [<ffffffff810ee3ca>] rcu_read_unlock_special+0x17a/0x2a0
> > [  393.641012]  [<ffffffff810ee803>] rcu_check_callbacks+0x313/0x950
> > [  393.641012]  [<ffffffff8107a6bd>] ? hrtimer_run_queues+0x1d/0x180
> > [  393.641012]  [<ffffffff810abb9d>] ? trace_hardirqs_off+0xd/0x10
> > [  393.641012]  [<ffffffff8105bae3>] update_process_times+0x43/0x80
> > [  393.641012]  [<ffffffff810a9801>] tick_sched_handle.isra.10+0x31/0x40
> > [  393.641012]  [<ffffffff810a98f7>] tick_sched_timer+0x47/0x70
> > [  393.641012]  [<ffffffff8107941c>] __run_hrtimer+0x7c/0x490
> > [  393.641012]  [<ffffffff810a260d>] ? ktime_get_update_offsets+0x4d/0xe0
> > [  393.641012]  [<ffffffff810a98b0>] ? tick_nohz_handler+0xa0/0xa0
> > [  393.641012]  [<ffffffff8107a017>] hrtimer_interrupt+0x107/0x260

The hrtimer_interrupt is calling a rt_mutex_unlock? How did that happen?
Did it first call a rt_mutex_lock?

If patch two was the culprit, I'm thinking the idea behind patch two is
wrong. The only option is to remove patch number two!

Or perhaps I missed something.

-- Steve


> > [  393.641012]  [<ffffffff81030173>] local_apic_timer_interrupt+0x33/0x60
> > [  393.641012]  [<ffffffff8103059e>] smp_apic_timer_interrupt+0x3e/0x60
> > [  393.641012]  [<ffffffff8189022f>] apic_timer_interrupt+0x6f/0x80
> > [  393.641012]  <EOI>  [<ffffffff810ee250>] ? rcu_scheduler_starting+0x60/0x60
> > [  393.641012]  [<ffffffff81072101>] ? __rcu_read_unlock+0x91/0xa0
> > [  393.641012]  [<ffffffff810e80e3>] rcu_torture_read_unlock+0x33/0x70
> > [  393.641012]  [<ffffffff810e8f54>] rcu_torture_reader+0xe4/0x450
> > [  393.641012]  [<ffffffff810e92c0>] ? rcu_torture_reader+0x450/0x450
> > [  393.641012]  [<ffffffff810e8e70>] ? rcutorture_trace_dump+0x30/0x30
> > [  393.641012]  [<ffffffff810759d6>] kthread+0xd6/0xe0
> > [  393.641012]  [<ffffffff818874bb>] ? _raw_spin_unlock_irq+0x2b/0x60
> > [  393.641012]  [<ffffffff81075900>] ? flush_kthread_worker+0x130/0x130
> > [  393.641012]  [<ffffffff8188f52c>] ret_from_fork+0x7c/0xb0
> > [  393.641012]  [<ffffffff81075900>] ? flush_kthread_worker+0x130/0x130
> > 
> > I don't see this without your patches.
> > 
> > .config attached.  The other configurations completed without errors.
> > Short tests, 30 minutes per configuration.
> > 
> > Thoughts?
> > 
> > 							Thanx, Paul


