Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaBVP7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 10:59:50 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:61277 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaBVP7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 10:59:49 -0500
Date: Sat, 22 Feb 2014 16:59:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: per-thread vma caching
Message-ID: <20140222155944.GA22483@gmail.com>
References: <1392960523.3039.16.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFw1_Ecbjjv9vijj3o46mkq3NrJn0X-FnbpCGBZG2=NuOA@mail.gmail.com>
 <1393016019.3039.40.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFyQJGG6SC99mWwm3L=xYTCmt3=Qm-R4pWjeCyY_xAt63Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyQJGG6SC99mWwm3L=xYTCmt3=Qm-R4pWjeCyY_xAt63Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Feb 21, 2014 at 12:53 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> > I think you are right. I just reran some of the tests and things are
> > pretty much the same, so we could get rid of it.
> 
> Ok, I'd prefer the simpler model of just a single per-thread hashed
> lookup, and then we could perhaps try something more complex if there
> are particular loads that really matter. I suspect there is more
> upside to playing with the hashing of the per-thread cache (making it
> three bits, whatever) than with some global thing.
> 
> >> Also, the hash you use for the vmacache index is *particularly* odd.
> >>
> >>         int idx =  (addr >> 10) & 3;
> >>
> >> you're using the top two bits of the address *within* the page.
> >> There's a lot of places that round addresses down to pages, and in
> >> general it just looks really odd to use an offset within a page as an
> >> index, since in some patterns (linear accesses, whatever), the page
> >> faults will always be to the beginning of the page, so index 0 ends up
> >> being special.
> >
> > Ah, this comes from tediously looking at access patterns. I actually
> > printed pages of them. I agree that it is weird, and I'm by no means
> > against changing it. However, the results are just too good, specially
> > for ebizzy, so I decided to keep it, at least for now. I am open to
> > alternatives.
> 
> Hmm. Numbers talk, bullshit walks. So if you have the numbers that say
> this is actually a good model..
> 
> I guess that for any particular page, only the first access address
> matters. And if it really is a "somewhat linear", and the first access
> tends to hit in the first part of the page, and the cache index tends
> to cluster towards idx=0. And for linear accesses, I guess *any*
> clustering is actually a good thing, since spreading things out just
> defeats the fact that linear accesses also tend to hit in the same
> vma.
> 
> And if you have truly fairly random accesses, then presumably their
> offsets within the page are fairly random too, and so hashing by
> offset within page might work well to spread out the vma cache
> lookups.
> 
> So I guess I can rationalize it. [...]

Davidlohr: it would be nice to stick a comment about the (post facto) 
rationale into the changelog or the code (or both).

Thanks,

	Ingo
