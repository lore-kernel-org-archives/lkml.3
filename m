Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaKSTCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:02:23 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58312 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbaKSTCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:02:21 -0500
Date: Wed, 19 Nov 2014 20:02:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119190215.GA10796@lerouge>
References: <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 09:40:26AM -0800, Linus Torvalds wrote:
> On Wed, Nov 19, 2014 at 9:22 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So it hasn't actually done the "push %rbx; popfq" part - there must be
> > a label at the return part, and context_tracking_user_exit() never
> > actually did the local_irq_save/restore at all. Which means that it
> > took one of the early exits instead:
> >
> >         if (!context_tracking_is_enabled())
> >                 return;
> >
> >         if (in_interrupt())
> >                 return;
> 
> Ho humm. Interesting. Neither of those should possibly have happened.
> 
> We "know" that "context_tracking_is_enabled()" must be true, because
> the only way we get to context_tracking_user_exit() in the first place
> is through "user_exit()", which does:
> 
>         if (context_tracking_is_enabled())
>                 context_tracking_user_exit();
> 
> and we know we shouldn't be in_interrupt(), because the backtrace is
> the system call entry path, for chrissake!
> 
> So we definitely have some corruption going on. A few possibilities:
> 
>  - either the register contents are corrupted (%rbx in your dump said
> "0x0000000100000046", but the eflags we restored was 0x246)
> 
>  - in_interrupt() is wrong, and we've had some irq_count() corruption.
> I'd expect that to result in "scheduling while atomic" messages,
> though, especially if it goes on long enough that you get a watchdog
> event..
> 
>  - there is something rotten in the land of
> context_tracking_is_enabled(), which uses a static key.
> 
>  - I have misread the whole trace, and am a moron. But your earlier
> report really had some very similar things, just in
> context_tracking_user_enter() instead of exit.
> 
> In your previous oops, the registers that was allegedly used to
> restore %eflags was %r12:
> 
>   28: 41 54                 push   %r12
>   2a: 9d                   popfq
>   2b:* 5b                   pop    %rbx <-- trapping instruction
>   2c: 41 5c                 pop    %r12
>   2e: 5d                   pop    %rbp
>   2f: c3                   retq
> 
> but:
> 
>   R12: ffff880101ee3ec0
>   EFLAGS: 00000282
> 
> so again, it looks like we never actually did that "popfq"
> instruction, and it would have exited through the (same) early exits.
> 
> But what an odd coincidence that it ended up in both of your reports
> being *exactly* at that instruction after the "popf". If it had
> actually *taken* the popf, I'd not be so surprised ("ok, popf enabled
> interrupts, and there was an interrupt pending"), but since everything
> seems to say that it came there through some control flow that did
> *not* go through the popf, that's just a very odd coincidence.
> 
> And both context_tracking_user_enter() and exit() have that exact same
> issue with the early returns. They shouldn't have happened in the
> first place.

I got a report lately involving context tracking. Not sure if it's
the same here but the issue was that context tracking uses per cpu data
and per cpu allocation use vmalloc and vmalloc'ed area can fault due to
lazy paging.

With that in mind, about eveything can happen. Some parts of the context tracking
code really aren't fault-safe (or more generally exception safe). That's because
context tracking itself tracks exceptions.

So for example if we enter a syscall, we go to context_tracking_user_exit() then
vtime_user_enter() which _takes a lock_ with write_seqlock().

If an exception occurs before we unlock the seqlock (it's possible for
example account_user_time() -> task_group_account_field()-> cpuacct_account_field()
accesses dynamically allocated per cpu area which can fault) then
the fault calls exception_enter() then user_exit() which does all the same again
and deadlocks.

I can certainly fix that with a few recursion protection.

Now we just need to determine if the current case has the same cause.
