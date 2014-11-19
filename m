Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaKSRWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:22:11 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:40620 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbaKSRWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:22:08 -0500
MIME-Version: 1.0
In-Reply-To: <20141119145902.GA13387@redhat.com>
References: <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
	<20141118020959.GA2091@redhat.com>
	<CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
	<20141118023930.GA2871@redhat.com>
	<CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
	<20141118145234.GA7487@redhat.com>
	<alpine.DEB.2.11.1411181914020.3909@nanos>
	<20141118215540.GD35311@redhat.com>
	<20141119021902.GA14216@redhat.com>
	<CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
	<20141119145902.GA13387@redhat.com>
Date: Wed, 19 Nov 2014 09:22:07 -0800
X-Google-Sender-Auth: clj6UWN97Wolo1U-3SRckY1l9RE
Message-ID: <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 6:59 AM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Nov 18, 2014 at 08:40:55PM -0800, Linus Torvalds wrote:
>  >
>  > That makes me wonder: does the problem go away if you disable NOHZ?
>
> Aparently not.
>
> NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [trinity-c75:25175]
> CPU: 3 PID: 25175 Comm: trinity-c75 Not tainted 3.18.0-rc5+ #92 [loadavg: 168.72 151.72 150.38 9/410 27945]
> RIP: 0010:[<ffffffff94175be7>]  [<ffffffff94175be7>] context_tracking_user_exit+0x57/0x120
> Call Trace:
>  [<ffffffff94012c25>] syscall_trace_enter_phase1+0x125/0x1a0
>  [<ffffffff9437b3be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff947d41bf>] tracesys+0x14/0x4a

Ok, that's just crazy. This is the system call *entry* portion.

Last time it was the system call exit side, which at least made some
sense, because the "return to user space" thing actually has loops in
it to handle all events before we return to user space.

But the whole 'tracesys' part is only entered once, at the very
beginning of a system call. There's no loop over the work. That whole
call trace implies that the lockup happened just after we entered the
system call path from _user_ space.

And in fact, exactly like last time, the code line implies that the
timer interrupt happened on the return from the instruction, and
indeed in both cases the code looked like this (the registers
differed, but the "restore flags, start popping saved regs" was the
exact same):

  26: 53                   push   %rbx
  27: 9d                   popfq
  28:* 5b                   pop    %rbx <-- trapping instruction
  29: 41 5c                 pop    %r12

in both cases, the timer interrupt happened right after the "popfq",
but in both cases the value in the register that was used to restore
eflags was invalid. Here %rbx was 0x0000000100000046 (which is a valid
eflags value, but not the one we've actually restored!), and in your
previous oops (where it was %r12) it was completely invalid.

So it hasn't actually done the "push %rbx; popfq" part - there must be
a label at the return part, and context_tracking_user_exit() never
actually did the local_irq_save/restore at all. Which means that it
took one of the early exits instead:

        if (!context_tracking_is_enabled())
                return;

        if (in_interrupt())
                return;

So not only does this happen at early system call entry time, the
function that is claimed to lock up doesn't actually *do* anything.

Ho humm..

Oh, and to make matters worse, the only way this call chain can happen
is this in syscall_trace_enter_phase1():

        if (work & _TIF_NOHZ) {
                user_exit();
                work &= ~TIF_NOHZ;
        }

so there's still some NOHZ confusion there. It looks like TIF_NOHZ
gets set regardless of whether NOHZ is enabled or not..

I'm adding Frederic explicitly to the cc too, because this is just
fishy.  I am starting to blame context tracking, because it has now
shown up twice in different guises, and TIF_NOHZ seems to be
implicated.

> CPU: 1 PID: 25164 Comm: trinity-c64 Not tainted 3.18.0-rc5+ #92 [loadavg: 168.72 151.72 150.38 9/410 27945]
> RIP: 0010:[<ffffffff940fb71e>]  [<ffffffff940fb71e>] generic_exec_single+0xee/0x1a0
> Call Trace:
>  [<ffffffff940fb89a>] smp_call_function_single+0x6a/0xe0
>  [<ffffffff941671aa>] perf_event_read+0xca/0xd0
>  [<ffffffff94167240>] perf_event_read_value+0x90/0xe0
>  [<ffffffff941689c6>] perf_read+0x226/0x370
>  [<ffffffff941eafff>] vfs_read+0x9f/0x180

Hmm.. We've certainly seen a lot of smp_call, for various different
reasons in your traces..

I'm wondering if the smp-call ended up corrupting something on CPU3.
Because even _with_ TIF_NOHZ confusion, I don't see how system call
*entry* could cause a watchdog event. There are no loops, there are no
locks I see, there is just *nothing* there I can see.

Let's add Andy L to the cc too, in case he hasn't seen this.  He's
been changing the lowlevel asm code, including very much this whole
"syscall_trace_enter_phase1" thing. Maybe he sees something I don't.

Andy?

> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc5+ #92 [loadavg: 168.72 151.72 150.38 11/410 27945]
> RIP: 0010:[<ffffffff943dd415>]  [<ffffffff943dd415>] intel_idle+0xd5/0x180
> CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.18.0-rc5+ #92 [loadavg: 168.72 151.72 150.38 10/410 27945]
> RIP: 0010:[<ffffffff943dd415>]  [<ffffffff943dd415>] intel_idle+0xd5/0x180

Nothing there.

> Also, today I learned we can reach the perf_event_read code from
> read(). Given I had /proc/sys/kernel/perf_event_paranoid set to 1,
> I'm not sure how this is even possible. The only user of perf_fops
> is perf_event_open syscall _after_ it's checked that sysctl.
>
> Oh, there's an ioctl path to perf too. Though trinity
> doesn't know anything about it, so I find it surprising if it
> managed to pull the right combination of entropy to make that
> do the right thing.  Still, that ioctl path probably needs
> to also be checking that sysctl shouldn't it ?

Hmm. Perf people are already mostly on the list. Peter/Ingo/Arnaldo?

                      Linus
