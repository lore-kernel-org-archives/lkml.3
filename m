Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbaJaNPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:15:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:5652 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217AbaJaNPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:15:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="409098543"
Date: Fri, 31 Oct 2014 21:15:31 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 0 PID: 95 at kernel/sched/core.c:7312
 __might_sleep()
Message-ID: <20141031131531.GA28258@wfg-t540p.sh.intel.com>
References: <20141027130621.GA6336@wfg-t540p.sh.intel.com>
 <20141027133627.GH3337@twins.programming.kicks-ass.net>
 <20141027140325.GA15725@wfg-t540p.sh.intel.com>
 <20141031121008.GK10501@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031121008.GK10501@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 01:10:08PM +0100, Peter Zijlstra wrote:
> On Mon, Oct 27, 2014 at 10:03:25PM +0800, Fengguang Wu wrote:
> > On Mon, Oct 27, 2014 at 02:36:27PM +0100, Peter Zijlstra wrote:
> > > On Mon, Oct 27, 2014 at 09:06:21PM +0800, Fengguang Wu wrote:
> > > > Hi Peter,
> > > > 
> > > > FYI, this bug seems still there on v3.18-rc2.
> > > 
> > > Oh, right, I commented out that patch and the audit one because I was
> > > waiting for some feedback. Lemme go prod people.
> > 
> > One more warning, looks like triggered by thermal_apic_exit. Authors CCed.
> > 
> > [   29.107798] Running tests on trace events:
> > [   29.108302] Testing event thermal_apic_exit: 
> > [   29.143786] ------------[ cut here ]------------
> > [   29.144489] WARNING: CPU: 1 PID: 101 at kernel/sched/core.c:7187 __might_sleep+0xb9/0x100()
> > [   29.145781] do not call blocking ops when !TASK_RUNNING; state=1 set at [<c1e62e65>] event_test_thread+0x58/0x92
> > [   29.147139] Modules linked in:
> > [   29.147604] CPU: 1 PID: 101 Comm: test-events Not tainted 3.17.0-rc6-01872-ga0d2c46 #17
> > [   29.148646] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> > [   29.149969]  00000001 00000000 ffffffff cbc4fe5c c17ef50f cbc4fea4 00000001 00000065
> > [   29.151143]  cbc4fe78 c10689d7 00001c13 c10a5f59 00000001 00000000 00000029 cbc4fe90
> > [   29.152343]  c1068a1b 00000009 cbc4fe88 c1b5cc24 cbc4fea4 cbc4fec4 c10a5f59 c1b5c9b0
> > [   29.153511] Call Trace:
> > [   29.153859]  [<c17ef50f>] dump_stack+0x78/0xa8
> > [   29.154448]  [<c10689d7>] warn_slowpath_common+0x87/0xa0
> > [   29.155119]  [<c10a5f59>] ? __might_sleep+0xb9/0x100
> > [   29.155706]  [<c1068a1b>] warn_slowpath_fmt+0x2b/0x30
> > [   29.164357]  [<c10a5f59>] __might_sleep+0xb9/0x100
> > [   29.164935]  [<c1e62e65>] ? event_test_thread+0x58/0x92
> > [   29.165541]  [<c1e62e65>] ? event_test_thread+0x58/0x92
> > [   29.166154]  [<c17f8d4c>] down_read+0x1c/0x50
> > [   29.166660]  [<c1083a6f>] exit_signals+0x1f/0x1d0
> > [   29.167215]  [<c106bc1f>] do_exit+0x1bf/0x13a0
> > [   29.167748]  [<c1e62e0d>] ? event_test_stuff+0x6c/0x6c
> > [   29.168434]  [<c109bea8>] ? kthread_should_stop+0x8/0x20
> > [   29.169145]  [<c1e62e0d>] ? event_test_stuff+0x6c/0x6c
> > [   29.169829]  [<c109c3d4>] kthread+0xe4/0x110
> > [   29.170397]  [<c1e62e0d>] ? event_test_stuff+0x6c/0x6c
> > [   29.171082]  [<c10d0000>] ? push_dl_task+0x50/0x5a0
> > [   29.171759]  [<c17fbf21>] ret_from_kernel_thread+0x21/0x30
> > [   29.172496]  [<c109c2f0>] ? insert_kthread_work+0x110/0x110
> > [   29.173234] ---[ end trace 12bb28a4b269a09b ]---
> > [   29.173913] test-events (101) used greatest stack depth: 6712 bytes left
> 
> Hmm, confusing that, did that tree include:
>   fe0e01c77dd9 ("tracing: Robustify wait loop")

