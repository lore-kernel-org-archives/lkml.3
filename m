Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbaKTTnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:43:11 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:41166 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbaKTTnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:43:09 -0500
MIME-Version: 1.0
In-Reply-To: <20141120152509.GA5412@redhat.com>
References: <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
	<20141118023930.GA2871@redhat.com>
	<CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
	<20141118145234.GA7487@redhat.com>
	<alpine.DEB.2.11.1411181914020.3909@nanos>
	<20141118215540.GD35311@redhat.com>
	<20141119021902.GA14216@redhat.com>
	<CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
	<20141119145902.GA13387@redhat.com>
	<546D0530.8040800@mit.edu>
	<20141120152509.GA5412@redhat.com>
Date: Thu, 20 Nov 2014 11:43:07 -0800
X-Google-Sender-Auth: Bm4byfuxssEk54EdzZUVQwoNBeQ
Message-ID: <CA+55aFzP0jivKYWUVwt==wNaBjZM+aBQLMT=Td+2cOVKSvm-dQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 7:25 AM, Dave Jones <davej@redhat.com> wrote:
>
> Disabling CONTEXT_TRACKING didn't change the problem.
> Unfortunatly the full trace didn't make it over usb-serial this time. Grr.
>
> Here's what came over serial..
>
> NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [trinity-c35:11634]
> RIP: 0010:[<ffffffff88379605>]  [<ffffffff88379605>] copy_user_enhanced_fast_string+0x5/0x10
> RAX: ffff880220eb4000 RBX: ffffffff887dac64 RCX: 0000000000006a18
> RDX: 000000000000e02f RSI: 00007f766f466620 RDI: ffff88016f6a7617
> RBP: ffff880220eb7f78 R08: 8000000000000063 R09: 0000000000000004
> Call Trace:
>  [<ffffffff882f4225>] ? SyS_add_key+0xd5/0x240
>  [<ffffffff8837adae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff887da092>] system_call_fastpath+0x12/0x17

Ok, that's just about half-way in a ~57kB memory copy (you can see it
in the register state: %rdx contains the original size of the key
payload, rcx contains the current remaining size: 57kB total, 27kB
left).

And it's holding absolutely zero locks, and not even doing anything
odd. It wasn't doing anything particularly odd before either, although
the kmalloc() of a 64kB area might just have caused a fair amount of
VM work, of course.

You know what? I'm seriously starting to think that these bugs aren't
actually real. Or rather, I don't think it's really a true softlockup,
because most of them seem to happen in totally harmless code.

So I'm wondering whether the real issue might not be just this:

   [loadavg: 164.79 157.30 155.90 37/409 11893]

together with possibly a scheduler issue and/or a bug in the smpboot
thread logic (that the watchdog uses) or similar.

That's *especially* true if it turns out that the 3.17 problem you saw
was actually a perf bug that has already been fixed and is in stable.
We've been looking at kernel/smp.c changes, and looking for x86 IPI or
APIC changes, and found some harmlessly (at least on x86) suspicious
code and this exercise might be worth it for that reason, but what if
it's really just a scheduler regression.

There's been a *lot* more scheduler changes since 3.17 than the small
things we've looked at for x86 entry or IPI handling. And the
scheduler changes have been about things like overloaded scheduling
groups etc, and I could easily imaging that some bug *there* ends up
causing the watchdog process not to schedule.

Hmm? Scheduler people?

                       Linus
