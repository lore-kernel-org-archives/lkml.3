Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3LXPsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 10:48:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49858 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3LXPr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 10:47:58 -0500
Message-ID: <1387900067.5490.33.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Tue, 24 Dec 2013 16:47:47 +0100
In-Reply-To: <20131223225017.GA8623@linutronix.de>
References: <20131223225017.GA8623@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:yYLomq4LEElRkhFr9M3wNapop6tr6c9QBKEhtFRhlE8
 0dcU4+PlqNvpj+d09Ka4fppf7G95Zm5AwMNwpZdBMWDx/7hpXY
 WkR4s+0tuTVIREMLSCAhvop0pCiTdexLq8TB3CSJXbfguZ1CVX
 HmWS/c26sbbK2/8aT8npQ9AqKRyvBGHMK2AqaoreCNZxzmv2MY
 JqFZWORSwzpZWkOHxNDP0Xl1JI43H6/B1ml+Kk6H9tiq6S6UIZ
 RgrhXEe+y8Ez7rl7+XBBWBFEC1bPruLAxrXcsHFj6DKa79fugn
 gxEnLEl94f93RwSG/XSpjhs19Dnus6spCC7S3KYbsHHVm7poVD
 fvisYZkP7uGYWa+bQhGjkcNix4cIEOrz8tZLrZpg8gyK1eg413
 HwEQvMjFLJ1eQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 23:50 +0100, Sebastian Andrzej Siewior wrote: 
> Dear RT folks!
> 
> I'm pleased to announce the v3.12.6-rt9 patch set.
> 
> Changes since v3.12.6-rt8
> - ARM's mach-sti is now using rawlock as boot_lock (like the other
>   mach-*)
> - There was a callpath to rcu_preempt_qs() with interrupts enabled. Tiejun
>   Chen posted a patch to call it with interrupt disabled like we always
>   do.
> - A patch from Paul E. McKenney to not activate RCU core on NO_HZ_FULL
>   CPUs
> - A patch from Thomas Gleixner not to raise the timer softirq
>   unconditionally (only if a timer is pending)
> 
> 
> There is also a patch in the queue from Paul E. McKenney to move RCU
> processing from softirq into its own thread. After Mike Galbraith
> reported a few RCU stalls I decided to keep it disabled for now until I
> have some time to look at it.

I built this kernel with Paul's patch and NO_HZ_FULL enabled again on 64
core box.  I haven't seen RCU grip yet, but I just checked on it after
3.5 hours into this boot/beat (after fixing crash+kdump setup), and
found it in the process of dumping. 

crash> bt
PID: 508    TASK: ffff8802739ba340  CPU: 16  COMMAND: "ksoftirqd/16"
 #0 [ffff880276806a40] machine_kexec at ffffffff8103bc07
 #1 [ffff880276806aa0] crash_kexec at ffffffff810d56b3
 #2 [ffff880276806b70] panic at ffffffff815bf8b0
 #3 [ffff880276806bf0] watchdog_overflow_callback at ffffffff810fed3d
 #4 [ffff880276806c10] __perf_event_overflow at ffffffff81131928
 #5 [ffff880276806ca0] perf_event_overflow at ffffffff81132254
 #6 [ffff880276806cb0] intel_pmu_handle_irq at ffffffff8102078f
 #7 [ffff880276806de0] perf_event_nmi_handler at ffffffff815c5825
 #8 [ffff880276806e10] nmi_handle at ffffffff815c4ed3
 #9 [ffff880276806ea0] default_do_nmi at ffffffff815c5063
#10 [ffff880276806ed0] do_nmi at ffffffff815c5388
#11 [ffff880276806ef0] end_repeat_nmi at ffffffff815c4371
    [exception RIP: _raw_spin_trylock+48]
    RIP: ffffffff815c3790  RSP: ffff880276803e28  RFLAGS: 00000002
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000002
    RDX: ffff880276803e28  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff815c3790   R8: ffffffff815c3790   R9: 0000000000000018
    R10: ffff880276803e28  R11: 0000000000000002  R12: ffffffffffffffff
    R13: ffff880273a0c000  R14: ffff8802739ba340  R15: ffff880273a03fd8
    ORIG_RAX: ffff880273a03fd8  CS: 0010  SS: 0018