Nope. However I find some more bugs that happen around thermal_apic_exit. 
One DEBUG_LOCKS_WARN_ON, one "task blocked for more than 120 seconds",
and some RCU stalls. I just queued bisects for them. Hopefully we can
get some results tomorrow.
   
Thanks,
Fengguang
---

[   28.885927] Running tests on trace events:
[   28.886981] Testing event thermal_apic_exit:
[   28.920390] ------------[ cut here ]------------
[   28.921098] WARNING: CPU: 1 PID: 0 at kernel/locking/lockdep.c:3169 __lock_acquire+0xbab/0xe20() 
[   28.922604] DEBUG_LOCKS_WARN_ON(chain_key != 0)
[   28.923487]  0000000000000009 ffff88011f487d58 ffffffff82756dbb ffff88011f487da0
[   28.923487]  ffff88011f487d90 ffffffff810fc61b 0000000000000000 ffff8800b51196d0
[   28.923487]  0000000000000000 000000000000cb40 ffffffff834c6e40 ffff88011f487df0
[   28.923487] Call Trace:
[   28.923487]  <#DF>  [<ffffffff82756dbb>] dump_stack+0xc3/0x113
[   28.923487]  [<ffffffff810fc61b>] warn_slowpath_common+0xbb/0xf0
[   28.923487]  [<ffffffff810fc6e7>] warn_slowpath_fmt+0x57/0x70
[   28.923487]  [<ffffffff8118f1db>] __lock_acquire+0xbab/0xe20
[   28.923487]  [<ffffffff8118f56d>] lock_acquire+0x11d/0x1f0
[   28.923487]  [<ffffffff8113d8f0>] ? atomic_notifier_chain_unregister+0x120/0x120
[   28.923487]  [<ffffffff8113d953>] __atomic_notifier_call_chain+0x63/0xe0
[   28.923487]  [<ffffffff8113d8f0>] ? atomic_notifier_chain_unregister+0x120/0x120
[   28.923487]  [<ffffffff8113e67e>] notify_die+0x3e/0x50
[   28.923487]  [<ffffffff8100797a>] do_double_fault+0x3a/0x90
[   28.923487]  [<ffffffff8277665b>] double_fault+0x2b/0x30
[   28.923487]  [<ffffffff82775c80>] ? irq_return+0xe/0xe
[   28.923487]  [<ffffffff81066e66>] ? do_async_page_fault+0x16/0x130
[   28.923487]  <<EOE>>  <UNK> 
[   28.923487] ---[ end trace db5c924ecafb3949 ]---
[   28.923487] PANIC: double fault, error_code: 0xffffffffffffffff


