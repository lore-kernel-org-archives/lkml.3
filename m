Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbaKTAhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:37:16 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:50181 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaKTAhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:37:14 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXzMe2WcpY3yX48WtvdRQDvSg7CZRO1T1TdLynmAcJHXg@mail.gmail.com>
References: <cover.1416352397.git.luto@amacapital.net>
	<c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net>
	<CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
	<20141119192928.GL12538@two.firstfloor.org>
	<CA+55aFwykb6aZYgyZXbU1DQ3OL0umpv8gkHYWykBEC2B7UdMbw@mail.gmail.com>
	<CALCETrXi7vdNAk4RziNDtqX4asPqXxi1VsLzL7pP0zivkjTH4Q@mail.gmail.com>
	<CA+55aFx4-WzNQ0e-ZTcCig3b7U7xmt1WB1jzO3TLk9zHD006ng@mail.gmail.com>
	<CALCETrVJJUcPRfkWRouLJCNUVNRH3aWX0X_K8L62yrUu1aR8Vg@mail.gmail.com>
	<CA+55aFy0neTJAAm-8KsmPPU33zevyHmYa+vZjPk-DozSPPW_nQ@mail.gmail.com>
	<CALCETrXzMe2WcpY3yX48WtvdRQDvSg7CZRO1T1TdLynmAcJHXg@mail.gmail.com>
Date: Wed, 19 Nov 2014 16:37:13 -0800
X-Google-Sender-Auth: EQiy30zMbLWSZ_tf_FKF0o-AC9Q
Message-ID: <CA+55aFxNkD8=1JB0-4EyQTR+Yd0YaofB3+E5J+L3vsfki-RUSQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] sched, x86: Check that we're on the right stack in
 schedule and __might_sleep
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 4:13 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> No drugs, just imprecision.  This series doesn't change NMI handling
> at all.  It only changes machine_check int3, debug, and stack_segment.
> (Why is #SS using IST stacks anyway?)

.. ok, we were talking about adding an explicit preemption count to
nmi, and then you wanted to make that conditional, that kind of
freaked me out.

> So my point stands: if machine_check is going to be conditionally
> atomic, then that condition needs to be expressed somewhere.

I'd still prefer to keep that knowledge in one place, rather than
adding *another* completely ad-hoc thing in addition to what we
already have.

Also, I really don't think it should be about the particular stack
you're using. Sure, if a debug fault happens in user space, the fault
handler could sleep if it runs on the regular stack, but our
"might_sleep()" are about catching things that *could* be problematic,
even if the sleep never happens. And so, might_sleep() _should_
actually trigger, even if it's not using the IST stack, because *if*
the debug exception happened in kernel space, then we should warn.

So I'd actually *prefer* to have special hacks that perhaps then
"undo" the preemption count if the code expressly tests for "did this
happen in user space, then I know I'm safe". But then it's an
*explicit* thing, not something that just magically works because
nobody even thought about it, and the trap happened in user space.

See the argument? I'd *rather* see code like

   /* Magic */
   if (user_mode(regs)) {
       .. verify that we're using the normal kernel stack
       .. enable interrupts, enable preemption
       .. this is the explicit special case and it is aware
       .. of being special
   }

even if on the face of it it looks hacky. But an *explicit* hack is
preferable to something that just "happens" to work only for the
user-mode case.

                   Linus
