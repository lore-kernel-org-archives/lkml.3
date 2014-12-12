Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174AbaLLEp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 23:45:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933358AbaLLEpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 23:45:54 -0500
Date: Thu, 11 Dec 2014 23:45:09 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141212044509.GA21145@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1417540493.21136.3@mail.thefacebook.com>
 <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212030343.GA7945@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212030343.GA7945@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 10:03:43PM -0500, Dave Jones wrote:
 > On Thu, Dec 11, 2014 at 01:49:17PM -0800, Linus Torvalds wrote:
 >  
 >  > Anyway, you might as well stop bisecting. Regardless of where it lands
 >  > in the remaining pile, it's not going to give us any useful
 >  > information, methinks.
 >  > 
 >  > I'm stumped.
 > 
 > yeah, likewise.  I don't recall any bug that's given me this much headache.
 > I don't think it's helped that the symptoms are vague enough that a
 > number of people have thought they've seen the same thing, which have
 > turned out to be unrelated incidents.  At least some of those have
 > gotten closure though it seems.
 > 
 >  > Maybe it's worth it to concentrate on just testing current kernels,
 >  > and instead try to limit the triggering some other way. In particular,
 >  > you had a trinity run that was *only* testing lsetxattr(). Is that
 >  > really *all* that was going on? Obviously trinity will be using
 >  > timers, fork, and other things? Can you recreate that lsetxattr thing,
 >  > and just try to get as many problem reports as possible from one
 >  > particular kernel (say, 3.18, since that should be a reasonable modern
 >  > base with hopefully not a lot of other random issues)?
 > 
 > I'll let it run overnight, but so far after 4hrs, on .18 it's not done
 > anything.

Two hours later, it had spewed this, but survived. (Trinity had quit after that
point because /proc/sys/kernel/tainted changed).


