Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaGGN41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:56:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24740 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaGGN40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:56:26 -0400
Message-ID: <53BAA6DF.5060409@oracle.com>
Date: Mon, 07 Jul 2014 09:55:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
References: <53B98709.3090603@oracle.com> <20140707083016.GA19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140707083016.GA19379@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 04:30 AM, Peter Zijlstra wrote:
> On Sun, Jul 06, 2014 at 01:27:37PM -0400, Sasha Levin wrote:
>> Hi all,
>> 
>> While fuzzing with trinity inside a KVM tools guest running the latest -next kernel I've stumbled on the following spew:
>> 
>> [10062.200152] BUG: spinlock recursion on CPU#11, trinity-c194/2414 [10062.201897]  lock: 0xffff88010cfd7740, .magic: dead4ead, .owner: trinity-c194/2414, .owner_cpu: -1 [10062.204432] CPU: 11 PID: 2414 Comm: trinity-c194 Not tainted 3.16.0-rc3-next-20140703-sasha-00024-g2ad7668-dirty #763 [10062.207517]  ffff88010cfd7740 ffff8803a429fe48 ffffffffaa4897e4 0000000000000000 [10062.209810]  ffff8803c35f0000 ffff8803a429fe68 ffffffffaa47df58 ffff88010cfd7740 [10062.210024]  ffffffffab845c77 ffff8803a429fe88 ffffffffaa47df83 ffff88010cfd7740 [10062.210024] Call Trace: [10062.210024] dump_stack (lib/dump_stack.c:52) [10062.210024] spin_dump (kernel/locking/spinlock_debug.c:68 (discriminator 6)) [10062.210024] spin_bug (kernel/locking/spinlock_debug.c:76) [10062.210024] do_raw_spin_lock (kernel/locking/spinlock_debug.c:84 kernel/locking/spinlock_debug.c:135) [10062.210024] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151) [10062.210024] ? task_r!
 q_lock (in
clude/linux/sched.h:2885 kernel/sched/core.c:348) [10062.210024] task_rq_lock (include/linux/sched.h:2885 kernel/sched/core.c:348) [10062.210024] SyS_sched_rr_get_interval (kernel/sched/core.c:4429 kernel/sched/core.c:4407) [10062.210024] ? tracesys (arch/x86/kernel/entry_64.S:531) [10062.210024] tracesys (arch/x86/kernel/entry_64.S:542)
> 
> Cute, but I'm utterly failing to see how that happened :/
> 
> All we should be holding there is the rcu_read_lock(), task_rq_lock() there will take ->pi_lock and then rq->lock.
> 
> Maybe after more tea, when the brain wakes up more or so.. weird.
> 

I've also had this one, which looks similar:

[10375.005884] BUG: spinlock recursion on CPU#0, modprobe/10965
[10375.006573]  lock: 0xffff8803a0fd7740, .magic: dead4ead, .owner: modprobe/10965, .owner_cpu: 15
[10375.007412] CPU: 0 PID: 10965 Comm: modprobe Tainted: G        W      3.16.0-rc3-next-20140704-sasha-00023-g26c0906-dirty #765
[10375.008591]  ffff8803a0fd7740 ffff88015507f6d8 ffffffff9d48f5f4 0000000000000000
[10375.009660]  ffff880122f90000 ffff88015507f6f8 ffffffff9d483d68 ffff8803a0fd7740
[10375.010323]  ffffffff9e8476a1 ffff88015507f718 ffffffff9d483d93 ffff8803a0fd7740
[10375.010323] Call Trace:
[10375.010323] dump_stack (lib/dump_stack.c:52)
[10375.010323] spin_dump (kernel/locking/spinlock_debug.c:68 (discriminator 6))
[10375.010323] spin_bug (kernel/locking/spinlock_debug.c:76)
[10375.010323] do_raw_spin_lock (kernel/locking/spinlock_debug.c:84 kernel/locking/spinlock_debug.c:135)
[10375.010323] _raw_spin_lock_nested (kernel/locking/spinlock.c:362 (discriminator 2))
[10375.010323] ? load_balance (kernel/sched/sched.h:1427 kernel/sched/fair.c:6556)
[10375.010323] ? _raw_spin_lock (kernel/locking/spinlock.c:152)
[10375.010323] ? load_balance (kernel/sched/sched.h:1427 kernel/sched/fair.c:6556)
[10375.010323] load_balance (kernel/sched/sched.h:1427 kernel/sched/fair.c:6556)
[10375.010323] ? put_lock_stats.isra.12 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[10375.010323] ? _raw_spin_unlock_irqrestore (include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
[10375.010323] pick_next_task_fair (kernel/sched/fair.c:6808 kernel/sched/fair.c:4851)
[10375.010323] __schedule (kernel/sched/core.c:2675 kernel/sched/core.c:2789)
[10375.010323] schedule (kernel/sched/core.c:2836)
[10375.010323] p9_client_rpc (net/9p/client.c:756 (discriminator 9))
[10375.010323] ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
[10375.010323] ? bit_waitqueue (kernel/sched/wait.c:291)
[10375.010323] p9_client_walk (net/9p/client.c:1188 (discriminator 3))
[10375.010323] v9fs_vfs_lookup (fs/9p/vfs_inode.c:808)
[10375.010323] ? d_alloc (fs/dcache.c:1475)
[10375.010323] lookup_real (fs/namei.c:1332)
[10375.010323] __lookup_hash (fs/namei.c:1350)
[10375.010323] lookup_slow (fs/namei.c:1460)
[10375.010323] link_path_walk (fs/namei.c:1540 fs/namei.c:1796)
[10375.010323] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
[10375.010323] path_lookupat (fs/namei.c:1943)
[10375.010323] ? kmem_cache_alloc (include/linux/kmemleak.h:44 mm/slub.c:1256 mm/slub.c:2451 mm/slub.c:2459 mm/slub.c:2464)
[10375.010323] ? getname_flags (fs/namei.c:145)
[10375.010323] ? getname_flags (fs/namei.c:145)
[10375.010323] filename_lookup (fs/namei.c:1984)
[10375.010323] user_path_at_empty (fs/namei.c:2135)
[10375.010323] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
[10375.010323] ? put_lock_stats.isra.12 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[10375.010323] user_path_at (fs/namei.c:2146)
[10375.010323] vfs_fstatat (fs/stat.c:107)
[10375.010323] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:184 (discriminator 2))
[10375.010323] vfs_stat (fs/stat.c:124)
[10375.010323] SYSC_newstat (fs/stat.c:272)
[10375.010323] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
[10375.010323] ? syscall_trace_enter (include/linux/context_tracking.h:27 arch/x86/kernel/ptrace.c:1461)
[10375.010323] ? tracesys (arch/x86/kernel/entry_64.S:531)
[10375.010323] SyS_newstat (fs/stat.c:267)
[10375.010323] tracesys (arch/x86/kernel/entry_64.S:542)


Thanks,
Sasha