[   41.312924] registered taskstats version 1
[   41.312958] Running tests on trace events:
[  241.367557] Testing event thermal_apic_exit:
[  241.367558] INFO: task swapper:1 blocked for more than 120 seconds.
[  241.367574]       Not tainted 3.17.0-rc5 #171
[  241.367576] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  241.367595] swapper         D ffff88003e607ee0     0     1      0 0x00000000
[  241.367620]  ffff88003810bc50 0000000000000046 ffff88003810bfd8 ffff880038100000
[  241.367625]  ffffffffa4966b40 ffff88003e608000 ffff880038100000 ffff88003810bbb0
[  241.367634]  ffffffffa2d6aa3a ffffffffa5fc0e50 0000000000017d30 ffff880038100000
[  241.367638] Call Trace:
[  241.367700]  [<ffffffffa2d6aa3a>] ? check_preemption_disabled+0x3d/0x166
[  241.367719]  [<ffffffffa26d569f>] ? __lock_acquire+0x842/0x1ba7
[  241.367745]  [<ffffffffa3be9614>] ? wait_for_common+0x3e/0x214
[  241.367751]  [<ffffffffa3be8bae>] schedule+0xa9/0xab
[  241.367757]  [<ffffffffa3bee02a>] schedule_timeout+0x3c/0x2f3
[  241.367762]  [<ffffffffa2d6aa3a>] ? check_preemption_disabled+0x3d/0x166
[  241.367776]  [<ffffffffa273e34c>] ? trace_preempt_on+0x70/0x157
[  241.367782]  [<ffffffffa3be9756>] wait_for_common+0x180/0x214
[  241.367787]  [<ffffffffa3bedff3>] ? schedule_timeout+0x5/0x2f3
[  241.367792]  [<ffffffffa3be9756>] ? wait_for_common+0x180/0x214
[  241.367800]  [<ffffffffa26bfdc4>] ? sched_fork+0x2a5/0x2a5
[  241.367805]  [<ffffffffa3be9957>] wait_for_completion+0x1d/0x1f
[  241.367817]  [<ffffffffa26b6bc4>] kthread_stop+0x114/0x1ff
[  241.367846]  [<ffffffffa571b5ee>] event_test_stuff+0x71/0x76
[  241.367852]  [<ffffffffa571b805>] event_trace_self_tests+0x212/0x6d7
[  241.367857]  [<ffffffffa571bdae>] ? test_work+0x64/0x64
[  241.367861]  [<ffffffffa571bdd8>] event_trace_self_tests_init+0x2a/0xd1
[  241.367863]  [<ffffffffa571bdae>] ? test_work+0x64/0x64
[  241.367872]  [<ffffffffa56fa5bf>] do_one_initcall+0x194/0x29c
[  241.367877]  [<ffffffffa26b5bb4>] ? parameq+0x22/0x24
[  241.367880]  [<ffffffffa26b600e>] ? parse_args+0x458/0x595
[  241.367883]  [<ffffffffa56fa7ef>] kernel_init_freeable+0x128/0x1ed
[  241.367892]  [<ffffffffa3bbd0a9>] ? rest_init+0xbd/0xbd
[  241.367895]  [<ffffffffa3bbd0b7>] kernel_init+0xe/0x152
[  241.367898]  [<ffffffffa3bf04ba>] ret_from_fork+0x7a/0xb0
[  241.367902]  [<ffffffffa3bbd0a9>] ? rest_init+0xbd/0xbd
[  241.367906] no locks held by swapper/1.
[  241.368005] INFO: task test-events:138 blocked for more than 120 seconds.
[  241.368033]       Not tainted 3.17.0-rc5 #171
[  241.368034] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  241.368042] test-events     D ffff88003e607db8     0   138      2 0x00000000
[  241.368047]  ffff88003e607bf0 0000000000000046 ffff88003e607fd8 ffff88003e608000
[  241.368050]  ffffffffa26be18a ffff8800383bc300 ffff88003e608000 ffff88003e607b50
[  241.368054]  ffffffffa2d6aa3a ffffffffa5fc56e0 0000000000061870 ffff88003e608000
[  241.368055] Call Trace:
[  241.368060]  [<ffffffffa26be18a>] ? finish_task_switch.constprop.57+0x7f/0x1ad
[  241.368063]  [<ffffffffa2d6aa3a>] ? check_preemption_disabled+0x3d/0x166
[  241.368066]  [<ffffffffa26d569f>] ? __lock_acquire+0x842/0x1ba7
[  241.368069]  [<ffffffffa3be9761>] ? wait_for_common+0x18b/0x214
[  241.368072]  [<ffffffffa3be8bae>] schedule+0xa9/0xab
[  241.368075]  [<ffffffffa3bee02a>] schedule_timeout+0x3c/0x2f3
[  241.368078]  [<ffffffffa2d6aa3a>] ? check_preemption_disabled+0x3d/0x166
[  241.368081]  [<ffffffffa273e34c>] ? trace_preempt_on+0x70/0x157
[  241.368084]  [<ffffffffa3be9756>] wait_for_common+0x180/0x214
[  241.368086]  [<ffffffffa3bedff3>] ? schedule_timeout+0x5/0x2f3
[  241.368089]  [<ffffffffa3be9756>] ? wait_for_common+0x180/0x214
[  241.368091]  [<ffffffffa26bfdc4>] ? sched_fork+0x2a5/0x2a5
[  241.368094]  [<ffffffffa3be9957>] wait_for_completion+0x1d/0x1f
[  241.368097]  [<ffffffffa26b1399>] flush_work+0x2cb/0x2dd
[  241.368099]  [<ffffffffa26acd95>] ? __queue_delayed_work+0x328/0x328
[  241.368103]  [<ffffffffa571bd4a>] ? event_test_thread+0x80/0x80
[  241.368105]  [<ffffffffa26b180c>] schedule_on_each_cpu+0x91/0xa0
[  241.368108]  [<ffffffffa571bcca>] ? event_trace_self_tests+0x6d7/0x6d7
[  241.368111]  [<ffffffffa571bd1e>] event_test_thread+0x54/0x80
[  241.368114]  [<ffffffffa26b640c>] kthread+0x129/0x131
[  241.368117]  [<ffffffffa26b62e3>] ? __kthread_parkme+0x81/0x81
[  241.368119]  [<ffffffffa3bf04ba>] ret_from_fork+0x7a/0xb0
[  241.368122]  [<ffffffffa26b62e3>] ? __kthread_parkme+0x81/0x81
[  241.368124] no locks held by test-events/138.
[  285.648094] usbcore: registered new interface driver brcmfmac
[  285.994088] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[  286.701734] OK


