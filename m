Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3KKSgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:36:17 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55307 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3KKSgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:36:08 -0500
Date: Mon, 11 Nov 2013 10:36:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: laijs@cn.fujitsu.com
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: WARN_ON_ONCE(in_irq() || in_serving_softirq()
Message-ID: <20131111183602.GA16592@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111118-1344-0000-0000-0000032B56DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai,

I am hitting the new warning in rcu_read_unlock_special() that checks for
(in_irq() || in_serving_softirq()).  Please see below for the splat.
I actually managed to get two CPUs hitting this simultaneously, so got
two splats.

My first thought is to revert the WARN_ON_ONCE(), going back to:

	if (in_irq() || in_serving_softirq()) {
		local_irq_restore(flags);
		return;
	}

>From what I can see, the scheduling-clock tick is setting
RCU_READ_UNLOCK_NEED_QS, which is causing the softirq handler's
RCU read-side critical section to enter rcu_read_unlock_special().

Another fix would be to check for t->rcu_read_unlock_special == 0
in the previous "if (special & RCU_READ_UNLOCK_NEED_QS) {" check.

Other thoughts?

							Thanx, Paul

------------------------------------------------------------------------

[  192.542052] ------------[ cut here ]------------
[  192.542054] ------------[ cut here ]------------
[  192.542072] WARNING: CPU: 1 PID: 674 at /home/paulmck/public_git/linux-rcu/kernel/rcu/tree_plugin.h:367 rcu_read_unlock_special+0x260/0x270()
[  192.542074] Modules linked in:
[  192.542080] CPU: 1 PID: 674 Comm: rcu_torture_rea Not tainted 3.12.0-rc1+ #1
[  192.542081] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  192.542085]  000000000000016f ffff88001fc43cc8 ffffffff817eaf38 0000000000000102
[  192.542087]  0000000000000000 ffff88001fc43d08 ffffffff81045907 0000000000000001
[  192.542089]  0000000000000002 0000000000004bcf ffffffff83ccbd40 ffff88001e1cc0c0
[  192.542090] Call Trace:
[  192.542100]  <IRQ>  [<ffffffff817eaf38>] dump_stack+0x4f/0x84
[  192.542106]  [<ffffffff81045907>] warn_slowpath_common+0x87/0xb0
[  192.542109]  [<ffffffff81045945>] warn_slowpath_null+0x15/0x20
[  192.542111]  [<ffffffff81094ea0>] rcu_read_unlock_special+0x260/0x270
[  192.542114]  [<ffffffff8108ddce>] __rcu_read_unlock+0x5e/0x60
[  192.542117]  [<ffffffff8108f1c1>] rcu_torture_read_unlock+0x21/0x30
[  192.542133]  [<ffffffff810914f5>] rcu_torture_timer+0x135/0x150
[  192.542137]  [<ffffffff810913c0>] ? rcu_torture_reader+0x310/0x310
[  192.542144]  [<ffffffff8105149a>] call_timer_fn+0x7a/0x200
[  192.542146]  [<ffffffff81051420>] ? del_timer+0x70/0x70
[  192.542148]  [<ffffffff81052165>] run_timer_softirq+0x215/0x2f0
[  192.542151]  [<ffffffff8109671f>] ? ktime_get+0x4f/0xe0
[  192.542153]  [<ffffffff810913c0>] ? rcu_torture_reader+0x310/0x310
[  192.542156]  [<ffffffff8104a1a9>] __do_softirq+0xd9/0x2d0
[  192.542158]  [<ffffffff8104a4ce>] irq_exit+0x7e/0xa0
[  192.542163]  [<ffffffff8102e1d5>] smp_apic_timer_interrupt+0x45/0x60
[  192.542170]  [<ffffffff817fe6ca>] apic_timer_interrupt+0x6a/0x70
[  192.542177]  <EOI>  [<ffffffff81071d86>] ? finish_task_switch+0x46/0xf0
[  192.542179]  [<ffffffff81071d86>] ? finish_task_switch+0x46/0xf0
[  192.542186]  [<ffffffff817f64cc>] ? _raw_spin_unlock_irq+0x2c/0x60
[  192.542188]  [<ffffffff817f64c6>] ? _raw_spin_unlock_irq+0x26/0x60
[  192.542190]  [<ffffffff81071dc3>] finish_task_switch+0x83/0xf0
[  192.542192]  [<ffffffff81071d86>] ? finish_task_switch+0x46/0xf0
[  192.542194]  [<ffffffff817f46ca>] __schedule+0x3ba/0x860
[  192.542197]  [<ffffffff817f4c84>] schedule+0x24/0x70
[  192.542199]  [<ffffffff81091190>] rcu_torture_reader+0xe0/0x310
[  192.542201]  [<ffffffff810913c0>] ? rcu_torture_reader+0x310/0x310
[  192.542204]  [<ffffffff810910b0>] ? rcutorture_trace_dump+0x30/0x30
[  192.542209]  [<ffffffff81068096>] kthread+0xd6/0xe0
[  192.542211]  [<ffffffff81071d86>] ? finish_task_switch+0x46/0xf0
[  192.542215]  [<ffffffff81067fc0>] ? flush_kthread_work+0x190/0x190
[  192.542217]  [<ffffffff817fda2c>] ret_from_fork+0x7c/0xb0
[  192.542220]  [<ffffffff81067fc0>] ? flush_kthread_work+0x190/0x190
[  192.542222] ---[ end trace 8519fcb7dea5ceee ]---
[  192.543027] WARNING: CPU: 2 PID: 670 at /home/paulmck/public_git/linux-rcu/kernel/rcu/tree_plugin.h:367 rcu_read_unlock_special+0x260/0x270()
[  192.543027] Modules linked in:
[  192.543027] CPU: 2 PID: 670 Comm: rcu_torture_rea Tainted: G        W    3.12.0-rc1+ #1
[  192.543027] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  192.543027]  000000000000016f ffff88001fc83cc8 ffffffff817eaf38 0000000000000102
[  192.543027]  0000000000000000 ffff88001fc83d08 ffffffff81045907 ffff88001e36ffd8
[  192.543027]  0000000000000002 0000000000004bcf ffffffff83ccbd40 ffff88001e1c8000
[  192.543027] Call Trace:
[  192.543027]  <IRQ>  [<ffffffff817eaf38>] dump_stack+0x4f/0x84
[  192.543027]  [<ffffffff81045907>] warn_slowpath_common+0x87/0xb0
[  192.543027]  [<ffffffff81045945>] warn_slowpath_null+0x15/0x20
[  192.543027]  [<ffffffff81094ea0>] rcu_read_unlock_special+0x260/0x270
[  192.543027]  [<ffffffff8108ddce>] __rcu_read_unlock+0x5e/0x60
[  192.543027]  [<ffffffff8108f1c1>] rcu_torture_read_unlock+0x21/0x30
[  192.543027]  [<ffffffff810914f5>] rcu_torture_timer+0x135/0x150
[  192.543027]  [<ffffffff810913c0>] ? rcu_torture_reader+0x310/0x310
[  192.543027]  [<ffffffff8105149a>] call_timer_fn+0x7a/0x200
[  192.543027]  [<ffffffff81051420>] ? del_timer+0x70/0x70
[  192.543027]  [<ffffffff81052165>] run_timer_softirq+0x215/0x2f0
[  192.543027]  [<ffffffff8109671f>] ? ktime_get+0x4f/0xe0
[  192.543027]  [<ffffffff810913c0>] ? rcu_torture_reader+0x310/0x310
[  192.543027]  [<ffffffff8104a1a9>] __do_softirq+0xd9/0x2d0
[  192.543027]  [<ffffffff8104a4ce>] irq_exit+0x7e/0xa0
[  192.543027]  [<ffffffff8102e1d5>] smp_apic_timer_interrupt+0x45/0x60
[  192.543027]  [<ffffffff817fe6ca>] apic_timer_interrupt+0x6a/0x70
[  192.543027]  <EOI>  [<ffffffff817f64cc>] ? _raw_spin_unlock_irq+0x2c/0x60
[  192.543027]  [<ffffffff817f64c6>] ? _raw_spin_unlock_irq+0x26/0x60
[  192.543027]  [<ffffffff817f4a1d>] __schedule+0x70d/0x860
[  192.543027]  [<ffffffff817f4c84>] schedule+0x24/0x70
[  192.543027]  [<ffffffff81091190>] rcu_torture_reader+0xe0/0x310
[  192.543027]  [<ffffffff81071d86>] ? finish_task_switch+0x46/0xf0
[  192.543027]  [<ffffffff810913c0>] ? rcu_torture_reader+0x310/0x310
[  192.543027]  [<ffffffff810910b0>] ? rcutorture_trace_dump+0x30/0x30
[  192.543027]  [<ffffffff81068096>] kthread+0xd6/0xe0
[  192.543027]  [<ffffffff81071d86>] ? finish_task_switch+0x46/0xf0
[  192.543027]  [<ffffffff81067fc0>] ? flush_kthread_work+0x190/0x190
[  192.543027]  [<ffffffff817fda2c>] ret_from_fork+0x7c/0xb0
[  192.543027]  [<ffffffff81067fc0>] ? flush_kthread_work+0x190/0x190
[  192.543027] ---[ end trace 8519fcb7dea5ceef ]---

