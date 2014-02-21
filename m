Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaBUUxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:53:43 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:47275 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaBUUxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:53:41 -0500
X-Greylist: delayed 55494 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Feb 2014 15:53:41 EST
Message-ID: <1393016019.3039.40.camel@buesod1.americas.hpqcorp.net>
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
Date: Fri, 21 Feb 2014 12:53:39 -0800
In-Reply-To: <CA+55aFw1_Ecbjjv9vijj3o46mkq3NrJn0X-FnbpCGBZG2=NuOA@mail.gmail.com>
References: <1392960523.3039.16.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFw1_Ecbjjv9vijj3o46mkq3NrJn0X-FnbpCGBZG2=NuOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 10:13 -0800, Linus Torvalds wrote:
> On Thu, Feb 20, 2014 at 9:28 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > From: Davidlohr Bueso <davidlohr@hp.com>
> >
> > This patch is a continuation of efforts trying to optimize find_vma(),
> > avoiding potentially expensive rbtree walks to locate a vma upon faults.
> 
> Ok, so I like this one much better than the previous version.
> 
> However, I do wonder if the per-mm vmacache is actually worth it.
> Couldn't the per-thread one replace it entirely?

I think you are right. I just reran some of the tests and things are
pretty much the same, so we could get rid of it. I originally left it
there because I recall seeing a slightly better hit rate for some java
workloads (map/reduce, specifically), but it wasn't a big deal - some
slots endup being redundant with a per mm cache. It does however
guarantee that we access hot vmas immediately, instead of potentially
slightly more reads when we go into per-thread checking. I'm happy with
the results either way.

> Also, the hash you use for the vmacache index is *particularly* odd.
> 
>         int idx =  (addr >> 10) & 3;
> 
> you're using the top two bits of the address *within* the page.
> There's a lot of places that round addresses down to pages, and in
> general it just looks really odd to use an offset within a page as an
> index, since in some patterns (linear accesses, whatever), the page
> faults will always be to the beginning of the page, so index 0 ends up
> being special.

Ah, this comes from tediously looking at access patterns. I actually
printed pages of them. I agree that it is weird, and I'm by no means
against changing it. However, the results are just too good, specially
for ebizzy, so I decided to keep it, at least for now. I am open to
alternatives.

Thanks,
Davidlohr

