Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269Ab3FYBr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:47:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28731 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FYBrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:47:24 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=H4BA1lnxbasA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=TpfIETeN-9UA:10 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=NEAV23lmAAAA:8 a=qongvrTdjU4yCArMpMMA:9 a=QEXdDO2ut3YA:10 a=WwgC8nHKvroA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372124842.18733.193.camel@gandalf.local.home>
Subject: Re: [tracing/rcu] WARNING: at kernel/lockdep.c:3537 check_flags()
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 24 Jun 2013 21:47:22 -0400
In-Reply-To: <20130623041959.GA19722@localhost>
References: <20130623041959.GA19722@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-23 at 12:19 +0800, Fengguang Wu wrote:
> Greetings,
> 
> I find the below dmesg in upstream and linux-next.
> 
> [    2.456884] Testing tracer branch: 
> [    2.458281] ------------[ cut here ]------------
> [    2.459813] WARNING: at /c/kernel-tests/src/tip/kernel/lockdep.c:3537 check_flags+0xb7/0x1b0()

Hmm, I bet lockdep and the branch tracer probably don't play well
together. They both are bullies, and want to beat up the same kid. The
problem is, they want sole access to beat up that kid, and don't want
help.


> [    2.460000] Hardware name: Bochs
> [    2.460000] Pid: 3, comm: ksoftirqd/0 Not tainted 3.9.0-rc4-03252-g8b473e1 #58
> [    2.460000] Call Trace:
> 
> [    2.460000]  [<ffffffff81073cdf>] warn_slowpath_common+0xaf/0xd0
> [    2.460000]  [<ffffffff81073dda>] warn_slowpath_null+0x1a/0x20
> [    2.460000]  [<ffffffff810e14f7>] check_flags+0xb7/0x1b0
> [    2.460000]  [<ffffffff810e2682>] lock_is_held+0x62/0xc0
> [    2.460000]  [<ffffffff810c938c>] __might_sleep+0x3c/0x3b0
> [    2.460000]  [<ffffffff81082404>] run_ksoftirqd+0xd4/0x130
> [    2.460000]  [<ffffffff810bec5c>] smpboot_thread_fn+0x25c/0x2e0
> [    2.460000]  [<ffffffff810bea00>] ? lg_global_unlock+0x40/0x40
> [    2.460000]  [<ffffffff810b210b>] kthread+0xfb/0x110
> [    2.460000]  [<ffffffff810b2010>] ? insert_kthread_work+0x120/0x120
> [    2.460000]  [<ffffffff81825c7a>] ret_from_fork+0x7a/0xb0
> [    2.460000]  [<ffffffff810b2010>] ? insert_kthread_work+0x120/0x120
> [    2.460000] ---[ end trace 3af7e87d98c6254d ]---
> 
> Bisecting for "__might_sleep" and the first bad commit is
> 
> commit 965a002b4f1a458c5dcb334ec29f48a0046faa25
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Sat Jun 18 09:55:39 2011 -0700
> 
>     rcu: Make TINY_RCU also use softirq for RCU_BOOST=n
>     
>     This patch #ifdefs TINY_RCU kthreads out of the kernel unless RCU_BOOST=y,
>     thus eliminating context-switch overhead if RCU priority boosting has
>     not been configured.
>     
>     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> But note that its parent commit 385680a9487d2f85382ad6d74e2a15837e47bfd9
> is not really clean and has this dmesg instead:
> 
> [    2.592748] Testing tracer wakeup_rt: PASSED
> [    2.936495] Testing tracer branch: 
> [    2.940281] ------------[ cut here ]------------
> [    2.941194] WARNING: at /c/wfg/mm/kernel/lockdep.c:3363 check_flags.part.31+0xaf/0x1c0()
> [    2.942593] Hardware name: Bochs
> [    2.943199] Pid: 0, comm: swapper Not tainted 3.1.0-rc8-00019-g385680a #99
> [    2.944234] Call Trace:
> [    2.944234]  <IRQ>  [<ffffffff81050b9e>] warn_slowpath_common+0x9e/0xd0
> [    2.944234]  [<ffffffff81050caa>] warn_slowpath_null+0x1a/0x20
> [    2.944234]  [<ffffffff8109fddf>] check_flags.part.31+0xaf/0x1c0
> [    2.944234]  [<ffffffff810a49a9>] lock_acquire+0x119/0x230
> [    2.944234]  [<ffffffff810657c7>] run_timer_softirq+0x217/0x8a0
> [    2.944234]  [<ffffffff81065751>] ? run_timer_softirq+0x1a1/0x8a0
> [    2.944234]  [<ffffffff810655a0>] ? ftrace_raw_output_itimer_expire+0x160/0x160
> [    2.944234]  [<ffffffff8105c190>] __do_softirq+0x1c0/0x5c0
> [    2.944234]  [<ffffffff815b8f7a>] call_softirq+0x1a/0x30
> [    2.944234]  [<ffffffff81006465>] do_softirq+0x165/0x290
> [    2.944234]  [<ffffffff8105c967>] irq_exit+0xb7/0x130
> [    2.944234]  [<ffffffff810237d7>] smp_apic_timer_interrupt+0x77/0xb0
> [    2.944234]  [<ffffffff815b8971>] apic_timer_interrupt+0x71/0x80
> [    2.944234]  <EOI>  [<ffffffff810e1e75>] ? ftrace_likely_update+0xc5/0x230
> [    2.944234]  [<ffffffff810a045d>] ? trace_hardirqs_off+0xd/0x10
> [    2.944234]  [<ffffffff8102bdab>] ? native_safe_halt+0xb/0x10
> [    2.944234]  [<ffffffff8100f893>] default_idle+0x7d3/0x810
> [    2.944234]  [<ffffffff8100131c>] cpu_idle+0x14c/0x160
> [    2.944234]  [<ffffffff815922f3>] rest_init+0xe7/0xf4
> [    2.944234]  [<ffffffff8159220c>] ? csum_partial_copy_generic+0x16c/0x16c
> [    2.944234]  [<ffffffff81c33f15>] start_kernel+0x4f4/0x4ff
> [    2.944234]  [<ffffffff81c33000>] ? vsyscall_gtod_data+0xf80/0xf80
> [    2.944234]  [<ffffffff81c33000>] ? vsyscall_gtod_data+0xf80/0xf80
> [    2.944234]  [<ffffffff81c33169>] x86_64_start_reservations+0x166/0x16a
> [    2.944234]  [<ffffffff81c333dd>] x86_64_start_kernel+0x270/0x27f
> [    2.944234] ---[ end trace 6d450e935ee1897c ]---
> [    2.944234] possible reason: unannotated irqs-on.
> [    2.944234] irq event stamp: 10085
> [    2.944234] hardirqs last  enabled at (10084): [<ffffffff815b6892>] _raw_spin_unlock_irq+0x32/0x80
> [    2.944234] hardirqs last disabled at (10085): [<ffffffff810e1e37>] ftrace_likely_update+0x87/0x230

