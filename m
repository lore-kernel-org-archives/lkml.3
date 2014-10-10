Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaJJNlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:41:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27815 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaJJNlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:41:15 -0400
Message-ID: <5437E1B3.6020409@oracle.com>
Date: Fri, 10 Oct 2014 09:40:03 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: "David S. Miller" <davem@davemloft.net>, tgraf@suug.ch,
        LKML <linux-kernel@vger.kernel.org>
Subject: rhashtable: hang while running tests on boot
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm sometimes observing the following hang during boot:

[    6.693025] Running resizable hashtable tests...
[    6.693750]   Adding 2048 keys
[    7.344733]   Traversal complete: counted=2048, nelems=2048, entries=2048
[    7.349160]   Table expansion iteration 0...
[    7.391345]   Verifying lookups...
[    7.395200]   Table expansion iteration 1...
[    7.451080]   Verifying lookups...
[    7.454615]   Table expansion iteration 2...
[    7.514360]   Verifying lookups...
[    7.516023]   Table expansion iteration 3...
[    7.563620]   Verifying lookups...
[    7.569623]   Table shrinkage iteration 0...
[    7.611140]   Verifying lookups...
[    7.617687]   Table shrinkage iteration 1...
[    7.670713]   Verifying lookups...
[    7.677038]   Table shrinkage iteration 2...
[    7.730366]   Verifying lookups...
[    7.735700]   Table shrinkage iteration 3...
[    7.790214]   Verifying lookups...
[    7.796491]   Deleting 2048 keys
[ 2406.630096] INFO: task swapper/0:1 blocked for more than 1200 seconds.
[ 2406.630846]       Not tainted 3.17.0-next-20141009-sasha-00052-gb585dd2-dirty #1374
[ 2406.632329] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2406.633652] swapper/0       D ffffffff986f3040 12352     1      0 0x00000000
[ 2406.634910]  ffff8800681af9b8 0000000000000002 ffff8800681af958 ffffffff91100014
[ 2406.636287]  ffff880479338000 ffff8800681ac010 ffff8800681ac000 00000001e6f9f550
[ 2406.637611]  ffff8804e7310000 ffff880479338000 00000000001e3580 0000000000000000
[ 2406.638934] Call Trace:
[ 2406.639505] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[ 2406.640030] schedule (kernel/sched/core.c:2895)
[ 2406.640933] schedule_timeout (kernel/time/timer.c:1476)
[ 2406.641974] ? mark_held_locks (kernel/locking/lockdep.c:2513)
[ 2406.643063] ? wait_for_completion (kernel/sched/completion.c:75 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.644131] ? get_parent_ip (kernel/sched/core.c:2606)
[ 2406.645074] wait_for_completion (include/linux/spinlock.h:334 kernel/sched/completion.c:76 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.646116] ? wake_up_state (kernel/sched/core.c:2990)
[ 2406.647142] ? kfree_call_rcu (kernel/rcu/tree_plugin.h:651)
[ 2406.648139] wait_rcu_gp (kernel/rcu/update.c:298 kernel/rcu/update.c:229)
[ 2406.649231] ? rcu_read_lock_held (kernel/rcu/update.c:212)
[ 2406.650021] ? wait_for_completion (kernel/sched/completion.c:64 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.651185] synchronize_rcu (kernel/rcu/tree_plugin.h:682)
[ 2406.652235] rhashtable_shrink (lib/rhashtable.c:130 lib/rhashtable.c:334)
[ 2406.653288] ? rht_grow_above_75 (lib/rhashtable.c:151)
[ 2406.654333] rhashtable_remove_pprev (lib/rhashtable.c:394)
[ 2406.655518] rhashtable_remove (lib/rhashtable.c:437)
[ 2406.656547] test_rht_init (lib/rhashtable.c:747 lib/rhashtable.c:785)
[ 2406.657492] ? jhash2 (lib/hash.c:23)
[ 2406.658369] ? lockdep_rht_mutex_is_held (lib/rhashtable.c:139)
[ 2406.660018] ? rht_grow_above_75 (lib/rhashtable.c:151)
[ 2406.661027] ? rht_shrink_below_30 (lib/rhashtable.c:617)
[ 2406.662085] ? jhash2 (lib/hash.c:23)
[ 2406.663030] ? lockdep_rht_mutex_is_held (lib/rhashtable.c:139)
[ 2406.664022] ? rht_grow_above_75 (lib/rhashtable.c:151)
[ 2406.664920] ? rht_shrink_below_30 (lib/rhashtable.c:617)
[ 2406.665991] ? test_rht_lookup (lib/rhashtable.c:762)
[ 2406.667127] do_one_initcall (init/main.c:791)
[ 2406.668162] kernel_init_freeable (init/main.c:856 init/main.c:864 init/main.c:883 init/main.c:1004)
[ 2406.669291] ? rest_init (init/main.c:931)
[ 2406.670020] kernel_init (init/main.c:936)
[ 2406.671017] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.671976] ? rest_init (init/main.c:931)
[ 2406.672944] no locks held by swapper/0/1.
[ 2406.673705]   task                        PC stack   pid father
[ 2406.674838] swapper/0       D ffffffff986f3040 12352     1      0 0x00000000
[ 2406.676114]  ffff8800681af9b8 0000000000000002 ffff8800681af958 ffffffff91100014
[ 2406.677474]  ffff880479338000 ffff8800681ac010 ffff8800681ac000 00000001e6f9f550
[ 2406.679056]  ffff8804e7310000 ffff880479338000 00000000001e3580 0000000000000000
[ 2406.680948] Call Trace:
[ 2406.681378] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[ 2406.682346] schedule (kernel/sched/core.c:2895)
[ 2406.683358] schedule_timeout (kernel/time/timer.c:1476)
[ 2406.684565] ? mark_held_locks (kernel/locking/lockdep.c:2513)
[ 2406.685561] ? wait_for_completion (kernel/sched/completion.c:75 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.686636] ? get_parent_ip (kernel/sched/core.c:2606)
[ 2406.687821] wait_for_completion (include/linux/spinlock.h:334 kernel/sched/completion.c:76 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.688995] ? wake_up_state (kernel/sched/core.c:2990)
[ 2406.690019] ? kfree_call_rcu (kernel/rcu/tree_plugin.h:651)
[ 2406.691270] wait_rcu_gp (kernel/rcu/update.c:298 kernel/rcu/update.c:229)
[ 2406.692247] ? rcu_read_lock_held (kernel/rcu/update.c:212)
[ 2406.693371] ? wait_for_completion (kernel/sched/completion.c:64 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.694499] synchronize_rcu (kernel/rcu/tree_plugin.h:682)
[ 2406.695586] rhashtable_shrink (lib/rhashtable.c:130 lib/rhashtable.c:334)
[ 2406.696647] ? rht_grow_above_75 (lib/rhashtable.c:151)
[ 2406.697695] rhashtable_remove_pprev (lib/rhashtable.c:394)
[ 2406.698783] rhashtable_remove (lib/rhashtable.c:437)
[ 2406.700021] test_rht_init (lib/rhashtable.c:747 lib/rhashtable.c:785)
[ 2406.701112] ? jhash2 (lib/hash.c:23)
[ 2406.702058] ? lockdep_rht_mutex_is_held (lib/rhashtable.c:139)
[ 2406.703493] ? rht_grow_above_75 (lib/rhashtable.c:151)
[ 2406.704609] ? rht_shrink_below_30 (lib/rhashtable.c:617)
[ 2406.705753] ? jhash2 (lib/hash.c:23)
[ 2406.706696] ? lockdep_rht_mutex_is_held (lib/rhashtable.c:139)
[ 2406.707970] ? rht_grow_above_75 (lib/rhashtable.c:151)
[ 2406.709102] ? rht_shrink_below_30 (lib/rhashtable.c:617)
[ 2406.710019] ? test_rht_lookup (lib/rhashtable.c:762)
[ 2406.711156] do_one_initcall (init/main.c:791)
[ 2406.712199] kernel_init_freeable (init/main.c:856 init/main.c:864 init/main.c:883 init/main.c:1004)
[ 2406.713297] ? rest_init (init/main.c:931)
[ 2406.714252] kernel_init (init/main.c:936)
[ 2406.715272] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.716235] ? rest_init (init/main.c:931)
[ 2406.717188] kthreadd        S ffffffff986f3040 13008     2      0 0x00000000
[ 2406.718503]  ffff8800681b7e28 0000000000000002 ffffffff911f8a74 ffff880000000000
[ 2406.720350]  ffff8800681c0000 ffff8800681b4010 ffff8800681b4000 00000001d3fa3046
[ 2406.721759]  ffff88032ef48000 ffff8800681c0000 ffff8800681b7e28 0000000000000000
[ 2406.723184] Call Trace:
[ 2406.723649] ? kthreadd (include/linux/spinlock.h:349 kernel/kthread.c:514)
[ 2406.724597] schedule (kernel/sched/core.c:2895)
[ 2406.725459] kthreadd (kernel/kthread.c:498)
[ 2406.726356] ? ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.727409] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 2406.728533] ? kthread_create_on_cpu (kernel/kthread.c:484)
[ 2406.729606] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.730022] ? kthread_create_on_cpu (kernel/kthread.c:484)
[ 2406.731174] ksoftirqd/0     S ffffffff986f3040 14128     3      2 0x00000000
[ 2406.732477]  ffff880068203d88 0000000000000002 ffff880068203d48 0000000000000000
[ 2406.733812]  ffff8800681c3000 ffff880068200010 ffff880068200000 0000021672e3f5fb
[ 2406.735201]  ffffffff97a3b580 ffff8800681c3000 ffff880068203d78 0000000000000000
[ 2406.736519] Call Trace:
[ 2406.736957] schedule (kernel/sched/core.c:2895)
[ 2406.737835] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2406.738973] ? tasklet_init (kernel/softirq.c:646)
[ 2406.740019] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2406.741125] kthread (kernel/kthread.c:207)
[ 2406.742100] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.743239] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.744375] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.745291] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.746408] kworker/0:0     S ffffffff986f3040 13376     4      2 0x00000000
[ 2406.747823]  ffff880068227d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2406.750011]  ffff880068228000 ffff880068224010 ffff880068224000 00000001a2994cfe
[ 2406.751406]  ffff880066ccb000 ffff880068228000 ffff880068227d48 0000000000000000
[ 2406.752737] Call Trace:
[ 2406.753171] ? worker_thread (kernel/workqueue.c:2176)
[ 2406.754127] schedule (kernel/sched/core.c:2895)
[ 2406.754971] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2406.755983] ? process_one_work (kernel/workqueue.c:2100)
[ 2406.757037] kthread (kernel/kthread.c:207)
[ 2406.757936] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.758992] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.759966] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.760017] kworker/0:0H    S ffffffff986f3040 14144     5      2 0x00000000
[ 2406.761280]  ffff88006823bd58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2406.762698]  ffff88006822b000 ffff880068238010 ffff880068238000 000000018eea5296
[ 2406.764069]  ffffffff97a3b580 ffff88006822b000 ffff88006823bd48 0000000000000000
[ 2406.765452] Call Trace:
[ 2406.765913] ? worker_thread (kernel/workqueue.c:2176)
[ 2406.766717] schedule (kernel/sched/core.c:2895)
[ 2406.767320] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2406.768183] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2406.770019] ? process_one_work (kernel/workqueue.c:2100)
[ 2406.771089] kthread (kernel/kthread.c:207)
[ 2406.771964] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.773037] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.773942] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.774986] kworker/u64:0   S ffffffff986f3040 12240     6      2 0x00000000
[ 2406.775896]  ffff880068253d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2406.776726]  ffff880068248000 ffff880068250010 ffff880068250000 00000001df873686
[ 2406.778049]  ffff880176ef0000 ffff880068248000 ffff880068253d48 0000000000000000
[ 2406.779414] Call Trace:
[ 2406.780020] ? worker_thread (kernel/workqueue.c:2176)
[ 2406.781025] schedule (kernel/sched/core.c:2895)
[ 2406.781896] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2406.782878] ? process_one_work (kernel/workqueue.c:2100)
[ 2406.784002] kthread (kernel/kthread.c:207)
[ 2406.784897] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.785955] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.786964] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.788082] kworker/u65:0   S ffffffff986f3040 14176     7      2 0x00000000
[ 2406.789383]  ffff880068257d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2406.790591]  ffff88006824b000 ffff880068254010 ffff880068254000 000000018c0b7509
[ 2406.791974]  ffffffff97a3b580 ffff88006824b000 ffff880068257d48 0000000000000000
[ 2406.793295] Call Trace:
[ 2406.793733] ? worker_thread (kernel/workqueue.c:2176)
[ 2406.794692] schedule (kernel/sched/core.c:2895)
[ 2406.795580] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2406.796503] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2406.797445] ? process_one_work (kernel/workqueue.c:2100)
[ 2406.798467] kthread (kernel/kthread.c:207)
[ 2406.799439] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.800019] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.800943] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.801992] rcu_preempt     S ffffffff986f3040 13120     8      2 0x00000000
[ 2406.803334]  ffff88006826bc78 0000000000000002 ffff88006826bc18 0000000000000000
[ 2406.804699]  ffff880068260000 ffff880068268010 ffff880068268000 00000001e6f8a541
[ 2406.806010]  ffffffff97a3b580 ffff880068260000 ffffffffffffff71 0000000000000000
[ 2406.807392] Call Trace:
[ 2406.807831] schedule (kernel/sched/core.c:2895)
[ 2406.808691] rcu_gp_kthread (kernel/rcu/tree.c:1796 (discriminator 13))
[ 2406.810020] ? check_chain_key (kernel/locking/lockdep.c:2190)
[ 2406.811131] ? abort_exclusive_wait (kernel/sched/wait.c:291)
[ 2406.812224] ? rcu_process_callbacks (kernel/rcu/tree.c:1780)
[ 2406.813345] kthread (kernel/kthread.c:207)
[ 2406.814224] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.815359] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.816312] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.817423] rcu_sched       S ffffffff986f3040 13984     9      2 0x00000000
[ 2406.818710]  ffff880068273c78 0000000000000006 ffff880068273c18 0000000000000000
[ 2406.820345]  ffff880068263000 ffff880068270010 ffff880068270000 000000003bca266a
[ 2406.821695]  ffff880068278000 ffff880068263000 fffffffffffffed4 0000000000000000
[ 2406.823092] Call Trace:
[ 2406.823530] ? rcu_process_callbacks (kernel/rcu/tree.c:1780)
[ 2406.824622] schedule (kernel/sched/core.c:2895)
[ 2406.825506] rcu_gp_kthread (kernel/rcu/tree.c:1796 (discriminator 13))
[ 2406.826510] ? check_chain_key (kernel/locking/lockdep.c:2190)
[ 2406.827585] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 2406.828691] ? trace_hardirqs_on_caller ()
[ 2406.830020] ? abort_exclusive_wait (kernel/sched/wait.c:291)
[ 2406.831093] ? rcu_process_callbacks (kernel/rcu/tree.c:1780)
[ 2406.832231] kthread (kernel/kthread.c:207)
[ 2406.833131] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.834179] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.835093] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.836254] rcu_bh          S ffffffff986f3040 13984    10      2 0x00000000
[ 2406.837531]  ffff880068277c78 0000000000000006 ffff880068277c18 0000000000000000
[ 2406.838916]  ffff880068278000 ffff880068274010 ffff880068274000 000000003bd53d9d
[ 2406.840343]  ffff88006827b000 ffff880068278000 fffffffffffffed4 0000000000000000
[ 2406.841688] Call Trace:
[ 2406.842132] ? rcu_process_callbacks (kernel/rcu/tree.c:1780)
[ 2406.843304] schedule (kernel/sched/core.c:2895)
[ 2406.844150] rcu_gp_kthread (kernel/rcu/tree.c:1796 (discriminator 13))
[ 2406.845118] ? check_chain_key (kernel/locking/lockdep.c:2190)
[ 2406.846114] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 2406.847262] ? trace_hardirqs_on_caller ()
[ 2406.848383] ? abort_exclusive_wait (kernel/sched/wait.c:291)
[ 2406.849448] ? rcu_process_callbacks (kernel/rcu/tree.c:1780)
[ 2406.850018] kthread (kernel/kthread.c:207)
[ 2406.850961] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.852046] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.852986] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.854031] rcuc/0          S ffffffff986f3040 13648    11      2 0x00000000
[ 2406.855296]  ffff880068283d88 0000000000000002 ffff880068283d48 ffffffff00000000
[ 2406.856624]  ffff88006827b000 ffff880068280010 ffff880068280000 00000001a568403f
[ 2406.857953]  ffff8800681c3000 ffff88006827b000 ffff88006827b000 0000000000000000
[ 2406.860066] Call Trace:
[ 2406.860524] schedule (kernel/sched/core.c:2895)
[ 2406.861367] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2406.862384] ? rcu_sysidle_cb ()
[ 2406.863370] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2406.864330] kthread (kernel/kthread.c:207)
[ 2406.865180] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.866230] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.867329] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.868380] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.869439] rcub/0          S ffffffff986f3040 14176    12      2 0x00000000
[ 2406.870782]  ffff880068287d58 0000000000000002 0000000000000001 ffff880000000000
[ 2406.872218]  ffff880068288000 ffff880068284010 ffff880068284000 000000003cdded68
[ 2406.873591]  ffff880479338000 ffff880068288000 0000000000000282 0000000000000000
[ 2406.874954] Call Trace:
[ 2406.875434] schedule (kernel/sched/core.c:2895)
[ 2406.876286] rcu_boost_kthread ()
[ 2406.877294] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2406.878226] ? rcu_gp_kthread ()
[ 2406.879291] kthread (kernel/kthread.c:207)
[ 2406.880021] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.881066] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.881994] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.883163] rcub/1          S ffffffff986f3040 14176    13      2 0x00000000
[ 2406.884435]  ffff880068293d58 0000000000000002 0000000000000001 ffff880000000000
[ 2406.885755]  ffff88006828b000 ffff880068290010 ffff880068290000 000000003ce9d682
[ 2406.887136]  ffff880479338000 ffff88006828b000 0000000000000282 0000000000000000
[ 2406.888471] Call Trace:
[ 2406.888910] schedule (kernel/sched/core.c:2895)
[ 2406.890020] rcu_boost_kthread ()
[ 2406.891082] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2406.892122] ? rcu_gp_kthread ()
[ 2406.893195] kthread (kernel/kthread.c:207)
[ 2406.894128] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.895298] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.896247] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.897305] migration/0     S ffffffff986f3040 14128    14      2 0x00000000
[ 2406.898588]  ffff880068297d88 0000000000000002 ffff880068297d28 ffffffff00000000
[ 2406.900071]  ffff880068298000 ffff880068294010 ffff880068294000 000000009371a6f4
[ 2406.901487]  ffff880479338000 ffff880068298000 ffff880068297d78 0000000000000000
[ 2406.902905] Call Trace:
[ 2406.903435] schedule (kernel/sched/core.c:2895)
[ 2406.904321] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2406.905389] ? res_counter_memparse_write_strategy ()
[ 2406.906684] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2406.907800] kthread (kernel/kthread.c:207)
[ 2406.908693] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.909769] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.910019] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.911003] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.912102] watchdog/0      S ffffffff986f3040 14032    15      2 0x00000000
[ 2406.913376]  ffff880068377d88 0000000000000002 0000000000000000 ffff880000000000
[ 2406.914777]  ffff88006829b000 ffff880068374010 ffff880068374000 0000022f117abd81
[ 2406.916147]  ffffffff97a3b580 ffff88006829b000 ffff88006829b000 0000000000000000
[ 2406.917548] Call Trace:
[ 2406.918007] schedule (kernel/sched/core.c:2895)
[ 2406.919008] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2406.920023] ? touch_nmi_watchdog ()
[ 2406.921062] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2406.922055] kthread (kernel/kthread.c:207)
[ 2406.922981] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.924038] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.925131] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.926104] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.927252] watchdog/1      S ffffffff986f3040 13536    16      2 0x00000000
[ 2406.928550]  ffff880108f93d88 0000000000000002 0000000000000001 ffff880100000000
[ 2406.930911]  ffff880108f83000 ffff880108f90010 ffff880108f90000 0000022f150fba94
[ 2406.932412]  ffff880068378000 ffff880108f83000 ffff880108f83000 0000000000000000
[ 2406.933786] Call Trace:
[ 2406.934230] schedule (kernel/sched/core.c:2895)
[ 2406.935100] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2406.936203] ? touch_nmi_watchdog ()
[ 2406.937257] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2406.938300] kthread (kernel/kthread.c:207)
[ 2406.939281] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.940019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.941126] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.942069] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.943205] migration/1     S ffffffff986f3040 14128    17      2 0x00000000
[ 2406.944480]  ffff880108f97d88 0000000000000002 ffff880108f97d28 ffffffff00000000
[ 2406.945848]  ffff880108f98000 ffff880108f94010 ffff880108f94000 000000009e15dc81
[ 2406.947258]  ffff880068378000 ffff880108f98000 ffff880108f97d78 0000000000000000
[ 2406.948632] Call Trace:
[ 2406.949066] schedule (kernel/sched/core.c:2895)
[ 2406.950018] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2406.951115] ? res_counter_memparse_write_strategy ()
[ 2406.952419] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2406.953429] kthread (kernel/kthread.c:207)
[ 2406.954300] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.955411] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.956468] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.957459] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.958519] rcuc/1          S ffffffff986f3040 13728    18      2 0x00000000
[ 2406.960012]  ffff880108fa3d88 0000000000000002 ffff880108fa3d48 ffffffff00000000
[ 2406.961375]  ffff880108f9b000 ffff880108fa0010 ffff880108fa0000 00000001b8794085
[ 2406.962718]  ffff880108fa8000 ffff880108f9b000 ffff880108f9b000 0000000000000000
[ 2406.964082] Call Trace:
[ 2406.964508] schedule (kernel/sched/core.c:2895)
[ 2406.965409] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2406.966409] ? rcu_sysidle_cb ()
[ 2406.967443] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2406.968466] kthread (kernel/kthread.c:207)
[ 2406.969345] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.970020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.971114] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.972073] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.973120] ksoftirqd/1     S ffffffff986f3040 13616    19      2 0x00000000
[ 2406.974384]  ffff880108fa7d88 0000000000000002 ffff880108fa7d48 0000000000000000
[ 2406.975765]  ffff880108fa8000 ffff880108fa4010 ffff880108fa4000 000002299b287dee
[ 2406.977083]  ffff880068378000 ffff880108fa8000 ffff880108fa7d78 0000000000000000
[ 2406.978424] Call Trace:
[ 2406.978950] schedule (kernel/sched/core.c:2895)
[ 2406.980019] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2406.981031] ? tasklet_init (kernel/softirq.c:646)
[ 2406.981991] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2406.983040] kthread (kernel/kthread.c:207)
[ 2406.983939] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2406.985031] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.986167] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2406.987134] ? flush_kthread_work (kernel/kthread.c:176)
[ 2406.988189] kworker/1:0     S ffffffff986f3040 14144    20      2 0x00000000
[ 2406.990032]  ffff880108fb7d58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2406.991453]  ffff880108fab000 ffff880108fb4010 ffff880108fb4000 000000018e52bb7d
[ 2406.992817]  ffff880068378000 ffff880108fab000 ffff880108fb7d48 0000000000000000
[ 2406.994202] Call Trace:
[ 2406.994631] ? worker_thread (kernel/workqueue.c:2176)
[ 2406.995641] schedule (kernel/sched/core.c:2895)
[ 2406.996501] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2406.997453] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2406.998430] ? process_one_work (kernel/workqueue.c:2100)
[ 2406.999578] kthread (kernel/kthread.c:207)
[ 2407.000020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.001093] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.002031] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.003144] kworker/1:0H    S ffffffff986f3040 14144    21      2 0x00000000
[ 2407.004421]  ffff880108fc3d58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2407.005749]  ffff880108fb8000 ffff880108fc0010 ffff880108fc0000 000000018ec4c772
[ 2407.007282]  ffff880068378000 ffff880108fb8000 ffff880108fc3d48 0000000000000000
[ 2407.008687] Call Trace:
[ 2407.009164] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.010000] schedule (kernel/sched/core.c:2895)
[ 2407.010000] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.010000] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.010000] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.010000] kthread (kernel/kthread.c:207)
[ 2407.010000] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.010000] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.010000] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.010000] kworker/u66:0   S ffffffff986f3040 14176    22      2 0x00000000
[ 2407.020022]  ffff880108fdbd58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2407.021443]  ffff880108fbb000 ffff880108fd8010 ffff880108fd8000 000000018c1ebef1
[ 2407.022837]  ffff880068378000 ffff880108fbb000 ffff880108fdbd48 0000000000000000
[ 2407.024306] Call Trace:
[ 2407.024764] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.025788] schedule (kernel/sched/core.c:2895)
[ 2407.026655] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.027721] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.028711] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.030019] kthread (kernel/kthread.c:207)
[ 2407.030919] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.032151] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.033139] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.034329] watchdog/2      S ffffffff986f3040 13680    23      2 0x00000000
[ 2407.034329]  ffff880176effd88 0000000000000002 0000000000000002 ffff880100000000
[ 2407.034329]  ffff880176f0b000 ffff880176efc010 ffff880176efc000 0000022f1771945d
[ 2407.035241]  ffff88006837b000 ffff880176f0b000 ffff880176f0b000 0000000000000000
[ 2407.040066] Call Trace:
[ 2407.040515] schedule (kernel/sched/core.c:2895)
[ 2407.041392] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.042489] ? touch_nmi_watchdog ()
[ 2407.043526] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.044509] kthread (kernel/kthread.c:207)
[ 2407.045376] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.046513] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.047603] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.048579] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.049515] migration/2     S ffffffff986f3040 14128    24      2 0x00000000
[ 2407.050882]  ffff880176f1bd88 0000000000000002 ffff880176f1bd28 ffffffff00000000
[ 2407.052562]  ffff880176ef3000 ffff880176f18010 ffff880176f18000 00000000937234eb
[ 2407.053913]  ffff88006837b000 ffff880176ef3000 ffff880176f1bd78 0000000000000000
[ 2407.055278] Call Trace:
[ 2407.055706] schedule (kernel/sched/core.c:2895)
[ 2407.056559] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.057572] ? res_counter_memparse_write_strategy ()
[ 2407.058898] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.060018] kthread (kernel/kthread.c:207)
[ 2407.060876] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.061953] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.063081] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.063992] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.065025] rcuc/2          S ffffffff986f3040 13792    25      2 0x00000000
[ 2407.066262]  ffff880176f1fd88 0000000000000002 ffff880176f1fd48 ffffffff00000000
[ 2407.067658]  ffff880176f20000 ffff880176f1c010 ffff880176f1c000 00000001b9aba080
[ 2407.068992]  ffff880176f23000 ffff880176f20000 ffff880176f20000 0000000000000000
[ 2407.070400] Call Trace:
[ 2407.070851] schedule (kernel/sched/core.c:2895)
[ 2407.071732] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.072753] ? rcu_sysidle_cb ()
[ 2407.073746] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.074859] kthread (kernel/kthread.c:207)
[ 2407.075756] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.076825] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.077937] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.078977] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.080018] ksoftirqd/2     S ffffffff986f3040 13616    26      2 0x00000000
[ 2407.081322]  ffff880176f2bd88 0000000000000002 ffff880176f2bd48 0000000000000000
[ 2407.082777]  ffff880176f23000 ffff880176f28010 ffff880176f28000 000001c75bca2fc0
[ 2407.084137]  ffff88006837b000 ffff880176f23000 ffff880176f2bd78 0000000000000000
[ 2407.085471] Call Trace:
[ 2407.085927] schedule (kernel/sched/core.c:2895)
[ 2407.086885] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.087904] ? tasklet_init (kernel/softirq.c:646)
[ 2407.088875] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.089874] kthread (kernel/kthread.c:207)
[ 2407.090023] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.091123] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.092184] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.093150] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.094314] kworker/2:0     S ffffffff986f3040 13376    27      2 0x00000000
[ 2407.095728]  ffff880176f3bd58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2407.097092]  ffff880176f30000 ffff880176f38010 ffff880176f38000 00000001a4f73702
[ 2407.098636]  ffff880068248000 ffff880176f30000 ffff880176f3bd48 0000000000000000
[ 2407.100906] Call Trace:
[ 2407.101369] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.102373] schedule (kernel/sched/core.c:2895)
[ 2407.103225] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.104157] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.105209] kthread (kernel/kthread.c:207)
[ 2407.106115] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.107226] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.108174] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.109262] kworker/2:0H    S ffffffff986f3040 14144    28      2 0x00000000
[ 2407.110613]  ffff880176f3fd58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2407.112184]  ffff880176f33000 ffff880176f3c010 ffff880176f3c000 000000018ec9409f
[ 2407.113501]  ffff88006837b000 ffff880176f33000 ffff880176f3fd48 0000000000000000
[ 2407.114888] Call Trace:
[ 2407.115315] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.116310] schedule (kernel/sched/core.c:2895)
[ 2407.117167] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.118127] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.119164] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.120018] kthread (kernel/kthread.c:207)
[ 2407.120928] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.122078] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.122993] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.124076] kworker/u67:0   S ffffffff986f3040 14144    29      2 0x00000000
[ 2407.125335]  ffff880176f67d58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2407.126790]  ffff880176f68000 ffff880176f64010 ffff880176f64000 000000018c0b8930
[ 2407.128278]  ffff88006837b000 ffff880176f68000 ffff880176f67d48 0000000000000000
[ 2407.130012] Call Trace:
[ 2407.130495] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.131505] schedule (kernel/sched/core.c:2895)
[ 2407.132539] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.133506] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.134582] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.135664] kthread (kernel/kthread.c:207)
[ 2407.136661] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.137815] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.138816] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.140034] watchdog/3      S ffffffff986f3040 13536    30      2 0x00000000
[ 2407.141363]  ffff8801e4f87d88 0000000000000002 0000000000000003 ffff880100000000
[ 2407.142785]  ffff8801e4f93000 ffff8801e4f84010 ffff8801e4f84000 0000022f193b3e16
[ 2407.144149]  ffff880479380000 ffff8801e4f93000 ffff8801e4f93000 0000000000000000
[ 2407.145481] Call Trace:
[ 2407.145935] schedule (kernel/sched/core.c:2895)
[ 2407.146925] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.147964] ? touch_nmi_watchdog ()
[ 2407.149056] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.150019] kthread (kernel/kthread.c:207)
[ 2407.150608] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.151179] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.151741] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.152224] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.152783] migration/3     S ffffffff986f3040 14128    31      2 0x00000000
[ 2407.153453]  ffff8801e4fabd88 0000000000000002 ffff8801e4fabd28 ffffffff00000000
[ 2407.154363]  ffff8801e4fa0000 ffff8801e4fa8010 ffff8801e4fa8000 000000009372701a
[ 2407.155237]  ffff880479380000 ffff8801e4fa0000 ffff8801e4fabd78 0000000000000000
[ 2407.156201] Call Trace:
[ 2407.156490] schedule (kernel/sched/core.c:2895)
[ 2407.157573] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.158687] ? res_counter_memparse_write_strategy ()
[ 2407.160019] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.161005] kthread (kernel/kthread.c:207)
[ 2407.161902] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.163107] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.164245] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.165149] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.166246] rcuc/3          S ffffffff986f3040 13600    32      2 0x00000000
[ 2407.167485]  ffff8801e4fafd88 0000000000000002 ffff8801e4fafd48 ffffffff00000000
[ 2407.168860]  ffff8801e4fa3000 ffff8801e4fac010 ffff8801e4fac000 00000001b9aba080
[ 2407.170070]  ffff8801e4fb0000 ffff8801e4fa3000 ffff8801e4fa3000 0000000000000000
[ 2407.171475] Call Trace:
[ 2407.171974] schedule (kernel/sched/core.c:2895)
[ 2407.172846] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.173936] ? rcu_sysidle_cb ()
[ 2407.174962] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.176024] kthread (kernel/kthread.c:207)
[ 2407.176968] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.178169] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.179306] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.180020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.181076] ksoftirqd/3     S ffffffff986f3040 13616    33      2 0x00000000
[ 2407.182407]  ffff8801e4fbbd88 0000000000000002 ffff8801e4fbbd48 0000000000000000
[ 2407.183981]  ffff8801e4fb0000 ffff8801e4fb8010 ffff8801e4fb8000 0000020e125193b9
[ 2407.185359]  ffff880479380000 ffff8801e4fb0000 ffff8801e4fbbd78 0000000000000000
[ 2407.186753] Call Trace:
[ 2407.187184] schedule (kernel/sched/core.c:2895)
[ 2407.188055] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.189131] ? tasklet_init (kernel/softirq.c:646)
[ 2407.190019] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.191024] kthread (kernel/kthread.c:207)
[ 2407.191894] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.192957] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.194127] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.195058] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.196131] kworker/3:0     S ffffffff986f3040 13376    34      2 0x00000000
[ 2407.197484]  ffff8801e4fc3d58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2407.198930]  ffff8801e4fb3000 ffff8801e4fc0010 ffff8801e4fc0000 00000000da5cadd3
[ 2407.200862]  ffff8801e2188000 ffff8801e4fb3000 ffff8801e4fc3d48 0000000000000000
[ 2407.202283] Call Trace:
[ 2407.202776] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.203754] schedule (kernel/sched/core.c:2895)
[ 2407.204600] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.205511] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.206627] kthread (kernel/kthread.c:207)
[ 2407.207551] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.208693] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.209687] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.210021] kworker/3:0H    S ffffffff986f3040 14144    35      2 0x00000000
[ 2407.211580]  ffff8801e4fc7d58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2407.212913]  ffff8801e4fc8000 ffff8801e4fc4010 ffff8801e4fc4000 000000018ec99907
[ 2407.214304]  ffff880479380000 ffff8801e4fc8000 ffff8801e4fc7d48 0000000000000000
[ 2407.215693] Call Trace:
[ 2407.216175] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.217381] schedule (kernel/sched/core.c:2895)
[ 2407.218301] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.220019] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.220994] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.222067] kthread (kernel/kthread.c:207)
[ 2407.222941] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.223986] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.224905] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.226116] kworker/u68:0   S ffffffff986f3040 13568    36      2 0x00000000
[ 2407.227442]  ffff8801e4ffbd58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2407.228797]  ffff8801e4fcb000 ffff8801e4ff8010 ffff8801e4ff8000 000000018c304fcc
[ 2407.230412]  ffff880479380000 ffff8801e4fcb000 ffff8801e4ffbd48 0000000000000000
[ 2407.231745] Call Trace:
[ 2407.232186] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.233144] schedule (kernel/sched/core.c:2895)
[ 2407.234055] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.234996] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.235915] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.236936] kthread (kernel/kthread.c:207)
[ 2407.237822] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.238938] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.240015] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.241036] watchdog/4      S ffffffff986f3040 14032    37      2 0x00000000
[ 2407.242331]  ffff880252f77d88 0000000000000002 0000000000000004 ffff880200000000
[ 2407.243687]  ffff880252f7b000 ffff880252f74010 ffff880252f74000 0000022f1c360aa9
[ 2407.245005]  ffff8807e5360000 ffff880252f7b000 ffff880252f7b000 0000000000000000
[ 2407.246506] Call Trace:
[ 2407.246975] schedule (kernel/sched/core.c:2895)
[ 2407.247840] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.248842] ? touch_nmi_watchdog ()
[ 2407.249844] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.250019] kthread (kernel/kthread.c:207)
[ 2407.250966] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.252064] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.253093] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.254141] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.255245] migration/4     S ffffffff986f3040 14128    38      2 0x00000000
[ 2407.256520]  ffff880252fabd88 0000000000000002 ffff880252fabd28 ffffffff00000000
[ 2407.257891]  ffff880252fa0000 ffff880252fa8010 ffff880252fa8000 000000009372bc41
[ 2407.260064]  ffff8807e5360000 ffff880252fa0000 ffff880252fabd78 0000000000000000
[ 2407.261417] Call Trace:
[ 2407.261855] schedule (kernel/sched/core.c:2895)
[ 2407.262731] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.263738] ? res_counter_memparse_write_strategy ()
[ 2407.265021] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.266000] kthread (kernel/kthread.c:207)
[ 2407.267003] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.268139] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.269235] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.270019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.270567] rcuc/4          S ffffffff986f3040 13792    39      2 0x00000000
[ 2407.271244]  ffff880252fafd88 0000000000000002 ffff880252fafd48 ffffffff00000000
[ 2407.271950]  ffff880252fa3000 ffff880252fac010 ffff880252fac000 00000001badccd80
[ 2407.272658]  ffff880252fb0000 ffff880252fa3000 ffff880252fa3000 0000000000000000
[ 2407.273364] Call Trace:
[ 2407.273593] schedule (kernel/sched/core.c:2895)
[ 2407.274096] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.274712] ? rcu_sysidle_cb ()
[ 2407.275300] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.275979] kthread (kernel/kthread.c:207)
[ 2407.276524] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.277540] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.278771] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.279717] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.280017] ksoftirqd/4     S ffffffff986f3040 13616    40      2 0x00000000
[ 2407.281327]  ffff880252fbbd88 0000000000000002 ffff880252fbbd48 0000000000000000
[ 2407.282667]  ffff880252fb0000 ffff880252fb8010 ffff880252fb8000 000002048d18c29b
[ 2407.283984]  ffff8807e5360000 ffff880252fb0000 ffff880252fbbd78 0000000000000000
[ 2407.285352] Call Trace:
[ 2407.285784] schedule (kernel/sched/core.c:2895)
[ 2407.286694] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.287696] ? tasklet_init (kernel/softirq.c:646)
[ 2407.288664] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.290020] kthread (kernel/kthread.c:207)
[ 2407.290919] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.291970] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.293027] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.293975] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.295018] kworker/4:0     S ffffffff986f3040 13376    41      2 0x00000000
[ 2407.296270]  ffff880252fc3d58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2407.297707]  ffff880252fb3000 ffff880252fc0010 ffff880252fc0000 00000001b80936f1
[ 2407.299102]  ffff8802501a3000 ffff880252fb3000 ffff880252fc3d48 0000000000000000
[ 2407.300849] Call Trace:
[ 2407.301284] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.302316] schedule (kernel/sched/core.c:2895)
[ 2407.303165] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.304103] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.305113] kthread (kernel/kthread.c:207)
[ 2407.306013] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.307070] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.308071] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.309473] kworker/4:0H    S ffffffff986f3040 14144    42      2 0x00000000
[ 2407.310778]  ffff880252fc7d58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2407.312180]  ffff880252fd0000 ffff880252fc4010 ffff880252fc4000 000000018ec74108
[ 2407.313585]  ffff8807e5360000 ffff880252fd0000 ffff880252fc7d48 0000000000000000
[ 2407.314991] Call Trace:
[ 2407.315417] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.316428] schedule (kernel/sched/core.c:2895)
[ 2407.317299] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.318576] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.319554] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.320018] kthread (kernel/kthread.c:207)
[ 2407.320885] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.321958] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.322859] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.323888] kworker/u69:0   S ffffffff986f3040 14176    43      2 0x00000000
[ 2407.325141]  ffff880252fffd58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2407.326539]  ffff880252fd3000 ffff880252ffc010 ffff880252ffc000 000000018c1b1d3a
[ 2407.327958]  ffff8807e5360000 ffff880252fd3000 ffff880252fffd48 0000000000000000
[ 2407.330068] Call Trace:
[ 2407.330501] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.331462] schedule (kernel/sched/core.c:2895)
[ 2407.332292] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.333298] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.334262] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.335259] kthread (kernel/kthread.c:207)
[ 2407.336128] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.337318] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.338324] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.339534] watchdog/5      S ffffffff986f3040 13536    44      2 0x00000000
[ 2407.340779]  ffff8802c0f7fd88 0000000000000002 0000000000000005 ffff880200000000
[ 2407.342197]  ffff8802c0f8b000 ffff8802c0f7c010 ffff8802c0f7c000 0000022f1e0001ff
[ 2407.343521]  ffff880108f80000 ffff8802c0f8b000 ffff8802c0f8b000 0000000000000000
[ 2407.344829] Call Trace:
[ 2407.345258] schedule (kernel/sched/core.c:2895)
[ 2407.346233] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.346902] ? touch_nmi_watchdog ()
[ 2407.347623] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.348514] kthread (kernel/kthread.c:207)
[ 2407.349177] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.350019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.350816] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.351493] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.352141] migration/5     S ffffffff986f3040 14128    45      2 0x00000000
[ 2407.352930]  ffff8802c0fabd88 0000000000000002 ffff8802c0fabd28 ffffffff00000000
[ 2407.353767]  ffff8802c0fa0000 ffff8802c0fa8010 ffff8802c0fa8000 0000000093730dd3
[ 2407.354645]  ffff880108f80000 ffff8802c0fa0000 ffff8802c0fabd78 0000000000000000
[ 2407.355496] Call Trace:
[ 2407.355777] schedule (kernel/sched/core.c:2895)
[ 2407.356378] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.357078] ? res_counter_memparse_write_strategy ()
[ 2407.358312] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.359297] kthread (kernel/kthread.c:207)
[ 2407.360019] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.361144] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.362243] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.363152] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.364201] rcuc/5          S ffffffff986f3040 13872    46      2 0x00000000
[ 2407.365467]  ffff8802c0fafd88 0000000000000002 ffff8802c0fafd48 ffffffff00000000
[ 2407.366909]  ffff8802c0fa3000 ffff8802c0fac010 ffff8802c0fac000 00000001bd3c473e
[ 2407.368269]  ffff8802c0fb0000 ffff8802c0fa3000 ffff8802c0fa3000 0000000000000000
[ 2407.369639] Call Trace:
[ 2407.370020] schedule (kernel/sched/core.c:2895)
[ 2407.370881] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.371920] ? rcu_sysidle_cb ()
[ 2407.372889] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.373940] kthread (kernel/kthread.c:207)
[ 2407.374811] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.375872] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.376929] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.377922] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.378992] ksoftirqd/5     S ffffffff986f3040 14128    47      2 0x00000000
[ 2407.380503]  ffff8802c0fbbd88 0000000000000002 ffff8802c0fbbd48 0000000000000000
[ 2407.382185]  ffff8802c0fb0000 ffff8802c0fb8010 ffff8802c0fb8000 0000021d7b0afce7
[ 2407.383535]  ffff880108f80000 ffff8802c0fb0000 ffff8802c0fbbd78 0000000000000000
[ 2407.384955] Call Trace:
[ 2407.385398] schedule (kernel/sched/core.c:2895)
[ 2407.386556] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.387816] ? tasklet_init (kernel/softirq.c:646)
[ 2407.389123] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.390020] kthread (kernel/kthread.c:207)
[ 2407.390961] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.392036] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.393109] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.394267] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.395351] kworker/5:0     S ffffffff986f3040 13376    48      2 0x00000000
[ 2407.396825]  ffff8802c0fc3d58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2407.398626]  ffff8802c0fb3000 ffff8802c0fc0010 ffff8802c0fc0000 000000010fda0c6c
[ 2407.400754]  ffff8802bd8a8000 ffff8802c0fb3000 ffff8802c0fc3d48 0000000000000000
[ 2407.402460] Call Trace:
[ 2407.403059] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.404091] schedule (kernel/sched/core.c:2895)
[ 2407.404945] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.405880] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.407216] kthread (kernel/kthread.c:207)
[ 2407.408580] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.409634] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.410019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.411091] kworker/5:0H    S ffffffff986f3040 14144    49      2 0x00000000
[ 2407.412341]  ffff8802c0fc7d58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2407.413705]  ffff8802c0fc8000 ffff8802c0fc4010 ffff8802c0fc4000 000000018ec74108
[ 2407.415026]  ffff880108f80000 ffff8802c0fc8000 ffff8802c0fc7d48 0000000000000000
[ 2407.416343] Call Trace:
[ 2407.416772] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.417771] schedule (kernel/sched/core.c:2895)
[ 2407.418642] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.420018] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.420961] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.422024] kthread (kernel/kthread.c:207)
[ 2407.422921] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.423998] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.424909] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.426056] kworker/u70:0   S ffffffff986f3040 14176    50      2 0x00000000
[ 2407.427337]  ffff8802c0ffbd58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2407.428742]  ffff8802c0fcb000 ffff8802c0ff8010 ffff8802c0ff8000 000000018c19884d
[ 2407.430368]  ffff880108f80000 ffff8802c0fcb000 ffff8802c0ffbd48 0000000000000000
[ 2407.431754] Call Trace:
[ 2407.432201] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.433185] schedule (kernel/sched/core.c:2895)
[ 2407.434026] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.435030] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.435978] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.437038] kthread (kernel/kthread.c:207)
[ 2407.437926] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.439131] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.440022] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.441082] watchdog/6      S ffffffff986f3040 14032    51      2 0x00000000
[ 2407.442401]  ffff88032ef6bd88 0000000000000002 0000000000000006 ffff880300000000
[ 2407.443739]  ffff88032ef4b000 ffff88032ef68010 ffff88032ef68000 0000022f20fb2977
[ 2407.445040]  ffff8802c0f88000 ffff88032ef4b000 ffff88032ef4b000 0000000000000000
[ 2407.446440] Call Trace:
[ 2407.446869] schedule (kernel/sched/core.c:2895)
[ 2407.447727] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.448759] ? touch_nmi_watchdog ()
[ 2407.449779] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.450019] kthread (kernel/kthread.c:207)
[ 2407.450924] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.451981] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.453020] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.454025] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.455098] migration/6     S ffffffff986f3040 14128    52      2 0x00000000
[ 2407.456405]  ffff88032ef6fd88 0000000000000002 ffff88032ef6fd28 ffffffff00000000
[ 2407.457851]  ffff88032ef70000 ffff88032ef6c010 ffff88032ef6c000 0000000093735387
[ 2407.460066]  ffff8802c0f88000 ffff88032ef70000 ffff88032ef6fd78 0000000000000000
[ 2407.461458] Call Trace:
[ 2407.461990] schedule (kernel/sched/core.c:2895)
[ 2407.462877] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.463903] ? res_counter_memparse_write_strategy ()
[ 2407.465164] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.466229] kthread (kernel/kthread.c:207)
[ 2407.467130] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.468237] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.469326] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.470019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.471078] rcuc/6          S ffffffff986f3040 13792    53      2 0x00000000
[ 2407.472312]  ffff88032ef7bd88 0000000000000002 ffff88032ef7bd48 ffffffff00000000
[ 2407.473726]  ffff88032ef73000 ffff88032ef78010 ffff88032ef78000 00000001df38aa00
[ 2407.475052]  ffff88032ef80000 ffff88032ef73000 ffff88032ef73000 0000000000000000
[ 2407.476384] Call Trace:
[ 2407.476818] schedule (kernel/sched/core.c:2895)
[ 2407.477773] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.478786] ? rcu_sysidle_cb ()
[ 2407.480018] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.481011] kthread (kernel/kthread.c:207)
[ 2407.481957] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.483041] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.484101] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.485014] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.486144] ksoftirqd/6     S ffffffff986f3040 14128    54      2 0x00000000
[ 2407.487453]  ffff88032ef7fd88 0000000000000002 ffff88032ef7fd48 0000000000000000
[ 2407.488809]  ffff88032ef80000 ffff88032ef7c010 ffff88032ef7c000 0000006b40493dac
[ 2407.490340]  ffff8802c0f88000 ffff88032ef80000 ffff88032ef7fd78 0000000000000000
[ 2407.491711] Call Trace:
[ 2407.492161] schedule (kernel/sched/core.c:2895)
[ 2407.493082] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.494127] ? tasklet_init (kernel/softirq.c:646)
[ 2407.495065] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.496058] kthread (kernel/kthread.c:207)
[ 2407.496933] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.498190] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.499317] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.500019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.501069] kworker/6:0     S ffffffff986f3040 13376    55      2 0x00000000
[ 2407.502389]  ffff88032ef8fd58 0000000000000002 ffffffff911eeacf ffff880300000000
[ 2407.503746]  ffff88032ef83000 ffff88032ef8c010 ffff88032ef8c000 0000000122feab87
[ 2407.505051]  ffff88032c090000 ffff88032ef83000 ffff88032ef8fd48 0000000000000000
[ 2407.506492] Call Trace:
[ 2407.506928] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.507891] schedule (kernel/sched/core.c:2895)
[ 2407.508755] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.510019] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.511037] kthread (kernel/kthread.c:207)
[ 2407.511887] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.512934] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.513887] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.514926] kworker/6:0H    S ffffffff986f3040 14176    56      2 0x00000000
[ 2407.516187]  ffff88032efa3d58 0000000000000002 ffffffff911eeacf ffff880300000000
[ 2407.517674]  ffff88032ef98000 ffff88032efa0010 ffff88032efa0000 000000018ed9cbdc
[ 2407.519149]  ffff8802bd8db000 ffff88032ef98000 ffff88032efa3d48 0000000000000000
[ 2407.520606] Call Trace:
[ 2407.521043] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.522076] schedule (kernel/sched/core.c:2895)
[ 2407.522946] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.523866] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.524829] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.525978] kthread (kernel/kthread.c:207)
[ 2407.526840] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.527910] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.528884] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.530020] kworker/u71:0   S ffffffff986f3040 14176    57      2 0x00000000
[ 2407.531332]  ffff88032efcbd58 0000000000000002 ffffffff911eeacf ffff880300000000
[ 2407.532683]  ffff88032ef9b000 ffff88032efc8010 ffff88032efc8000 000000018c462922
[ 2407.534025]  ffff8802c0f88000 ffff88032ef9b000 ffff88032efcbd48 0000000000000000
[ 2407.535424] Call Trace:
[ 2407.535920] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.536890] schedule (kernel/sched/core.c:2895)
[ 2407.537783] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.538842] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.539815] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.540027] kthread (kernel/kthread.c:207)
[ 2407.540900] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.542015] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.542948] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.544019] watchdog/7      S ffffffff986f3040 14032    58      2 0x00000000
[ 2407.545370]  ffff88039cf87d88 0000000000000002 0000000000000007 ffff880300000000
[ 2407.546798]  ffff88039cfa0000 ffff88039cf84010 ffff88039cf84000 0000022f22c4aa45
[ 2407.548178]  ffff880479388000 ffff88039cfa0000 ffff88039cfa0000 0000000000000000
[ 2407.550327] Call Trace:
[ 2407.550776] schedule (kernel/sched/core.c:2895)
[ 2407.551664] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.552683] ? touch_nmi_watchdog ()
[ 2407.553733] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.554836] kthread (kernel/kthread.c:207)
[ 2407.555688] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.556826] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.558020] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.558981] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.560017] migration/7     S ffffffff986f3040 14128    59      2 0x00000000
[ 2407.561317]  ffff88039cfabd88 0000000000000002 ffff88039cfabd28 ffffffff00000000
[ 2407.562706]  ffff88039cfa3000 ffff88039cfa8010 ffff88039cfa8000 0000000093739991
[ 2407.564035]  ffff880479388000 ffff88039cfa3000 ffff88039cfabd78 0000000000000000
[ 2407.565363] Call Trace:
[ 2407.565940] schedule (kernel/sched/core.c:2895)
[ 2407.566802] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.567833] ? res_counter_memparse_write_strategy ()
[ 2407.569102] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.570019] kthread (kernel/kthread.c:207)
[ 2407.570925] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.571989] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.573027] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.573991] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.575023] rcuc/7          S ffffffff986f3040 13792    60      2 0x00000000
[ 2407.576299]  ffff88039cfafd88 0000000000000002 ffff88039cfafd48 ffffffff00000000
[ 2407.577743]  ffff88039cfb0000 ffff88039cfac010 ffff88039cfac000 00000001c0376dbd
[ 2407.579120]  ffff88039cfb3000 ffff88039cfb0000 ffff88039cfb0000 0000000000000000
[ 2407.580893] Call Trace:
[ 2407.581357] schedule (kernel/sched/core.c:2895)
[ 2407.582286] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.583297] ? rcu_sysidle_cb ()
[ 2407.584280] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.585281] kthread (kernel/kthread.c:207)
[ 2407.586212] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.587323] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.588433] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.589364] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.590017] ksoftirqd/7     S ffffffff986f3040 13616    61      2 0x00000000
[ 2407.591286]  ffff88039cfbbd88 0000000000000002 ffff88039cfbbd38 ffffffff00000000
[ 2407.592604]  ffff88039cfb3000 ffff88039cfb8010 ffff88039cfb8000 00000001c03b7f1f
[ 2407.593956]  ffff880479388000 ffff88039cfb3000 ffff88039cfbbdd8 0000000000000000
[ 2407.595310] Call Trace:
[ 2407.595744] schedule (kernel/sched/core.c:2895)
[ 2407.596578] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.597627] ? tasklet_init (kernel/softirq.c:646)
[ 2407.598565] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.600019] kthread (kernel/kthread.c:207)
[ 2407.600866] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.601992] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.603039] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.603949] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.605028] kworker/7:0     S ffffffff986f3040 14176    62      2 0x00000000
[ 2407.606352]  ffff88039cfcbd58 0000000000000002 ffffffff911eeacf ffff880300000000
[ 2407.607715]  ffff88039cfc0000 ffff88039cfc8010 ffff88039cfc8000 000000018e68c6a9
[ 2407.609221]  ffff880479388000 ffff88039cfc0000 ffff88039cfcbd48 0000000000000000
[ 2407.610394] Call Trace:
[ 2407.610666] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.611338] schedule (kernel/sched/core.c:2895)
[ 2407.612188] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.613114] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.614152] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.615185] kthread (kernel/kthread.c:207)
[ 2407.616063] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.617165] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.618082] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.619019] kworker/7:0H    S ffffffff986f3040 14176    63      2 0x00000000
[ 2407.620021]  ffff88039cfcfd58 0000000000000002 ffffffff911eeacf ffff880300000000
[ 2407.621451]  ffff88039cfc3000 ffff88039cfcc010 ffff88039cfcc000 000000018ef3cfb6
[ 2407.622834]  ffff880479388000 ffff88039cfc3000 ffff88039cfcfd48 0000000000000000
[ 2407.624168] Call Trace:
[ 2407.624599] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.625650] schedule (kernel/sched/core.c:2895)
[ 2407.626507] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.627433] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.628371] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.629406] kthread (kernel/kthread.c:207)
[ 2407.630021] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.631081] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.632000] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.633040] kworker/u72:0   S ffffffff986f3040 14144    64      2 0x00000000
[ 2407.634417]  ffff88039cff7d58 0000000000000002 ffffffff911eeacf ffff880300000000
[ 2407.635819]  ffff88039cff8000 ffff88039cff4010 ffff88039cff4000 000000018c0b7509
[ 2407.637208]  ffff8802bd823000 ffff88039cff8000 ffff88039cff7d48 0000000000000000
[ 2407.638668] Call Trace:
[ 2407.640020] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.641003] schedule (kernel/sched/core.c:2895)
[ 2407.641876] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.642936] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.643973] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.645072] kthread (kernel/kthread.c:207)
[ 2407.646035] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.647205] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.648170] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.649267] watchdog/8      S ffffffff986f3040 14032    65      2 0x00000000
[ 2407.650532]  ffff88040b387d88 0000000000000002 0000000000000008 ffff880400000000
[ 2407.651978]  ffff88040b393000 ffff88040b384010 ffff88040b384000 0000022f25bfd2ad
[ 2407.653377]  ffff880631390000 ffff88040b393000 ffff88040b393000 0000000000000000
[ 2407.654826] Call Trace:
[ 2407.655297] schedule (kernel/sched/core.c:2895)
[ 2407.656233] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.657297] ? touch_nmi_watchdog ()
[ 2407.658429] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.659427] kthread (kernel/kthread.c:207)
[ 2407.660019] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.661089] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.662250] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.663160] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.664267] migration/8     S ffffffff986f3040 14128    66      2 0x00000000
[ 2407.665670]  ffff88040b3bbd88 0000000000000002 ffff88040b3bbd28 ffffffff00000000
[ 2407.667042]  ffff88040b3b0000 ffff88040b3b8010 ffff88040b3b8000 000002306e4b68c9
[ 2407.668400]  ffff880631390000 ffff88040b3b0000 ffff88040b3bbd78 0000000000000000
[ 2407.670062] Call Trace:
[ 2407.670515] schedule (kernel/sched/core.c:2895)
[ 2407.671395] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.672395] ? res_counter_memparse_write_strategy ()
[ 2407.673648] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.674703] kthread (kernel/kthread.c:207)
[ 2407.675552] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.676598] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.677654] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.678702] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.680017] rcuc/8          S ffffffff986f3040 13792    67      2 0x00000000
[ 2407.681300]  ffff88040b3bfd88 0000000000000002 ffff88040b3bfd48 ffffffff00000000
[ 2407.682676]  ffff88040b3b3000 ffff88040b3bc010 ffff88040b3bc000 00000001e495f480
[ 2407.684077]  ffff88040b3c0000 ffff88040b3b3000 ffff88040b3b3000 0000000000000000
[ 2407.685412] Call Trace:
[ 2407.685946] schedule (kernel/sched/core.c:2895)
[ 2407.686838] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.687865] ? rcu_sysidle_cb ()
[ 2407.688883] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.689889] kthread (kernel/kthread.c:207)
[ 2407.690019] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.691108] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.692190] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.693179] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.694254] ksoftirqd/8     S ffffffff986f3040 13616    68      2 0x00000000
[ 2407.695555]  ffff88040b3cbd88 0000000000000002 ffff88040b3cbd38 ffffffff00000000
[ 2407.696886]  ffff88040b3c0000 ffff88040b3c8010 ffff88040b3c8000 00000001e4971d83
[ 2407.698373]  ffff880631390000 ffff88040b3c0000 ffff88040b3cbdd8 0000000000000000
[ 2407.700609] Call Trace:
[ 2407.701075] schedule (kernel/sched/core.c:2895)
[ 2407.702001] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.703063] ? tasklet_init (kernel/softirq.c:646)
[ 2407.704056] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.705074] kthread (kernel/kthread.c:207)
[ 2407.706021] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.707117] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.708226] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.709189] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.710017] kworker/8:0     S ffffffff986f3040 14176    69      2 0x00000000
[ 2407.711366]  ffff88040b3d3d58 0000000000000002 ffffffff911eeacf ffff880400000000
[ 2407.712736]  ffff88040b3c3000 ffff88040b3d0010 ffff88040b3d0000 000000018e7a291c
[ 2407.714205]  ffff880631390000 ffff88040b3c3000 ffff88040b3d3d48 0000000000000000
[ 2407.715590] Call Trace:
[ 2407.716053] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.717082] schedule (kernel/sched/core.c:2895)
[ 2407.718094] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.719100] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.720021] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.721067] kthread (kernel/kthread.c:207)
[ 2407.721904] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.722622] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.723590] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.724660] kworker/8:0H    S ffffffff986f3040 14144    70      2 0x00000000
[ 2407.726052]  ffff88040b3d7d58 0000000000000002 ffffffff911eeacf ffff880400000000
[ 2407.727461]  ffff88040b3d8000 ffff88040b3d4010 ffff88040b3d4000 000000018ed9cbdc
[ 2407.728879]  ffff880631390000 ffff88040b3d8000 ffff88040b3d7d48 0000000000000000
[ 2407.730634] Call Trace:
[ 2407.731117] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.732110] schedule (kernel/sched/core.c:2895)
[ 2407.733021] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.734111] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.735098] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.736208] kthread (kernel/kthread.c:207)
[ 2407.737174] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.738409] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.739386] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.740020] kworker/u73:0   S ffffffff986f3040 14144    71      2 0x00000000
[ 2407.741400]  ffff880408007d58 0000000000000002 ffffffff911eeacf ffff880400000000
[ 2407.742817]  ffff88040b3db000 ffff880408004010 ffff880408004000 000000018c136910
[ 2407.744291]  ffff880631390000 ffff88040b3db000 ffff880408007d48 0000000000000000
[ 2407.745839] Call Trace:
[ 2407.746312] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.747362] schedule (kernel/sched/core.c:2895)
[ 2407.748282] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.750019] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.751055] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.752187] kthread (kernel/kthread.c:207)
[ 2407.753126] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.754320] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.755303] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.756427] watchdog/9      S ffffffff986f3040 13536    72      2 0x00000000
[ 2407.757769]  ffff8804793b3d88 0000000000000002 0000000000000009 ffff880400000000
[ 2407.759276]  ffff880479393000 ffff8804793b0010 ffff8804793b0000 0000022f28bac507
[ 2407.760624]  ffff8807e5368000 ffff880479393000 ffff880479393000 0000000000000000
[ 2407.762075] Call Trace:
[ 2407.762531] schedule (kernel/sched/core.c:2895)
[ 2407.763422] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.764504] ? touch_nmi_watchdog ()
[ 2407.765591] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.766640] kthread (kernel/kthread.c:207)
[ 2407.767536] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.768593] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.769645] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.770019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.771172] migration/9     S ffffffff986f3040 14128    73      2 0x00000000
[ 2407.772522]  ffff8804793b7d88 0000000000000002 ffff8804793b7d28 ffffffff00000000
[ 2407.773976]  ffff88047938b000 ffff8804793b4010 ffff8804793b4000 000000009374209e
[ 2407.775340]  ffff8807e5368000 ffff88047938b000 ffff8804793b7d78 0000000000000000
[ 2407.776716] Call Trace:
[ 2407.777218] schedule (kernel/sched/core.c:2895)
[ 2407.778099] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.779122] ? res_counter_memparse_write_strategy ()
[ 2407.780020] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.781164] kthread (kernel/kthread.c:207)
[ 2407.782092] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.783159] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.784208] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.785226] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.786348] rcuc/9          S ffffffff986f3040 13792    74      2 0x00000000
[ 2407.787641]  ffff8804793bbd88 0000000000000002 ffff8804793bbd48 ffffffff00000000
[ 2407.790353]  ffff880479383000 ffff8804793b8010 ffff8804793b8000 00000001ccbe7080
[ 2407.791727]  ffff88047933b000 ffff880479383000 ffff880479383000 0000000000000000
[ 2407.793054] Call Trace:
[ 2407.793482] schedule (kernel/sched/core.c:2895)
[ 2407.794451] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.795477] ? rcu_sysidle_cb ()
[ 2407.796468] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.797468] kthread (kernel/kthread.c:207)
[ 2407.798426] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.799528] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.800018] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.800999] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.802163] ksoftirqd/9     S ffffffff986f3040 14128    75      2 0x00000000
[ 2407.803507]  ffff8804793bfd88 0000000000000002 ffff8804793bfd48 0000000000000000
[ 2407.804881]  ffff88047933b000 ffff8804793bc010 ffff8804793bc000 0000021a171b0eca
[ 2407.806379]  ffff8807e5368000 ffff88047933b000 ffff8804793bfd78 0000000000000000
[ 2407.807791] Call Trace:
[ 2407.808230] schedule (kernel/sched/core.c:2895)
[ 2407.809119] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.810024] ? tasklet_init (kernel/softirq.c:646)
[ 2407.811004] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.812000] kthread (kernel/kthread.c:207)
[ 2407.812853] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.813996] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.815114] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.816025] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.817163] kworker/9:0     S ffffffff986f3040 14176    76      2 0x00000000
[ 2407.818427]  ffff8804793c7d58 0000000000000002 ffffffff911eeacf ffff880400000000
[ 2407.820589]  ffff8804793c8000 ffff8804793c4010 ffff8804793c4000 000000018e68c6a9
[ 2407.821968]  ffff8807e5368000 ffff8804793c8000 ffff8804793c7d48 0000000000000000
[ 2407.823290] Call Trace:
[ 2407.823718] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.824708] schedule (kernel/sched/core.c:2895)
[ 2407.825538] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.826506] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.827462] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.828512] kthread (kernel/kthread.c:207)
[ 2407.829367] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.830018] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.830947] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.831995] kworker/9:0H    S ffffffff986f3040 14176    77      2 0x00000000
[ 2407.833269]  ffff8804793d3d58 0000000000000002 ffffffff911eeacf ffff880400000000
[ 2407.834575]  ffff8804793cb000 ffff8804793d0010 ffff8804793d0000 000000018ed9cbdc
[ 2407.835874]  ffff88047933b000 ffff8804793cb000 ffff8804793d3d48 0000000000000000
[ 2407.837180] Call Trace:
[ 2407.837653] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.838619] schedule (kernel/sched/core.c:2895)
[ 2407.840018] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.840951] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.841961] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.843011] kthread (kernel/kthread.c:207)
[ 2407.843907] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.844963] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.845940] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.847026] kworker/u74:0   S ffffffff986f3040 14176    78      2 0x00000000
[ 2407.848343]  ffff8804793ffd58 0000000000000002 ffffffff911eeacf ffff880400000000
[ 2407.849718]  ffff880478800000 ffff8804793fc010 ffff8804793fc000 000000018c0b7509
[ 2407.850898]  ffff8807e5368000 ffff880478800000 ffff8804793ffd48 0000000000000000
[ 2407.852347] Call Trace:
[ 2407.852801] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.853870] schedule (kernel/sched/core.c:2895)
[ 2407.854735] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.855684] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.856617] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.857747] kthread (kernel/kthread.c:207)
[ 2407.858625] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.860018] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.860942] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.862055] watchdog/10     S ffffffff986f3040 14032    79      2 0x00000000
[ 2407.863372]  ffff8804e7333d88 0000000000000002 000000000000000a ffff880400000000
[ 2407.864749]  ffff8804e7313000 ffff8804e7330010 ffff8804e7330000 0000022f29ec5928
[ 2407.866263]  ffff8800683b0000 ffff8804e7313000 ffff8804e7313000 0000000000000000
[ 2407.867638] Call Trace:
[ 2407.868083] schedule (kernel/sched/core.c:2895)
[ 2407.868976] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.870025] ? touch_nmi_watchdog ()
[ 2407.871065] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.872092] kthread (kernel/kthread.c:207)
[ 2407.873004] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.874182] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.875283] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.876216] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.877295] migration/10    S ffffffff986f3040 14128    80      2 0x00000000
[ 2407.878683]  ffff8804e7337d88 0000000000000002 ffff8804e7337d28 ffffffff00000000
[ 2407.880067]  ffff8804e730b000 ffff8804e7334010 ffff8804e7334000 0000000093747421
[ 2407.881464]  ffff8800683b0000 ffff8804e730b000 ffff8804e7337d78 0000000000000000
[ 2407.882934] Call Trace:
[ 2407.883383] schedule (kernel/sched/core.c:2895)
[ 2407.884256] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.885330] ? res_counter_memparse_write_strategy ()
[ 2407.886685] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.887738] kthread (kernel/kthread.c:207)
[ 2407.888647] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.890020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.891136] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.892115] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.893201] rcuc/10         S ffffffff986f3040 13792    81      2 0x00000000
[ 2407.894557]  ffff8804e7343d88 0000000000000002 ffff8804e7343d48 ffffffff00000000
[ 2407.895912]  ffff8804e7338000 ffff8804e7340010 ffff8804e7340000 00000001cdef94ef
[ 2407.897265]  ffff8804e733b000 ffff8804e7338000 ffff8804e7338000 0000000000000000
[ 2407.898776] Call Trace:
[ 2407.899227] schedule (kernel/sched/core.c:2895)
[ 2407.900019] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.901105] ? rcu_sysidle_cb ()
[ 2407.902180] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.903255] kthread (kernel/kthread.c:207)
[ 2407.904196] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.905391] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.906573] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.907548] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.908668] ksoftirqd/10    S ffffffff986f3040 14128    82      2 0x00000000
[ 2407.910012]  ffff8804e7347d88 0000000000000002 ffff8804e7347d38 ffffffff00000000
[ 2407.911460]  ffff8804e733b000 ffff8804e7344010 ffff8804e7344000 00000001cdf16ad0
[ 2407.912889]  ffff8800683b0000 ffff8804e733b000 ffff8804e7347dd8 0000000000000000
[ 2407.914381] Call Trace:
[ 2407.914836] schedule (kernel/sched/core.c:2895)
[ 2407.915700] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.916769] ? tasklet_init (kernel/softirq.c:646)
[ 2407.917789] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.918822] kthread (kernel/kthread.c:207)
[ 2407.919711] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.920020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.921113] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.922101] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.923202] kworker/10:0    S ffffffff986f3040 13376    83      2 0x00000000
[ 2407.924505]  ffff8804e734fd58 0000000000000002 ffffffff911eeacf ffff880400000000
[ 2407.925927]  ffff8804e7350000 ffff8804e734c010 ffff8804e734c000 00000001c1b6f7ae
[ 2407.927275]  ffff880068248000 ffff8804e7350000 ffff8804e734fd48 0000000000000000
[ 2407.928622] Call Trace:
[ 2407.930037] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.931041] schedule (kernel/sched/core.c:2895)
[ 2407.931926] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.932859] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.933902] kthread (kernel/kthread.c:207)
[ 2407.934808] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.935833] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.936765] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.937906] kworker/10:0H   S ffffffff986f3040 14144    84      2 0x00000000
[ 2407.939202]  ffff8804e735bd58 0000000000000002 ffffffff911eeacf ffff880400000000
[ 2407.940602]  ffff8804e7353000 ffff8804e7358010 ffff8804e7358000 000000018ed9cbdc
[ 2407.942009]  ffff8800683b0000 ffff8804e7353000 ffff8804e735bd48 0000000000000000
[ 2407.943391] Call Trace:
[ 2407.943831] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.944803] schedule (kernel/sched/core.c:2895)
[ 2407.945658] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.946653] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.947609] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.948637] kthread (kernel/kthread.c:207)
[ 2407.949511] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.950019] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.951017] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.952112] kworker/u75:0   S ffffffff986f3040 14144    85      2 0x00000000
[ 2407.953434]  ffff8804e738bd58 0000000000000002 ffffffff911eeacf ffff880400000000
[ 2407.954763]  ffff8804e7380000 ffff8804e7388010 ffff8804e7388000 000000018c039e3d
[ 2407.956113]  ffff8800683b0000 ffff8804e7380000 ffff8804e738bd48 0000000000000000
[ 2407.957539] Call Trace:
[ 2407.957988] ? worker_thread (kernel/workqueue.c:2176)
[ 2407.958980] schedule (kernel/sched/core.c:2895)
[ 2407.960019] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2407.960991] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2407.962013] ? process_one_work (kernel/workqueue.c:2100)
[ 2407.963061] kthread (kernel/kthread.c:207)
[ 2407.963941] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.965033] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.966133] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.967260] watchdog/11     S ffffffff986f3040 13536    86      2 0x00000000
[ 2407.968580]  ffff880555387d88 0000000000000002 000000000000000b ffff880500000000
[ 2407.970336]  ffff8805553b8000 ffff880555384010 ffff880555384000 0000022f2bb5a940
[ 2407.971731]  ffff8800683b3000 ffff8805553b8000 ffff8805553b8000 0000000000000000
[ 2407.973098] Call Trace:
[ 2407.973531] schedule (kernel/sched/core.c:2895)
[ 2407.974504] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.975568] ? touch_nmi_watchdog ()
[ 2407.976614] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.977645] kthread (kernel/kthread.c:207)
[ 2407.978532] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.979589] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.980021] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.981006] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.982080] migration/11    S ffffffff986f3040 14128    87      2 0x00000000
[ 2407.983317]  ffff8805553c3d88 0000000000000002 ffff8805553c3d28 ffffffff00000000
[ 2407.984650]  ffff8805553bb000 ffff8805553c0010 ffff8805553c0000 000000009374c1e0
[ 2407.986039]  ffff8800683b3000 ffff8805553bb000 ffff8805553c3d78 0000000000000000
[ 2407.987381] Call Trace:
[ 2407.987809] schedule (kernel/sched/core.c:2895)
[ 2407.988649] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2407.990024] ? res_counter_memparse_write_strategy ()
[ 2407.991264] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2407.992220] kthread (kernel/kthread.c:207)
[ 2407.993069] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2407.994245] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.995270] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2407.996197] ? flush_kthread_work (kernel/kthread.c:176)
[ 2407.997372] rcuc/11         S ffffffff986f3040 13792    88      2 0x00000000
[ 2407.998662]  ffff8805553c7d88 0000000000000002 ffff8805553c7d48 ffffffff00000000
[ 2408.000325]  ffff8805553c8000 ffff8805553c4010 ffff8805553c4000 00000001d647d880
[ 2408.001681]  ffff8805553cb000 ffff8805553c8000 ffff8805553c8000 0000000000000000
[ 2408.003024] Call Trace:
[ 2408.003455] schedule (kernel/sched/core.c:2895)
[ 2408.004299] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.005299] ? rcu_sysidle_cb ()
[ 2408.006288] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.007254] kthread (kernel/kthread.c:207)
[ 2408.008112] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.009199] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.010020] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.010950] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.012025] ksoftirqd/11    S ffffffff986f3040 13616    89      2 0x00000000
[ 2408.013313]  ffff8805553d3d88 0000000000000002 ffff8805553d3d38 ffffffff00000000
[ 2408.014648]  ffff8805553cb000 ffff8805553d0010 ffff8805553d0000 00000001d6497fdd
[ 2408.015956]  ffff8800683b3000 ffff8805553cb000 ffff8805553d3dd8 0000000000000000
[ 2408.017317] Call Trace:
[ 2408.017743] schedule (kernel/sched/core.c:2895)
[ 2408.018596] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.020026] ? tasklet_init (kernel/softirq.c:646)
[ 2408.020956] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.022016] kthread (kernel/kthread.c:207)
[ 2408.022875] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.023962] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.025021] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.026027] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.027123] kworker/11:0    S ffffffff986f3040 13728    90      2 0x00000000
[ 2408.028411]  ffff8805553e3d58 0000000000000002 ffffffff911eeacf ffff880500000000
[ 2408.029767]  ffff8805553d8000 ffff8805553e0010 ffff8805553e0000 00000001cabe423a
[ 2408.030916]  ffff8805549b8000 ffff8805553d8000 ffff8805553e3d48 0000000000000000
[ 2408.032269] Call Trace:
[ 2408.032704] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.033782] schedule (kernel/sched/core.c:2895)
[ 2408.034684] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.035649] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.036690] kthread (kernel/kthread.c:207)
[ 2408.037671] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.038740] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.040021] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.041104] kworker/11:0H   S ffffffff986f3040 14144    91      2 0x00000000
[ 2408.042461]  ffff8805553e7d58 0000000000000002 ffffffff911eeacf ffff880500000000
[ 2408.043893]  ffff8805553db000 ffff8805553e4010 ffff8805553e4000 000000018ed9cbdc
[ 2408.045293]  ffff8800683b3000 ffff8805553db000 ffff8805553e7d48 0000000000000000
[ 2408.046787] Call Trace:
[ 2408.047224] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.048261] schedule (kernel/sched/core.c:2895)
[ 2408.049144] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.050020] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.050991] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.052089] kthread (kernel/kthread.c:207)
[ 2408.053011] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.054122] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.055034] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.056127] kworker/u76:0   S ffffffff986f3040 13568    92      2 0x00000000
[ 2408.057473]  ffff88055481bd58 0000000000000002 ffffffff911eeacf ffff880500000000
[ 2408.059041]  ffff880554810000 ffff880554818010 ffff880554818000 000000018c039e3d
[ 2408.060621]  ffff8800683b3000 ffff880554810000 ffff88055481bd48 0000000000000000
[ 2408.062151] Call Trace:
[ 2408.062687] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.063881] schedule (kernel/sched/core.c:2895)
[ 2408.064757] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.065732] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.066810] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.067852] kthread (kernel/kthread.c:207)
[ 2408.068802] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.070030] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.071152] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.072326] watchdog/12     S ffffffff986f3040 13680    93      2 0x00000000
[ 2408.073833]  ffff8805c33b3d88 0000000000000002 000000000000000c ffff880500000000
[ 2408.075200]  ffff8805c33a8000 ffff8805c33b0010 ffff8805c33b0000 0000022f2eb0a501
[ 2408.076559]  ffff8801e4f90000 ffff8805c33a8000 ffff8805c33a8000 0000000000000000
[ 2408.077930] Call Trace:
[ 2408.078373] schedule (kernel/sched/core.c:2895)
[ 2408.079247] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.080026] ? touch_nmi_watchdog ()
[ 2408.081106] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.082281] kthread (kernel/kthread.c:207)
[ 2408.083170] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.084297] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.085397] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.086441] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.087498] migration/12    S ffffffff986f3040 14128    94      2 0x00000000
[ 2408.088749]  ffff8805c33b7d88 0000000000000002 ffff8805c33b7d28 ffffffff00000000
[ 2408.090595]  ffff8805c33ab000 ffff8805c33b4010 ffff8805c33b4000 000000009375031f
[ 2408.091971]  ffff8801e4f90000 ffff8805c33ab000 ffff8805c33b7d78 0000000000000000
[ 2408.093296] Call Trace:
[ 2408.093933] schedule (kernel/sched/core.c:2895)
[ 2408.094796] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.095799] ? res_counter_memparse_write_strategy ()
[ 2408.097074] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.098026] kthread (kernel/kthread.c:207)
[ 2408.098859] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.100020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.101122] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.102317] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.103492] rcuc/12         S ffffffff986f3040 14128    95      2 0x00000000
[ 2408.104847]  ffff8805c33c3d88 0000000000000002 0000000100000000 0000000000000000
[ 2408.106529]  ffff8805c33b8000 ffff8805c33c0010 ffff8805c33c0000 0000000062e2d70d
[ 2408.107947]  ffff8805c33bb000 ffff8805c33b8000 ffff8805c33b8000 0000000000000000
[ 2408.109449] Call Trace:
[ 2408.110020] schedule (kernel/sched/core.c:2895)
[ 2408.110892] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.111970] ? rcu_sysidle_cb ()
[ 2408.112932] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.114060] kthread (kernel/kthread.c:207)
[ 2408.114922] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.115987] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.117077] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.118403] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.119842] ksoftirqd/12    S ffffffff986f3040 14128    96      2 0x00000000
[ 2408.120779]  ffff8805c33c7d88 0000000000000002 ffff8805c33c7d38 ffffffff00000000
[ 2408.122663]  ffff8805c33bb000 ffff8805c33c4010 ffff8805c33c4000 0000000062e2d70d
[ 2408.124041]  ffff8805c33a8000 ffff8805c33bb000 ffff8805c33c7dd8 0000000000000000
[ 2408.125408] Call Trace:
[ 2408.125838] schedule (kernel/sched/core.c:2895)
[ 2408.126755] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.127829] ? tasklet_init (kernel/softirq.c:646)
[ 2408.128777] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.130019] kthread (kernel/kthread.c:207)
[ 2408.130943] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.132136] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.133187] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.134222] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.135263] kworker/12:0    S ffffffff986f3040 14176    97      2 0x00000000
[ 2408.136540]  ffff8805c33cfd58 0000000000000002 ffffffff911eeacf ffff880500000000
[ 2408.137998]  ffff8805c33d0000 ffff8805c33cc010 ffff8805c33cc000 000000018e68c6a9
[ 2408.139490]  ffff8801e4f90000 ffff8805c33d0000 ffff8805c33cfd48 0000000000000000
[ 2408.140864] Call Trace:
[ 2408.141327] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.142373] schedule (kernel/sched/core.c:2895)
[ 2408.143377] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.144331] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.145253] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.146437] kthread (kernel/kthread.c:207)
[ 2408.147544] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.148967] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.150019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.151106] kworker/12:0H   S ffffffff986f3040 14144    98      2 0x00000000
[ 2408.152367]  ffff8805c33dbd58 0000000000000002 ffffffff911eeacf ffff880500000000
[ 2408.153923]  ffff8805c33d3000 ffff8805c33d8010 ffff8805c33d8000 000000018ede51a0
[ 2408.155504]  ffff8801e4f90000 ffff8805c33d3000 ffff8805c33dbd48 0000000000000000
[ 2408.156969] Call Trace:
[ 2408.157409] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.158617] schedule (kernel/sched/core.c:2895)
[ 2408.159494] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.160019] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.161061] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.162126] kthread (kernel/kthread.c:207)
[ 2408.162999] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.164071] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.165106] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.166270] kworker/u77:0   S ffffffff986f3040 14144    99      2 0x00000000
[ 2408.167624]  ffff8805c2c0bd58 0000000000000002 ffffffff911eeacf ffff880500000000
[ 2408.169120]  ffff8805c2c00000 ffff8805c2c08010 ffff8805c2c08000 000000018c039e3d
[ 2408.170987]  ffff8801e4f90000 ffff8805c2c00000 ffff8805c2c0bd48 0000000000000000
[ 2408.172430] Call Trace:
[ 2408.172871] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.173928] schedule (kernel/sched/core.c:2895)
[ 2408.174786] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.175762] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.176729] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.177913] kthread (kernel/kthread.c:207)
[ 2408.178841] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.180018] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.180978] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.182129] watchdog/13     S ffffffff986f3040 13680   100      2 0x00000000
[ 2408.183462]  ffff8806313b3d88 0000000000000002 000000000000000d ffff880600000000
[ 2408.184804]  ffff880631393000 ffff8806313b0010 ffff8806313b0000 0000022f307a90d6
[ 2408.186230]  ffff880479390000 ffff880631393000 ffff880631393000 0000000000000000
[ 2408.187565] Call Trace:
[ 2408.188009] schedule (kernel/sched/core.c:2895)
[ 2408.188890] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.190023] ? touch_nmi_watchdog ()
[ 2408.191051] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.192065] kthread (kernel/kthread.c:207)
[ 2408.192988] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.194152] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.195203] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.196140] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.197288] migration/13    S ffffffff986f3040 14128   101      2 0x00000000
[ 2408.198578]  ffff8806313b7d88 0000000000000002 ffff8806313b7d28 ffffffff00000000
[ 2408.200340]  ffff8806313b8000 ffff8806313b4010 ffff8806313b4000 000000009375498f
[ 2408.201845]  ffff880479390000 ffff8806313b8000 ffff8806313b7d78 0000000000000000
[ 2408.203240] Call Trace:
[ 2408.203722] schedule (kernel/sched/core.c:2895)
[ 2408.204637] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.205845] ? res_counter_memparse_write_strategy ()
[ 2408.207155] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.208166] kthread (kernel/kthread.c:207)
[ 2408.209059] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.210020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.211142] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.212128] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.213205] rcuc/13         S ffffffff986f3040 13984   102      2 0x00000000
[ 2408.214636]  ffff8806313c3d88 0000000000000002 ffff8806313c3d48 ffffffff00000000
[ 2408.216030]  ffff8806313bb000 ffff8806313c0010 ffff8806313c0000 0000000153253e81
[ 2408.217491]  ffff8806313c8000 ffff8806313bb000 ffff8806313bb000 0000000000000000
[ 2408.218845] Call Trace:
[ 2408.219294] schedule (kernel/sched/core.c:2895)
[ 2408.220022] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.221070] ? rcu_sysidle_cb ()
[ 2408.222143] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.223178] kthread (kernel/kthread.c:207)
[ 2408.224103] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.225333] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.226502] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.227517] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.228683] ksoftirqd/13    S ffffffff986f3040 13616   103      2 0x00000000
[ 2408.230566]  ffff8806313c7d88 0000000000000002 ffff8806313c7d48 0000000000000000
[ 2408.232036]  ffff8806313c8000 ffff8806313c4010 ffff8806313c4000 00000008f29b4380
[ 2408.233483]  ffff880479390000 ffff8806313c8000 ffff8806313c7d78 0000000000000000
[ 2408.235007] Call Trace:
[ 2408.235460] schedule (kernel/sched/core.c:2895)
[ 2408.236355] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.237391] ? tasklet_init (kernel/softirq.c:646)
[ 2408.238519] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.239575] kthread (kernel/kthread.c:207)
[ 2408.240019] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.241240] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.242441] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.243434] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.244556] kworker/13:0    S ffffffff986f3040 14176   104      2 0x00000000
[ 2408.246008]  ffff8806313d7d58 0000000000000002 ffffffff911eeacf ffff880600000000
[ 2408.247483]  ffff8806313cb000 ffff8806313d4010 ffff8806313d4000 000000018e68c6a9
[ 2408.248924]  ffff880479390000 ffff8806313cb000 ffff8806313d7d48 0000000000000000
[ 2408.250946] Call Trace:
[ 2408.251405] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.252420] schedule (kernel/sched/core.c:2895)
[ 2408.253311] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.254390] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.255376] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.256476] kthread (kernel/kthread.c:207)
[ 2408.257391] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.258549] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.259521] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.260022] kworker/13:0H   S ffffffff986f3040 14144   105      2 0x00000000
[ 2408.261416]  ffff8806313e3d58 0000000000000002 ffffffff911eeacf ffff880600000000
[ 2408.262798]  ffff8806313d8000 ffff8806313e0010 ffff8806313e0000 000000018ed9cbdc
[ 2408.264154]  ffff880479390000 ffff8806313d8000 ffff8806313e3d48 0000000000000000
[ 2408.265550] Call Trace:
[ 2408.266014] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.267007] schedule (kernel/sched/core.c:2895)
[ 2408.267889] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.268918] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.269913] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.269913] kthread (kernel/kthread.c:207)
[ 2408.269913] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.269913] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.269913] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.269913] kworker/u78:0   S ffffffff986f3040 14176   106      2 0x00000000
[ 2408.269913]  ffff880630c0bd58 0000000000000002 ffffffff911eeacf ffff880600000000
[ 2408.269913]  ffff8806313db000 ffff880630c08010 ffff880630c08000 000000018c039e3d
[ 2408.280064]  ffff880479390000 ffff8806313db000 ffff880630c0bd48 0000000000000000
[ 2408.281493] Call Trace:
[ 2408.281977] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.283014] schedule (kernel/sched/core.c:2895)
[ 2408.283902] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.284861] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.285911] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.286959] kthread (kernel/kthread.c:207)
[ 2408.287864] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.288950] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.290023] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.291114] watchdog/14     S ffffffff986f3040 14032   107      2 0x00000000
[ 2408.292396]  ffff88069f32bd88 0000000000000002 000000000000000e ffff880600000000
[ 2408.293806]  ffff88069f30b000 ffff88069f328010 ffff88069f328000 0000022f32dcc0e0
[ 2408.295195]  ffff8807e5370000 ffff88069f30b000 ffff88069f30b000 0000000000000000
[ 2408.296595] Call Trace:
[ 2408.297053] schedule (kernel/sched/core.c:2895)
[ 2408.298044] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.299083] ? touch_nmi_watchdog ()
[ 2408.300019] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.301005] kthread (kernel/kthread.c:207)
[ 2408.302005] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.303120] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.304211] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.305153] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.306279] migration/14    S ffffffff986f3040 14128   108      2 0x00000000
[ 2408.307600]  ffff88069f32fd88 0000000000000002 ffff88069f32fd28 ffffffff00000000
[ 2408.309016]  ffff88069f330000 ffff88069f32c010 ffff88069f32c000 000000009375885f
[ 2408.310614]  ffff8807e5370000 ffff88069f330000 ffff88069f32fd78 0000000000000000
[ 2408.312000] Call Trace:
[ 2408.312505] schedule (kernel/sched/core.c:2895)
[ 2408.313457] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.314552] ? res_counter_memparse_write_strategy ()
[ 2408.315839] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.316816] kthread (kernel/kthread.c:207)
[ 2408.317749] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.318870] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.320021] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.320945] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.322138] rcuc/14         S ffffffff986f3040 13984   109      2 0x00000000
[ 2408.323485]  ffff88069f33bd88 0000000000000002 ffff88069f33bd48 ffffffff00000000
[ 2408.324822]  ffff88069f333000 ffff88069f338010 ffff88069f338000 00000001368a4a80
[ 2408.326198]  ffff88069f340000 ffff88069f333000 ffff88069f333000 0000000000000000
[ 2408.327524] Call Trace:
[ 2408.327955] schedule (kernel/sched/core.c:2895)
[ 2408.328803] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.330026] ? rcu_sysidle_cb ()
[ 2408.331010] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.331989] kthread (kernel/kthread.c:207)
[ 2408.332862] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.333995] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.335064] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.335992] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.337036] ksoftirqd/14    S ffffffff986f3040 14128   110      2 0x00000000
[ 2408.338359]  ffff88069f33fd88 0000000000000002 ffff88069f33fd48 0000000000000000
[ 2408.339735]  ffff88069f340000 ffff88069f33c010 ffff88069f33c000 00000215543bc17b
[ 2408.340890]  ffff8807e5370000 ffff88069f340000 ffff88069f33fd78 0000000000000000
[ 2408.342329] Call Trace:
[ 2408.342782] schedule (kernel/sched/core.c:2895)
[ 2408.343654] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.344711] ? tasklet_init (kernel/softirq.c:646)
[ 2408.345762] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.346768] kthread (kernel/kthread.c:207)
[ 2408.347689] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.348781] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.349723] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.350019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.351078] kworker/14:0    S ffffffff986f3040 14176   111      2 0x00000000
[ 2408.352343]  ffff88069f34fd58 0000000000000002 ffffffff911eeacf ffff880600000000
[ 2408.353748]  ffff88069f343000 ffff88069f34c010 ffff88069f34c000 000000018e68c6a9
[ 2408.355175]  ffff8807e5370000 ffff88069f343000 ffff88069f34fd48 0000000000000000
[ 2408.356539] Call Trace:
[ 2408.357100] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.358123] schedule (kernel/sched/core.c:2895)
[ 2408.358988] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.360018] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.361054] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.362081] kthread (kernel/kthread.c:207)
[ 2408.362965] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.364045] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.365033] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.366140] kworker/14:0H   S ffffffff986f3040 14144   112      2 0x00000000
[ 2408.367435]  ffff88069f35bd58 0000000000000002 ffffffff911eeacf ffff880600000000
[ 2408.368877]  ffff88069f350000 ffff88069f358010 ffff88069f358000 000000018ed9cbdc
[ 2408.370883]  ffff8807e5370000 ffff88069f350000 ffff88069f35bd48 0000000000000000
[ 2408.372338] Call Trace:
[ 2408.372796] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.373880] schedule (kernel/sched/core.c:2895)
[ 2408.374711] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.375641] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.376683] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.377825] kthread (kernel/kthread.c:207)
[ 2408.378713] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.379748] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.380019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.381155] kworker/u79:0   S ffffffff986f3040 14176   113      2 0x00000000
[ 2408.382405]  ffff88069f383d58 0000000000000002 ffffffff911eeacf ffff880600000000
[ 2408.383721]  ffff88069f353000 ffff88069f380010 ffff88069f380000 000000018c039e3d
[ 2408.385066]  ffff8807e5370000 ffff88069f353000 ffff88069f383d48 0000000000000000
[ 2408.386449] Call Trace:
[ 2408.386891] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.387893] schedule (kernel/sched/core.c:2895)
[ 2408.388851] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.390018] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.390987] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.392047] kthread (kernel/kthread.c:207)
[ 2408.392939] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.394078] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.395011] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.396131] watchdog/15     S ffffffff986f3040 13680   114      2 0x00000000
[ 2408.397526]  ffff88070d3c3d88 0000000000000002 000000000000000f ffff880700000000
[ 2408.398895]  ffff88070d3b8000 ffff88070d3c0010 ffff88070d3c0000 0000022f35d7ac2a
[ 2408.400596]  ffff8800683d8000 ffff88070d3b8000 ffff88070d3b8000 0000000000000000
[ 2408.401978] Call Trace:
[ 2408.402442] schedule (kernel/sched/core.c:2895)
[ 2408.403342] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.404491] ? touch_nmi_watchdog ()
[ 2408.405611] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.406619] kthread (kernel/kthread.c:207)
[ 2408.407524] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.408620] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.410019] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.410956] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.412022] migration/15    S ffffffff986f3040 14128   115      2 0x00000000
[ 2408.413300]  ffff88070d3c7d88 0000000000000002 ffff88070d3c7d28 ffffffff00000000
[ 2408.414696]  ffff88070d3bb000 ffff88070d3c4010 ffff88070d3c4000 000000009375cf05
[ 2408.416074]  ffff8800683d8000 ffff88070d3bb000 ffff88070d3c7d78 0000000000000000
[ 2408.417425] Call Trace:
[ 2408.417981] schedule (kernel/sched/core.c:2895)
[ 2408.418876] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.419908] ? res_counter_memparse_write_strategy ()
[ 2408.420019] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.421105] kthread (kernel/kthread.c:207)
[ 2408.422013] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.423158] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.424268] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.425293] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.426384] rcuc/15         S ffffffff986f3040 14128   116      2 0x00000000
[ 2408.427700]  ffff88070d3d3d88 0000000000000002 0000000100000000 0000000000000000
[ 2408.430355]  ffff88070d3c8000 ffff88070d3d0010 ffff88070d3d0000 000000006a66fcf2
[ 2408.431757]  ffff88070d3cb000 ffff88070d3c8000 ffff88070d3c8000 0000000000000000
[ 2408.433127] Call Trace:
[ 2408.433601] schedule (kernel/sched/core.c:2895)
[ 2408.434471] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.435528] ? rcu_sysidle_cb ()
[ 2408.436502] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.437535] kthread (kernel/kthread.c:207)
[ 2408.438397] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.439491] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.440021] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.441035] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.442092] ksoftirqd/15    S ffffffff986f3040 14128   117      2 0x00000000
[ 2408.443363]  ffff88070d3d7d88 0000000000000002 ffff88070d3d7d48 0000000000000000
[ 2408.444720]  ffff88070d3cb000 ffff88070d3d4010 ffff88070d3d4000 0000021d35ce8089
[ 2408.446105]  ffff8800683d8000 ffff88070d3cb000 ffff88070d3d7d78 0000000000000000
[ 2408.447450] Call Trace:
[ 2408.447897] schedule (kernel/sched/core.c:2895)
[ 2408.448771] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.450024] ? tasklet_init (kernel/softirq.c:646)
[ 2408.450966] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.451936] kthread (kernel/kthread.c:207)
[ 2408.452795] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.453972] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.455009] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.455934] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.456986] kworker/15:0    S ffffffff986f3040 14176   118      2 0x00000000
[ 2408.458325]  ffff88070d3dfd58 0000000000000002 ffffffff911eeacf ffff880700000000
[ 2408.460065]  ffff88070d3e0000 ffff88070d3dc010 ffff88070d3dc000 000000018e68c6a9
[ 2408.461474]  ffff8800683d8000 ffff88070d3e0000 ffff88070d3dfd48 0000000000000000
[ 2408.462818] Call Trace:
[ 2408.463268] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.464266] schedule (kernel/sched/core.c:2895)
[ 2408.465123] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.466166] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.467112] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.468163] kthread (kernel/kthread.c:207)
[ 2408.469040] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.470019] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.470977] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.472056] kworker/15:0H   S ffffffff986f3040 14144   119      2 0x00000000
[ 2408.473408]  ffff88070d3ebd58 0000000000000002 ffffffff911eeacf ffff880700000000
[ 2408.474783]  ffff88070d3e3000 ffff88070d3e8010 ffff88070d3e8000 000000018ed9cbdc
[ 2408.476164]  ffff8800683d8000 ffff88070d3e3000 ffff88070d3ebd48 0000000000000000
[ 2408.477611] Call Trace:
[ 2408.478043] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.479037] schedule (kernel/sched/core.c:2895)
[ 2408.480018] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.480966] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.482064] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.483110] kthread (kernel/kthread.c:207)
[ 2408.483994] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.485075] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.486048] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.487114] kworker/u80:0   S ffffffff986f3040 14176   120      2 0x00000000
[ 2408.488394]  ffff88070a01bd58 0000000000000002 ffffffff911eeacf ffff880700000000
[ 2408.490066]  ffff88070a010000 ffff88070a018010 ffff88070a018000 000000018beebcd0
[ 2408.491440]  ffff8800683d8000 ffff88070a010000 ffff88070a01bd48 0000000000000000
[ 2408.492793] Call Trace:
[ 2408.493229] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.494278] schedule (kernel/sched/core.c:2895)
[ 2408.495127] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.496096] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.497090] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.498231] kthread (kernel/kthread.c:207)
[ 2408.499146] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.500020] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.500993] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.502207] watchdog/16     S ffffffff986f3040 14032   121      2 0x00000000
[ 2408.503546]  ffff880779377d88 0000000000000002 0000000000000010 ffff880700000000
[ 2408.504946]  ffff880779383000 ffff880779374010 ffff880779374000 0000022f3839eee1
[ 2408.506431]  ffff8800683db000 ffff880779383000 ffff880779383000 0000000000000000
[ 2408.507817] Call Trace:
[ 2408.508280] schedule (kernel/sched/core.c:2895)
[ 2408.509179] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.510029] ? touch_nmi_watchdog ()
[ 2408.511136] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.512168] kthread (kernel/kthread.c:207)
[ 2408.513132] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.514245] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.515300] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.516253] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.517394] migration/16    S ffffffff986f3040 14128   122      2 0x00000000
[ 2408.518708]  ffff8807793abd88 0000000000000002 ffff8807793abd28 ffffffff00000000
[ 2408.520609]  ffff88077937b000 ffff8807793a8010 ffff8807793a8000 0000000093760aa1
[ 2408.522041]  ffff8800683db000 ffff88077937b000 ffff8807793abd78 0000000000000000
[ 2408.523377] Call Trace:
[ 2408.523810] schedule (kernel/sched/core.c:2895)
[ 2408.524648] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.525743] ? res_counter_memparse_write_strategy ()
[ 2408.527038] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.528020] kthread (kernel/kthread.c:207)
[ 2408.528892] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.530027] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.531136] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.532069] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.533109] rcuc/16         S ffffffff986f3040 14128   123      2 0x00000000
[ 2408.534423]  ffff8807793afd88 0000000000000002 0000000100000000 0000000000000000
[ 2408.535763]  ffff8807793b0000 ffff8807793ac010 ffff8807793ac000 000000006d10c974
[ 2408.537087]  ffff8807793b3000 ffff8807793b0000 ffff8807793b0000 0000000000000000
[ 2408.538545] Call Trace:
[ 2408.538994] schedule (kernel/sched/core.c:2895)
[ 2408.540018] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.541043] ? rcu_sysidle_cb ()
[ 2408.542105] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.543130] kthread (kernel/kthread.c:207)
[ 2408.544042] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.545154] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.546296] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.547224] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.548277] ksoftirqd/16    S ffffffff986f3040 14128   124      2 0x00000000
[ 2408.549609]  ffff8807793bbd88 0000000000000002 ffff8807793bbd48 0000000000000000
[ 2408.550856]  ffff8807793b3000 ffff8807793b8010 ffff8807793b8000 000000f926583d45
[ 2408.552170]  ffff8800683db000 ffff8807793b3000 ffff8807793bbd78 0000000000000000
[ 2408.553567] Call Trace:
[ 2408.554003] schedule (kernel/sched/core.c:2895)
[ 2408.554876] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.555906] ? tasklet_init (kernel/softirq.c:646)
[ 2408.556846] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.557947] kthread (kernel/kthread.c:207)
[ 2408.558835] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.560020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.561063] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.562101] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.563252] kworker/16:0    S ffffffff986f3040 14176   125      2 0x00000000
[ 2408.564540]  ffff8807793cbd58 0000000000000002 ffffffff911eeacf ffff880700000000
[ 2408.566004]  ffff8807793c0000 ffff8807793c8010 ffff8807793c8000 000000018e68c6a9
[ 2408.567378]  ffff8800683db000 ffff8807793c0000 ffff8807793cbd48 0000000000000000
[ 2408.568736] Call Trace:
[ 2408.569188] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.570019] schedule (kernel/sched/core.c:2895)
[ 2408.570888] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.571840] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.572787] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.573994] kthread (kernel/kthread.c:207)
[ 2408.574874] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.575957] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.576888] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.578034] kworker/16:0H   S ffffffff986f3040 14144   126      2 0x00000000
[ 2408.579355]  ffff8807793cfd58 0000000000000002 ffffffff911eeacf ffff880700000000
[ 2408.580874]  ffff8807793c3000 ffff8807793cc010 ffff8807793cc000 000000018ed9cbdc
[ 2408.582293]  ffff8800683db000 ffff8807793c3000 ffff8807793cfd48 0000000000000000
[ 2408.583670] Call Trace:
[ 2408.584104] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.585056] schedule (kernel/sched/core.c:2895)
[ 2408.585995] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.586980] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.587942] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.589090] kthread (kernel/kthread.c:207)
[ 2408.590028] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.591129] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.592055] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.593219] rcub/2          S ffffffff986f3040 14176   127      2 0x00000000
[ 2408.594499]  ffff880067d8bd58 0000000000000002 0000000000000001 ffff880000000000
[ 2408.595854]  ffff880067d80000 ffff880067d88010 ffff880067d88000 000000006c2b284f
[ 2408.597382]  ffff880479338000 ffff880067d80000 0000000000000282 0000000000000000
[ 2408.598832] Call Trace:
[ 2408.599485] schedule (kernel/sched/core.c:2895)
[ 2408.600021] rcu_boost_kthread ()
[ 2408.601547] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.602542] ? rcu_gp_kthread ()
[ 2408.603640] kthread (kernel/kthread.c:207)
[ 2408.604554] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.605779] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.606954] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.608059] kworker/u81:0   S ffffffff986f3040 14176   128      2 0x00000000
[ 2408.610056]  ffff8807793f7d58 0000000000000002 ffffffff911eeacf ffff880700000000
[ 2408.611802]  ffff8807793f8000 ffff8807793f4010 ffff8807793f4000 000000018bf65d0c
[ 2408.613319]  ffff8800683db000 ffff8807793f8000 ffff8807793f7d48 0000000000000000
[ 2408.614728] Call Trace:
[ 2408.615319] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.616354] schedule (kernel/sched/core.c:2895)
[ 2408.617316] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.618351] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.619291] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.620018] kthread (kernel/kthread.c:207)
[ 2408.621040] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.622092] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.623031] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.624150] watchdog/17     S ffffffff986f3040 13536   129      2 0x00000000
[ 2408.625550]  ffff8807e535fd88 0000000000000002 0000000000000011 ffff880700000000
[ 2408.626934]  ffff8807e5373000 ffff8807e535c010 ffff8807e535c000 0000022f3bcdffc3
[ 2408.628295]  ffff880176ef0000 ffff8807e5373000 ffff8807e5373000 0000000000000000
[ 2408.630636] Call Trace:
[ 2408.630956] schedule (kernel/sched/core.c:2895)
[ 2408.631596] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.632233] ? touch_nmi_watchdog ()
[ 2408.632946] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.634015] kthread (kernel/kthread.c:207)
[ 2408.634890] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.635956] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.637041] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.637963] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.639038] migration/17    S ffffffff986f3040 14128   130      2 0x00000000
[ 2408.640014]  ffff8807e538bd88 0000000000000002 ffff8807e538bd28 ffffffff00000000
[ 2408.641824]  ffff8807e536b000 ffff8807e5388010 ffff8807e5388000 000000009376445f
[ 2408.643203]  ffff880176ef0000 ffff8807e536b000 ffff8807e538bd78 0000000000000000
[ 2408.644589] Call Trace:
[ 2408.645172] schedule (kernel/sched/core.c:2895)
[ 2408.646119] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.647249] ? res_counter_memparse_write_strategy ()
[ 2408.648611] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.650032] kthread (kernel/kthread.c:207)
[ 2408.650951] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.652054] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.653141] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.654202] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.655273] rcuc/17         S ffffffff986f3040 13984   131      2 0x00000000
[ 2408.656538]  ffff8807e538fd88 0000000000000002 ffff8807e538fd48 ffffffff00000000
[ 2408.658012]  ffff8807e5363000 ffff8807e538c010 ffff8807e538c000 00000001cfceed3f
[ 2408.659347]  ffff8807e5390000 ffff8807e5363000 ffff8807e5363000 0000000000000000
[ 2408.660864] Call Trace:
[ 2408.661313] schedule (kernel/sched/core.c:2895)
[ 2408.662260] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.663315] ? rcu_sysidle_cb ()
[ 2408.664313] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.665455] kthread (kernel/kthread.c:207)
[ 2408.666418] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.667569] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.668673] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.669793] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.670019] ksoftirqd/17    S ffffffff986f3040 14128   132      2 0x00000000
[ 2408.671310]  ffff8807e539bd88 0000000000000002 ffff8807e539bd38 ffffffff00000000
[ 2408.672738]  ffff8807e5390000 ffff8807e5398010 ffff8807e5398000 00000001d053ba8e
[ 2408.674119]  ffff880068248000 ffff8807e5390000 ffff8807e539bdd8 0000000000000000
[ 2408.675156] Call Trace:
[ 2408.675560] schedule (kernel/sched/core.c:2895)
[ 2408.676436] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.677569] ? tasklet_init (kernel/softirq.c:646)
[ 2408.678596] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.679666] kthread (kernel/kthread.c:207)
[ 2408.679666] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.679666] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.679666] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.679666] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.679666] kworker/17:0    S ffffffff986f3040 13584   133      2 0x00000000
[ 2408.679666]  ffff8807e53a3d58 0000000000000002 ffffffff911eeacf ffff880700000000
[ 2408.679666]  ffff8807e5393000 ffff8807e53a0010 ffff8807e53a0000 00000001d0ba88f8
[ 2408.690352]  ffff880068248000 ffff8807e5393000 ffff8807e53a3d48 0000000000000000
[ 2408.691775] Call Trace:
[ 2408.692237] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.693333] schedule (kernel/sched/core.c:2895)
[ 2408.694229] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.695221] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.696303] kthread (kernel/kthread.c:207)
[ 2408.697286] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.698376] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.699379] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.700019] kworker/17:0H   S ffffffff986f3040 14144   134      2 0x00000000
[ 2408.701388]  ffff8807e53a7d58 0000000000000002 ffffffff911eeacf ffff880700000000
[ 2408.702810]  ffff8807e53a8000 ffff8807e53a4010 ffff8807e53a4000 000000018ee2f679
[ 2408.704187]  ffff880176ef0000 ffff8807e53a8000 ffff8807e53a7d48 0000000000000000
[ 2408.705733] Call Trace:
[ 2408.706213] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.707231] schedule (kernel/sched/core.c:2895)
[ 2408.708117] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.709181] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.710021] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.711116] kthread (kernel/kthread.c:207)
[ 2408.712033] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.713240] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.714225] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.715372] kworker/u82:0   S ffffffff986f3040 14144   135      2 0x00000000
[ 2408.716873]  ffff8807e53dbd58 0000000000000002 ffffffff911eeacf ffff880700000000
[ 2408.720015]  ffff8807e53ab000 ffff8807e53d8010 ffff8807e53d8000 000000018c085361
[ 2408.721488]  ffff880176ef0000 ffff8807e53ab000 ffff8807e53dbd48 0000000000000000
[ 2408.722953] Call Trace:
[ 2408.723426] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.724479] schedule (kernel/sched/core.c:2895)
[ 2408.725447] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.726476] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.727589] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.728715] kthread (kernel/kthread.c:207)
[ 2408.729747] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.730022] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.730996] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.732116] watchdog/18     S ffffffff986f3040 14032   136      2 0x00000000
[ 2408.733555]  ffff88085139bd88 0000000000000002 0000000000000012 ffff880800000000
[ 2408.735024]  ffff880851390000 ffff880851398010 ffff880851398000 0000022f3d972376
[ 2408.736552]  ffff880252f78000 ffff880851390000 ffff880851390000 0000000000000000
[ 2408.737993] Call Trace:
[ 2408.738446] schedule (kernel/sched/core.c:2895)
[ 2408.740022] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.741227] ? touch_nmi_watchdog ()
[ 2408.742358] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.743449] kthread (kernel/kthread.c:207)
[ 2408.744443] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.745713] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.746933] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.747984] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.749136] migration/18    S ffffffff986f3040 14128   137      2 0x00000000
[ 2408.750562]  ffff88085139fd88 0000000000000002 ffff88085139fd28 ffffffff00000000
[ 2408.752011]  ffff880851393000 ffff88085139c010 ffff88085139c000 00000000937680ac
[ 2408.753572]  ffff880252f78000 ffff880851393000 ffff88085139fd78 0000000000000000
[ 2408.755038] Call Trace:
[ 2408.755534] schedule (kernel/sched/core.c:2895)
[ 2408.756480] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.757698] ? res_counter_memparse_write_strategy ()
[ 2408.759244] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.760021] kthread (kernel/kthread.c:207)
[ 2408.761099] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.762306] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.763387] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.764349] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.765561] rcuc/18         S ffffffff986f3040 13792   138      2 0x00000000
[ 2408.766991]  ffff8808513abd88 0000000000000002 ffff8808513abd48 ffffffff00000000
[ 2408.768386]  ffff8808513a0000 ffff8808513a8010 ffff8808513a8000 00000001e36356d2
[ 2408.770379]  ffff8808513a3000 ffff8808513a0000 ffff8808513a0000 0000000000000000
[ 2408.771804] Call Trace:
[ 2408.772253] schedule (kernel/sched/core.c:2895)
[ 2408.773125] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.774368] ? rcu_sysidle_cb ()
[ 2408.775416] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.776467] kthread (kernel/kthread.c:207)
[ 2408.777541] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.779006] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.780020] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.781014] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.782416] ksoftirqd/18    S ffffffff986f3040 13616   139      2 0x00000000
[ 2408.783753]  ffff8808513afd88 0000000000000002 ffff8808513afd48 0000000000000000
[ 2408.785176]  ffff8808513a3000 ffff8808513ac010 ffff8808513ac000 0000021243327c2b
[ 2408.786596]  ffff880252f78000 ffff8808513a3000 ffff8808513afd78 0000000000000000
[ 2408.787971] Call Trace:
[ 2408.788405] schedule (kernel/sched/core.c:2895)
[ 2408.789444] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.790025] ? tasklet_init (kernel/softirq.c:646)
[ 2408.791084] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.792189] kthread (kernel/kthread.c:207)
[ 2408.793173] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.794283] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.795377] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.796343] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.797476] kworker/18:0    S ffffffff986f3040 13376   140      2 0x00000000
[ 2408.798839]  ffff8808513b7d58 0000000000000002 ffffffff911eeacf ffff880800000000
[ 2408.800912]  ffff8808513b8000 ffff8808513b4010 ffff8808513b4000 00000001ce42a914
[ 2408.802461]  ffff8807e4d8b000 ffff8808513b8000 ffff8808513b7d48 0000000000000000
[ 2408.803926] Call Trace:
[ 2408.804416] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.805450] schedule (kernel/sched/core.c:2895)
[ 2408.806491] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.807626] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.809315] kthread (kernel/kthread.c:207)
[ 2408.810029] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.811645] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.813000] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.814236] kworker/18:0H   S ffffffff986f3040 14144   141      2 0x00000000
[ 2408.815570]  ffff8808513c3d58 0000000000000002 ffffffff911eeacf ffff880800000000
[ 2408.817436]  ffff8808513bb000 ffff8808513c0010 ffff8808513c0000 000000018ed9cbdc
[ 2408.820067]  ffff880252f78000 ffff8808513bb000 ffff8808513c3d48 0000000000000000
[ 2408.821517] Call Trace:
[ 2408.822323] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.823682] schedule (kernel/sched/core.c:2895)
[ 2408.824791] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.826061] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.827058] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.828654] kthread (kernel/kthread.c:207)
[ 2408.829930] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.830030] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.831386] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.833009] kworker/u83:0   S ffffffff986f3040 14176   142      2 0x00000000
[ 2408.834374]  ffff8808513f3d58 0000000000000002 ffffffff911eeacf ffff880800000000
[ 2408.835764]  ffff8808513e8000 ffff8808513f0010 ffff8808513f0000 000000018c0dbb27
[ 2408.837538]  ffff880252f78000 ffff8808513e8000 ffff8808513f3d48 0000000000000000
[ 2408.840064] Call Trace:
[ 2408.840511] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.841638] schedule (kernel/sched/core.c:2895)
[ 2408.842705] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.844200] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.845494] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.846940] kthread (kernel/kthread.c:207)
[ 2408.848320] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.850030] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.851252] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.852775] watchdog/19     S ffffffff986f3040 13536   143      2 0x00000000
[ 2408.854460]  ffff8808bd353d88 0000000000000002 0000000000000013 ffff880800000000
[ 2408.855811]  ffff8808bd348000 ffff8808bd350010 ffff8808bd350000 0000022f40924e6d
[ 2408.857595]  ffff88032ef48000 ffff8808bd348000 ffff8808bd348000 0000000000000000
[ 2408.860070] Call Trace:
[ 2408.860780] schedule (kernel/sched/core.c:2895)
[ 2408.862265] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.863526] ? touch_nmi_watchdog ()
[ 2408.864959] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.866307] kthread (kernel/kthread.c:207)
[ 2408.867238] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.868359] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.869752] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.870020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.871071] migration/19    S ffffffff986f3040 14128   144      2 0x00000000
[ 2408.872779]  ffff8808bd357d88 0000000000000002 ffff8808bd357d28 ffffffff00000000
[ 2408.874165]  ffff8808bd34b000 ffff8808bd354010 ffff8808bd354000 000000009376b971
[ 2408.875565]  ffff88032ef48000 ffff8808bd34b000 ffff8808bd357d78 0000000000000000
[ 2408.876991] Call Trace:
[ 2408.877476] schedule (kernel/sched/core.c:2895)
[ 2408.878486] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.880027] ? res_counter_memparse_write_strategy ()
[ 2408.882097] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.883389] kthread (kernel/kthread.c:207)
[ 2408.884343] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.885960] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.887456] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.888586] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.890018] rcuc/19         S ffffffff986f3040 13792   145      2 0x00000000
[ 2408.891390]  ffff8808bd363d88 0000000000000002 ffff8808bd363d48 ffffffff00000000
[ 2408.892861]  ffff8808bd358000 ffff8808bd360010 ffff8808bd360000 00000001e19a7375
[ 2408.894466]  ffff8808bd35b000 ffff8808bd358000 ffff8808bd358000 0000000000000000
[ 2408.895940] Call Trace:
[ 2408.896443] schedule (kernel/sched/core.c:2895)
[ 2408.897427] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.898617] ? rcu_sysidle_cb ()
[ 2408.900023] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.901154] kthread (kernel/kthread.c:207)
[ 2408.902175] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.903298] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.904421] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.905456] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.906582] ksoftirqd/19    S ffffffff986f3040 13616   146      2 0x00000000
[ 2408.907907]  ffff8808bd367d88 0000000000000002 ffff8808bd367d48 0000000000000000
[ 2408.909571]  ffff8808bd35b000 ffff8808bd364010 ffff8808bd364000 00000001e19dd7e9
[ 2408.910936]  ffff8808bd3ab000 ffff8808bd35b000 ffff8808bd367d78 0000000000000000
[ 2408.912473] Call Trace:
[ 2408.913001] schedule (kernel/sched/core.c:2895)
[ 2408.913886] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.914972] ? tasklet_init (kernel/softirq.c:646)
[ 2408.915918] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.916955] kthread (kernel/kthread.c:207)
[ 2408.917857] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.919004] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.920020] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.921059] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.922169] kworker/19:0    S ffffffff986f3040 13376   147      2 0x00000000
[ 2408.923456]  ffff8808bd36fd58 0000000000000002 ffffffff911eeacf ffff880800000000
[ 2408.924901]  ffff8808bd370000 ffff8808bd36c010 ffff8808bd36c000 00000001d47ec091
[ 2408.926296]  ffff8808bd3ab000 ffff8808bd370000 ffff8808bd36fd48 0000000000000000
[ 2408.927697] Call Trace:
[ 2408.928145] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.929242] schedule (kernel/sched/core.c:2895)
[ 2408.930026] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.931022] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.932131] kthread (kernel/kthread.c:207)
[ 2408.933209] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.934285] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.935262] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.936408] kworker/19:0H   S ffffffff986f3040 14176   148      2 0x00000000
[ 2408.937950]  ffff8808bd37bd58 0000000000000002 ffffffff911eeacf ffff880800000000
[ 2408.940346]  ffff8808bd373000 ffff8808bd378010 ffff8808bd378000 000000018ed9cbdc
[ 2408.942232]  ffff88032ef48000 ffff8808bd373000 ffff8808bd37bd48 0000000000000000
[ 2408.943689] Call Trace:
[ 2408.944145] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.945315] schedule (kernel/sched/core.c:2895)
[ 2408.946206] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.947239] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.948365] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.949620] kthread (kernel/kthread.c:207)
[ 2408.950031] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.951292] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.952398] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.954094] kworker/u84:0   S ffffffff986f3040 14176   149      2 0x00000000
[ 2408.955374]  ffff8808bd3a7d58 0000000000000002 ffffffff911eeacf ffff880800000000
[ 2408.957319]  ffff8808bd3a8000 ffff8808bd3a4010 ffff8808bd3a4000 000000018bf2c57c
[ 2408.959272]  ffff88032ef48000 ffff8808bd3a8000 ffff8808bd3a7d48 0000000000000000
[ 2408.961093] Call Trace:
[ 2408.961551] ? worker_thread (kernel/workqueue.c:2176)
[ 2408.962940] schedule (kernel/sched/core.c:2895)
[ 2408.963825] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2408.964825] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2408.966336] ? process_one_work (kernel/workqueue.c:2100)
[ 2408.967622] kthread (kernel/kthread.c:207)
[ 2408.968552] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.970026] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.971078] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.972417] watchdog/20     S ffffffff986f3040 14032   150      2 0x00000000
[ 2408.974122]  ffff880905377d88 0000000000000002 0000000000000014 ffff880900000000
[ 2408.975655]  ffff88090538b000 ffff880905374010 ffff880905374000 0000022f42f4abf1
[ 2408.977198]  ffff8804e7308000 ffff88090538b000 ffff88090538b000 0000000000000000
[ 2408.979255] Call Trace:
[ 2408.980028] schedule (kernel/sched/core.c:2895)
[ 2408.981230] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2408.982258] ? touch_nmi_watchdog ()
[ 2408.983284] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2408.984275] kthread (kernel/kthread.c:207)
[ 2408.985197] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2408.986571] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.988280] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2408.990027] ? flush_kthread_work (kernel/kthread.c:176)
[ 2408.991296] migration/20    S ffffffff986f3040 14128   151      2 0x00000000
[ 2408.993208]  ffff8809053b3d88 0000000000000002 ffff8809053b3d28 ffffffff00000000
[ 2408.994619]  ffff8809053a8000 ffff8809053b0010 ffff8809053b0000 000000009376f4cc
[ 2408.996008]  ffff8804e7308000 ffff8809053a8000 ffff8809053b3d78 0000000000000000
[ 2408.997662] Call Trace:
[ 2408.998149] schedule (kernel/sched/core.c:2895)
[ 2408.999370] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.000022] ? res_counter_memparse_write_strategy ()
[ 2409.001702] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.002755] kthread (kernel/kthread.c:207)
[ 2409.003777] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.005055] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.006163] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.007148] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.008249] rcuc/20         S ffffffff986f3040 14128   152      2 0x00000000
[ 2409.010565]  ffff8809053b7d88 0000000000000002 0000000100000000 0000000000000000
[ 2409.011989]  ffff8809053ab000 ffff8809053b4010 ffff8809053b4000 0000000077c8d1cf
[ 2409.013717]  ffff8809053b8000 ffff8809053ab000 ffff8809053ab000 0000000000000000
[ 2409.015302] Call Trace:
[ 2409.015811] schedule (kernel/sched/core.c:2895)
[ 2409.017057] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.018239] ? rcu_sysidle_cb ()
[ 2409.019242] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.020020] kthread (kernel/kthread.c:207)
[ 2409.020871] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.021998] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.023101] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.024139] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.025252] ksoftirqd/20    S ffffffff986f3040 14128   153      2 0x00000000
[ 2409.026589]  ffff8809053c3d88 0000000000000002 ffff8809053c3d48 0000000000000000
[ 2409.027949]  ffff8809053b8000 ffff8809053c0010 ffff8809053c0000 000001b59f1ad8f4
[ 2409.029726]  ffff8804e7308000 ffff8809053b8000 ffff8809053c3d78 0000000000000000
[ 2409.031119] Call Trace:
[ 2409.031598] schedule (kernel/sched/core.c:2895)
[ 2409.032521] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.033798] ? tasklet_init (kernel/softirq.c:646)
[ 2409.034942] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.036230] kthread (kernel/kthread.c:207)
[ 2409.037643] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.039241] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.040037] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.041281] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.042394] kworker/20:0    S ffffffff986f3040 14144   154      2 0x00000000
[ 2409.044168]  ffff8809053cbd58 0000000000000002 ffffffff911eeacf ffff880900000000
[ 2409.045781]  ffff8809053bb000 ffff8809053c8010 ffff8809053c8000 000000018e68c6a9
[ 2409.047213]  ffff8804e7308000 ffff8809053bb000 ffff8809053cbd48 0000000000000000
[ 2409.050064] Call Trace:
[ 2409.050497] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.051576] schedule (kernel/sched/core.c:2895)
[ 2409.052613] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.053702] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.054626] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.055665] kthread (kernel/kthread.c:207)
[ 2409.056674] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.058006] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.059442] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.060000] kworker/20:0H   S ffffffff986f3040 14144   155      2 0x00000000
[ 2409.060000]  ffff8809053cfd58 0000000000000002 ffffffff911eeacf ffff880900000000
[ 2409.060000]  ffff8809053d8000 ffff8809053cc010 ffff8809053cc000 000000018ee772f5
[ 2409.060000]  ffff8804e7308000 ffff8809053d8000 ffff8809053cfd48 0000000000000000
[ 2409.060000] Call Trace:
[ 2409.060000] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.060000] schedule (kernel/sched/core.c:2895)
[ 2409.070019] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.070966] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.071946] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.073167] kthread (kernel/kthread.c:207)
[ 2409.074107] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.075198] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.076181] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.077380] kworker/u85:0   S ffffffff986f3040 14144   156      2 0x00000000
[ 2409.078780]  ffff880904c07d58 0000000000000002 ffffffff911eeacf ffff880900000000
[ 2409.080738]  ffff8809053db000 ffff880904c04010 ffff880904c04000 000000018c082869
[ 2409.082262]  ffff8804e7308000 ffff8809053db000 ffff880904c07d48 0000000000000000
[ 2409.083769] Call Trace:
[ 2409.084437] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.085590] schedule (kernel/sched/core.c:2895)
[ 2409.086833] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.087853] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.088861] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.090022] kthread (kernel/kthread.c:207)
[ 2409.090952] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.092231] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.093272] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.094313] watchdog/21     S ffffffff986f3040 13536   157      2 0x00000000
[ 2409.095571]  ffff880067dc7d88 0000000000000002 0000000000000015 ffff880000000000
[ 2409.096950]  ffff880067dc8000 ffff880067dc4010 ffff880067dc4000 0000022f45ef819c
[ 2409.098684]  ffff880779378000 ffff880067dc8000 ffff880067dc8000 0000000000000000
[ 2409.100347] Call Trace:
[ 2409.100800] schedule (kernel/sched/core.c:2895)
[ 2409.101906] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.102998] ? touch_nmi_watchdog ()
[ 2409.104118] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.105265] kthread (kernel/kthread.c:207)
[ 2409.106374] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.107623] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.108832] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.109942] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.110019] migration/21    S ffffffff986f3040 14128   158      2 0x00000000
[ 2409.111490]  ffff880067dd7d88 0000000000000002 ffff880067dd7d28 ffffffff00000000
[ 2409.113029]  ffff880067dd8000 ffff880067dd4010 ffff880067dd4000 000000009377305d
[ 2409.114418]  ffff880779378000 ffff880067dd8000 ffff880067dd7d78 0000000000000000
[ 2409.115805] Call Trace:
[ 2409.116334] schedule (kernel/sched/core.c:2895)
[ 2409.117292] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.118350] ? res_counter_memparse_write_strategy ()
[ 2409.120023] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.121099] kthread (kernel/kthread.c:207)
[ 2409.122012] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.123117] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.124215] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.125281] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.126459] rcuc/21         S ffffffff986f3040 14128   159      2 0x00000000
[ 2409.127771]  ffff880067df7d88 0000000000000002 0000000100000000 0000000000000000
[ 2409.130063]  ffff880067df8000 ffff880067df4010 ffff880067df4000 000000007a6fccb9
[ 2409.131486]  ffff880067e08000 ffff880067df8000 ffff880067df8000 0000000000000000
[ 2409.132842] Call Trace:
[ 2409.133313] schedule (kernel/sched/core.c:2895)
[ 2409.134166] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.135182] ? rcu_sysidle_cb ()
[ 2409.136137] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.137191] kthread (kernel/kthread.c:207)
[ 2409.138104] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.139168] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.140019] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.140983] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.142082] ksoftirqd/21    S ffffffff986f3040 14128   160      2 0x00000000
[ 2409.143335]  ffff880067e07d88 0000000000000002 ffff880067e07d48 0000000000000000
[ 2409.144748]  ffff880067e08000 ffff880067e04010 ffff880067e04000 00000073d7eb5137
[ 2409.146192]  ffff880779378000 ffff880067e08000 ffff880067e07d78 0000000000000000
[ 2409.147543] Call Trace:
[ 2409.147976] schedule (kernel/sched/core.c:2895)
[ 2409.148813] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.150024] ? tasklet_init (kernel/softirq.c:646)
[ 2409.150956] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.151947] kthread (kernel/kthread.c:207)
[ 2409.152832] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.153920] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.154952] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.155873] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.156915] kworker/21:0    S ffffffff986f3040 14144   161      2 0x00000000
[ 2409.158226]  ffff880067e23d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2409.159604]  ffff880067e18000 ffff880067e20010 ffff880067e20000 000000018e68c6a9
[ 2409.160981]  ffff880779378000 ffff880067e18000 ffff880067e23d48 0000000000000000
[ 2409.162436] Call Trace:
[ 2409.162887] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.164110] schedule (kernel/sched/core.c:2895)
[ 2409.165087] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.166083] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.167089] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.168430] kthread (kernel/kthread.c:207)
[ 2409.169450] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.170019] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.170954] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.172007] kworker/21:0H   S ffffffff986f3040 14144   162      2 0x00000000
[ 2409.173389]  ffff880067e33d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2409.174745]  ffff880067e28000 ffff880067e30010 ffff880067e30000 000000018ed9cbdc
[ 2409.176077]  ffff880779378000 ffff880067e28000 ffff880067e33d48 0000000000000000
[ 2409.177486] Call Trace:
[ 2409.177974] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.178950] schedule (kernel/sched/core.c:2895)
[ 2409.180019] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.181131] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.182063] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.183132] kthread (kernel/kthread.c:207)
[ 2409.184018] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.185233] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.186181] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.187292] kworker/u86:0   S ffffffff986f3040 14176   163      2 0x00000000
[ 2409.188668]  ffff880067e87d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2409.190627]  ffff880067e88000 ffff880067e84010 ffff880067e84000 000000018bf896b1
[ 2409.192001]  ffff880779378000 ffff880067e88000 ffff880067e87d48 0000000000000000
[ 2409.193477] Call Trace:
[ 2409.193924] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.194936] schedule (kernel/sched/core.c:2895)
[ 2409.195842] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.196825] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.197928] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.198958] kthread (kernel/kthread.c:207)
[ 2409.200020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.201070] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.202013] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.203158] watchdog/22     S ffffffff986f3040 13536   164      2 0x00000000
[ 2409.204485]  ffff880067eafd88 0000000000000002 0000000000000016 ffff880000000000
[ 2409.205928]  ffff880067eb0000 ffff880067eac010 ffff880067eac000 0000022f4851d372
[ 2409.207321]  ffff880067c08000 ffff880067eb0000 ffff880067eb0000 0000000000000000
[ 2409.208721] Call Trace:
[ 2409.209243] schedule (kernel/sched/core.c:2895)
[ 2409.210023] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.211111] ? touch_nmi_watchdog ()
[ 2409.212198] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.213314] kthread (kernel/kthread.c:207)
[ 2409.214210] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.215304] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.216375] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.217411] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.218527] migration/22    S ffffffff986f3040 14128   165      2 0x00000000
[ 2409.220015]  ffff880067ebfd88 0000000000000002 ffff880067ebfd28 ffffffff00000000
[ 2409.221509]  ffff880067ec0000 ffff880067ebc010 ffff880067ebc000 0000000093776b2b
[ 2409.222924]  ffff880067c08000 ffff880067ec0000 ffff880067ebfd78 0000000000000000
[ 2409.224346] Call Trace:
[ 2409.224813] schedule (kernel/sched/core.c:2895)
[ 2409.225807] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.226908] ? res_counter_memparse_write_strategy ()
[ 2409.228240] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.229358] kthread (kernel/kthread.c:207)
[ 2409.230021] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.231112] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.232204] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.233288] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.234378] rcuc/22         S ffffffff986f3040 13792   166      2 0x00000000
[ 2409.235697]  ffff880067ecfd88 0000000000000002 ffff880067ecfd48 ffffffff00000000
[ 2409.237214]  ffff880067ed0000 ffff880067ecc010 ffff880067ecc000 00000001a3e495b7
[ 2409.238617]  ffff880067ee0000 ffff880067ed0000 ffff880067ed0000 0000000000000000
[ 2409.240066] Call Trace:
[ 2409.240516] schedule (kernel/sched/core.c:2895)
[ 2409.241524] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.242579] ? rcu_sysidle_cb ()
[ 2409.243562] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.244561] kthread (kernel/kthread.c:207)
[ 2409.245562] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.246709] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.247841] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.248778] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.250023] ksoftirqd/22    S ffffffff986f3040 13616   167      2 0x00000000
[ 2409.251354]  ffff880067eebd88 0000000000000002 ffff880067eebd38 ffffffff00000000
[ 2409.252785]  ffff880067ee0000 ffff880067ee8010 ffff880067ee8000 00000001a437e7a2
[ 2409.254279]  ffff880067c08000 ffff880067ee0000 ffff880067eebdd8 0000000000000000
[ 2409.255638] Call Trace:
[ 2409.256099] schedule (kernel/sched/core.c:2895)
[ 2409.257039] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.258058] ? tasklet_init (kernel/softirq.c:646)
[ 2409.259016] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.260018] kthread (kernel/kthread.c:207)
[ 2409.260899] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.262080] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.263163] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.264161] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.265351] kworker/22:0    S ffffffff986f3040 14176   168      2 0x00000000
[ 2409.266656]  ffff880067efbd58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2409.268020]  ffff880067ef0000 ffff880067ef8010 ffff880067ef8000 000000018e7860f8
[ 2409.269474]  ffff880067c08000 ffff880067ef0000 ffff880067efbd48 0000000000000000
[ 2409.270869] Call Trace:
[ 2409.271299] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.272251] schedule (kernel/sched/core.c:2895)
[ 2409.273138] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.274102] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.275145] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.276235] kthread (kernel/kthread.c:207)
[ 2409.277166] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.278267] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.279225] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.280017] kworker/22:0H   S ffffffff986f3040 14144   169      2 0x00000000
[ 2409.281387]  ffff880067f13d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2409.282740]  ffff880067f08000 ffff880067f10010 ffff880067f10000 000000018ed9cbdc
[ 2409.284114]  ffff880067c08000 ffff880067f08000 ffff880067f13d48 0000000000000000
[ 2409.285567] Call Trace:
[ 2409.286018] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.287015] schedule (kernel/sched/core.c:2895)
[ 2409.287867] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.288880] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.290022] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.291089] kthread (kernel/kthread.c:207)
[ 2409.291971] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.293121] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.294082] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.295148] kworker/u87:0   S ffffffff986f3040 14144   170      2 0x00000000
[ 2409.296472]  ffff880067f8bd58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2409.297866]  ffff880067f80000 ffff880067f88010 ffff880067f88000 000000018c0218fa
[ 2409.299216]  ffff880067c08000 ffff880067f80000 ffff880067f8bd48 0000000000000000
[ 2409.300605] Call Trace:
[ 2409.301090] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.302068] schedule (kernel/sched/core.c:2895)
[ 2409.302967] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.303987] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.305124] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.306217] kthread (kernel/kthread.c:207)
[ 2409.307144] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.308266] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.309321] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.310019] watchdog/23     S ffffffff986f3040 13536   171      2 0x00000000
[ 2409.311359]  ffff880067fbbd88 0000000000000002 0000000000000017 ffff880000000000
[ 2409.312849]  ffff880067fb0000 ffff880067fb8010 ffff880067fb8000 0000022f4ab433ad
[ 2409.314313]  ffff880067c0b000 ffff880067fb0000 ffff880067fb0000 0000000000000000
[ 2409.315730] Call Trace:
[ 2409.316208] schedule (kernel/sched/core.c:2895)
[ 2409.317211] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.318383] ? touch_nmi_watchdog ()
[ 2409.320021] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.321127] kthread (kernel/kthread.c:207)
[ 2409.322087] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.323248] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.324395] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.325431] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.326561] migration/23    S ffffffff986f3040 14080   172      2 0x00000000
[ 2409.327899]  ffff880067fcbd88 0000000000000002 ffff880067fcbd28 ffffffff00000000
[ 2409.329457]  ffff880067fc0000 ffff880067fc8010 ffff880067fc8000 000000009377a489
[ 2409.330942]  ffff880067c0b000 ffff880067fc0000 ffff880067fcbd78 0000000000000000
[ 2409.332366] Call Trace:
[ 2409.332850] schedule (kernel/sched/core.c:2895)
[ 2409.333847] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.334921] ? res_counter_memparse_write_strategy ()
[ 2409.336317] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.337441] kthread (kernel/kthread.c:207)
[ 2409.338382] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.339566] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.340019] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.341145] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.342199] rcuc/23         S ffffffff986f3040 13792   173      2 0x00000000
[ 2409.343478]  ffff880067fdbd88 0000000000000002 ffff880067fdbd48 ffffffff00000000
[ 2409.344884]  ffff880067fd0000 ffff880067fd8010 ffff880067fd8000 00000001a567a380
[ 2409.346307]  ffff880067fe0000 ffff880067fd0000 ffff880067fd0000 0000000000000000
[ 2409.347707] Call Trace:
[ 2409.348231] schedule (kernel/sched/core.c:2895)
[ 2409.349152] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.350028] ? rcu_sysidle_cb ()
[ 2409.351079] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.352192] kthread (kernel/kthread.c:207)
[ 2409.353123] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.354199] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.355249] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.356249] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.357457] ksoftirqd/23    S ffffffff986f3040 13616   174      2 0x00000000
[ 2409.358844]  ffff880067febd88 0000000000000002 ffff880067febd38 ffffffff00000000
[ 2409.360821]  ffff880067fe0000 ffff880067fe8010 ffff880067fe8000 00000001a56975ae
[ 2409.361594]  ffff880067c0b000 ffff880067fe0000 ffff880067febdd8 0000000000000000
[ 2409.362381] Call Trace:
[ 2409.362634] schedule (kernel/sched/core.c:2895)
[ 2409.363119] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.363690] ? tasklet_init (kernel/softirq.c:646)
[ 2409.364207] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.365133] kthread (kernel/kthread.c:207)
[ 2409.366109] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.367328] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.368461] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.370022] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.371185] kworker/23:0    S ffffffff986f3040 14176   175      2 0x00000000
[ 2409.372581]  ffff880067803d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2409.374036]  ffff880067ff8000 ffff880067800010 ffff880067800000 000000018e68c6a9
[ 2409.375495]  ffff880067c0b000 ffff880067ff8000 ffff880067803d48 0000000000000000
[ 2409.377001] Call Trace:
[ 2409.377510] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.378610] schedule (kernel/sched/core.c:2895)
[ 2409.379506] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.380019] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.380813] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.381367] kthread (kernel/kthread.c:207)
[ 2409.381825] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.382379] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.382880] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.383456] kworker/23:0H   S ffffffff986f3040 14144   176      2 0x00000000
[ 2409.384179]  ffff880067813d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2409.385064]  ffff880067808000 ffff880067810010 ffff880067810000 000000018ed9cbdc
[ 2409.386218]  ffff880067c0b000 ffff880067808000 ffff880067813d48 0000000000000000
[ 2409.387684] Call Trace:
[ 2409.388156] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.389307] schedule (kernel/sched/core.c:2895)
[ 2409.390022] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.390973] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.391931] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.393044] kthread (kernel/kthread.c:207)
[ 2409.393917] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.394991] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.395940] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.397070] kworker/u88:0   S ffffffff986f3040 14176   177      2 0x00000000
[ 2409.398375]  ffff880067867d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2409.400347]  ffff880067868000 ffff880067864010 ffff880067864000 000000018c0cf742
[ 2409.401889]  ffff880067c0b000 ffff880067868000 ffff880067867d48 0000000000000000
[ 2409.403259] Call Trace:
[ 2409.403697] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.404672] schedule (kernel/sched/core.c:2895)
[ 2409.405597] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.406587] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.407580] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.408670] kthread (kernel/kthread.c:207)
[ 2409.409664] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.410024] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.411014] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.412221] watchdog/24     S ffffffff986f3040 14032   178      2 0x00000000
[ 2409.413577]  ffff88006788bd88 0000000000000002 0000000000000018 ffff880000000000
[ 2409.415031]  ffff88006786b000 ffff880067888010 ffff880067888000 0000022f4c7e5c01
[ 2409.416525]  ffff8804e7310000 ffff88006786b000 ffff88006786b000 0000000000000000
[ 2409.417943] Call Trace:
[ 2409.418409] schedule (kernel/sched/core.c:2895)
[ 2409.420022] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.421128] ? touch_nmi_watchdog ()
[ 2409.422221] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.423249] kthread (kernel/kthread.c:207)
[ 2409.424155] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.425365] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.426418] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.427333] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.428362] migration/24    S ffffffff986f3040 14128   179      2 0x00000000
[ 2409.430013]  ffff88006788fd88 0000000000000002 ffff88006788fd28 ffffffff00000000
[ 2409.431390]  ffff88006780b000 ffff88006788c010 ffff88006788c000 000000009377dd98
[ 2409.432738]  ffff8804e7310000 ffff88006780b000 ffff88006788fd78 0000000000000000
[ 2409.434149] Call Trace:
[ 2409.434586] schedule (kernel/sched/core.c:2895)
[ 2409.435445] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.436472] ? res_counter_memparse_write_strategy ()
[ 2409.437842] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.438878] kthread (kernel/kthread.c:207)
[ 2409.439778] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.440019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.441089] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.442028] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.443108] rcuc/24         S ffffffff986f3040 13792   180      2 0x00000000
[ 2409.444423]  ffff880067893d88 0000000000000002 ffff880067893d48 ffffffff00000000
[ 2409.445776]  ffff880067ffb000 ffff880067890010 ffff880067890000 00000001e6f82797
[ 2409.447165]  ffff880067fe3000 ffff880067ffb000 ffff880067ffb000 0000000000000000
[ 2409.448654] Call Trace:
[ 2409.450021] schedule (kernel/sched/core.c:2895)
[ 2409.450897] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.451933] ? rcu_sysidle_cb ()
[ 2409.452959] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.453948] kthread (kernel/kthread.c:207)
[ 2409.454805] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.455895] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.457024] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.457981] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.459037] ksoftirqd/24    S ffffffff986f3040 14128   181      2 0x00000000
[ 2409.460014]  ffff880067897d88 0000000000000002 ffff880067897d48 0000000000000000
[ 2409.461470]  ffff880067fe3000 ffff880067894010 ffff880067894000 0000022a20b420c9
[ 2409.462827]  ffff8804e7310000 ffff880067fe3000 ffff880067897d78 0000000000000000
[ 2409.464176] Call Trace:
[ 2409.464679] schedule (kernel/sched/core.c:2895)
[ 2409.465542] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.466567] ? tasklet_init (kernel/softirq.c:646)
[ 2409.467529] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.468620] kthread (kernel/kthread.c:207)
[ 2409.469537] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.470021] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.471117] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.472172] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.473301] kworker/24:0    S ffffffff986f3040 12832   182      2 0x00000000
[ 2409.474644]  ffff88006789fd58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2409.476126]  ffff880067fd3000 ffff88006789c010 ffff88006789c000 000000018d43b06a
[ 2409.477579]  ffff880479338000 ffff880067fd3000 ffff88006789fd48 0000000000000000
[ 2409.480070] Call Trace:
[ 2409.480550] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.481656] schedule (kernel/sched/core.c:2895)
[ 2409.482538] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.483542] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.484614] kthread (kernel/kthread.c:207)
[ 2409.485633] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.486758] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.487704] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.488803] kworker/24:0H   S ffffffff986f3040 14176   183      2 0x00000000
[ 2409.490024]  ffff8800678abd58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2409.491473]  ffff880067fc3000 ffff8800678a8010 ffff8800678a8000 000000018ed9cbdc
[ 2409.493045]  ffff880479338000 ffff880067fc3000 ffff8800678abd48 0000000000000000
[ 2409.494508] Call Trace:
[ 2409.494976] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.496027] schedule (kernel/sched/core.c:2895)
[ 2409.497062] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.498073] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.499104] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.500020] kthread (kernel/kthread.c:207)
[ 2409.501059] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.502185] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.503198] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.504365] watchdog/25     S ffffffff986f3040 14032   184      2 0x00000000
[ 2409.505784]  ffff880108fdfd88 0000000000000002 0000000000000019 ffff880100000000
[ 2409.507231]  ffff880108ff8000 ffff880108fdc010 ffff880108fdc000 0000022f4e479074
[ 2409.508799]  ffff880779380000 ffff880108ff8000 ffff880108ff8000 0000000000000000
[ 2409.510633] Call Trace:
[ 2409.511071] schedule (kernel/sched/core.c:2895)
[ 2409.511959] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.513071] ? touch_nmi_watchdog ()
[ 2409.514183] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.515223] kthread (kernel/kthread.c:207)
[ 2409.516129] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.517465] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.518607] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.519582] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.520021] migration/25    S ffffffff986f3040 14128   185      2 0x00000000
[ 2409.521518]  ffff880106003d88 0000000000000002 ffff880106003d28 ffffffff00000000
[ 2409.522937]  ffff880108ffb000 ffff880106000010 ffff880106000000 000000009378221c
[ 2409.524466]  ffff880779380000 ffff880108ffb000 ffff880106003d78 0000000000000000
[ 2409.525986] Call Trace:
[ 2409.526490] schedule (kernel/sched/core.c:2895)
[ 2409.527407] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.528559] ? res_counter_memparse_write_strategy ()
[ 2409.530023] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.531084] kthread (kernel/kthread.c:207)
[ 2409.531999] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.533201] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.534351] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.535352] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.536535] rcuc/25         S ffffffff986f3040 13792   186      2 0x00000000
[ 2409.537850]  ffff880106007d88 0000000000000002 ffff880106007d48 ffffffff00000000
[ 2409.539256]  ffff880106008000 ffff880106004010 ffff880106004000 00000001b7491224
[ 2409.540953]  ffff88010600b000 ffff880106008000 ffff880106008000 0000000000000000
[ 2409.542344] Call Trace:
[ 2409.542797] schedule (kernel/sched/core.c:2895)
[ 2409.543659] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.544777] ? rcu_sysidle_cb ()
[ 2409.545794] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.546779] kthread (kernel/kthread.c:207)
[ 2409.547689] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.548870] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.550020] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.550972] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.552052] ksoftirqd/25    S ffffffff986f3040 14128   187      2 0x00000000
[ 2409.553418]  ffff880106013d88 0000000000000002 ffff880106013d48 0000000000000000
[ 2409.554808]  ffff88010600b000 ffff880106010010 ffff880106010000 000002048cd37b65
[ 2409.556240]  ffff880779380000 ffff88010600b000 ffff880106013d78 0000000000000000
[ 2409.557756] Call Trace:
[ 2409.558215] schedule (kernel/sched/core.c:2895)
[ 2409.559108] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.560029] ? tasklet_init (kernel/softirq.c:646)
[ 2409.561059] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.562065] kthread (kernel/kthread.c:207)
[ 2409.562974] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.564108] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.565376] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.566385] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.567531] kworker/25:0    S ffffffff986f3040 13376   188      2 0x00000000
[ 2409.568983]  ffff880106017d58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2409.569519]  ffff880106018000 ffff880106014010 ffff880106014000 00000001137e8a7a
[ 2409.569519]  ffff88010616b000 ffff880106018000 ffff880106017d48 0000000000000000
[ 2409.569519] Call Trace:
[ 2409.569519] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.569519] schedule (kernel/sched/core.c:2895)
[ 2409.569519] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.569519] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.569519] kthread (kernel/kthread.c:207)
[ 2409.569531] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.580023] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.581120] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.582248] kworker/25:0H   S ffffffff986f3040 14176   189      2 0x00000000
[ 2409.583624]  ffff880106023d58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2409.585152]  ffff88010601b000 ffff880106020010 ffff880106020000 000000018ed9cbdc
[ 2409.586617]  ffff880779380000 ffff88010601b000 ffff880106023d48 0000000000000000
[ 2409.588142] Call Trace:
[ 2409.588632] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.590020] schedule (kernel/sched/core.c:2895)
[ 2409.590949] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.591928] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.593032] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.594098] kthread (kernel/kthread.c:207)
[ 2409.595028] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.596169] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.597196] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.598309] watchdog/26     S ffffffff986f3040 13680   190      2 0x00000000
[ 2409.600018]  ffff880176f9bd88 0000000000000002 000000000000001a ffff880100000000
[ 2409.601437]  ffff880176f6b000 ffff880176f98010 ffff880176f98000 0000022f51db8414
[ 2409.602856]  ffff880067c20000 ffff880176f6b000 ffff880176f6b000 0000000000000000
[ 2409.604313] Call Trace:
[ 2409.604887] schedule (kernel/sched/core.c:2895)
[ 2409.605867] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.607001] ? touch_nmi_watchdog ()
[ 2409.608079] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.609220] kthread (kernel/kthread.c:207)
[ 2409.610022] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.611172] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.612310] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.613403] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.614566] migration/26    S ffffffff986f3040 14128   191      2 0x00000000
[ 2409.615972]  ffff880176f9fd88 0000000000000002 ffff880176f9fd28 ffffffff00000000
[ 2409.617551]  ffff880176fa0000 ffff880176f9c010 ffff880176f9c000 0000000093785c86
[ 2409.619015]  ffff880067c20000 ffff880176fa0000 ffff880176f9fd78 0000000000000000
[ 2409.620645] Call Trace:
[ 2409.621153] schedule (kernel/sched/core.c:2895)
[ 2409.622061] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.623156] ? res_counter_memparse_write_strategy ()
[ 2409.624537] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.625657] kthread (kernel/kthread.c:207)
[ 2409.626605] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.627767] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.628980] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.630021] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.631146] rcuc/26         S ffffffff986f3040 13792   192      2 0x00000000
[ 2409.632492]  ffff880176fabd88 0000000000000002 ffff880176fabd48 ffffffff00000000
[ 2409.633998]  ffff880176fa3000 ffff880176fa8010 ffff880176fa8000 00000001b9130a00
[ 2409.635348]  ffff880176fb0000 ffff880176fa3000 ffff880176fa3000 0000000000000000
[ 2409.636738] Call Trace:
[ 2409.637250] schedule (kernel/sched/core.c:2895)
[ 2409.638162] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.639213] ? rcu_sysidle_cb ()
[ 2409.640020] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.641114] kthread (kernel/kthread.c:207)
[ 2409.642023] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.643145] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.644215] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.645203] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.646267] ksoftirqd/26    S ffffffff986f3040 13616   193      2 0x00000000
[ 2409.647545]  ffff880176fafd88 0000000000000002 ffff880176fafd48 0000000000000000
[ 2409.649023]  ffff880176fb0000 ffff880176fac010 ffff880176fac000 0000021da09d6e31
[ 2409.650674]  ffff880067c20000 ffff880176fb0000 ffff880176fafd78 0000000000000000
[ 2409.652116] Call Trace:
[ 2409.652561] schedule (kernel/sched/core.c:2895)
[ 2409.653527] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.654584] ? tasklet_init (kernel/softirq.c:646)
[ 2409.655528] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.656523] kthread (kernel/kthread.c:207)
[ 2409.657484] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.658573] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.659800] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.660022] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.661103] kworker/26:0    S ffffffff986f3040 13712   194      2 0x00000000
[ 2409.662366]  ffff880176fbbd58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2409.663720]  ffff880176fb3000 ffff880176fb8010 ffff880176fb8000 00000001a60c5163
[ 2409.665163]  ffff8801740c0000 ffff880176fb3000 ffff880176fbbd48 0000000000000000
[ 2409.666522] Call Trace:
[ 2409.666959] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.667941] schedule (kernel/sched/core.c:2895)
[ 2409.668898] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.670020] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.671140] kthread (kernel/kthread.c:207)
[ 2409.672188] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.673259] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.674201] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.675272] kworker/26:0H   S ffffffff986f3040 14144   195      2 0x00000000
[ 2409.676743]  ffff880176fbfd58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2409.678102]  ffff880176fc0000 ffff880176fbc010 ffff880176fbc000 000000018ee3bcd5
[ 2409.680067]  ffff880067c20000 ffff880176fc0000 ffff880176fbfd48 0000000000000000
[ 2409.681482] Call Trace:
[ 2409.681935] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.682927] schedule (kernel/sched/core.c:2895)
[ 2409.683846] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.684859] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.685886] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.686969] kthread (kernel/kthread.c:207)
[ 2409.687865] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.689022] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.690024] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.691100] watchdog/27     S ffffffff986f3040 13680   196      2 0x00000000
[ 2409.692409]  ffff8801e4fffd88 0000000000000002 000000000000001b ffff880100000000
[ 2409.693897]  ffff8801e2020000 ffff8801e4ffc010 ffff8801e4ffc000 0000022f530c435c
[ 2409.695215]  ffff880067c23000 ffff8801e2020000 ffff8801e2020000 0000000000000000
[ 2409.696534] Call Trace:
[ 2409.697024] schedule (kernel/sched/core.c:2895)
[ 2409.697868] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.698871] ? touch_nmi_watchdog ()
[ 2409.700018] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.701112] kthread (kernel/kthread.c:207)
[ 2409.702045] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.703150] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.704205] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.705185] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.706259] migration/27    S ffffffff986f3040 14128   197      2 0x00000000
[ 2409.707541]  ffff8801e202bd88 0000000000000002 ffff8801e202bd28 ffffffff00000000
[ 2409.708948]  ffff8801e2023000 ffff8801e2028010 ffff8801e2028000 0000000093789ddc
[ 2409.710337]  ffff880067c23000 ffff8801e2023000 ffff8801e202bd78 0000000000000000
[ 2409.711691] Call Trace:
[ 2409.712152] schedule (kernel/sched/core.c:2895)
[ 2409.713140] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.714158] ? res_counter_memparse_write_strategy ()
[ 2409.715415] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.716402] kthread (kernel/kthread.c:207)
[ 2409.717343] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.718408] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.719478] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.720020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.721123] rcuc/27         S ffffffff986f3040 13792   198      2 0x00000000
[ 2409.722367]  ffff8801e202fd88 0000000000000002 ffff8801e202fd48 ffffffff00000000
[ 2409.723691]  ffff8801e2030000 ffff8801e202c010 ffff8801e202c000 00000001b9130a00
[ 2409.725096]  ffff8801e2033000 ffff8801e2030000 ffff8801e2030000 0000000000000000
[ 2409.726439] Call Trace:
[ 2409.726878] schedule (kernel/sched/core.c:2895)
[ 2409.727731] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.728797] ? rcu_sysidle_cb ()
[ 2409.730021] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.731000] kthread (kernel/kthread.c:207)
[ 2409.731864] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.732987] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.734035] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.734968] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.736038] ksoftirqd/27    S ffffffff986f3040 14128   199      2 0x00000000
[ 2409.737416]  ffff8801e203bd88 0000000000000002 ffff8801e203bd48 0000000000000000
[ 2409.738722]  ffff8801e2033000 ffff8801e2038010 ffff8801e2038000 000002048d1868dd
[ 2409.740328]  ffff880067c23000 ffff8801e2033000 ffff8801e203bd78 0000000000000000
[ 2409.741714] Call Trace:
[ 2409.742137] schedule (kernel/sched/core.c:2895)
[ 2409.742962] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.743964] ? tasklet_init (kernel/softirq.c:646)
[ 2409.744930] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.745900] kthread (kernel/kthread.c:207)
[ 2409.746776] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.747875] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.749028] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.749962] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.750017] kworker/27:0    S ffffffff986f3040 13376   200      2 0x00000000
[ 2409.751287]  ffff8801e203fd58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2409.752678]  ffff8801e2040000 ffff8801e203c010 ffff8801e203c000 00000000ddbb7da3
[ 2409.754022]  ffff8801e218b000 ffff8801e2040000 ffff8801e203fd48 0000000000000000
[ 2409.755334] Call Trace:
[ 2409.755809] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.756808] schedule (kernel/sched/core.c:2895)
[ 2409.757681] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.758630] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.760021] kthread (kernel/kthread.c:207)
[ 2409.761010] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.762042] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.762954] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.764003] kworker/27:0H   S ffffffff986f3040 14144   201      2 0x00000000
[ 2409.764932]  ffff8801e204bd58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2409.765803]  ffff8801e2043000 ffff8801e2048010 ffff8801e2048000 000000018ed9cbdc
[ 2409.766948]  ffff880067c23000 ffff8801e2043000 ffff8801e204bd48 0000000000000000
[ 2409.768342] Call Trace:
[ 2409.768776] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.770019] schedule (kernel/sched/core.c:2895)
[ 2409.770878] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.771809] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.772813] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.773883] kthread (kernel/kthread.c:207)
[ 2409.774773] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.775896] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.776906] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.778006] watchdog/28     S ffffffff986f3040 14032   202      2 0x00000000
[ 2409.779298]  ffff88025003bd88 0000000000000002 000000000000001c ffff880200000000
[ 2409.780968]  ffff880250030000 ffff880250038010 ffff880250038000 0000022f556ec074
[ 2409.781867]  ffff88040b390000 ffff880250030000 ffff880250030000 0000000000000000
[ 2409.783066] Call Trace:
[ 2409.783512] schedule (kernel/sched/core.c:2895)
[ 2409.784404] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.785560] ? touch_nmi_watchdog ()
[ 2409.786591] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.787584] kthread (kernel/kthread.c:207)
[ 2409.788496] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.789685] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.790021] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.790970] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.792110] migration/28    S ffffffff986f3040 14128   203      2 0x00000000
[ 2409.793364]  ffff88025003fd88 0000000000000002 ffff88025003fd28 ffffffff00000000
[ 2409.794705]  ffff880250033000 ffff88025003c010 ffff88025003c000 000000009378def6
[ 2409.796137]  ffff88040b390000 ffff880250033000 ffff88025003fd78 0000000000000000
[ 2409.797493] Call Trace:
[ 2409.797934] schedule (kernel/sched/core.c:2895)
[ 2409.798810] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.800024] ? res_counter_memparse_write_strategy ()
[ 2409.801299] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.802281] kthread (kernel/kthread.c:207)
[ 2409.803149] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.804320] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.805384] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.806353] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.807468] rcuc/28         S ffffffff986f3040 13792   204      2 0x00000000
[ 2409.808952]  ffff88025004bd88 0000000000000002 ffff88025004bd48 ffffffff00000000
[ 2409.810923]  ffff880250040000 ffff880250048010 ffff880250048000 00000001bc0dd4c4
[ 2409.812307]  ffff880250043000 ffff880250040000 ffff880250040000 0000000000000000
[ 2409.813737] Call Trace:
[ 2409.814173] schedule (kernel/sched/core.c:2895)
[ 2409.815053] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.816098] ? rcu_sysidle_cb ()
[ 2409.817112] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.818082] kthread (kernel/kthread.c:207)
[ 2409.818950] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.820022] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.821182] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.822128] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.823170] ksoftirqd/28    S ffffffff986f3040 13616   205      2 0x00000000
[ 2409.824457]  ffff88025004fd88 0000000000000002 ffff88025004fd38 ffffffff00000000
[ 2409.825836]  ffff880250043000 ffff88025004c010 ffff88025004c000 00000001bc0fa187
[ 2409.827179]  ffff88040b390000 ffff880250043000 ffff88025004fdd8 0000000000000000
[ 2409.828577] Call Trace:
[ 2409.829029] schedule (kernel/sched/core.c:2895)
[ 2409.830019] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.831030] ? tasklet_init (kernel/softirq.c:646)
[ 2409.831962] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.833010] kthread (kernel/kthread.c:207)
[ 2409.833884] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.834935] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.835990] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.836948] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.837989] kworker/28:0    S ffffffff986f3040 13152   206      2 0x00000000
[ 2409.839271]  ffff88025005bd58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2409.840908]  ffff880250050000 ffff880250058010 ffff880250058000 00000000ec097fa2
[ 2409.842253]  ffff880250158000 ffff880250050000 ffff88025005bd48 0000000000000000
[ 2409.843580] Call Trace:
[ 2409.844020] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.845087] schedule (kernel/sched/core.c:2895)
[ 2409.845946] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.846923] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.847944] kthread (kernel/kthread.c:207)
[ 2409.848887] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.850034] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.850980] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.852030] kworker/28:0H   S ffffffff986f3040 14144   207      2 0x00000000
[ 2409.853388]  ffff88025005fd58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2409.854787]  ffff880250053000 ffff88025005c010 ffff88025005c000 000000018ed9cbdc
[ 2409.856145]  ffff88040b390000 ffff880250053000 ffff88025005fd48 0000000000000000
[ 2409.857570] Call Trace:
[ 2409.858030] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.859018] schedule (kernel/sched/core.c:2895)
[ 2409.859867] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.860018] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.860966] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.862030] kthread (kernel/kthread.c:207)
[ 2409.862889] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.863987] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.864943] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.865990] watchdog/29     S ffffffff986f3040 14032   208      2 0x00000000
[ 2409.867278]  ffff8802c0fffd88 0000000000000002 000000000000001d ffff880200000000
[ 2409.868757]  ffff8802be230000 ffff8802c0ffc010 ffff8802c0ffc000 0000022f586a1919
[ 2409.870895]  ffff88069f308000 ffff8802be230000 ffff8802be230000 0000000000000000
[ 2409.872211] Call Trace:
[ 2409.872691] schedule (kernel/sched/core.c:2895)
[ 2409.873545] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.874590] ? touch_nmi_watchdog ()
[ 2409.875637] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.876706] kthread (kernel/kthread.c:207)
[ 2409.877698] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.878809] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.880018] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.881051] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.882105] migration/29    S ffffffff986f3040 14128   209      2 0x00000000
[ 2409.883363]  ffff8802be23bd88 0000000000000002 ffff8802be23bd28 ffffffff00000000
[ 2409.884765]  ffff8802be233000 ffff8802be238010 ffff8802be238000 0000000093792e55
[ 2409.886122]  ffff88069f308000 ffff8802be233000 ffff8802be23bd78 0000000000000000
[ 2409.887507] Call Trace:
[ 2409.887948] schedule (kernel/sched/core.c:2895)
[ 2409.888885] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.889914] ? res_counter_memparse_write_strategy ()
[ 2409.890019] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.891001] kthread (kernel/kthread.c:207)
[ 2409.891979] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.893067] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.894122] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.895064] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.896276] rcuc/29         S ffffffff986f3040 13792   210      2 0x00000000
[ 2409.897533]  ffff8802be23fd88 0000000000000002 ffff8802be23fd48 ffffffff00000000
[ 2409.900071]  ffff8802be240000 ffff8802be23c010 ffff8802be23c000 00000001bdd7be00
[ 2409.901542]  ffff8802be243000 ffff8802be240000 ffff8802be240000 0000000000000000
[ 2409.902945] Call Trace:
[ 2409.903399] schedule (kernel/sched/core.c:2895)
[ 2409.904292] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.905455] ? rcu_sysidle_cb ()
[ 2409.906464] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.907493] kthread (kernel/kthread.c:207)
[ 2409.908380] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.909563] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.910020] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.910997] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.912137] ksoftirqd/29    S ffffffff986f3040 13616   211      2 0x00000000
[ 2409.913450]  ffff8802be24bd88 0000000000000002 ffff8802be24bd48 0000000000000000
[ 2409.914866]  ffff8802be243000 ffff8802be248010 ffff8802be248000 000000ecb04f9a65
[ 2409.916381]  ffff88069f308000 ffff8802be243000 ffff8802be24bd78 0000000000000000
[ 2409.917787] Call Trace:
[ 2409.918289] schedule (kernel/sched/core.c:2895)
[ 2409.919157] smpboot_thread_fn (kernel/smpboot.c:156)
[ 2409.920024] ? tasklet_init (kernel/softirq.c:646)
[ 2409.921025] ? SyS_setgroups (kernel/smpboot.c:105)
[ 2409.922085] kthread (kernel/kthread.c:207)
[ 2409.923002] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
[ 2409.924161] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.925290] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.926314] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.927403] kworker/29:0    S ffffffff986f3040 13584   212      2 0x00000000
[ 2409.928847]  ffff8802be24fd58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2409.930863]  ffff8802be250000 ffff8802be24c010 ffff8802be24c000 000000017b2ca21b
[ 2409.932184]  ffff8802bdac3000 ffff8802be250000 ffff8802be24fd48 0000000000000000
[ 2409.933710] Call Trace:
[ 2409.934175] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.935208] schedule (kernel/sched/core.c:2895)
[ 2409.936126] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.937208] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.938263] kthread (kernel/kthread.c:207)
[ 2409.939118] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.940020] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.941088] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.942179] kworker/29:0H   S ffffffff986f3040 14176   213      2 0x00000000
[ 2409.943457]  ffff8802be25bd58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2409.944863]  ffff8802be253000 ffff8802be258010 ffff8802be258000 000000018edf2e76
[ 2409.946243]  ffff880068248000 ffff8802be253000 ffff8802be25bd48 0000000000000000
[ 2409.947631] Call Trace:
[ 2409.948087] ? worker_thread (kernel/workqueue.c:2176)
[ 2409.949184] schedule (kernel/sched/core.c:2895)
[ 2409.950019] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2409.950951] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2409.951953] ? process_one_work (kernel/workqueue.c:2100)
[ 2409.953169] kthread (kernel/kthread.c:207)
[ 2409.954068] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.955190] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.956212] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.957448] khelper         S ffffffff986f3040 14384   214      2 0x00000000
[ 2409.959038]  ffff88006748fd68 0000000000000002 ffffffff911ef3ec ffff880000000000
[ 2409.960911]  ffff880067fb3000 ffff88006748c010 ffff88006748c000 0000000099beb816
[ 2409.962351]  ffff880068378000 ffff880067fb3000 ffff88006748fd58 0000000000000000
[ 2409.963754] Call Trace:
[ 2409.964211] ? rescuer_thread ()
[ 2409.965302] schedule (kernel/sched/core.c:2895)
[ 2409.966171] rescuer_thread ()
[ 2409.967171] ? worker_thread ()
[ 2409.968158] kthread (kernel/kthread.c:207)
[ 2409.969097] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.970021] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.970969] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.972034] kdevtmpfs       S ffffffff986f3040 12736   215      2 0x00000000
[ 2409.973413]  ffff88006749fd98 0000000000000002 ffffffff929603b1 ffff880000000000
[ 2409.974921]  ffff880067f83000 ffff88006749c010 ffff88006749c000 000000009acf696b
[ 2409.976561]  ffff880779380000 ffff880067f83000 ffff88006749fd98 0000000000000000
[ 2409.978243] Call Trace:
[ 2409.978827] ? devtmpfsd ()
[ 2409.980021] ? handle_create ()
[ 2409.981177] schedule (kernel/sched/core.c:2895)
[ 2409.982182] devtmpfsd ()
[ 2409.983127] ? handle_create ()
[ 2409.984279] kthread (kernel/kthread.c:207)
[ 2409.985215] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.986496] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2409.987555] ? flush_kthread_work (kernel/kthread.c:176)
[ 2409.988888] netns           S ffffffff986f3040 14528   216      2 0x00000000
[ 2409.990024]  ffff8800678fbd68 0000000000000002 ffffffff911ef3ec ffff880000000000
[ 2409.991373]  ffff880067f0b000 ffff8800678f8010 ffff8800678f8000 000000009ce015be
[ 2409.992812]  ffff880068378000 ffff880067f0b000 ffff8800678fbd58 0000000000000000
[ 2409.994243] Call Trace:
[ 2409.994734] ? rescuer_thread ()
[ 2409.995792] schedule (kernel/sched/core.c:2895)
[ 2409.996920] rescuer_thread ()
[ 2409.998088] ? worker_thread ()
[ 2409.999293] kthread (kernel/kthread.c:207)
[ 2410.000023] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.001198] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.002362] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.003750] kworker/u64:1   S ffffffff986f3040 13568   217      2 0x00000000
[ 2410.005222]  ffff88006796bd58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2410.006610]  ffff880067ef3000 ffff880067968010 ffff880067968000 000000018c610f99
[ 2410.008061]  ffff88047933b000 ffff880067ef3000 ffff88006796bd48 0000000000000000
[ 2410.010070] Call Trace:
[ 2410.010554] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.011611] schedule (kernel/sched/core.c:2895)
[ 2410.012683] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.013742] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.014706] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.016240] kthread (kernel/kthread.c:207)
[ 2410.017434] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.018542] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.019689] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.020019] perf            S ffffffff986f3040 14528   219      2 0x00000000
[ 2410.021556]  ffff88006793bd68 0000000000000002 ffffffff911ef3ec ffff880000000000
[ 2410.023125]  ffff880067ed3000 ffff880067938010 ffff880067938000 00000000a2e46ad3
[ 2410.024661]  ffff880779380000 ffff880067ed3000 ffff88006793bd58 0000000000000000
[ 2410.026433] Call Trace:
[ 2410.026876] ? rescuer_thread ()
[ 2410.028048] schedule (kernel/sched/core.c:2895)
[ 2410.030019] rescuer_thread ()
[ 2410.031056] ? worker_thread ()
[ 2410.032131] kthread (kernel/kthread.c:207)
[ 2410.033123] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.034261] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.035217] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.036367] kworker/3:1     S ffffffff986f3040 14144   527      2 0x00000000
[ 2410.037866]  ffff8801e216fd58 0000000000000006 ffffffff911eeacf ffff880100000000
[ 2410.039442]  ffff8801e2188000 ffff8801e216c010 ffff8801e216c000 00000001a6a1aeac
[ 2410.040929]  ffff880067ddb000 ffff8801e2188000 ffff8801e216fd48 0000000000000000
[ 2410.042276] Call Trace:
[ 2410.042715] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.043733] schedule (kernel/sched/core.c:2895)
[ 2410.044672] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.045630] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.046597] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.047703] kthread (kernel/kthread.c:207)
[ 2410.048736] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.050023] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.051076] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.052254] kworker/27:1    S ffffffff986f3040 14144   574      2 0x00000000
[ 2410.053730]  ffff8801e21b7d58 0000000000000006 ffffffff911eeacf ffff880100000000
[ 2410.055107]  ffff8801e218b000 ffff8801e21b4010 ffff8801e21b4000 00000001a6b0e2f5
[ 2410.056550]  ffff880173e03000 ffff8801e218b000 ffff8801e21b7d48 0000000000000000
[ 2410.057957] Call Trace:
[ 2410.058414] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.059438] schedule (kernel/sched/core.c:2895)
[ 2410.060018] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.061090] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.062045] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.063078] kthread (kernel/kthread.c:207)
[ 2410.064050] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.065220] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.066170] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.067278] kworker/28:1    S ffffffff986f3040 14160   756      2 0x00000000
[ 2410.068609]  ffff880250107d58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2410.070330]  ffff880250158000 ffff880250104010 ffff880250104000 00000001b792c97d
[ 2410.071687]  ffff88040b390000 ffff880250158000 ffff880250107d48 0000000000000000
[ 2410.073110] Call Trace:
[ 2410.073548] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.074536] schedule (kernel/sched/core.c:2895)
[ 2410.075381] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.076341] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.077427] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.078484] kthread (kernel/kthread.c:207)
[ 2410.079383] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.080018] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.081113] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.082287] kworker/5:1     S ffffffff986f3040 14160  1133      2 0x00000000
[ 2410.083593]  ffff8802bd8b3d58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2410.085032]  ffff8802bd8a8000 ffff8802bd8b0010 ffff8802bd8b0000 00000001b8938e7d
[ 2410.086466]  ffff880108f80000 ffff8802bd8a8000 ffff8802bd8b3d48 0000000000000000
[ 2410.088055] Call Trace:
[ 2410.088542] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.090019] schedule (kernel/sched/core.c:2895)
[ 2410.090875] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.091795] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.092792] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.093827] kthread (kernel/kthread.c:207)
[ 2410.094704] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.095772] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.096828] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.098034] kworker/25:1    S ffffffff986f3040 14144  1172      2 0x00000000
[ 2410.099481]  ffff8801061a3d58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2410.100989]  ffff88010616b000 ffff8801061a0010 ffff8801061a0000 00000001b1005ca5
[ 2410.102425]  ffff880779380000 ffff88010616b000 ffff8801061a3d48 0000000000000000
[ 2410.103864] Call Trace:
[ 2410.104313] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.105432] schedule (kernel/sched/core.c:2895)
[ 2410.106362] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.107385] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.108481] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.109573] kthread (kernel/kthread.c:207)
[ 2410.110021] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.111138] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.112183] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.113352] kworker/6:1     S ffffffff986f3040 13616  1306      2 0x00000000
[ 2410.114765]  ffff88032c103d58 0000000000000002 ffffffff911eeacf ffff880300000000
[ 2410.116324]  ffff88032c090000 ffff88032c100010 ffff88032c100000 0000000199c283fb
[ 2410.117825]  ffff8802c0f88000 ffff88032c090000 ffff88032c103d48 0000000000000000
[ 2410.120014] Call Trace:
[ 2410.120495] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.121604] schedule (kernel/sched/core.c:2895)
[ 2410.122488] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.123456] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.124418] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.125530] kthread (kernel/kthread.c:207)
[ 2410.126395] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.127474] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.128496] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.129693] kworker/29:1    S ffffffff986f3040 14160  2253      2 0x00000000
[ 2410.130872]  ffff8802bd9fbd58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2410.132300]  ffff8802bdac3000 ffff8802bd9f8010 ffff8802bd9f8000 00000001b9272fd8
[ 2410.133819]  ffff88069f308000 ffff8802bdac3000 ffff8802bd9fbd48 0000000000000000
[ 2410.135219] Call Trace:
[ 2410.135674] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.136721] schedule (kernel/sched/core.c:2895)
[ 2410.137615] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.138571] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.139552] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.140027] kthread (kernel/kthread.c:207)
[ 2410.140926] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.142025] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.143000] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.144241] khungtaskd      R  running task    13456  2449      2 0x00080000
[ 2410.145609]  000000004a54a125 0000000000003490 ffff8802bd950000 ffff8802bd82fd38
[ 2410.147013]  ffffffff91210433 ffffffff91210322 ffff8802bd950000 ffff8802bd9508f8
[ 2410.148471]  ffff8802bd950000 ffff8802bd9508f8 0000000000000000 ffff8802bd950778
[ 2410.149257] Call Trace:
[ 2410.149257] sched_show_task ()
[ 2410.149257] ? sched_show_task ()
[ 2410.149257] show_state_filter ()
[ 2410.149257] ? sched_show_task ()
[ 2410.149257] watchdog ()
[ 2410.149257] ? watchdog ()
[ 2410.149257] ? reset_hung_task_detector ()
[ 2410.149257] kthread (kernel/kthread.c:207)
[ 2410.149490] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.150020] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.151019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.152172] writeback       S ffffffff986f3040 14528  2452      2 0x00000000
[ 2410.153570]  ffff880554947d68 0000000000000002 ffffffff911ef3ec ffff880500000000
[ 2410.155050]  ffff880554813000 ffff880554944010 ffff880554944000 000000018bde0c17
[ 2410.156482]  ffff8801e4f90000 ffff880554813000 ffff880554947d58 0000000000000000
[ 2410.157958] Call Trace:
[ 2410.158425] ? rescuer_thread ()
[ 2410.170020] schedule (kernel/sched/core.c:2895)
[ 2410.170894] rescuer_thread ()
[ 2410.171900] ? worker_thread ()
[ 2410.173116] kthread (kernel/kthread.c:207)
[ 2410.173997] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.175059] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.176000] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.177122] ksmd            S ffffffff986f3040 14208  2459      2 0x00000000
[ 2410.178383]  ffff88055495bd98 0000000000000002 ffff88055495bd38 0000000000000000
[ 2410.180064]  ffff880067e0b000 ffff880554958010 ffff880554958000 000000018c632f74
[ 2410.181590]  ffff8801e4f90000 ffff880067e0b000 0000000000000000 0000000000000000
[ 2410.183068] Call Trace:
[ 2410.183536] schedule (kernel/sched/core.c:2895)
[ 2410.184595] ksm_scan_thread ()
[ 2410.185634] ? abort_exclusive_wait (kernel/sched/wait.c:291)
[ 2410.186717] ? ksm_do_scan ()
[ 2410.187689] kthread (kernel/kthread.c:207)
[ 2410.188583] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.189618] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.190019] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.191052] khugepaged      S ffffffff986f3040 14472  2462      2 0x00000000
[ 2410.192375]  ffff88055495fd68 0000000000000002 ffff88055495fd08 0000000000000000
[ 2410.193721]  ffff880067dfb000 ffff88055495c010 ffff88055495c000 000000018c90b2f7
[ 2410.195091]  ffff8801e4f90000 ffff880067dfb000 0000000000000000 0000000000000000
[ 2410.196600] Call Trace:
[ 2410.197060] schedule (kernel/sched/core.c:2895)
[ 2410.197987] khugepaged ()
[ 2410.198963] ? abort_exclusive_wait (kernel/sched/wait.c:291)
[ 2410.200021] ? khugepaged_scan_mm_slot ()
[ 2410.201223] kthread (kernel/kthread.c:207)
[ 2410.202122] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.203236] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.204341] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.205438] crypto          S ffffffff986f3040 14528  2473      2 0x00000000
[ 2410.206780]  ffff880554963d68 0000000000000002 ffffffff911ef3ec ffff880200000000
[ 2410.208283]  ffff8802bdb8b000 ffff880554960010 ffff880554960000 000000018d07401f
[ 2410.210067]  ffff8801e4f90000 ffff8802bdb8b000 ffff880554963d58 0000000000000000
[ 2410.211412] Call Trace:
[ 2410.211859] ? rescuer_thread ()
[ 2410.212927] schedule (kernel/sched/core.c:2895)
[ 2410.213784] rescuer_thread ()
[ 2410.214741] ? worker_thread ()
[ 2410.215733] kthread (kernel/kthread.c:207)
[ 2410.216699] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.217802] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.218770] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.220022] kworker/24:1    S ffffffff986f3040 14160  2475      2 0x00000000
[ 2410.221374]  ffff880067083d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2410.222708]  ffff880067d83000 ffff880067080010 ffff880067080000 00000001a365da4c
[ 2410.224015]  ffff8804e7310000 ffff880067d83000 ffff880067083d48 0000000000000000
[ 2410.225474] Call Trace:
[ 2410.225927] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.226929] schedule (kernel/sched/core.c:2895)
[ 2410.227810] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.228913] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.230020] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.231116] kthread (kernel/kthread.c:207)
[ 2410.232081] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.233304] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.234300] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.235408] kintegrityd     S ffffffff986f3040 14336  2482      2 0x00000000
[ 2410.236788]  ffff88055498bd68 0000000000000002 ffffffff911ef3ec ffff880500000000
[ 2410.238276]  ffff880554980000 ffff880554988010 ffff880554988000 000000018da09d61
[ 2410.239717]  ffff8801e4f90000 ffff880554980000 ffff88055498bd58 0000000000000000
[ 2410.241033] Call Trace:
[ 2410.241493] ? rescuer_thread ()
[ 2410.242521] schedule (kernel/sched/core.c:2895)
[ 2410.243420] rescuer_thread ()
[ 2410.244448] ? worker_thread ()
[ 2410.245475] kthread (kernel/kthread.c:207)
[ 2410.246400] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.247496] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.248554] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.249636] bioset          S ffffffff986f3040 14176  2492      2 0x00000000
[ 2410.250833]  ffff88055498fd68 0000000000000002 ffffffff911ef3ec ffff880500000000
[ 2410.252370]  ffff880554983000 ffff88055498c010 ffff88055498c000 000000018ec16721
[ 2410.253851]  ffff8801e4f90000 ffff880554983000 ffff88055498fd58 0000000000000000
[ 2410.255313] Call Trace:
[ 2410.255754] ? rescuer_thread ()
[ 2410.256900] schedule (kernel/sched/core.c:2895)
[ 2410.257818] rescuer_thread ()
[ 2410.258813] ? worker_thread ()
[ 2410.260020] kthread (kernel/kthread.c:207)
[ 2410.260995] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.262149] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.263147] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.264255] kblockd         S ffffffff986f3040 14160  2497      2 0x00000000
[ 2410.265793]  ffff880554993d68 0000000000000002 ffffffff911ef3ec ffff880000000000
[ 2410.267273]  ffff880067ee3000 ffff880554990010 ffff880554990000 000000018ede51a0
[ 2410.268877]  ffff8801e4f90000 ffff880067ee3000 ffff880554993d58 0000000000000000
[ 2410.270369] Call Trace:
[ 2410.270868] ? rescuer_thread ()
[ 2410.271946] schedule (kernel/sched/core.c:2895)
[ 2410.272911] rescuer_thread ()
[ 2410.273933] ? worker_thread ()
[ 2410.274992] kthread (kernel/kthread.c:207)
[ 2410.275939] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.277143] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.278111] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.279231] kworker/0:1     S ffffffff986f3040 14064  2760      2 0x00000000
[ 2410.280896]  ffff880000083d58 0000000000000002 ffffffff911eeacf ffff880000000000
[ 2410.282350]  ffff880066ccb000 ffff880000080010 ffff880000080000 0000008c2ecafcd9
[ 2410.283786]  ffffffff97a3b580 ffff880066ccb000 ffff880000083d48 0000000000000000
[ 2410.285305] Call Trace:
[ 2410.285834] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.286905] schedule (kernel/sched/core.c:2895)
[ 2410.287815] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.288915] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.289948] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.291165] kthread (kernel/kthread.c:207)
[ 2410.292101] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.293303] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.294336] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.295500] kworker/2:1     S ffffffff986f3040 14144  2791      2 0x00000000
[ 2410.296954]  ffff880173d63d58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2410.298416]  ffff880173d90000 ffff880173d60010 ffff880173d60000 00000001b87e3c8f
[ 2410.299842]  ffff880176f23000 ffff880173d90000 ffff880173d63d48 0000000000000000
[ 2410.301022] Call Trace:
[ 2410.301476] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.302480] schedule (kernel/sched/core.c:2895)
[ 2410.303379] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.304457] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.305465] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.306561] kthread (kernel/kthread.c:207)
[ 2410.307527] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.308763] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.310025] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.311193] kworker/26:1    S ffffffff986f3040 14208  2795      2 0x00000000
[ 2410.312686]  ffff880173d53d58 0000000000000002 ffffffff911eeacf ffff880100000000
[ 2410.314141]  ffff8801740c0000 ffff880173d50010 ffff880173d50000 00000001a6201619
[ 2410.315595]  ffff880067c20000 ffff8801740c0000 ffff880173d53d48 0000000000000000
[ 2410.317118] Call Trace:
[ 2410.317619] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.318608] schedule (kernel/sched/core.c:2895)
[ 2410.319511] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.320023] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.321038] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.322137] kthread (kernel/kthread.c:207)
[ 2410.323079] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.324359] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.325389] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.326640] kworker/4:1     S ffffffff986f3040 14272  2967      2 0x00000000
[ 2410.328229]  ffff8802501e3d58 0000000000000002 ffffffff911eeacf ffff880200000000
[ 2410.330368]  ffff8802501a3000 ffff8802501e0010 ffff8802501e0000 00000001b80936f1
[ 2410.331859]  ffff8807e5360000 ffff8802501a3000 ffff8802501e3d48 0000000000000000
[ 2410.333389] Call Trace:
[ 2410.333912] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.334994] schedule (kernel/sched/core.c:2895)
[ 2410.335945] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.337053] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.338287] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.339648] kthread (kernel/kthread.c:207)
[ 2410.340024] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.341267] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.342240] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.343378] kworker/10:1    S ffffffff986f3040 14272  3061      2 0x00000000
[ 2410.344773]  ffff8804e4567d58 0000000000000002 ffffffff911eeacf ffff880400000000
[ 2410.346241]  ffff8804e455b000 ffff8804e4564010 ffff8804e4564000 00000001c1b6f7ae
[ 2410.347785]  ffff8800683b0000 ffff8804e455b000 ffff8804e4567d48 0000000000000000
[ 2410.350066] Call Trace:
[ 2410.350497] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.351489] schedule (kernel/sched/core.c:2895)
[ 2410.352411] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.353409] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.354365] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.355394] kthread (kernel/kthread.c:207)
[ 2410.356272] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.357492] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.358464] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.359557] kworker/11:1    S ffffffff986f3040 14272  3191      2 0x00000000
[ 2410.368730]  ffff8805549b7d58 0000000000000002 ffffffff911eeacf ffff880500000000
[ 2410.370123]  ffff8805549b8000 ffff8805549b4010 ffff8805549b4000 00000001cabe423a
[ 2410.371224]  ffff8800683b3000 ffff8805549b8000 ffff8805549b7d48 0000000000000000
[ 2410.372117] Call Trace:
[ 2410.372493] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.373121] schedule (kernel/sched/core.c:2895)
[ 2410.373914] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.374850] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.375796] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.376813] kthread (kernel/kthread.c:207)
[ 2410.377699] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.378791] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.379595] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.380018] kworker/18:1    S ffffffff986f3040 13888  3245      2 0x00000000
[ 2410.381299]  ffff880850d4fd58 0000000000000002 ffffffff911eeacf ffff880800000000
[ 2410.382634]  ffff8808513eb000 ffff880850d4c010 ffff880850d4c000 00000001e3677b36
[ 2410.384043]  ffff880252f78000 ffff8808513eb000 ffff880850d4fd48 0000000000000000
[ 2410.385477] Call Trace:
[ 2410.385933] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.386930] schedule (kernel/sched/core.c:2895)
[ 2410.387863] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.388818] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.390020] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.391043] kthread (kernel/kthread.c:207)
[ 2410.392010] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.393148] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.394216] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.395297] kworker/17:1    S ffffffff986f3040 14272  3277      2 0x00000000
[ 2410.397017]  ffff8807e4d1fd58 0000000000000002 ffffffff911eeacf ffff880700000000
[ 2410.398434]  ffff8807e4cf0000 ffff8807e4d1c010 ffff8807e4d1c000 00000001d0ba88f8
[ 2410.401031]  ffff880176ef0000 ffff8807e4cf0000 ffff8807e4d1fd48 0000000000000000
[ 2410.402371] Call Trace:
[ 2410.402806] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.403777] schedule (kernel/sched/core.c:2895)
[ 2410.404663] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.405585] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.406530] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.407598] kthread (kernel/kthread.c:207)
[ 2410.408597] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.409658] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.410020] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.411071] kworker/19:1    S ffffffff986f3040 14160  3318      2 0x00000000
[ 2410.412369]  ffff8808ba46bd58 0000000000000002 ffffffff911eeacf ffff880800000000
[ 2410.413706]  ffff8808bd3ab000 ffff8808ba468010 ffff8808ba468000 00000001e19e87a5
[ 2410.415052]  ffff88032ef48000 ffff8808bd3ab000 ffff8808ba46bd48 0000000000000000
[ 2410.416499] Call Trace:
[ 2410.416957] ? worker_thread (kernel/workqueue.c:2176)
[ 2410.417955] schedule (kernel/sched/core.c:2895)
[ 2410.418828] worker_thread (include/linux/spinlock.h:334 kernel/workqueue.c:2107)
[ 2410.420023] ? __schedule (./arch/x86/include/asm/bitops.h:311 include/linux/thread_info.h:91 include/linux/sched.h:2891 kernel/sched/core.c:2873)
[ 2410.420971] ? process_one_work (kernel/workqueue.c:2100)
[ 2410.421999] kthread (kernel/kthread.c:207)
[ 2410.422910] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.424036] ret_from_fork (arch/x86/kernel/entry_64.S:348)
[ 2410.424997] ? flush_kthread_work (kernel/kthread.c:176)
[ 2410.426097] Sched Debug Version: v0.11, 3.17.0-next-20141009-sasha-00052-gb585dd2-dirty #1374
[ 2410.427585] ktime                                   : 2410420.000000
[ 2410.428776] sched_clk                               : 2109970294.178355
[ 2410.430013] cpu_clk                                 : 2410426.092045
[ 2410.431149] jiffies                                 : 4295178339
[ 2410.432400] sched_clock_stable()                    : 0
[ 2410.433363]
[ 2410.433652] sysctl_sched
[ 2410.434117]   .sysctl_sched_latency                    : 24.000000
[ 2410.435181]   .sysctl_sched_min_granularity            : 3.000000
[ 2410.436372]   .sysctl_sched_wakeup_granularity         : 4.000000
[ 2410.437707]   .sysctl_sched_child_runs_first           : 0
[ 2410.438719]   .sysctl_sched_features                   : 110203
[ 2410.440015]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[ 2410.441265]
[ 2410.441569] cpu#0, 2260.998 MHz
[ 2410.442171]   .nr_running                    : 0
[ 2410.443018]   .load                          : 0
[ 2410.443842]   .nr_switches                   : 4390
[ 2410.444771]   .nr_load_updates               : 241044
[ 2410.445696]   .nr_uninterruptible            : -1
[ 2410.446603]   .next_balance                  : 4295.178341
[ 2410.447574]   .curr->pid                     : 0
[ 2410.448458]   .clock                         : 2410440.024448
[ 2410.449511]   .cpu_load[0]                   : 0
[ 2410.450012]   .cpu_load[1]                   : 0
[ 2410.450817]   .cpu_load[2]                   : 0
[ 2410.451663]   .cpu_load[3]                   : 0
[ 2410.452545]   .cpu_load[4]                   : 0
[ 2410.453373]   .yld_count                     : 0
[ 2410.454229]   .sched_count                   : 5149
[ 2410.455103]   .sched_goidle                  : 1510
[ 2410.456068]   .avg_idle                      : 1000000
[ 2410.456988]   .max_idle_balance_cost         : 500000
[ 2410.457880]   .ttwu_count                    : 1745
[ 2410.458849]   .ttwu_local                    : 1449
[ 2410.460202]
[ 2410.460202] cfs_rq[0]:/
[ 2410.460907]   .exec_clock                    : 1404.855413
[ 2410.461894]   .MIN_vruntime                  : 0.000001
[ 2410.462774]   .min_vruntime                  : 2484.742740
[ 2410.463733]   .max_vruntime                  : 0.000001
[ 2410.464950]   .spread                        : 0.000000
[ 2410.465947]   .spread0                       : 0.000000
[ 2410.467068]   .nr_spread_over                : 24
[ 2410.468025]   .nr_running                    : 0
[ 2410.469226]   .load                          : 0
[ 2410.470000]   .runnable_load_avg             : 0
[ 2410.470000]   .blocked_load_avg              : 0
[ 2410.470000]   .tg_load_contrib               : 0
[ 2410.470000]   .tg_runnable_contrib           : 0
[ 2410.470000]   .tg_load_avg                   : 1023
[ 2410.470000]   .tg->runnable_avg              : 1009
[ 2410.470000]   .tg->cfs_bandwidth.timer_active: 0
[ 2410.470000]   .throttled                     : 0
[ 2410.470000]   .throttle_count                : 0
[ 2410.470000]   .avg->runnable_avg_sum         : 0
[ 2410.470000]   .avg->runnable_avg_period      : 47781
[ 2410.470000]
[ 2410.470000] rt_rq[0]:/
[ 2410.470000]   .rt_nr_running                 : 0
[ 2410.470000]   .rt_throttled                  : 0
[ 2410.470000]   .rt_time                       : 0.000000
[ 2410.470000]   .rt_runtime                    : 950.000000
[ 2410.470000]
[ 2410.470000] runnable tasks:
[ 2410.470000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2410.470000] ----------------------------------------------------------------------------------------------------------
[ 2410.470000]      ksoftirqd/0     3      2473.690107        41   120      2473.690107         2.337353   2294407.990505 0 /
[ 2410.470000]      kworker/0:0     4      2466.879168        14   120      2466.879168         0.617311      6032.768214 0 /
[ 2410.470000]     kworker/0:0H     5      2361.712530         4   100      2361.712530         0.077605      5702.546789 0 /
[ 2410.470000]    kworker/u65:0     7      2361.712530         6   120      2361.712530         0.151997      5644.875550 0 /
[ 2410.470000]      rcu_preempt     8      2484.742740       533   120      2484.742740       141.855168      6881.075151 0 /
[ 2410.470000]        rcu_sched     9       169.791976         2   120       169.791976         0.088845         0.000000 0 /
[ 2410.470000]           rcu_bh    10       171.829080         2   120       171.829080         0.085366         0.000000 0 /
[ 2410.470000]           rcuc/0    11         0.000000        35    98         0.000000        40.135821         0.000000 0 /
[ 2410.470000]           rcub/0    12         0.000000         3    98         0.000000         0.251274         0.000000 0 /
[ 2410.470000]           rcub/1    13         0.000000         3    98         0.000000         0.107743         0.000000 0 /
[ 2410.470000]      migration/0    14         0.000000         5     0         0.000000        16.563157         0.000000 0 /
[ 2410.470000]       watchdog/0    15         0.000000        64     0         0.000000        21.348929         0.000000 0 /
[ 2410.470000]           rcub/2   127         0.000000         3    98         0.000000         0.109297         0.000000 0 /
[ 2410.470000]      kworker/0:1  2760      2479.351932         5   120      2479.351932         1.021067    595057.625155 0 /
[ 2410.520030]
[ 2410.520304] cpu#1, 2260.998 MHz
[ 2410.520911]   .nr_running                    : 0
[ 2410.520911]   .load                          : 0
[ 2410.521600]   .nr_switches                   : 552
[ 2410.522410]   .nr_load_updates               : 240930
[ 2410.523254]   .nr_uninterruptible            : 0
[ 2410.524080]   .next_balance                  : 4295.178349
[ 2410.525005]   .curr->pid                     : 0
[ 2410.525801]   .clock                         : 2410520.008958
[ 2410.526772]   .cpu_load[0]                   : 0
[ 2410.527575]   .cpu_load[1]                   : 0
[ 2410.528458]   .cpu_load[2]                   : 0
[ 2410.529333]   .cpu_load[3]                   : 0
[ 2410.530016]   .cpu_load[4]                   : 0
[ 2410.530852]   .yld_count                     : 0
[ 2410.531652]   .sched_count                   : 556
[ 2410.532623]   .sched_goidle                  : 252
[ 2410.533476]   .avg_idle                      : 1000000
[ 2410.534379]   .max_idle_balance_cost         : 500000
[ 2410.535265]   .ttwu_count                    : 230
[ 2410.536179]   .ttwu_local                    : 125
[ 2410.537050]
[ 2410.537050] cfs_rq[1]:/
[ 2410.537765]   .exec_clock                    : 60.261443
[ 2410.538743]   .MIN_vruntime                  : 0.000001
[ 2410.539664]   .min_vruntime                  : 1297.794892
[ 2410.540000]   .max_vruntime                  : 0.000001
[ 2410.540000]   .spread                        : 0.000000
[ 2410.540000]   .spread0                       : -1186.947848
[ 2410.540000]   .nr_spread_over                : 98
[ 2410.540000]   .nr_running                    : 0
[ 2410.540000]   .load                          : 0
[ 2410.540000]   .runnable_load_avg             : 0
[ 2410.540000]   .blocked_load_avg              : 0
[ 2410.540000]   .tg_load_contrib               : 0
[ 2410.540000]   .tg_runnable_contrib           : 0
[ 2410.540000]   .tg_load_avg                   : 1023
[ 2410.540000]   .tg->runnable_avg              : 1009
[ 2410.540000]   .tg->cfs_bandwidth.timer_active: 0
[ 2410.540000]   .throttled                     : 0
[ 2410.540000]   .throttle_count                : 0
[ 2410.540000]   .avg->runnable_avg_sum         : 0
[ 2410.540000]   .avg->runnable_avg_period      : 47825
[ 2410.540000]
[ 2410.540000] rt_rq[1]:/
[ 2410.540000]   .rt_nr_running                 : 0
[ 2410.540000]   .rt_throttled                  : 0
[ 2410.540000]   .rt_time                       : 0.000000
[ 2410.540000]   .rt_runtime                    : 950.000000
[ 2410.540000]
[ 2410.540000] runnable tasks:
[ 2410.540000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2410.540000] ----------------------------------------------------------------------------------------------------------
[ 2410.540000]       watchdog/1    16        -3.000000        64     0        -3.000000         1.790527         0.000000 1 /
[ 2410.540000]      migration/1    17         0.000000         6     0         0.000000        16.594452         0.000000 1 /
[ 2410.540000]           rcuc/1    18        -2.697790        35    98        -2.697790        49.798805         0.000000 1 /
[ 2410.540000]      ksoftirqd/1    19      1286.010549        36   120      1286.010549         4.186029   2376425.016092 1 /
[ 2410.540000]      kworker/1:0    20      1008.098700         9   120      1008.098700         0.087666      5467.978269 1 /
[ 2410.540000]     kworker/1:0H    21      1008.098700         5   100      1008.098700         0.098471      5460.810214 1 /
[ 2410.540000]    kworker/u66:0    22      1008.098700         6   120      1008.098700         0.043816      5410.721505 1 /
[ 2410.540000]          khelper   214         7.214058         2   100         7.214058         0.262636         0.030256 1 /
[ 2410.540000]            netns   216        19.214052         2   100        19.214052         0.000000         0.000000 1 /
[ 2410.580029]
[ 2410.580331] cpu#2, 2260.998 MHz
[ 2410.580990]   .nr_running                    : 1
[ 2410.581858]   .load                          : 1024
[ 2410.582927]   .nr_switches                   : 1557
[ 2410.590013]   .nr_load_updates               : 240923
[ 2410.590922]   .nr_uninterruptible            : -1
[ 2410.591780]   .next_balance                  : 4295.178362
[ 2410.592820]   .curr->pid                     : 2449
[ 2410.593715]   .clock                         : 2410590.000446
[ 2410.594728]   .cpu_load[0]                   : 1023
[ 2410.595604]   .cpu_load[1]                   : 1023
[ 2410.596551]   .cpu_load[2]                   : 1023
[ 2410.597479]   .cpu_load[3]                   : 1023
[ 2410.598394]   .cpu_load[4]                   : 1023
[ 2410.599273]   .yld_count                     : 0
[ 2410.600012]   .sched_count                   : 1558
[ 2410.600865]   .sched_goidle                  : 733
[ 2410.601720]   .avg_idle                      : 1000000
[ 2410.602618]   .max_idle_balance_cost         : 500000
[ 2410.603474]   .ttwu_count                    : 218
[ 2410.604362]   .ttwu_local                    : 168
[ 2410.605195]
[ 2410.605195] cfs_rq[2]:/
[ 2410.605908]   .exec_clock                    : 3658.665588
[ 2410.606866]   .MIN_vruntime                  : 0.000001
[ 2410.607773]   .min_vruntime                  : 4207.308825
[ 2410.608815]   .max_vruntime                  : 0.000001
[ 2410.609752]   .spread                        : 0.000000
[ 2410.610000]   .spread0                       : 1722.566085
[ 2410.610000]   .nr_spread_over                : 47
[ 2410.610000]   .nr_running                    : 1
[ 2410.610000]   .load                          : 1024
[ 2410.610000]   .runnable_load_avg             : 1023
[ 2410.610000]   .blocked_load_avg              : 0
[ 2410.610000]   .tg_load_contrib               : 1023
[ 2410.610000]   .tg_runnable_contrib           : 1009
[ 2410.610000]   .tg_load_avg                   : 1023
[ 2410.610000]   .tg->runnable_avg              : 1009
[ 2410.610000]   .tg->cfs_bandwidth.timer_active: 0
[ 2410.610000]   .throttled                     : 0
[ 2410.610000]   .throttle_count                : 0
[ 2410.610000]   .avg->runnable_avg_sum         : 46228
[ 2410.610000]   .avg->runnable_avg_period      : 46228
[ 2410.610000]
[ 2410.610000] rt_rq[2]:/
[ 2410.610000]   .rt_nr_running                 : 0
[ 2410.610000]   .rt_throttled                  : 0
[ 2410.610000]   .rt_time                       : 0.000000
[ 2410.610000]   .rt_runtime                    : 950.000000
[ 2410.610000]
[ 2410.610000] runnable tasks:
[ 2410.610000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2410.610000] ----------------------------------------------------------------------------------------------------------
[ 2410.610000]       watchdog/2    23        -5.954295        65     0        -5.954295         1.759017         0.000000 2 /
[ 2410.610000]      migration/2    24         0.000000         5     0         0.000000        16.483408         0.000000 2 /
[ 2410.610000]           rcuc/2    25        -5.847492        52    98        -5.847492       130.535593         0.000000 2 /
[ 2410.610000]      ksoftirqd/2    26       649.744424        56   120       649.744424         8.840580   1954341.300146 2 /
[ 2410.610000]      kworker/2:0    27       541.832573        11   120       541.832573         0.472425      5807.380888 2 /
[ 2410.610000]     kworker/2:0H    28       417.453822         5   100       417.453822         0.091631      5422.080542 2 /
[ 2410.610000]    kworker/u67:0    29       393.147836         7   120       393.147836         0.040779      5371.003755 2 /
[ 2410.610000] R     khungtaskd  2449      4207.308825         4   120      4207.308825      3947.418580   2399989.761000 2 /
[ 2410.610000]      kworker/2:1  2791       649.424181         3   120       649.424181         0.567890       328.400792 2 /
[ 2410.650028]
[ 2410.650304] cpu#3, 2260.998 MHz
[ 2410.650851]   .nr_running                    : 0
[ 2410.651660]   .load                          : 0
[ 2410.652467]   .nr_switches                   : 683
[ 2410.653282]   .nr_load_updates               : 240933
[ 2410.654247]   .nr_uninterruptible            : -1
[ 2410.655108]   .next_balance                  : 4295.178366
[ 2410.656094]   .curr->pid                     : 0
[ 2410.656894]   .clock                         : 2410650.011922
[ 2410.660023]   .cpu_load[0]                   : 0
[ 2410.660839]   .cpu_load[1]                   : 0
[ 2410.661657]   .cpu_load[2]                   : 0
[ 2410.662491]   .cpu_load[3]                   : 0
[ 2410.663321]   .cpu_load[4]                   : 0
[ 2410.664294]   .yld_count                     : 0
[ 2410.665122]   .sched_count                   : 684
[ 2410.665970]   .sched_goidle                  : 312
[ 2410.666819]   .avg_idle                      : 1000000
[ 2410.668044]   .max_idle_balance_cost         : 500000
[ 2410.668956]   .ttwu_count                    : 313
[ 2410.670013]   .ttwu_local                    : 140
[ 2410.670881]
[ 2410.670881] cfs_rq[3]:/
[ 2410.671590]   .exec_clock                    : 70.637097
[ 2410.672614]   .MIN_vruntime                  : 0.000001
[ 2410.673516]   .min_vruntime                  : 2125.968970
[ 2410.674494]   .max_vruntime                  : 0.000001
[ 2410.675427]   .spread                        : 0.000000
[ 2410.676372]   .spread0                       : -358.773770
[ 2410.677309]   .nr_spread_over                : 168
[ 2410.678177]   .nr_running                    : 0
[ 2410.678993]   .load                          : 0
[ 2410.679892]   .runnable_load_avg             : 0
[ 2410.680000]   .blocked_load_avg              : 0
[ 2410.680000]   .tg_load_contrib               : 0
[ 2410.680000]   .tg_runnable_contrib           : 0
[ 2410.680000]   .tg_load_avg                   : 1023
[ 2410.680000]   .tg->runnable_avg              : 1009
[ 2410.680000]   .tg->cfs_bandwidth.timer_active: 0
[ 2410.680000]   .throttled                     : 0
[ 2410.680000]   .throttle_count                : 0
[ 2410.680000]   .avg->runnable_avg_sum         : 0
[ 2410.680000]   .avg->runnable_avg_period      : 46895
[ 2410.680000]
[ 2410.680000] rt_rq[3]:/
[ 2410.680000]   .rt_nr_running                 : 0
[ 2410.680000]   .rt_throttled                  : 0
[ 2410.680000]   .rt_time                       : 0.000000
[ 2410.680000]   .rt_runtime                    : 950.000000
[ 2410.680000]
[ 2410.680000] runnable tasks:
[ 2410.680000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2410.680000] ----------------------------------------------------------------------------------------------------------
[ 2410.680000]       watchdog/3    30        -5.829671        65     0        -5.829671         2.217722         0.000000 3 /
[ 2410.680000]      migration/3    31         0.000000         5     0         0.000000        16.441398         0.000000 3 /
[ 2410.680000]           rcuc/3    32        -6.000000        39    98        -6.000000       141.308388         0.000000 3 /
[ 2410.680000]      ksoftirqd/3    33      2124.988516        41   120      2124.988516        14.898134   2257976.485322 3 /
[ 2410.680000]      kworker/3:0    34       438.814133         9   120       438.814133         0.512479      2364.146962 3 /
[ 2410.680000]     kworker/3:0H    35      1936.321899         5   100      1936.321899         0.131092      5383.051672 3 /
[ 2410.680000]    kworker/u68:0    36      1936.321501         5   120      1936.321501         2.204159      5334.159463 3 /
[ 2410.680000]      kworker/3:1   527      1997.674762         9   120      1997.674762        10.962373      3400.753146 3 /
[ 2410.710038]
[ 2410.710331] cpu#4, 2260.998 MHz
[ 2410.711089]   .nr_running                    : 0
[ 2410.711973]   .load                          : 0
[ 2410.713108]   .nr_switches                   : 350
[ 2410.720027]   .nr_load_updates               : 240937
[ 2410.721080]   .nr_uninterruptible            : -1
[ 2410.721942]   .next_balance                  : 4295.178368
[ 2410.722937]   .curr->pid                     : 0
[ 2410.723914]   .clock                         : 2410710.025868
[ 2410.724916]   .cpu_load[0]                   : 0
[ 2410.725719]   .cpu_load[1]                   : 0
[ 2410.726529]   .cpu_load[2]                   : 0
[ 2410.727382]   .cpu_load[3]                   : 0
[ 2410.728307]   .cpu_load[4]                   : 0
[ 2410.729118]   .yld_count                     : 0
[ 2410.730015]   .sched_count                   : 351
[ 2410.731006]   .sched_goidle                  : 155
[ 2410.731975]   .avg_idle                      : 1000000
[ 2410.732970]   .max_idle_balance_cost         : 500000
[ 2410.733925]   .ttwu_count                    : 172
[ 2410.734767]   .ttwu_local                    : 122
[ 2410.735617]
[ 2410.735617] cfs_rq[4]:/
[ 2410.736443]   .exec_clock                    : 21.055557
[ 2410.737407]   .MIN_vruntime                  : 0.000001
[ 2410.738320]   .min_vruntime                  : 601.042043
[ 2410.739354]   .max_vruntime                  : 0.000001
[ 2410.740000]   .spread                        : 0.000000
[ 2410.740000]   .spread0                       : -1883.700697
[ 2410.740000]   .nr_spread_over                : 43
[ 2410.740000]   .nr_running                    : 0
[ 2410.740000]   .load                          : 0
[ 2410.740000]   .runnable_load_avg             : 0
[ 2410.740000]   .blocked_load_avg              : 0
[ 2410.740000]   .tg_load_contrib               : 0
[ 2410.740000]   .tg_runnable_contrib           : 0
[ 2410.740000]   .tg_load_avg                   : 1023
[ 2410.740000]   .tg->runnable_avg              : 1009
[ 2410.740000]   .tg->cfs_bandwidth.timer_active: 0
[ 2410.740000]   .throttled                     : 0
[ 2410.740000]   .throttle_count                : 0
[ 2410.740000]   .avg->runnable_avg_sum         : 0
[ 2410.740000]   .avg->runnable_avg_period      : 46725
[ 2410.740000]
[ 2410.740000] rt_rq[4]:/
[ 2410.740000]   .rt_nr_running                 : 0
[ 2410.740000]   .rt_throttled                  : 0
[ 2410.740000]   .rt_time                       : 0.000000
[ 2410.740000]   .rt_runtime                    : 950.000000
[ 2410.740000]
[ 2410.740000] runnable tasks:
[ 2410.740000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2410.740000] ----------------------------------------------------------------------------------------------------------
[ 2410.740000]       watchdog/4    37        -8.718984        64     0        -8.718984         2.466319         0.000000 4 /
[ 2410.740000]      migration/4    38         0.000000         5     0         0.000000        16.416214         0.000000 4 /
[ 2410.740000]           rcuc/4    39        -9.000000        31    98        -9.000000        81.848927         0.000000 4 /
[ 2410.740000]      ksoftirqd/4    40       595.480237        39   120       595.480237         7.414808   2217101.121974 4 /
[ 2410.740000]      kworker/4:0    41       589.389965        11   120       589.389965         0.434621      6047.493222 4 /
[ 2410.740000]     kworker/4:0H    42       371.864093         5   100       371.864093         0.085256      5343.248497 4 /
[ 2410.740000]    kworker/u69:0    43       371.864093         7   120       371.864093         0.126147      5294.035684 4 /
[ 2410.740000]      kworker/4:1  2967       601.042043         2   120       601.042043         0.093119         1.097912 4 /
[ 2410.780028]
[ 2410.780312] cpu#5, 2260.998 MHz
[ 2410.780872]   .nr_running                    : 0
[ 2410.781706]   .load                          : 0
[ 2410.782527]   .nr_switches                   : 231
[ 2410.783428]   .nr_load_updates               : 240939
[ 2410.784345]   .nr_uninterruptible            : 2
[ 2410.790013]   .next_balance                  : 4295.178375
[ 2410.790942]   .curr->pid                     : 0
[ 2410.791731]   .clock                         : 2410780.029912
[ 2410.792865]   .cpu_load[0]                   : 0
[ 2410.793668]   .cpu_load[1]                   : 0
[ 2410.794467]   .cpu_load[2]                   : 0
[ 2410.795262]   .cpu_load[3]                   : 0
[ 2410.796113]   .cpu_load[4]                   : 0
[ 2410.796937]   .yld_count                     : 0
[ 2410.797765]   .sched_count                   : 232
[ 2410.798621]   .sched_goidle                  : 103
[ 2410.799489]   .avg_idle                      : 1000000
[ 2410.800012]   .max_idle_balance_cost         : 500000
[ 2410.800888]   .ttwu_count                    : 108
[ 2410.801705]   .ttwu_local                    : 93
[ 2410.802508]
[ 2410.802508] cfs_rq[5]:/
[ 2410.803213]   .exec_clock                    : 20.478596
[ 2410.804288]   .MIN_vruntime                  : 0.000001
[ 2410.805289]   .min_vruntime                  : 174.868094
[ 2410.806287]   .max_vruntime                  : 0.000001
[ 2410.807218]   .spread                        : 0.000000
[ 2410.808252]   .spread0                       : -2309.874646
[ 2410.809236]   .nr_spread_over                : 7
[ 2410.810000]   .nr_running                    : 0
[ 2410.810000]   .load                          : 0
[ 2410.810000]   .runnable_load_avg             : 0
[ 2410.810000]   .blocked_load_avg              : 0
[ 2410.810000]   .tg_load_contrib               : 0
[ 2410.810000]   .tg_runnable_contrib           : 0
[ 2410.810000]   .tg_load_avg                   : 1023
[ 2410.810000]   .tg->runnable_avg              : 1009
[ 2410.810000]   .tg->cfs_bandwidth.timer_active: 0
[ 2410.810000]   .throttled                     : 0
[ 2410.810000]   .throttle_count                : 0
[ 2410.810000]   .avg->runnable_avg_sum         : 0
[ 2410.810000]   .avg->runnable_avg_period      : 46745
[ 2410.810000]
[ 2410.810000] rt_rq[5]:/
[ 2410.810000]   .rt_nr_running                 : 0
[ 2410.810000]   .rt_throttled                  : 0
[ 2410.810000]   .rt_time                       : 0.000000
[ 2410.810000]   .rt_runtime                    : 950.000000
[ 2410.810000]
[ 2410.810000] runnable tasks:
[ 2410.810000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2410.810000] ----------------------------------------------------------------------------------------------------------
[ 2410.810000]       watchdog/5    44        -8.714686        64     0        -8.714686         2.377705         0.000000 5 /
[ 2410.810000]      migration/5    45         0.000000         5     0         0.000000        16.410036         0.000000 5 /
[ 2410.810000]           rcuc/5    46        -9.000000        18    98        -9.000000         6.828479         0.000000 5 /
[ 2410.810000]      ksoftirqd/5    47       171.515986        19   120       171.515986         9.164899   2324243.886432 5 /
[ 2410.810000]      kworker/5:0    48        36.820323         9   120        36.820323         0.530610      3185.791897 5 /
[ 2410.810000]     kworker/5:0H    49        60.371734         5   100        60.371734         0.091520      5303.232342 5 /
[ 2410.810000]    kworker/u70:0    50        60.371734         4   120        60.371734         0.044045      5253.983464 5 /
[ 2410.810000]      kworker/5:1  1133       163.697678         6   120       163.697678         1.011825      2828.384173 5 /
[ 2410.850027]
[ 2410.850303] cpu#6, 2260.998 MHz
[ 2410.850930]   .nr_running                    : 0
[ 2410.852040]   .load                          : 0
[ 2410.852845]   .nr_switches                   : 2893
[ 2410.853674]   .nr_load_updates               : 240943
[ 2410.854553]   .nr_uninterruptible            : 0
[ 2410.860013]   .next_balance                  : 4295.178387
[ 2410.861048]   .curr->pid                     : 0
[ 2410.861864]   .clock                         : 2410859.958231
[ 2410.862956]   .cpu_load[0]                   : 0
[ 2410.863864]   .cpu_load[1]                   : 0
[ 2410.864733]   .cpu_load[2]                   : 0
[ 2410.865642]   .cpu_load[3]                   : 0
[ 2410.866757]   .cpu_load[4]                   : 0
[ 2410.867605]   .yld_count                     : 0
[ 2410.868555]   .sched_count                   : 2894
[ 2410.869435]   .sched_goidle                  : 1398
[ 2410.870022]   .avg_idle                      : 1000000
[ 2410.870951]   .max_idle_balance_cost         : 500000
[ 2410.871932]   .ttwu_count                    : 1457
[ 2410.872784]   .ttwu_local                    : 200
[ 2410.873633]
[ 2410.873633] cfs_rq[6]:/
[ 2410.874320]   .exec_clock                    : 859.697603
[ 2410.875247]   .MIN_vruntime                  : 0.000001
[ 2410.876324]   .min_vruntime                  : 15877.001334
[ 2410.877325]   .max_vruntime                  : 0.000001
[ 2410.878257]   .spread                        : 0.000000
[ 2410.879196]   .spread0                       : 13392.258594
[ 2410.880000]   .nr_spread_over                : 1249
[ 2410.880000]   .nr_running                    : 0
[ 2410.880000]   .load                          : 0
[ 2410.880000]   .runnable_load_avg             : 0
[ 2410.880000]   .blocked_load_avg              : 0
[ 2410.880000]   .tg_load_contrib               : 0
[ 2410.880000]   .tg_runnable_contrib           : 0
[ 2410.880000]   .tg_load_avg                   : 1023
[ 2410.880000]   .tg->runnable_avg              : 1009
[ 2410.880000]   .tg->cfs_bandwidth.timer_active: 0
[ 2410.880000]   .throttled                     : 0
[ 2410.880000]   .throttle_count                : 0
[ 2410.880000]   .avg->runnable_avg_sum         : 0
[ 2410.880000]   .avg->runnable_avg_period      : 46971
[ 2410.880000]
[ 2410.880000] rt_rq[6]:/
[ 2410.880000]   .rt_nr_running                 : 0
[ 2410.880000]   .rt_throttled                  : 0
[ 2410.880000]   .rt_time                       : 0.000000
[ 2410.880000]   .rt_runtime                    : 950.000000
[ 2410.880000]
[ 2410.880000] runnable tasks:
[ 2410.880000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2410.880000] ----------------------------------------------------------------------------------------------------------
[ 2410.880000]       watchdog/6    51        -8.987617        64     0        -8.987617        62.300477         0.000000 6 /
[ 2410.880000]      migration/6    52         0.000000         5     0         0.000000        16.494017         0.000000 6 /
[ 2410.880000]           rcuc/6    53        -8.962083        63    98        -8.962083       571.704899         0.000000 6 /
[ 2410.880000]      ksoftirqd/6    54     15865.201862        67   120     15865.201862         2.071851    458568.064570 6 /
[ 2410.880000]      kworker/6:0    55      2305.180775         8   120      2305.180775         0.581357      3464.597990 6 /
[ 2410.880000]     kworker/6:0H    56     13733.207556         5   100     13733.207556         0.112255      5263.919523 6 /
[ 2410.880000]    kworker/u71:0    57     13426.127848         6   120     13426.127848         0.068695      5207.973156 6 /
[ 2410.880000]      kworker/6:1  1306     15295.106761        20   120     15295.106761        21.054344      1898.424325 6 /
[ 2410.920041]
[ 2410.920330] cpu#7, 2260.998 MHz
[ 2410.920922]   .nr_running                    : 0
[ 2410.921799]   .load                          : 0
[ 2410.922749]   .nr_switches                   : 927
[ 2410.923908]   .nr_load_updates               : 240943
[ 2410.925013]   .nr_uninterruptible            : 1
[ 2410.926155]   .next_balance                  : 4295.178390
[ 2410.930014]   .curr->pid                     : 0
[ 2410.930920]   .clock                         : 2410920.017019
[ 2410.932006]   .cpu_load[0]                   : 0
[ 2410.933044]   .cpu_load[1]                   : 0
[ 2410.933874]   .cpu_load[2]                   : 0
[ 2410.934678]   .cpu_load[3]                   : 0
[ 2410.935474]   .cpu_load[4]                   : 0
[ 2410.936431]   .yld_count                     : 0
[ 2410.937271]   .sched_count                   : 928
[ 2410.938300]   .sched_goidle                  : 423
[ 2410.939128]   .avg_idle                      : 1000000
[ 2410.940013]   .max_idle_balance_cost         : 500000
[ 2410.940952]   .ttwu_count                    : 447
[ 2410.941789]   .ttwu_local                    : 174
[ 2410.942618]
[ 2410.942618] cfs_rq[7]:/
[ 2410.943307]   .exec_clock                    : 152.638669
[ 2410.944332]   .MIN_vruntime                  : 0.000001
[ 2410.945244]   .min_vruntime                  : 3384.672835
[ 2410.946172]   .max_vruntime                  : 0.000001
[ 2410.947052]   .spread                        : 0.000000
[ 2410.947931]   .spread0                       : 899.930095
[ 2410.948929]   .nr_spread_over                : 266
[ 2410.949760]   .nr_running                    : 0
[ 2410.950000]   .load                          : 0
[ 2410.950000]   .runnable_load_avg             : 0
[ 2410.950000]   .blocked_load_avg              : 0
[ 2410.950000]   .tg_load_contrib               : 0
[ 2410.950000]   .tg_runnable_contrib           : 0
[ 2410.950000]   .tg_load_avg                   : 1023
[ 2410.950000]   .tg->runnable_avg              : 1009
[ 2410.950000]   .tg->cfs_bandwidth.timer_active: 0
[ 2410.950000]   .throttled                     : 0
[ 2410.950000]   .throttle_count                : 0
[ 2410.950000]   .avg->runnable_avg_sum         : 0
[ 2410.950000]   .avg->runnable_avg_period      : 47306
[ 2410.950000]
[ 2410.950000] rt_rq[7]:/
[ 2410.950000]   .rt_nr_running                 : 0
[ 2410.950000]   .rt_throttled                  : 0
[ 2410.950000]   .rt_time                       : 0.000000
[ 2410.950000]   .rt_runtime                    : 950.000000
[ 2410.950000]
[ 2410.950000] runnable tasks:
[ 2410.950000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2410.950000] ----------------------------------------------------------------------------------------------------------
[ 2410.950000]       watchdog/7    58        -8.907327        64     0        -8.907327         2.373221         0.000000 7 /
[ 2410.950000]      migration/7    59         0.000000         5     0         0.000000        16.434877         0.000000 7 /
[ 2410.950000]           rcuc/7    60        -9.000000        61    98        -9.000000       156.074537         0.000000 7 /
[ 2410.950000]      ksoftirqd/7    61      3372.872197        61   120      3372.872197        22.412284      5884.098705 7 /
[ 2410.950000]      kworker/7:0    62      2893.764451         9   120      2893.764451         0.107182      5230.863236 7 /
[ 2410.950000]     kworker/7:0H    63      2905.764870         5   100      2905.764870         0.124122      5225.081536 7 /
[ 2410.950000]    kworker/u72:0    64      2857.764469         6   120      2857.764469         1.468943      5173.498262 7 /
[ 2410.980032]
[ 2410.980330] cpu#8, 2260.998 MHz
[ 2410.980887]   .nr_running                    : 0
[ 2410.981692]   .load                          : 0
[ 2410.982528]   .nr_switches                   : 608
[ 2410.983440]   .nr_load_updates               : 240946
[ 2410.984764]   .nr_uninterruptible            : 1
[ 2410.990013]   .next_balance                  : 4295.178399
[ 2410.991056]   .curr->pid                     : 0
[ 2410.991874]   .clock                         : 2410990.012129
[ 2410.992985]   .cpu_load[0]                   : 0
[ 2410.993778]   .cpu_load[1]                   : 0
[ 2410.994608]   .cpu_load[2]                   : 0
[ 2410.995415]   .cpu_load[3]                   : 0
[ 2410.996335]   .cpu_load[4]                   : 0
[ 2410.997140]   .yld_count                     : 0
[ 2410.997945]   .sched_count                   : 609
[ 2410.998775]   .sched_goidle                  : 280
[ 2410.999602]   .avg_idle                      : 1000000
[ 2411.000016]   .max_idle_balance_cost         : 500000
[ 2411.000945]   .ttwu_count                    : 192
[ 2411.001809]   .ttwu_local                    : 120
[ 2411.002676]
[ 2411.002676] cfs_rq[8]:/
[ 2411.003436]   .exec_clock                    : 465.773593
[ 2411.004430]   .MIN_vruntime                  : 0.000001
[ 2411.005364]   .min_vruntime                  : 1301.007429
[ 2411.006330]   .max_vruntime                  : 0.000001
[ 2411.007272]   .spread                        : 0.000000
[ 2411.008309]   .spread0                       : -1183.735311
[ 2411.009263]   .nr_spread_over                : 63
[ 2411.010000]   .nr_running                    : 0
[ 2411.010000]   .load                          : 0
[ 2411.010000]   .runnable_load_avg             : 0
[ 2411.010000]   .blocked_load_avg              : 0
[ 2411.010000]   .tg_load_contrib               : 0
[ 2411.010000]   .tg_runnable_contrib           : 0
[ 2411.010000]   .tg_load_avg                   : 1023
[ 2411.010000]   .tg->runnable_avg              : 1009
[ 2411.010000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.010000]   .throttled                     : 0
[ 2411.010000]   .throttle_count                : 0
[ 2411.010000]   .avg->runnable_avg_sum         : 0
[ 2411.010000]   .avg->runnable_avg_period      : 47760
[ 2411.010000]
[ 2411.010000] rt_rq[8]:/
[ 2411.010000]   .rt_nr_running                 : 0
[ 2411.010000]   .rt_throttled                  : 0
[ 2411.010000]   .rt_time                       : 0.000000
[ 2411.010000]   .rt_runtime                    : 950.000000
[ 2411.010000]
[ 2411.010000] runnable tasks:
[ 2411.010000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.010000] ----------------------------------------------------------------------------------------------------------
[ 2411.010000]       watchdog/8    65       -11.591015        64     0       -11.591015        12.102810         0.000000 8 /
[ 2411.010000]      migration/8    66         0.000000         6     0         0.000000        18.494335         0.000000 8 /
[ 2411.010000]           rcuc/8    67       -12.000000        33    98       -12.000000        92.159993         0.000000 8 /
[ 2411.010000]      ksoftirqd/8    68       899.679450        33   120       899.679450         1.790754      6513.015800 8 /
[ 2411.010000]      kworker/8:0    69       396.962635         9   120       396.962635         0.084296      5190.692941 8 /
[ 2411.010000]     kworker/8:0H    70       396.962635         5   100       396.962635         0.109323      5183.654484 8 /
[ 2411.010000]    kworker/u73:0    71       348.962659         5   120       348.962659         0.057492      5131.815207 8 /
[ 2411.040028]
[ 2411.040309] cpu#9, 2260.998 MHz
[ 2411.040859]   .nr_running                    : 0
[ 2411.041661]   .load                          : 0
[ 2411.042469]   .nr_switches                   : 759
[ 2411.043288]   .nr_load_updates               : 240950
[ 2411.044236]   .nr_uninterruptible            : 0
[ 2411.045026]   .next_balance                  : 4295.178408
[ 2411.050014]   .curr->pid                     : 0
[ 2411.050808]   .clock                         : 2411040.019631
[ 2411.051841]   .cpu_load[0]                   : 0
[ 2411.052629]   .cpu_load[1]                   : 0
[ 2411.053436]   .cpu_load[2]                   : 0
[ 2411.054234]   .cpu_load[3]                   : 0
[ 2411.055020]   .cpu_load[4]                   : 0
[ 2411.055950]   .yld_count                     : 0
[ 2411.056749]   .sched_count                   : 760
[ 2411.057586]   .sched_goidle                  : 357
[ 2411.058403]   .avg_idle                      : 1000000
[ 2411.059281]   .max_idle_balance_cost         : 500000
[ 2411.060014]   .ttwu_count                    : 167
[ 2411.060849]   .ttwu_local                    : 103
[ 2411.061676]
[ 2411.061676] cfs_rq[9]:/
[ 2411.062368]   .exec_clock                    : 95.292793
[ 2411.063370]   .MIN_vruntime                  : 0.000001
[ 2411.064272]   .min_vruntime                  : 823.247529
[ 2411.065198]   .max_vruntime                  : 0.000001
[ 2411.066116]   .spread                        : 0.000000
[ 2411.067046]   .spread0                       : -1661.495211
[ 2411.068095]   .nr_spread_over                : 58
[ 2411.068900]   .nr_running                    : 0
[ 2411.069705]   .load                          : 0
[ 2411.070000]   .runnable_load_avg             : 0
[ 2411.070000]   .blocked_load_avg              : 0
[ 2411.070000]   .tg_load_contrib               : 0
[ 2411.070000]   .tg_runnable_contrib           : 0
[ 2411.070000]   .tg_load_avg                   : 1023
[ 2411.070000]   .tg->runnable_avg              : 1009
[ 2411.070000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.070000]   .throttled                     : 0
[ 2411.070000]   .throttle_count                : 0
[ 2411.070000]   .avg->runnable_avg_sum         : 0
[ 2411.070000]   .avg->runnable_avg_period      : 46883
[ 2411.070000]
[ 2411.070000] rt_rq[9]:/
[ 2411.070000]   .rt_nr_running                 : 0
[ 2411.070000]   .rt_throttled                  : 0
[ 2411.070000]   .rt_time                       : 0.000000
[ 2411.070000]   .rt_runtime                    : 950.000000
[ 2411.070000]
[ 2411.070000] runnable tasks:
[ 2411.070000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.070000] ----------------------------------------------------------------------------------------------------------
[ 2411.070000]       watchdog/9    72       -11.762618        64     0       -11.762618       241.737549         0.000000 9 /
[ 2411.070000]      migration/9    73         0.000000         5     0         0.000000        16.379425         0.000000 9 /
[ 2411.070000]           rcuc/9    74       -12.000000        24    98       -12.000000        76.845501         0.000000 9 /
[ 2411.070000]      ksoftirqd/9    75       819.417418        29   120       819.417418        14.162553   2309418.394883 9 /
[ 2411.070000]      kworker/9:0    76       103.514401         9   120       103.514401         0.088349      5149.772781 9 /
[ 2411.070000]     kworker/9:0H    77       103.514925         5   100       103.514925         0.142795      5142.982962 9 /
[ 2411.070000]    kworker/u74:0    78       103.566072         4   120       103.566072         0.072763      5092.706818 9 /
[ 2411.070000]    kworker/u64:1   217       103.594895      2884   120       103.594895       140.358393      3583.392560 9 /
[ 2411.100029]
[ 2411.100306] cpu#10, 2260.998 MHz
[ 2411.100932]   .nr_running                    : 0
[ 2411.101741]   .load                          : 0
[ 2411.102553]   .nr_switches                   : 412
[ 2411.110013]   .nr_load_updates               : 240951
[ 2411.110890]   .nr_uninterruptible            : -1
[ 2411.111741]   .next_balance                  : 4295.178412
[ 2411.112771]   .curr->pid                     : 0
[ 2411.113608]   .clock                         : 2411100.019589
[ 2411.114629]   .cpu_load[0]                   : 0
[ 2411.115546]   .cpu_load[1]                   : 0
[ 2411.116579]   .cpu_load[2]                   : 0
[ 2411.117456]   .cpu_load[3]                   : 0
[ 2411.118272]   .cpu_load[4]                   : 0
[ 2411.119071]   .yld_count                     : 0
[ 2411.120015]   .sched_count                   : 413
[ 2411.120835]   .sched_goidle                  : 192
[ 2411.121716]   .avg_idle                      : 1000000
[ 2411.122583]   .max_idle_balance_cost         : 500000
[ 2411.123502]   .ttwu_count                    : 108
[ 2411.124346]   .ttwu_local                    : 83
[ 2411.125225]
[ 2411.125225] cfs_rq[10]:/
[ 2411.125995]   .exec_clock                    : 43.666889
[ 2411.127020]   .MIN_vruntime                  : 0.000001
[ 2411.128054]   .min_vruntime                  : 340.496637
[ 2411.128984]   .max_vruntime                  : 0.000001
[ 2411.129916]   .spread                        : 0.000000
[ 2411.130000]   .spread0                       : -2144.246103
[ 2411.130000]   .nr_spread_over                : 18
[ 2411.130000]   .nr_running                    : 0
[ 2411.130000]   .load                          : 0
[ 2411.130000]   .runnable_load_avg             : 0
[ 2411.130000]   .blocked_load_avg              : 0
[ 2411.130000]   .tg_load_contrib               : 0
[ 2411.130000]   .tg_runnable_contrib           : 0
[ 2411.130000]   .tg_load_avg                   : 1023
[ 2411.130000]   .tg->runnable_avg              : 1009
[ 2411.130000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.130000]   .throttled                     : 0
[ 2411.130000]   .throttle_count                : 0
[ 2411.130000]   .avg->runnable_avg_sum         : 0
[ 2411.130000]   .avg->runnable_avg_period      : 47078
[ 2411.130000]
[ 2411.130000] rt_rq[10]:/
[ 2411.130000]   .rt_nr_running                 : 0
[ 2411.130000]   .rt_throttled                  : 0
[ 2411.130000]   .rt_time                       : 0.000000
[ 2411.130000]   .rt_runtime                    : 950.000000
[ 2411.130000]
[ 2411.130000] runnable tasks:
[ 2411.130000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.130000] ----------------------------------------------------------------------------------------------------------
[ 2411.130000]      watchdog/10    79       -11.863076        64     0       -11.863076         2.034022         0.000000 10 /
[ 2411.130000]     migration/10    80         0.000000         5     0         0.000000        16.273118         0.000000 10 /
[ 2411.130000]          rcuc/10    81       -12.000000        14    98       -12.000000        31.336181         0.000000 10 /
[ 2411.130000]     ksoftirqd/10    82       328.572924        14   120       328.572924         0.303733      6129.909867 10 /
[ 2411.130000]     kworker/10:0    83       140.751062        11   120       140.751062         0.502393      5971.133417 10 /
[ 2411.130000]    kworker/10:0H    84        -3.208636         5   100        -3.208636         0.047639      5106.084866 10 /
[ 2411.130000]    kworker/u75:0    85        -1.048576         7   120        -1.048576         0.020066      5055.664531 10 /
[ 2411.130000]     kworker/10:1  3061       152.751062         2   120       152.751062         0.000000         0.000000 10 /
[ 2411.170041]
[ 2411.170345] cpu#11, 2260.998 MHz
[ 2411.170917]   .nr_running                    : 0
[ 2411.171757]   .load                          : 0
[ 2411.172564]   .nr_switches                   : 411
[ 2411.173410]   .nr_load_updates               : 240953
[ 2411.174405]   .nr_uninterruptible            : -1
[ 2411.175237]   .next_balance                  : 4295.178419
[ 2411.176213]   .curr->pid                     : 0
[ 2411.177018]   .clock                         : 2411170.021381
[ 2411.180024]   .cpu_load[0]                   : 0
[ 2411.180825]   .cpu_load[1]                   : 0
[ 2411.181622]   .cpu_load[2]                   : 0
[ 2411.182432]   .cpu_load[3]                   : 0
[ 2411.183228]   .cpu_load[4]                   : 0
[ 2411.184096]   .yld_count                     : 0
[ 2411.184941]   .sched_count                   : 412
[ 2411.185771]   .sched_goidle                  : 190
[ 2411.186626]   .avg_idle                      : 1000000
[ 2411.187556]   .max_idle_balance_cost         : 500000
[ 2411.188584]   .ttwu_count                    : 186
[ 2411.189432]   .ttwu_local                    : 97
[ 2411.190023]
[ 2411.190023] cfs_rq[11]:/
[ 2411.190733]   .exec_clock                    : 43.079945
[ 2411.191699]   .MIN_vruntime                  : 0.000001
[ 2411.192604]   .min_vruntime                  : 1098.871288
[ 2411.193539]   .max_vruntime                  : 0.000001
[ 2411.194452]   .spread                        : 0.000000
[ 2411.195365]   .spread0                       : -1385.871452
[ 2411.196475]   .nr_spread_over                : 83
[ 2411.197333]   .nr_running                    : 0
[ 2411.198155]   .load                          : 0
[ 2411.198981]   .runnable_load_avg             : 0
[ 2411.199915]   .blocked_load_avg              : 0
[ 2411.200000]   .tg_load_contrib               : 0
[ 2411.200000]   .tg_runnable_contrib           : 0
[ 2411.200000]   .tg_load_avg                   : 1023
[ 2411.200000]   .tg->runnable_avg              : 1009
[ 2411.200000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.200000]   .throttled                     : 0
[ 2411.200000]   .throttle_count                : 0
[ 2411.200000]   .avg->runnable_avg_sum         : 0
[ 2411.200000]   .avg->runnable_avg_period      : 47210
[ 2411.200000]
[ 2411.200000] rt_rq[11]:/
[ 2411.200000]   .rt_nr_running                 : 0
[ 2411.200000]   .rt_throttled                  : 0
[ 2411.200000]   .rt_time                       : 0.000000
[ 2411.200000]   .rt_runtime                    : 950.000000
[ 2411.200000]
[ 2411.200000] runnable tasks:
[ 2411.200000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.200000] ----------------------------------------------------------------------------------------------------------
[ 2411.200000]      watchdog/11    86       -11.882318        64     0       -11.882318         2.016977         0.000000 11 /
[ 2411.200000]     migration/11    87         0.000000         5     0         0.000000        16.359475         0.000000 11 /
[ 2411.200000]          rcuc/11    88       -11.964787        21    98       -11.964787        53.475339         0.000000 11 /
[ 2411.200000]     ksoftirqd/11    89      1086.994436        21   120      1086.994436        14.345390      6212.028945 11 /
[ 2411.200000]     kworker/11:0    90      1074.871294        11   120      1074.871294         0.065938      6092.994368 11 /
[ 2411.200000]    kworker/11:0H    91        11.999988         5   100        11.999988         0.046825      5075.520328 11 /
[ 2411.200000]    kworker/u76:0    92        12.979733         7   120        12.979733         0.999294      5025.623248 11 /
[ 2411.200000]     kworker/11:1  3191      1086.871294         2   120      1086.871294         0.000000         0.000000 11 /
[ 2411.230040]
[ 2411.230388] cpu#12, 2260.998 MHz
[ 2411.231002]   .nr_running                    : 0
[ 2411.231844]   .load                          : 0
[ 2411.232691]   .nr_switches                   : 200
[ 2411.233565]   .nr_load_updates               : 240955
[ 2411.240014]   .nr_uninterruptible            : 7
[ 2411.240859]   .next_balance                  : 4295.178429
[ 2411.241814]   .curr->pid                     : 0
[ 2411.242623]   .clock                         : 2411240.009625
[ 2411.243609]   .cpu_load[0]                   : 0
[ 2411.244476]   .cpu_load[1]                   : 0
[ 2411.245350]   .cpu_load[2]                   : 0
[ 2411.246183]   .cpu_load[3]                   : 0
[ 2411.247017]   .cpu_load[4]                   : 0
[ 2411.247956]   .yld_count                     : 0
[ 2411.248789]   .sched_count                   : 208
[ 2411.249671]   .sched_goidle                  : 97
[ 2411.250014]   .avg_idle                      : 1000000
[ 2411.250951]   .max_idle_balance_cost         : 500000
[ 2411.251952]   .ttwu_count                    : 74
[ 2411.252812]   .ttwu_local                    : 60
[ 2411.253658]
[ 2411.253658] cfs_rq[12]:/
[ 2411.254356]   .exec_clock                    : 1.197013
[ 2411.255359]   .MIN_vruntime                  : 0.000001
[ 2411.256358]   .min_vruntime                  : 168.024711
[ 2411.257373]   .max_vruntime                  : 0.000001
[ 2411.258343]   .spread                        : 0.000000
[ 2411.259418]   .spread0                       : -2316.718029
[ 2411.260000]   .nr_spread_over                : 0
[ 2411.260000]   .nr_running                    : 0
[ 2411.260000]   .load                          : 0
[ 2411.260000]   .runnable_load_avg             : 0
[ 2411.260000]   .blocked_load_avg              : 0
[ 2411.260000]   .tg_load_contrib               : 0
[ 2411.260000]   .tg_runnable_contrib           : 0
[ 2411.260000]   .tg_load_avg                   : 1023
[ 2411.260000]   .tg->runnable_avg              : 1009
[ 2411.260000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.260000]   .throttled                     : 0
[ 2411.260000]   .throttle_count                : 0
[ 2411.260000]   .avg->runnable_avg_sum         : 0
[ 2411.260000]   .avg->runnable_avg_period      : 46826
[ 2411.260000]
[ 2411.260000] rt_rq[12]:/
[ 2411.260000]   .rt_nr_running                 : 0
[ 2411.260000]   .rt_throttled                  : 0
[ 2411.260000]   .rt_time                       : 0.000000
[ 2411.260000]   .rt_runtime                    : 950.000000
[ 2411.260000]
[ 2411.260000] runnable tasks:
[ 2411.260000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.260000] ----------------------------------------------------------------------------------------------------------
[ 2411.260000]      watchdog/12    93       -11.942514        65     0       -11.942514         1.853807         0.000000 12 /
[ 2411.260000]     migration/12    94         0.000000         5     0         0.000000        16.181353         0.000000 12 /
[ 2411.260000]          rcuc/12    95       -12.000000         4    98       -12.000000         0.130953         0.000000 12 /
[ 2411.260000]     ksoftirqd/12    96       -13.048576         4   120       -13.048576         0.126916         0.000000 12 /
[ 2411.260000]     kworker/12:0    97        59.252878         9   120        59.252878         0.134412      5040.113180 12 /
[ 2411.260000]    kworker/12:0H    98        71.283104         5   100        71.283104         0.084873      5034.453899 12 /
[ 2411.260000]    kworker/u77:0    99        -1.048576         7   120        -1.048576         0.042142      4982.611475 12 /
[ 2411.260000]        writeback  2452        10.951418         2   100        10.951418         0.000000         0.000000 12 /
[ 2411.260000]             ksmd  2459        22.951412         2   125        22.951412         0.000000         0.000000 12 /
[ 2411.260000]       khugepaged  2462        34.951406         2   139        34.951406         0.000000         0.018710 12 /
[ 2411.260000]           crypto  2473        46.951400         2   100        46.951400         0.000000         0.000000 12 /
[ 2411.260000]      kintegrityd  2482        71.252878         2   100        71.252878         0.000000         0.215201 12 /
[ 2411.260000]           bioset  2492        83.283104         2   100        83.283104         0.047595         5.808248 12 /
[ 2411.260000]          kblockd  2497        95.283098         2   100        95.283098         0.000000         0.000000 12 /
[ 2411.310037]
[ 2411.310388] cpu#13, 2260.998 MHz
[ 2411.310966]   .nr_running                    : 0
[ 2411.311766]   .load                          : 0
[ 2411.312567]   .nr_switches                   : 235
[ 2411.313398]   .nr_load_updates               : 240960
[ 2411.314360]   .nr_uninterruptible            : 0
[ 2411.315172]   .next_balance                  : 4295.178429
[ 2411.316126]   .curr->pid                     : 0
[ 2411.316935]   .clock                         : 2411310.014968
[ 2411.317932]   .cpu_load[0]                   : 0
[ 2411.320013]   .cpu_load[1]                   : 0
[ 2411.320818]   .cpu_load[2]                   : 0
[ 2411.321629]   .cpu_load[3]                   : 0
[ 2411.322421]   .cpu_load[4]                   : 0
[ 2411.323210]   .yld_count                     : 0
[ 2411.324075]   .sched_count                   : 236
[ 2411.324889]   .sched_goidle                  : 112
[ 2411.325731]   .avg_idle                      : 1000000
[ 2411.326617]   .max_idle_balance_cost         : 500000
[ 2411.327573]   .ttwu_count                    : 72
[ 2411.328448]   .ttwu_local                    : 70
[ 2411.329287]
[ 2411.329287] cfs_rq[13]:/
[ 2411.330000]   .exec_clock                    : 14.427142
[ 2411.330000]   .MIN_vruntime                  : 0.000001
[ 2411.330000]   .min_vruntime                  : 43.495923
[ 2411.330000]   .max_vruntime                  : 0.000001
[ 2411.330000]   .spread                        : 0.000000
[ 2411.330000]   .spread0                       : -2441.246817
[ 2411.330000]   .nr_spread_over                : 0
[ 2411.330000]   .nr_running                    : 0
[ 2411.330000]   .load                          : 0
[ 2411.330000]   .runnable_load_avg             : 0
[ 2411.330000]   .blocked_load_avg              : 0
[ 2411.330000]   .tg_load_contrib               : 0
[ 2411.330000]   .tg_runnable_contrib           : 0
[ 2411.330000]   .tg_load_avg                   : 1023
[ 2411.330000]   .tg->runnable_avg              : 1009
[ 2411.330000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.330000]   .throttled                     : 0
[ 2411.330000]   .throttle_count                : 0
[ 2411.330000]   .avg->runnable_avg_sum         : 0
[ 2411.330000]   .avg->runnable_avg_period      : 47803
[ 2411.330000]
[ 2411.330000] rt_rq[13]:/
[ 2411.330000]   .rt_nr_running                 : 0
[ 2411.330000]   .rt_throttled                  : 0
[ 2411.330000]   .rt_time                       : 0.000000
[ 2411.330000]   .rt_runtime                    : 950.000000
[ 2411.330000]
[ 2411.330000] runnable tasks:
[ 2411.330000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.330000] ----------------------------------------------------------------------------------------------------------
[ 2411.330000]      watchdog/13   100       -11.618062        65     0       -11.618062        22.339001         0.000000 13 /
[ 2411.330000]     migration/13   101         0.000000         5     0         0.000000        16.267033         0.000000 13 /
[ 2411.330000]          rcuc/13   102       -12.000000         8    98       -12.000000         5.125244         0.000000 13 /
[ 2411.330000]     ksoftirqd/13   103        36.265224        10   120        36.265224         6.318655     36720.125149 13 /
[ 2411.330000]     kworker/13:0   104        31.495923         9   120        31.495923         0.087394      4999.963473 13 /
[ 2411.330000]    kworker/13:0H   105        31.495923         5   100        31.495923         0.089324      4994.140764 13 /
[ 2411.330000]    kworker/u78:0   106        31.495923         7   120        31.495923         0.040040      4942.258911 13 /
[ 2411.370034]
[ 2411.370309] cpu#14, 2260.998 MHz
[ 2411.370864]   .nr_running                    : 0
[ 2411.371646]   .load                          : 0
[ 2411.372433]   .nr_switches                   : 168
[ 2411.373248]   .nr_load_updates               : 240963
[ 2411.374144]   .nr_uninterruptible            : 0
[ 2411.374922]   .next_balance                  : 4295.178436
[ 2411.375870]   .curr->pid                     : 0
[ 2411.376649]   .clock                         : 2411370.009374
[ 2411.377611]   .cpu_load[0]                   : 0
[ 2411.380013]   .cpu_load[1]                   : 0
[ 2411.380781]   .cpu_load[2]                   : 0
[ 2411.381556]   .cpu_load[3]                   : 0
[ 2411.382333]   .cpu_load[4]                   : 0
[ 2411.383113]   .yld_count                     : 0
[ 2411.384038]   .sched_count                   : 169
[ 2411.384960]   .sched_goidle                  : 81
[ 2411.385778]   .avg_idle                      : 1000000
[ 2411.386700]   .max_idle_balance_cost         : 500000
[ 2411.387651]   .ttwu_count                    : 67
[ 2411.388454]   .ttwu_local                    : 66
[ 2411.389278]
[ 2411.389278] cfs_rq[14]:/
[ 2411.389996]   .exec_clock                    : 4.779922
[ 2411.390000]   .MIN_vruntime                  : 0.000001
[ 2411.390000]   .min_vruntime                  : 15.419945
[ 2411.390000]   .max_vruntime                  : 0.000001
[ 2411.390000]   .spread                        : 0.000000
[ 2411.390000]   .spread0                       : -2469.322795
[ 2411.390000]   .nr_spread_over                : 0
[ 2411.390000]   .nr_running                    : 0
[ 2411.390000]   .load                          : 0
[ 2411.390000]   .runnable_load_avg             : 0
[ 2411.390000]   .blocked_load_avg              : 0
[ 2411.390000]   .tg_load_contrib               : 0
[ 2411.390000]   .tg_runnable_contrib           : 0
[ 2411.390000]   .tg_load_avg                   : 1023
[ 2411.390000]   .tg->runnable_avg              : 1009
[ 2411.390000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.390000]   .throttled                     : 0
[ 2411.390000]   .throttle_count                : 0
[ 2411.390000]   .avg->runnable_avg_sum         : 0
[ 2411.390000]   .avg->runnable_avg_period      : 47145
[ 2411.390000]
[ 2411.390000] rt_rq[14]:/
[ 2411.390000]   .rt_nr_running                 : 0
[ 2411.390000]   .rt_throttled                  : 0
[ 2411.390000]   .rt_time                       : 0.000000
[ 2411.390000]   .rt_runtime                    : 950.000000
[ 2411.390000]
[ 2411.390000] runnable tasks:
[ 2411.390000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.390000] ----------------------------------------------------------------------------------------------------------
[ 2411.390000]      watchdog/14   107       -11.968285        64     0       -11.968285         1.752756         0.000000 14 /
[ 2411.390000]     migration/14   108         0.000000         5     0         0.000000        16.325863         0.000000 14 /
[ 2411.390000]          rcuc/14   109       -12.000000         6    98       -12.000000         0.555867         0.000000 14 /
[ 2411.390000]     ksoftirqd/14   110         3.652384         8   120         3.652384         0.353412   2288890.783639 14 /
[ 2411.390000]     kworker/14:0   111         3.419945         9   120         3.419945         0.132713      4960.124501 14 /
[ 2411.390000]    kworker/14:0H   112         3.419945         5   100         3.419945         0.084121      4953.891525 14 /
[ 2411.390000]    kworker/u79:0   113         3.419945         6   120         3.419945         0.036552      4902.432199 14 /
[ 2411.430030]
[ 2411.430324] cpu#15, 2260.998 MHz
[ 2411.430963]   .nr_running                    : 0
[ 2411.431789]   .load                          : 0
[ 2411.432622]   .nr_switches                   : 169
[ 2411.433473]   .nr_load_updates               : 240964
[ 2411.434425]   .nr_uninterruptible            : 0
[ 2411.435258]   .next_balance                  : 4295.178441
[ 2411.436204]   .curr->pid                     : 0
[ 2411.437010]   .clock                         : 2411430.022981
[ 2411.438013]   .cpu_load[0]                   : 0
[ 2411.440015]   .cpu_load[1]                   : 0
[ 2411.440835]   .cpu_load[2]                   : 0
[ 2411.441642]   .cpu_load[3]                   : 0
[ 2411.442437]   .cpu_load[4]                   : 0
[ 2411.443215]   .yld_count                     : 0
[ 2411.444078]   .sched_count                   : 170
[ 2411.444912]   .sched_goidle                  : 82
[ 2411.445703]   .avg_idle                      : 1000000
[ 2411.446589]   .max_idle_balance_cost         : 500000
[ 2411.447511]   .ttwu_count                    : 63
[ 2411.448011]   .ttwu_local                    : 63
[ 2411.448447]
[ 2411.448447] cfs_rq[15]:/
[ 2411.448825]   .exec_clock                    : 0.482620
[ 2411.449304]   .MIN_vruntime                  : 0.000001
[ 2411.449790]   .min_vruntime                  : -1.048576
[ 2411.450000]   .max_vruntime                  : 0.000001
[ 2411.450000]   .spread                        : 0.000000
[ 2411.450000]   .spread0                       : -2485.791316
[ 2411.450000]   .nr_spread_over                : 0
[ 2411.450000]   .nr_running                    : 0
[ 2411.450000]   .load                          : 0
[ 2411.450000]   .runnable_load_avg             : 0
[ 2411.450000]   .blocked_load_avg              : 0
[ 2411.450000]   .tg_load_contrib               : 0
[ 2411.450000]   .tg_runnable_contrib           : 0
[ 2411.450000]   .tg_load_avg                   : 1023
[ 2411.450000]   .tg->runnable_avg              : 1009
[ 2411.450000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.450000]   .throttled                     : 0
[ 2411.450000]   .throttle_count                : 0
[ 2411.450000]   .avg->runnable_avg_sum         : 0
[ 2411.450000]   .avg->runnable_avg_period      : 47418
[ 2411.450000]
[ 2411.450000] rt_rq[15]:/
[ 2411.450000]   .rt_nr_running                 : 0
[ 2411.450000]   .rt_throttled                  : 0
[ 2411.450000]   .rt_time                       : 0.000000
[ 2411.450000]   .rt_runtime                    : 950.000000
[ 2411.450000]
[ 2411.450000] runnable tasks:
[ 2411.450000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.450000] ----------------------------------------------------------------------------------------------------------
[ 2411.450000]      watchdog/15   114       -11.943272        65     0       -11.943272         1.771749         0.000000 15 /
[ 2411.450000]     migration/15   115         0.000000         5     0         0.000000        16.208149         0.000000 15 /
[ 2411.450000]          rcuc/15   116       -12.000000         4    98       -12.000000         0.117200         0.000000 15 /
[ 2411.450000]     ksoftirqd/15   117       -12.904921         7   120       -12.904921         0.261585   2322694.795376 15 /
[ 2411.450000]     kworker/15:0   118       -12.766339         9   120       -12.766339         0.367641      4920.199372 15 /
[ 2411.450000]    kworker/15:0H   119       -10.259592         5   100       -10.259592         0.092997      4907.939966 15 /
[ 2411.450000]    kworker/u80:0   120        -1.048576         7   120        -1.048576         0.041679      4855.099955 15 /
[ 2411.490042]
[ 2411.490353] cpu#16, 2260.998 MHz
[ 2411.490953]   .nr_running                    : 0
[ 2411.490953]   .load                          : 0
[ 2411.491794]   .nr_switches                   : 161
[ 2411.492668]   .nr_load_updates               : 240964
[ 2411.493578]   .nr_uninterruptible            : 2
[ 2411.494437]   .next_balance                  : 4295.178446
[ 2411.495520]   .curr->pid                     : 0
[ 2411.496386]   .clock                         : 2411480.016768
[ 2411.497426]   .cpu_load[0]                   : 0
[ 2411.498254]   .cpu_load[1]                   : 0
[ 2411.499087]   .cpu_load[2]                   : 0
[ 2411.500014]   .cpu_load[3]                   : 0
[ 2411.500872]   .cpu_load[4]                   : 0
[ 2411.501712]   .yld_count                     : 0
[ 2411.502562]   .sched_count                   : 162
[ 2411.503478]   .sched_goidle                  : 78
[ 2411.504307]   .avg_idle                      : 1000000
[ 2411.505199]   .max_idle_balance_cost         : 500000
[ 2411.506111]   .ttwu_count                    : 63
[ 2411.506952]   .ttwu_local                    : 61
[ 2411.507857]
[ 2411.507857] cfs_rq[16]:/
[ 2411.508643]   .exec_clock                    : 12.746254
[ 2411.509586]   .MIN_vruntime                  : 0.000001
[ 2411.510000]   .min_vruntime                  : 25.483328
[ 2411.510000]   .max_vruntime                  : 0.000001
[ 2411.510000]   .spread                        : 0.000000
[ 2411.510000]   .spread0                       : -2459.259412
[ 2411.510000]   .nr_spread_over                : 0
[ 2411.510000]   .nr_running                    : 0
[ 2411.510000]   .load                          : 0
[ 2411.510000]   .runnable_load_avg             : 0
[ 2411.510000]   .blocked_load_avg              : 0
[ 2411.510000]   .tg_load_contrib               : 0
[ 2411.510000]   .tg_runnable_contrib           : 0
[ 2411.510000]   .tg_load_avg                   : 1023
[ 2411.510000]   .tg->runnable_avg              : 1009
[ 2411.510000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.510000]   .throttled                     : 0
[ 2411.510000]   .throttle_count                : 0
[ 2411.510000]   .avg->runnable_avg_sum         : 0
[ 2411.510000]   .avg->runnable_avg_period      : 47833
[ 2411.510000]
[ 2411.510000] rt_rq[16]:/
[ 2411.510000]   .rt_nr_running                 : 0
[ 2411.510000]   .rt_throttled                  : 0
[ 2411.510000]   .rt_time                       : 0.000000
[ 2411.510000]   .rt_runtime                    : 950.000000
[ 2411.510000]
[ 2411.510000] runnable tasks:
[ 2411.510000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.510000] ----------------------------------------------------------------------------------------------------------
[ 2411.510000]      watchdog/16   121       -11.721401        64     0       -11.721401        57.255880         0.000000 16 /
[ 2411.510000]     migration/16   122         0.000000         5     0         0.000000        16.198310         0.000000 16 /
[ 2411.510000]          rcuc/16   123       -12.000000         4    98       -12.000000         0.119951         0.000000 16 /
[ 2411.510000]     ksoftirqd/16   124        23.419067         5   120        23.419067        10.002304   1068260.357073 16 /
[ 2411.510000]     kworker/16:0   125       -12.223984         9   120       -12.223984         0.063150      4870.524513 16 /
[ 2411.510000]    kworker/16:0H   126        -4.224500         5   100        -4.224500         0.086418      4877.088389 16 /
[ 2411.510000]    kworker/u81:0   128         0.889373         6   120         0.889373         0.199788      4811.777997 16 /
[ 2411.550032]
[ 2411.550347] cpu#17, 2260.998 MHz
[ 2411.550963]   .nr_running                    : 0
[ 2411.551813]   .load                          : 0
[ 2411.552695]   .nr_switches                   : 710
[ 2411.553661]   .nr_load_updates               : 240967
[ 2411.554584]   .nr_uninterruptible            : -1
[ 2411.555442]   .next_balance                  : 4295.178453
[ 2411.556449]   .curr->pid                     : 0
[ 2411.557298]   .clock                         : 2411550.018865
[ 2411.560014]   .cpu_load[0]                   : 0
[ 2411.560837]   .cpu_load[1]                   : 0
[ 2411.561653]   .cpu_load[2]                   : 0
[ 2411.562469]   .cpu_load[3]                   : 0
[ 2411.563354]   .cpu_load[4]                   : 0
[ 2411.564188]   .yld_count                     : 0
[ 2411.565024]   .sched_count                   : 711
[ 2411.565904]   .sched_goidle                  : 346
[ 2411.566785]   .avg_idle                      : 1000000
[ 2411.567728]   .max_idle_balance_cost         : 500000
[ 2411.568635]   .ttwu_count                    : 73
[ 2411.570014]   .ttwu_local                    : 70
[ 2411.570874]
[ 2411.570874] cfs_rq[17]:/
[ 2411.571605]   .exec_clock                    : 91.265376
[ 2411.572684]   .MIN_vruntime                  : 0.000001
[ 2411.573648]   .min_vruntime                  : 97.215760
[ 2411.574616]   .max_vruntime                  : 0.000001
[ 2411.575538]   .spread                        : 0.000000
[ 2411.576547]   .spread0                       : -2387.526980
[ 2411.577511]   .nr_spread_over                : 0
[ 2411.578327]   .nr_running                    : 0
[ 2411.579176]   .load                          : 0
[ 2411.580000]   .runnable_load_avg             : 0
[ 2411.580000]   .blocked_load_avg              : 0
[ 2411.580000]   .tg_load_contrib               : 0
[ 2411.580000]   .tg_runnable_contrib           : 0
[ 2411.580000]   .tg_load_avg                   : 1023
[ 2411.580000]   .tg->runnable_avg              : 1009
[ 2411.580000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.580000]   .throttled                     : 0
[ 2411.580000]   .throttle_count                : 0
[ 2411.580000]   .avg->runnable_avg_sum         : 0
[ 2411.580000]   .avg->runnable_avg_period      : 47452
[ 2411.580000]
[ 2411.580000] rt_rq[17]:/
[ 2411.580000]   .rt_nr_running                 : 0
[ 2411.580000]   .rt_throttled                  : 0
[ 2411.580000]   .rt_time                       : 0.000000
[ 2411.580000]   .rt_runtime                    : 950.000000
[ 2411.580000]
[ 2411.580000] runnable tasks:
[ 2411.580000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.580000] ----------------------------------------------------------------------------------------------------------
[ 2411.580000]    kworker/u64:0     6        97.215760      3540   120        97.215760       843.575325      5932.235098 17 /
[ 2411.580000]      watchdog/17   129       -11.518651        65     0       -11.518651         2.436730         0.000000 17 /
[ 2411.580000]     migration/17   130         0.000000         5     0         0.000000        16.092483         0.000000 17 /
[ 2411.580000]          rcuc/17   131       -12.000000         8    98       -12.000000        17.517316         0.000000 17 /
[ 2411.580000]     ksoftirqd/17   132        31.178874         8   120        31.178874         0.230027      5901.450967 17 /
[ 2411.580000]     kworker/17:0   133        33.485959        11   120        33.485959         6.114499      5936.074079 17 /
[ 2411.580000]    kworker/17:0H   134        -4.620706         5   100        -4.620706         0.095434      4823.417435 17 /
[ 2411.580000]    kworker/u82:0   135        -1.048576         6   120        -1.048576         0.045271      4771.288496 17 /
[ 2411.580000]     kworker/17:1  3277        45.485959         2   120        45.485959         1.343627         0.000000 17 /
[ 2411.610034]
[ 2411.610305] cpu#18, 2260.998 MHz
[ 2411.610857]   .nr_running                    : 0
[ 2411.611643]   .load                          : 0
[ 2411.612437]   .nr_switches                   : 732
[ 2411.620013]   .nr_load_updates               : 240971
[ 2411.620889]   .nr_uninterruptible            : -1
[ 2411.621741]   .next_balance                  : 4295.178462
[ 2411.622693]   .curr->pid                     : 0
[ 2411.623569]   .clock                         : 2411610.021824
[ 2411.624574]   .cpu_load[0]                   : 0
[ 2411.625361]   .cpu_load[1]                   : 0
[ 2411.626158]   .cpu_load[2]                   : 0
[ 2411.626947]   .cpu_load[3]                   : 0
[ 2411.627801]   .cpu_load[4]                   : 0
[ 2411.628603]   .yld_count                     : 0
[ 2411.629388]   .sched_count                   : 733
[ 2411.630012]   .sched_goidle                  : 338
[ 2411.630864]   .avg_idle                      : 1000000
[ 2411.631887]   .max_idle_balance_cost         : 500000
[ 2411.632775]   .ttwu_count                    : 375
[ 2411.633595]   .ttwu_local                    : 124
[ 2411.634420]
[ 2411.634420] cfs_rq[18]:/
[ 2411.635170]   .exec_clock                    : 77.351656
[ 2411.636112]   .MIN_vruntime                  : 0.000001
[ 2411.637019]   .min_vruntime                  : 3073.225679
[ 2411.637977]   .max_vruntime                  : 0.000001
[ 2411.638896]   .spread                        : 0.000000
[ 2411.639892]   .spread0                       : 588.482939
[ 2411.640000]   .nr_spread_over                : 243
[ 2411.640000]   .nr_running                    : 0
[ 2411.640000]   .load                          : 0
[ 2411.640000]   .runnable_load_avg             : 0
[ 2411.640000]   .blocked_load_avg              : 0
[ 2411.640000]   .tg_load_contrib               : 0
[ 2411.640000]   .tg_runnable_contrib           : 0
[ 2411.640000]   .tg_load_avg                   : 1023
[ 2411.640000]   .tg->runnable_avg              : 1009
[ 2411.640000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.640000]   .throttled                     : 0
[ 2411.640000]   .throttle_count                : 0
[ 2411.640000]   .avg->runnable_avg_sum         : 0
[ 2411.640000]   .avg->runnable_avg_period      : 46694
[ 2411.640000]
[ 2411.640000] rt_rq[18]:/
[ 2411.640000]   .rt_nr_running                 : 0
[ 2411.640000]   .rt_throttled                  : 0
[ 2411.640000]   .rt_time                       : 0.000000
[ 2411.640000]   .rt_runtime                    : 950.000000
[ 2411.640000]
[ 2411.640000] runnable tasks:
[ 2411.640000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.640000] ----------------------------------------------------------------------------------------------------------
[ 2411.640000]      watchdog/18   136       -12.000000        64     0       -12.000000        11.992431         0.000000 18 /
[ 2411.640000]     migration/18   137         0.000000         5     0         0.000000        16.184252         0.000000 18 /
[ 2411.640000]          rcuc/18   138       -12.000000        27    98       -12.000000       128.812403         0.000000 18 /
[ 2411.640000]     ksoftirqd/18   139      3061.525143        29   120      3061.525143         1.122667   2275407.751869 18 /
[ 2411.640000]     kworker/18:0   140       729.567180        11   120       729.567180         0.424123      5859.630213 18 /
[ 2411.640000]    kworker/18:0H   141       -11.349839         5   100       -11.349839         0.104914      4782.748107 18 /
[ 2411.640000]    kworker/u83:0   142         0.650161         4   120         0.650161         1.743958      4721.513764 18 /
[ 2411.640000]     kworker/18:1  3245      3064.439771        16   120      3064.439771        10.127414       325.582628 18 /
[ 2411.680031]
[ 2411.680403] cpu#19, 2260.998 MHz
[ 2411.680992]   .nr_running                    : 0
[ 2411.680992]   .load                          : 0
[ 2411.681610]   .nr_switches                   : 221
[ 2411.682421]   .nr_load_updates               : 240971
[ 2411.683315]   .nr_uninterruptible            : -1
[ 2411.684145]   .next_balance                  : 4295.178470
[ 2411.685069]   .curr->pid                     : 0
[ 2411.685854]   .clock                         : 2411680.013661
[ 2411.686823]   .cpu_load[0]                   : 0
[ 2411.687662]   .cpu_load[1]                   : 0
[ 2411.688475]   .cpu_load[2]                   : 0
[ 2411.689295]   .cpu_load[3]                   : 0
[ 2411.690012]   .cpu_load[4]                   : 0
[ 2411.690842]   .yld_count                     : 0
[ 2411.691752]   .sched_count                   : 222
[ 2411.692584]   .sched_goidle                  : 97
[ 2411.693428]   .avg_idle                      : 1000000
[ 2411.694345]   .max_idle_balance_cost         : 500000
[ 2411.695277]   .ttwu_count                    : 102
[ 2411.696126]   .ttwu_local                    : 88
[ 2411.696964]
[ 2411.696964] cfs_rq[19]:/
[ 2411.697687]   .exec_clock                    : 19.133619
[ 2411.698633]   .MIN_vruntime                  : 0.000001
[ 2411.699653]   .min_vruntime                  : 180.863557
[ 2411.700000]   .max_vruntime                  : 0.000001
[ 2411.700000]   .spread                        : 0.000000
[ 2411.700000]   .spread0                       : -2303.879183
[ 2411.700000]   .nr_spread_over                : 8
[ 2411.700000]   .nr_running                    : 0
[ 2411.700000]   .load                          : 0
[ 2411.700000]   .runnable_load_avg             : 0
[ 2411.700000]   .blocked_load_avg              : 0
[ 2411.700000]   .tg_load_contrib               : 0
[ 2411.700000]   .tg_runnable_contrib           : 0
[ 2411.700000]   .tg_load_avg                   : 1023
[ 2411.700000]   .tg->runnable_avg              : 1009
[ 2411.700000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.700000]   .throttled                     : 0
[ 2411.700000]   .throttle_count                : 0
[ 2411.700000]   .avg->runnable_avg_sum         : 0
[ 2411.700000]   .avg->runnable_avg_period      : 47461
[ 2411.700000]
[ 2411.700000] rt_rq[19]:/
[ 2411.700000]   .rt_nr_running                 : 0
[ 2411.700000]   .rt_throttled                  : 0
[ 2411.700000]   .rt_time                       : 0.000000
[ 2411.700000]   .rt_runtime                    : 950.000000
[ 2411.700000]
[ 2411.700000] runnable tasks:
[ 2411.700000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.700000] ----------------------------------------------------------------------------------------------------------
[ 2411.700000]         kthreadd     2        48.518144       242   120        48.518144       125.769163      6896.677497 19 /
[ 2411.700000]      watchdog/19   143       -12.000000        64     0       -12.000000         2.398239         0.000000 19 /
[ 2411.700000]     migration/19   144         0.000000         5     0         0.000000        16.173580         0.000000 19 /
[ 2411.700000]          rcuc/19   145       -11.944377        14    98       -11.944377         6.566131         0.000000 19 /
[ 2411.700000]     ksoftirqd/19   146       169.015485        15   120       169.015485        15.114137      6108.297403 19 /
[ 2411.700000]     kworker/19:0   147        48.464548        11   120        48.464548         0.575558      5912.965409 19 /
[ 2411.700000]    kworker/19:0H   148        -6.980675         5   100        -6.980675         0.111774      4730.245191 19 /
[ 2411.700000]    kworker/u84:0   149        -1.048576         7   120        -1.048576         0.049559      4675.656720 19 /
[ 2411.700000]     kworker/19:1  3318       171.125064         6   120       171.125064         4.514797       216.849937 19 /
[ 2411.740043]
[ 2411.740327] cpu#20, 2260.998 MHz
[ 2411.740920]   .nr_running                    : 0
[ 2411.741764]   .load                          : 0
[ 2411.742567]   .nr_switches                   : 163
[ 2411.743413]   .nr_load_updates               : 240974
[ 2411.744486]   .nr_uninterruptible            : 1
[ 2411.745343]   .next_balance                  : 4295.178473
[ 2411.750013]   .curr->pid                     : 0
[ 2411.750811]   .clock                         : 2411749.560243
[ 2411.751940]   .cpu_load[0]                   : 0
[ 2411.752719]   .cpu_load[1]                   : 0
[ 2411.753525]   .cpu_load[2]                   : 0
[ 2411.754335]   .cpu_load[3]                   : 0
[ 2411.755139]   .cpu_load[4]                   : 0
[ 2411.755997]   .yld_count                     : 0
[ 2411.756864]   .sched_count                   : 164
[ 2411.757687]   .sched_goidle                  : 79
[ 2411.758501]   .avg_idle                      : 1000000
[ 2411.759444]   .max_idle_balance_cost         : 500000
[ 2411.760012]   .ttwu_count                    : 63
[ 2411.760856]   .ttwu_local                    : 62
[ 2411.761707]
[ 2411.761707] cfs_rq[20]:/
[ 2411.762412]   .exec_clock                    : 12.644582
[ 2411.763417]   .MIN_vruntime                  : 0.000001
[ 2411.764306]   .min_vruntime                  : 13.175720
[ 2411.765229]   .max_vruntime                  : 0.000001
[ 2411.766148]   .spread                        : 0.000000
[ 2411.767152]   .spread0                       : -2471.567020
[ 2411.768134]   .nr_spread_over                : 0
[ 2411.768960]   .nr_running                    : 0
[ 2411.769842]   .load                          : 0
[ 2411.770000]   .runnable_load_avg             : 0
[ 2411.770000]   .blocked_load_avg              : 0
[ 2411.770000]   .tg_load_contrib               : 0
[ 2411.770000]   .tg_runnable_contrib           : 0
[ 2411.770000]   .tg_load_avg                   : 1023
[ 2411.770000]   .tg->runnable_avg              : 1009
[ 2411.770000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.770000]   .throttled                     : 0
[ 2411.770000]   .throttle_count                : 0
[ 2411.770000]   .avg->runnable_avg_sum         : 0
[ 2411.770000]   .avg->runnable_avg_period      : 46910
[ 2411.770000]
[ 2411.770000] rt_rq[20]:/
[ 2411.770000]   .rt_nr_running                 : 0
[ 2411.770000]   .rt_throttled                  : 0
[ 2411.770000]   .rt_time                       : 0.000000
[ 2411.770000]   .rt_runtime                    : 950.000000
[ 2411.770000]
[ 2411.770000] runnable tasks:
[ 2411.770000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.770000] ----------------------------------------------------------------------------------------------------------
[ 2411.770000]      watchdog/20   150       -12.000000        64     0       -12.000000        82.473639         0.000000 20 /
[ 2411.770000]     migration/20   151         0.000000         5     0         0.000000        16.225450         0.000000 20 /
[ 2411.770000]          rcuc/20   152       -12.000000         4    98       -12.000000         0.120716         0.000000 20 /
[ 2411.770000]     ksoftirqd/20   153        11.166292         6   120        11.166292        10.485492   1877559.948030 20 /
[ 2411.770000]     kworker/20:0   154       -11.851169         9   120       -11.851169         0.105636      4689.053268 20 /
[ 2411.770000]    kworker/20:0H   155        -3.900855         5   100        -3.900855         0.048525      4684.800721 20 /
[ 2411.770000]    kworker/u85:0   156        -1.048576         7   120        -1.048576         0.042451      4632.778534 20 /
[ 2411.800029]
[ 2411.800419] cpu#21, 2260.998 MHz
[ 2411.801049]   .nr_running                    : 0
[ 2411.801836]   .load                          : 0
[ 2411.802668]   .nr_switches                   : 159
[ 2411.803487]   .nr_load_updates               : 240976
[ 2411.804417]   .nr_uninterruptible            : 0
[ 2411.810013]   .next_balance                  : 4295.178481
[ 2411.810952]   .curr->pid                     : 0
[ 2411.811813]   .clock                         : 2411800.009585
[ 2411.812969]   .cpu_load[0]                   : 0
[ 2411.813829]   .cpu_load[1]                   : 0
[ 2411.814649]   .cpu_load[2]                   : 0
[ 2411.815579]   .cpu_load[3]                   : 0
[ 2411.816798]   .cpu_load[4]                   : 0
[ 2411.818014]   .yld_count                     : 0
[ 2411.818844]   .sched_count                   : 160
[ 2411.820017]   .sched_goidle                  : 77
[ 2411.820893]   .avg_idle                      : 1000000
[ 2411.821856]   .max_idle_balance_cost         : 500000
[ 2411.822845]   .ttwu_count                    : 61
[ 2411.823716]   .ttwu_local                    : 61
[ 2411.824780]
[ 2411.824780] cfs_rq[21]:/
[ 2411.825661]   .exec_clock                    : 3.631724
[ 2411.826674]   .MIN_vruntime                  : 0.000001
[ 2411.827690]   .min_vruntime                  : 1.962051
[ 2411.828595]   .max_vruntime                  : 0.000001
[ 2411.829569]   .spread                        : 0.000000
[ 2411.830000]   .spread0                       : -2482.780689
[ 2411.830000]   .nr_spread_over                : 0
[ 2411.830000]   .nr_running                    : 0
[ 2411.830000]   .load                          : 0
[ 2411.830000]   .runnable_load_avg             : 0
[ 2411.830000]   .blocked_load_avg              : 0
[ 2411.830000]   .tg_load_contrib               : 0
[ 2411.830000]   .tg_runnable_contrib           : 0
[ 2411.830000]   .tg_load_avg                   : 1023
[ 2411.830000]   .tg->runnable_avg              : 1009
[ 2411.830000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.830000]   .throttled                     : 0
[ 2411.830000]   .throttle_count                : 0
[ 2411.830000]   .avg->runnable_avg_sum         : 0
[ 2411.830000]   .avg->runnable_avg_period      : 46745
[ 2411.830000]
[ 2411.830000] rt_rq[21]:/
[ 2411.830000]   .rt_nr_running                 : 0
[ 2411.830000]   .rt_throttled                  : 0
[ 2411.830000]   .rt_time                       : 0.000000
[ 2411.830000]   .rt_runtime                    : 950.000000
[ 2411.830000]
[ 2411.830000] runnable tasks:
[ 2411.830000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.830000] ----------------------------------------------------------------------------------------------------------
[ 2411.830000]      watchdog/21   157       -11.378903        64     0       -11.378903         2.386230         0.000000 21 /
[ 2411.830000]     migration/21   158         0.000000         5     0         0.000000        16.063164         0.000000 21 /
[ 2411.830000]          rcuc/21   159       -12.000000         4    98       -12.000000         0.094952         0.000000 21 /
[ 2411.830000]     ksoftirqd/21   160       -10.037949         5   120       -10.037949         0.085091    495489.614974 21 /
[ 2411.830000]     kworker/21:0   161       -10.037949         9   120       -10.037949         0.080989      4649.873541 21 /
[ 2411.830000]    kworker/21:0H   162        -8.121673         5   100        -8.121673         0.107345      4642.094736 21 /
[ 2411.830000]    kworker/u86:0   163         1.962051         7   120         1.962051         3.054566      4583.967753 21 /
[ 2411.860034]
[ 2411.860340] cpu#22, 2260.998 MHz
[ 2411.860930]   .nr_running                    : 0
[ 2411.861763]   .load                          : 0
[ 2411.870013]   .nr_switches                   : 242
[ 2411.870831]   .nr_load_updates               : 240977
[ 2411.871865]   .nr_uninterruptible            : 0
[ 2411.872654]   .next_balance                  : 4295.178487
[ 2411.873614]   .curr->pid                     : 0
[ 2411.874399]   .clock                         : 2411870.009502
[ 2411.875449]   .cpu_load[0]                   : 0
[ 2411.876264]   .cpu_load[1]                   : 0
[ 2411.877057]   .cpu_load[2]                   : 0
[ 2411.877859]   .cpu_load[3]                   : 0
[ 2411.878687]   .cpu_load[4]                   : 0
[ 2411.879534]   .yld_count                     : 0
[ 2411.880013]   .sched_count                   : 243
[ 2411.880843]   .sched_goidle                  : 112
[ 2411.881653]   .avg_idle                      : 1000000
[ 2411.882528]   .max_idle_balance_cost         : 500000
[ 2411.883478]   .ttwu_count                    : 86
[ 2411.884276]   .ttwu_local                    : 80
[ 2411.885100]
[ 2411.885100] cfs_rq[22]:/
[ 2411.885805]   .exec_clock                    : 6.077984
[ 2411.886706]   .MIN_vruntime                  : 0.000001
[ 2411.887660]   .min_vruntime                  : 87.084578
[ 2411.888616]   .max_vruntime                  : 0.000001
[ 2411.889522]   .spread                        : 0.000000
[ 2411.890000]   .spread0                       : -2397.658162
[ 2411.890000]   .nr_spread_over                : 2
[ 2411.890000]   .nr_running                    : 0
[ 2411.890000]   .load                          : 0
[ 2411.890000]   .runnable_load_avg             : 0
[ 2411.890000]   .blocked_load_avg              : 0
[ 2411.890000]   .tg_load_contrib               : 0
[ 2411.890000]   .tg_runnable_contrib           : 0
[ 2411.890000]   .tg_load_avg                   : 1023
[ 2411.890000]   .tg->runnable_avg              : 1009
[ 2411.890000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.890000]   .throttled                     : 0
[ 2411.890000]   .throttle_count                : 0
[ 2411.890000]   .avg->runnable_avg_sum         : 0
[ 2411.890000]   .avg->runnable_avg_period      : 47505
[ 2411.890000]
[ 2411.890000] rt_rq[22]:/
[ 2411.890000]   .rt_nr_running                 : 0
[ 2411.890000]   .rt_throttled                  : 0
[ 2411.890000]   .rt_time                       : 0.000000
[ 2411.890000]   .rt_runtime                    : 950.000000
[ 2411.890000]
[ 2411.890000] runnable tasks:
[ 2411.890000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.890000] ----------------------------------------------------------------------------------------------------------
[ 2411.890000]      watchdog/22   164       -11.536479        64     0       -11.536479         2.263761         0.000000 22 /
[ 2411.890000]     migration/22   165         0.000000         5     0         0.000000        16.268275         0.000000 22 /
[ 2411.890000]          rcuc/22   166       -12.000000        14    98       -12.000000        10.039553         0.000000 22 /
[ 2411.890000]     ksoftirqd/22   167        75.188880        14   120        75.188880         1.437150      4948.083882 22 /
[ 2411.890000]     kworker/22:0   168       -13.048576         9   120       -13.048576         0.081248      4610.447227 22 /
[ 2411.890000]    kworker/22:0H   169        -5.403577         5   100        -5.403577         0.082830      4602.415494 22 /
[ 2411.890000]    kworker/u87:0   170        -1.048576         7   120        -1.048576         0.047058      4549.881639 22 /
[ 2411.920079]
[ 2411.920366] cpu#23, 2260.998 MHz
[ 2411.920929]   .nr_running                    : 0
[ 2411.921724]   .load                          : 0
[ 2411.930013]   .nr_switches                   : 275
[ 2411.930840]   .nr_load_updates               : 240977
[ 2411.931869]   .nr_uninterruptible            : 0
[ 2411.932719]   .next_balance                  : 4295.178491
[ 2411.933691]   .curr->pid                     : 0
[ 2411.934511]   .clock                         : 2411930.021675
[ 2411.935560]   .cpu_load[0]                   : 0
[ 2411.936376]   .cpu_load[1]                   : 0
[ 2411.937184]   .cpu_load[2]                   : 0
[ 2411.938005]   .cpu_load[3]                   : 0
[ 2411.938809]   .cpu_load[4]                   : 0
[ 2411.939663]   .yld_count                     : 0
[ 2411.940014]   .sched_count                   : 276
[ 2411.940839]   .sched_goidle                  : 129
[ 2411.941698]   .avg_idle                      : 1000000
[ 2411.942584]   .max_idle_balance_cost         : 500000
[ 2411.943579]   .ttwu_count                    : 102
[ 2411.944442]   .ttwu_local                    : 76
[ 2411.945293]
[ 2411.945293] cfs_rq[23]:/
[ 2411.946030]   .exec_clock                    : 20.510508
[ 2411.946969]   .MIN_vruntime                  : 0.000001
[ 2411.947986]   .min_vruntime                  : 331.332068
[ 2411.949024]   .max_vruntime                  : 0.000001
[ 2411.949934]   .spread                        : 0.000000
[ 2411.950000]   .spread0                       : -2153.410672
[ 2411.950000]   .nr_spread_over                : 19
[ 2411.950000]   .nr_running                    : 0
[ 2411.950000]   .load                          : 0
[ 2411.950000]   .runnable_load_avg             : 0
[ 2411.950000]   .blocked_load_avg              : 0
[ 2411.950000]   .tg_load_contrib               : 0
[ 2411.950000]   .tg_runnable_contrib           : 0
[ 2411.950000]   .tg_load_avg                   : 1023
[ 2411.950000]   .tg->runnable_avg              : 1009
[ 2411.950000]   .tg->cfs_bandwidth.timer_active: 0
[ 2411.950000]   .throttled                     : 0
[ 2411.950000]   .throttle_count                : 0
[ 2411.950000]   .avg->runnable_avg_sum         : 0
[ 2411.950000]   .avg->runnable_avg_period      : 47628
[ 2411.950000]
[ 2411.950000] rt_rq[23]:/
[ 2411.950000]   .rt_nr_running                 : 0
[ 2411.950000]   .rt_throttled                  : 0
[ 2411.950000]   .rt_time                       : 0.000000
[ 2411.950000]   .rt_runtime                    : 950.000000
[ 2411.950000]
[ 2411.950000] runnable tasks:
[ 2411.950000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2411.950000] ----------------------------------------------------------------------------------------------------------
[ 2411.950000]      watchdog/23   171       -11.198058        65     0       -11.198058         2.772217         0.000000 23 /
[ 2411.950000]     migration/23   172         0.000000         5     0         0.000000        16.432340         0.000000 23 /
[ 2411.950000]          rcuc/23   173       -12.000000        12    98       -12.000000        17.496876         0.000000 23 /
[ 2411.950000]     ksoftirqd/23   174       319.511310        12   120       319.511310         0.458300      4919.009853 23 /
[ 2411.950000]     kworker/23:0   175       -13.030928         9   120       -13.030928         0.097602      4569.101631 23 /
[ 2411.950000]    kworker/23:0H   176        -6.129640         5   100        -6.129640         0.100730      4561.813677 23 /
[ 2411.950000]    kworker/u88:0   177        -1.048576         6   120        -1.048576         0.036926      4509.572952 23 /
[ 2411.990035]
[ 2411.990331] cpu#24, 2260.998 MHz
[ 2411.990944]   .nr_running                    : 0
[ 2411.990944]   .load                          : 0
[ 2411.991772]   .nr_switches                   : 443
[ 2411.992657]   .nr_load_updates               : 240982
[ 2411.993550]   .nr_uninterruptible            : 0
[ 2411.994361]   .next_balance                  : 4295.178495
[ 2411.995431]   .curr->pid                     : 0
[ 2411.996309]   .clock                         : 2411990.029430
[ 2411.997511]   .cpu_load[0]                   : 0
[ 2411.998399]   .cpu_load[1]                   : 0
[ 2411.999305]   .cpu_load[2]                   : 0
[ 2412.000013]   .cpu_load[3]                   : 0
[ 2412.000869]   .cpu_load[4]                   : 0
[ 2412.001715]   .yld_count                     : 0
[ 2412.002554]   .sched_count                   : 500
[ 2412.003538]   .sched_goidle                  : 173
[ 2412.004476]   .avg_idle                      : 1000000
[ 2412.005373]   .max_idle_balance_cost         : 500000
[ 2412.006291]   .ttwu_count                    : 3421
[ 2412.007216]   .ttwu_local                    : 168
[ 2412.008081]
[ 2412.008081] cfs_rq[24]:/
[ 2412.008823]   .exec_clock                    : 4131.913349
[ 2412.009816]   .MIN_vruntime                  : 0.000001
[ 2412.010000]   .min_vruntime                  : 4303.384719
[ 2412.010000]   .max_vruntime                  : 0.000001
[ 2412.010000]   .spread                        : 0.000000
[ 2412.010000]   .spread0                       : 1818.641979
[ 2412.010000]   .nr_spread_over                : 17
[ 2412.010000]   .nr_running                    : 0
[ 2412.010000]   .load                          : 0
[ 2412.010000]   .runnable_load_avg             : 0
[ 2412.010000]   .blocked_load_avg              : 0
[ 2412.010000]   .tg_load_contrib               : 0
[ 2412.010000]   .tg_runnable_contrib           : 0
[ 2412.010000]   .tg_load_avg                   : 1023
[ 2412.010000]   .tg->runnable_avg              : 1009
[ 2412.010000]   .tg->cfs_bandwidth.timer_active: 0
[ 2412.010000]   .throttled                     : 0
[ 2412.010000]   .throttle_count                : 0
[ 2412.010000]   .avg->runnable_avg_sum         : 0
[ 2412.010000]   .avg->runnable_avg_period      : 47012
[ 2412.010000]
[ 2412.010000] rt_rq[24]:/
[ 2412.010000]   .rt_nr_running                 : 0
[ 2412.010000]   .rt_throttled                  : 0
[ 2412.010000]   .rt_time                       : 0.000000
[ 2412.010000]   .rt_runtime                    : 950.000000
[ 2412.010000]
[ 2412.010000] runnable tasks:
[ 2412.010000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2412.010000] ----------------------------------------------------------------------------------------------------------
[ 2412.010000]        swapper/0     1      4303.384719       541   120      4303.384719      5126.527672      2107.219371 0 /
[ 2412.010000]      watchdog/24   178       -12.000000        64     0       -12.000000         1.917278         0.000000 0 /
[ 2412.010000]     migration/24   179         0.000000         5     0         0.000000        16.286308         0.000000 0 /
[ 2412.010000]          rcuc/24   180       -12.000000        37    98       -12.000000        45.956270         0.000000 0 /
[ 2412.010000]     ksoftirqd/24   181      4291.420854        38   120      4291.420854         1.164877   2377737.120946 0 /
[ 2412.010000]     kworker/24:0   182      3907.145354        10   120      3907.145354         1.276275      4511.993072 0 /
[ 2412.010000]    kworker/24:0H   183      3927.301167         5   100      3927.301167         0.052721      4525.574701 0 /
[ 2412.010000]     kworker/24:1  2475      4136.495399         4   120      4136.495399         0.845448       366.741280 0 /
[ 2412.050030]
[ 2412.050358] cpu#25, 2260.998 MHz
[ 2412.050998]   .nr_running                    : 0
[ 2412.051970]   .load                          : 0
[ 2412.052923]   .nr_switches                   : 3171
[ 2412.053835]   .nr_load_updates               : 240986
[ 2412.060014]   .nr_uninterruptible            : -1
[ 2412.060843]   .next_balance                  : 4295.178502
[ 2412.061852]   .curr->pid                     : 0
[ 2412.062682]   .clock                         : 2412050.025132
[ 2412.063968]   .cpu_load[0]                   : 0
[ 2412.064820]   .cpu_load[1]                   : 0
[ 2412.065642]   .cpu_load[2]                   : 0
[ 2412.066536]   .cpu_load[3]                   : 0
[ 2412.067715]   .cpu_load[4]                   : 0
[ 2412.068695]   .yld_count                     : 0
[ 2412.070012]   .sched_count                   : 3172
[ 2412.070865]   .sched_goidle                  : 1442
[ 2412.071776]   .avg_idle                      : 1000000
[ 2412.072751]   .max_idle_balance_cost         : 500000
[ 2412.073656]   .ttwu_count                    : 265
[ 2412.074485]   .ttwu_local                    : 134
[ 2412.075361]
[ 2412.075361] cfs_rq[25]:/
[ 2412.076187]   .exec_clock                    : 111.820844
[ 2412.077277]   .MIN_vruntime                  : 0.000001
[ 2412.078248]   .min_vruntime                  : 1600.942105
[ 2412.079242]   .max_vruntime                  : 0.000001
[ 2412.080000]   .spread                        : 0.000000
[ 2412.080000]   .spread0                       : -883.800635
[ 2412.080000]   .nr_spread_over                : 123
[ 2412.080000]   .nr_running                    : 0
[ 2412.080000]   .load                          : 0
[ 2412.080000]   .runnable_load_avg             : 0
[ 2412.080000]   .blocked_load_avg              : 0
[ 2412.080000]   .tg_load_contrib               : 0
[ 2412.080000]   .tg_runnable_contrib           : 0
[ 2412.080000]   .tg_load_avg                   : 1023
[ 2412.080000]   .tg->runnable_avg              : 1009
[ 2412.080000]   .tg->cfs_bandwidth.timer_active: 0
[ 2412.080000]   .throttled                     : 0
[ 2412.080000]   .throttle_count                : 0
[ 2412.080000]   .avg->runnable_avg_sum         : 0
[ 2412.080000]   .avg->runnable_avg_period      : 47222
[ 2412.080000]
[ 2412.080000] rt_rq[25]:/
[ 2412.080000]   .rt_nr_running                 : 0
[ 2412.080000]   .rt_throttled                  : 0
[ 2412.080000]   .rt_time                       : 0.000000
[ 2412.080000]   .rt_runtime                    : 950.000000
[ 2412.080000]
[ 2412.080000] runnable tasks:
[ 2412.080000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2412.080000] ----------------------------------------------------------------------------------------------------------
[ 2412.080000]      watchdog/25   184       -12.000000        64     0       -12.000000         1.898364         0.000000 1 /
[ 2412.080000]     migration/25   185         0.000000         5     0         0.000000        16.168735         0.000000 1 /
[ 2412.080000]          rcuc/25   186       -12.000000        38    98       -12.000000       149.551381         0.000000 1 /
[ 2412.080000]     ksoftirqd/25   187      1596.642255        41   120      1596.642255         8.696743   2216200.682831 1 /
[ 2412.080000]     kworker/25:0   188      1196.370012         8   120      1196.370012         0.441629      2437.836934 1 /
[ 2412.080000]    kworker/25:0H   189      1196.017003         5   100      1196.017003         0.082483      4494.807694 1 /
[ 2412.080000]        kdevtmpfs   215         7.201179         2   120         7.201179         0.249757        12.319502 1 /
[ 2412.080000]             perf   219        31.201167         2   100        31.201167         0.000000         0.000000 1 /
[ 2412.080000]     kworker/25:1  1172      1589.978135         6   120      1589.978135         1.036030      2640.976484 1 /
[ 2412.120029]
[ 2412.120304] cpu#26, 2260.998 MHz
[ 2412.120867]   .nr_running                    : 0
[ 2412.121657]   .load                          : 0
[ 2412.122619]   .nr_switches                   : 565
[ 2412.123656]   .nr_load_updates               : 240985
[ 2412.124566]   .nr_uninterruptible            : -1
[ 2412.130013]   .next_balance                  : 4295.178507
[ 2412.131054]   .curr->pid                     : 0
[ 2412.131963]   .clock                         : 2412130.037130
[ 2412.132947]   .cpu_load[0]                   : 0
[ 2412.133777]   .cpu_load[1]                   : 0
[ 2412.134599]   .cpu_load[2]                   : 0
[ 2412.135596]   .cpu_load[3]                   : 0
[ 2412.136477]   .cpu_load[4]                   : 0
[ 2412.137324]   .yld_count                     : 0
[ 2412.138166]   .sched_count                   : 565
[ 2412.139098]   .sched_goidle                  : 261
[ 2412.140016]   .avg_idle                      : 1000000
[ 2412.141016]   .max_idle_balance_cost         : 500000
[ 2412.141958]   .ttwu_count                    : 184
[ 2412.142844]   .ttwu_local                    : 121
[ 2412.143823]
[ 2412.143823] cfs_rq[26]:/
[ 2412.144574]   .exec_clock                    : 137.683902
[ 2412.145555]   .MIN_vruntime                  : 0.000001
[ 2412.146514]   .min_vruntime                  : 808.654579
[ 2412.147609]   .max_vruntime                  : 0.000001
[ 2412.148594]   .spread                        : 0.000000
[ 2412.149581]   .spread0                       : -1676.088161
[ 2412.150000]   .nr_spread_over                : 56
[ 2412.150000]   .nr_running                    : 0
[ 2412.150000]   .load                          : 0
[ 2412.150000]   .runnable_load_avg             : 0
[ 2412.150000]   .blocked_load_avg              : 0
[ 2412.150000]   .tg_load_contrib               : 0
[ 2412.150000]   .tg_runnable_contrib           : 0
[ 2412.150000]   .tg_load_avg                   : 1023
[ 2412.150000]   .tg->runnable_avg              : 1009
[ 2412.150000]   .tg->cfs_bandwidth.timer_active: 0
[ 2412.150000]   .throttled                     : 0
[ 2412.150000]   .throttle_count                : 0
[ 2412.150000]   .avg->runnable_avg_sum         : 0
[ 2412.150000]   .avg->runnable_avg_period      : 47588
[ 2412.150000]
[ 2412.150000] rt_rq[26]:/
[ 2412.150000]   .rt_nr_running                 : 0
[ 2412.150000]   .rt_throttled                  : 0
[ 2412.150000]   .rt_time                       : 0.000000
[ 2412.150000]   .rt_runtime                    : 950.000000
[ 2412.150000]
[ 2412.150000] runnable tasks:
[ 2412.150000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2412.150000] ----------------------------------------------------------------------------------------------------------
[ 2412.150000]      watchdog/26   190       -11.864519        65     0       -11.864519        12.365491         0.000000 2 /
[ 2412.150000]     migration/26   191         0.000000         5     0         0.000000        16.164895         0.000000 2 /
[ 2412.150000]          rcuc/26   192       -12.000000        32    98       -12.000000        64.230919         0.000000 2 /
[ 2412.150000]     ksoftirqd/26   193       804.446527        35   120       804.446527        10.523041   2323932.436893 2 /
[ 2412.150000]     kworker/26:0   194       705.297725        11   120       705.297725         1.462378      4847.815252 2 /
[ 2412.150000]    kworker/26:0H   195       462.641141         5   100       462.641141         0.087373      4454.099978 2 /
[ 2412.150000]     kworker/26:1  2795       715.927119         2   120       715.927119         0.025664         0.000000 2 /
[ 2412.180036]
[ 2412.180386] cpu#27, 2260.998 MHz
[ 2412.180970]   .nr_running                    : 0
[ 2412.181822]   .load                          : 0
[ 2412.182660]   .nr_switches                   : 1102
[ 2412.190015]   .nr_load_updates               : 240988
[ 2412.191021]   .nr_uninterruptible            : -1
[ 2412.191871]   .next_balance                  : 4295.178515
[ 2412.192837]   .curr->pid                     : 0
[ 2412.193696]   .clock                         : 2412180.024743
[ 2412.194789]   .cpu_load[0]                   : 0
[ 2412.195600]   .cpu_load[1]                   : 0
[ 2412.196447]   .cpu_load[2]                   : 0
[ 2412.197262]   .cpu_load[3]                   : 0
[ 2412.198097]   .cpu_load[4]                   : 0
[ 2412.198976]   .yld_count                     : 0
[ 2412.200013]   .sched_count                   : 1102
[ 2412.200838]   .sched_goidle                  : 526
[ 2412.201645]   .avg_idle                      : 1000000
[ 2412.202519]   .max_idle_balance_cost         : 500000
[ 2412.203489]   .ttwu_count                    : 544
[ 2412.204315]   .ttwu_local                    : 134
[ 2412.205142]
[ 2412.205142] cfs_rq[27]:/
[ 2412.205847]   .exec_clock                    : 382.675370
[ 2412.206762]   .MIN_vruntime                  : 0.000001
[ 2412.207765]   .min_vruntime                  : 5285.109584
[ 2412.208749]   .max_vruntime                  : 0.000001
[ 2412.209651]   .spread                        : 0.000000
[ 2412.210000]   .spread0                       : 2800.366844
[ 2412.210000]   .nr_spread_over                : 404
[ 2412.210000]   .nr_running                    : 0
[ 2412.210000]   .load                          : 0
[ 2412.210000]   .runnable_load_avg             : 0
[ 2412.210000]   .blocked_load_avg              : 0
[ 2412.210000]   .tg_load_contrib               : 0
[ 2412.210000]   .tg_runnable_contrib           : 0
[ 2412.210000]   .tg_load_avg                   : 1023
[ 2412.210000]   .tg->runnable_avg              : 1009
[ 2412.210000]   .tg->cfs_bandwidth.timer_active: 0
[ 2412.210000]   .throttled                     : 0
[ 2412.210000]   .throttle_count                : 0
[ 2412.210000]   .avg->runnable_avg_sum         : 0
[ 2412.210000]   .avg->runnable_avg_period      : 47017
[ 2412.210000]
[ 2412.210000] rt_rq[27]:/
[ 2412.210000]   .rt_nr_running                 : 0
[ 2412.210000]   .rt_throttled                  : 0
[ 2412.210000]   .rt_time                       : 0.000000
[ 2412.210000]   .rt_runtime                    : 950.000000
[ 2412.210000]
[ 2412.210000] runnable tasks:
[ 2412.210000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2412.210000] ----------------------------------------------------------------------------------------------------------
[ 2412.210000]      watchdog/27   196       -11.922392        65     0       -11.922392        22.247260         0.000000 3 /
[ 2412.210000]     migration/27   197         0.000000         5     0         0.000000        16.016492         0.000000 3 /
[ 2412.210000]          rcuc/27   198       -12.000000        36    98       -12.000000       190.480081         0.000000 3 /
[ 2412.210000]     ksoftirqd/27   199      5274.203820        38   120      5274.203820         2.037006   2216070.714578 3 /
[ 2412.210000]     kworker/27:0   200      1685.190637         8   120      1685.190637         0.684364      1455.525449 3 /
[ 2412.210000]    kworker/27:0H   201      4901.847525         5   100      4901.847525         0.089833      4414.484245 3 /
[ 2412.210000]     kworker/27:1   574      5001.590539         9   120      5001.590539         5.855957      3359.598417 3 /
[ 2412.240030]
[ 2412.240340] cpu#28, 2260.998 MHz
[ 2412.240962]   .nr_running                    : 0
[ 2412.241830]   .load                          : 0
[ 2412.250015]   .nr_switches                   : 430
[ 2412.250916]   .nr_load_updates               : 240993
[ 2412.251891]   .nr_uninterruptible            : 0
[ 2412.252703]   .next_balance                  : 4295.178522
[ 2412.253669]   .curr->pid                     : 0
[ 2412.254468]   .clock                         : 2412240.038130
[ 2412.255567]   .cpu_load[0]                   : 0
[ 2412.256389]   .cpu_load[1]                   : 0
[ 2412.257212]   .cpu_load[2]                   : 0
[ 2412.258031]   .cpu_load[3]                   : 0
[ 2412.258825]   .cpu_load[4]                   : 0
[ 2412.259734]   .yld_count                     : 0
[ 2412.260848]   .sched_count                   : 430
[ 2412.261675]   .sched_goidle                  : 194
[ 2412.262492]   .avg_idle                      : 1000000
[ 2412.263394]   .max_idle_balance_cost         : 500000
[ 2412.264259]   .ttwu_count                    : 203
[ 2412.265074]   .ttwu_local                    : 116
[ 2412.265903]
[ 2412.265903] cfs_rq[28]:/
[ 2412.266664]   .exec_clock                    : 85.097840
[ 2412.267722]   .MIN_vruntime                  : 0.000001
[ 2412.268662]   .min_vruntime                  : 1120.669000
[ 2412.269635]   .max_vruntime                  : 0.000001
[ 2412.270000]   .spread                        : 0.000000
[ 2412.270000]   .spread0                       : -1364.073740
[ 2412.270000]   .nr_spread_over                : 81
[ 2412.270000]   .nr_running                    : 0
[ 2412.270000]   .load                          : 0
[ 2412.270000]   .runnable_load_avg             : 0
[ 2412.270000]   .blocked_load_avg              : 0
[ 2412.270000]   .tg_load_contrib               : 0
[ 2412.270000]   .tg_runnable_contrib           : 0
[ 2412.270000]   .tg_load_avg                   : 1023
[ 2412.270000]   .tg->runnable_avg              : 1009
[ 2412.270000]   .tg->cfs_bandwidth.timer_active: 0
[ 2412.270000]   .throttled                     : 0
[ 2412.270000]   .throttle_count                : 0
[ 2412.270000]   .avg->runnable_avg_sum         : 0
[ 2412.270000]   .avg->runnable_avg_period      : 46859
[ 2412.270000]
[ 2412.270000] rt_rq[28]:/
[ 2412.270000]   .rt_nr_running                 : 0
[ 2412.270000]   .rt_throttled                  : 0
[ 2412.270000]   .rt_time                       : 0.000000
[ 2412.270000]   .rt_runtime                    : 950.000000
[ 2412.270000]
[ 2412.270000] runnable tasks:
[ 2412.270000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2412.270000] ----------------------------------------------------------------------------------------------------------
[ 2412.270000]      watchdog/28   202       -12.000000        64     0       -12.000000         2.170262         0.000000 4 /
[ 2412.270000]     migration/28   203         0.000000         5     0         0.000000        16.101280         0.000000 4 /
[ 2412.270000]          rcuc/28   204       -12.000000        30    98       -12.000000        72.999615         0.000000 4 /
[ 2412.270000]     ksoftirqd/28   205      1108.844530        30   120      1108.844530         6.701470      5028.545978 4 /
[ 2412.270000]     kworker/28:0   206       344.384217         8   120       344.384217         3.168883      1656.054851 4 /
[ 2412.270000]    kworker/28:0H   207       637.749102         5   100       637.749102         0.067481      4375.741723 4 /
[ 2412.270000]     kworker/28:1   756      1109.768610         5   120      1109.768610         1.866706      3409.882713 4 /
[ 2412.300028]
[ 2412.300310] cpu#29, 2260.998 MHz
[ 2412.300891]   .nr_running                    : 0
[ 2412.301684]   .load                          : 0
[ 2412.310012]   .nr_switches                   : 4541
[ 2412.310949]   .nr_load_updates               : 240993
[ 2412.311854]   .nr_uninterruptible            : -1
[ 2412.312679]   .next_balance                  : 4295.178529
[ 2412.313631]   .curr->pid                     : 0
[ 2412.314436]   .clock                         : 2412310.033702
[ 2412.315509]   .cpu_load[0]                   : 0
[ 2412.316314]   .cpu_load[1]                   : 0
[ 2412.317132]   .cpu_load[2]                   : 0
[ 2412.317952]   .cpu_load[3]                   : 0
[ 2412.318809]   .cpu_load[4]                   : 0
[ 2412.320013]   .yld_count                     : 0
[ 2412.320817]   .sched_count                   : 4541
[ 2412.321701]   .sched_goidle                  : 1936
[ 2412.322568]   .avg_idle                      : 1000000
[ 2412.323520]   .max_idle_balance_cost         : 500000
[ 2412.324419]   .ttwu_count                    : 152
[ 2412.325261]   .ttwu_local                    : 140
[ 2412.326108]
[ 2412.326108] cfs_rq[29]:/
[ 2412.326819]   .exec_clock                    : 580.424463
[ 2412.327895]   .MIN_vruntime                  : 0.000001
[ 2412.328876]   .min_vruntime                  : 716.861353
[ 2412.329833]   .max_vruntime                  : 0.000001
[ 2412.330000]   .spread                        : 0.000000
[ 2412.330000]   .spread0                       : -1767.881387
[ 2412.330000]   .nr_spread_over                : 19
[ 2412.330000]   .nr_running                    : 0
[ 2412.330000]   .load                          : 0
[ 2412.330000]   .runnable_load_avg             : 0
[ 2412.330000]   .blocked_load_avg              : 0
[ 2412.330000]   .tg_load_contrib               : 0
[ 2412.330000]   .tg_runnable_contrib           : 0
[ 2412.330000]   .tg_load_avg                   : 1023
[ 2412.330000]   .tg->runnable_avg              : 1009
[ 2412.330000]   .tg->cfs_bandwidth.timer_active: 0
[ 2412.330000]   .throttled                     : 0
[ 2412.330000]   .throttle_count                : 0
[ 2412.330000]   .avg->runnable_avg_sum         : 0
[ 2412.330000]   .avg->runnable_avg_period      : 47258
[ 2412.330000]
[ 2412.330000] rt_rq[29]:/
[ 2412.330000]   .rt_nr_running                 : 0
[ 2412.330000]   .rt_throttled                  : 0
[ 2412.330000]   .rt_time                       : 0.000000
[ 2412.330000]   .rt_runtime                    : 950.000000
[ 2412.330000]
[ 2412.330000] runnable tasks:
[ 2412.330000]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 2412.330000] ----------------------------------------------------------------------------------------------------------
[ 2412.330000]      watchdog/29   208       -11.742339        64     0       -11.742339        82.140280         0.000000 5 /
[ 2412.330000]     migration/29   209         0.000000         5     0         0.000000        16.141815         0.000000 5 /
[ 2412.330000]          rcuc/29   210       -11.960757        35    98       -11.960757       141.057461         0.000000 5 /
[ 2412.330000]     ksoftirqd/29   211       705.253251        37   120       705.253251         1.283877   1014057.356237 5 /
[ 2412.330000]     kworker/29:0   212       443.422252         8   120       443.422252         0.754835      4016.607290 5 /
[ 2412.330000]    kworker/29:0H   213       495.418950         5   100       495.418950         0.110017      4333.766632 5 /
[ 2412.330000]     kworker/29:1  2253       705.736406         6   120       705.736406         0.894810      1038.078861 5 /
[ 2412.360029]
[ 2412.360320]
[ 2412.360320] Showing all locks held in the system:
[ 2412.370206] 2 locks held by khungtaskd/2449:
[ 2412.370959] #0: (rcu_read_lock){......}, at: watchdog ()
[ 2412.372556] #1: (tasklist_lock){.+.+..}, at: debug_show_all_locks ()
[ 2412.374323]
[ 2412.374608] =============================================


Thanks,
Sasha