[  100.365786] Loaded X.509 cert 'Magrathea: Glacier signing key: ed92ccb96eed51867a2651631e3edca82d664510'
[  100.365799] Running tests on trace events:
[  155.533925] Testing event thermal_apic_exit: 
[  155.533925] INFO: rcu_sched self-detected stall on CPU
[  155.533925] Task dump for CPU 0:
[  155.533925] kworker/0:0     R running      0     4      2 0x00000008
[  155.533925] Workqueue: events_power_efficient fb_flashcursor
[  155.533925]  d1cc0090 d1cc0090 00000002 d1cc9c44 c66acbe5 c7d03385 00000000 00000004
[  155.533925]  00000002 00000008 00000000 c7e84220 00000086 d1cc9c58 c66b1836 c7d033d0
[  155.533925]  00000000 00000001 d1cc9c74 c66ea982 c7e84220 00000000 d23bd8e0 00000003
[  155.533925] Call Trace:
[  155.533925]  [<c66acbe5>] sched_show_task+0x155/0x2f0
[  155.533925]  [<c66b1836>] dump_cpu_task+0x36/0x40
[  155.533925]  [<c66ea982>] rcu_dump_cpu_stacks+0xb2/0x100
[  155.533925]  [<c66f04cc>] rcu_check_callbacks+0x64c/0xb80
[  155.533925]  [<c66f651c>] update_process_times+0x3c/0x80
[  155.533925]  [<c670ebbb>] tick_sched_timer+0x7b/0x320
[  155.533925]  [<c66f7069>] ? __run_hrtimer+0x1d9/0x740
[  155.533925]  [<c66f7069>] __run_hrtimer+0x1d9/0x740
[  155.533925]  [<c670eb40>] ? tick_init_highres+0x20/0x20
[  155.533925]  [<c66f8978>] hrtimer_interrupt+0x188/0x450
[  155.533925]  [<c664511c>] local_apic_timer_interrupt+0x4c/0x80
[  155.533925]  [<c7703b72>] smp_trace_apic_timer_interrupt+0xf2/0x3b4
[  155.533925]  [<c7703339>] trace_apic_timer_interrupt+0x39/0x40
[  155.533925]  [<c66d007b>] ? lock_stat_write+0x9b/0xd0
[  155.533925]  [<c66da58a>] ? console_unlock+0x59a/0x840
[  155.533925]  [<c6b60000>] ? rio_lock_device+0xd0/0x180
[  155.533925]  [<c6b792e0>] ? bit_putcs+0x650/0x650
[  155.533925]  [<c6b6f782>] fb_flashcursor+0x82/0x170
[  155.533925]  [<c6b792e0>] ? bit_putcs+0x650/0x650
[  155.533925]  [<c66923e0>] process_one_work+0x4e0/0xb40
[  155.533925]  [<c6692292>] ? process_one_work+0x392/0xb40
[  155.533925]  [<c6692db6>] worker_thread+0x376/0x910
[  155.533925]  [<c6692a40>] ? process_one_work+0xb40/0xb40
[  155.533925]  [<c669bfad>] kthread+0x10d/0x110
[  155.533925]  [<c6692a40>] ? process_one_work+0xb40/0xb40
[  155.533925]  [<c7702861>] ret_from_kernel_thread+0x21/0x30
[  155.533925]  [<c669bea0>] ? insert_kthread_work+0x110/0x110
[  155.776702] INFO: rcu_sched detected stalls on CPUs/tasks:
[  155.776702] Task dump for CPU 0:
[  155.776702] kworker/0:0     R running      0     4      2 0x00000008
[  155.776702] Workqueue: events_power_efficient fb_flashcursor
[  155.776702]  d1cc9e8c c6b6f782 00000000 00000007 00000000 00000002 00000720 c6b792e0
[  155.776702]  d3896000 00000000 00000000 00000000 d1cc9ee8 c66923e0 00000000 00000001
[  155.776702]  00000000 c6692292 00000000 00000000 d1cd0d00 00000000 d23c3100 d1c42780
[  155.776702] Call Trace:
[  155.776702]  [<c6b6f782>] ? fb_flashcursor+0x82/0x170
[  155.776702]  [<c6b792e0>] ? bit_putcs+0x650/0x650
[  155.776702]  [<c66923e0>] process_one_work+0x4e0/0xb40
[  155.776702]  [<c6692292>] ? process_one_work+0x392/0xb40
[  155.776702]  [<c6692db6>] worker_thread+0x376/0x910
[  155.776702]  [<c6692a40>] ? process_one_work+0xb40/0xb40
[  155.776702]  [<c669bfad>] kthread+0x10d/0x110
[  155.776702]  [<c6692a40>] ? process_one_work+0xb40/0xb40
[  155.776702]  [<c7702861>] ret_from_kernel_thread+0x21/0x30
[  155.776702]  [<c669bea0>] ? insert_kthread_work+0x110/0x110
[  187.487111] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0
[  187.743744] OK
[  188.029847] Testing event thermal_apic_entry: OK


