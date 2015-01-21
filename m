Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbbAUKQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:16:32 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:35763 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbAUKQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:16:21 -0500
Date: Wed, 21 Jan 2015 02:16:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        morgan.wang@huawei.com, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: RCU CPU stall console spews  leads to soft lockup disabled is
 reasonable ?
Message-ID: <20150121101613.GE9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150119084200.GE9719@linux.vnet.ibm.com>
 <54BCC89D.9040702@huawei.com>
 <20150119140612.GI116159@redhat.com>
 <54BDC6DF.6000602@huawei.com>
 <20150120152531.GR116159@redhat.com>
 <54BF0E53.5040409@huawei.com>
 <54BF1957.6080606@huawei.com>
 <54BF4D0D.3090500@huawei.com>
 <20150121070246.GB9719@linux.vnet.ibm.com>
 <54BF6BEE.2050505@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BF6BEE.2050505@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-0025-0000-0000-000007EF9678
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 05:05:50PM +0800, Zhang Zhen wrote:
> On 2015/1/21 15:02, Paul E. McKenney wrote:
> > On Wed, Jan 21, 2015 at 02:54:05PM +0800, Zhang Zhen wrote:
> >> On 2015/1/21 11:13, Zhang Zhen wrote:
> >>> On 2015/1/21 10:26, Zhang Zhen wrote:
> >>>> On 2015/1/20 23:25, Don Zickus wrote:
> > 
> > [ . . . ]
> > 
> >>> Sorry, i made a mistake, the log above is based on v3.10.63.
> >>> I have tested the latest upstream kernel (based on ec6f34e5b552),
> >>> but my test case can't triggered RCU stall warning.
> >>>
> >>
> >> I used git bisect to find the bad commit, but found a irrelevant
> >> commit(db5d711e2db776 zram: avoid null access when fail to alloc meta).
> >> Before this commit, my test case can easily trigger RCU stall warning,
> >> but after this commit, my test case can't trigger RCU stall warning.
> > 
> > I have lost track of exactly what kernel you are using.  If you are
> > using a recent kernel (v3.18 or thereabouts), one thing to try is to
> > apply my stack of RCU CPU stall-warning changes that are on their way
> > in, please see v3.19-rc1..630181c4a915 in -rcu, which is at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> > 
> > These handle the problems that Dave Jones and a few others located this
> > past December.  Could you please give them a spin?
> > 
> 
> Yeah, my test case can easily trigger RCU stall-warning based on commit 630181c4a915
> in your linux-rcu git tree.
> 
> In my .config, CONFIG_RCU_CPU_STALL_TIMEOUT=21.
> Before commented out touch_softlockup_watchdog() in touch_nmi_watchdog:
> 
> / #
> / # echo 60 > /proc/sys/kernel/watchdog_thresh
> [   21.885200] NMI watchdog: disabled (cpu0): hardware events not enabled
> / #  busybox insmod softlockup_test.ko
> [   47.900117] INFO: rcu_sched detected stalls on CPUs/tasks:
> [   47.900117] 	(detected by 0, t=5252 jiffies, g=-202, c=-203, q=7)
> [   47.900117] All QSes seen, last rcu_sched kthread activity 5252 (4294904271-4294899019), jiffies_till_next_fqs=1

Looks like you are starving RCU's grace-period kthreads.  What happens if
you boot with rcutree.kthread_prio=1 in order to run them at real-time
priority?

