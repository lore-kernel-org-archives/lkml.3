Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaKSTiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:38:12 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:56114 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbaKSTiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:38:10 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXT3XvfoWvX2hBeW-S2nUHoeLqFFbnW-66H34_aUXKn8g@mail.gmail.com>
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
	<CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
	<CALCETrXT3XvfoWvX2hBeW-S2nUHoeLqFFbnW-66H34_aUXKn8g@mail.gmail.com>
Date: Wed, 19 Nov 2014 11:38:09 -0800
X-Google-Sender-Auth: 2H_5dyyiT0sHurz5bbwJ3ljRSWQ
Message-ID: <CA+55aFyRdYDzj_d42paCy-Tg33ysEmkTVVZ+A97b+-0LF_6Yeg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:15 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I suspect that the regression was triggered by the seccomp pull, since
> that reworked a lot of this code.

Note that it turns out that Dave can apparently see the same problems
with 3.17, so it's not actually a regression. So it may have been
going on for a while.


> Just to make sure I understand: it says "NMI watchdog", but this trace
> is from a timer interrupt, not NMI, right?

Yeah. The kernel/watchdog.c code always says "NMI watchdog", but it's
actually just a regular tiemr function: watchdog_timer_fn() started
with hrtimer_start().

> Is it possible that we've managed to return to userspace with
> interrupts off somehow?  A loop in userspace that somehow has
> interrupts off can cause all kinds of fun lockups.

That sounds unlikely, but if there is some stack corruption going on.

However, it wouldn't even explain things, because even if interrupts
had been disabled in user space, and even if that popf got executed,
this wouldn't be where they got enabled. That would be the :"sti" in
the system call entry path (hidden behind the ENABLE_INTERRUPTS
macro).

Of course, maybe Dave has paravirtualization enabled (what a crock
_that_ is), and there is something wrong with that whole code.

> I don't understand the logic of what enables TIF_NOHZ.

Yeah, that makes two of us.  But..

> In 3.17, I don't think that code would run with context tracking on,
> although I don't immediately see any bugs here.

See above: the problem apparently isn't new. Although it is possible
that we have two different issues going on..

                      Linus
