Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbaKRRUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:20:37 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:54850 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbaKRRUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:20:04 -0500
MIME-Version: 1.0
In-Reply-To: <20141118145234.GA7487@redhat.com>
References: <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141117170359.GA1382@redhat.com>
	<CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
	<20141118020959.GA2091@redhat.com>
	<CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
	<20141118023930.GA2871@redhat.com>
	<CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
	<20141118145234.GA7487@redhat.com>
Date: Tue, 18 Nov 2014 09:20:02 -0800
X-Google-Sender-Auth: cNCrY0HCedNm3SZBIUPEl5TaVGU
Message-ID: <CA+55aFxttmjXJX4wtwSpTOdDCMwpSopAsL3MJ1n8mJSJOEpyhQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 6:52 AM, Dave Jones <davej@redhat.com> wrote:
>
> Here's the first hit. Curiously, one cpu is missing.

That might be the CPU3 that isn't responding to IPIs due to some bug..

> NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [trinity-c180:17837]
> RIP: 0010:[<ffffffffa91a0db0>]  [<ffffffffa91a0db0>] bad_range+0x0/0x90

Hmm. Something looping in the page allocator? Not waiting for a lock,
but livelocked? I'm not seeing anything here that should trigger the
NMI watchdog at all.

Can the NMI watchdog get confused somehow?

> Call Trace:
>  [<ffffffffa91a6030>] __alloc_pages_nodemask+0x230/0xd20
>  [<ffffffffa91f400e>] alloc_pages_vma+0xee/0x1b0
>  [<ffffffffa91b643e>] shmem_alloc_page+0x6e/0xc0
>  [<ffffffffa91b8ff0>] shmem_getpage_gfp+0x630/0xa40
>  [<ffffffffa91b9442>] shmem_write_begin+0x42/0x70
>  [<ffffffffa919a684>] generic_perform_write+0xd4/0x1f0
>  [<ffffffffa919d5d2>] __generic_file_write_iter+0x162/0x350
>  [<ffffffffa919d7ff>] generic_file_write_iter+0x3f/0xb0
>  [<ffffffffa92155e8>] do_iter_readv_writev+0x78/0xc0
>  [<ffffffffa9216e18>] do_readv_writev+0xd8/0x2a0
>  [<ffffffffa90cf426>] ? lock_release_holdtime.part.28+0xe6/0x160
>  [<ffffffffa921706c>] vfs_writev+0x3c/0x50

And CPU2 is in that TLB flusher again:

> NMI backtrace for cpu 2
> RIP: 0010:[<ffffffffa9116dbe>]  [<ffffffffa9116dbe>] generic_exec_single+0xee/0x1a0
> Call Trace:
>  [<ffffffffa9045bb0>] ? do_flush_tlb_all+0x60/0x60
>  [<ffffffffa9116f3a>] smp_call_function_single+0x6a/0xe0
>  [<ffffffffa9117679>] smp_call_function_many+0x2b9/0x320
>  [<ffffffffa9046370>] flush_tlb_mm_range+0xe0/0x370
>  [<ffffffffa91cc762>] tlb_flush_mmu_tlbonly+0x42/0x50
>  [<ffffffffa91cdd28>] unmap_single_vma+0x6b8/0x900
>  [<ffffffffa91ce06c>] zap_page_range_single+0xfc/0x160
>  [<ffffffffa91ce254>] unmap_mapping_range+0x134/0x190

.. and the code line implies that it's in that csd_lock_wait() loop,
again consistent with waiting for some other CPU. Presumably the
missing CPU3.

> NMI backtrace for cpu 0
> RIP: 0010:[<ffffffffa90ac450>]  [<ffffffffa90ac450>] preempt_count_add+0x0/0xc0
> Call Trace:
>  [<ffffffffa96bbb45>] cpuidle_enter_state+0x55/0x300
>  [<ffffffffa96bbea7>] cpuidle_enter+0x17/0x20
>  [<ffffffffa90c88f5>] cpu_startup_entry+0x4e5/0x630
>  [<ffffffffa902d523>] start_secondary+0x1a3/0x220

And CPU0 is just in the idle loop (that RIP is literally the
instruction after the "mwait" according to the code line).

> INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 125.739 msecs

.. and that's us giving up on CPU3.

So it does look like CPU3 is the problem, but sadly, CPU3 is
apparently not listening, and doesn't even react to the NMI, much less
a TLB flush IPI.

Not reacting to NMI could be:
 (a) some APIC state issue
 (b) we're already stuck in a loop in the previous NMI handler
 (c) what?

Anybody?

                     Linus