[    8.501899] Loaded X.509 cert 'Magrathea: Glacier signing key: 96a5acfb117bc5a31236c72e2cba49d5cd9e5f83'
[    8.501953] Running tests on trace events:
[  111.222350] Testing event thermal_apic_exit: 
[  111.222350] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=100002 jiffies, g=-14, c=-15, q=24)
[  111.222350] Task dump for CPU 1:
[  111.222350] kworker/1:1     R running      0    17      2 0x00000008
[  111.222350] Workqueue: events tsc_refine_calibration_work
[  111.222350]  d3115ec4 c1068de2 00073ea2 00000000 00000246 000003e8 00000064 00000000
[  111.222350]  d3115ee4 c167b6d9 00000000 00000006 00000000 00000000 c1856315 d3115ef0
[  111.222350]  d3115f1c c1007bdf c1856315 00000a85 000001f7 91c7bf00 0016dc6c 2ac72b80
[  111.222350] Call Trace:
[  111.222350]  [<c1068de2>] ? vprintk_emit+0x34f/0x37a
[  111.222350]  [<c167b6d9>] printk+0x1c/0x1e
[  111.222350]  [<c1007bdf>] tsc_refine_calibration_work+0x177/0x197
[  111.222350]  [<c104a239>] process_one_work+0x162/0x2ce
[  111.222350]  [<c104ab68>] worker_thread+0x24c/0x320
[  111.222350]  [<c104a91c>] ? rescuer_thread+0x1f6/0x1f6
[  111.222350]  [<c104d9a9>] kthread+0xb1/0xb6
[  111.222350]  [<c1050000>] ? smpboot_thread_fn+0xf5/0x16c
[  111.222350]  [<c16880c1>] ret_from_kernel_thread+0x21/0x30
[  111.222350]  [<c104d8f8>] ? kthread_create_on_node+0x107/0x107
[  190.377909] OK
[  191.222265] Testing event thermal_apic_entry: OK
[  191.938659] Testing event threshold_apic_exit: OK

