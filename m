Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaLNXrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 18:47:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48390 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaLNXrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 18:47:16 -0500
Message-ID: <548E214D.6040706@oracle.com>
Date: Sun, 14 Dec 2014 18:46:21 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@kernel.org>, David Lang <david@lang.hm>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?windows-1252?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141211145408.GB16800@redhat.com> <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com> <20141212185454.GB4716@redhat.com> <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com> <alpine.DEB.2.02.1412121157060.18579@nftneq.ynat.uz> <20141212203417.GE25340@linux.vnet.ibm.com> <548B5CEC.1040607@oracle.com> <20141213083055.GI32572@gmail.com> <548C60FF.9020607@oracle.com> <20141213180752.GI25340@linux.vnet.ibm.com> <20141214175007.GA6927@linux.vnet.ibm.com>
In-Reply-To: <20141214175007.GA6927@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2014 12:50 PM, Paul E. McKenney wrote:
> rcu: Make cond_resched_rcu_qs() apply to normal RCU flavors
> 
> Although cond_resched_rcu_qs() only applies to TASKS_RCU, it is used
> in places where it would be useful for it to apply to the normal RCU
> flavors, rcu_preempt, rcu_sched, and rcu_bh.  This is especially the
> case for workloads that aggressively overload the system, particularly
> those that generate large numbers of RCU updates on systems running
> NO_HZ_FULL CPUs.  This commit therefore communicates quiescent states
> from cond_resched_rcu_qs() to the normal RCU flavors.
> 
> Note that it is unfortunately necessary to leave the old ->passed_quiesce
> mechanism in place to allow quiescent states that apply to only one
> flavor to be recorded.  (Yes, we could decrement ->rcu_qs_ctr_snap in
> that case, but that is not so good for debugging of RCU internals.)
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Does it depend on anything not currently in -next? My build fails with

kernel/rcu/tree.c: In function ‘rcu_report_qs_rdp’:
kernel/rcu/tree.c:2099:6: error: ‘struct rcu_data’ has no member named ‘gpwrap’
   rdp->gpwrap) {
      ^

On an unrelated subject, I've tried disabling preemption, and am seeing different
stalls even when I have the testfiles fuzzing in trinity disabled (which means I'm
not seeing hangs in the preempt case):

[  332.920142] INFO: rcu_sched self-detected stall on CPU
[  332.920142] 	19: (2099 ticks this GP) idle=f7d/140000000000001/0 softirq=21726/21726 fqs=1751
[  332.920142] 	 (t=2100 jiffies g=10656 c=10655 q=212427)
[  332.920142] Task dump for CPU 19:
[  332.920142] trinity-c522    R  running task    13544  9447   8279 0x1008000a
[  332.920142]  00000000000034e8 00000000000034e8 ffff8808a678a000 ffff8808bc203c18
[  332.920142]  ffffffff814b66f6 dfffe900000054de 0000000000000013 ffff8808bc215800
[  332.920142]  0000000000000013 ffffffff9cb5d018 dfffe90000000000 ffff8808bc203c48
[  332.920142] Call Trace:
[  332.920142] <IRQ> sched_show_task (kernel/sched/core.c:4541)
[  332.920142] dump_cpu_task (kernel/sched/core.c:8383)
[  332.940081] INFO: rcu_sched detected stalls on CPUs/tasks:
[  332.920142] rcu_dump_cpu_stacks (kernel/rcu/tree.c:1093)
[  332.920142] rcu_check_callbacks (kernel/rcu/tree.c:1199 kernel/rcu/tree.c:1261 kernel/rcu/tree.c:3194 kernel/rcu/tree.c:3254 kernel/rcu/tree.c:2507)
[  332.920142] update_process_times (./arch/x86/include/asm/preempt.h:22 kernel/time/timer.c:1386)
[  332.920142] tick_sched_timer (kernel/time/tick-sched.c:152 kernel/time/tick-sched.c:1128)
[  332.920142] __run_hrtimer (kernel/time/hrtimer.c:1216 (discriminator 3))
[  332.920142] ? tick_init_highres (kernel/time/tick-sched.c:1115)
[  332.920142] hrtimer_interrupt (include/linux/timerqueue.h:37 kernel/time/hrtimer.c:1275)
[  332.920142] ? acct_account_cputime (kernel/tsacct.c:168)
[  332.920142] local_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:921)
[  332.920142] smp_apic_timer_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/apic/apic.c:945)
[  332.920142] apic_timer_interrupt (arch/x86/kernel/entry_64.S:983)
[  332.920142] <EOI> ? retint_restore_args (arch/x86/kernel/entry_64.S:844)
[  332.920142] ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
[  332.920142] __debug_check_no_obj_freed (lib/debugobjects.c:713)
[  332.920142] debug_check_no_obj_freed (lib/debugobjects.c:727)
[  332.920142] free_pages_prepare (mm/page_alloc.c:829)
[  332.920142] free_hot_cold_page (mm/page_alloc.c:1496)
[  332.920142] __free_pages (mm/page_alloc.c:2982)
[  332.920142] ? __vunmap (mm/vmalloc.c:1459 (discriminator 2))
[  332.920142] __vunmap (mm/vmalloc.c:1455 (discriminator 2))
[  332.920142] vfree (mm/vmalloc.c:1500)
[  332.920142] SyS_init_module (kernel/module.c:2483 kernel/module.c:3359 kernel/module.c:3346)
[  332.920142] ia32_do_call (arch/x86/ia32/ia32entry.S:446)


Thanks,
Sasha
