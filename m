Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaLMWhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 17:37:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbaLMWhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 17:37:00 -0500
Date: Sat, 13 Dec 2014 17:36:16 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141213223616.GA22559@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141213165915.GA12756@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 11:59:15AM -0500, Dave Jones wrote:
 > On Fri, Dec 12, 2014 at 11:14:06AM -0800, Linus Torvalds wrote:
 >  > On Fri, Dec 12, 2014 at 10:54 AM, Dave Jones <davej@redhat.com> wrote:
 >  > >
 >  > > Something that's still making me wonder if it's some kind of hardware
 >  > > problem is the non-deterministic nature of this bug.
 >  > 
 >  > I'd expect it to be a race condition, though. Which can easily cause
 >  > these kinds of issues, and the timing will be pretty random even if
 >  > the load is very regular.
 >  > 
 >  > And we know that the scheduler has an integer overflow under Sasha's
 >  > loads, although I didn't hear anything from Ingo and friends about it.
 >  > Ingo/Peter, you were cc'd on that report, where at least one of the
 >  > multiplcations in wake_affine() ended up overflowing..
 >  > 
 >  > Some scheduler thing that overflows only under heavy load, and screws
 >  > up scheduling could easily account for the RCU thread thing. I see it
 >  > *less* easily accounting for DaveJ's case, though, because the
 >  > watchdog is running at RT priority,  and the scheduler would have to
 >  > screw up much more to then not schedule an RT task, but..
 >  > 
 >  > I'm also not sure if the bug ever happens with preemption disabled.
 > 
 > Bah, so I see some watchdog traces with preemption off, and that then
 > taints the kernel, and the fuzzing stops.  I'll hack something up
 > so it ignores the taint and keeps going. All I really care about here
 > is the "machine hangs completely" case, which the trace below didn't
 > hit..

Ok, I think we can rule out preemption. I just checked on it, and
found it wedged.  Here's what I got over usb-serial.
(tainting was from previous post).

