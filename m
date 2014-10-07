Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaJGAwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:52:45 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:63080 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaJGAwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:52:43 -0400
Date: Mon, 6 Oct 2014 19:52:38 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: 3.17 another perf_fuzzer lockup
Message-ID: <20141006195238.3e9a9203@as>
In-Reply-To: <alpine.DEB.2.11.1410061151400.12313@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1410061130100.11293@vincent-weaver-1.umelst.maine.edu>
	<alpine.DEB.2.11.1410061151400.12313@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014 11:55:11 -0400 (EDT)
Vince Weaver <vincent.weaver@maine.edu> wrote:

> On Mon, 6 Oct 2014, Vince Weaver wrote:
> 
> > [  843.700042] general protection fault: 0000 [#1] SMP 
> > ...
> > [  843.704001] task: ffff88011a874000 ti: ffff8800bc0ec000 task.ti: ffff8800bc0ec000
> > [  843.704001] RIP: 0010:[<ffffffff810cd913>]  [<ffffffff810cd913>] perf_event_context_sched_in.isra.75+0x1f/0x90
> 
> For what it's worth, this is 
> 
> kernel/events/core.c:2646
> 
>         if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
>                 perf_cgroup_sched_in(prev, task);
> 
> 
> ffffffff810cd902:       53                      push   %rbx
> ffffffff810cd903:       48 8b 07                mov    (%rdi),%rax
> ffffffff810cd906:       48 8b 58 40             mov    0x40(%rax),%rbx
> ffffffff810cd90a:       65 48 03 1c 25 08 ce    add    %gs:0xce08,%rbx
> ffffffff810cd911:       00 00 
> ffffffff810cd913:       48 39 bb d8 00 00 00    cmp    %rdi,0xd8(%rbx)
> ffffffff810cd91a:       74 63                   je     ffffffff810cd97f <perf_event_context_sched_in.isra.75+0x8b>
> 

Actually it's:

static void perf_event_context_sched_in(struct perf_event_context *ctx,
					struct task_struct *task)
{
	struct perf_cpu_context *cpuctx;

	cpuctx = __get_cpu_context(ctx);
	if (cpuctx->task_ctx == ctx)      <======= oops
		return;

cpuctx is in %rbx (=ffff1001e742c000) and that's not even a legal
address, which is what caused the general protection fault

> 
> > [  843.704001] RSP: 0018:ffff8800bc0efd50  EFLAGS: 00010087
> > [  843.704001] RAX: ffffea0002ba2d68 RBX: ffff1001e742c000 RCX: 000000000000038f
> > [  843.704001] RDX: ffff88011fc95b30 RSI: ffff880037d0eb00 RDI: ffff880037d0e700
> > [  843.704001] RBP: ffff8800bc0efd60 R08: ffff8800bc0ec000 R09: 000000000000baff
> > [  843.704001] R10: 0000000000000006 R11: 00000000000009bc R12: ffff880037d0e700
> > [  843.704001] R13: ffff8800c944f400 R14: 0000000000000001 R15: ffff88011b340800
> > [  843.704001] FS:  00007ffc76c17700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
> > [  843.704001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [  843.704001] DR0: 0000000001c7b000 DR1: 0000000000000000 DR2: 0000000001c7b000
> > [  843.704001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> > [  843.704001] Stack:
> > [  843.704001]  ffff88011a874000 ffff88011b340800 ffff8800bc0efd90 ffffffff810cd9bb
> > [  843.704001]  ffff88011a8744e8 ffff88011b340800 ffff88011fc929c0 ffff8800c944f400
> > [  843.704001]  ffff8800bc0efdc0 ffffffff8105ae62 ffff88011fc929c0 ffff8800c944f400
> > [  843.704001] Call Trace:
> > [  843.704001]  [<ffffffff810cd9bb>] __perf_event_task_sched_in+0x37/0xf4
> > [  843.704001]  [<ffffffff8105ae62>] finish_task_switch+0x9b/0xa6
> > [  843.704001]  [<ffffffff815209c1>] __schedule+0x309/0x4a5
> > [  843.704001]  [<ffffffff81520df3>] _cond_resched+0x28/0x3b
> > [  843.704001]  [<ffffffff815217b5>] mutex_lock+0x12/0x2f
> > [  843.704001]  [<ffffffff810cb9bb>] find_get_context+0xfc/0x170
> > [  843.704001]  [<ffffffff810cff77>] SYSC_perf_event_open+0x47b/0x7f5
> > [  843.704001]  [<ffffffff810d0651>] SyS_perf_event_open+0xe/0x10
> > [  843.704001]  [<ffffffff81523ad1>] tracesys+0xd4/0xd9
> > [  843.704001] Code: 89 e7 e8 65 fe ff ff 5b 41 5c 5d c3 e8 c7 7e 45 00 55 48 89 e5 41 54 49 89 fc 53 48 8b 07 48 8b 58 40 65 48 03 1c 25 08 ce 00 00 <48> 39 bb d8 00 00 00 74 63 48 89 fe 48 89 df e8 f0 b4 ff ff 49 
> > [  843.704001] RIP  [<ffffffff810cd913>] perf_event_context_sched_in.isra.75+0x1f/0x90
> > [  843.704001]  RSP <ffff8800bc0efd50>
