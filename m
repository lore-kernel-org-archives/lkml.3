Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbaLMQ77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 11:59:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095AbaLMQ75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 11:59:57 -0500
Date: Sat, 13 Dec 2014 11:59:15 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141213165915.GA12756@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 11:14:06AM -0800, Linus Torvalds wrote:
 > On Fri, Dec 12, 2014 at 10:54 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > Something that's still making me wonder if it's some kind of hardware
 > > problem is the non-deterministic nature of this bug.
 > 
 > I'd expect it to be a race condition, though. Which can easily cause
 > these kinds of issues, and the timing will be pretty random even if
 > the load is very regular.
 > 
 > And we know that the scheduler has an integer overflow under Sasha's
 > loads, although I didn't hear anything from Ingo and friends about it.
 > Ingo/Peter, you were cc'd on that report, where at least one of the
 > multiplcations in wake_affine() ended up overflowing..
 > 
 > Some scheduler thing that overflows only under heavy load, and screws
 > up scheduling could easily account for the RCU thread thing. I see it
 > *less* easily accounting for DaveJ's case, though, because the
 > watchdog is running at RT priority,  and the scheduler would have to
 > screw up much more to then not schedule an RT task, but..
 > 
 > I'm also not sure if the bug ever happens with preemption disabled.

Bah, so I see some watchdog traces with preemption off, and that then
taints the kernel, and the fuzzing stops.  I'll hack something up
so it ignores the taint and keeps going. All I really care about here
is the "machine hangs completely" case, which the trace below didn't
hit..

(back to fuzzing almost everything, not just lsetxattr btw)