[   30.218843] registered taskstats version 1
[   30.218850] Running tests on trace events:
[  126.381421] Testing event thermal_apic_exit: 
[  126.381421] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=30002 jiffies, g=61, c=60, q=10)
[  126.381421] Task dump for CPU 1:
[  126.381421] kworker/u4:0    R running      0     6      2 0x00000008
[  126.381421] Workqueue: events_power_efficient fb_flashcursor
[  126.381421]  d2073ed8 c1062324 c2668580 00000400 00000000 00000477 014194e4 00000210
[  126.381421]  00000000 00000246 c1365f79 00000720 00000000 d2073f0c c13619fb 00000000
[  126.381421]  00000007 00000000 00000001 00000000 c1365f79 00000002 d222d000 d20376c0
[  126.381421] Call Trace:
[  126.381421]  [<c1062324>] ? console_unlock+0x305/0x3ce
[  126.381421]  [<c1365f79>] ? bit_update_start+0x36/0x36
[  126.381421]  [<c13619fb>] fb_flashcursor+0xe5/0xf0
[  126.381421]  [<c1365f79>] ? bit_update_start+0x36/0x36
[  126.381421]  [<c10477cb>] process_one_work+0x16e/0x2e1
[  126.381421]  [<c104795e>] process_scheduled_works+0x20/0x26
[  126.381421]  [<c1047bd1>] worker_thread+0x26d/0x32f
[  126.381421]  [<c1047964>] ? process_scheduled_works+0x26/0x26
[  126.381421]  [<c104b171>] kthread+0xb1/0xb6
[  126.381421]  [<c1040000>] ? prepare_signal+0x9b/0x1d4
[  126.381421]  [<c1e75f41>] ret_from_kernel_thread+0x21/0x30
[  126.381421]  [<c104b0c0>] ? __kthread_parkme+0x59/0x59
[  426.847647] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=120007 jiffies, g=61, c=60, q=14)
[  426.847648] Task dump for CPU 1:
[  426.847650] kworker/u4:0    R running      0     6      2 0x00000008
[  426.847650] Workqueue: events_power_efficient fb_flashcursor
[  426.847650]  d2073ed8 c1062324 c2668580 00000400 00000000 0000048c 014194e4 0000026b
[  426.847650]  00000000 00000246 c1365f79 00000720 00000000 d2073f0c c13619fb 00000000
[  426.847650]  00000007 00000000 00000001 00000000 c1365f79 00000002 d222d000 d20376c0
[  426.847650] Call Trace:
[  426.847650]  [<c1062324>] ? console_unlock+0x305/0x3ce
[  426.847650]  [<c1365f79>] ? bit_update_start+0x36/0x36
[  426.847650]  [<c13619fb>] fb_flashcursor+0xe5/0xf0
[  426.847650]  [<c1365f79>] ? bit_update_start+0x36/0x36
[  426.847650]  [<c10477cb>] process_one_work+0x16e/0x2e1
[  426.847650]  [<c104795e>] process_scheduled_works+0x20/0x26
[  426.847650]  [<c1047bd1>] worker_thread+0x26d/0x32f
[  426.847650]  [<c1047964>] ? process_scheduled_works+0x26/0x26
[  426.847650]  [<c104b171>] kthread+0xb1/0xb6
[  426.847650]  [<c1040000>] ? prepare_signal+0x9b/0x1d4
[  426.847650]  [<c1e75f41>] ret_from_kernel_thread+0x21/0x30
[  426.847650]  [<c104b0c0>] ? __kthread_parkme+0x59/0x59
[  727.367170] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=210012 jiffies, g=61, c=60, q=14)
[  727.367170] Task dump for CPU 1:
[  727.367170] kworker/u4:0    R running      0     6      2 0x00000008
[  727.367170] Workqueue: events_power_efficient fb_flashcursor
[  727.367170]  d2073ed8 c1062324 c2668580 00000400 00000000 000004a0 014194e4 000002ed
[  727.367170]  00000000 00000246 c1365f79 00000720 00000000 d2073f0c c13619fb 00000000
[  727.367170]  00000007 00000000 00000001 00000000 c1365f79 00000002 d222d000 d20376c0
[  727.367170] Call Trace:
[  727.367170]  [<c1062324>] ? console_unlock+0x305/0x3ce
[  727.367170]  [<c1365f79>] ? bit_update_start+0x36/0x36
[  727.367170]  [<c13619fb>] fb_flashcursor+0xe5/0xf0
[  727.367170]  [<c1365f79>] ? bit_update_start+0x36/0x36
[  727.367170]  [<c10477cb>] process_one_work+0x16e/0x2e1
[  727.367170]  [<c104795e>] process_scheduled_works+0x20/0x26
[  727.367170]  [<c1047bd1>] worker_thread+0x26d/0x32f
[  727.367170]  [<c1047964>] ? process_scheduled_works+0x26/0x26
[  727.367170]  [<c104b171>] kthread+0xb1/0xb6
[  727.367170]  [<c1040000>] ? prepare_signal+0x9b/0x1d4
[  727.367170]  [<c1e75f41>] ret_from_kernel_thread+0x21/0x30
[  727.367170]  [<c104b0c0>] ? __kthread_parkme+0x59/0x59
[ 1027.723415] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=300017 jiffies, g=61, c=60, q=14)
[ 1027.723415] Task dump for CPU 1:
[ 1027.723415] kworker/u4:0    R running      0     6      2 0x00000008
[ 1027.723415] Workqueue: events_power_efficient fb_flashcursor
[ 1027.723415]  d2073ed8 c1062324 c2668580 00000400 00000000 000004b4 014194e4 00000499
[ 1027.723415]  00000000 00000246 c1365f79 00000720 00000000 d2073f0c c13619fb 00000000
[ 1027.723415]  00000007 00000000 00000001 00000000 c1365f79 00000002 d222d000 d20376c0
[ 1027.723415] Call Trace:
[ 1027.723415]  [<c1062324>] ? console_unlock+0x305/0x3ce
[ 1027.723415]  [<c1365f79>] ? bit_update_start+0x36/0x36
[ 1027.723415]  [<c13619fb>] fb_flashcursor+0xe5/0xf0
[ 1027.723415]  [<c1365f79>] ? bit_update_start+0x36/0x36
[ 1027.723415]  [<c10477cb>] process_one_work+0x16e/0x2e1
[ 1027.723415]  [<c104795e>] process_scheduled_works+0x20/0x26
[ 1027.723415]  [<c1047bd1>] worker_thread+0x26d/0x32f
[ 1027.723415]  [<c1047964>] ? process_scheduled_works+0x26/0x26
[ 1027.723415]  [<c104b171>] kthread+0xb1/0xb6
[ 1027.723415]  [<c1040000>] ? prepare_signal+0x9b/0x1d4
[ 1027.723415]  [<c1e75f41>] ret_from_kernel_thread+0x21/0x30
[ 1027.723415]  [<c104b0c0>] ? __kthread_parkme+0x59/0x59
[ 1047.876173] OK
[ 1048.377837] Testing event thermal_apic_entry: OK
[ 1048.845826] Testing event threshold_apic_exit: OK