[76132.505590] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [trinity-c8:19387]
[76132.506438] CPU: 3 PID: 19387 Comm: trinity-c8 Tainted: G        W      3.18.0+ #102 [loadavg: 148.33 137.64 140.62 48/406 19489]
[76132.507293] task: ffff880226a9ada0 ti: ffff8801aee08000 task.ti: ffff8801aee08000
[76132.508149] RIP: 0010:[<ffffffff81045d3c>]  [<ffffffff81045d3c>] kernel_map_pages+0xbc/0x120
[76132.509022] RSP: 0000:ffff8801aee0ba08  EFLAGS: 00000202
[76132.509889] RAX: 00000000001407e0 RBX: 0000000000000000 RCX: 0000000000140760
[76132.510760] RDX: 0000000000000202 RSI: ffff880000000188 RDI: 0000000000000001
[76132.511636] RBP: ffff8801aee0ba68 R08: 8000000000000063 R09: ffff880000000000
[76132.512512] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[76132.513394] R13: 0000000000000000 R14: 0000000001b5f000 R15: 0000000000000000
[76132.514269] FS:  00007fb1263cc740(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
[76132.515152] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[76132.516055] CR2: 000000000277dff8 CR3: 0000000233290000 CR4: 00000000001407e0
[76132.516957] DR0: 00007f07ef05a000 DR1: 00007fb7761bb000 DR2: 0000000000000000
[76132.517858] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[76132.518757] Stack:
[76132.519650]  ffff880097a32000 ffff8801aee0ba08 0000000000000000 0000000000000003
[76132.520590]  0000000000000000 0000000100000001 0000000000097a31 0000000000000000
[76132.521530]  0000000000000000 0000000078052420 ffff8802447d7348 0000000000000001
[76132.522447] Call Trace:
[76132.523359]  [<ffffffff8117f9d4>] get_page_from_freelist+0x4a4/0xaa0
[76132.524281]  [<ffffffff811801fe>] __alloc_pages_nodemask+0x22e/0xb40
[76132.525205]  [<ffffffff810abb55>] ? local_clock+0x25/0x30
[76132.526135]  [<ffffffff810c518c>] ? __lock_acquire.isra.31+0x22c/0x9f0
[76132.527065]  [<ffffffff8118545d>] ? release_pages+0x1bd/0x270
[76132.528004]  [<ffffffff810c367f>] ? lock_release_holdtime.part.24+0xf/0x190
[76132.528944]  [<ffffffff811c941e>] alloc_pages_vma+0xee/0x1b0
[76132.529883]  [<ffffffff811a465a>] ? do_wp_page+0xca/0x770
[76132.530823]  [<ffffffff8109faff>] ? __might_sleep+0x1f/0x140
[76132.531770]  [<ffffffff811a465a>] do_wp_page+0xca/0x770
[76132.532705]  [<ffffffff811a6eab>] handle_mm_fault+0x6cb/0xe90
[76132.533633]  [<ffffffff810423f8>] ? __do_page_fault+0x198/0x5c0
[76132.534561]  [<ffffffff8104245c>] __do_page_fault+0x1fc/0x5c0
[76132.535465]  [<ffffffff817cf790>] ? _raw_spin_unlock_irq+0x30/0x40
[76132.536372]  [<ffffffff8109f2bd>] ? finish_task_switch+0x7d/0x120
[76132.537269]  [<ffffffff8109f27f>] ? finish_task_switch+0x3f/0x120
[76132.538154]  [<ffffffff817c9822>] ? __schedule+0x352/0x8c0
[76132.539043]  [<ffffffff8137576d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[76132.539921]  [<ffffffff8104282c>] do_page_fault+0xc/0x10
[76132.540791]  [<ffffffff817d1fb2>] page_fault+0x22/0x30
[76132.541654] Code: 65 48 33 04 25 28 00 00 00 75 75 48 83 c4 50 5b 41 5c 5d c3 0f 1f 00 9c 5a fa 0f 20 e0 48 89 c1 80 e1 7f 0f 22 e1 0f 22 e0 52 9d <eb> cf 66 90 49 bc 00 00 00 00 00 88 ff ff 48 63 f6 49 01 fc 48 
[76132.543541] sending NMI to other CPUs:
[76132.544438] NMI backtrace for cpu 1
[76132.545300] CPU: 1 PID: 17326 Comm: trinity-c93 Tainted: G        W      3.18.0+ #102 [loadavg: 148.33 137.64 140.62 48/406 19489]
[76132.546193] task: ffff8800098b2da0 ti: ffff8801aec38000 task.ti: ffff8801aec38000
[76132.547085] RIP: 0010:[<ffffffff810c50a2>]  [<ffffffff810c50a2>] __lock_acquire.isra.31+0x142/0x9f0
[76132.547987] RSP: 0018:ffff8801aec3bd58  EFLAGS: 00000082
[76132.548883] RAX: 0000000000000000 RBX: ffff8800098b2da0 RCX: 0000000000000002
[76132.549786] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81c0a098
[76132.550683] RBP: ffff8801aec3bdc8 R08: 0000000000000000 R09: 0000000000000000
[76132.551576] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff825a4ab0
[76132.552462] R13: 0000000000000000 R14: ffffffff81c0a098 R15: 0000000000000000
[76132.553347] FS:  00007fb1263cc740(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
[76132.554237] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[76132.555118] CR2: 00007fc56b68e000 CR3: 0000000176d68000 CR4: 00000000001407e0
[76132.556014] DR0: 00007f07ef05a000 DR1: 00007fb7761bb000 DR2: 0000000000000000
[76132.556908] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[76132.557805] Stack:
[76132.558679]  ffff8801aec3bdd8 0000000000000046 0000000000000000 0000000000000000
[76132.559582]  0000000000000000 0000000000000000 ffff8801aec3bdf8 0000000000000046
[76132.560486]  0000000000000000 0000000000000246 0000000000000000 0000000000000000
[76132.561394] Call Trace:
[76132.562285]  [<ffffffff810c605f>] lock_acquire+0x9f/0x120
[76132.563172]  [<ffffffff8107a939>] ? do_wait+0xd9/0x280
[76132.564038]  [<ffffffff817cf851>] _raw_read_lock+0x41/0x80
[76132.564891]  [<ffffffff8107a939>] ? do_wait+0xd9/0x280
[76132.565734]  [<ffffffff8107a939>] do_wait+0xd9/0x280
[76132.566566]  [<ffffffff8107af00>] SyS_wait4+0x80/0x110
[76132.567389]  [<ffffffff810789e0>] ? task_stopped_code+0x60/0x60
[76132.568220]  [<ffffffff817d0392>] system_call_fastpath+0x12/0x17
[76132.569044] Code: 00 00 45 31 ed e9 f3 01 00 00 0f 1f 80 00 00 00 00 44 89 e8 4d 8b 64 c6 08 4d 85 e4 0f 84 21 ff ff ff f0 41 ff 84 24 98 01 00 00 <8b> 3d 70 31 ab 01 44 8b ab 68 07 00 00 85 ff 75 0a 41 83 fd 2f 
[76132.570883] NMI backtrace for cpu 2
[76132.570886] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 26.444 msecs
[76132.572634] CPU: 2 PID: 18775 Comm: trinity-c59 Tainted: G        W      3.18.0+ #102 [loadavg: 148.33 137.64 140.62 49/406 19489]
[76132.573536] task: ffff880096135b40 ti: ffff8802408f0000 task.ti: ffff8802408f0000
[76132.574440] RIP: 0010:[<ffffffff810fbd4e>]  [<ffffffff810fbd4e>] generic_exec_single+0xee/0x1b0
[76132.575364] RSP: 0018:ffff8802408f3d28  EFLAGS: 00000202
[76132.576275] RAX: ffff880223a67d00 RBX: ffff8802408f3d40 RCX: ffff880223a67d40
[76132.577188] RDX: ffff8802447d3ac0 RSI: ffff8802408f3d40 RDI: ffff8802408f3d40
[76132.578096] RBP: ffff8802408f3d88 R08: 0000000000000001 R09: 0000000000000001
[76132.579011] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
[76132.579918] R13: 0000000000000001 R14: ffff880096159290 R15: ffff8802408f3e80
[76132.580822] FS:  00007fb1263cc740(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
[76132.581737] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[76132.582653] CR2: 0000000081000000 CR3: 00000001ccf39000 CR4: 00000000001407e0
[76132.583573] DR0: 00007f07ef05a000 DR1: 00007fb7761bb000 DR2: 0000000000000000
[76132.584495] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[76132.585411] Stack:
[76132.586319]  0000000000000001 ffff880096135b40 ffff8802408f3d48 ffff880223a67d40
[76132.587256]  ffffffff81166730 ffff8802258737b0 0000000000000003 00000000803d2842
[76132.588198]  ffff8802408f3da8 00000000ffffffff 0000000000000003 ffffffff81166730
[76132.589142] Call Trace:
[76132.590074]  [<ffffffff81166730>] ? perf_swevent_add+0x110/0x110
[76132.591018]  [<ffffffff81166730>] ? perf_swevent_add+0x110/0x110
[76132.591957]  [<ffffffff810fbeb0>] smp_call[76148.896166] sched: RT throttling activated
[76172.492491] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [kworker/u16:1:24452]
[76172.493490] CPU: 3 PID: 24452 Comm: kworker/u16:1 Tainted: G        W    L 3.18.0+ #102 [loadavg: 180.20 147.58 143.86 23/399 24452]
[76172.494533] task: ffff88007309c470 ti: ffff880223a18000 task.ti: ffff880223a18000
[76172.495572] RIP: 0010:[<ffffffff817cf799>]  [<ffffffff817cf799>] _raw_spin_unlock_irq+0x39/0x40
[76172.496598] RSP: 0018:ffff880223a1bec8  EFLAGS: 00000286
[76172.497628] RAX: 0000000000000003 RBX: 0000000000000046 RCX: 0000000000000380
[76172.498691] RDX: ffff88024460dc40 RSI: 0000000000000000 RDI: ffff8802447d2f00
[76172.499749] RBP: ffff880223a1bed8 R08: 0000000000000000 R09: 0000000000000000
[76172.500804] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[76172.501920] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[76172.502958] FS:  0000000000000000(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
[76172.504054] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[76172.505140] CR2: 00007fe411e27000 CR3: 0000000042ae7000 CR4: 00000000001407e0
[76172.506171] DR0: 00007f07ef05a000 DR1: 00007fb7761bb000 DR2: 0000000000000000
[76172.507176] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[76172.508171] Stack:
[76172.509170]  0000000000000001 ffff8802447d2f00 ffff880223a1bf28 ffffffff8109f2bd
[76172.510185]  ffffffff8109f27f 0000000000000000 0000000000000000 ffff8802447d2f00
[76172.511234]  ffff8802447d2f00 ffff880094cc5dc0 0000000000000000 ffff8801aed38208
[76172.512313] Call Trace:
[76172.513371]  [<ffffffff8109f2bd>] finish_task_switch+0x7d/0x120
[76172.514399]  [<ffffffff8109f27f>] ? finish_task_switch+0x3f/0x120
[76172.515429]  [<ffffffff810a5c87>] schedule_tail+0x27/0xb0
[76172.516455]  [<ffffffff817d027f>] ret_from_fork+0xf/0xb0
[76172.517479]  [<ffffffff8108e390>] ? call_helper+0x20/0x20
[76172.518515] Code: 53 48 89 fb 48 8d 7f 18 48 83 ec 08 48 8b 55 08 e8 8d 6c 8f ff 48 89 df e8 b5 9f 8f ff e8 d0 aa 97 ff fb 65 ff 0c 25 e0 a9 00 00 <48> 83 c4 08 5b 5d c3 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb 48 
[76172.520732] sending NMI to other CPUs:
[76172.521757] NMI backtrace for cpu 1
[76172.522745] CPU: 1 PID: 24454 Comm: modprobe Tainted: G        W    L 3.18.0+ #102 [loadavg: 180.20 147.58 143.86 19/402 24456]
[76172.523759] task: ffff880223174470 ti: ffff880225ba4000 task.ti: ffff880225ba4000
[76172.524750] RIP: 0033:[<000000336f609ffd>]  [<000000336f609ffd>] 0x336f609ffd
[76172.525747] RSP: 002b:00007fffcd99c458  EFLAGS: 00000202
[76172.526721] RAX: 0000000000000001 RBX: 0000000000000003 RCX: 0000000000000000
[76172.527697] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 000000336ec20908
[76172.528662] RBP: 000000336ee80fc0 R08: 000000336ec20908 R09: 0000000000000000
[76172.529632] R10: 000000336ee879b0 R11: 0000000000000010 R12: 00007fffcd99c4d0
[76172.530599] R13: 0000000000418c2f R14: 00007fffcd99d918 R15: 0000000000000000
[76172.531567] FS:  00007f8ca6d7e740(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
[76172.532543] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[76172.533512] CR2: 000000336eed9c00 CR3: 00000000963b7000 CR4: 00000000001407e0
[76172.534486] DR0: 00007f07ef05a000 DR1: 00007fb7761bb000 DR2: 0000000000000000
[76172.535450] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[76172.536413] 
[76172.537368] NMI backtrace for cpu 2
[76172.538331] CPU: 2 PID: 20261 Comm: trinity-c241 Tainted: G        W    L 3.18.0+ #102 [loadavg: 180.20 147.58 143.86 18/402 24456]
[76172.539329] task: ffff88017968ada0 ti: ffff8801c0508000 task.ti: ffff8801c0508000
[76172.540316] RIP: 0033:[<000000336ee39e40>]  [<000000336ee39e40>] 0x336ee39e40
[76172.541314] RSP: 002b:00007fffe71236e8  EFLAGS: 00000206
[76172.542300] RAX: 0000000000000003 RBX: 0000000001b66720 RCX: 000000336f1b70cc
[76172.543289] RDX: 000000336f1b70c4 RSI: 00007fffe71236fc RDI: 000000336f1b76e0
[76172.544282] RBP: 000000000000000f R08: 000000336f1b713c R09: 000000336f1b7140
[76172.545273] R10: ffffffffffff9f00 R11: 0000000000000202 R12: 00007fe41545d000
[76172.546266] R13: 00007fe41545d068 R14: 0000000000000000 R15: 0000000000000000
[76172.547263] FS:  00007fe416231740(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
[76172.548267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[76172.549270] CR2: 0000000000000008 CR3: 000000017304b000 CR4: 00000000001407e0
[76172.550284] DR0: 00007f07ef05a000 DR1: 00007fb7761bb000 DR2: 0000000000000000
[76172.551300] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[76172.552316] 
[76172.553304] NMI backtrace for cpu 0
[76172.554289] CPU: 0 PID: 22642 Comm: trinity-c51 Tainted: G        W    L 3.18.0+ #102 [loadavg: 180.20 147.58 143.86 19/400 24457]
[76172.555284] task: ffff88009f375b40 ti: ffff880229be8000 task.ti: ffff880229be8000
[76172.556277] RIP: 0010:[<ffffffff811a5de0>]  [<ffffffff811a5de0>] copy_page_range+0x550/0xa20
[76172.557304] RSP: 0018:ffff880229bebc50  EFLAGS: 00000286
[76172.558340] RAX: 001ffe000008007c RBX: 00007fe413bbf000 RCX: 00000000022c3700
[76172.559328] RDX: ffffea00022c3700 RSI: 00007fe413bbf000 RDI: ffff880201b78c00
[76172.560375] RBP: ffff880229bebd80 R08: 0000000000000000 R09: 0000000000000001
[76172.561423] R10: 0000000000000000 R11: 0000000000000000 R12: 800000008b0dc007
[76172.562465] R13: 00007fe413c00000 R14: ffff88022475ddf8 R15: 0000000000000018
[76172.563432] FS:  00007fe416231740(0000) GS:ffff880244000000(0000) knlGS:0000000000000000
[76172.564401] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[76172.565375] CR2: 0000000001d04b68 CR3: 00000001aee5d000 CR4: 00000000001407f0
[76172.566408] DR0: 00007f07ef05a000 DR1: 00007fb7761bb000 DR2: 0000000000000000
[76172.567423] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[76172.568394] Stack:
[76172.569353]  ffffffff00000000 00007fe413ea6fff 0000000000000000 ffff88021242b988
[76172.570337]  00007fe413ea6fff 00007fe4134a7000 ffff88006681f7f8 ffff880175a72d08
[76172.571323]  ffff8800905d9c80 ffff8801aee5d7f8 00007fe413ea7000 ffff880223ff3c80
[76172.572320] Call Trace:
[76172.573300]  [<ffffffff810764ef>] copy_process.part.26+0x146f/0x1a40

	Dave