[34917.468470] WARNING: CPU: 1 PID: 9226 at kernel/watchdog.c:317 watchdog_overflow_callback+0x9c/0xd0()
[34917.468500] Watchdog detected hard LOCKUP on cpu 1
[34917.468516] CPU: 1 PID: 9226 Comm: trinity-c107 Not tainted 3.18.0+ #102 
[34917.468542] [loadavg: 155.62 139.10 140.12 10/405 11756]
[34917.468559]  ffffffff81a65d99 000000005606cf60 ffff880244205b98 ffffffff817c4f75
[34917.468591]  ffffffff810cd5a1 ffff880244205bf0 ffff880244205bd8 ffffffff81077cb1
[34917.468623]  ffff880244205bd8 ffff880243c55388 0000000000000000 ffff880244205d30
[34917.468655] Call Trace:
[34917.468667]  <NMI>  [<ffffffff817c4f75>] dump_stack+0x4e/0x68
[34917.468696]  [<ffffffff810cd5a1>] ? console_unlock+0x1f1/0x4e0
[34917.468718]  [<ffffffff81077cb1>] warn_slowpath_common+0x81/0xa0
[34917.468740]  [<ffffffff81077d25>] warn_slowpath_fmt+0x55/0x70
[34917.468761]  [<ffffffff817c3710>] ? __slab_alloc+0x3c4/0x58f
[34917.468783]  [<ffffffff8112bce0>] ? restart_watchdog_hrtimer+0x60/0x60
[34917.468806]  [<ffffffff8112bd7c>] watchdog_overflow_callback+0x9c/0xd0
[34917.468830]  [<ffffffff8116ebed>] __perf_event_overflow+0x9d/0x2a0
[34917.468856]  [<ffffffff8116d7c3>] ? perf_event_update_userpage+0x103/0x180
[34917.469785]  [<ffffffff8116d6c0>] ? perf_event_task_disable+0x90/0x90
[34917.470705]  [<ffffffff8116f7c4>] perf_event_overflow+0x14/0x20
[34917.471632]  [<ffffffff8101e749>] intel_pmu_handle_irq+0x1f9/0x3f0
[34917.472553]  [<ffffffff81017cbb>] perf_event_nmi_handler+0x2b/0x50
[34917.473459]  [<ffffffff81007330>] nmi_handle+0xc0/0x1b0
[34917.474355]  [<ffffffff81007275>] ? nmi_handle+0x5/0x1b0
[34917.475245]  [<ffffffff8100761a>] default_do_nmi+0x4a/0x140
[34917.476128]  [<ffffffff810077d0>] do_nmi+0xc0/0x100
[34917.477012]  [<ffffffff817d237a>] end_repeat_nmi+0x1e/0x2e
[34917.477902]  [<ffffffff81383a37>] ? debug_check_no_obj_freed+0xe7/0x250
[34917.478788]  [<ffffffff81383a37>] ? debug_check_no_obj_freed+0xe7/0x250
[34917.479660]  [<ffffffff81383a37>] ? debug_check_no_obj_freed+0xe7/0x250
[34917.480523]  <<EOE>>  [<ffffffff8117b87f>] free_pages_prepare+0x1af/0x240
[34917.481396]  [<ffffffff8117dd51>] __free_pages_ok+0x21/0x100
[34917.482270]  [<ffffffff8117de4b>] free_compound_page+0x1b/0x20
[34917.483144]  [<ffffffff81184d23>] __put_compound_page+0x23/0x30
[34917.484022]  [<ffffffff81184da8>] put_compound_page+0x48/0x2e0
[34917.484895]  [<ffffffff811854d9>] release_pages+0x239/0x270
[34917.485768]  [<ffffffff811b9d1d>] free_pages_and_swap_cache+0x8d/0xa0
[34917.486648]  [<ffffffff811a25d4>] tlb_flush_mmu_free+0x34/0x60
[34917.487530]  [<ffffffff811a4021>] unmap_single_vma+0x6d1/0x900
[34917.488405]  [<ffffffff811a4d51>] unmap_vmas+0x51/0xa0
[34917.489277]  [<ffffffff811ae175>] exit_mmap+0xe5/0x1a0
[34917.490143]  [<ffffffff81074d6b>] mmput+0x6b/0x100
[34917.490995]  [<ffffffff810792ae>] do_exit+0x29e/0xb60
[34917.491823]  [<ffffffff8107abfc>] do_group_exit+0x4c/0xc0
[34917.492645]  [<ffffffff8107ac84>] SyS_exit_group+0x14/0x20
[34917.493462]  [<ffffffff817d0589>] tracesys_phase2+0xd4/0xd9
[34917.494268] ---[ end trace c48441b18b6523a2 ]---
[34917.495171] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 26.690 msecs
[34917.496031] perf interrupt took too long (211387 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[34967.056860] INFO: rcu_sched detected stalls on CPUs/tasks:
[34967.057898] 	1: (0 ticks this GP) idle=b4c/0/0 softirq=2168971/2168971 
[34967.058900] 	(detected by 2, t=6002 jiffies, g=1058044, c=1058043, q=0)
[34967.059867] Task dump for CPU 1:
[34967.060827] swapper/1       R  running task    14576     0      1 0x00200000
[34967.061802]  0000000142b4be38 4a979bec19cdc3d2 ffffe8ffff003200 0000000000000003
[34967.062786]  ffffffff81cb1b80 0000000000000001 ffff880242b4be88 ffffffff8165ff65
[34967.063759]  00001fcecca713d2 ffffffff81cb1ca0 ffffffff81cb1b80 ffffffff81d215b0
[34967.064721] Call Trace:
[34967.065649]  [<ffffffff8165ff65>] ? cpuidle_enter_state+0x55/0x190
[34967.066570]  [<ffffffff81660157>] ? cpuidle_enter+0x17/0x20
[34967.067498]  [<ffffffff810bd6c5>] ? cpu_startup_entry+0x355/0x410
[34967.068425]  [<ffffffff8103016a>] ? start_secondary+0x1aa/0x230
[35027.731690] INFO: rcu_sched detected stalls on CPUs/tasks:
[35027.732701] 	1: (0 ticks this GP) idle=b82/0/0 softirq=2168971/2168971 
[35027.733652] 	(detected by 2, t=6002 jiffies, g=1058047, c=1058046, q=0)
[35027.734593] Task dump for CPU 1:
[35027.735514] swapper/1       R  running task    14576     0      1 0x00200000
[35027.736445]  0000000142b4be38 4a979bec19cdc3d2 ffffe8ffff003200 0000000000000004
[35027.737369]  ffffffff81cb1b80 0000000000000001 ffff880242b4be88 ffffffff8165ff65
[35027.738285]  00001fde808fc8c8 ffffffff81cb1cf8 ffffffff81cb1b80 ffffffff81d215b0
[35027.739206] Call Trace:
[35027.740114]  [<ffffffff8165ff65>] ? cpuidle_enter_state+0x55/0x190
[35027.741032]  [<ffffffff81660157>] ? cpuidle_enter+0x17/0x20
[35027.741949]  [<ffffffff810bd6c5>] ? cpu_startup_entry+0x355/0x410
[35027.742858]  [<ffffffff8103016a>] ? start_secondary+0x1aa/0x230
[35982.698415] perf interrupt took too long (209762 > 10000), lowering kernel.perf_event_max_sample_rate to 12500
[37306.241794] perf interrupt took too long (208160 > 19841), lowering kernel.perf_event_max_sample_rate to 6300
[38626.487390] perf interrupt took too long (206565 > 39062), lowering kernel.perf_event_max_sample_rate to 3200
[39781.429034] perf interrupt took too long (204990 > 78125), lowering kernel.perf_event_max_sample_rate to 1600
[41041.380281] perf interrupt took too long (203427 > 156250), lowering kernel.perf_event_max_sample_rate to 800

