Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab3LJX2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:28:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:52115 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3LJX2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:28:33 -0500
Date: Wed, 11 Dec 2013 00:28:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
In-Reply-To: <CA+55aFymvumbFXw6azLH+-3y6RB7mT_cho-wJguMepezzG=YQA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1312110025340.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com> <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com> <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de> <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com> <20131210204925.GB27373@redhat.com> <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com> <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com> <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com> <alpine.DEB.2.02.1312102348120.28330@ionos.tec.linutronix.de> <CA+55aFymvumbFXw6azLH+-3y6RB7mT_cho-wJguMepezzG=YQA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Linus Torvalds wrote:

> On Tue, Dec 10, 2013 at 2:57 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > But how does the access_ok() move do anything helpful here?
> 
> Just making it all more obvious.
> 
> > We really need it for the fastpath !fshared case, but for the fshared
> > case you actively break working code, because you force a VERIFY_WRITE
> > check into it. The VERIFY_WRITE is necessary for !fshared, because
> > there is no way that one thread can map the futex RO and the other RW,
> > right?
> 
> Nobody actually uses that argument any more (it goes back to the old
> i386 "let's manually verify that we have write permissions, because
> the CPU doesn't do it for us in the trap handling"), and it should
> probably be removed.

Fair enough.
 
> But you're right that it's at least misleading. I'd love to remove it
> entirely, because it's not even syntax-checked, and it's confusing.
> But that would be a humongous patch.

Well, we should ask Julia for a coccinelle patch to limit the
wreckage. :)

Seriously, if that VERIFY_WRITE is completely useless we really want
to get rid of it.
 
> So these days, "access_ok()" literally just checks that the address is
> in the user address space range. And that would seem to always be
> appropriate for futexes, so why not just do it in the generic code?

Agreed, but as long as the VERIFY_WRITE argument is there it needs at
least a big fat comment :)

Thanks,

	tglx
