Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaAQFRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 00:17:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaAQFR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 00:17:29 -0500
Message-ID: <1389935832.5449.23.camel@marge.simpson.net>
Subject: Re: [PATCH RT 4/8] rtmutex: use a trylock for waiter lock in trylock
From: Mike Galbraith <bitbucket@online.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Date: Fri, 17 Jan 2014 06:17:12 +0100
In-Reply-To: <20140116232228.0f3cfb89@gandalf.local.home>
References: <20140116015824.201732155@goodmis.org>
	 <20140116020324.637491369@goodmis.org>
	 <1389841737.5418.14.camel@marge.simpson.net>
	 <20140116232228.0f3cfb89@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Y4DoFzAB6mwvkzkGe9KgnnpP2rzhOlLBE3OTs2etzKq
 UC+8tV4rhCBllDNvLkjaTnnObm4gI9gw6Q0yaT2bAffrgNOrM3
 wH2Ejgw9B0kmgxihWbZQvkdAW0ixV7TpxqMxC0SDdnXs9eSNDK
 LvTftCRLBtnPYC7RlIZBCk4R0kGJMu+7kLysr7Pmld0NPy/ADT
 MJkYzSPYbBBHKiBnHKVoxwZKjN5eYDH544otzVLhdC7JmQQi0b
 m8KNuS5frIsZYbdMVBhNRLMg5ynuyFJ7EU7MTbka6++7hbJYlK
 4PLal25ChJ/hRhqIZa/Gk+cqN8jjzph+BQUCnYz1TtXkhv3Udc
 DvW124H/9nmNzlPTlhYiQbtt+QKphJm0g+Gjg36kRg0iajhMwx
 /bz2THrWPP0iA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 23:22 -0500, Steven Rostedt wrote: 
> On Thu, 16 Jan 2014 04:08:57 +0100
> Mike Galbraith <bitbucket@online.de> wrote:
> 
> > On Wed, 2014-01-15 at 20:58 -0500, Steven Rostedt wrote:
> > 
> > 
> > > 3.2.53-rt76-rc1 stable review patch.
> > > If anyone has any objections, please let me know.
> > 
> > Not sure this is needed without the tglx don't unconditionally raise
> > timer softirq patch, and with that patch applied in the form it exists
> > in 3.12-rt9, as well as this one, you'll still eventually deadlock.
> 
> Hmm, I'll have to take a look. This sounds to be missing from all the
> stable -rt kernels. I'll be pulling in the latest updates from 3.12-rt
> soon.

Below are the two deadlocks I encountered with 3.12-rt9, which has both
$subject and timers-do-not-raise-softirq-unconditionally.patch applied.

With bandaids applied, no others appeared.

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

Unrelated to this, just FYI, hotplug is still racy in -rt, though I'm
suspecting -rt isn't really to blame.  I'm trying to finger it out now.

Your stress script makes virgin -rt9 explode in get_group() ala below.
You can also end up accessing bad domain data in idle_balance().. 64
core box with no SMT enabled enters idle_balance(), and finds SIBLING
domain with groups of 0 weight, and promptly do /0 in that case. 

This is virgin source running on 64 core DL980.. well, virgin plus one
trace_printk() to help asm-challenged self find stuff on the stack.

[ 4466.495899] CPU: 9 PID: 63150 Comm: stress-cpu-hotp Tainted: GF            3.12.7-rt9 #240
[ 4466.495900] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
[ 4466.495901] task: ffff88026ddfbd40 ti: ffff880267486000 task.ti: ffff880267486000
[ 4466.495904] RIP: 0010:[<ffffffff8108c58f>]  [<ffffffff8108c58f>] get_group+0x4f/0x80
[ 4466.495905] RSP: 0018:ffff880267487b88  EFLAGS: 00010282                                                                                                                                                                                 
[ 4466.495906] RAX: 0000000000017390 RBX: ffff8802703aba48 RCX: 0000000000000100                                                                                                                                                            
[ 4466.495906] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000100                                                                                                                                                            
[ 4466.495907] RBP: ffff880267487b98 R08: 0000000000000100 R09: ffff880270215290                                                                                                                                                            
[ 4466.495908] R10: ffff880270215290 R11: 0000000000000007 R12: ffff880267487bc8                                                                                                                                                            
[ 4466.495909] R13: ffff880270215290 R14: ffff8802703aba48 R15: 0000000000000011
[ 4466.495910] FS:  00007fb8c9390700(0000) GS:ffff880276f20000(0000) knlGS:0000000000000000
[ 4466.495911] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4466.495912] CR2: 0000000000017390 CR3: 0000000265033000 CR4: 00000000000007e0
[ 4466.495913] Stack:
[ 4466.495917]  0000000000000012 00000000ffffffff ffff880267487bf8 ffffffff8108c6b0
[ 4466.495921]  ffff8802703aba00 ffff8802682d1b40 ffff8802648b3380 ffffffff8108d2da
[ 4466.495925]  ffff8802648b3380 ffff880270215200 0000000000000000 0000000000000000
[ 4466.495925] Call Trace:
[ 4466.495931]  [<ffffffff8108c6b0>] build_sched_groups+0xf0/0x200
[ 4466.495934]  [<ffffffff8108d2da>] ? build_sched_domain+0x5a/0xf0
[ 4466.495936]  [<ffffffff8108f7ca>] build_sched_domains+0x22a/0x490
[ 4466.495939]  [<ffffffff8108fbd1>] partition_sched_domains+0x1a1/0x3e0
[ 4466.495946]  [<ffffffff810dfcb2>] cpuset_update_active_cpus+0x12/0x30
[ 4466.495948]  [<ffffffff8108fe4c>] cpuset_cpu_active+0x3c/0x70
[ 4466.495954]  [<ffffffff815c987f>] notifier_call_chain+0x3f/0x80
[ 4466.495960]  [<ffffffff81085c09>] __raw_notifier_call_chain+0x9/0x10
[ 4466.495966]  [<ffffffff8105a138>] _cpu_up+0x158/0x170
[ 4466.495968]  [<ffffffff8105a3aa>] cpu_up+0xca/0x130
[ 4466.495974]  [<ffffffff815bcc26>] cpu_subsys_online+0x56/0xb0
[ 4466.495978]  [<ffffffff8141303d>] device_online+0x7d/0xa0
[ 4466.495982]  [<ffffffff814149b8>] online_store+0x78/0x80
[ 4466.495989]  [<ffffffff814124db>] dev_attr_store+0x1b/0x20
[ 4466.495996]  [<ffffffff8121ba35>] sysfs_write_file+0xc5/0x140
[ 4466.496003]  [<ffffffff811a0f27>] vfs_write+0xe7/0x190
[ 4466.496007]  [<ffffffff811a187d>] SyS_write+0x5d/0xa0
[ 4466.496012]  [<ffffffff815cd4b9>] system_call_fastpath+0x16/0x1b
[ 4466.496026] Code: 85 c0 74 13 48 8d b8 90 00 00 00 be 00 01 00 00 e8 c7 9d 29 00 89 c7 4d 85 e4 74 39 48 63 cf 48 8b 43 08 48 8b 14 cd 40 27 ab 81 <48> 8b 34 10 49 89 34 24 48 8b 14 cd 40 27 ab 81 48 8b 43 10 48 
[ 4466.496028] RIP  [<ffffffff8108c58f>] get_group+0x4f/0x80
[ 4466.496028]  RSP <ffff880267487b88>
[ 4466.496029] CR2: 0000000000017390