[18755.303442] WARNING: CPU: 1 PID: 25572 at kernel/watchdog.c:317 watchdog_overflow_callback+0xdd/0x130()
[18755.303472] Watchdog detected hard LOCKUP on cpu 1
[18755.303487] CPU: 1 PID: 25572 Comm: trinity-c25 Not tainted 3.18.0+ #101 
[18755.303527]  ffffffff81a66315 00000000c1ad8e75 ffff880244205b88 ffffffff817d317e
[18755.303556]  0000000000110001 ffff880244205be0 ffff880244205bc8 ffffffff81078a01
[18755.303586]  0000000000000000 0000000000000001 0000000000000000 ffff880244205d30
[18755.303616] Call Trace:
[18755.303627]  <NMI>  [<ffffffff817d317e>] dump_stack+0x4f/0x7c
[18755.303654]  [<ffffffff81078a01>] warn_slowpath_common+0x81/0xa0
[18755.303675]  [<ffffffff81078a75>] warn_slowpath_fmt+0x55/0x70
[18755.303696]  [<ffffffff8112fea0>] ? restart_watchdog_hrtimer+0x60/0x60
[18755.303718]  [<ffffffff8112ff7d>] watchdog_overflow_callback+0xdd/0x130
[18755.303742]  [<ffffffff81173a7c>] __perf_event_overflow+0xac/0x2a0
[18755.303765]  [<ffffffff81019952>] ? x86_perf_event_set_period+0xe2/0x150
[18755.303787]  [<ffffffff81174644>] perf_event_overflow+0x14/0x20
[18755.303809]  [<ffffffff8101f479>] intel_pmu_handle_irq+0x209/0x410
[18755.303831]  [<ffffffff8101875b>] perf_event_nmi_handler+0x2b/0x50
[18755.303853]  [<ffffffff81007634>] nmi_handle+0xa4/0x1e0
[18755.303872]  [<ffffffff81007595>] ? nmi_handle+0x5/0x1e0
[18755.303892]  [<ffffffff810079aa>] default_do_nmi+0x7a/0x1d0
[18755.303911]  [<ffffffff81007bb8>] do_nmi+0xb8/0xf0
[18755.303929]  [<ffffffff817e0c2a>] end_repeat_nmi+0x1e/0x2e
[18755.303948]  <<EOE>>  <UNK> 
[18755.303959] ---[ end trace 6362f5b39b85eb2c ]---
[18755.303983] perf interrupt took too long (7018 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[18758.481443] ------------[ cut here ]------------
[18758.481475] WARNING: CPU: 3 PID: 25965 at kernel/watchdog.c:317 watchdog_overflow_callback+0xdd/0x130()
[18758.481512] Watchdog detected hard LOCKUP on cpu 3
[18758.481531] CPU: 3 PID: 25965 Comm: trinity-c418 Tainted: G        W      3.18.0+ #101 
[18758.482554]  ffffffff81a66315 00000000c93c9d92 ffff880244605b88 ffffffff817d317e
[18758.483585]  0000000000110004 ffff880244605be0 ffff880244605bc8 ffffffff81078a01
[18758.484614]  0000000000000000 0000000000000003 0000000000000000 ffff880244605d30
[18758.485651] Call Trace:
[18758.486657]  <NMI>  [<ffffffff817d317e>] dump_stack+0x4f/0x7c
[18758.487670]  [<ffffffff81078a01>] warn_slowpath_common+0x81/0xa0
[18758.488676]  [<ffffffff81078a75>] warn_slowpath_fmt+0x55/0x70
[18758.489675]  [<ffffffff8112fea0>] ? restart_watchdog_hrtimer+0x60/0x60
[18758.490681]  [<ffffffff8112ff7d>] watchdog_overflow_callback+0xdd/0x130
[18758.491687]  [<ffffffff81173a7c>] __perf_event_overflow+0xac/0x2a0
[18758.492677]  [<ffffffff81019952>] ? x86_perf_event_set_period+0xe2/0x150
[18758.493668]  [<ffffffff81174644>] perf_event_overflow+0x14/0x20
[18758.494662]  [<ffffffff8101f479>] intel_pmu_handle_irq+0x209/0x410
[18758.495653]  [<ffffffff8101875b>] perf_event_nmi_handler+0x2b/0x50
[18758.496652]  [<ffffffff81007634>] nmi_handle+0xa4/0x1e0
[18758.497646]  [<ffffffff81007595>] ? nmi_handle+0x5/0x1e0
[18758.498644]  [<ffffffff811080cf>] ? is_module_text_address+0x3f/0x50
[18758.499644]  [<ffffffff810079aa>] default_do_nmi+0x7a/0x1d0
[18758.500643]  [<ffffffff81007bb8>] do_nmi+0xb8/0xf0
[18758.501633]  [<ffffffff817e0c2a>] end_repeat_nmi+0x1e/0x2e
[18758.502619]  [<ffffffff811080cf>] ? is_module_text_address+0x3f/0x50
[18758.503606]  [<ffffffff811080cf>] ? is_module_text_address+0x3f/0x50
[18758.504583]  [<ffffffff811080cf>] ? is_module_text_address+0x3f/0x50
[18758.505548]  <<EOE>>  [<ffffffff810986b8>] __kernel_text_address+0x58/0x80
[18758.506526]  [<ffffffff81182a24>] ? free_one_page+0x1c4/0x520
[18758.507503]  [<ffffffff81006d8f>] print_context_stack+0x8f/0x100
[18758.508483]  [<ffffffff81005710>] dump_trace+0x140/0x370
[18758.509464]  [<ffffffff811b0961>] ? remove_vma+0x71/0x80
[18758.510445]  [<ffffffff81013ecf>] save_stack_trace+0x2f/0x50
[18758.511428]  [<ffffffff811d4f20>] set_track+0x70/0x140
[18758.512412]  [<ffffffff817d0f85>] free_debug_processing+0x157/0x22a
[18758.513387]  [<ffffffff810c50fe>] ? put_lock_stats.isra.23+0xe/0x30
[18758.514344]  [<ffffffff817d10ad>] __slab_free+0x55/0x320
[18758.515298]  [<ffffffff8138e016>] ? debug_check_no_obj_freed+0x156/0x250
[18758.516252]  [<ffffffff811d7fd2>] kmem_cache_free+0x262/0x280
[18758.517201]  [<ffffffff811b0961>] ? remove_vma+0x71/0x80
[18758.518133]  [<ffffffff811b0961>] remove_vma+0x71/0x80
[18758.519042]  [<ffffffff811b3f1c>] exit_mmap+0x13c/0x1a0
[18758.519938]  [<ffffffff81075a2b>] mmput+0x6b/0x100
[18758.520826]  [<ffffffff8107a02e>] do_exit+0x29e/0xba0
[18758.521707]  [<ffffffff81088d41>] ? get_signal+0x2c1/0x710
[18758.522585]  [<ffffffff8138cb27>] ? debug_smp_processor_id+0x17/0x20
[18758.523463]  [<ffffffff810c50fe>] ? put_lock_stats.isra.23+0xe/0x30
[18758.524336]  [<ffffffff810c5466>] ? lock_release_holdtime.part.24+0xe6/0x160
[18758.525220]  [<ffffffff8107b9dc>] do_group_exit+0x4c/0xc0
[18758.526099]  [<ffffffff81088d8c>] get_signal+0x30c/0x710
[18758.526977]  [<ffffffff8138cb27>] ? debug_smp_processor_id+0x17/0x20
[18758.527858]  [<ffffffff81002477>] do_signal+0x37/0x770
[18758.528735]  [<ffffffff8138d131>] ? free_object+0x81/0xb0
[18758.529608]  [<ffffffff8138db87>] ? debug_object_free+0xf7/0x150
[18758.530480]  [<ffffffff810ec285>] ? hrtimer_nanosleep+0x155/0x1c0
[18758.531357]  [<ffffffff810eac60>] ? hrtimer_get_res+0x50/0x50
[18758.532225]  [<ffffffff81002c15>] do_notify_resume+0x65/0x80
[18758.533102]  [<ffffffff8137f9ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[18758.533980]  [<ffffffff817deeff>] int_signal+0x12/0x17
[18758.534858] ---[ end trace 6362f5b39b85eb2d ]---
[18758.535840] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 54.297 msecs
[18758.537332] perf interrupt took too long (426767 > 10000), lowering kernel.perf_event_max_sample_rate to 12500

Few seconds later rcu craps itself..

[18801.941908] INFO: rcu_preempt detected stalls on CPUs/tasks:
[18801.942920] 	3: (3 GPs behind) idle=bf4/0/0 softirq=1597256/1597257 
[18801.943890] 	(detected by 0, t=6002 jiffies, g=763359, c=763358, q=0)
[18801.944843] Task dump for CPU 3:
[18801.945770] swapper/3       R  running task    14576     0      1 0x00200000
[18801.946706]  0000000342b6fe28 def23185c07e1b3d ffffe8ffff403518 0000000000000001
[18801.947629]  ffffffff81cb2000 0000000000000003 ffff880242b6fe78 ffffffff8166cb95
[18801.948557]  0000111242adb59f ffffffff81cb2070 ffff880242b6c000 ffffffff81d21ab0
[18801.949478] Call Trace:
[18801.950384]  [<ffffffff8166cb95>] ? cpuidle_enter_state+0x55/0x1c0
[18801.951303]  [<ffffffff8166cdb7>] ? cpuidle_enter+0x17/0x20
[18801.952211]  [<ffffffff810bf303>] ? cpu_startup_entry+0x423/0x4d0
[18801.953125]  [<ffffffff810314c3>] ? start_secondary+0x1a3/0x220

More of the same a minute later..

[18861.937095] INFO: rcu_preempt detected stalls on CPUs/tasks:
[18861.938050] 	1: (3 GPs behind) idle=89a/0/0 softirq=1498125/1498197 
[18861.938992] 	3: (4 GPs behind) idle=bf6/0/0 softirq=1597256/1597257 
[18861.939897] 	(detected by 0, t=6002 jiffies, g=763360, c=763359, q=0)
[18861.940812] Task dump for CPU 1:
[18861.941719] swapper/1       R  running task    14576     0      1 0x00200000
[18861.942649]  0000000142b5be28 8d64c020bc383a15 ffffe8ffff003518 0000000000000005
[18861.943584]  ffffffff81cb2000 0000000000000001 ffff880242b5be78 ffffffff8166cb95
[18861.944531]  0000112a29d67eee ffffffff81cb21d0 ffff880242b58000 ffffffff81d21ab0
[18861.945482] Call Trace:
[18861.946417]  [<ffffffff8166cb95>] ? cpuidle_enter_state+0x55/0x1c0
[18861.947368]  [<ffffffff8166cdb7>] ? cpuidle_enter+0x17/0x20
[18861.948315]  [<ffffffff810bf303>] ? cpu_startup_entry+0x423/0x4d0
[18861.949262]  [<ffffffff810314c3>] ? start_secondary+0x1a3/0x220
[18861.950214] Task dump for CPU 3:
[18861.951168] swapper/3       R  running task    14576     0      1 0x00200000
[18861.952143]  0000000342b6fe28 def23185c07e1b3d ffffe8ffff403518 0000000000000001
[18861.953117]  ffffffff81cb2000 0000000000000003 ffff880242b6fe78 ffffffff8166cb95
[18861.954099]  0000111c49e2522b ffffffff81cb2070 ffff880242b6c000 ffffffff81d21ab0
[18861.955082] Call Trace:
[18861.956054]  [<ffffffff8166cb95>] ? cpuidle_enter_state+0x55/0x1c0
[18861.957045]  [<ffffffff8166cdb7>] ? cpuidle_enter+0x17/0x20
[18861.958034]  [<ffffffff810bf303>] ? cpu_startup_entry+0x423/0x4d0
[18861.959019]  [<ffffffff810314c3>] ? start_secondary+0x1a3/0x220

CPU2 also gets 'stuck'.

[18889.800920] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 133s! [kworker/2:2:17558]
[18889.801789] CPU: 2 PID: 17558 Comm: kworker/2:2 Tainted: G        W      3.18.0+ #101 
[18889.802646] Workqueue: events free_obj_work
[18889.803490] task: ffff880231380000 ti: ffff8801b8c34000 task.ti: ffff8801b8c34000
[18889.804347] RIP: 0010:[<ffffffff81379d90>]  [<ffffffff81379d90>] memchr_inv+0x30/0x150
[18889.805219] RSP: 0018:ffff8801b8c37b08  EFLAGS: 00000287
[18889.806090] RAX: ffff8801cc9208a0 RBX: ffffffff81801b30 RCX: 000000000000005a
[18889.806973] RDX: 0000000000000008 RSI: 000000000000005a RDI: ffff8801cc92089c
[18889.807862] RBP: ffff8801b8c37b08 R08: ffff8801cc920898 R09: 000000000000005a
[18889.808756] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801b8c37af8
[18889.809650] R13: 0000000000000000 R14: ffffffffffffc000 R15: ffff8801b8c37b68
[18889.810545] FS:  0000000000000000(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
[18889.811489] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18889.812384] CR2: 00007f1da06eaf30 CR3: 0000000001c11000 CR4: 00000000001407e0
[18889.813290] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18889.814194] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[18889.815096] Stack:
[18889.815990]  ffff8801b8c37b58 ffffffff811d5aeb ffffea0007324800 ffff8801cc920898
[18889.816912]  00000000000000ce ffff880243c0fa80 ffff8801cc920730 ffffea0007324800
[18889.817839]  00000000000000bb ffff880243c0fa80 ffff8801b8c37b98 ffffffff811d6e78
[18889.818764] Call Trace:
[18889.819681]  [<ffffffff811d5aeb>] check_bytes_and_report+0x3b/0x110
[18889.820608]  [<ffffffff811d6e78>] check_object+0xa8/0x250
[18889.821525]  [<ffffffff811d7328>] __free_slab+0x158/0x1b0
[18889.822444]  [<ffffffff811d73b9>] discard_slab+0x39/0x50
[18889.823355]  [<ffffffff817d133a>] __slab_free+0x2e2/0x320
[18889.824250]  [<ffffffff8138ceed>] ? free_obj_work+0x5d/0xa0
[18889.825130]  [<ffffffff8138cb27>] ? debug_smp_processor_id+0x17/0x20
[18889.826007]  [<ffffffff811d7fd2>] kmem_cache_free+0x262/0x280
[18889.826882]  [<ffffffff8138cefc>] ? free_obj_work+0x6c/0xa0
[18889.827749]  [<ffffffff8138cefc>] free_obj_work+0x6c/0xa0
[18889.828612]  [<ffffffff810942ad>] process_one_work+0x1fd/0x590
[18889.829468]  [<ffffffff81094227>] ? process_one_work+0x177/0x590
[18889.830321]  [<ffffffff810c50fe>] ? put_lock_stats.isra.23+0xe/0x30
[18889.831215]  [<ffffffff8109475b>] worker_thread+0x11b/0x490
[18889.832054]  [<ffffffff81094640>] ? process_one_work+0x590/0x590
[18889.832896]  [<ffffffff81099f79>] kthread+0xf9/0x110
[18889.833738]  [<ffffffff810c50fe>] ? put_lock_stats.isra.23+0xe/0x30
[18889.834580]  [<ffffffff81099e80>] ? kthread_create_on_node+0x250/0x250
[18889.835425]  [<ffffffff817deb6c>] ret_from_fork+0x7c/0xb0
[18889.836268]  [<ffffffff81099e80>] ? kthread_create_on_node+0x250/0x250
[18889.837107] Code: 48 89 e5 77 3e 40 0f b6 f6 85 d2 89 d0 89 f1 74 2b 40 3a 37 0f 85 f1 00 00 00 83 e8 01 48 8d 44 07 01 eb 0f 0f 1f 80 00 00 00 00 <3a> 0f 0f 85 d8 00 00 00 48 83 c7 01 48 39 c7 75 ef 31 c0 5d c3 
[18889.838955] sending NMI to other CPUs:
[18889.839845] NMI backtrace for cpu 0
[18889.840760] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W      3.18.0+ #101 
[18889.841697] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[18889.842634] RIP: 0010:[<ffffffff813e1b15>]  [<ffffffff813e1b15>] intel_idle+0xd5/0x180
[18889.843583] RSP: 0018:ffffffff81c03e28  EFLAGS: 00000046
[18889.844523] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[18889.845467] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[18889.846410] RBP: ffffffff81c03e58 R08: 000000008baf90f8 R09: 0000000000000000
[18889.847355] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[18889.848300] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[18889.849240] FS:  0000000000000000(0000) GS:ffff880244000000(0000) knlGS:0000000000000000
[18889.850183] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18889.851118] CR2: 00007f7c0148c443 CR3: 0000000001c11000 CR4: 00000000001407f0
[18889.852058] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18889.852998] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[18889.853923] Stack:
[18889.854837]  0000000081c03e58 1972379d2eec42e9 ffffe8fffee03518 0000000000000005
[18889.855780]  ffffffff81cb2000 0000000000000000 ffffffff81c03ea8 ffffffff8166cb95
[18889.856727]  00001130b01225d0 ffffffff81cb21d0 ffffffff81c00000 ffffffff81d21ab0
[18889.857674] Call Trace:
[18889.858606]  [<ffffffff8166cb95>] cpuidle_enter_state+0x55/0x1c0
[18889.859532]  [<ffffffff8166cdb7>] cpuidle_enter+0x17/0x20
[18889.860435]  [<ffffffff810bf303>] cpu_startup_entry+0x423/0x4d0
[18889.861332]  [<ffffffff817ca403>] rest_init+0xc3/0xd0
[18889.862219]  [<ffffffff817ca345>] ? rest_init+0x5/0xd0
[18889.863099]  [<ffffffff81f21ee0>] ? ftrace_init+0xa8/0x13b
[18889.863975]  [<ffffffff81f0304c>] start_kernel+0x49d/0x4be
[18889.864840]  [<ffffffff81f0299f>] ? set_init_arg+0x55/0x55
[18889.865703]  [<ffffffff81f02581>] x86_64_start_reservations+0x2a/0x2c
[18889.866564]  [<ffffffff81f02675>] x86_64_start_kernel+0xf2/0xf6
[18889.867421] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[18889.869301] NMI backtrace for cpu 1
[18889.869312] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 29.456 msecs
[18889.871119] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W      3.18.0+ #101 
[18889.872056] task: ffff8802428bade0 ti: ffff880242b58000 task.ti: ffff880242b58000
[18889.872994] RIP: 0010:[<ffffffff813e1b15>]  [<ffffffff813e1b15>] intel_idle+0xd5/0x180
[18889.873934] RSP: 0018:ffff880242b5bdf8  EFLAGS: 00000046
[18889.874867] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[18889.875814] RDX: 0000000000000000 RSI: ffff880242b5bfd8 RDI: 0000000000000001
[18889.876751] RBP: ffff880242b5be28 R08: 000000008baf90f8 R09: 0000000000000000
[18889.877685] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[18889.878619] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880242b58000
[18889.879556] FS:  0000000000000000(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
[18889.880479] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18889.881425] CR2: 00007f0f10335000 CR3: 0000000001c11000 CR4: 00000000001407e0
[18889.882361] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18889.883292] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[18889.884219] Stack:
[18889.885136]  0000000142b5be28 8d64c020bc383a15 ffffe8ffff003518 0000000000000005
[18889.886087]  ffffffff81cb2000 0000000000000001 ffff880242b5be78 ffffffff8166cb95
[18889.887044]  00001130b011a3f3 ffffffff81cb21d0 ffff880242b58000 ffffffff81d21ab0
[18889.888005] Call Trace:
[18889.888970]  [<ffffffff8166cb95>] cpuidle_enter_state+0x55/0x1c0
[18889.889949]  [<ffffffff8166cdb7>] cpuidle_enter+0x17/0x20
[18889.890918]  [<ffffffff810bf303>] cpu_startup_entry+0x423/0x4d0
[18889.891884]  [<ffffffff810314c3>] start_secondary+0x1a3/0x220
[18889.892843] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[18889.894938] NMI backtrace for cpu 3
[18889.894946] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 55.092 msecs
[18889.896934] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W      3.18.0+ #101 
[18889.897911] task: ffff880242b65bc0 ti: ffff880242b6c000 task.ti: ffff880242b6c000
[18889.898890] RIP: 0010:[<ffffffff813e1b15>]  [<ffffffff813e1b15>] intel_idle+0xd5/0x180
[18889.899884] RSP: 0018:ffff880242b6fdf8  EFLAGS: 00000046
[18889.900889] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[18889.901859] RDX: 0000000000000000 RSI: ffff880242b6ffd8 RDI: 0000000000000003
[18889.902800] RBP: ffff880242b6fe28 R08: 000000008baf90f8 R09: 0000000000000000
[18889.903734] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[18889.904666] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880242b6c000
[18889.905599] FS:  0000000000000000(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
[18889.906546] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[18889.907502] CR2: 00007f0f10335000 CR3: 0000000001c11000 CR4: 00000000001407e0
[18889.908452] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18889.909396] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[18889.910329] Stack:
[18889.911297]  0000000342b6fe28 def23185c07e1b3d ffffe8ffff403518 0000000000000005
[18889.912265]  ffffffff81cb2000 0000000000000003 ffff880242b6fe78 ffffffff8166cb95
[18889.913254]  00001130b01223e8 ffffffff81cb21d0 ffff880242b6c000 ffffffff81d21ab0
[18889.914291] Call Trace:
[18889.915361]  [<ffffffff8166cb95>] cpuidle_enter_state+0x55/0x1c0
[18889.916402]  [<ffffffff8166cdb7>] cpuidle_enter+0x17/0x20
[18889.917448]  [<ffffffff810bf303>] cpu_startup_entry+0x423/0x4d0
[18889.918434]  [<ffffffff810314c3>] start_secondary+0x1a3/0x220
[18889.919385] Code: 31 d2 65 48 8b 34 25 08 aa 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 aa 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[18889.921511] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 81.657 msecs
[18889.922586] perf interrupt took too long (423445 > 19841), lowering kernel.perf_event_max_sample_rate to 6300

Then things are idle. Curiously, periodically I continued to see these..

[19729.163946] perf interrupt took too long (420164 > 39062), lowering kernel.perf_event_max_sample_rate to 3200
[20944.488815] perf interrupt took too long (416920 > 78125), lowering kernel.perf_event_max_sample_rate to 1600
[22102.596107] perf interrupt took too long (413690 > 156250), lowering kernel.perf_event_max_sample_rate to 800

I've seen those messages a fair bit on other machines do, and they drive me nuts
because there's no 'perf' being run. I think it means "NMI watchdog", but is
worded badly.  Still, it's curious that they appeared during what should have
been idle time.

I'll reboot the box and give it another shot, and see what falls out in the morning.

Oh, worth noting: on this run, I gave Chris's idea of disabling usb serial console a try.
I don't know if that's why I didn't see a total lockup this time or not..

Also this was from a run with just lsetxattr, 512 children..

	Dave

