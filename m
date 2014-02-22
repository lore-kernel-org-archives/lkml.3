Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaBVE5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 23:57:32 -0500
Received: from g2t2353.austin.hp.com ([15.217.128.52]:51722 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaBVE5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 23:57:31 -0500
Message-ID: <1393045046.2473.6.camel@buesod1.americas.hpqcorp.net>
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
Date: Fri, 21 Feb 2014 20:57:26 -0800
In-Reply-To: <1393044955.2473.5.camel@buesod1.americas.hpqcorp.net>
References: <1392960523.3039.16.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFw1_Ecbjjv9vijj3o46mkq3NrJn0X-FnbpCGBZG2=NuOA@mail.gmail.com>
	 <1393016226.3039.44.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFzw24Mwk_xw3QM_36-TbDOya=XZCqUeSSBVNS1QfjnWEw@mail.gmail.com>
	 <1393044955.2473.5.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 20:55 -0800, Davidlohr Bueso wrote:
> On Fri, 2014-02-21 at 13:24 -0800, Linus Torvalds wrote:
> > On Fri, Feb 21, 2014 at 12:57 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > >
> > > Btw, one concern I had is regarding seqnum overflows... if such
> > > scenarios should happen we'd end up potentially returning bogus vmas and
> > > getting bus errors and other sorts of issues. So we'd have to flush the
> > > caches, but, do we care? I guess on 32bit systems it could be a bit more
> > > possible to trigger given enough forking.
> > 
> > I guess we should do something like
> > 
> >     if (unlikely(!++seqnum))
> >         flush_vma_cache()
> > 
> > just to not have to worry about it.
> > 
> > And we can either use a "#ifndef CONFIG_64BIT" to disable it for the
> > 64-bit case (because no, we really don't need to worry about overflow
> > in 64 bits ;), or just decide that a 32-bit sequence number actually
> > packs better in the structures, and make it be an "u32" even on 64-bit
> > architectures?
> > 
> > It looks like a 32-bit sequence number might pack nicely next to the
> > 
> >     unsigned brk_randomized:1;
> 
> And probably specially so for structures like task and mm. I hadn't
> considered the benefits of packing vs overflowing. So we can afford
> flushing all tasks's vmacache every 4 billion forks.

ah, not quite that much, I was just thinking of dup_mmap, of course we
also increment upon invalidations.

