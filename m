Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaKRVzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:55:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbaKRVzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:55:50 -0500
Date: Tue, 18 Nov 2014 16:55:40 -0500
From: Don Zickus <dzickus@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141118215540.GD35311@redhat.com>
References: <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141117170359.GA1382@redhat.com>
 <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
 <20141118020959.GA2091@redhat.com>
 <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
 <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411181914020.3909@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 07:54:17PM +0100, Thomas Gleixner wrote:
> On Tue, 18 Nov 2014, Dave Jones wrote:
> > Here's the first hit. Curiously, one cpu is missing.
> 
> I don't think so
> 
> > NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c180:17837]
> 
> > irq event stamp: 2258092
> > hardirqs last  enabled at (2258091): [<ffffffffa91a58b5>] get_page_from_freelist+0x555/0xaa0
> > hardirqs last disabled at (2258092): [<ffffffffa985396a>] apic_timer_interrupt+0x6a/0x80
> 
> So that means we are in the timer interrupt and handling
> watchdog_timer_fn.
> 
> > CPU: 1 PID: 17837 Comm: trinity-c180 Not tainted 3.18.0-rc5+ #90 [loadavg: 199.00 178.81 173.92 35/402 20526]
> > task: ffff8801575e4680 ti: ffff880202434000 task.ti: ffff880202434000
> > RIP: 0010:[<ffffffffa91a0db0>]  [<ffffffffa91a0db0>] bad_range+0x0/0x90
> 
> So the softlockup tells us, that the high priority watchdog thread was
> not able to touch the watchdog timestamp. That means this task was
> hogging the CPU for 20+ seconds. I have no idea how that happens in
> that call chain.
> 
> Call Trace:
>  [<ffffffffa91a58c4>] ? get_page_from_freelist+0x564/0xaa0
>  [<ffffffffa90ac411>] ? get_parent_ip+0x11/0x50
>  [<ffffffffa91a6030>] __alloc_pages_nodemask+0x230/0xd20
>  [<ffffffffa90ac411>] ? get_parent_ip+0x11/0x50
>  [<ffffffffa90d1e45>] ? mark_held_locks+0x75/0xa0
>  [<ffffffffa91f400e>] alloc_pages_vma+0xee/0x1b0
>  [<ffffffffa91b643e>] ? shmem_alloc_page+0x6e/0xc0
>  [<ffffffffa91b643e>] shmem_alloc_page+0x6e/0xc0
>  [<ffffffffa90ac411>] ? get_parent_ip+0x11/0x50
>  [<ffffffffa90ac58b>] ? preempt_count_sub+0x7b/0x100
>  [<ffffffffa93dcc46>] ? __percpu_counter_add+0x86/0xb0
>  [<ffffffffa91d50d6>] ? __vm_enough_memory+0x66/0x1c0
>  [<ffffffffa919ad65>] ? find_get_entry+0x5/0x230
>  [<ffffffffa933b10c>] ? cap_vm_enough_memory+0x4c/0x60
>  [<ffffffffa91b8ff0>] shmem_getpage_gfp+0x630/0xa40
>  [<ffffffffa90cee01>] ? match_held_lock+0x111/0x160
>  [<ffffffffa91b9442>] shmem_write_begin+0x42/0x70
>  [<ffffffffa919a684>] generic_perform_write+0xd4/0x1f0
>  [<ffffffffa919d5d2>] __generic_file_write_iter+0x162/0x350
>  [<ffffffffa92154a0>] ? new_sync_read+0xd0/0xd0
>  [<ffffffffa919d7ff>] generic_file_write_iter+0x3f/0xb0
>  [<ffffffffa919d7c0>] ? __generic_file_write_iter+0x350/0x350
>  [<ffffffffa92155e8>] do_iter_readv_writev+0x78/0xc0
>  [<ffffffffa9216e18>] do_readv_writev+0xd8/0x2a0
>  [<ffffffffa919d7c0>] ? __generic_file_write_iter+0x350/0x350
>  [<ffffffffa90cf426>] ? lock_release_holdtime.part.28+0xe6/0x160
>  [<ffffffffa919d7c0>] ? __generic_file_write_iter+0x350/0x350
>  [<ffffffffa90ac411>] ? get_parent_ip+0x11/0x50
>  [<ffffffffa90ac58b>] ? preempt_count_sub+0x7b/0x100
>  [<ffffffffa90e782e>] ? rcu_read_lock_held+0x6e/0x80
>  [<ffffffffa921706c>] vfs_writev+0x3c/0x50
>  [<ffffffffa92171dc>] SyS_writev+0x5c/0x100
>  [<ffffffffa9852c49>] tracesys_phase2+0xd4/0xd9
> 
> But this gets pages for a write into shmem and the other one below
> does a madvise on a shmem map. Coincidence?
> 
> > sending NMI to other CPUs:
> 
> So here we kick the other cpus
> 
> > NMI backtrace for cpu 2
> > CPU: 2 PID: 15913 Comm: trinity-c141 Not tainted 3.18.0-rc5+ #90 [loadavg: 199.00 178.81 173.92 35/402 20526]
> > task: ffff880223229780 ti: ffff8801afca0000 task.ti: ffff8801afca0000
> > RIP: 0010:[<ffffffffa9116dbe>]  [<ffffffffa9116dbe>] generic_exec_single+0xee/0x1a0
> >  [<ffffffffa9045bb0>] ? do_flush_tlb_all+0x60/0x60
> >  [<ffffffffa9045bb0>] ? do_flush_tlb_all+0x60/0x60
> >  [<ffffffffa9116f3a>] smp_call_function_single+0x6a/0xe0
> >  [<ffffffffa93b2e1f>] ? cpumask_next_and+0x4f/0xb0
> >  [<ffffffffa9045bb0>] ? do_flush_tlb_all+0x60/0x60
> >  [<ffffffffa9117679>] smp_call_function_many+0x2b9/0x320
> >  [<ffffffffa9046370>] flush_tlb_mm_range+0xe0/0x370
> >  [<ffffffffa91cc762>] tlb_flush_mmu_tlbonly+0x42/0x50
> >  [<ffffffffa91cdd28>] unmap_single_vma+0x6b8/0x900
> >  [<ffffffffa91ce06c>] zap_page_range_single+0xfc/0x160
> >  [<ffffffffa91ce254>] unmap_mapping_range+0x134/0x190
> >  [<ffffffffa91bb9dd>] shmem_fallocate+0x4fd/0x520
> >  [<ffffffffa90c7c77>] ? prepare_to_wait+0x27/0x90
> >  [<ffffffffa9213bc2>] do_fallocate+0x132/0x1d0
> >  [<ffffffffa91e3228>] SyS_madvise+0x398/0x870
> >  [<ffffffffa983f6c0>] ? rcu_read_lock_sched_held+0x4e/0x6a
> >  [<ffffffffa9013877>] ? syscall_trace_enter_phase2+0xa7/0x2b0
> >  [<ffffffffa9852c49>] tracesys_phase2+0xd4/0xd9
> 
> We've seen that before
> 
> > NMI backtrace for cpu 0
> > INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 37.091 msecs
> 
> So it complains that the backtrace handler took 37 msec, which is
> indeed long for just dumping a stack trace.
> 
> > CPU: 0 PID: 15851 Comm: trinity-c80 Not tainted 3.18.0-rc5+ #90 [loadavg: 199.00 178.81 173.92 36/402 20526]
> > task: ffff8801874e8000 ti: ffff88022baec000 task.ti: ffff88022baec000
> > RIP: 0010:[<ffffffffa90ac450>]  [<ffffffffa90ac450>] preempt_count_add+0x0/0xc0
> > RSP: 0000:ffff880244003c30  EFLAGS: 00000092
> > RAX: 0000000000000001 RBX: ffffffffa9edb560 RCX: 0000000000000001
> > RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000001
> > RBP: ffff880244003c48 R08: 0000000000000000 R09: 0000000000000001
> > R10: 0000000000000000 R11: ffff8801874e88c8 [23543.271956] NMI backtrace for cpu 3
> 
> So here we mangle CPU3 in and lose the backtrace for cpu0, which might
> be the real interesting one ....


Dave,

Can you provide another dump?  The hope is we get something not mangled?

The other option we have done in RHEL is panic the system and let kdump
capture the memory.  Then we can analyze the vmcore for the stack trace
cpu0 stored in memory to get a rough idea where it might be if the cpu
isn't responding very well.

Cheers,
Don

> 
> > INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 100.612 msecs
> 
> This one takes 100ms.
> 
> > CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0-rc5+ #90 [loadavg: 199.00 178.81 173.92 37/402 20526]
> > task: ffff880242b5c680 ti: ffff880242b78000 task.ti: ffff880242b78000
> > RIP: 0010:[<ffffffffa94251b5>]  [<ffffffffa94251b5>] intel_idle+0xd5/0x180
> 
> So that one is simply idle.
> 
> > INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 125.739 msecs
> > 
> 
> And we get another backtrace handler taking too long. Of course we
> cannot tell which of the 3 complaints comes from which cpu, because
> the printk lacks a cpuid.
> 
> Thanks,
> 
> 	tglx
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