> [   47.900117] busybox         R  running task        0    42     41 0x00000008
> [   47.900117]  ffffffff81afaf40 ffff88007fa03d98 ffffffff810781c0 ffffffff81a5e5f8
> [   47.900117]  ffffffff81a45d80 ffff88007fa03dd8 ffffffff810af723 0000000000000083
> [   47.900117]  ffff88007fa13580 ffffffff81a45d80 ffffffff81a45d80 ffffffff810c43e0
> [   47.900117] Call Trace:
> [   47.900117]  <IRQ>  [<ffffffff810781c0>] sched_show_task+0xb0/0x110
> [   47.900117]  [<ffffffff810af723>] print_other_cpu_stall+0x2d3/0x2f0
> [   47.900117]  [<ffffffff810c43e0>] ? tick_nohz_handler+0xc0/0xc0
> [   47.900117]  [<ffffffff810af8b8>] __rcu_pending+0x178/0x220
> [   47.900117]  [<ffffffff810b02a5>] rcu_check_callbacks+0x105/0x190
> [   47.900117]  [<ffffffff810c43e0>] ? tick_nohz_handler+0xc0/0xc0
> [   47.900117]  [<ffffffff810b3582>] update_process_times+0x32/0x60
> [   47.900117]  [<ffffffff810c41e2>] tick_sched_handle+0x32/0x80
> [   47.900117]  [<ffffffff810c442d>] tick_sched_timer+0x4d/0x90
> [   47.900117]  [<ffffffff810b5b57>] __run_hrtimer+0xc7/0x1c0
> [   47.900117]  [<ffffffff810b5e37>] hrtimer_interrupt+0xe7/0x220
> [   47.900117]  [<ffffffffa0005000>] ? 0xffffffffa0005000
> [   47.900117]  [<ffffffff81035654>] local_apic_timer_interrupt+0x34/0x60
> [   47.900117]  [<ffffffff81035d8c>] smp_apic_timer_interrupt+0x3c/0x60
> [   47.900117]  [<ffffffff814ff02a>] apic_timer_interrupt+0x6a/0x70
> [   47.900117]  <EOI>  [<ffffffff814fdaa0>] ? _raw_spin_lock+0x20/0x30
> [   47.900117]  [<ffffffffa000505d>] test_init+0x5d/0x1000 [softlockup_test]
> [   47.900117]  [<ffffffffa0005000>] ? 0xffffffffa0005000
> [   47.900117]  [<ffffffff81000288>] do_one_initcall+0xb8/0x1d0
> [   47.900117]  [<ffffffff81168794>] ? __vunmap+0x94/0xf0
> [   47.900117]  [<ffffffff810ce36b>] do_init_module+0x2b/0x1b0
> [   47.900117]  [<ffffffff810d09b5>] load_module+0x585/0x5f0
> [   47.900117]  [<ffffffff810cdd40>] ? mod_sysfs_teardown+0x150/0x150
> [   47.900117]  [<ffffffff810d0bbb>] SyS_init_module+0x9b/0xc0
> [   47.900117]  [<ffffffff814fe252>] system_call_fastpath+0x12/0x17
> [   47.900117] rcu_sched kthread starved for 5252 jiffies!
> 
> After commented out touch_softlockup_watchdog() in touch_nmi_watchdog:
> 
> / #
> / # echo 60 > /proc/sys/kernel/watchdog_thresh
> [  123.011980] NMI watchdog: disabled (cpu0): hardware events not enabled
> / # busybox insmod softlockup_test.ko
> [  150.912055] INFO: rcu_sched detected stalls on CPUs/tasks:
> [  150.912055] 	(detected by 0, t=5252 jiffies, g=-198, c=-199, q=6)
> [  150.912055] All QSes seen, last rcu_sched kthread activity 5252 (4294930024-4294924772), jiffies_till_next_fqs=1

Same here, looks like RCU's grace-period kthreads haven't gotten a chance
to run for more than 5,000 jiffies.

