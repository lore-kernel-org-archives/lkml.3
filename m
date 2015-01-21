Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbbAUC6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 21:58:02 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:41314 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbbAUC6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 21:58:00 -0500
Date: Tue, 20 Jan 2015 18:57:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: rcu, sched: WARNING: CPU: 30 PID: 23771 at
 kernel/rcu/tree_plugin.h:337 rcu_read_unlock_special+0x369/0x550()
Message-ID: <20150121025754.GV9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <54BBC084.2030604@oracle.com>
 <20150118232255.GD9719@linux.vnet.ibm.com>
 <54BE76B9.7070907@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BE76B9.7070907@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012102-0029-0000-0000-000007581183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:39:37AM -0500, Sasha Levin wrote:
> On 01/18/2015 06:22 PM, Paul E. McKenney wrote:
> > On Sun, Jan 18, 2015 at 09:17:40AM -0500, Sasha Levin wrote:
> >> > Hi Paul, Lai,
> >> > 
> >> > While fuzzing with trinity inside a KVM tools guest running the latest -next
> >> > kernel, I've stumbled on the following spew:
> >> > 
> >> > [  598.188036] WARNING: CPU: 30 PID: 23771 at kernel/rcu/tree_plugin.h:337 rcu_read_unlock_special+0x369/0x550()
> >> > [  598.188036] Modules linked in:
> >> > [  598.188036] CPU: 30 PID: 23771 Comm: trinity-c118 Not tainted 3.19.0-rc4-next-20150116-sasha-00055-gb8e1507-dirty #1745
> >> > [  598.188036]  ffffffff926e52dc ffff8801b4403c38 ffffffff91439fb2 0000000000000000
> >> > [  598.188036]  0000000000000000 ffff8801b4403c78 ffffffff8e159e1a ffff8801b4403c58
> >> > [  598.188036]  0000000000000000 ffff88002f093000 00000000ffffffff ffff8801b23b9290
> >> > [  598.188036] Call Trace:
> >> > [  598.188036] <IRQ> dump_stack (lib/dump_stack.c:52)
> >> > [  598.212152] warn_slowpath_common (kernel/panic.c:447)
> >> > [  598.212152] warn_slowpath_null (kernel/panic.c:481)
> >> > [  598.212152] rcu_read_unlock_special (kernel/rcu/tree_plugin.h:337 (discriminator 9))
> >> > [  598.212152] ? select_task_rq_fair (include/linux/rcupdate.h:889 kernel/sched/fair.c:4740)
> >> > [  598.212152] __rcu_read_unlock (kernel/rcu/update.c:97)
> >> > [  598.212152] select_task_rq_fair (kernel/sched/fair.c:4805)
> >> > [  598.212152] ? select_task_rq_fair (include/linux/rcupdate.h:889 kernel/sched/fair.c:4740)
> >> > [  598.212152] ? try_to_wake_up (kernel/sched/core.c:1701)
> >> > [  598.212152] try_to_wake_up (kernel/sched/core.c:1415 kernel/sched/core.c:1729)
> >> > [  598.212152] wake_up_process (kernel/sched/core.c:1797 (discriminator 3))
> >> > [  598.212152] hrtimer_wakeup (kernel/time/hrtimer.c:1490)
> >> > [  598.212152] __run_hrtimer (kernel/time/hrtimer.c:1218 (discriminator 3))
> >> > [  598.212152] ? hrtimer_interrupt (kernel/time/hrtimer.c:622 kernel/time/hrtimer.c:1254)
> >> > [  598.212152] ? hrtimer_get_res (kernel/time/hrtimer.c:1480)
> >> > [  598.212152] hrtimer_interrupt (kernel/time/hrtimer.c:1307)
> >> > [  598.212152] local_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:921)
> >> > [  598.212152] smp_apic_timer_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/apic/apic.c:945)
> >> > [  598.212152] apic_timer_interrupt (arch/x86/kernel/entry_64.S:983)
> >> > [  598.212152] <EOI> ? context_tracking_user_enter (./arch/x86/include/asm/paravirt.h:809 kernel/context_tracking.c:106)
> >> > [  598.212152] syscall_trace_leave (arch/x86/kernel/ptrace.c:1640)
> >> > [  598.212152] int_check_syscall_exit_work (arch/x86/kernel/entry_64.S:577)
> > So RCU believes that an RCU read-side critical section that ended within
> > an interrupt handler (in this case, an hrtimer) somehow got preempted.
> > Which is not supposed to happen.
> > 
> > Do you have CONFIG_PROVE_RCU enabled?  If not, could you please enable it
> > and retry?
> 
> I did have CONFIG_PROVE_RCU, and didn't see anything else besides what I pasted here.

OK, fair enough.  I do have a stack of RCU CPU stall-warning changes on
their way in, please see v3.19-rc1..630181c4a915 in -rcu, which is at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git

These handle the problems that Dave Jones, yourself, and a few others
located this past December.  Could you please give them a spin?

							Thanx, Paul

