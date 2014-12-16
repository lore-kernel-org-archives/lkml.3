Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaLPFaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:30:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41889 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaLPFaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:30:03 -0500
Message-ID: <548FC338.4050409@oracle.com>
Date: Tue, 16 Dec 2014 00:29:28 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sched: odd values for effective load calculations
References: <547E42F7.5070105@gmail.com> <20141213083012.GH32572@gmail.com> <20141215121227.GZ29390@twins.programming.kicks-ass.net> <20141215131410.GM10476@twins.programming.kicks-ass.net>
In-Reply-To: <20141215131410.GM10476@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 08:14 AM, Peter Zijlstra wrote:
>>>> [  787.894288] ================================================================================
>>>> > > > [  787.897074] UBSan: Undefined behaviour in kernel/sched/fair.c:4541:17
>>>> > > > [  787.898981] signed integer overflow:
>>>> > > > [  787.900066] 361516561629678 * 101500 cannot be represented in type 'long long int'
>> > 
>> > So that's:
>> > 
>> > 	this_eff_load *= this_load +
>> > 		effective_load(tg, this_cpu, weight, weight);
>> > 
>> > Going by the numbers the 101500 must be 'this_eff_load', 100 * ~1024
>> > makes that. Which makes the rhs 'large'. Do you have
>> > CONFIG_FAIR_GROUP_SCHED enabled? If so, what kind of cgroup hierarchy
>> > are you using?
>> > 
>> > In any case, bit sad this doesn't have a register dump included :/
> Hmm, I was hoping to be able to see if it was this_load or the
> effective_load() result being silly large, but going by the ASM output
> of my compiler this isn't going to be available in registers, its all
> stack spills.
> 
> Pinning my hopes on that reproducability thing :/

Okay, yeah, it's very reproducible. I've added:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df2cdf7..e1fbe1a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4486,7 +4486,7 @@ static int wake_wide(struct task_struct *p)

 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
-       s64 this_load, load;
+       s64 this_load, load, tmps;
        s64 this_eff_load, prev_eff_load;
        int idx, this_cpu, prev_cpu;
        struct task_group *tg;
@@ -4538,6 +4538,9 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
        prev_eff_load *= capacity_of(this_cpu);

        if (this_load > 0) {
+               if (__builtin_mul_overflow(this_eff_load, this_load +
+                        effective_load(tg, this_cpu, weight, weight), &tmps))
+                       printk(KERN_CRIT "%lld %lld %lld", this_eff_load, this_load, effective_load(tg, this_cpu, weight, weight));
                this_eff_load *= this_load +
                        effective_load(tg, this_cpu, weight, weight);

And got:

[  437.511964] 91600 1765238667340524 81
[  437.512781] ================================================================================
[  437.516069] UBSan: Undefined behaviour in kernel/sched/fair.c:4544:17
[  437.517888] signed integer overflow:
[  437.518721] 1765238667340605 * 91600 cannot be represented in type 'long long int'
[  437.520051] CPU: 16 PID: 23069 Comm: trinity-c510 Not tainted 3.18.0-next-20141211-sasha-00069-g11f17a7-dirty #1607
[  437.520153]  0000000000000000 0000000000000000 ffffffffb1f0fc70 ffff880321e8f908
[  437.520153]  ffffffffb0250d8f 1ffffffff78a0603 ffffffffb1f0fc88 ffff880321e8f928
[  437.520153]  ffffffffb0252f96 1ffffffff78a0603 ffffffffb1f0fc88 ffff880321e8f9e8
[  437.520153] Call Trace:
[  437.520153] dump_stack (lib/dump_stack.c:52)
[  437.520153] ubsan_epilogue (lib/ubsan.c:159)
[  437.520153] handle_overflow (lib/ubsan.c:191)
[  437.520153] ? printk (./arch/x86/include/asm/preempt.h:95 kernel/printk/printk.c:1863)
[  437.520153] __ubsan_handle_mul_overflow (lib/ubsan.c:218)
[  437.520153] select_task_rq_fair (kernel/sched/fair.c:4544 kernel/sched/fair.c:4758)
[  437.520153] ? get_parent_ip (kernel/sched/core.c:2564)
[  437.520153] ? get_parent_ip (kernel/sched/core.c:2564)
[  437.520153] try_to_wake_up (kernel/sched/core.c:1415 kernel/sched/core.c:1729)
[  437.520153] ? deactivate_slab (include/linux/spinlock.h:349 mm/slub.c:1940)
[  437.520153] default_wake_function (kernel/sched/core.c:2988)
[  437.520153] ? get_parent_ip (kernel/sched/core.c:2564)
[  437.520153] autoremove_wake_function (kernel/sched/wait.c:295)
[  437.520153] __wake_up_common (kernel/sched/wait.c:73)
[  437.520153] ? copy_page_to_iter (./arch/x86/include/asm/preempt.h:95 include/linux/uaccess.h:36 include/linux/highmem.h:75 mm/iov_iter.c:180 mm/iov_iter.c:432)
[  437.520153] __wake_up_sync_key (include/linux/spinlock.h:364 kernel/sched/wait.c:146)
[  437.520153] pipe_read (fs/pipe.c:317)
[  437.520153] ? do_sync_readv_writev (fs/read_write.c:396)
[  437.520153] do_iter_readv_writev (fs/read_write.c:681)
[  437.520153] do_readv_writev (fs/read_write.c:849)
[  437.520153] ? pipe_write (fs/pipe.c:231)
[  437.520153] ? acct_account_cputime (kernel/tsacct.c:168)
[  437.520153] ? preempt_count_sub (kernel/sched/core.c:2620)
[  437.520153] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[  437.520153] ? vtime_account_user (kernel/sched/cputime.c:701)
[  437.520153] vfs_readv (fs/read_write.c:881)
[  437.520153] SyS_readv (fs/read_write.c:907 fs/read_write.c:898)
[  437.520153] ? trace_hardirqs_on_thunk (arch/x86/lib/thunk_64.S:33)
[  437.520153] system_call_fastpath (arch/x86/kernel/entry_64.S:423)
[  437.520153] ================================================================================

So it's actually 'this_load' going bananas.


Thanks,
Sasha
