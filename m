Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3FYM7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:59:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:5984 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3FYM7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:59:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,936,1363158000"; 
   d="scan'208";a="355447570"
Date: Tue, 25 Jun 2013 20:59:31 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [tracing/rcu] WARNING: at kernel/lockdep.c:3537 check_flags()
Message-ID: <20130625125931.GA4114@localhost>
References: <20130623041959.GA19722@localhost>
 <1372124842.18733.193.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372124842.18733.193.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 09:47:22PM
 -0400, Steven Rostedt wrote:
> On Sun, 2013-06-23 at 12:19 +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I find the below dmesg in upstream and linux-next.
> > 
> > [    2.456884] Testing tracer branch: 
> > [    2.458281]
 ------------[ cut here ]------------
> > [    2.459813] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3537 check_flags+0xb7/0x1b0()
> 
> Hmm, I bet lockdep and the branch tracer probably don't play well
> together. They both are bullies, and want to beat up the same kid. The
> problem is, they want sole access to beat up that kid, and don't want
> help.
> 
> 
> > [    2.460000] Hardware name: Bochs
> > [    2.460000] Pid: 3, comm: ksoftirqd/0 Not tainted 3.9.0-rc4-03252-g8b473e1 #58
> > [    2.460000] Call Trace:
> > 
> > [    2.460000]  [<ffffffff81073cdf>] warn_slowpath_common+0xaf/0xd0
> > [    2.460000]  [<ffffffff81073dda>] warn_slowpath_null+0x1a/0x20
> > [    2.460000]  [<ffffffff810e14f7>] check_flags+0xb7/0x1b0
> > [    2.460000]  [<ffffffff810e2682>] lock_is_held+0x62/0xc0
> > [    2.460000]  [<ffffffff810c938c>] __might_sleep+0x3c/0x3b0
> > [    2.460000]  [<ffffffff81082404>] run_ksoftirqd+0xd4/0x130
> > [    2.460000]  [<ffffffff810bec5c>] smpboot_thread_fn+0x25c/0x2e0
> > [    2.460000]  [<ffffffff810bea00>] ? lg_global_unlock+0x40/0x40
> > [    2.460000]  [<ffffffff810b210b>] kthread+0xfb/0x110
> > [    2.460000]  [<ffffffff810b2010>] ? insert_kthread_work+0x120/0x120
> > [    2.460000]  [<ffffffff81825c7a>] ret_from_fork+0x7a/0xb0
> > [    2.460000]  [<ffffffff810b2010>] ? insert_kthread_work+0x120/0x120
> > [    2.460000]
 ---[ end trace 3af7e87d98c6254d ]---
> > 
> > Bisecting for "__might_sleep" and the first bad commit is
> > 
> > commit 965a002b4f1a458c5dcb334ec29f48a0046faa25
> > Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > Date:   Sat Jun 18 09:55:39 2011
 -0700
> > 
> >     rcu: Make TINY_RCU also use softirq for RCU_BOOST=n
> >     
> >     This patch #ifdefs TINY_RCU kthreads out of the kernel unless RCU_BOOST=y,
> >     thus eliminating context-switch overhead if RCU priority boosting has
> >     not been configured.
> >     
> >     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > But note that its parent commit 385680a9487d2f85382ad6d74e2a15837e47bfd9
> > is not really clean and has this dmesg instead:
> > 
> > [    2.592748] Testing tracer wakeup_rt: PASSED
> > [    2.936495] Testing tracer branch: 
> > [    2.940281]
 ------------[ cut here ]------------
