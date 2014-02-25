Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaBYTrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:47:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51955 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaBYTrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:47:07 -0500
Date: Tue, 25 Feb 2014 20:46:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, aswin@hp.com,
        scott.norton@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: per-thread vma caching
Message-ID: <20140225194649.GV6835@laptop.programming.kicks-ass.net>
References: <1393352206.2577.36.camel@buesod1.americas.hpqcorp.net>
 <20140225183522.GU6835@laptop.programming.kicks-ass.net>
 <1393353454.2577.42.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393353454.2577.42.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 10:37:34AM -0800, Davidlohr Bueso wrote:
> On Tue, 2014-02-25 at 19:35 +0100, Peter Zijlstra wrote:
> > On Tue, Feb 25, 2014 at 10:16:46AM -0800, Davidlohr Bueso wrote:
> > > +void vmacache_update(struct mm_struct *mm, unsigned long addr,
> > > +		     struct vm_area_struct *newvma)
> > > +{
> > > +	/*
> > > +	 * Hash based on the page number. Provides a good
> > > +	 * hit rate for workloads with good locality and
> > > +	 * those with random accesses as well.
> > > +	 */
> > > +	int idx = (addr >> PAGE_SHIFT) & 3;
> > 
> >  % VMACACHE_SIZE
> > 
> > perhaps? GCC should turn that into a mask for all sensible values I
> > would think.
> > 
> > Barring that I think something like:
> > 
> > #define VMACACHE_BITS	2
> > #define VMACACHE_SIZE	(1U << VMACACHE_BITS)
> > #define VMACACHE_MASK	(VMACACHE_SIZE - 1)
> 
> Hmm all that seems like an overkill.

If GCC does the right thing with % VMACACHE_SIZE it gets rid of an ugly
constant. But the 3 VMACACHE_* things are 'better' in that its
impossible to set VMACACHE_SIZE to silly values.
