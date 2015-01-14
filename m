Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbbANSa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:30:28 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:52090 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbbANSa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:30:26 -0500
Date: Wed, 14 Jan 2015 10:21:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Stoidner, Christoph" <c.stoidner@arvero.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Question concerning RCU
Message-ID: <20150114182157.GR9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <94921a144a97457385ae95b838c3c6fa@EX132MBOX1A.de2.local>
 <20150106194317.GG5280@linux.vnet.ibm.com>
 <81b94fc89c774b71a967fc93823e9c63@EX132MBOX1A.de2.local>
 <20150111202604.GC8063@linux.vnet.ibm.com>
 <249b36ec1afa43a699b281a4192c6afd@EX132MBOX1A.de2.local>
 <20150112194412.GE9719@linux.vnet.ibm.com>
 <13bb628102314f509629bb399b056eb9@EX132MBOX1A.de2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13bb628102314f509629bb399b056eb9@EX132MBOX1A.de2.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011418-0025-0000-0000-000007C6C4C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 08:38:03AM +0000, Stoidner, Christoph wrote:
> 
> Hi Paul,
> 
> > Two things to try:
> > 
> > 1.      alt-sysreq-t to get all tasks' stacks, or
> 
> I am not able to do that since I am working on an embedded system which 
> has no real tty, just a serial connected terminal.
> 
> > 2.      disable RCU CPU stall warnings and see if the hangs go away.
> > 
> 
> As I see there is no config option to disable stall warnings. So I have now
> removed the calls of print_cpu_stall() and print_other_cpu_stall() in
> check_cpu_stall() in rcutree.c. Now the system crashs after some run-time 
> with the kernel message you can find at the end of that mail.

OK.  For future reference, booting with "rcupdate.rcu_cpu_stall_suppress=0"
is an easier way to accomplish this, but whatever works.

Quibbling about ways and means aside, this says that the RCU CPU stall
warnings were in fact diagnostic in nature rather than the source of the
problem.  Of course, the tangled list of tasks hanging off of the rcu_node
structure would cause the problem, but only if there already was an
RCU CPU stall warning for some other reason or if you did a certain series
of CPU-hotplug operations on a system with more than 16 CPUs.

So you have some other problem.  And given that you are the first to
report this, I am (perhaps self-servingly) inclined to suspect that
the tangling of the list of tasks hanging off of the rcu_node structure
is a symptom rather than a cause of the problem.

> > Hmmm...  Are you by chance pushing all dmesg through a serial console?
> 
> What exact do you mean? I thought I can see already all messages on my 
> kernel console. Do you think some message was chocked on some reason?

Many kernel versions can see all sorts of problems if there is too much
dmesg traffic pushed through too small a pipe.  Even a 115Kbaud serial
line is too slow for many kernels and kernel configurations.  There has
been some work to try to fix this in recent kernels, but thus far it has
not gone particularly well.

So if you are using a serial line for your console, try selecting the
fastest supported bitrate if you are not already doing so.  Alternatively,
adjust the various dmesg configurations options (Google is your friend
here) to limit the traffic passing through the serial line.  Another
option would be to find some other way to get your dmesg console traffic.
VGA or whatever, depending on what your hardware supports.

> > One thing to try would be to add a counter and break out of the loop
> > after (say) 10 iterations.  Is that a change you are comfortable making?
> 
> I will do so and give you the results.

Sounds good!

> So now here is the kernel output mentioned from above (messages when crash with disabled print_cpu_stall and print_other_cpu_stall):
> 
> [ 3448.269140] WARNING: at kernel/rcutree_plugin.h:227 rcu_note_context_switch+0x2b8/0x2e4()

???  I could believe rcu_preempt_note_context_switch() in
kernel/rcutree_plugin.h.  I could also believe rcu_note_context_switch()
in kernel/rcutree.c.  I cannot believe rcu_note_context_switch() in
kernel/rcutree_plugin.h.

There is something very wrong here.

If this is really rcu_preempt_note_context_switch() in kernel/rcutree_plugin.h,
this is complaining about the list of tasks hanging off of the rcu_node
structure being in an incorrect state.  Which matches your observation
that this list was corrupted: A task that should not be on the list is
instead already on the list.  (Or the pointers have been overwritten,
perhaps by a wild-pointer bug.)

This corruption could be most easily explained by a task entering the
scheduler twice.  In other words, a task called schedule(), but then
before starting running again, the task again called schedule().

You are running on new hardware, correct?  If so, I strongly suggest
that you review and test any recent changes to the architecture-specific
used by the scheduler.

> [ 3448.269158] Modules linked in:
> [ 3448.269186] CPU: 0 PID: 151 Comm: arm-linux-light Not tainted 3.10.18-rt14 #7
> [ 3448.269243] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [ 3448.269281] [<c0011994>] (show_stack+0x10/0x14) from [<c001bff0>] (warn_slowpath_common+0x4c/0x68)
> [ 3448.269312] [<c001bff0>] (warn_slowpath_common+0x4c/0x68) from [<c001c028>] (warn_slowpath_null+0x1c/0x24)
> [ 3448.269344] [<c001c028>] (warn_slowpath_null+0x1c/0x24) from [<c007498c>] (rcu_note_context_switch+0x2b8/0x2e4)
> [ 3448.269381] [<c007498c>] (rcu_note_context_switch+0x2b8/0x2e4) from [<c045da0c>] (__schedule+0x2c/0x4d0)
> [ 3448.269413] [<c045da0c>] (__schedule+0x2c/0x4d0) from [<c045e270>] (preempt_schedule_irq+0x48/0x80)
> [ 3448.269454] [<c045e270>] (preempt_schedule_irq+0x48/0x80) from [<c000e570>] (svc_preempt+0x8/0x20)
> [ 3448.269505] [<c000e570>] (svc_preempt+0x8/0x20) from [<c03f0a38>] (__inet_lookup_established+0x180/0x314)
> [ 3448.269553] [<c03f0a38>] (__inet_lookup_established+0x180/0x314) from [<c0409b64>] (tcp_v4_rcv+0x380/0x84c)
> [ 3448.269589] [<c0409b64>] (tcp_v4_rcv+0x380/0x84c) from [<c03e6e5c>] (ip_local_deliver+0xb0/0x19c)
> [ 3448.269621] [<c03e6e5c>] (ip_local_deliver+0xb0/0x19c) from [<c03e7240>] (ip_rcv+0x2f8/0x75c)
> [ 3448.269667] [<c03e7240>] (ip_rcv+0x2f8/0x75c) from [<c03c2dcc>] (__netif_receive_skb_core+0x2ac/0x618)
> [ 3448.269712] [<c03c2dcc>] (__netif_receive_skb_core+0x2ac/0x618) from [<c03c5310>] (process_backlog+0x90/0x150)
> [ 3448.269751] [<c03c5310>] (process_backlog+0x90/0x150) from [<c03c5b04>] (net_rx_action+0x13c/0x328)
> [ 3448.269797] [<c03c5b04>] (net_rx_action+0x13c/0x328) from [<c0023744>] (do_current_softirqs+0x1cc/0x428)
> [ 3448.269833] [<c0023744>] (do_current_softirqs+0x1cc/0x428) from [<c0023a7c>] (local_bh_enable+0x74/0x8c)
> [ 3448.269872] [<c0023a7c>] (local_bh_enable+0x74/0x8c) from [<c041a7e8>] (inet_stream_connect+0x40/0x48)
> [ 3448.269918] [<c041a7e8>] (inet_stream_connect+0x40/0x48) from [<c03b3a34>] (SyS_connect+0x68/0x90)
> [ 3448.269959] [<c03b3a34>] (SyS_connect+0x68/0x90) from [<c000e920>] (ret_fast_syscall+0x0/0x44)
> [ 3448.269971] ---[ end trace 0000000000000002 ]---
> [39204.977349] NOHZ: local_softirq_pending 02
> [39205.021093] DOS2 invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0

