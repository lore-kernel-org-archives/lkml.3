Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaCDASR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:18:17 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:51017 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbaCDASQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:18:16 -0500
Message-ID: <1393892292.30648.12.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v4] mm: per-thread vma caching
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, aswin@hp.com,
        scott.norton@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 03 Mar 2014 16:18:12 -0800
In-Reply-To: <20140303160021.3001634fa62781d7b0359158@linux-foundation.org>
References: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net>
	 <20140303160021.3001634fa62781d7b0359158@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 16:00 -0800, Andrew Morton wrote:
> On Thu, 27 Feb 2014 13:48:24 -0800 Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > From: Davidlohr Bueso <davidlohr@hp.com>
> > 
> > This patch is a continuation of efforts trying to optimize find_vma(),
> > avoiding potentially expensive rbtree walks to locate a vma upon faults.
> > The original approach (https://lkml.org/lkml/2013/11/1/410), where the
> > largest vma was also cached, ended up being too specific and random, thus
> > further comparison with other approaches were needed. There are two things
> > to consider when dealing with this, the cache hit rate and the latency of
> > find_vma(). Improving the hit-rate does not necessarily translate in finding
> > the vma any faster, as the overhead of any fancy caching schemes can be too
> > high to consider.
> > 
> > We currently cache the last used vma for the whole address space, which
> > provides a nice optimization, reducing the total cycles in find_vma() by up
> > to 250%, for workloads with good locality. On the other hand, this simple
> > scheme is pretty much useless for workloads with poor locality. Analyzing
> > ebizzy runs shows that, no matter how many threads are running, the
> > mmap_cache hit rate is less than 2%, and in many situations below 1%.
> > 
> > The proposed approach is to replace this scheme with a small per-thread cache,
> > maximizing hit rates at a very low maintenance cost. Invalidations are
> > performed by simply bumping up a 32-bit sequence number. The only expensive
> > operation is in the rare case of a seq number overflow, where all caches that
> > share the same address space are flushed. Upon a miss, the proposed replacement
> > policy is based on the page number that contains the virtual address in
> > question. Concretely, the following results are seen on an 80 core, 8 socket
> > x86-64 box:
> > 
> > ...
> > 
> > 2) Kernel build: This one is already pretty good with the current approach
> > as we're dealing with good locality.
> > 
> > +----------------+----------+------------------+
> > | caching scheme | hit-rate | cycles (billion) |
> > +----------------+----------+------------------+
> > | baseline       | 75.28%   | 11.03            |
> > | patched        | 88.09%   | 9.31             |
> > +----------------+----------+------------------+
> 
> What is the "cycles" number here?  I'd like to believe we sped up kernel
> builds by 10% ;)
> 
> Were any overall run time improvements observable?

Weeell not too much (I wouldn't normally go measuring cycles if I could
use a benchmark instead ;). As discussed a while back, all this occurs
under the mmap_sem anyway, so while we do optimize find_vma() in more
workloads than before, it doesn't translate in better benchmark
throughput :( The same occurs if we get rid of any caching and just rely
on rbtree walks, sure the cost of find_vma() goes way up, but that
really doesn't hurt from a user perspective. Fwiw, I did see in ebizzy
perf traces find_vma goes from ~7% to ~0.4%.

> 
> > ...
> >
> > @@ -1228,6 +1229,9 @@ struct task_struct {
> >  #ifdef CONFIG_COMPAT_BRK
> >  	unsigned brk_randomized:1;
> >  #endif
> > +	/* per-thread vma caching */
> > +	u32 vmacache_seqnum;
> > +	struct vm_area_struct *vmacache[VMACACHE_SIZE];
> 
> So these are implicitly locked by being per-thread.

Yes.

> > +static inline void vmacache_invalidate(struct mm_struct *mm)
> > +{
> > +	mm->vmacache_seqnum++;
> > +
> > +	/* deal with overflows */
> > +	if (unlikely(mm->vmacache_seqnum == 0))
> > +		vmacache_flush_all(mm);
> > +}
> 
> What's the locking rule for mm->vmacache_seqnum?

Invalidations occur under the mmap_sem (writing), just like
mm->mmap_cache did.

Thanks,
Davidlohr

