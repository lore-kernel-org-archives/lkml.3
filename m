Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3LKMmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:42:55 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:54184 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3LKMmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:50 -0500
Date: Wed, 11 Dec 2013 07:42:40 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom
 notifications to access reserves
Message-ID: <20131211124240.GA24557@htj.dyndns.org>
References: <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032118570.29733@chino.kir.corp.google.com>
 <20131204054533.GZ3556@cmpxchg.org>
 <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
 <20131205025026.GA26777@htj.dyndns.org>
 <alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
 <20131206190105.GE13373@htj.dyndns.org>
 <alpine.DEB.2.02.1312061441390.8949@chino.kir.corp.google.com>
 <20131210215037.GB9143@htj.dyndns.org>
 <alpine.DEB.2.02.1312101522400.22701@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312101522400.22701@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo,

On Tue, Dec 10, 2013 at 03:55:48PM -0800, David Rientjes wrote:
> > Well, the gotcha there is that you won't be able to do that with
> > system level OOM handler either unless you create a separately
> > reserved memory, which, again, can be achieved using hierarchical
> > memcg setup already.  Am I missing something here?
> 
> System oom conditions would only arise when the usage of memcgs A + B 
> above cause the page allocator to not be able to allocate memory without 
> oom killing something even though the limits of both A and B may not have 
> been reached yet.  No userspace oom handler can allocate memory with 
> access to memory reserves in the page allocator in such a context; it's 
> vital that if we are to handle system oom conditions in userspace that we 
> given them access to memory that other processes can't allocate.  You 
> could attach a userspace system oom handler to any memcg in this scenario 
> with memory.oom_reserve_in_bytes and since it has PF_OOM_HANDLER it would 
> be able to allocate in reserves in the page allocator and overcharge in 
> its memcg to handle it.  This isn't possible only with a hierarchical 
> memcg setup unless you ensure the sum of the limits of the top level 
> memcgs do not equal or exceed the sum of the min watermarks of all memory 
> zones, and we exceed that.

Yes, exactly.  If system memory is 128M, create top level memcgs w/
120M and 8M each (well, with some slack of course) and then overcommit
the descendants of 120M while putting OOM handlers and friends under
8M without overcommitting.

...
> The stronger rationale is that you can't handle system oom in userspace 
> without this functionality and we need to do so.

You're giving yourself an unreasonable precondition - overcommitting
at root level and handling system OOM from userland - and then trying
to contort everything to fit that.  How can possibly "overcommitting
at root level" be a goal of and in itself?  Please take a step back
and look at and explain the *problem* you're trying to solve.  You
haven't explained why that *need*s to be the case at all.

I wrote this at the start of the thread but you're still doing the
same thing.  You're trying to create a hidden memcg level inside a
memcg.  At the beginning of this thread, you were trying to do that
for !root memcgs and now you're arguing that you *need* that for root
memcg.  Because there's no other limit we can make use of, you're
suggesting the use of kernel reserve memory for that purpose.  It
seems like an absurd thing to do to me.  It could be that you might
not be able to achieve exactly the same thing that way, but the right
thing to do would be improving memcg in general so that it can instead
of adding yet more layer of half-baked complexity, right?

Even if there are some inherent advantages of system userland OOM
handling with a separate physical memory reserve, which AFAICS you
haven't succeeded at showing yet, this is a very invasive change and,
as you said before, something with an *extremely* narrow use case.
Wouldn't it be a better idea to improve the existing mechanisms - be
that memcg in general or kernel OOM handling - to fit the niche use
case better?  I mean, just think about all the corner cases.  How are
you gonna handle priority inversion through locked pages or
allocations given out to other tasks through slab?  You're suggesting
opening a giant can of worms for extremely narrow benefit which
doesn't even seem like actually needing opening the said can.

Thanks.

-- 
tejun
