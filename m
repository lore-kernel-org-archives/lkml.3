Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab3HOAW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 20:22:57 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:43468 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab3HOAW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 20:22:56 -0400
Date: Wed, 14 Aug 2013 20:22:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] idr: Document ida tree sections
Message-ID: <20130815002251.GP28628@htj.dyndns.org>
References: <20130809145756.GL20515@mtj.dyndns.org>
 <20130813221308.GA11980@kmo-pixel>
 <20130813221928.GE28996@mtj.dyndns.org>
 <20130813222759.GA12069@kmo-pixel>
 <20130813224428.GG28996@mtj.dyndns.org>
 <20130813225927.GA2000@kmo-pixel>
 <20130813232211.GI28996@mtj.dyndns.org>
 <20130813235133.GA3807@kmo-pixel>
 <20130813235947.GL28996@mtj.dyndns.org>
 <20130815000427.GB6427@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815000427.GB6427@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Wed, Aug 14, 2013 at 05:04:27PM -0700, Kent Overstreet wrote:
> I was just telling you how I felt :) Regardless of that, IMO what I've
> got now is superior to any radix tree based approach for what ida/idr
> are supposed to do. I could of course be wrong, but I'm not convinced...

It's just very difficult to tell either way.  You say it's better but
the benefit to weirdity ratio doesn't seem too apparent.  The only
thing the proposed solution saves is a few pointer dereferences in
extreme corner cases at the cost of making low level library using
high order allocation or vmalloc allocation.

Weirdity aside, the unsualness even makes evaluating the overhead
muddier.  e.g. vmalloc space is expensive not only in terms of address
space real estate but also in terms of runtime performance because
each vmalloc page is additional TLB pressure in most configurations
where the kernel linear address space is mapped with gigantic
mappings.  The net effect could be small and won't easily show up in
microbenchmarks as they usually don't tend to push TLB pressure but
then again the performance benefit of the proposed implementation is
likely to extremely minor too.

For a code piece to be unusual, it should have its accompanying clear
benefits, which doesn't seem to be the case here.  It's different and
maybe better in some extreme benchmarks specifically designed for it
but that seems to be about it.

> Re: caching the last allocation with a radix tree based implementation.
> I thought about that more last night, I don't think that would be viable
> for using ida underneath the percpu ida allocator.
>
> Reason being percpu ida has to heavily optimize for the case where
> almost all of the id space is allocated, and after awhile the id space
> is going to be fragmented - so caching the last allocated id is going to
> be useless.

A 4k page has 32k bits.  It can serve up quite a few IDs even with
internal indexing.  Most cases will be fine with single page and
single layer would cover most of what's left.  How is that gonna be
very different from the proposed implementation.  If you worry about
huge ID space being distributed by a lot of CPUs, you can use per-cpu
hints, which will be faster than the proposed solution anyway.

> This is also why I implemented the ganged allocation bit, to amortize
> the bitmap tree traversal. So we'd lose out on that going back to a
> radix tree, or have to reimplement it (and it'll be slower due to
> pointer chasing).
> 
> Which is all not the end of the world, but it means that if we punt on
> the ida/idr rewrites for now or change our minds about them - we _do_
> have quite a bit of stuff waiting on the percpu ida allocator, so for
> that to go in separate I'll have to change it back to using a stack of
> integers for the global freelist - which does use significantly more
> memory.

Yes, I'd like to see better, percpu-aware ida too and there are things
which can benefit from it, but we still need to get ida right and I
don't think it's a very difficult thing to do at this point.

Thanks.

-- 
tejun
