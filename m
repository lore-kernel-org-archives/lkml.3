Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3LJW5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:57:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:51948 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3LJW5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:57:37 -0500
Date: Tue, 10 Dec 2013 23:57:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
In-Reply-To: <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1312102348120.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com> <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com> <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de> <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com> <20131210204925.GB27373@redhat.com> <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com> <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com> <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Linus Torvalds wrote:

> On Tue, Dec 10, 2013 at 2:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Shouldn't we do something like the attached?
> 
> So I think that kernel/futex.c part of the patch might be a good idea,
> but on x86-64 (which is what Dave is running), the
> 
>         if (end >> __VIRTUAL_MASK_SHIFT)
> 
> test in get_user_pages_fast() should have been equivalent. And even on
> 32-bit, we do check the _PAGE_USER bits in the page tables, so I guess
> it's all good on a get_user_pages_fast() side.
> 
> So never mind. It's not the address checking.
> 
> And I think I see what's up.
> 
> I think what happens is:
>  - get_user_pages_fast(address, 1, 1, &page) fails (because it's read-only)
>  - get_user_pages_fast(address, 1, 0, &page) succeeds and gets a large-page
>  - __get_user_pages_fast(address, 1, 1, &page) fails (because it's read-only).
> 
> so what triggers this is likely that Dave now does large-pages, and
> one of them is a read-only mapping.
> 
> So I would suggest replacing the second "1" in the
> __get_user_pages_fast() call with a "!ro" instead. So how about this
> second patch instead (the access_ok() move remains).

Yes, that's what I decoded as well.

But how does the access_ok() move do anything helpful here?

We really need it for the fastpath !fshared case, but for the fshared
case you actively break working code, because you force a VERIFY_WRITE
check into it. The VERIFY_WRITE is necessary for !fshared, because
there is no way that one thread can map the futex RO and the other RW,
right?

But for fshared it's legitimate to have a RO mapping if you just wait
for the futex. Note, that futexes are (ab)used as user space
waitqueues, so RO makes sense. And your move would break them.

If [__]get_user_pages_fast() does not do the right checks, then we
need to fix that and not add random access_ok() checks into the call
sites.

Thanks,

	tglx