--- <RT exception stack> ---
#12 [ffff880276803e28] _raw_spin_trylock at ffffffff815c3790
#13 [ffff880276803e30] rt_spin_lock_slowunlock_hirq at ffffffff815c2cc8
#14 [ffff880276803e50] rt_spin_unlock_after_trylock_in_irq at ffffffff815c3425
#15 [ffff880276803e60] get_next_timer_interrupt at ffffffff810684a7
#16 [ffff880276803ed0] tick_nohz_stop_sched_tick at ffffffff810c5f2e
#17 [ffff880276803f50] tick_nohz_irq_exit at ffffffff810c6333
#18 [ffff880276803f70] irq_exit at ffffffff81060065
#19 [ffff880276803f90] smp_apic_timer_interrupt at ffffffff810358f5
#20 [ffff880276803fb0] apic_timer_interrupt at ffffffff815cbf9d
--- <IRQ stack> ---
#21 [ffff880273a03b28] apic_timer_interrupt at ffffffff815cbf9d
    [exception RIP: _raw_spin_lock+50]
    RIP: ffffffff815c3642  RSP: ffff880273a03bd8  RFLAGS: 00000202
    RAX: 0000000000008b49  RBX: ffff880272157290  RCX: ffff8802739ba340
    RDX: 0000000000008b4a  RSI: 0000000000000010  RDI: ffff880273a0c000
    RBP: ffff880273a03bd8   R8: 0000000000000001   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000001  R12: ffffffff810927b5
    R13: ffff880273a03b68  R14: 0000000000000010  R15: 0000000000000010
    ORIG_RAX: ffffffffffffff10  CS: 0010  SS: 0018
#22 [ffff880273a03be0] rt_spin_lock_slowlock at ffffffff815c2591
#23 [ffff880273a03cc0] rt_spin_lock at ffffffff815c3362
#24 [ffff880273a03cd0] run_timer_softirq at ffffffff81069002
#25 [ffff880273a03d70] handle_softirq at ffffffff81060d0f
#26 [ffff880273a03db0] do_current_softirqs at ffffffff81060f3c
#27 [ffff880273a03e20] run_ksoftirqd at ffffffff81061045
#28 [ffff880273a03e40] smpboot_thread_fn at ffffffff81089c31
#29 [ffff880273a03ec0] kthread at ffffffff810807fe
#30 [ffff880273a03f50] ret_from_fork at ffffffff815cb28c
crash> gdb list *0xffffffff815c2591
0xffffffff815c2591 is in rt_spin_lock_slowlock (kernel/rtmutex.c:109).
104     }
105     #endif
106     
107     static inline void init_lists(struct rt_mutex *lock)
108     {
109             if (unlikely(!lock->wait_list.node_list.prev))
110                     plist_head_init(&lock->wait_list);
111     }
112     
113     /*
crash> gdb list *0xffffffff815c2590
0xffffffff815c2590 is in rt_spin_lock_slowlock (kernel/rtmutex.c:744).
739             struct rt_mutex_waiter waiter, *top_waiter;
740             int ret;
741     
742             rt_mutex_init_waiter(&waiter, true);
743     
744             raw_spin_lock(&lock->wait_lock);
745             init_lists(lock);
746     
747             if (__try_to_take_rt_mutex(lock, self, NULL, STEAL_LATERAL)) {
748                     raw_spin_unlock(&lock->wait_lock);
crash> gdb list *0xffffffff815c2cc8
0xffffffff815c2cc8 is in rt_spin_lock_slowunlock_hirq (kernel/rtmutex.c:851).
846     {
847             int ret;
848     
849             do {
850                     ret = raw_spin_trylock(&lock->wait_lock);
851             } while (!ret);
852     
853             __rt_spin_lock_slowunlock(lock);
854     }
855

Dang, Santa might have delivered a lock pick set in a few more hours.

