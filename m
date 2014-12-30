Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaL3BFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 20:05:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45281 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaL3BFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 20:05:14 -0500
Message-ID: <54A1FA24.1000009@oracle.com>
Date: Mon, 29 Dec 2014 20:04:36 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>
CC: Li Bin <huawei.libin@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, rui.xiang@huawei.com,
        wengmeiling.weng@huawei.com
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
References: <53B98709.3090603@oracle.com>	 <20140707083016.GA19379@twins.programming.kicks-ass.net>	 <53BAA6DF.5060409@oracle.com>	 <20140707200550.GA6758@twins.programming.kicks-ass.net>	 <549D03F6.9090607@huawei.com> <1419673927.8667.2.camel@stgolabs.net>	 <549ED5D7.8070007@oracle.com> <1419797834.8667.8.camel@stgolabs.net>
In-Reply-To: <1419797834.8667.8.camel@stgolabs.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2014 03:17 PM, Davidlohr Bueso wrote:
>> That is, what race condition specifically creates the
>> > 'lock->owner == current' situation in the debug check?
> Why do you suspect a race as opposed to a legitimate recursion issue?
> Although after staring at the code for a while, I cannot see foul play
> in sched_rr_get_interval.

Because it's not specific to sched_rr_get_interval. I've seen the same
error with different traces, and when the only common thing is the
spinlock debug output looking off then that's what I'm going to blame.

Here's an example of a completely sched-unrelated trace:

[ 1971.009744] BUG: spinlock lockup suspected on CPU#7, trinity-c436/29017
[ 1971.013170]  lock: 0xffff88016e0d8af0, .magic: dead4ead, .owner: trinity-c404/541, .owner_cpu: 12
[ 1971.017630] CPU: 7 PID: 29017 Comm: trinity-c436 Not tainted 3.19.0-rc1-next-20141226-sasha-00051-g2dd3d73-dirty #1639
[ 1971.023642]  0000000000000000 0000000000000000 ffff880102fe3000 ffff88014e923658
[ 1971.027654]  ffffffffb13501de 0000000000000055 ffff88016e0d8af0 ffff88014e923698
[ 1971.031716]  ffffffffa1588205 ffff88016e0d8af0 ffff88016e0d8b00 ffff88016e0d8af0
[ 1971.035695] Call Trace:
[ 1971.037081] dump_stack (lib/dump_stack.c:52)
[ 1971.040175] spin_dump (kernel/locking/spinlock_debug.c:68 (discriminator 8))
[ 1971.043138] do_raw_spin_lock (include/linux/nmi.h:48 kernel/locking/spinlock_debug.c:119 kernel/locking/spinlock_debug.c:137)
[ 1971.046155] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 1971.048801] ? __page_check_address (include/linux/spinlock.h:309 mm/rmap.c:633)
[ 1971.052152] __page_check_address (include/linux/spinlock.h:309 mm/rmap.c:633)
[ 1971.055129] try_to_unmap_one (include/linux/rmap.h:204 mm/rmap.c:1176)
[ 1971.057738] ? vma_interval_tree_iter_next (mm/interval_tree.c:24 (discriminator 4))
[ 1971.061181] rmap_walk (mm/rmap.c:1747 mm/rmap.c:1772)
[ 1971.062582] try_to_munlock (mm/rmap.c:1631)
[ 1971.064829] ? try_to_unmap_nonlinear (mm/rmap.c:1167)
[ 1971.068741] ? SyS_msync (mm/rmap.c:1546)
[ 1971.072252] ? page_get_anon_vma (mm/rmap.c:450)
[ 1971.074321] __munlock_isolated_page (mm/mlock.c:132)
[ 1971.075431] __munlock_pagevec (mm/mlock.c:388)
[ 1971.076345] ? munlock_vma_pages_range (include/linux/mm.h:906 mm/mlock.c:521)
[ 1971.077371] munlock_vma_pages_range (mm/mlock.c:533)
[ 1971.078339] exit_mmap (mm/internal.h:227 mm/mmap.c:2827)
[ 1971.079153] ? retint_restore_args (arch/x86/kernel/entry_64.S:844)
[ 1971.080197] ? __khugepaged_exit (./arch/x86/include/asm/atomic.h:118 include/linux/sched.h:2463 mm/huge_memory.c:2151)
[ 1971.081055] ? __khugepaged_exit (./arch/x86/include/asm/atomic.h:118 include/linux/sched.h:2463 mm/huge_memory.c:2151)
[ 1971.081915] mmput (kernel/fork.c:659)
[ 1971.082578] do_exit (./arch/x86/include/asm/thread_info.h:164 kernel/exit.c:438 kernel/exit.c:732)
[ 1971.083360] ? sched_clock_cpu (kernel/sched/clock.c:311)
[ 1971.084191] ? get_signal (kernel/signal.c:2338)
[ 1971.084984] ? _raw_spin_unlock_irq (./arch/x86/include/asm/paravirt.h:819 include/linux/spinlock_api_smp.h:168 kernel/locking/spinlock.c:199)
[ 1971.085862] do_group_exit (include/linux/sched.h:775 kernel/exit.c:858)
[ 1971.086659] get_signal (kernel/signal.c:2358)
[ 1971.087486] ? sched_clock_local (kernel/sched/clock.c:202)
[ 1971.088359] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
[ 1971.089142] do_signal (arch/x86/kernel/signal.c:703)
[ 1971.089896] ? vtime_account_user (kernel/sched/cputime.c:701)
[ 1971.090853] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:144 (discriminator 2))
[ 1971.091950] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
[ 1971.092806] do_notify_resume (arch/x86/kernel/signal.c:756)
[ 1971.093618] int_signal (arch/x86/kernel/entry_64.S:587)


Thanks,
Sasha
