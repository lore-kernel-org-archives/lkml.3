Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaEHUrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:47:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095AbaEHUrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:47:21 -0400
Date: Thu, 8 May 2014 16:46:53 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Victor Kaplansky <VICTORK@il.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <alpine.LRH.2.02.1405081614100.4346@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ I found this in the lkml archvive ]

> On Wed, Oct 30, 2013 at 04:52:05PM +0200, Victor Kaplansky wrote:
>
> > Peter Zijlstra <peterz@infradead.org> wrote on 10/30/2013 01:25:26 PM:
> >
> > > Also, I'm not entirely sure on C, that too seems like a dependency, we
> > > simply cannot read the buffer @tail before we've read the tail itself,
> > > now can we? Similarly we cannot compare tail to head without having the
> > > head read completed.
> >
> > No, this one we cannot omit, because our problem on consumer side is not
> > with @tail, which is written exclusively by consumer, but with @head.
>
> Ah indeed, my argument was flawed in that @head is the important part.
> But we still do a comparison of @tail against @head before we do further
> reads.
>
> Although I suppose speculative reads are allowed -- they don't have the
> destructive behaviour speculative writes have -- and thus we could in
> fact get reorder issues.
>
> But since it is still a dependent load in that we do that @tail vs @head
> comparison before doing other loads, wouldn't a read_barrier_depends()
> be sufficient? Or do we still need a complete rmb?
>
> > BTW, it is why you also don't need ACCESS_ONCE() around @tail, but only
> > around
> > @head read.
>
> Agreed, the ACCESS_ONCE() around tail is superfluous since we're the one
> updating tail, so there's no problem with the value changing
> unexpectedly.

You need ACCESS_ONCE even if you are the only process writing the value. 
Because without ACCESS_ONCE, the compiler may perform store tearing and 
split the store into several smaller stores. Search the file 
"Documentation/memory-barriers.txt" for the term "store tearing", it shows 
an example where one instruction storing 32-bit value may be split to two 
instructions, each storing 16-bit value.

Mikulas

