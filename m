Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaBYBQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:16:30 -0500
Received: from g2t2353.austin.hp.com ([15.217.128.52]:29256 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbaBYBQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:16:28 -0500
Message-ID: <1393290984.2577.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm: per-thread vma caching
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 17:16:24 -0800
In-Reply-To: <CA+55aFyQJGG6SC99mWwm3L=xYTCmt3=Qm-R4pWjeCyY_xAt63Q@mail.gmail.com>
References: <1392960523.3039.16.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFw1_Ecbjjv9vijj3o46mkq3NrJn0X-FnbpCGBZG2=NuOA@mail.gmail.com>
	 <1393016019.3039.40.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFyQJGG6SC99mWwm3L=xYTCmt3=Qm-R4pWjeCyY_xAt63Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 13:18 -0800, Linus Torvalds wrote:
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

If we add the two missing bits to the shifting and use PAGE_SHIFT (x86
at least) we get just as good results as with 10. So we would probably
prefer hashing based on the page number and not some offset within the
page.

Thanks,
Davidlohr

