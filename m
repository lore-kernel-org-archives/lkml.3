Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab3LJWsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:48:54 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:37592 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3LJWsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:48:53 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
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
	<alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
Date: Tue, 10 Dec 2013 14:48:52 -0800
X-Google-Sender-Auth: ab-r13FqdMsEC48Rh4nk2UWsBHg
Message-ID: <CA+55aFzhCSvc4Vy7tEC2K972h+vne6Y0QSekDDZbV_ATB-9mxw@mail.gmail.com>
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

On Tue, Dec 10, 2013 at 2:42 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> And yes, I remember that we do not do an extra check for the fshared
> case, because get_user_pages_fast() should do it for us already. If
> not we are fubared not only in the futex code.

Yeah. It turns out we do do the access check indirectly - by looking
at the PAGE_USER bit, even if we don't necessarily check the actual
limits. So get_user_pages_fast() is fine.

> But there is a subtle detail:

Yup, see my email from ten minutes ago, we found the same thing. And
that would seem to explain the endless loop, and also the timing
(since Dave mentions he started doing large-pages lately).

So I think the "__get_user_pages_fast(address, 1, !ro, &page)" thing
should work.

Dave, can you re-create that trinity run and test that patch? I think
we've got this, but it might be nice to leave the hung machine up and
running until it's verified.. Although I don't really see what else we
could need or get out of it, so..

             Linus