> > [    2.941194] WARNING: at /c/wfg/mm/kernel/lockdep.c:3363 check_flags.part.31+0xaf/0x1c0()
> > [    2.942593] Hardware name: Bochs
> > [    2.943199] Pid: 0, comm: swapper Not tainted 3.1.0-rc8-00019-g385680a #99
> > [    2.944234] Call Trace:
> > [    2.944234]  <IRQ>  [<ffffffff81050b9e>] warn_slowpath_common+0x9e/0xd0
> > [    2.944234]  [<ffffffff81050caa>] warn_slowpath_null+0x1a/0x20
> > [    2.944234]  [<ffffffff8109fddf>] check_flags.part.31+0xaf/0x1c0
> > [    2.944234]  [<ffffffff810a49a9>] lock_acquire+0x119/0x230
> > [    2.944234]  [<ffffffff810657c7>] run_timer_softirq+0x217/0x8a0
> > [    2.944234]  [<ffffffff81065751>] ? run_timer_softirq+0x1a1/0x8a0
> > [    2.944234]  [<ffffffff810655a0>] ? ftrace_raw_output_itimer_expire+0x160/0x160
> > [    2.944234]  [<ffffffff8105c190>] __do_softirq+0x1c0/0x5c0
> > [    2.944234]  [<ffffffff815b8f7a>] call_softirq+0x1a/0x30
> > [    2.944234]  [<ffffffff81006465>] do_softirq+0x165/0x290
> > [    2.944234]  [<ffffffff8105c967>] irq_exit+0xb7/0x130
> > [    2.944234]  [<ffffffff810237d7>] smp_apic_timer_interrupt+0x77/0xb0
> > [    2.944234]  [<ffffffff815b8971>] apic_timer_interrupt+0x71/0x80
> > [    2.944234]  <EOI>  [<ffffffff810e1e75>] ? ftrace_likely_update+0xc5/0x230
> > [    2.944234]  [<ffffffff810a045d>] ? trace_hardirqs_off+0xd/0x10
> > [    2.944234]  [<ffffffff8102bdab>] ? native_safe_halt+0xb/0x10
> > [    2.944234]  [<ffffffff8100f893>] default_idle+0x7d3/0x810
> > [    2.944234]  [<ffffffff8100131c>] cpu_idle+0x14c/0x160
> > [    2.944234]  [<ffffffff815922f3>] rest_init+0xe7/0xf4
> > [    2.944234]  [<ffffffff8159220c>] ? csum_partial_copy_generic+0x16c/0x16c
> > [    2.944234]  [<ffffffff81c33f15>] start_kernel+0x4f4/0x4ff
> > [    2.944234]  [<ffffffff81c33000>] ? vsyscall_gtod_data+0xf80/0xf80
> > [    2.944234]  [<ffffffff81c33000>] ? vsyscall_gtod_data+0xf80/0xf80
> > [    2.944234]  [<ffffffff81c33169>] x86_64_start_reservations+0x166/0x16a
> > [    2.944234]  [<ffffffff81c333dd>] x86_64_start_kernel+0x270/0x27f
> > [    2.944234]
 ---[ end trace 6d450e935ee1897c ]---
> > [    2.944234] possible reason: unannotated irqs-on.
> > [    2.944234] irq event stamp: 10085
> > [    2.944234] hardirqs last  enabled at (10084): [<ffffffff815b6892>] _raw_spin_unlock_irq+0x32/0x80
> > [    2.944234] hardirqs last disabled at (10085): [<ffffffff810e1e37>] ftrace_likely_update+0x87/0x230
> 
> irqs were last disabled at ftrace_likely_update(), perhaps the branch
> tracer called something in the wrong place.
> 
> I took your config, and I'm unable to reproduce this. Does this only
> happen on virt boxes?

Sorry I don't run tests on real machines for now. The kvm command line
is something close to this:

qemu-system-x86_64
 -cpu kvm64
 -enable-kvm
 -kernel /tmp//kernel/x86_64-randconfig-c29-0622/c0a4b933aa6fb8bdc21cb854633ea07779cda2b1/vmlinuz-3.10.0-rc7-next-20130625-08594-gc0a4b93-23753
 -append 'hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw'
 -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz
 -m 256M
 -smp 2
 -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
 -net user,vlan=0,hostfwd=tcp::27849-:22
 -net nic,vlan=1,model=e1000
 -net user,vlan=1
 -boot order=nc
 -no-reboot
 -watchdog i6300esb
 -drive file=/fs/LABEL=KVM/diska-roam-23753,media=disk,if=virtio
 -drive file=/fs/LABEL=KVM/diskb-roam-23753,media=disk,if=virtio
 -drive file=/fs/LABEL=KVM/diskc-roam-23753,media=disk,if=virtio
 -drive file=/fs/LABEL=KVM/diskd-roam-23753,media=disk,if=virtio
 -drive file=/fs/LABEL=KVM/diske-roam-23753,media=disk,if=virtio
 -drive file=/fs/LABEL=KVM/diskf-roam-23753,media=disk,if=virtio
 -pidfile /dev/shm/kboot/pid-roam-lkp-23753
 -serial file:/dev/shm/kboot/serial-roam-lkp-23753
 -daemonize
 -display none
 -monitor null 

Thanks,
Fengguang