crash>  bt
PID: 63150  TASK: ffff88026ddfbd40  CPU: 9   COMMAND: "stress-cpu-hotp"
 #0 [ffff880267487790] machine_kexec at ffffffff8103b9e7
 #1 [ffff8802674877f0] crash_kexec at ffffffff810d3763
 #2 [ffff8802674878c0] oops_end at ffffffff815c6f58
 #3 [ffff8802674878f0] no_context at ffffffff81048529
 #4 [ffff880267487930] __bad_area_nosemaphore at ffffffff8104873d
 #5 [ffff880267487980] bad_area at ffffffff8104888c
 #6 [ffff8802674879b0] __do_page_fault at ffffffff815c97ac
 #7 [ffff880267487ac0] do_page_fault at ffffffff815c9839
 #8 [ffff880267487ad0] page_fault at ffffffff815c6348
    [exception RIP: get_group+79]                                               core.c:5721     *sg = *per_cpu_ptr(sdd->sg, cpu)
    RIP: ffffffff8108c58f  RSP: ffff880267487b88  RFLAGS: 00010282
    RAX: 0000000000017390  RBX: ffff8802703aba48  RCX: 0000000000000100
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000000100
    RBP: ffff880267487b98   R8: 0000000000000100   R9: ffff880270215290
    R10: ffff880270215290  R11: 0000000000000007  R12: ffff880267487bc8
    R13: ffff880270215290  R14: ffff8802703aba48  R15: 0000000000000011
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #9 [ffff880267487ba0] build_sched_groups at ffffffff8108c6b0                   core.c:5763     group = get_group(i, sdd, &sg);
#10 [ffff880267487c00] build_sched_domains at ffffffff8108f7ca                  core.c:6407     if (build_sched_groups(sd, i))
#11 [ffff880267487c50] partition_sched_domains at ffffffff8108fbd1              core.c:6608     build_sched_domains(doms_new[i], dattr_new ? dattr_new + i : NULL);
#12 [ffff880267487d00] cpuset_update_active_cpus at ffffffff810dfcb2            cpuset.c:2286   partition_sched_domains(1, NULL, NULL);
#13 [ffff880267487d10] cpuset_cpu_active at ffffffff8108fe4c                    core.c:6662     cpuset_update_active_cpus(true);
#14 [ffff880267487d20] notifier_call_chain at ffffffff815c987f
#15 [ffff880267487d60] __raw_notifier_call_chain at ffffffff81085c09
#16 [ffff880267487d70] _cpu_up at ffffffff8105a138
#17 [ffff880267487dc0] cpu_up at ffffffff8105a3aa
#18 [ffff880267487df0] cpu_subsys_online at ffffffff815bcc26
#19 [ffff880267487e30] device_online at ffffffff8141303d
#20 [ffff880267487e60] online_store at ffffffff814149b8
#21 [ffff880267487e90] dev_attr_store at ffffffff814124db
#22 [ffff880267487ea0] sysfs_write_file at ffffffff8121ba35
#23 [ffff880267487ef0] vfs_write at ffffffff811a0f27
#24 [ffff880267487f20] sys_write at ffffffff811a187d
#25 [ffff880267487f80] system_call_fastpath at ffffffff815cd4b9
    RIP: 00007fb8c8ab31f0  RSP: 00007fff96a6f348  RFLAGS: 00000246
    RAX: 0000000000000001  RBX: ffffffff815cd4b9  RCX: ffffffffffffffff
    RDX: 0000000000000002  RSI: 00007fb8c93b9000  RDI: 0000000000000001
    RBP: 00007fb8c93b9000   R8: 00007fb8c9390700   R9: 00007fb8c8d59e30
    R10: 00007fb8c8d59e30  R11: 0000000000000246  R12: 0000000000000000
    R13: 00007fff96a6f470  R14: 0000000000000002  R15: 00007fb8c8d587a0
    ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

