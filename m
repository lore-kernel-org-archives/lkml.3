Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051Ab3LJWmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:42:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:51827 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab3LJWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:42:18 -0500
Date: Tue, 10 Dec 2013 23:42:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
In-Reply-To: <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com> <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com> <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de> <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com> <20131210204925.GB27373@redhat.com> <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com> <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
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

> On Tue, Dec 10, 2013 at 1:57 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So it looks like __get_user_pages_fast() fails, and keeps failing.
> 
> Hmm.. Is any of the addresses unchecked, perhaps?
> __get_user_pages_fast() does an access_ok() check, while
> get_user_pages_fast() does *not* seem to do one.
> 
> That looks a bit dangerous. Yeah, users should have checked the
> address range, but there really is no reason not to do it in
> get_user_pages_fast().
> 
> And it looks like the futex code is actually seriously buggered. It
> only does the access_ok() check for the non-shared case.
> 
> Why?

The !fshared case is the fast path which does not even reach
get_user_pages_fast().

We had this discussion some time ago already, where the access_ok()
check was missing in the !fshared case or the check was buggered for
some reason. Need to dig up the gory details.

And yes, I remember that we do not do an extra check for the fshared
case, because get_user_pages_fast() should do it for us already. If
not we are fubared not only in the futex code.

But there is a subtle detail:

    err = get_user_pages_fast(address, 1, 1, &page);

So we ask for write access as the write argument is 1. In case that
fails we have that fallback path:

        /*
         * If write access is not required (eg. FUTEX_WAIT), try
         * and get read-only access.
         */
        if (err == -EFAULT && rw == VERIFY_READ) {
                err = get_user_pages_fast(address, 1, 0, &page);

That's a legitimate use case. And futex_requeue only requests
VERIFY_READ for the !requeue_pi case.

Now, if that map is RO, i.e. we took the fallback path then the THP
one will fail as it has write=1 unconditionally.

      if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) 

Thanks,

	tglx
 
