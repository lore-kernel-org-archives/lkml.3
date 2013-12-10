Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3LJU6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:58:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:26343 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab3LJU56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:57:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,866,1378882800"; 
   d="scan'208";a="450081986"
Message-ID: <1386709077.3685.73.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: process 'stuck' at exit.
From: Darren Hart <dvhart@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 12:57:57 -0800
In-Reply-To: <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
References: <20131210154724.GA30020@redhat.com>
	 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 10:40 -0800, Linus Torvalds wrote:
> Hmm. Looks like the futex code is somehow stuck in a loop, calling
> get_user_pages_fast().
> 
> The futex code itself is apparently so low-overhead that it doesn't
> show up in your 'perf top' report (which is dominated by all the
> expensive debug things that get_user_pages_fast() etc ends up doing),
> but that's the only looping I can see. Perhaps the "goto again" case
> for transparent huge pages in get_futex_key()? Or the
> "retry[_private]" cases in futex_requeue()? Some error condition that
> causes us to retry forever, rather than returning the error code?
> 
> Added a few more people to the cc.. Ideas?
> 
>               Linus
> 
> 
> On Tue, Dec 10, 2013 at 7:47 AM, Dave Jones <davej@redhat.com> wrote:
> > I woke up to find my fuzzer in a curious state.
> >
> >  1121 pts/5    SN+    0:00  |       \_ ../trinity -q -l off -N 999999 -C 42
> >  1130 pts/5    SN+    0:01  |           \_ ../trinity -q -l off -N 999999 -C 42
> >  1131 pts/5    SN+    0:17  |           \_ ../trinity -q -l off -N 999999 -C 42
> > 10818 ?        RNs  21115152:53  |               \_ ../trinity -q -l off -N 999999 -C 42
> >
> > (ignore the first 3 pids, they're waiting on 10818, which is the interesting one)
> >
> > It's completed its run of 999999 syscalls, and looking at tmux, it tried to exit.
> >
> > /proc/10818/stack just shows
> >
> > [<ffffffffffffffff>] 0xffffffffffffffff
> >
> > Top reports a core is spinning in the kernel 100%, so I ran perf top -a
> > and saw..
> >
> >   8.63%  [kernel]                [k] trace_hardirqs_off_caller
> >   7.68%  [kernel]                [k] __lock_acquire
> >   5.35%  [kernel]                [k] gup_huge_pmd
> >   5.31%  [kernel]                [k] put_compound_page
> >   4.93%  [kernel]                [k] gup_pud_range
> >   4.76%  [kernel]                [k] trace_hardirqs_on_caller
> >   4.58%  [kernel]                [k] get_user_pages_fast
> >   4.00%  [kernel]                [k] debug_smp_processor_id
> >   4.00%  [kernel]                [k] lock_is_held
> >   3.73%  [kernel]                [k] lock_acquired
> >   3.67%  [kernel]                [k] lock_release
> >
> >
> > sysrq-t shows..
> >
> > trinity-child27 R  running task     5520 10818   1131 0x00080004
> >  0000000000000000 ffff8801b0ef4170 000000000000032c ffff8801b609e108
> >  0000000000000000 ffff880160d21c30 ffffffff810ad895 ffffffff817587a0
> >  ffff8801b0ef4170 ffff8801b609e0a8 ffff8801b609e000 ffff880160d21d50
> > Call Trace:
> >  [<ffffffff817587a0>] ? retint_restore_args+0xe/0xe
> >  [<ffffffff8132af0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> >  [<ffffffff8100b184>] ? native_sched_clock+0x24/0x80
> >  [<ffffffff8109624f>] ? local_clock+0xf/0x50
> >  [<ffffffff810aa27e>] ? put_lock_stats.isra.28+0xe/0x30
> >  [<ffffffff8103edd0>] ? gup_pud_range+0x170/0x190
> >  [<ffffffff8103f0d5>] ? get_user_pages_fast+0x1a5/0x1c0
> >  [<ffffffff810ad1f5>] ? trace_hardirqs_on_caller+0x115/0x1e0
> >  [<ffffffff810a8a2f>] ? up_read+0x1f/0x40
> >  [<ffffffff8103f0d5>] ? get_user_pages_fast+0x1a5/0x1c0
> >  [<ffffffff8115f76c>] ? put_page+0x3c/0x50
> >  [<ffffffff810dd525>] ? get_futex_key+0xd5/0x2c0
> >  [<ffffffff810df18a>] ? futex_requeue+0xfa/0x9c0
> >  [<ffffffff810e019e>] ? do_futex+0xae/0xc80
> >  [<ffffffff810aa27e>] ? put_lock_stats.isra.28+0xe/0x30
> >  [<ffffffff810aa7de>] ? lock_release_holdtime.part.29+0xee/0x170
> >  [<ffffffff8114f16e>] ? context_tracking_user_exit+0x4e/0x190
> >  [<ffffffff810ad1f5>] ? trace_hardirqs_on_caller+0x115/0x1e0
> >  [<ffffffff810e0de1>] ? SyS_futex+0x71/0x150
> >  [<ffffffff81010a45>] ? syscall_trace_enter+0x145/0x2a0
> >  [<ffffffff81760be4>] ? tracesys+0xdd/0xe2
> >

Hi Dave,

Can you get us an idea of the arguments trinity is tossing into
SYS_futex?

Op code? Would help to know if this was requeue_pi for example.
Type of memory being used for the uaddr?

I see futex_requeue in the stack, which means the opcode is one of:

FUTEX_REQUEUE
FUTEX_CMP_REQUEUE
FUTEX_CMP_REQUEUE_PI

FUTEX_REQUEUE has a known issue and was replaced with FUTEX_CMP_REQUEUE,
for details, test cases, and an analysis see the historic tree:

commit 9b91d73bde9d68800f9e5c338c0cf9d0fe3bc862
Author: Andrew Morton <akpm@osdl.org>
Date:   2004-05-31

    [PATCH] Add FUTEX_CMP_REQUEUE futex op

Specifically:
http://listman.redhat.com/archives/phil-list/2004-May/msg00023.html


Trinity is going to trigger hangs in futexes just by it's very nature,
but I believe you have watchdogs in place to kill such malformed tests
after a timeout?

I'll keep digging.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


