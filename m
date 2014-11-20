Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbaKTANw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:13:52 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:51863 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbaKTANt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:13:49 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFy0neTJAAm-8KsmPPU33zevyHmYa+vZjPk-DozSPPW_nQ@mail.gmail.com>
References: <cover.1416352397.git.luto@amacapital.net> <c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net>
 <CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
 <20141119192928.GL12538@two.firstfloor.org> <CA+55aFwykb6aZYgyZXbU1DQ3OL0umpv8gkHYWykBEC2B7UdMbw@mail.gmail.com>
 <CALCETrXi7vdNAk4RziNDtqX4asPqXxi1VsLzL7pP0zivkjTH4Q@mail.gmail.com>
 <CA+55aFx4-WzNQ0e-ZTcCig3b7U7xmt1WB1jzO3TLk9zHD006ng@mail.gmail.com>
 <CALCETrVJJUcPRfkWRouLJCNUVNRH3aWX0X_K8L62yrUu1aR8Vg@mail.gmail.com> <CA+55aFy0neTJAAm-8KsmPPU33zevyHmYa+vZjPk-DozSPPW_nQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Nov 2014 16:13:27 -0800
Message-ID: <CALCETrXzMe2WcpY3yX48WtvdRQDvSg7CZRO1T1TdLynmAcJHXg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] sched, x86: Check that we're on the right stack in
 schedule and __might_sleep
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 3:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 19, 2014 at 3:49 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> My only real objection is that it's going to be ugly and error prone.
>> It'll have to be something like:
>
> No.
>
>> because the whole point of this series is to make the IST entries not
>> be atomic when they come from userspace.
>
> Andy,  you need to lay off the drugs.
>

No drugs, just imprecision.  This series doesn't change NMI handling
at all.  It only changes machine_check int3, debug, and stack_segment.
(Why is #SS using IST stacks anyway?)

So my point stands: if machine_check is going to be conditionally
atomic, then that condition needs to be expressed somewhere.  And
machine_check really does need to sleep, and it does so today.  It's
just that, in current kernels, it pretends to be atomic, but then it
fakes everyone out before returning (look for sync_regs in entry_64.S)
and becomes non-atomic part-way through, mediated by a special TIF
flag.  I think that the current conditional sync_regs thing is even
crazier than switching stacks depending on regs->cs, so I'm trying to
reduce craziness.

With this series applied, machine_check is honest: if it came from
user space, it doesn't even pretend to be atomic.

And I'm not even making these things preemptable by default.  They
still run with irqs off.  They're just allowed to turn irqs off *if
user_mode_vm(regs)* if they want.

> NMI absolutely *has* to be atomic. The whole "oh, there's a per-core
> NMI flag and it disables all other NMI's and interrupts" kind of
> enforces that.
>
> Trust me. Talking about being able to preempt the NMI handler is just
> crazy talk.

I engage in crazy talk all the time, but I'm not *that* crazy.

--Andy