> [  150.912055] busybox         R  running task        0    42     41 0x00000008
> [  150.912055]  ffffffff81afaf40 ffff88007fa03d98 ffffffff810781c0 ffffffff81a5e5f8
> [  150.912055]  ffffffff81a45d80 ffff88007fa03dd8 ffffffff810af723 0000000000000083
> [  150.912055]  ffff88007fa13580 ffffffff81a45d80 ffffffff81a45d80 ffffffff810c43e0
> [  150.912055] Call Trace:
> [  150.912055]  <IRQ>  [<ffffffff810781c0>] sched_show_task+0xb0/0x110
> [  150.912055]  [<ffffffff810af723>] print_other_cpu_stall+0x2d3/0x2f0
> [  150.912055]  [<ffffffff810c43e0>] ? tick_nohz_handler+0xc0/0xc0
> [  150.912055]  [<ffffffff810af8b8>] __rcu_pending+0x178/0x220
> [  150.912055]  [<ffffffff810b02a5>] rcu_check_callbacks+0x105/0x190
> [  150.912055]  [<ffffffff810c43e0>] ? tick_nohz_handler+0xc0/0xc0
> [  150.912055]  [<ffffffff810b3582>] update_process_times+0x32/0x60
> [  150.912055]  [<ffffffff810c41e2>] tick_sched_handle+0x32/0x80
> [  150.912055]  [<ffffffff810c442d>] tick_sched_timer+0x4d/0x90
> [  150.912055]  [<ffffffff810b5b57>] __run_hrtimer+0xc7/0x1c0
> [  150.912055]  [<ffffffff810b5e37>] hrtimer_interrupt+0xe7/0x220
> [  150.912055]  [<ffffffffa0005000>] ? 0xffffffffa0005000
> [  150.912055]  [<ffffffff81035654>] local_apic_timer_interrupt+0x34/0x60
> [  150.912055]  [<ffffffff81035d8c>] smp_apic_timer_interrupt+0x3c/0x60
> [  150.912055]  [<ffffffff814ff02a>] apic_timer_interrupt+0x6a/0x70
> [  150.912055]  <EOI>  [<ffffffff814fda90>] ? _raw_spin_lock+0x20/0x30
> [  150.912055]  [<ffffffffa000505d>] test_init+0x5d/0x1000 [softlockup_test]
> [  150.912055]  [<ffffffffa0005000>] ? 0xffffffffa0005000
> [  150.912055]  [<ffffffff81000288>] do_one_initcall+0xb8/0x1d0
> [  150.912055]  [<ffffffff81168784>] ? __vunmap+0x94/0xf0
> [  150.912055]  [<ffffffff810ce36b>] do_init_module+0x2b/0x1b0
> [  150.912055]  [<ffffffff810d09b5>] load_module+0x585/0x5f0
> [  150.912055]  [<ffffffff810cdd40>] ? mod_sysfs_teardown+0x150/0x150
> [  150.912055]  [<ffffffff810d0bbb>] SyS_init_module+0x9b/0xc0
> [  150.912055]  [<ffffffff814fe252>] system_call_fastpath+0x12/0x17
> [  150.912055] rcu_sched kthread starved for 5252 jiffies!
> ...
> ...
> [  291.009857] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 135s! [busybox:42]
> [  291.010286] Modules linked in: softlockup_test(O+)
> [  291.010944] CPU: 0 PID: 42 Comm: busybox Tainted: G           O   3.19.0-rc1-0.27-default+ #3
> [  291.011356] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  291.011674] task: ffff88007d3e61d0 ti: ffff88007d3fc000 task.ti: ffff88007d3fc000
> [  291.012066] RIP: 0010:[<ffffffff814fda90>]  [<ffffffff814fda90>] _raw_spin_lock+0x20/0x30
> [  291.012205] RSP: 0018:ffff88007d3ffdd8  EFLAGS: 00000202
> [  291.012205] RAX: 0000000000000000 RBX: ffff88007cc1e250 RCX: 0000000000012a40
> [  291.012205] RDX: 0000000000000001 RSI: 0000000000000246 RDI: ffff88007d3ffde8
> [  291.012205] RBP: ffff88007d3ffdd8 R08: ffff88007fa12a40 R09: 000000000000b806
> [  291.012205] R10: 0000000000000000 R11: ffff88007d3ffcd8 R12: ffffffff8107b1a4
> [  291.012205] R13: ffff88007d3ffd68 R14: 0000000000000000 R15: 0000000000000000
> [  291.012205] FS:  00000000007fd880(0063) GS:ffff88007fa00000(0000) knlGS:0000000000000000
> [  291.012205] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  291.012205] CR2: 000000000081c87f CR3: 000000007d3f1000 CR4: 00000000000006f0
> [  291.012205] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  291.012205] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> [  291.012205] Stack:
> [  291.012205]  ffff88007d3ffe08 ffffffffa000505d ffff880000020000 0000000000000000
> [  291.012205]  ffffffffa0005000 ffffffff81a19250 ffff88007d3ffe78 ffffffff81000288
> [  291.012205]  ffff88007d317540 0000000000000020 ffff88007d317540 0000000000000001
> [  291.012205] Call Trace:
> [  291.012205]  [<ffffffffa000505d>] test_init+0x5d/0x1000 [softlockup_test]
> [  291.012205]  [<ffffffffa0005000>] ? 0xffffffffa0005000
> [  291.012205]  [<ffffffff81000288>] do_one_initcall+0xb8/0x1d0
> [  291.012205]  [<ffffffff81168784>] ? __vunmap+0x94/0xf0
> [  291.012205]  [<ffffffff810ce36b>] do_init_module+0x2b/0x1b0
> [  291.012205]  [<ffffffff810d09b5>] load_module+0x585/0x5f0
> [  291.012205]  [<ffffffff810cdd40>] ? mod_sysfs_teardown+0x150/0x150
> [  291.012205]  [<ffffffff810d0bbb>] SyS_init_module+0x9b/0xc0
> [  291.012205]  [<ffffffff814fe252>] system_call_fastpath+0x12/0x17
> [  291.012205] Code: 89 d0 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 b8 00 00 01 00 3e 0f c1 07 89 c2 c1 ea 10 66 39 d0 75 0b eb 11 0f 1f 80 00 00 00 00 <f3> 90 0f b7 07 66 39 c2 75 f6 c9 c3 0f 1f 40 00 55 48 89 e5 9c
> 
> >                                                         Thanx, Paul
> > 
> >> I'm totally confused.
> >>
> >> My test case:
> >>
> >> //
> >> #include <linux/kernel.h>
> >> #include <linux/module.h>
> >> #include <linux/spinlock.h>
> >> #include <linux/slab.h>
> >> #include <linux/kthread.h>
> >>
> >> struct foo {
> >>         int a;
> >>         char b;
> >>         long c;
> >> };
> >>
> >> struct foo gbl_foo = {1, 'a', 2};
> >> struct foo *pgbl_foo = &gbl_foo;
> >>
> >> static int my_kthread(void *data)
> >> {
> >>         DEFINE_SPINLOCK(foo_mutex);

This defines a spinlock on the stack, which means that each of your
kthreads have their own lock, which means that acquiring the lock has
no effect.  Given that you spawn only one kthread, no problem now,
but big problems when you spawn multiple kthreads.

> >>         struct foo *new_fp;
> >>         struct foo *old_fp;
> >>
> >>         new_fp = kmalloc(sizeof(*new_fp), GFP_KERNEL);
> >>         spin_lock(&foo_mutex);
> >>         old_fp = pgbl_foo;
> >>         *new_fp = *old_fp;
> >>         new_fp->a = 2;
> >>         rcu_assign_pointer(pgbl_foo, new_fp);

You are planning to add RCU readers some time later?

> >>         spin_unlock(&foo_mutex);
> >>         synchronize_rcu();
> >>         kfree(old_fp);
> >>
> >>         return 0;
> >> }
> >>
> >> static int hello_start(void)
> >> {
> >>         struct task_struct *my_task = NULL;
> >>         DEFINE_SPINLOCK(hello_lock);
> >>
> >>         my_task = kthread_run(my_kthread, NULL, "my_thread%d", 1);
> >>
> >>         spin_lock_init(&hello_lock);
> >>         spin_lock(&hello_lock);
> >>         spin_lock(&hello_lock);

And this is the cause of the RCU CPU stall warnings.

If you only have one CPU and have built with CONFIG_PREEMPT=n, what
you have above is expected behavior.

							Thanx, Paul

> >>         return 0;
> >> }
> >>
> >> static int __init test_init(void)
> >> {
> >>         hello_start();
> >>
> >>         printk(KERN_INFO "Module init\n");
> >>         return 0;
> >> }
> >>
> >> static void __exit test_exit(void)
> >> {
> >>         printk(KERN_INFO "Module exit!\n");
> >> }
> >>
> >> module_init(test_init)
> >> module_exit(test_exit)
> >> MODULE_LICENSE("GPL");
> >> //
> >>>>>
> >>>>> Cheers,
> >>>>> Don
> >>>>>
> >>>>> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> >>>>> index 70bf118..833c015 100644
> >>>>> --- a/kernel/watchdog.c
> >>>>> +++ b/kernel/watchdog.c
> >>>>> @@ -209,7 +209,7 @@ void touch_nmi_watchdog(void)
> >>>>>  	 * going off.
> >>>>>  	 */
> >>>>>  	raw_cpu_write(watchdog_nmi_touch, true);
> >>>>> -	touch_softlockup_watchdog();
> >>>>> +	//touch_softlockup_watchdog();
> >>>>>  }
> >>>>>  EXPORT_SYMBOL(touch_nmi_watchdog);
> >>>>>  
> >>>>>
> >>>>> .
> >>>>>
> >>>>
> >>>
> >>
> >>
> > 
> > 
> > .
> > 
> 
> 

