Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3JVVZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:25:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:61089 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab3JVVZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:25:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,550,1378882800"; 
   d="scan'208";a="415403026"
Date: Tue, 22 Oct 2013 22:24:47 +0100
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Michael wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [sched] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84
 put_online_cpus()
Message-ID: <20131022212447.GA1373@localhost>
References: <20131019005129.GA5979@localhost>
 <20131022204632.GD2490@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022204632.GD2490@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 10:46:32PM +0200, Peter Zijlstra wrote:
> On Sat, Oct 19, 2013 at 08:51:29AM +0800, Fengguang Wu wrote:
> > Greetings,
> > [   58.695502] ------------[ cut here ]------------
> > [   58.697835] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84 put_online_cpus+0x43/0x70()
> > [   58.702423] Modules linked in:
> > [   58.704404] CPU: 0 PID: 3166 Comm: trinity-child0 Not tainted 3.12.0-rc5-01882-gf3db366 #1172
> > [   58.708530] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > [   58.710992]  0000000000000000 ffff88000acfbe50 ffffffff81a24643 0000000000000000
> > [   58.715410]  ffff88000acfbe88 ffffffff810c3e6b ffffffff810c3fef 0000000000000000
> > [   58.719826]  0000000000000000 0000000000006ee0 0000000000000ffc ffff88000acfbe98
> > [   58.724348] Call Trace:
> > [   58.726190]  [<ffffffff81a24643>] dump_stack+0x4d/0x66
> > [   58.728531]  [<ffffffff810c3e6b>] warn_slowpath_common+0x7f/0x98
> > [   58.731069]  [<ffffffff810c3fef>] ? put_online_cpus+0x43/0x70
> > [   58.733664]  [<ffffffff810c3f32>] warn_slowpath_null+0x1a/0x1c
> > [   58.736258]  [<ffffffff810c3fef>] put_online_cpus+0x43/0x70
> > [   58.738686]  [<ffffffff810efd59>] sched_setaffinity+0x7d/0x1f9
> > [   58.741210]  [<ffffffff810efce1>] ? sched_setaffinity+0x5/0x1f9
> > [   58.743775]  [<ffffffff81a2f724>] ? _raw_spin_unlock_irq+0x2c/0x3e
> > [   58.746417]  [<ffffffff810c7012>] ? do_setitimer+0x194/0x1f5
> > [   58.748899]  [<ffffffff810eff37>] SyS_sched_setaffinity+0x62/0x71
> > [   58.751481]  [<ffffffff81a373a9>] system_call_fastpath+0x16/0x1b
> > [   58.754070] ---[ end trace 034818a1f6f06868 ]---
> > [   58.757521] ------------[ cut here ]------------
> 
> Duh.. must've been blind or so..
> 
> Does this make it go away
 
> @@ -3716,7 +3716,6 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
>  	p = find_process_by_pid(pid);
>  	if (!p) {
>  		rcu_read_unlock();
> -		put_online_cpus();
>  		return -ESRCH;

Yes, it fixed the WARNING.

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

// The tests was queued for Michael Wang and have just finished.

There seems show up a new unreliable error "BUG:kernel_test_crashed".
I'll increase test runs to confirm whether it's a new bug.

/kernel/x86_64-lkp/686c61a262ef88fdbc81c4d18bd0fcfc904d3f3e                                  
+----------------------------------------------------------------------------------+-----------+--------------+--------------+
|                                                                                  | v3.12-rc4 | 6acce3ef8452 | 686c61a262ef |
+----------------------------------------------------------------------------------+-----------+--------------+--------------+
| good_boots                                                                       | 539       | 0            | 16           |
| has_kernel_error_warning                                                         | 24        | 20           | 1            |
| INFO:task_blocked_for_more_than_seconds                                          | 14        |              |              |
| WARNING:CPU:PID:at_arch/x86/kernel/cpu/perf_event_intel.c:intel_pmu_handle_irq() | 1         |              |              |
| INFO:NMI_handler(perf_event_nmi_handler)took_too_long_to_run:msecs               | 1         |              |              |
| XFS(vde):xlog_verify_grant_tail:space_BBTOB(tail_blocks)                         | 5         |              |              |
| Corruption_detected.Unmount_and_run_xfs_repair                                   | 5         |              |              |
| metadata_I/O_error:block(xfs_trans_read_buf_map)error_numblks                    | 5         |              |              |
| BUG:kernel_test_hang                                                             | 3         |              |              |
| WARNING:CPU:PID:at_kernel/cpu.c:put_online_cpus()                                | 0         | 20           |              |
| BUG:kernel_test_crashed                                                          | 0         | 0            | 1            |
+----------------------------------------------------------------------------------+-----------+--------------+--------------+

/kernel/x86_64-lkp-CONFIG_SCHED_DEBUG/686c61a262ef88fdbc81c4d18bd0fcfc904d3f3e
                                  
+------------------------------------------------------------------------------------+-----------+--------------+--------------+
|                                                                                    | v3.12-rc4 | 6acce3ef8452 | 686c61a262ef |
+------------------------------------------------------------------------------------+-----------+--------------+--------------+
| good_boots                                                                         | 39        | 0            | 16           |
| has_kernel_error_warning                                                           | 0         | 20           |              |
| INFO:rcu_sched_self-detected_stall_on_CPU(t=jiffies_g=c=q=)                        | 0         | 1            |              |
| INFO:task_blocked_for_more_than_seconds                                            | 0         | 6            |              |
| INFO:NMI_handler(arch_trigger_all_cpu_backtrace_handler)took_too_long_to_run:msecs | 0         | 3            |              |
| Kernel_panic-not_syncing:hung_task:blocked_tasks                                   | 0         | 3            |              |
| WARNING:CPU:PID:at_kernel/cpu.c:put_online_cpus()                                  | 0         | 12           |              |
| BUG:kernel_test_crashed                                                            | 0         | 1            |              |
+------------------------------------------------------------------------------------+-----------+--------------+--------------+

/kernel/x86_64-lkp-CONFIG_SCSI_DEBUG/686c61a262ef88fdbc81c4d18bd0fcfc904d3f3e

+------------------------------------------------------------------+-----------+--------------+--------------+
|                                                                  | v3.12-rc4 | 6acce3ef8452 | 686c61a262ef |
+------------------------------------------------------------------+-----------+--------------+--------------+
| good_boots                                                       | 38        | 1            | 17           |
| has_kernel_error_warning                                         | 1         | 20           | 1            |
| Out_of_memory:Kill_process                                       | 1         |              |              |
| Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes | 1         |              |              |
| BUG:kernel_test_oops                                             | 1         |              |              |
| WARNING:CPU:PID:at_kernel/cpu.c:put_online_cpus()                | 0         | 20           |              |
| INFO:rcu_sched_self-detected_stall_on_CPU(t=jiffies_g=c=q=)      | 0         | 0            | 1            |
+------------------------------------------------------------------+-----------+--------------+--------------+

