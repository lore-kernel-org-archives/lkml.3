Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaKJJoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:44:22 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaKJJoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:44:20 -0500
Date: Mon, 10 Nov 2014 10:44:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Inconsistent lock state with Hyper-V memory balloon?
Message-ID: <20141110094407.GE29390@twins.programming.kicks-ass.net>
References: <20141108143654.GA7939@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141108143654.GA7939@sucs.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 02:36:54PM +0000, Sitsofe Wheeler wrote:
> I've been trying to use the Hyper-V balloon driver to allow the host to
> reclaim unused memory but have been hitting issues. With a Hyper-V 2012
> R2 guest with 4GBytes of RAM, dynamic memory on, 1GByte minimum 10GByte
> maximum, 8 vcpus, running a 3.18.0-rc3 kernel with no swap configured
> the following lockdep splat occurred:
> 
> =================================
> [ INFO: inconsistent lock state ]
> 3.18.0-rc3.x86_64 #159 Not tainted
> ---------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
>  (bdev_lock){+.?...}, at: [<ffffffff811ff39c>] nr_blockdev_pages+0x1c/0x80
> {SOFTIRQ-ON-W} state was registered at:
>   [<ffffffff810ba03d>] __lock_acquire+0x87d/0x1c60
>   [<ffffffff810bbcdc>] lock_acquire+0xfc/0x150
>   [<ffffffff816e4019>] _raw_spin_lock+0x39/0x50
>   [<ffffffff811ff39c>] nr_blockdev_pages+0x1c/0x80
>   [<ffffffff8115d5f7>] si_meminfo+0x47/0x70
>   [<ffffffff81d6622f>] eventpoll_init+0x11/0x10a
>   [<ffffffff81d3d150>] do_one_initcall+0xf9/0x1a7
>   [<ffffffff81d3d3d2>] kernel_init_freeable+0x1d4/0x268
>   [<ffffffff816ce0ae>] kernel_init+0xe/0x100
>   [<ffffffff816e4dfc>] ret_from_fork+0x7c/0xb0
> irq event stamp: 2660283708
> hardirqs last  enabled at (2660283708): [<ffffffff8115eef5>] free_hot_cold_page+0x175/0x190
> hardirqs last disabled at (2660283707): [<ffffffff8115ee25>] free_hot_cold_page+0xa5/0x190
> softirqs last  enabled at (2660132034): [<ffffffff81071e6a>] _local_bh_enable+0x4a/0x50
> softirqs last disabled at (2660132035): [<ffffffff81072478>] irq_exit+0x58/0xc0
> 
> might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(bdev_lock);
>   <Interrupt>
>     lock(bdev_lock);
> 
> *
> 
> no locks held by swapper/0/0.
> 
> 
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc3.x86_64 #159
> Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
>  ffffffff8266ac90 ffff880107403af8 ffffffff816db3ef 0000000000000000
>  ffffffff81c134c0 ffff880107403b58 ffffffff816d6fd3 0000000000000001
>  ffffffff00000001 ffff880100000000 ffffffff81010e6f 0000000000000046
> Call Trace:
>  <IRQ>  [<ffffffff816db3ef>] dump_stack+0x4e/0x68
>  [<ffffffff816d6fd3>] print_usage_bug+0x1f3/0x204
>  [<ffffffff81010e6f>] ? save_stack_trace+0x2f/0x50
>  [<ffffffff810b6f40>] ? print_irq_inversion_bug+0x200/0x200
>  [<ffffffff810b78e6>] mark_lock+0x176/0x2e0
>  [<ffffffff810b9f83>] __lock_acquire+0x7c3/0x1c60
>  [<ffffffff8103d548>] ? lookup_address+0x28/0x30
>  [<ffffffff8103d58b>] ? _lookup_address_cpa.isra.3+0x3b/0x40
>  [<ffffffff813c4e89>] ? __debug_check_no_obj_freed+0x89/0x220
>  [<ffffffff810bbcdc>] lock_acquire+0xfc/0x150
>  [<ffffffff811ff39c>] ? nr_blockdev_pages+0x1c/0x80
>  [<ffffffff816e4019>] _raw_spin_lock+0x39/0x50
>  [<ffffffff811ff39c>] ? nr_blockdev_pages+0x1c/0x80
>  [<ffffffff811ff39c>] nr_blockdev_pages+0x1c/0x80
>  [<ffffffff8115d5f7>] si_meminfo+0x47/0x70
>  [<ffffffff815eb14d>] post_status.isra.3+0x6d/0x190
>  [<ffffffff810b7f4d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8115f00f>] ? __free_pages+0x2f/0x60
>  [<ffffffff815eb34f>] ? free_balloon_pages.isra.5+0x8f/0xb0
>  [<ffffffff815eb972>] balloon_onchannelcallback+0x212/0x380
>  [<ffffffff815e69d3>] vmbus_on_event+0x173/0x1d0
>  [<ffffffff81071b47>] tasklet_action+0x127/0x160
>  [<ffffffff81071ffa>] __do_softirq+0x18a/0x340
>  [<ffffffff81072478>] irq_exit+0x58/0xc0
>  [<ffffffff810290c5>] hyperv_vector_handler+0x45/0x60
>  [<ffffffff816e6b92>] hyperv_callback_vector+0x72/0x80
>  <EOI>  [<ffffffff81037b76>] ? native_safe_halt+0x6/0x10
>  [<ffffffff810b7f4d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8100c8d1>] default_idle+0x51/0xf0
>  [<ffffffff8100d30f>] arch_cpu_idle+0xf/0x20
>  [<ffffffff810b01e7>] cpu_startup_entry+0x217/0x3f0
>  [<ffffffff816ce099>] rest_init+0xc9/0xd0
>  [<ffffffff816cdfd5>] ? rest_init+0x5/0xd0
>  [<ffffffff81d3d04a>] start_kernel+0x438/0x445
>  [<ffffffff81d3c94a>] ? set_init_arg+0x57/0x57
>  [<ffffffff81d3c120>] ? early_idt_handlers+0x120/0x120
>  [<ffffffff81d3c59f>] x86_64_start_reservations+0x2a/0x2c
>  [<ffffffff81d3c6df>] x86_64_start_kernel+0x13e/0x14d
> 
> Any help deciphering the above is greatly appreciated!

Its fairly simple, the first trace shows where bdev_lock was taken with
softirqs enabled, and the second trace shows where its taken from
softirqs. Combine the two and you've got a recursive deadlock.

I don't know the block layer very well, but a quick glance at the code
shows its bdev_lock isn't meant to be used from softirq context,
therefore the hyperv stuff is broken.

So complain to the hyperv people.
