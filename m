Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab3LKQbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:31:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab3LKQb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:31:29 -0500
Date: Wed, 11 Dec 2013 16:31:25 +0000
From: Mel Gorman <mgorman@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131211163125.GC24125@suse.de>
References: <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
 <20131210214143.GG27373@redhat.com>
 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:42:15PM +0100, Thomas Gleixner wrote:
> On Tue, 10 Dec 2013, Linus Torvalds wrote:
> 
> > On Tue, Dec 10, 2013 at 1:57 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > So it looks like __get_user_pages_fast() fails, and keeps failing.
> > 
> > Hmm.. Is any of the addresses unchecked, perhaps?
> > __get_user_pages_fast() does an access_ok() check, while
> > get_user_pages_fast() does *not* seem to do one.
> > 
> > That looks a bit dangerous. Yeah, users should have checked the
> > address range, but there really is no reason not to do it in
> > get_user_pages_fast().
> > 
> > And it looks like the futex code is actually seriously buggered. It
> > only does the access_ok() check for the non-shared case.
> > 
> > Why?
> 
> The !fshared case is the fast path which does not even reach
> get_user_pages_fast().
> 
> We had this discussion some time ago already, where the access_ok()
> check was missing in the !fshared case or the check was buggered for
> some reason. Need to dig up the gory details.
> 
> And yes, I remember that we do not do an extra check for the fshared
> case, because get_user_pages_fast() should do it for us already. If
> not we are fubared not only in the futex code.
> 
> But there is a subtle detail:
> 
>     err = get_user_pages_fast(address, 1, 1, &page);
> 
> So we ask for write access as the write argument is 1. In case that
> fails we have that fallback path:
> 
>         /*
>          * If write access is not required (eg. FUTEX_WAIT), try
>          * and get read-only access.
>          */
>         if (err == -EFAULT && rw == VERIFY_READ) {
>                 err = get_user_pages_fast(address, 1, 0, &page);
> 
> That's a legitimate use case. And futex_requeue only requests
> VERIFY_READ for the !requeue_pi case.
> 
> Now, if that map is RO, i.e. we took the fallback path then the THP
> one will fail as it has write=1 unconditionally.
> 
>       if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) 
> 

Not that it really matters but the naming and comments around that
particular __get_user_pages_fast call are a little misleading.  The ifdef
CONFIG_TRANSPARENT_HUGEPAGE in futex.c is there because greater care has
to be taken against THP splits, not because it is dealing exclusively with
THP. The PageTail check applies to either hugetlbfs or THPs and similarly
gup_huge_pmd handles both. The whole path should be very rare for THPs
considering that THPs exist on MAP_PRIVATE anonymous mappings and how many
shared futexes exist backed by such mappings? A RO mapping makes that seem
even more strange because what thread is updating the value the caller is
waiting on? It seems more like that was a shared futex on a hugetlbfs-backed
mappings which might explain why the bug was undiscovered for so long.

-- 
Mel Gorman
SUSE Labs
