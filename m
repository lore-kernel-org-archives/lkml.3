Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaKSXtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:49:53 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:61648 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaKSXtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:49:51 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx4-WzNQ0e-ZTcCig3b7U7xmt1WB1jzO3TLk9zHD006ng@mail.gmail.com>
References: <cover.1416352397.git.luto@amacapital.net> <c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net>
 <CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
 <20141119192928.GL12538@two.firstfloor.org> <CA+55aFwykb6aZYgyZXbU1DQ3OL0umpv8gkHYWykBEC2B7UdMbw@mail.gmail.com>
 <CALCETrXi7vdNAk4RziNDtqX4asPqXxi1VsLzL7pP0zivkjTH4Q@mail.gmail.com> <CA+55aFx4-WzNQ0e-ZTcCig3b7U7xmt1WB1jzO3TLk9zHD006ng@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Nov 2014 15:49:29 -0800
Message-ID: <CALCETrVJJUcPRfkWRouLJCNUVNRH3aWX0X_K8L62yrUu1aR8Vg@mail.gmail.com>
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

On Wed, Nov 19, 2014 at 3:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 19, 2014 at 3:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> Does that include nmi?  I'm a bit afraid of touching that code.
>
> NMI is kind of special, since it's really not supposed to touch
> 'current' or anything like that, and that's how we do preempt-count
> (and that's where irq-count is) right now.
>
> I would prefer to have preempt_count be a percpu variable rather than
> a per-thread one, but there are historical reasons for that horror. Oh
> well.
>
>> It's certainly easy enough to bump irq_count in the paranoid entries.
>
> It definitely shouldn't be done from the assembly code. Usually it's
> "irq_enter/exit()" that does it, but for NMI you'd presumably just do
> it explicitly from do_nmi() or similar. But NMI really is nastier than
> other cases, see above.

My only real objection is that it's going to be ugly and error prone.
It'll have to be something like:

if (!user_mode_vm(regs))
    irq_enter();

...

if (!user_mode_vm(regs))
    irq_exit();

because the whole point of this series is to make the IST entries not
be atomic when they come from userspace.  We can wrap this in an
inline cond_ist_enter/cond_ist_exit or whatever, but still, blech.

Tony already sent the follow-up patch that will make do_machine_check
enable interrupts if it came from userspace.

--Andy

>
> (That said, I thought we did it anyway, but now that I look I can't
> find it. So I was probably just smoking something)
>
>              Linus



-- 
Andy Lutomirski
AMA Capital Management, LLC
