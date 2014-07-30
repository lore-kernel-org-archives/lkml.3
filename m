Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaG3Pr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:47:58 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:38739 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbaG3Pr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:47:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140730065312.GA1652@laptop.redhat.com>
References: <20140730014827.565626091@linuxfoundation.org>
	<20140730014829.344302554@linuxfoundation.org>
	<20140730065312.GA1652@laptop.redhat.com>
Date: Wed, 30 Jul 2014 08:47:55 -0700
X-Google-Sender-Auth: 9MuBfIxvhO_rpyp11x6cxjy_-pY
Message-ID: <CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of load_balance()
 in scheduler
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 11:53 PM, Jakub Jelinek <jakub@redhat.com> wrote:
>
> IMNSHO this is a too big hammer approach.  The bug happened on a single
> file only (right?)

Very dubious. We happened to see it in a single case, and _maybe_ that
was the only one in the whole kernel. But it's much more likely that
it wasn't - it's not like the code in question was even all that
unusual (just a percpu access triggering an asm - but we have tons of
asms in the kernel).

I'd argue that we were very lucky to get the problem happening
reliably enough for a couple of people who then cared enoiugh to do
good bug reports (considering that it needed an interrupt in *just*
the right place) that we could debug it at all. In some code that gets
run much less than the scheduler, it could easily have been one of
those "people report it once in a blue moon, looks like memory
corruption".

Now, it would be interesting to hear if there is something very
special that made that instruction scheduling bug trigger just for
4.9.x, or if there is something else that made it very particular to
that code sequence. But in the absence of good reasoning to the
contrary, I'd much rather say "let's just avoid the bug entirely".

And that's partly because we really don't care that much about the
debug info. Yes, it gets used, but it's not *that* common, and the
last time the issue of debug info sucking up tons of resources came
up, the biggest users were people who just wanted line information for
oopses. Yes, there are people running kgdb etc, but on the whole it's
rare, and quite frankly, from everything I have _ever_ seen, that's
not how the real kernel bugs are ever really discovered. So the kind
of debug information that the variable tracking logic adds just isn't
all that important for the kernel.

                 Linus
