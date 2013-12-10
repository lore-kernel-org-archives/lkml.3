Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3LJTSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:18:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:50667 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3LJTSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:18:35 -0500
Date: Tue, 10 Dec 2013 20:18:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
In-Reply-To: <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com> <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Linus Torvalds wrote:

> Hmm. Looks like the futex code is somehow stuck in a loop, calling
> get_user_pages_fast().
> 
> The futex code itself is apparently so low-overhead that it doesn't
> show up in your 'perf top' report (which is dominated by all the
> expensive debug things that get_user_pages_fast() etc ends up doing),
> but that's the only looping I can see. Perhaps the "goto again" case
> for transparent huge pages in get_futex_key()? Or the

Cc'ng more folks on that.

> "retry[_private]" cases in futex_requeue()? Some error condition that
> causes us to retry forever, rather than returning the error code?

So this is pretty unlikely. The retry requires:

   get_futex_value_locked() == EFAULT;
   
Now we drop the hash bucket locks and do:

   get_user();

And if that get_user() faults again, we bail out.

If it succeeds we try again. So between the get_user() and the next
get_futex_value_locked() the effect of get_user() must have been
undone. I guess this can happen, but a gazillion times in a row?

> 
> Added a few more people to the cc.. Ideas?

...

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
> >
> > any ideas ?
> >
> >         Dave
> >
> 
