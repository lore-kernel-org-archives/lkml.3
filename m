Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaAYFMz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 00:12:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaAYFMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 00:12:53 -0500
Message-ID: <1390626760.3625.17.camel@marge.simpson.net>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: paulmck@linux.vnet.ibm.com, linux-rt-users@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 25 Jan 2014 06:12:40 +0100
In-Reply-To: <20140124195014.GB29981@linutronix.de>
References: <20131221193900.GA8427@linutronix.de>
	 <1387681647.5412.25.camel@marge.simpson.net>
	 <1387702631.5412.101.camel@marge.simpson.net>
	 <1387773533.5369.16.camel@marge.simpson.net>
	 <20131224193636.GD19211@linux.vnet.ibm.com>
	 <1387940854.5373.8.camel@marge.simpson.net>
	 <20131225075544.GE19211@linux.vnet.ibm.com>
	 <1387993057.5346.17.camel@marge.simpson.net>
	 <20140117171441.GG5785@linutronix.de>
	 <1390015514.5444.46.camel@marge.simpson.net>
	 <20140124195014.GB29981@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:7J9LH2iDgq5VrBg5DIH53CzfCaDDQhlpaQ1htA/LGrk
 W4OMrLOo44DUy1LMwD4dwKerhHTZHCisrghPCcrU2Jyuuhvfvk
 gJgMo2U0Cwqx4tF4srgVSuV6EnxVVIOqoX1LvDmLH2rN/t96aG
 d4o9Ec8NAjIRog1tjlqbVykPZK2imNqk1RvBKclNOCGt1NXZd6
 uo0L6hFue9FPNUfaozXT60xSuH1f8vXlizlt1jXcEkSxlU0tum
 6jIKlZm+5MJ864SPnw+q3EzqCUH3oV6DYpnl3XQUCi6KD0wGBD
 oEXdRm6+YFAfz5zP+e79UyNMF+xuYzmw42xNaB9yv24W8pPW5J
 OxKi3GyFckAv4PsLu8stOnd4RTaIXGbMlGoQjOkLpTieK1CFGm
 3T74gtUCbbmeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-24 at 20:50 +0100, Sebastian Andrzej Siewior wrote: 
> * Mike Galbraith | 2014-01-18 04:25:14 [+0100]:
> 
> >> ># timers-do-not-raise-softirq-unconditionally.patch
> >> ># rtmutex-use-a-trylock-for-waiter-lock-in-trylock.patch
> >> >
> >> >..those two out does seem to have stabilized the thing.
> >> 
> >> timers-do-not-raise-softirq-unconditionally.patch is on its way out.
> >> 
> >> rtmutex-use-a-trylock-for-waiter-lock-in-trylock.patch confues me.
> >> Didn't you report once that your box deadlocks without this patch? Now
> >> your 64way box on the other hand does not work with it?
> >
> >If 'do not raise' is applied, 'use a trylock' won't save you.  If 'do
> is this just an observation or you do know why it won't save me?

It's an observation from beyond the grave from the 64 core box that it
repeatedly did NOT save :)  Autopsy photos below.

I've built 3.12.8-rt9 with Stevens v2 "timer: Raise softirq if there's
irq_work" to see if it'll survive.

nohz_full_all:
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

nohz_tick:
PID: 6948   TASK: ffff880272d1f1c0  CPU: 29  COMMAND: "tbench"
 #0 [ffff8802769a6a40] machine_kexec at ffffffff8103bc07
 #1 [ffff8802769a6aa0] crash_kexec at ffffffff810d3e93
 #2 [ffff8802769a6b70] panic at ffffffff815bce70
 #3 [ffff8802769a6bf0] watchdog_overflow_callback at ffffffff810fd51d
 #4 [ffff8802769a6c10] __perf_event_overflow at ffffffff8112f1f8
 #5 [ffff8802769a6ca0] perf_event_overflow at ffffffff8112fb14
 #6 [ffff8802769a6cb0] intel_pmu_handle_irq at ffffffff8102078f
 #7 [ffff8802769a6de0] perf_event_nmi_handler at ffffffff815c2de5
 #8 [ffff8802769a6e10] nmi_handle at ffffffff815c2493
 #9 [ffff8802769a6ea0] default_do_nmi at ffffffff815c2623