[   41.523647] Ring buffer PASSED!
[   41.523862] Running tests on trace events:
[   41.528015] Testing event thermal_apic_exit: 
[   41.528015] INFO: rcu_preempt self-detected stall on CPU { 0}  (t=43492 jiffies g=-149 c=-150 q=0)
[   41.528015] Task dump for CPU 0:
[   41.528015] kworker/u2:1    R  running task        0   148      2 0x00080000
[   41.528015] Workqueue: events_power_efficient fb_flashcursor
[   41.528015]  0000000000000002 ffff880013a03e28 ffffffff810e4e36 0000000000000000
[   41.528015]  ffffffff82825b40 ffff880013a03e48 ffffffff810e84dc 0000000000000003
[   41.528015]  ffffffff82825b40 ffff880013a03e78 ffffffff811137ea ffffffff82825b40
[   41.528015] Call Trace:
[   41.528015]  <IRQ>  [<ffffffff810e4e36>] sched_show_task+0xe8/0xed
[   41.528015]  [<ffffffff810e84dc>] dump_cpu_task+0x3a/0x3e
[   41.528015]  [<ffffffff811137ea>] rcu_dump_cpu_stacks+0x9a/0xbf
[   41.528015]  [<ffffffff811199be>] rcu_check_callbacks+0x2e0/0x8ab
[   41.528015]  [<ffffffff8111ff83>] update_process_times+0x3e/0x7e
[   41.528015]  [<ffffffff81131248>] tick_nohz_handler+0x121/0x198
[   41.528015]  [<ffffffff81031273>] local_apic_timer_interrupt+0x6b/0x6f
[   41.528015]  [<ffffffff81f4bbcc>] smp_trace_apic_timer_interrupt+0xb3/0x14c
[   41.528015]  [<ffffffff81f4a7cd>] trace_apic_timer_interrupt+0x6d/0x80
[   41.528015]  <EOI>  [<ffffffff81103554>] ? arch_local_irq_restore+0x6/0xd
[   41.528015]  [<ffffffff8110577c>] console_unlock+0x44f/0x530
[   41.528015]  [<ffffffff815dd995>] ? bit_putcs+0x57c/0x57c
[   41.528015]  [<ffffffff815d66c5>] fb_flashcursor+0x14a/0x159
[   41.528015]  [<ffffffff810cf6c1>] process_one_work+0x2fa/0x4ca
[   41.528015]  [<ffffffff810cfd4d>] worker_thread+0x48d/0x5c1
[   41.528015]  [<ffffffff810cf8c0>] ? process_scheduled_works+0x2f/0x2f
[   41.528015]  [<ffffffff810cf8c0>] ? process_scheduled_works+0x2f/0x2f
[   41.528015]  [<ffffffff810d64fb>] kthread+0xe4/0xec
[   41.528015]  [<ffffffff810d6417>] ? __kthread_parkme+0x86/0x86
[   41.528015]  [<ffffffff81f4983c>] ret_from_fork+0x7c/0xb0
[   41.528015]  [<ffffffff810d6417>] ? __kthread_parkme+0x86/0x86
[  215.496161] OK
[  237.403862] Testing event thermal_apic_entry: OK
[  237.412177] Testing event threshold_apic_exit: OK


