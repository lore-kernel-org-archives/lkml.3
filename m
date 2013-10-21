Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3JUD2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 23:28:40 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:57593 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3JUD2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 23:28:38 -0400
Message-ID: <52649F5E.2080303@linux.vnet.ibm.com>
Date: Mon, 21 Oct 2013 11:28:30 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [sched] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84 put_online_cpus()
References: <20131019005129.GA5979@localhost>
In-Reply-To: <20131019005129.GA5979@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102103-8256-0000-0000-000009BE5A92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Fengguang

On 10/19/2013 08:51 AM, Fengguang Wu wrote:
> Greetings,

Will this do any helps?

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c06b8d3..7c61f31 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3716,7 +3716,6 @@ long sched_setaffinity(pid_t pid, const struct
cpumask *in_mask)
        p = find_process_by_pid(pid);
        if (!p) {
                rcu_read_unlock();
-               put_online_cpus();
                return -ESRCH;
        }

Regards,
Michael Wang

> 
> I got the below dmesg and the first bad commit is
> 
> commit 6acce3ef84520537f8a09a12c9ddbe814a584dd2
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Oct 11 14:38:20 2013 +0200
> 
>     sched: Remove get_online_cpus() usage
>     
>     Remove get_online_cpus() usage from the scheduler; there's 4 sites that
>     use it:
>     
>      - sched_init_smp(); where its completely superfluous since we're in
>        'early' boot and there simply cannot be any hotplugging.
>     
>      - sched_getaffinity(); we already take a raw spinlock to protect the
>        task cpus_allowed mask, this disables preemption and therefore
>        also stabilizes cpu_online_mask as that's modified using
>        stop_machine. However switch to active mask for symmetry with
>        sched_setaffinity()/set_cpus_allowed_ptr(). We guarantee active
>        mask stability by inserting sync_rcu/sched() into _cpu_down.
>     
>      - sched_setaffinity(); we don't appear to need get_online_cpus()
>        either, there's two sites where hotplug appears relevant:
>         * cpuset_cpus_allowed(); for the !cpuset case we use possible_mask,
>           for the cpuset case we hold task_lock, which is a spinlock and
>           thus for mainline disables preemption (might cause pain on RT).
>         * set_cpus_allowed_ptr(); Holds all scheduler locks and thus has
>           preemption properly disabled; also it already deals with hotplug
>           races explicitly where it releases them.
>     
>      - migrate_swap(); we can make stop_two_cpus() do the heavy lifting for
>        us with a little trickery. By adding a sync_sched/rcu() after the
>        CPU_DOWN_PREPARE notifier we can provide preempt/rcu guarantees for
>        cpu_active_mask. Use these to validate that both our cpus are active
>        when queueing the stop work before we queue the stop_machine works
>        for take_cpu_down().
>     
>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>     Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
>     Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
>     Cc: Mel Gorman <mgorman@suse.de>
>     Cc: Rik van Riel <riel@redhat.com>
>     Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>     Cc: Andrea Arcangeli <aarcange@redhat.com>
>     Cc: Johannes Weiner <hannes@cmpxchg.org>
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>     Cc: Andrew Morton <akpm@linux-foundation.org>
>     Cc: Steven Rostedt <rostedt@goodmis.org>
>     Cc: Oleg Nesterov <oleg@redhat.com>
>     Link: http://lkml.kernel.org/r/20131011123820.GV3081@twins.programming.kicks-ass.net
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> [3165] Watchdog is alive
> [3159] Started watchdog thread 3165
> [   58.695502] ------------[ cut here ]------------
> [   58.697835] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84 put_online_cpus+0x43/0x70()
> [   58.702423] Modules linked in:
> [   58.704404] CPU: 0 PID: 3166 Comm: trinity-child0 Not tainted 3.12.0-rc5-01882-gf3db366 #1172
> [   58.708530] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   58.710992]  0000000000000000 ffff88000acfbe50 ffffffff81a24643 0000000000000000
> [   58.715410]  ffff88000acfbe88 ffffffff810c3e6b ffffffff810c3fef 0000000000000000
> [   58.719826]  0000000000000000 0000000000006ee0 0000000000000ffc ffff88000acfbe98
> [   58.724348] Call Trace:
> [   58.726190]  [<ffffffff81a24643>] dump_stack+0x4d/0x66
> [   58.728531]  [<ffffffff810c3e6b>] warn_slowpath_common+0x7f/0x98
> [   58.731069]  [<ffffffff810c3fef>] ? put_online_cpus+0x43/0x70
> [   58.733664]  [<ffffffff810c3f32>] warn_slowpath_null+0x1a/0x1c
> [   58.736258]  [<ffffffff810c3fef>] put_online_cpus+0x43/0x70
> [   58.738686]  [<ffffffff810efd59>] sched_setaffinity+0x7d/0x1f9
> [   58.741210]  [<ffffffff810efce1>] ? sched_setaffinity+0x5/0x1f9
> [   58.743775]  [<ffffffff81a2f724>] ? _raw_spin_unlock_irq+0x2c/0x3e
> [   58.746417]  [<ffffffff810c7012>] ? do_setitimer+0x194/0x1f5
> [   58.748899]  [<ffffffff810eff37>] SyS_sched_setaffinity+0x62/0x71
> [   58.751481]  [<ffffffff81a373a9>] system_call_fastpath+0x16/0x1b
> [   58.754070] ---[ end trace 034818a1f6f06868 ]---
> [   58.757521] ------------[ cut here ]------------
> 
> git bisect start f3db36699379159b761cdbc093347822a633c616 2fe80d3bbf1c8bd9efc5b8154207c8dd104e7306 --
> git bisect good 0f2a02d75d0f37f1624585c50c3250b6d096f050  # 12:02     21+     19  kvm tools: fix function name
> git bisect good ee6946e6810792f208662507055e6f9c32f42898  # 13:47     21+      0  x86: perf -- Allow perf watchdog to use perfmon bit for msr index computation
> git bisect good 2eb3090631e1f3c5920e27e0a51ed876e88fe871  # 15:07     21+      0  Merge branch 'linus'
> git bisect good bf2575c121ca11247ef07fd02b43f7430834f7b1  # 15:58     21+      0  perf trace: Add summary option to dump syscall statistics
> git bisect good d6099aeb4a9aad5e7ab1c72eb119ebd52dee0d52  # 16:36     21+      0  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm
> git bisect good 54d54a7146ce2718738f97374d714dd6f5e103b0  # 16:56     21+      0  Merge branch 'x86/urgent'
> git bisect good ed8ada393388ef7ccfcfb3a88d8718f7df4b3165  # 17:44     21+      0  Merge tag 'rdma-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
> git bisect good f773934fb39d11608b8285db621ae65ca1465bf3  # 18:09     21+      0  Merge branch 'perf/core'
> git bisect  bad c2d816443ef305aba8eaf0bf368f4d3d87494f06  # 18:09      0-      9  sched/wait: Introduce prepare_to_wait_event()
> git bisect good 746023159c40c523b08a3bc3d213dac212385895  # 18:45     21+      1  sched: Fix race in migrate_swap_stop()
> git bisect  bad 8922915b38cd8b72f8e5af614b95be71d1d299d4  # 19:00      0-      1  sched/wait: Add ___wait_cond_timeout() to wait_event*_timeout() too
> git bisect  bad 6acce3ef84520537f8a09a12c9ddbe814a584dd2  # 19:13      0-      1  sched: Remove get_online_cpus() usage
> git bisect good 746023159c40c523b08a3bc3d213dac212385895  # 20:01     63+      3  sched: Fix race in migrate_swap_stop()
> git bisect  bad f3db36699379159b761cdbc093347822a633c616  # 20:01      0-     16  Merge branch 'sched/core'
> git bisect good 8df5f2f7724ba6566e92c87cf2354735aac4b9ed  # 20:53     63+     11  Revert "sched: Remove get_online_cpus() usage"
> git bisect good 04919afb85c8f007b7326c4da5eb61c52e91b9c7  # 21:36     63+      3  Merge branch 'for-linus' of git://git.samba.org/sfrench/cifs-2.6
> git bisect good a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 22:29     63+      6  Add linux-next specific files for 20130927
> git bisect  bad 574c653ee9062a8fcc619e7ec83a36ba2dfc5a26  # 22:43      0-      2  Merge branch 'core/rcu'
> 
> Thanks,
> Fengguang
> 

