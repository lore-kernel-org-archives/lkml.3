Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaGGPUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:20:12 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:45634 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaGGPUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:20:05 -0400
MIME-Version: 1.0
In-Reply-To: <CA+FTKhu2GoUCLrOEKfBs4t80wm5acPaV=JHb4eM_=xKv=Djm2Q@mail.gmail.com>
References: <CA+FTKhu2GoUCLrOEKfBs4t80wm5acPaV=JHb4eM_=xKv=Djm2Q@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 7 Jul 2014 19:19:44 +0400
Message-ID: <CACT4Y+bb1+8+rAeUZAfG5_uOWgBWc0EkQxEZ1Zct+ST50Xnk7w@mail.gmail.com>
Subject: Re: perf/events/core: Potential race in list_del_event
To: Alexey Preobrazhensky <preobr@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Stephane Eranian <eranian@google.com>,
        Kostya Serebryany <kcc@google.com>, Lars Bull <larsbull@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On Wed, Jun 18, 2014 at 5:07 PM, Alexey Preobrazhensky
<preobr@google.com> wrote:
> Hi,
>
> I’m working on AddressSanitizer[1] -- a tool that detects
> use-after-free and out-of-bounds bugs in kernel.
>
> We’ve encountered a heap-use-after-free in list_del_event() in linux
> kernel 3.15+ (revision 64b2d1fbbfda).
>
> It seems to be a race between list_del_event() and free_event_rcu(),
> with writes in __list_del() both happening to the same freed object,
> which suggests list of size 1.
>
> This heap-use-after-free was triggered under trinity syscall fuzzer,
> so there is no reproducer. Also, please note that the kernel version
> we were fuzzing doesn’t contain a recent commit 3737a1276163, which
> touched perf core.
>
> It would be great if someone familiar with the code took time to look
> into this report.
>
> Thanks,
>  Alexey
>
> [1] https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel
>
> AddressSanitizer: heap-use-after-free in list_del_event
> Write of size 8 by thread T14556:
>  [<     inlined    >] list_del_event+0x25d/0x290 __list_del
> ./include/linux/list.h:88
>  [<     inlined    >] list_del_event+0x25d/0x290 __list_del_entry
> ./include/linux/list.h:101
>  [<     inlined    >] list_del_event+0x25d/0x290 list_del_init
> ./include/linux/list.h:144
>  [<ffffffff812155ed>] list_del_event+0x25d/0x290 ./kernel/events/core.c:1311
>  [<ffffffff81218ae1>] perf_remove_from_context+0xf1/0x150
> ./kernel/events/core.c:1532
>  [<ffffffff8121abfd>] perf_event_release_kernel+0x4d/0xb0
> ./kernel/events/core.c:3292
>  [<ffffffff8121ada3>] put_event+0x143/0x170 ./kernel/events/core.c:3344
>  [<ffffffff8121adf0>] perf_release+0x20/0x30 ./kernel/events/core.c:3349
>  [<ffffffff812c38ec>] __fput+0x13c/0x300 ./fs/file_table.c:210
>  [<ffffffff812c3b1e>] ____fput+0xe/0x10 ./fs/file_table.c:246
>  [<ffffffff81120ab6>] task_work_run+0x136/0x150 ??:0
>  [<ffffffff810f3ede>] do_exit+0x5ae/0x1280 ??:0
>  [<ffffffff810f4c70>] do_group_exit+0x80/0x120 ??:0
>  [<ffffffff8110b2ae>] get_signal_to_deliver+0x39e/0x920 ./kernel/signal.c:2372
>  [<ffffffff810810b4>] do_signal+0x54/0xb70 signal.c:0
>  [<ffffffff81081c4d>] do_notify_resume+0x7d/0x90 ??:0
>  [<ffffffff818c283c>] retint_signal+0x48/0x8c ./arch/x86/kernel/entry_64.S:1095
>
> Freed by thread T0:
>  [<ffffffff81214638>] free_event_rcu+0x38/0x40 ./kernel/events/core.c:3191
>  [<     inlined    >] rcu_process_callbacks+0x2d6/0x920 __rcu_reclaim
> ./kernel/rcu/rcu.h:114
>  [<     inlined    >] rcu_process_callbacks+0x2d6/0x920 rcu_do_batch
> ./kernel/rcu/tree.c:2135
>  [<     inlined    >] rcu_process_callbacks+0x2d6/0x920
> invoke_rcu_callbacks ./kernel/rcu/tree.c:2389
>  [<     inlined    >] rcu_process_callbacks+0x2d6/0x920
> __rcu_process_callbacks ./kernel/rcu/tree.c:2356
>  [<ffffffff8117d126>] rcu_process_callbacks+0x2d6/0x920 ./kernel/rcu/tree.c:2373
>  [<ffffffff810f81f0>] __do_softirq+0x170/0x380 ./kernel/softirq.c:271
>  [<     inlined    >] irq_exit+0xc5/0xd0 invoke_softirq ./kernel/softirq.c:348
>  [<ffffffff810f85c5>] irq_exit+0xc5/0xd0 ./kernel/softirq.c:389
>  [<ffffffff818d1c1e>] smp_apic_timer_interrupt+0x5e/0x70
> ././arch/x86/include/asm/apic.h:696
>  [<ffffffff818d075d>] apic_timer_interrupt+0x6d/0x80
> ./arch/x86/kernel/entry_64.S:1164
>  [<     inlined    >] __schedule+0x665/0xd80 context_switch
> ./kernel/sched/core.c:2268
>  [<ffffffff818bb7d5>] __schedule+0x665/0xd80 ./kernel/sched/core.c:2719
>  [<     inlined    >] schedule_preempt_disabled+0x40/0xc0 schedule
> ./kernel/sched/core.c:2755
>  [<ffffffff818bc6a0>] schedule_preempt_disabled+0x40/0xc0
> ./kernel/sched/core.c:2782
>  [<ffffffff8115d395>] cpu_startup_entry+0x185/0x5d0 ??:0
>  [<ffffffff818af6b7>] rest_init+0x87/0x90 ./init/main.c:397
>  [<ffffffff81cf629f>] start_kernel+0x4ec/0x4fb ./init/main.c:652
>  [<ffffffff81cf5602>] x86_64_start_reservations+0x3a/0x3d
> ./arch/x86/kernel/head64.c:193
>  [<ffffffff81cf57ff>] x86_64_start_kernel+0x1fa/0x209
> ./arch/x86/kernel/head64.c:182
>
> Allocated by thread T14556:
>  [<ffffffff81223b72>] perf_event_alloc+0x72/0x6f0 ./include/linux/slab.h:467
>  [<ffffffff812246a8>] SYSC_perf_event_open+0x4b8/0xed0
> ./kernel/events/core.c:7072
>  [<ffffffff81225629>] SyS_perf_event_open+0x9/0x10 ./kernel/events/core.c:6997
>  [<ffffffff818cfd77>] tracesys+0xdd/0xe2 ./arch/x86/kernel/entry_64.S:748
>
> The buggy address ffff880029eedb28 is located 40 bytes inside
>  of 952-byte region [ffff880029eedb00, ffff880029eedeb8)
>
> Memory state around the buggy address:
>  ffff880029eed600: rrrrrrrr ffffffff ffffffff ffffffff
>  ffff880029eed700: ffffffff ffffffff ffffffff ffffffff
>  ffff880029eed800: ffffffff ffffffff ffffffff ffffffff
>  ffff880029eed900: ffffffff ffffffff ffffffff ffffffff
>  ffff880029eeda00: ffffffff rrrrrrrr rrrrrrrr rrrrrrrr
>>ffff880029eedb00: ffffffff ffffffff ffffffff ffffffff
>                         ^
>  ffff880029eedc00: ffffffff ffffffff ffffffff ffffffff
>  ffff880029eedd00: ffffffff ffffffff ffffffff ffffffff
>  ffff880029eede00: ffffffff ffffffff ffffffff ffffffff
>  ffff880029eedf00: rrrrrrrr rrrrrrrr rrrrrrrr rrrrrrrr
>  ffff880029eee000: rrrrrrrr rrrrrrrr ffffffff ffffffff
> Legend:
>  f - 8 freed bytes
>  r - 8 redzone bytes
>  . - 8 allocated bytes
>  x=1..7 - x allocated bytes + (8-x) redzone bytes
