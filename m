Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaKTGRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:17:15 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:61803 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaKTGRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:17:14 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFy2vKrXKo8Q=UU7AB5FujqS83Cb5E1gSjMFPOoom1X6sA@mail.gmail.com>
References: <20141118145234.GA7487@redhat.com> <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com> <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com> <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
 <20141119190215.GA10796@lerouge> <alpine.DEB.2.11.1411192251120.3909@nanos>
 <20141119225615.GA11386@lerouge> <alpine.DEB.2.11.1411200002330.3909@nanos>
 <CALCETrXyrk0VBbZy48nsUWnk82wFp6gpv_zw_F=3GKSDAR7T+Q@mail.gmail.com>
 <alpine.DEB.2.11.1411200059410.3909@nanos> <CALCETrXwjPKcCA6t=wjyKWZbREKFTF9E-n9eRa0C39R5O8Q0PQ@mail.gmail.com>
 <CA+55aFxi5mNNXFH20AwrgOVsT1HyuU1a63VYm6m+j0jSVr4dGQ@mail.gmail.com>
 <CALCETrU2Ag1LNveFq88q54wCxCPLi5onCNZzkOD0A_N3x_x6Tw@mail.gmail.com>
 <CA+55aFy8gzquS-RnjxO3aax8=TNcrm42zK_udpOMdzxSjTbcQg@mail.gmail.com>
 <CALCETrWyVtSQigP=mqoDiw5An4nSdXtig5dJCvTgF1onCJ3o1Q@mail.gmail.com> <CA+55aFy2vKrXKo8Q=UU7AB5FujqS83Cb5E1gSjMFPOoom1X6sA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Nov 2014 22:16:51 -0800
Message-ID: <CALCETrWOo_g+KPuPeYkTxyVR8AphEQxR7xvxa5Z=vVadtLSiLw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 6:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 19, 2014 at 5:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> And you were calling me crazy? :)
>
> Hey, I'm crazy like a fox.
>
>> We could be restarting just about anything if that happens. Except
>> that if we double-faulted on a trap gate entry instead of an interrupt
>> gate entry, then we can't restart, and, unless we can somehow decode
>> the error code usefully (it's woefully undocumented), int 0x80 and
>> int3 might be impossible to handle correctly if it double-faults.  And
>> please don't suggest moving int 0x80 to an IST stack :)
>
> No, no.  So tell me if this won't work:
>
>  - when forking a new process, make sure we allocate the vmalloc stack
> *before* we copy the vm
>
>  - this should guarantee that all new processes will at least have its
> *own* stack always in its page tables, since vmalloc always fills in
> the page table of the current page tables of the thread doing the
> vmalloc.

This gets interesting for kernel threads that don't really have an mm
in the first place, though.

>
> HOWEVER, that leaves the task switch *to* that process, and making
> sure that the stack pointer is ok in between the "switch %rsp" and
> "switch %cr3".
>
> So then we make the rule be: switch %cr3 *before* switching %rsp, and
> only in between those places can we get in trouble. Yes/no?
>

Kernel threads aside, sure.  And we do it in this order anyway, I think.

> And that small section is all with interrupts disabled, and nothing
> should take an exception. The C code might take a double fault on a
> regular access to the old stack (the *new* stack is guaranteed to be
> mapped, but the old stack is not), but that should be very similar to
> what we already do with "iret". So we can just fill in the page tables
> and return.

Unless we try to dump the stack from an NMI or something, but that
should be fine regardless.

>
> For safety, add a percpu counter that is cleared before the %cr3
> setting, to make sure that we only do a *single* double-fault, but it
> really sounds pretty safe. No?

I wouldn't be surprised if that's just as expensive as just fixing up
the pgd in the first place.  The fixup is just:

if (unlikely(pte_none(mm->pgd[pgd_address(rsp)]))) fix it;

or something like that.

>
> The only deadly thing would be NMI, but that's an IST anyway, so not
> an issue. No other traps should be able to happen except the double
> page table miss.
>
> But hey, maybe I'm not crazy like a fox. Maybe I'm just plain crazy,
> and I missed something else.

I actually kind of like it, other than the kernel thread issue.

We should arguably ditch lazy mm for kernel threads in favor of PCID,
but that's a different story.  Or we could beg Intel to give us
separate kernel and user page table hierarchies.

--Andy

>
> And no, I don't think the above is necessarily a *good* idea. But it
> doesn't seem really overly complicated either.
>
>                       Linus



-- 
Andy Lutomirski
AMA Capital Management, LLC