[  136.567395] Testing event thermal_apic_exit:
[  136.567396] atkbd serio0: Spurious ACK on isa0060/serio0. Some program might be trying to access hardware directly.
[  136.568519] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[  226.816301] INFO: rcu_sched self-detected stall on CPU
[  226.816301] Task dump for CPU 1:
[  226.816301] kworker/u4:2    R running      0   110      2 0x00000008
[  226.816301] Workqueue: events_power_efficient fb_flashcursor
[  226.816301]  ce813500 ce813500 d0c2fea4 d1c6fbdc d2c6bf40 00000000 0000006e 00000002
[  226.816301]  00000008 00000001 00000046 d0c2feb8 d1c724b6 d2c6bf85 00000001 00000002
[  226.816301]  d0c2fed0 d1c99241 d2de8700 d2de8700 d2de8700 d1bf7940 d0c2ff18 d1c9d25d
[  226.816301] Call Trace:
[  226.816301]  [<d1c6fbdc>] sched_show_task+0xfc/0x170
[  226.816301]  [<d1c724b6>] dump_cpu_task+0x36/0x40
[  226.816301]  [<d1c99241>] rcu_dump_cpu_stacks+0x71/0xb0
[  226.816301]  [<d1c9d25d>] rcu_check_callbacks+0x41d/0x620
[  226.816301]  [<d1ca12cc>] update_process_times+0x3c/0x60
[  226.816301]  [<d1cb1754>] tick_nohz_handler+0x74/0x110
[  226.816301]  [<d1c4ee40>] ? _local_bh_enable+0x50/0x50
[  226.816301]  [<d1c2b2c1>] local_apic_timer_interrupt+0x31/0x60
[  226.816301]  [<d1c4ee40>] ? _local_bh_enable+0x50/0x50
[  226.816301]  [<d28a9de9>] smp_trace_apic_timer_interrupt+0x39/0xbc
[  226.816301]  [<d28a97cd>] trace_apic_timer_interrupt+0x2d/0x34
[  226.816301]  [<d1c4ee40>] ? _local_bh_enable+0x50/0x50
[  226.816301]  [<d1ca007b>] ? perf_trace_timer_expire_entry+0x3b/0xc0
[  226.816301]  [<d1c4eead>] ? __do_softirq+0x6d/0x260
[  226.816301]  [<d1c4ee40>] ? _local_bh_enable+0x50/0x50
[  226.816301]  [<d1c04106>] do_softirq_own_stack+0x26/0x30
[  226.816301]  <IRQ>  [<d1c4f2d5>] irq_exit+0x95/0xa0
[  226.816301]  [<d1c28bcc>] smp_trace_reschedule_interrupt+0x3c/0xc0
[  226.816301]  [<d28a9595>] trace_reschedule_interrupt+0x2d/0x34
[  226.816301]  [<d1c8007b>] ? print_cpu+0x9b/0xc90
[  226.816301]  [<d1c8db3a>] ? console_unlock+0x45a/0x520
[  226.816301]  [<d20f8306>] ? cursor_timer_handler+0x16/0x40
[  226.816301]  [<d20fe680>] ? bit_clear+0x100/0x100
[  226.816301]  [<d20f84aa>] fb_flashcursor+0x4a/0x100
[  226.816301]  [<d20fe680>] ? bit_clear+0x100/0x100
[  226.816301]  [<d1c5f5af>] process_one_work+0x19f/0x490
[  226.816301]  [<d1c5f53a>] ? process_one_work+0x12a/0x490
[  226.816301]  [<d1c5f8d9>] worker_thread+0x39/0x440
[  226.816301]  [<d1c5f8a0>] ? process_one_work+0x490/0x490
[  226.816301]  [<d1c64848>] kthread+0xa8/0xc0
[  226.816301]  [<d28a8e01>] ret_from_kernel_thread+0x21/0x30
[  226.816301]  [<d1c647a0>] ? __kthread_unpark+0x60/0x60
[  374.822907] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0 
[  374.827405] OK
[  374.827411] Testing event thermal_apic_entry: OK