#10 [ffff8802769a6ed0] do_nmi at ffffffff815c2948
#11 [ffff8802769a6ef0] end_repeat_nmi at ffffffff815c1931
    [exception RIP: preempt_schedule+36]
    RIP: ffffffff815be944  RSP: ffff8802769a3d98  RFLAGS: 00000002
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000002
    RDX: ffff8802769a3d98  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff815be944   R8: ffffffff815be944   R9: 0000000000000018
    R10: ffff8802769a3d98  R11: 0000000000000002  R12: ffffffffffffffff
    R13: ffff880273f74000  R14: ffff880272d1f1c0  R15: ffff880269cedfd8
    ORIG_RAX: ffff880269cedfd8  CS: 0010  SS: 0018
--- <RT exception stack> ---
#12 [ffff8802769a3d98] preempt_schedule at ffffffff815be944
#13 [ffff8802769a3db0] _raw_spin_trylock at ffffffff815c0d6e
#14 [ffff8802769a3dc0] rt_spin_lock_slowunlock_hirq at ffffffff815c0288
#15 [ffff8802769a3de0] rt_spin_unlock_after_trylock_in_irq at ffffffff815c09e5
#16 [ffff8802769a3df0] run_local_timers at ffffffff81068025
#17 [ffff8802769a3e10] update_process_times at ffffffff810680ac
#18 [ffff8802769a3e40] tick_sched_handle at ffffffff810c3a92
#19 [ffff8802769a3e60] tick_sched_timer at ffffffff810c3d2f
#20 [ffff8802769a3e90] __run_hrtimer at ffffffff8108471d
#21 [ffff8802769a3ed0] hrtimer_interrupt at ffffffff8108497a
#22 [ffff8802769a3f70] local_apic_timer_interrupt at ffffffff810349e6
#23 [ffff8802769a3f90] smp_apic_timer_interrupt at ffffffff810358ee
#24 [ffff8802769a3fb0] apic_timer_interrupt at ffffffff815c955d
--- <IRQ stack> ---
#25 [ffff880269ced848] apic_timer_interrupt at ffffffff815c955d
    [exception RIP: _raw_spin_lock+53]
    RIP: ffffffff815c0c05  RSP: ffff880269ced8f8  RFLAGS: 00000202
    RAX: 0000000000000b7b  RBX: 0000000000000282  RCX: ffff880272d1f1c0
    RDX: 0000000000000b7d  RSI: ffff880269ceda38  RDI: ffff880273f74000
    RBP: ffff880269ced8f8   R8: 0000000000000001   R9: 00000000b54d13a4
    R10: 0000000000000001  R11: 0000000000000001  R12: ffff880269ced910
    R13: ffff880276d32170  R14: ffffffff810c9030  R15: ffff880269ced8b8
    ORIG_RAX: ffffffffffffff10  CS: 0010  SS: 0018
#26 [ffff880269ced900] rt_spin_lock_slowlock at ffffffff815bfb51
#27 [ffff880269ced9e0] rt_spin_lock at ffffffff815c0922
#28 [ffff880269ced9f0] lock_timer_base at ffffffff81067f92
#29 [ffff880269ceda20] mod_timer at ffffffff81069bcb
#30 [ffff880269ceda70] sk_reset_timer at ffffffff814d1e57
#31 [ffff880269ceda90] inet_csk_reset_xmit_timer at ffffffff8152d4a8
#32 [ffff880269cedac0] tcp_rearm_rto at ffffffff8152d583
#33 [ffff880269cedae0] tcp_ack at ffffffff81534085
#34 [ffff880269cedb60] tcp_rcv_established at ffffffff8153443d
#35 [ffff880269cedbb0] tcp_v4_do_rcv at ffffffff8153f56a
#36 [ffff880269cedbe0] __release_sock at ffffffff814d3891
#37 [ffff880269cedc10] release_sock at ffffffff814d3942
#38 [ffff880269cedc30] tcp_sendmsg at ffffffff8152b955
#39 [ffff880269cedd00] inet_sendmsg at ffffffff8155350e
#40 [ffff880269cedd30] sock_sendmsg at ffffffff814cea87
#41 [ffff880269cede40] sys_sendto at ffffffff814cebdf
#42 [ffff880269cedf80] tracesys at ffffffff815c8b09 (via system_call)
    RIP: 00007f0441a1fc35  RSP: 00007fffdea86130  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: ffffffff815c8b09  RCX: ffffffffffffffff
    RDX: 000000000000248d  RSI: 0000000000607260  RDI: 0000000000000004
    RBP: 000000000000248d   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007fffdea86a10
    R13: 00007fffdea86414  R14: 0000000000000004  R15: 0000000000607260
    ORIG_RAX: 000000000000002c  CS: 0033  SS: 002b

