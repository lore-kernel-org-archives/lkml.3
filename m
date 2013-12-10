Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3LJXFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:05:48 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:40169 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3LJXFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1312102348120.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	<CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	<20131210203559.GA1209@redhat.com>
	<20131210204925.GB27373@redhat.com>
	<20131210213431.GA6342@redhat.com>
	<20131210214143.GG27373@redhat.com>
	<CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
	<CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
	<CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
	<alpine.DEB.2.02.1312102348120.28330@ionos.tec.linutronix.de>
Date: Tue, 10 Dec 2013 15:05:46 -0800
X-Google-Sender-Auth: -iDIc1MWuaGIpp36jb5Y5yWgMU8
Message-ID: <CA+55aFymvumbFXw6azLH+-3y6RB7mT_cho-wJguMepezzG=YQA@mail.gmail.com>
Subject: Re: process 'stuck' at exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 2:57 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> But how does the access_ok() move do anything helpful here?

Just making it all more obvious.

> We really need it for the fastpath !fshared case, but for the fshared
> case you actively break working code, because you force a VERIFY_WRITE
> check into it. The VERIFY_WRITE is necessary for !fshared, because
> there is no way that one thread can map the futex RO and the other RW,
> right?

Nobody actually uses that argument any more (it goes back to the old
i386 "let's manually verify that we have write permissions, because
the CPU doesn't do it for us in the trap handling"), and it should
probably be removed.

But you're right that it's at least misleading. I'd love to remove it
entirely, because it's not even syntax-checked, and it's confusing.
But that would be a humongous patch.

So these days, "access_ok()" literally just checks that the address is
in the user address space range. And that would seem to always be
appropriate for futexes, so why not just do it in the generic code?

             Linus
