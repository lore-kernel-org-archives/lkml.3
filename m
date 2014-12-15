Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055AbaLOFrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 00:47:31 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:55605 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaLOFr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 00:47:27 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
References: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<20141214234654.GA396@redhat.com>
	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
Date: Sun, 14 Dec 2014 21:47:26 -0800
X-Google-Sender-Auth: pHUp4HOJwRo4aYBlBNSFuTqJaHY
Message-ID: <CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 4:38 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Can anybody make sense of that backtrace, keeping in mind that we're
> looking for some kind of endless loop where we don't make progress?

So looking at all the backtraces, which is kind of messy because
there's some missing data (presumably buffers overflowed from all the
CPU's printing at the same time), it looks  like:

 - CPU 0 is missing. No idea why.
 - CPU's 1-3 all have the same trace for

    int_signal ->
    do_notify_resume ->
    do_signal ->
      ....
    page_fault ->
    do_page_fault

and "save_xstate_sig+0x81" shows up on all stacks, although only on
CPU1 does it show up as a "guaranteed" part of the stack chain (ie it
matches frame pointer data too). CPU1 also has that __clear_user show
up (which is called from save_xstate_sig), but not other CPU's.  CPU2
and CPU3 have "save_xstate_sig+0x98" in addition to that +0x81 thing.

My guess is that "save_xstate_sig+0x81" is the instruction after the
__clear_user call, and that CPU1 took the fault in __clear_user(),
while CPU2 and CPU3 took the fault at "save_xstate_sig+0x98" instead,
which I'd guess is the

        xsave64 (%rdi)

and in fact, with CONFIG_FTRACE on, my own kernel build gives exactly
those two offsets for those things in save_xstate_sig().

So I'm pretty certain that on all three CPU's, we had page faults for
save_xstate_sig() accessing user space, with the only difference being
that on CPU1 it happened from __clear_user, while on CPU's 2/3 it
happened on the xsaveq instruction itself.

That sounds like much more than coincidence. I have no idea where CPU0
is hiding, and all CPU's were at different stages of actually handling
the fault, but that's to be expected if the page fault just keeps
repeating.

In fact, CPU2 shows up three different times, and the call trace
changes in between, so it's "making progress", just never getting out
of that loop. The traces are

    pagecache_get_page+0x0/0x220
    ? lookup_swap_cache+0x2a/0x70
    handle_mm_fault+0x401/0xe90
    ? __do_page_fault+0x198/0x5c0
    __do_page_fault+0x1fc/0x5c0
    ? trace_hardirqs_on_thunk+0x3a/0x3f
    ? __do_softirq+0x1ed/0x310
    ? retint_restore_args+0xe/0xe
    ? trace_hardirqs_off_thunk+0x3a/0x3c
    do_page_fault+0xc/0x10
    page_fault+0x22/0x30
    ? save_xstate_sig+0x98/0x220
    ? save_xstate_sig+0x81/0x220
    do_signal+0x5c7/0x740
    ? _raw_spin_unlock_irq+0x30/0x40
    do_notify_resume+0x65/0x80
    ? trace_hardirqs_on_thunk+0x3a/0x3f
    int_signal+0x12/0x17

and

    ? __lock_acquire.isra.31+0x22c/0x9f0
    ? lock_acquire+0xb4/0x120
    ? __do_page_fault+0x198/0x5c0
    down_read_trylock+0x5a/0x60
    ? __do_page_fault+0x198/0x5c0
    __do_page_fault+0x198/0x5c0
    ? __do_softirq+0x1ed/0x310
    ? retint_restore_args+0xe/0xe
    ? __do_page_fault+0xd8/0x5c0
    ? trace_hardirqs_off_thunk+0x3a/0x3c
    do_page_fault+0xc/0x10
    page_fault+0x22/0x30
    ? save_xstate_sig+0x98/0x220
    ? save_xstate_sig+0x81/0x220
    do_signal+0x5c7/0x740
    ? _raw_spin_unlock_irq+0x30/0x40
    do_notify_resume+0x65/0x80
    ? trace_hardirqs_on_thunk+0x3a/0x3f
    int_signal+0x12/0x17

and

    lock_acquire+0x40/0x120
    down_read_trylock+0x5a/0x60
    ? __do_page_fault+0x198/0x5c0
    __do_page_fault+0x198/0x5c0
    ? trace_hardirqs_on_thunk+0x3a/0x3f
    ? trace_hardirqs_on_thunk+0x3a/0x3f
    ? __do_softirq+0x1ed/0x310
    ? retint_restore_args+0xe/0xe
    ? trace_hardirqs_off_thunk+0x3a/0x3c
    do_page_fault+0xc/0x10
    page_fault+0x22/0x30
    ? save_xstate_sig+0x98/0x220
    ? save_xstate_sig+0x81/0x220
    do_signal+0x5c7/0x740
    ? _raw_spin_unlock_irq+0x30/0x40
    do_notify_resume+0x65/0x80
    ? trace_hardirqs_on_thunk+0x3a/0x3f
    int_signal+0x12/0x17

so it's always in __do_page_fault, but at sometimes it has gotten into
handle_mm_fault too. So it really really looks like it is taking an
endless stream of page faults on that "xsaveq" instruction. Presumably
the page faulting never actually makes any progress, even though it
*thinks* the page tables are fine.

DaveJ - you've seen that "endless page faults" behavior before. You
had a few traces that showed it. That was in that whole "pipe/page
fault oddness." email thread, where you would get endless faults in
copy_page_to_iter() with an error_code=0x2.

That was the one where I chased it down to "page table entry must be
marked with _PAGE_PROTNONE", but VM_WRITE in the vma, because your
machine was alive enough that you got traces out of the endless loop.

Very odd.

              Linus
