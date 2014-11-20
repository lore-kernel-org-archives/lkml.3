Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaKTCm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 21:42:27 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:43768 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaKTCm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 21:42:26 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrWyVtSQigP=mqoDiw5An4nSdXtig5dJCvTgF1onCJ3o1Q@mail.gmail.com>
References: <20141118145234.GA7487@redhat.com>
	<alpine.DEB.2.11.1411181914020.3909@nanos>
	<20141118215540.GD35311@redhat.com>
	<20141119021902.GA14216@redhat.com>
	<CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
	<20141119145902.GA13387@redhat.com>
	<CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
	<CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
	<20141119190215.GA10796@lerouge>
	<alpine.DEB.2.11.1411192251120.3909@nanos>
	<20141119225615.GA11386@lerouge>
	<alpine.DEB.2.11.1411200002330.3909@nanos>
	<CALCETrXyrk0VBbZy48nsUWnk82wFp6gpv_zw_F=3GKSDAR7T+Q@mail.gmail.com>
	<alpine.DEB.2.11.1411200059410.3909@nanos>
	<CALCETrXwjPKcCA6t=wjyKWZbREKFTF9E-n9eRa0C39R5O8Q0PQ@mail.gmail.com>
	<CA+55aFxi5mNNXFH20AwrgOVsT1HyuU1a63VYm6m+j0jSVr4dGQ@mail.gmail.com>
	<CALCETrU2Ag1LNveFq88q54wCxCPLi5onCNZzkOD0A_N3x_x6Tw@mail.gmail.com>
	<CA+55aFy8gzquS-RnjxO3aax8=TNcrm42zK_udpOMdzxSjTbcQg@mail.gmail.com>
	<CALCETrWyVtSQigP=mqoDiw5An4nSdXtig5dJCvTgF1onCJ3o1Q@mail.gmail.com>
Date: Wed, 19 Nov 2014 18:42:24 -0800
X-Google-Sender-Auth: YuGNRW_9pr14-d95JxGKWt50_m4
Message-ID: <CA+55aFy2vKrXKo8Q=UU7AB5FujqS83Cb5E1gSjMFPOoom1X6sA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
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

On Wed, Nov 19, 2014 at 5:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> And you were calling me crazy? :)

Hey, I'm crazy like a fox.

> We could be restarting just about anything if that happens. Except
> that if we double-faulted on a trap gate entry instead of an interrupt
> gate entry, then we can't restart, and, unless we can somehow decode
> the error code usefully (it's woefully undocumented), int 0x80 and
> int3 might be impossible to handle correctly if it double-faults.  And
> please don't suggest moving int 0x80 to an IST stack :)

No, no.  So tell me if this won't work:

 - when forking a new process, make sure we allocate the vmalloc stack
*before* we copy the vm

 - this should guarantee that all new processes will at least have its
*own* stack always in its page tables, since vmalloc always fills in
the page table of the current page tables of the thread doing the
vmalloc.

HOWEVER, that leaves the task switch *to* that process, and making
sure that the stack pointer is ok in between the "switch %rsp" and
"switch %cr3".

So then we make the rule be: switch %cr3 *before* switching %rsp, and
only in between those places can we get in trouble. Yes/no?

And that small section is all with interrupts disabled, and nothing
should take an exception. The C code might take a double fault on a
regular access to the old stack (the *new* stack is guaranteed to be
mapped, but the old stack is not), but that should be very similar to
what we already do with "iret". So we can just fill in the page tables
and return.

For safety, add a percpu counter that is cleared before the %cr3
setting, to make sure that we only do a *single* double-fault, but it
really sounds pretty safe. No?

The only deadly thing would be NMI, but that's an IST anyway, so not
an issue. No other traps should be able to happen except the double
page table miss.

But hey, maybe I'm not crazy like a fox. Maybe I'm just plain crazy,
and I missed something else.

And no, I don't think the above is necessarily a *good* idea. But it
doesn't seem really overly complicated either.

                      Linus