irqs were last disabled at ftrace_likely_update(), perhaps the branch
tracer called something in the wrong place.

I took your config, and I'm unable to reproduce this. Does this only
happen on virt boxes?

-- Steve


> [    2.944234] softirqs last  enabled at (10076): [<ffffffff8105c8a7>] irq_enter+0x87/0x90
> [    2.944234] softirqs last disabled at (10077): [<ffffffff815b8f7a>] call_softirq+0x1a/0x30
> [    3.040274] PASSED
> [    3.041998] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> 
> 
> git bisect start v3.2 v3.1 --
> git bisect  bad 68d99b2c8efcb6ed3807a55569300c53b5f88be5  # 10:10      0-  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
> git bisect good efb8d21b2c6db3497655cc6a033ae8a9883e4063  # 10:18     27+  Merge branch 'tty-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
> git bisect  bad 8686a0e200419322654a75155e2e6f80346a1297  # 10:22      0-  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 33bc95513c801b1637b6fb925155fb794b5da4f0  # 10:27     27+  staging: brcm80211: remove 'default n' from Kconfig
> git bisect good 4d8daa6b77d0697ea19b9c4f704be9b26d76fb36  # 10:34     27+  staging: brcm80211: cleaned up struct brcms_bss_cfg
> git bisect good 982653009b883ef1529089e3e6f1ae2fee41cbe2  # 10:38     27+  Merge branch 'core-iommu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 47724df3375bf0cf652039ab6b7ded29fe877de6  # 10:43     27+  Merge branch 'tip/perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/core
> git bisect  bad 048b718029033af117870d3da47da12995be14a3  # 10:52      0-  Merge branch 'rcu/next' of git://github.com/paulmckrcu/linux into core/rcu
> git bisect  bad e5177ec77d503636d0b609671c9d408b981add17  # 10:56      0-  rcu: Not necessary to pass rcu_read_lock_held() to rcu_dereference_protected()
> git bisect good 8008e129dc90ff4f7a56cb033d6bd042afe3ed52  # 11:00     27+  rcu: Drive configuration directly from SMP and PREEMPT
> git bisect good e0f23060adfa3f27beaa7918eff70258b88471b6  # 11:04     27+  rcu: Update comments to reflect softirqs vs. kthreads
> git bisect  bad 965a002b4f1a458c5dcb334ec29f48a0046faa25  # 11:10      0-  rcu: Make TINY_RCU also use softirq for RCU_BOOST=n
> git bisect good 385680a9487d2f85382ad6d74e2a15837e47bfd9  # 11:20     27+  rcu: Add event-trace markers to TREE_RCU kthreads
> git bisect good 385680a9487d2f85382ad6d74e2a15837e47bfd9  # 11:24     81+  rcu: Add event-trace markers to TREE_RCU kthreads
> git bisect  bad 1d995963014cc2a847f9e18d972a9e845b5c27cd  # 11:24      0-  Merge remote-tracking branch 'stable/master'
> git bisect  bad 9e895ace5d82df8929b16f58e9f515f6d54ab82d  # 11:24      0-  Linux 3.10-rc7
> git bisect  bad e1a86578747376f08985627c84df088a5d0d1e92  # 11:27      9-  Add linux-next specific files for 20130621
> 
> Thanks,
> Fengguang