Unless you have a very small memory, this likely indicates more problems.
Perhaps corruption of the kernel's freelists.

Again, please carefully review any new architecture-specific code.  If this
was a generic problem, it would have shown up by now.  Perhaps someone
with more knowledge of your particular CPU family could help out here.

And more OOM messages below.

Or if your memory really is too small, the easy answer would be to
either add more memory or to reconfigure your kernel to be smaller.
The kernel tinification project might be helpful here, though they are
focused on more recent kernels.

							Thanx, Paul

> [39205.236351] CPU: 0 PID: 119 Comm: DOS2 Tainted: G        W    3.10.18-rt14 #7
> [39205.243591] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [39205.252327] [<c0011994>] (show_stack+0x10/0x14) from [<c0459a04>] (dump_header.isra.13+0x64/0x1f8)
> [39205.261406] [<c0459a04>] (dump_header.isra.13+0x64/0x1f8) from [<c009cb58>] (oom_kill_process+0x270/0x41c)
> [39205.271171] [<c009cb58>] (oom_kill_process+0x270/0x41c) from [<c009d1a0>] (out_of_memory+0x2e0/0x358)
> [39205.280505] [<c009d1a0>] (out_of_memory+0x2e0/0x358) from [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828)
> [39205.290354] [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828) from [<c009bb78>] (filemap_fault+0x1b0/0x46c)
> [39205.300210] [<c009bb78>] (filemap_fault+0x1b0/0x46c) from [<c00b89fc>] (__do_fault+0x68/0x4a8)
> [39205.308930] [<c00b89fc>] (__do_fault+0x68/0x4a8) from [<c00bbef0>] (handle_pte_fault+0xb4/0x77c)
> [39205.317819] [<c00bbef0>] (handle_pte_fault+0xb4/0x77c) from [<c00bc650>] (handle_mm_fault+0x98/0xc8)
> [39205.327061] [<c00bc650>] (handle_mm_fault+0x98/0xc8) from [<c00160d8>] (do_page_fault+0x24c/0x374)
> [39205.336121] [<c00160d8>] (do_page_fault+0x24c/0x374) from [<c0008660>] (do_PrefetchAbort+0x34/0x9c)
> [39205.345276] [<c0008660>] (do_PrefetchAbort+0x34/0x9c) from [<c000e894>] (ret_from_exception+0x0/0x10)
> [39205.354563] Exception stack(0xc7045fb0 to 0xc7045ff8)
> [39205.359677] 5fa0:                                     befb8ba0 00000000 b6b1efe8 00000001
> [39205.367930] 5fc0: 00000001 00000001 befb8c1c 00000080 b6b1efe8 fffffc18 00000000 befb8c34
> [39205.376184] 5fe0: 000a8098 befb8b98 b6d32ab8 b6d27da0 20000010 ffffffff
> [39205.382847] Mem-info:
> [39205.385169] Normal per-cpu:
> [39205.388017] CPU    0: hi:   42, btch:   7 usd:   0
> [39205.392873] active_anon:378 inactive_anon:660 isolated_anon:0
> [39205.392873]  active_file:14 inactive_file:34 isolated_file:0
> [39205.392873]  unevictable:0 dirty:0 writeback:0 unstable:0
> [39205.392873]  free:257 slab_reclaimable:897 slab_unreclaimable:26405
> [39205.392873]  mapped:174 shmem:667 pagetables:61 bounce:0
> [39205.392873]  free_cma:0
> [39205.423759] Normal free:1028kB min:1368kB low:1708kB high:2052kB active_anon:1512kB inactive_anon:2640kB active_file:56kB inactive_file:136kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:131072kB managed:117004kB mlocked:0kB dirty:0kB writeback:0kB mapped:696kB shmem:2668kB slab_reclaimable:3588kB slab_unreclaimable:105620kB kernel_stack:688kB pagetables:244kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:193065 all_unreclaimable? yes
> [39205.465753] lowmem_reserve[]: 0 0
> [39205.469196] Normal: 11*4kB (UR) 7*8kB (UM) 0*16kB 9*32kB (R) 2*64kB (R) 0*128kB 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 1028kB
> [39205.481921] 715 total pagecache pages
> [39205.485639] 0 pages in swap cache
> [39205.488997] Swap cache stats: add 0, delete 0, find 0/0
> [39205.494265] Free swap  = 0kB
> [39205.497185] Total swap = 0kB
> [39205.506509] 32768 pages of RAM
> [39205.509623] 382 free pages
> [39205.512363] 3464 reserved pages
> [39205.515550] 26784 slab pages
> [39205.518476] 262440 pages shared
> [39205.521649] 0 pages swap cached
> [39205.524836] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [39205.532795] [   79]     0    79     4979       81       6        0             0 SHEL
> [39205.540723] [   86]     0    86      562        7       3        0             0 tcpsvd
> [39205.548829] [   87]     0    87      583        7       3        0             0 telnetd
> [39205.557022] [   91]     0    91      484       21       5        0             0 gdbserver
> [39205.565388] [  100]     0   100      563       14       4        0             0 sh
> [39205.573124] [  101]     0   101      561        9       3        0             0 init
> [39205.581048] [  102]     0   102      561        9       3        0             0 init
> [39205.588980] [  103]     0   103      561        9       3        0             0 init
> [39205.596913] [  111]     0   111      562        9       3        0             0 exe
> [39205.604756] [  119]     0   119    24406      301      19        0             0 DOS2
> [39205.612666] [  151]     0   151      664       91       5        0             0 arm-linux-light
> [39205.621540] Out of memory: Kill process 79 (SHEL) score 0 or sacrifice child
> [39205.629195] Killed process 86 (tcpsvd) total-vm:2248kB, anon-rss:28kB, file-rss:0kB
> [39205.672580] [sched_delayed] sched: RT throttling activated
> [39206.229122] Sdrv invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
> [39206.236550] CPU: 0 PID: 143 Comm: Sdrv Tainted: G        W    3.10.18-rt14 #7
> [39206.243807] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [39206.252434] [<c0011994>] (show_stack+0x10/0x14) from [<c0459a04>] (dump_header.isra.13+0x64/0x1f8)
> [39206.261508] [<c0459a04>] (dump_header.isra.13+0x64/0x1f8) from [<c009cb58>] (oom_kill_process+0x270/0x41c)
> [39206.271273] [<c009cb58>] (oom_kill_process+0x270/0x41c) from [<c009d1a0>] (out_of_memory+0x2e0/0x358)
> [39206.280605] [<c009d1a0>] (out_of_memory+0x2e0/0x358) from [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828)
> [39206.290454] [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828) from [<c009bb78>] (filemap_fault+0x1b0/0x46c)
> [39206.300308] [<c009bb78>] (filemap_fault+0x1b0/0x46c) from [<c00b89fc>] (__do_fault+0x68/0x4a8)
> [39206.309031] [<c00b89fc>] (__do_fault+0x68/0x4a8) from [<c00bbef0>] (handle_pte_fault+0xb4/0x77c)
> [39206.317925] [<c00bbef0>] (handle_pte_fault+0xb4/0x77c) from [<c00bc650>] (handle_mm_fault+0x98/0xc8)
> [39206.327165] [<c00bc650>] (handle_mm_fault+0x98/0xc8) from [<c00160d8>] (do_page_fault+0x24c/0x374)
> [39206.336231] [<c00160d8>] (do_page_fault+0x24c/0x374) from [<c0008660>] (do_PrefetchAbort+0x34/0x9c)
> [39206.345392] [<c0008660>] (do_PrefetchAbort+0x34/0x9c) from [<c000e894>] (ret_from_exception+0x0/0x10)
> [39206.354680] Exception stack(0xc70fdfb0 to 0xc70fdff8)
> [39206.359795] dfa0:                                     000a8d58 b4b1acdc 00000002 00000002
> [39206.368047] dfc0: 00000002 00000002 b4b1b664 000000f0 00000000 befb8b28 befb8b28 b4b1ad34
> [39206.376302] dfe0: 000a832c b4b1acd0 0003ad38 b6c513e0 20000010 ffffffff
> [39206.382963] Mem-info:
> [39206.385283] Normal per-cpu:
> [39206.388131] CPU    0: hi:   42, btch:   7 usd:  12
> [39206.392988] active_anon:371 inactive_anon:660 isolated_anon:0
> [39206.392988]  active_file:9 inactive_file:27 isolated_file:0
> [39206.392988]  unevictable:0 dirty:0 writeback:0 unstable:0
> [39206.392988]  free:256 slab_reclaimable:898 slab_unreclaimable:26405
> [39206.392988]  mapped:180 shmem:667 pagetables:59 bounce:0
> [39206.392988]  free_cma:0
> [39206.423786] Normal free:1024kB min:1368kB low:1708kB high:2052kB active_anon:1484kB inactive_anon:2640kB active_file:36kB inactive_file:108kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:131072kB managed:117004kB mlocked:0kB dirty:0kB writeback:0kB mapped:720kB shmem:2668kB slab_reclaimable:3592kB slab_unreclaimable:105620kB kernel_stack:688kB pagetables:236kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:266 all_unreclaimable? yes
> [39206.465516] lowmem_reserve[]: 0 0
> [39206.468958] Normal: 8*4kB (U) 8*8kB (UM) 2*16kB (UM) 8*32kB (UMR) 2*64kB (UR) 0*128kB 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 1024kB
> [39206.482299] 712 total pagecache pages
> [39206.486018] 0 pages in swap cache
> [39206.489379] Swap cache stats: add 0, delete 0, find 0/0
> [39206.494648] Free swap  = 0kB
> [39206.497572] Total swap = 0kB
> [39206.506902] 32768 pages of RAM
> [39206.510018] 393 free pages
> [39206.512756] 3464 reserved pages
> [39206.515942] 26785 slab pages
> [39206.518865] 262364 pages shared
> [39206.522037] 0 pages swap cached
> [39206.525218] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [39206.533176] [   79]     0    79     4979       75       6        0             0 SHEL
> [39206.541114] [   87]     0    87      583        7       3        0             0 telnetd
> [39206.549306] [   91]     0    91      484       21       5        0             0 gdbserver
> [39206.557671] [  100]     0   100      563       14       4        0             0 sh
> [39206.565426] [  101]     0   101      561        9       3        0             0 init
> [39206.573336] [  102]     0   102      561        9       3        0             0 init
> [39206.581258] [  103]     0   103      561        9       3        0             0 init
> [39206.589190] [  111]     0   111      562        9       3        0             0 exe
> [39206.597030] [  119]     0   119    24406      308      19        0             0 DOS2
> [39206.604961] [  151]     0   151      664       92       5        0             0 arm-linux-light
> [39206.613843] Out of memory: Kill process 79 (SHEL) score 0 or sacrifice child
> [39206.621020] Killed process 87 (telnetd) total-vm:2332kB, anon-rss:28kB, file-rss:0kB
> [39206.644507] Sdrv invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
> [39206.651911] CPU: 0 PID: 143 Comm: Sdrv Tainted: G        W    3.10.18-rt14 #7
> [39206.659162] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [39206.667808] [<c0011994>] (show_stack+0x10/0x14) from [<c0459a04>] (dump_header.isra.13+0x64/0x1f8)
> [39206.676897] [<c0459a04>] (dump_header.isra.13+0x64/0x1f8) from [<c009cb58>] (oom_kill_process+0x270/0x41c)
> [39206.686661] [<c009cb58>] (oom_kill_process+0x270/0x41c) from [<c009d1a0>] (out_of_memory+0x2e0/0x358)
> [39206.695997] [<c009d1a0>] (out_of_memory+0x2e0/0x358) from [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828)
> [39206.705844] [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828) from [<c009bb78>] (filemap_fault+0x1b0/0x46c)
> [39206.715699] [<c009bb78>] (filemap_fault+0x1b0/0x46c) from [<c00b89fc>] (__do_fault+0x68/0x4a8)
> [39206.724423] [<c00b89fc>] (__do_fault+0x68/0x4a8) from [<c00bbef0>] (handle_pte_fault+0xb4/0x77c)
> [39206.733294] [<c00bbef0>] (handle_pte_fault+0xb4/0x77c) from [<c00bc650>] (handle_mm_fault+0x98/0xc8)
> [39206.742523] [<c00bc650>] (handle_mm_fault+0x98/0xc8) from [<c00160d8>] (do_page_fault+0x24c/0x374)
> [39206.751591] [<c00160d8>] (do_page_fault+0x24c/0x374) from [<c0008660>] (do_PrefetchAbort+0x34/0x9c)
> [39206.760748] [<c0008660>] (do_PrefetchAbort+0x34/0x9c) from [<c000e894>] (ret_from_exception+0x0/0x10)
> [39206.770037] Exception stack(0xc70fdfb0 to 0xc70fdff8)
> [39206.775167] dfa0:                                     000a8d58 b4b1acdc 00000002 00000002
> [39206.783408] dfc0: 00000002 00000002 b4b1b664 000000f0 00000000 befb8b28 befb8b28 b4b1ad34
> [39206.791655] dfe0: 000a832c b4b1acd0 0003ad38 b6c513e0 20000010 ffffffff
> [39206.798323] Mem-info:
> [39206.800647] Normal per-cpu:
> [39206.803483] CPU    0: hi:   42, btch:   7 usd:  28
> [39206.808353] active_anon:364 inactive_anon:660 isolated_anon:0
> [39206.808353]  active_file:9 inactive_file:36 isolated_file:0
> [39206.808353]  unevictable:0 dirty:0 writeback:0 unstable:0
> [39206.808353]  free:249 slab_reclaimable:898 slab_unreclaimable:26405
> [39206.808353]  mapped:180 shmem:667 pagetables:57 bounce:0
> [39206.808353]  free_cma:0
> [39206.839162] Normal free:996kB min:1368kB low:1708kB high:2052kB active_anon:1456kB inactive_anon:2640kB active_file:36kB inactive_file:144kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:131072kB managed:117004kB mlocked:0kB dirty:0kB writeback:0kB mapped:720kB shmem:2668kB slab_reclaimable:3592kB slab_unreclaimable:105620kB kernel_stack:688kB pagetables:228kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:266 all_unreclaimable? yes
> [39206.880808] lowmem_reserve[]: 0 0
> [39206.884297] Normal: 1*4kB (U) 8*8kB (UM) 2*16kB (UM) 8*32kB (UMR) 2*64kB (UR) 0*128kB 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 996kB
> [39206.897477] 712 total pagecache pages
> [39206.901181] 0 pages in swap cache
> [39206.904546] Swap cache stats: add 0, delete 0, find 0/0
> [39206.909814] Free swap  = 0kB
> [39206.912725] Total swap = 0kB
> [39206.921891] 32768 pages of RAM
> [39206.925013] 402 free pages
> [39206.927763] 3464 reserved pages
> [39206.930933] 26785 slab pages
> [39206.933855] 262353 pages shared
> [39206.937037] 0 pages swap cached
> [39206.940210] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [39206.948169] [   79]     0    79     4979       76       6        0             0 SHEL
> [39206.956122] [   91]     0    91      484       21       5        0             0 gdbserver
> [39206.964490] [  100]     0   100      563       14       4        0             0 sh
> [39206.972224] [  101]     0   101      561        9       3        0             0 init
> [39206.980149] [  102]     0   102      561        9       3        0             0 init
> [39206.988080] [  103]     0   103      561        9       3        0             0 init
> [39206.996012] [  111]     0   111      562        9       3        0             0 exe
> [39207.003855] [  119]     0   119    24406      308      19        0             0 DOS2
> [39207.011765] [  151]     0   151      664       92       5        0             0 arm-linux-light
> [39207.020636] Out of memory: Kill process 79 (SHEL) score 0 or sacrifice child
> [39207.027829] Killed process 151 (arm-linux-light) total-vm:2656kB, anon-rss:356kB, file-rss:12kB
> [39301.762563] KTMR invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
> [39301.769989] CPU: 0 PID: 120 Comm: KTMR Tainted: G        W    3.10.18-rt14 #7
> [39301.777244] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [39301.785949] [<c0011994>] (show_stack+0x10/0x14) from [<c0459a04>] (dump_header.isra.13+0x64/0x1f8)
> [39301.795036] [<c0459a04>] (dump_header.isra.13+0x64/0x1f8) from [<c009cb58>] (oom_kill_process+0x270/0x41c)
> [39301.804802] [<c009cb58>] (oom_kill_process+0x270/0x41c) from [<c009d1a0>] (out_of_memory+0x2e0/0x358)
> [39301.814139] [<c009d1a0>] (out_of_memory+0x2e0/0x358) from [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828)
> [39301.823990] [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828) from [<c009bb78>] (filemap_fault+0x1b0/0x46c)
> [39301.833843] [<c009bb78>] (filemap_fault+0x1b0/0x46c) from [<c00b89fc>] (__do_fault+0x68/0x4a8)
> [39301.842545] [<c00b89fc>] (__do_fault+0x68/0x4a8) from [<c00bbef0>] (handle_pte_fault+0xb4/0x77c)
> [39301.851429] [<c00bbef0>] (handle_pte_fault+0xb4/0x77c) from [<c00bc650>] (handle_mm_fault+0x98/0xc8)
> [39301.860672] [<c00bc650>] (handle_mm_fault+0x98/0xc8) from [<c00160d8>] (do_page_fault+0x24c/0x374)
> [39301.869734] [<c00160d8>] (do_page_fault+0x24c/0x374) from [<c0008660>] (do_PrefetchAbort+0x34/0x9c)
> [39301.878889] [<c0008660>] (do_PrefetchAbort+0x34/0x9c) from [<c000e894>] (ret_from_exception+0x0/0x10)
> [39301.888177] Exception stack(0xc7ba7fb0 to 0xc7ba7ff8)
> [39301.893291] 7fa0:                                     00000000 00000000 b6b1b4d4 00000002
> [39301.901542] 7fc0: 00000002 00000002 b6b1b664 000000f0 00000000 000a8bc0 000a8bc0 b6b1adcc
> [39301.909792] 7fe0: 00000000 b6b1ada0 b6c9d2cc b6c9d2cc 00000010 ffffffff
> [39301.916459] Mem-info:
> [39301.918782] Normal per-cpu:
> [39301.921616] CPU    0: hi:   42, btch:   7 usd:  25
> [39301.926484] active_anon:275 inactive_anon:660 isolated_anon:0
> [39301.926484]  active_file:11 inactive_file:14 isolated_file:0
> [39301.926484]  unevictable:0 dirty:0 writeback:0 unstable:0
> [39301.926484]  free:253 slab_reclaimable:1067 slab_unreclaimable:26412
> [39301.926484]  mapped:170 shmem:667 pagetables:53 bounce:0
> [39301.926484]  free_cma:0
> [39301.957470] Normal free:1012kB min:1368kB low:1708kB high:2052kB active_anon:1100kB inactive_anon:2640kB active_file:44kB inactive_file:56kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:131072kB managed:117004kB mlocked:0kB dirty:0kB writeback:0kB mapped:680kB shmem:2668kB slab_reclaimable:4268kB slab_unreclaimable:105648kB kernel_stack:688kB pagetables:212kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:173 all_unreclaimable? yes
> [39301.999116] lowmem_reserve[]: 0 0
> [39302.002558] Normal: 5*4kB (UMR) 0*8kB 0*16kB 13*32kB (R) 1*64kB (R) 0*128kB 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 1012kB
> [39302.014927] 692 total pagecache pages
> [39302.018633] 0 pages in swap cache
> [39302.021979] Swap cache stats: add 0, delete 0, find 0/0
> [39302.027249] Free swap  = 0kB
> [39302.030174] Total swap = 0kB
> [39302.039493] 32768 pages of RAM
> [39302.042607] 403 free pages
> [39302.045362] 3464 reserved pages
> [39302.048547] 26961 slab pages
> [39302.051458] 262477 pages shared
> [39302.054641] 0 pages swap cached
> [39302.057828] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [39302.065789] [   79]     0    79     4979       74       6        0             0 SHEL
> [39302.073764] [   91]     0    91      484       21       5        0             0 gdbserver
> [39302.082106] [  100]     0   100      563       14       4        0             0 sh
> [39302.089855] [  101]     0   101      561        9       3        0             0 init
> [39302.097784] [  102]     0   102      561        9       3        0             0 init
> [39302.105717] [  103]     0   103      561        9       3        0             0 init
> [39302.113747] [  111]     0   111      562        9       3        0             0 exe
> [39302.121569] [  119]     0   119    24406      301      19        0             0 DOS2
> [39302.129494] Out of memory: Kill process 79 (SHEL) score 0 or sacrifice child
> [39302.136678] Killed process 79 (SHEL) total-vm:19916kB, anon-rss:196kB, file-rss:100kB
> [39302.300917] init invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
> [39302.308373] CPU: 0 PID: 1 Comm: init Tainted: G        W    3.10.18-rt14 #7
> [39302.322388] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [39302.338258] [<c0011994>] (show_stack+0x10/0x14) from [<c0459a04>] (dump_header.isra.13+0x64/0x1f8)
> [39302.349168] [<c0459a04>] (dump_header.isra.13+0x64/0x1f8) from [<c009cb58>] (oom_kill_process+0x270/0x41c)
> [39302.374571] [<c009cb58>] (oom_kill_process+0x270/0x41c) from [<c009d1a0>] (out_of_memory+0x2e0/0x358)
> [39302.389193] [<c009d1a0>] (out_of_memory+0x2e0/0x358) from [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828)
> [39302.411012] [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828) from [<c009bb78>] (filemap_fault+0x1b0/0x46c)
> [39302.423298] [<c009bb78>] (filemap_fault+0x1b0/0x46c) from [<c00b89fc>] (__do_fault+0x68/0x4a8)
> [39302.440703] [<c00b89fc>] (__do_fault+0x68/0x4a8) from [<c00bbef0>] (handle_pte_fault+0xb4/0x77c)
> [39302.452829] [<c00bbef0>] (handle_pte_fault+0xb4/0x77c) from [<c00bc650>] (handle_mm_fault+0x98/0xc8)
> [39302.471876] [<c00bc650>] (handle_mm_fault+0x98/0xc8) from [<c00160d8>] (do_page_fault+0x24c/0x374)
> [39302.487291] [<c00160d8>] (do_page_fault+0x24c/0x374) from [<c0008660>] (do_PrefetchAbort+0x34/0x9c)
> [39302.516625] [<c0008660>] (do_PrefetchAbort+0x34/0x9c) from [<c000e894>] (ret_from_exception+0x0/0x10)
> [39302.578993] Exception stack(0xc783ffb0 to 0xc783fff8)
> [39302.593458] ffa0:                                     0000004f 0000004f 00000000 00000000
> [39302.606339] ffc0: 00000000 00000000 bee4cf14 00000077 00000310 00000000 00000000 00000000
> [39302.621109] ffe0: 00000000 bee4cc98 000b7324 000b7324 00000010 ffffffff
> [39302.638620] Mem-info:
> [39302.640963] Normal per-cpu:
> [39302.655655] CPU    0: hi:   42, btch:   7 usd:  41
> [39302.670065] active_anon:226 inactive_anon:660 isolated_anon:0
> [39302.670065]  active_file:0 inactive_file:3 isolated_file:0
> [39302.670065]  unevictable:0 dirty:0 writeback:0 unstable:0
> [39302.670065]  free:321 slab_reclaimable:1068 slab_unreclaimable:26412
> [39302.670065]  mapped:149 shmem:667 pagetables:48 bounce:0
> [39302.670065]  free_cma:0
> [39302.718249] Normal free:1284kB min:1368kB low:1708kB high:2052kB active_anon:904kB inactive_anon:2640kB active_file:8kB inactive_file:8kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:131072kB managed:117004kB mlocked:0kB dirty:0kB writeback:0kB mapped:584kB shmem:2668kB slab_reclaimable:4272kB slab_unreclaimable:105648kB kernel_stack:688kB pagetables:192kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:41 all_unreclaimable? yes
> [39302.785703] lowmem_reserve[]: 0 0
> [39302.795114] Normal: 33*4kB (UEMR) 12*8kB (UEMR) 2*16kB (E) 14*32kB (R) 1*64kB (R) 0*128kB 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 1284kB
> [39302.835636] 672 total pagecache pages
> [39302.841215] 0 pages in swap cache
> [39302.844735] Swap cache stats: add 0, delete 0, find 0/0
> [39302.850018] Free swap  = 0kB
> [39302.852929] Total swap = 0kB
> [39302.893328] 32768 pages of RAM
> [39302.911174] 461 free pages
> [39302.916596] 3464 reserved pages
> [39302.919793] 26963 slab pages
> [39302.922706] 262420 pages shared
> [39302.948030] 0 pages swap cached
> [39302.951250] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [39302.965513] [   91]     0    91      484       21       5        0             0 gdbserver
> [39302.978368] [  100]     0   100      563       14       4        0             0 sh
> [39302.996039] [  101]     0   101      561        9       3        0             0 init
> [39303.027719] [  102]     0   102      561        9       3        0             0 init
> [39303.038487] [  103]     0   103      561        9       3        0             0 init
> [39303.062736] [  111]     0   111      562        9       3        0             0 exe
> [39303.072031] [  119]     0   119    24406      295      19        0             0 DOS2
> [39303.093995] Out of memory: Kill process 91 (gdbserver) score 0 or sacrifice child
> [39303.101575] Killed process 91 (gdbserver) total-vm:1936kB, anon-rss:84kB, file-rss:0kB
> [39306.039708] init invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
> [39306.047162] CPU: 0 PID: 1 Comm: init Tainted: G        W    3.10.18-rt14 #7
> [39306.058024] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [39306.077380] [<c0011994>] (show_stack+0x10/0x14) from [<c0459a04>] (dump_header.isra.13+0x64/0x1f8)
> [39306.098361] [<c0459a04>] (dump_header.isra.13+0x64/0x1f8) from [<c009cb58>] (oom_kill_process+0x270/0x41c)
> [39306.127747] [<c009cb58>] (oom_kill_process+0x270/0x41c) from [<c009d1a0>] (out_of_memory+0x2e0/0x358)
> [39306.147835] [<c009d1a0>] (out_of_memory+0x2e0/0x358) from [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828)
> [39306.169187] [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828) from [<c009bb78>] (filemap_fault+0x1b0/0x46c)
> [39306.181761] [<c009bb78>] (filemap_fault+0x1b0/0x46c) from [<c00b89fc>] (__do_fault+0x68/0x4a8)
> [39306.198047] [<c00b89fc>] (__do_fault+0x68/0x4a8) from [<c00bbef0>] (handle_pte_fault+0xb4/0x77c)
> [39306.221629] [<c00bbef0>] (handle_pte_fault+0xb4/0x77c) from [<c00bc650>] (handle_mm_fault+0x98/0xc8)
> [39306.245708] [<c00bc650>] (handle_mm_fault+0x98/0xc8) from [<c00160d8>] (do_page_fault+0x24c/0x374)
> [39306.271265] [<c00160d8>] (do_page_fault+0x24c/0x374) from [<c00085c4>] (do_DataAbort+0x34/0x9c)
> [39306.282745] [<c00085c4>] (do_DataAbort+0x34/0x9c) from [<c000e6dc>] (__dabt_usr+0x3c/0x40)
> [39306.306351] Exception stack(0xc783ffb0 to 0xc783fff8)
> [39306.311482] ffa0:                                     001baf08 001baf08 001fcc38 ffffffff
> [39306.339241] ffc0: 001f7924 001f7920 001baf08 00000077 00000000 00000000 00000000 00000000
> [39306.359055] ffe0: 00000020 bee4caa0 0014b914 00113a40 a0000010 ffffffff
> [39306.377316] Mem-info:
> [39306.379659] Normal per-cpu:
> [39306.382502] CPU    0: hi:   42, btch:   7 usd:  27
> [39306.398232] active_anon:206 inactive_anon:660 isolated_anon:0
> [39306.398232]  active_file:11 inactive_file:20 isolated_file:0
> [39306.398232]  unevictable:0 dirty:0 writeback:0 unstable:0
> [39306.398232]  free:335 slab_reclaimable:1075 slab_unreclaimable:26413
> [39306.398232]  mapped:156 shmem:667 pagetables:44 bounce:0
> [39306.398232]  free_cma:0
> [39306.451620] Normal free:1340kB min:1368kB low:1708kB high:2052kB active_anon:824kB inactive_anon:2640kB active_file:52kB inactive_file:80kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:131072kB managed:117004kB mlocked:0kB dirty:0kB writeback:0kB mapped:628kB shmem:2668kB slab_reclaimable:4300kB slab_unreclaimable:105652kB kernel_stack:688kB pagetables:176kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:42 all_unreclaimable? no
> [39306.538833] lowmem_reserve[]: 0 0
> [39306.558977] Normal: 20*4kB (UEMR) 20*8kB (UEMR) 3*16kB (EM) 13*32kB (R) 1*64kB (R) 0*128kB 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 1280kB
> [39306.602971] 699 total pagecache pages
> [39306.609041] 0 pages in swap cache
> [39306.612460] Swap cache stats: add 0, delete 0, find 0/0
> [39306.620242] Free swap  = 0kB
> [39306.626345] Total swap = 0kB
> [39306.657778] 32768 pages of RAM
> [39306.668074] 480 free pages
> [39306.675523] 3464 reserved pages
> [39306.678762] 26970 slab pages
> [39306.684900] 262406 pages shared
> [39306.692875] 0 pages swap cached
> [39306.696730] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [39306.706842] [  100]     0   100      563       14       4        0             0 sh
> [39306.719513] [  101]     0   101      561        9       3        0             0 init
> [39306.728904] [  102]     0   102      561        9       3        0             0 init
> [39306.744824] [  103]     0   103      561        9       3        0             0 init
> [39306.759690] [  111]     0   111      562        9       3        0             0 exe
> [39306.780712] [  119]     0   119    24406      308      19        0             0 DOS2
> [39306.797288] Out of memory: Kill process 100 (sh) score 0 or sacrifice child
> [39306.810532] Killed process 111 (exe) total-vm:2248kB, anon-rss:36kB, file-rss:0kB
> [39312.050234] init invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
> [39312.057920] CPU: 0 PID: 1 Comm: init Tainted: G        W    3.10.18-rt14 #7
> [39312.078095] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [39312.091134] [<c0011994>] (show_stack+0x10/0x14) from [<c0459a04>] (dump_header.isra.13+0x64/0x1f8)
> [39312.111807] [<c0459a04>] (dump_header.isra.13+0x64/0x1f8) from [<c009cb58>] (oom_kill_process+0x270/0x41c)
> [39312.136447] [<c009cb58>] (oom_kill_process+0x270/0x41c) from [<c009d1a0>] (out_of_memory+0x2e0/0x358)
> [39312.157209] [<c009d1a0>] (out_of_memory+0x2e0/0x358) from [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828)
> [39312.178860] [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828) from [<c009bb78>] (filemap_fault+0x1b0/0x46c)
> [39312.203462] [<c009bb78>] (filemap_fault+0x1b0/0x46c) from [<c00b89fc>] (__do_fault+0x68/0x4a8)
> [39312.212255] [<c00b89fc>] (__do_fault+0x68/0x4a8) from [<c00bbef0>] (handle_pte_fault+0xb4/0x77c)
> [39312.232682] [<c00bbef0>] (handle_pte_fault+0xb4/0x77c) from [<c00bc650>] (handle_mm_fault+0x98/0xc8)
> [39312.266914] [<c00bc650>] (handle_mm_fault+0x98/0xc8) from [<c00160d8>] (do_page_fault+0x24c/0x374)
> [39312.277388] [<c00160d8>] (do_page_fault+0x24c/0x374) from [<c0008660>] (do_PrefetchAbort+0x34/0x9c)
> [39312.302503] [<c0008660>] (do_PrefetchAbort+0x34/0x9c) from [<c000e894>] (ret_from_exception+0x0/0x10)
> [39312.319383] Exception stack(0xc783ffb0 to 0xc783fff8)
> [39312.352097] ffa0:                                     00000000 00000001 ffffffff 001f7920
> [39312.372703] ffc0: 001f791c 00000000 001fcc38 00000000 00000000 00000000 00000000 00000000
> [39312.381008] ffe0: 00000020 bee4cac8 0014b618 0014b618 20000010 ffffffff
> [39312.409790] Mem-info:
> [39312.412135] Normal per-cpu:
> [39312.427154] CPU    0: hi:   42, btch:   7 usd:  17
> [39312.432317] active_anon:197 inactive_anon:660 isolated_anon:0
> [39312.432317]  active_file:8 inactive_file:24 isolated_file:0
> [39312.432317]  unevictable:0 dirty:0 writeback:0 unstable:0
> [39312.432317]  free:341 slab_reclaimable:1082 slab_unreclaimable:26413
> [39312.432317]  mapped:152 shmem:667 pagetables:41 bounce:0
> [39312.432317]  free_cma:0
> [39312.497429] Normal free:1364kB min:1368kB low:1708kB high:2052kB active_anon:788kB inactive_anon:2640kB active_file:32kB inactive_file:76kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:131072kB managed:117004kB mlocked:0kB dirty:0kB writeback:0kB mapped:608kB shmem:2668kB slab_reclaimable:4328kB slab_unreclaimable:105652kB kernel_stack:688kB pagetables:164kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:72 all_unreclaimable? no
> [39312.585870] lowmem_reserve[]: 0 0
> [39312.589327] Normal: 29*4kB (UEMR) 20*8kB (UEMR) 4*16kB (UEM) 14*32kB (R) 1*64kB (R) 0*128kB 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 1364kB
> [39312.624867] 689 total pagecache pages
> [39312.628592] 0 pages in swap cache
> [39312.631946] Swap cache stats: add 0, delete 0, find 0/0
> [39312.658337] Free swap  = 0kB
> [39312.661272] Total swap = 0kB
> [39312.700260] 32768 pages of RAM
> [39312.703382] 484 free pages
> [39312.714606] 3464 reserved pages
> [39312.717807] 26977 slab pages
> [39312.720719] 262296 pages shared
> [39312.746288] 0 pages swap cached
> [39312.753219] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [39312.769450] [  100]     0   100      563       14       4        0             0 sh
> [39312.792525] [  101]     0   101      561        9       3        0             0 init
> [39312.812431] [  102]     0   102      561        9       3        0             0 init
> [39312.828814] [  103]     0   103      561        9       3        0             0 init
> [39312.858571] [  119]     0   119    24406      298      19        0             0 DOS2
> [39312.875342] Out of memory: Kill process 100 (sh) score 0 or sacrifice child
> [39312.882416] Killed process 100 (sh) total-vm:2252kB, anon-rss:56kB, file-rss:0kB
> [39317.058606] init invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
> [39317.087570] CPU: 0 PID: 1 Comm: init Tainted: G        W    3.10.18-rt14 #7
> [39317.110803] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [39317.124891] [<c0011994>] (show_stack+0x10/0x14) from [<c0459a04>] (dump_header.isra.13+0x64/0x1f8)
> [39317.136451] [<c0459a04>] (dump_header.isra.13+0x64/0x1f8) from [<c009cb58>] (oom_kill_process+0x270/0x41c)
> [39317.159165] [<c009cb58>] (oom_kill_process+0x270/0x41c) from [<c009d1a0>] (out_of_memory+0x2e0/0x358)
> [39317.180234] [<c009d1a0>] (out_of_memory+0x2e0/0x358) from [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828)
> [39317.202224] [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828) from [<c009bb78>] (filemap_fault+0x1b0/0x46c)
> [39317.221533] [<c009bb78>] (filemap_fault+0x1b0/0x46c) from [<c00b89fc>] (__do_fault+0x68/0x4a8)
> [39317.249910] [<c00b89fc>] (__do_fault+0x68/0x4a8) from [<c00bbef0>] (handle_pte_fault+0xb4/0x77c)
> [39317.263057] [<c00bbef0>] (handle_pte_fault+0xb4/0x77c) from [<c00bc650>] (handle_mm_fault+0x98/0xc8)
> [39317.280027] [<c00bc650>] (handle_mm_fault+0x98/0xc8) from [<c00160d8>] (do_page_fault+0x24c/0x374)
> [39317.312513] [<c00160d8>] (do_page_fault+0x24c/0x374) from [<c0008660>] (do_PrefetchAbort+0x34/0x9c)
> [39317.328088] [<c0008660>] (do_PrefetchAbort+0x34/0x9c) from [<c000e894>] (ret_from_exception+0x0/0x10)
> [39317.348834] Exception stack(0xc783ffb0 to 0xc783fff8)
> [39317.359555] ffa0:                                     00000021 bee4cc39 00000001 0010b2c4
> [39317.370051] ffc0: 001ecf63 00000021 bee4caf0 001ecf42 0000001b 005444e0 001ecf2e bee4cae4
> [39317.391095] ffe0: bee4cc24 bee4c590 001152b8 000fb168 60000010 ffffffff
> [39317.416835] Mem-info:
> [39317.419197] Normal per-cpu:
> [39317.437828] CPU    0: hi:   42, btch:   7 usd:  33
> [39317.442711] active_anon:183 inactive_anon:660 isolated_anon:0
> [39317.442711]  active_file:8 inactive_file:14 isolated_file:0
> [39317.442711]  unevictable:0 dirty:0 writeback:0 unstable:0
> [39317.442711]  free:335 slab_reclaimable:1099 slab_unreclaimable:26413
> [39317.442711]  mapped:157 shmem:667 pagetables:38 bounce:0
> [39317.442711]  free_cma:0
> [39317.504971] Normal free:1340kB min:1368kB low:1708kB high:2052kB active_anon:732kB inactive_anon:2640kB active_file:20kB inactive_file:48kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:131072kB managed:117004kB mlocked:0kB dirty:0kB writeback:0kB mapped:644kB shmem:2668kB slab_reclaimable:4396kB slab_unreclaimable:105652kB kernel_stack:688kB pagetables:152kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:115 all_unreclaimable? no
> [39317.580967] lowmem_reserve[]: 0 0
> [39317.587861] Normal: 33*4kB (UER) 23*8kB (UEMR) 0*16kB 14*32kB (R) 1*64kB (R) 0*128kB 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 1340kB
> [39317.626427] 691 total pagecache pages
> [39317.640437] 0 pages in swap cache
> [39317.665726] Swap cache stats: add 0, delete 0, find 0/0
> [39317.671033] Free swap  = 0kB
> [39317.685779] Total swap = 0kB
> [39317.725133] 32768 pages of RAM
> [39317.728257] 491 free pages
> [39317.745840] 3464 reserved pages
> [39317.750902] 26995 slab pages
> [39317.754102] 262412 pages shared
> [39317.757298] 0 pages swap cached
> [39317.760474] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [39317.799791] [  101]     0   101      561        9       3        0             0 init
> [39317.816678] [  102]     0   102      561        9       3        0             0 init
> [39317.840536] [  103]     0   103      561        9       3        0             0 init
> [39317.866055] [  119]     0   119    24406      301      19        0             0 DOS2
> [39317.888937] Out of memory: Kill process 101 (init) score 0 or sacrifice child
> [39317.896233] Killed process 101 (init) total-vm:2244kB, anon-rss:36kB, file-rss:0kB
> [39322.989534] init invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
> [39323.018122] CPU: 0 PID: 1 Comm: init Tainted: G        W    3.10.18-rt14 #7
> [39323.036030] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [39323.049244] [<c0011994>] (show_stack+0x10/0x14) from [<c0459a04>] (dump_header.isra.13+0x64/0x1f8)
> [39323.071846] [<c0459a04>] (dump_header.isra.13+0x64/0x1f8) from [<c009cb58>] (oom_kill_process+0x270/0x41c)
> [39323.082797] [<c009cb58>] (oom_kill_process+0x270/0x41c) from [<c009d1a0>] (out_of_memory+0x2e0/0x358)
> [39323.092186] [<c009d1a0>] (out_of_memory+0x2e0/0x358) from [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828)
> [39323.127854] [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828) from [<c009bb78>] (filemap_fault+0x1b0/0x46c)
> [39323.157556] [<c009bb78>] (filemap_fault+0x1b0/0x46c) from [<c00b89fc>] (__do_fault+0x68/0x4a8)
> [39323.181916] [<c00b89fc>] (__do_fault+0x68/0x4a8) from [<c00bbef0>] (handle_pte_fault+0xb4/0x77c)
> [39323.199135] [<c00bbef0>] (handle_pte_fault+0xb4/0x77c) from [<c00bc650>] (handle_mm_fault+0x98/0xc8)
> [39323.221869] [<c00bc650>] (handle_mm_fault+0x98/0xc8) from [<c00160d8>] (do_page_fault+0x24c/0x374)
> [39323.231150] [<c00160d8>] (do_page_fault+0x24c/0x374) from [<c0008660>] (do_PrefetchAbort+0x34/0x9c)
> [39323.262060] [<c0008660>] (do_PrefetchAbort+0x34/0x9c) from [<c000e894>] (ret_from_exception+0x0/0x10)
> [39323.271390] Exception stack(0xc783ffb0 to 0xc783fff8)
> [39323.297696] ffa0:                                     00000010 bee4ca5f 00001fed 00000000
> [39323.315546] ffc0: 00545c18 001f7730 001f923c 005444e0 00547c34 00000002 ffffffff 001df485
> [39323.329386] ffe0: 00000008 bee4cb38 0011f694 0013e770 20000010 ffffffff
> [39323.356376] Mem-info:
> [39323.359661] Normal per-cpu:
> [39323.362751] CPU    0: hi:   42, btch:   7 usd:  18
> [39323.367660] active_anon:180 inactive_anon:660 isolated_anon:0
> [39323.367660]  active_file:7 inactive_file:23 isolated_file:0
> [39323.367660]  unevictable:0 dirty:0 writeback:0 unstable:0
> [39323.367660]  free:320 slab_reclaimable:1117 slab_unreclaimable:26414
> [39323.367660]  mapped:151 shmem:667 pagetables:36 bounce:0
> [39323.367660]  free_cma:0
> [39323.447451] Normal free:1312kB min:1368kB low:1708kB high:2052kB active_anon:720kB inactive_anon:2640kB active_file:48kB inactive_file:64kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:131072kB managed:117004kB mlocked:0kB dirty:0kB writeback:0kB mapped:628kB shmem:2668kB slab_reclaimable:4468kB slab_unreclaimable:105656kB kernel_stack:688kB pagetables:144kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:136 all_unreclaimable? no
> [39323.517993] lowmem_reserve[]: 0 0
> [39323.521450] Normal: 20*4kB (UMR) 24*8kB (UEMR) 1*16kB (E) 14*32kB (R) 1*64kB (R) 0*128kB 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 1312kB
> [39323.565363] 687 total pagecache pages
> [39323.569104] 0 pages in swap cache
> [39323.572521] Swap cache stats: add 0, delete 0, find 0/0
> [39323.581752] Free swap  = 0kB
> [39323.593989] Total swap = 0kB
> [39323.603150] 32768 pages of RAM
> [39323.626062] 469 free pages
> [39323.628827] 3464 reserved pages
> [39323.632002] 27013 slab pages
> [39323.657831] 262290 pages shared
> [39323.661029] 0 pages swap cached
> [39323.684548] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [39323.692548] [  102]     0   102      561        9       3        0             0 init
> [39323.720101] [  103]     0   103      561        9       3        0             0 init
> [39323.729498] [  119]     0   119    24406      308      19        0             0 DOS2
> [39323.748844] Out of memory: Kill process 102 (init) score 0 or sacrifice child
> [39323.766241] Killed process 102 (init) total-vm:2244kB, anon-rss:36kB, file-rss:0kB
> [39324.490216] init invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
> [39324.499229] CPU: 0 PID: 1 Comm: init Tainted: G        W    3.10.18-rt14 #7
> [39324.514052] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [39324.522690] [<c0011994>] (show_stack+0x10/0x14) from [<c0459a04>] (dump_header.isra.13+0x64/0x1f8)
> [39324.543418] [<c0459a04>] (dump_header.isra.13+0x64/0x1f8) from [<c009cb58>] (oom_kill_process+0x270/0x41c)
> [39324.576346] [<c009cb58>] (oom_kill_process+0x270/0x41c) from [<c009d1a0>] (out_of_memory+0x2e0/0x358)
> [39324.605943] [<c009d1a0>] (out_of_memory+0x2e0/0x358) from [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828)
> [39324.621336] [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828) from [<c009bb78>] (filemap_fault+0x1b0/0x46c)
> [39324.641215] [<c009bb78>] (filemap_fault+0x1b0/0x46c) from [<c00b89fc>] (__do_fault+0x68/0x4a8)
> [39324.656727] [<c00b89fc>] (__do_fault+0x68/0x4a8) from [<c00bbef0>] (handle_pte_fault+0xb4/0x77c)
> [39324.672123] [<c00bbef0>] (handle_pte_fault+0xb4/0x77c) from [<c00bc650>] (handle_mm_fault+0x98/0xc8)
> [39324.690004] [<c00bc650>] (handle_mm_fault+0x98/0xc8) from [<c00160d8>] (do_page_fault+0x24c/0x374)
> [39324.709370] [<c00160d8>] (do_page_fault+0x24c/0x374) from [<c00085c4>] (do_DataAbort+0x34/0x9c)
> [39324.718221] [<c00085c4>] (do_DataAbort+0x34/0x9c) from [<c000e6dc>] (__dabt_usr+0x3c/0x40)
> [39324.748525] Exception stack(0xc783ffb0 to 0xc783fff8)
> [39324.755773] ffa0:                                     00545c18 001d6780 0074696e 001cabb8
> [39324.775857] ffc0: 00000004 00545c18 001d677b 005444e0 00000014 00000002 ffffffff 001df485
> [39324.790665] ffe0: 00000000 bee4cb28 001082d8 00108300 60000010 ffffffff
> [39324.798451] Mem-info:
> [39324.800796] Normal per-cpu:
> [39324.805283] CPU    0: hi:   42, btch:   7 usd:  24
> [39324.810167] active_anon:174 inactive_anon:660 isolated_anon:0
> [39324.810167]  active_file:5 inactive_file:12 isolated_file:0
> [39324.810167]  unevictable:0 dirty:0 writeback:0 unstable:0
> [39324.810167]  free:340 slab_reclaimable:1120 slab_unreclaimable:26414
> [39324.810167]  mapped:150 shmem:667 pagetables:34 bounce:0
> [39324.810167]  free_cma:0
> [39324.872476] Normal free:1332kB min:1368kB low:1708kB high:2052kB active_anon:696kB inactive_anon:2640kB active_file:28kB inactive_file:40kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:131072kB managed:117004kB mlocked:0kB dirty:0kB writeback:0kB mapped:608kB shmem:2668kB slab_reclaimable:4484kB slab_unreclaimable:105656kB kernel_stack:688kB pagetables:136kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:27 all_unreclaimable? no
> [39324.985082] lowmem_reserve[]: 0 0
> [39324.988537] Normal: 31*4kB (UEMR) 21*8kB (UEMR) 1*16kB (E) 14*32kB (R) 1*64kB (R) 0*128kB 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 1332kB
> [39325.044947] 698 total pagecache pages
> [39325.048672] 0 pages in swap cache
> [39325.052026] Swap cache stats: add 0, delete 0, find 0/0
> [39325.078558] Free swap  = 0kB
> [39325.081498] Total swap = 0kB
> [39325.101979] 32768 pages of RAM
> [39325.128894] 473 free pages
> [39325.131685] 3464 reserved pages
> [39325.144934] 27017 slab pages
> [39325.147870] 262372 pages shared
> [39325.151045] 0 pages swap cached
> [39325.164944] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [39325.172952] [  103]     0   103      561        9       3        0             0 init
> [39325.198596] [  119]     0   119    24406      294      19        0             0 DOS2
> [39325.216981] Out of memory: Kill process 103 (init) score 0 or sacrifice child
> [39325.233560] Killed process 103 (init) total-vm:2244kB, anon-rss:36kB, file-rss:0kB
> [39327.449171] init invoked oom-killer: gfp_mask=0x201da, order=0, oom_score_adj=0
> [39327.456625] CPU: 0 PID: 1 Comm: init Tainted: G        W    3.10.18-rt14 #7
> [39327.464900] [<c0013bc4>] (unwind_backtrace+0x0/0xf0) from [<c0011994>] (show_stack+0x10/0x14)
> [39327.480088] [<c0011994>] (show_stack+0x10/0x14) from [<c0459a04>] (dump_header.isra.13+0x64/0x1f8)
> [39327.509166] [<c0459a04>] (dump_header.isra.13+0x64/0x1f8) from [<c009cb58>] (oom_kill_process+0x270/0x41c)
> [39327.521211] [<c009cb58>] (oom_kill_process+0x270/0x41c) from [<c009d1a0>] (out_of_memory+0x2e0/0x358)
> [39327.544078] [<c009d1a0>] (out_of_memory+0x2e0/0x358) from [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828)
> [39327.577596] [<c00a11e8>] (__alloc_pages_nodemask+0x734/0x828) from [<c009bb78>] (filemap_fault+0x1b0/0x46c)
> [39327.603399] [<c009bb78>] (filemap_fault+0x1b0/0x46c) from [<c00b89fc>] (__do_fault+0x68/0x4a8)
> [39327.623261] [<c00b89fc>] (__do_fault+0x68/0x4a8) from [<c00bbef0>] (handle_pte_fault+0xb4/0x77c)
> [39327.638530] [<c00bbef0>] (handle_pte_fault+0xb4/0x77c) from [<c00bc650>] (handle_mm_fault+0x98/0xc8)
> [39327.674077] [<c00bc650>] (handle_mm_fault+0x98/0xc8) from [<c00160d8>] (do_page_fault+0x24c/0x374)
> [39327.683136] [<c00160d8>] (do_page_fault+0x24c/0x374) from [<c0008660>] (do_PrefetchAbort+0x34/0x9c)
> [39327.719802] [<c0008660>] (do_PrefetchAbort+0x34/0x9c) from [<c000e894>] (ret_from_exception+0x0/0x10)
> [39327.753954] Exception stack(0xc783ffb0 to 0xc783fff8)
> [39327.759082] ffa0:                                     00000000 00000000 00547c30 00000061
> [39327.785854] ffc0: 00000001 00000001 00547c30 005444e0 00547c28 001f8bc8 00000057 00002008
> [39327.805092] ffe0: 00000061 bee4cae0 00111fd0 00112000 60000010 ffffffff
> [39327.811771] Mem-info:
> [39327.841553] Normal per-cpu:
> [39327.850527] CPU    0: hi:   42, btch:   7 usd:  19
> [39327.864116] active_anon:166 inactive_anon:660 isolated_anon:0
> [39327.864116]  active_file:7 inactive_file:23 isolated_file:0
> [39327.864116]  unevictable:0 dirty:0 writeback:0 unstable:0
> [39327.864116]  free:326 slab_reclaimable:1128 slab_unreclaimable:26414
> [39327.864116]  mapped:161 shmem:667 pagetables:32 bounce:0
> [39327.864116]  free_cma:0
> [39327.925156] Normal free:1304kB min:1368kB low:1708kB high:2052kB active_anon:664kB inactive_anon:2640kB active_file:56kB inactive_file:80kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:131072kB managed:117004kB mlocked:0kB dirty:0kB writeback:0kB mapped:640kB shmem:2668kB slab_reclaimable:4512kB slab_unreclaimable:105656kB kernel_stack:688kB pagetables:128kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:46 all_unreclaimable? no
> [39328.008319] lowmem_reserve[]: 0 0
> [39328.011777] Normal: 22*4kB (UMR) 20*8kB (UEMR) 2*16kB (EM) 14*32kB (R) 1*64kB (R) 0*128kB 0*256kB 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB = 1304kB
> [39328.084015] 689 total pagecache pages
> [39328.087742] 0 pages in swap cache
> [39328.091094] Swap cache stats: add 0, delete 0, find 0/0
> [39328.122046] Free swap  = 0kB
> [39328.126272] Total swap = 0kB
> [39328.151698] 32768 pages of RAM
> [39328.167790] 485 free pages
> [39328.170598] 3464 reserved pages
> [39328.173993] 27024 slab pages
> [39328.176930] 262275 pages shared
> [39328.180104] 0 pages swap cached
> [39328.204867] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
> [39328.212890] [  119]     0   119    24406      297      19        0             0 DOS2
> [39328.232666] Out of memory: Kill process 119 (DOS2) score 0 or sacrifice child
> [39328.258087] Killed process 119 (DOS2) total-vm:97624kB, anon-rss:592kB, file-rss:608kB
> 
> 
> Thanks and regards,
> Christoph
> 

