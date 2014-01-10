Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaAJMMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:12:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57940 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaAJMMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:12:07 -0500
Date: Fri, 10 Jan 2014 13:11:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] lockdep: Introduce wait-type checks
Message-ID: <20140110121143.GM31570@twins.programming.kicks-ass.net>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
 <20140109173326.GA10105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109173326.GA10105@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:33:26PM -0500, Dave Jones wrote:
> On Thu, Jan 09, 2014 at 12:15:16PM +0100, Peter Zijlstra wrote:
>  > Subject: lockdep: Introduce wait-type checks
>  > From: Peter Zijlstra <peterz@infradead.org>
>  > Date: Tue, 19 Nov 2013 21:45:48 +0100
>  > 
>  > This patch extends lockdep to validate lock wait-type context.
> 
> ooh, a new toy.
> 
> *boom*
> 
> [    0.298629] =============================
> [    0.298732] [ BUG: Invalid wait context ]
> [    0.298834] 3.13.0-rc7+ #15 Not tainted
> [    0.298935] -----------------------------
> [    0.299038] swapper/0/1 is trying to lock:
> [    0.299135]  (&n->list_lock){......}-{3:3}, at: [<ffffffff816dea54>] get_partial_node.isra.49+0x4d/0x228
> [    0.299453] 
> stack backtrace:
> [    0.299608] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc7+ #15 
> [    0.299983]  0000000000000001 ffff880243f37a00 ffffffff816dfe5b 0000000000000014
> [    0.300302]  ffff880243f37a78 ffffffff8109f1f7 0000000000000000 ffff880243f37a78
> [    0.300611]  0000000000000046 ffffffff81189ae3 ffffffff00000000 0000000000000046
> [    0.300927] Call Trace:
> [    0.301028]  [<ffffffff816dfe5b>] dump_stack+0x4e/0x7a
> [    0.301128]  [<ffffffff8109f1f7>] __lock_acquire.isra.28+0x3d7/0xd80
> [    0.301238]  [<ffffffff81189ae3>] ? deactivate_slab+0x3c3/0x740
> [    0.301345]  [<ffffffff810a030d>] lock_acquire+0x8d/0x120
> [    0.302971]  [<ffffffff816dea54>] ? get_partial_node.isra.49+0x4d/0x228
> [    0.303077]  [<ffffffff816e9e3b>] _raw_spin_lock+0x3b/0x50
> [    0.303183]  [<ffffffff816dea54>] ? get_partial_node.isra.49+0x4d/0x228
> [    0.303290]  [<ffffffff816dea54>] get_partial_node.isra.49+0x4d/0x228
> [    0.303397]  [<ffffffff810cd482>] ? __module_text_address+0x12/0x60
> [    0.303502]  [<ffffffff810d35ff>] ? is_module_text_address+0x2f/0x50
> [    0.303610]  [<ffffffff81074548>] ? __kernel_text_address+0x58/0x80
> [    0.303717]  [<ffffffff816dedfc>] __slab_alloc+0x1cd/0x562
> [    0.303821]  [<ffffffff812e86ff>] ? alloc_cpumask_var_node+0x1f/0x90
> [    0.303929]  [<ffffffff8118ab6a>] kmem_cache_alloc_node_trace+0xda/0x290
> [    0.304037]  [<ffffffff812e86ff>] ? alloc_cpumask_var_node+0x1f/0x90
> [    0.304145]  [<ffffffff812e86ff>] alloc_cpumask_var_node+0x1f/0x90
> [    0.304250]  [<ffffffff812e879e>] alloc_cpumask_var+0xe/0x10
> [    0.304357]  [<ffffffff81030990>] __assign_irq_vector+0x40/0x340
> [    0.304462]  [<ffffffff810324a1>] __create_irqs+0x151/0x210
> [    0.304567]  [<ffffffff810325a2>] create_irq+0x22/0x30
> [    0.304674]  [<ffffffff815ab25d>] dmar_set_interrupt+0x2d/0xd0
> [    0.304784]  [<ffffffff81d6a532>] enable_drhd_fault_handling+0x24/0x66
> [    0.304890]  [<ffffffff81d6bc7f>] irq_remap_enable_fault_handling+0x26/0x30
> [    0.304999]  [<ffffffff81d2f3e0>] bsp_end_local_APIC_setup+0x18/0x1a
> [    0.305106]  [<ffffffff81d2d44a>] native_smp_prepare_cpus+0x35c/0x3d3
> [    0.305215]  [<ffffffff81d20f93>] kernel_init_freeable+0x124/0x26c
> [    0.305321]  [<ffffffff816d6d4e>] ? kernel_init+0xe/0x130
> [    0.305427]  [<ffffffff816d6d40>] ? rest_init+0xd0/0xd0
> [    0.305529]  [<ffffffff816d6d4e>] kernel_init+0xe/0x130
> [    0.305627]  [<ffffffff816f23ac>] ret_from_fork+0x7c/0xb0
> [    0.305731]  [<ffffffff816d6d40>] ? rest_init+0xd0/0xd0
> [    0.305836] 
> other info that might help us debug this:
> [    0.305993] 1 lock held by swapper/0/1:
> [    0.306093]  #0:  (vector_lock){......}-{2:2}, at: [<ffffffff8103245c>] __create_irqs+0x10c/0x210
> [    0.306444] 

Ok, so whatever way I turn this thing, we simply cannot allocate memory
while holding a raw_spinlock, since all the allocator locks upto and
including zone->lock are regular spinlocks and we very much want
preemptible allocators, so changing that is not an option.

While -rt does appear to turn list_lock into a raw_spinlock that is at
most a band-aid afaict because all those list iterations that are done
while holding it aren't in any way bounded.

But even converting list_lock doesn't help, because SLUB (and any of the
others) will eventually call into alloc_page and friends which will
touch zone->lock, which is very much a spinlock, even on -rt.

So we must change this __create_irqs() site to not do this allocation
while holding the lock, /me greps the -rt patches to see if anybody
touches that.

Ah, no, -rt simply forbids CPUMASK_OFFSTACK and side-steps the issue
here.

Bugger.

Thomas, any clue? __assign_irq_vector() is called rather deep down in
the whole IRQ story and appears to be rather stupidly expensive, a
sideways reading of it makes it appear to be O(nr_cpus^2) surely
a complete fail even for !rt kernels.
