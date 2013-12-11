Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab3LKR6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:58:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3LKR57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:57:59 -0500
Date: Wed, 11 Dec 2013 17:57:53 +0000
From: Mel Gorman <mgorman@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131211175752.GC11295@suse.de>
References: <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
 <20131210214143.GG27373@redhat.com>
 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
 <20131211163125.GC24125@suse.de>
 <alpine.DEB.2.02.1312111737590.28330@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312111737590.28330@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 05:38:55PM +0100, Thomas Gleixner wrote:
> On Wed, 11 Dec 2013, Mel Gorman wrote:
> > On Tue, Dec 10, 2013 at 11:42:15PM +0100, Thomas Gleixner wrote:
> > > Now, if that map is RO, i.e. we took the fallback path then the THP
> > > one will fail as it has write=1 unconditionally.
> > > 
> > >       if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) 
> > > 
> > 
> > Not that it really matters but the naming and comments around that
> > particular __get_user_pages_fast call are a little misleading.  The ifdef
> > CONFIG_TRANSPARENT_HUGEPAGE in futex.c is there because greater care has
> > to be taken against THP splits, not because it is dealing exclusively with
> > THP. The PageTail check applies to either hugetlbfs or THPs and similarly
> > gup_huge_pmd handles both. The whole path should be very rare for THPs
> > considering that THPs exist on MAP_PRIVATE anonymous mappings and how many
> > shared futexes exist backed by such mappings? A RO mapping makes that seem
> > even more strange because what thread is updating the value the caller is
> > waiting on? It seems more like that was a shared futex on a hugetlbfs-backed
> > mappings which might explain why the bug was undiscovered for so long.
> 
> This is the fshared path. The MAP_PRIVATE path does not do that dance
> at all.
> 

do_futex takes an op parameter and sets FLAGS_SHARED on that op parameter,
not whether the VMA backing that address was created with the MAP_PRIVATE
or MAP_SHARED flag. For example;

do_futex(addr, op) where !(ops & FUTEX_PRIVATE_FLAG) and cmd == FUTEX_WAIT
  -> futex_wait
    -> futex_wait_setup
      -> get_futex_key(fshared == true)

THP pages encountered in the fshared path should be rare because why create
a shared futex on a private mapping? That does not make it impossible
which is why splits are guarded against. If it was genuinely impossible
to be in this path for MAP_PRIVATE then there is no point worrying about
THP as it is currently supported at least. Overall, it still seems more
likely this was a hugetlbfs page.

-- 
Mel Gorman
SUSE Labs
