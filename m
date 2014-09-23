Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaIWNZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:25:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbaIWNZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:25:56 -0400
Date: Tue, 23 Sep 2014 15:25:53 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Greg Thelen <gthelen@google.com>,
        Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: lockless page counters
Message-ID: <20140923132553.GB10046@dhcp22.suse.cz>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
 <20140922144436.GG336@dhcp22.suse.cz>
 <20140922155049.GA6630@cmpxchg.org>
 <20140922172800.GA4343@dhcp22.suse.cz>
 <20140922195829.GA5197@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922195829.GA5197@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-09-14 15:58:29, Johannes Weiner wrote:
> On Mon, Sep 22, 2014 at 07:28:00PM +0200, Michal Hocko wrote:
> > On Mon 22-09-14 11:50:49, Johannes Weiner wrote:
> > > On Mon, Sep 22, 2014 at 04:44:36PM +0200, Michal Hocko wrote:
> > > > On Fri 19-09-14 09:22:08, Johannes Weiner wrote:
> > [...]
> > > > Nevertheless I think that the counter should live outside of memcg (it
> > > > is ugly and bad in general to make HUGETLB controller depend on MEMCG
> > > > just to have a counter). If you made kernel/page_counter.c and led both
> > > > containers select CONFIG_PAGE_COUNTER then you do not need a dependency
> > > > on MEMCG and I would find it cleaner in general.
> > > 
> > > The reason I did it this way is because the hugetlb controller simply
> > > accounts and limits a certain type of memory and in the future I would
> > > like to make it a memcg extension, just like kmem and swap.
> > 
> > I am not sure this is the right way to go. Hugetlb has always been
> > "special" and I do not see any advantage to pull its specialness into
> > memcg proper.
> >
> > It would just make the code more complicated. I can also imagine
> > users who simply do not want to pay memcg overhead and use only
> > hugetlb controller.
> 
> We already group user memory, kernel memory, and swap space together,
> what makes hugetlb-backed memory special?

There is only a little overlap between LRU backed and kmem accounted
memory with hugetlb which has always been standing aside from the rest
of the memory management code (THP being a successor which fits in much
better and which is already covered by memcg). It has basically its own
code path for every aspect of its object life cycle and internal data
structures which are in many ways not compatible with regular user or
kmem memory. Merging the controllers would require to merge hugetlb code
closer the MM code. Until then it just doesn't make sense to me.

> It's much easier to organize the code if all those closely related
> things are grouped together.

Could you be more specific please? How can pulling hugetlb details would
help other !hugetlb code paths?

> It's also better for the user interface to have a single memory
> controller.

I have seen so much confusion coming from hugetlb vs. THP that I think
the quite opposite is true. Besides that we would need a separate limit
for hugetlb accounted memory anyway so having a small and specialized
controller for specialized memory sounds like a proper way to go.

Finally, as mentioned in previous email, you might have users interested
only in hugetlb controller with memcg disabled.

> We're also close to the point where we don't differentiate between the
> root group and dedicated groups in terms of performance, Dave's tests
> fell apart at fairly high concurrency, and I'm already getting rid of
> the lock he saw contended.

Sure but this has nothing to do with it. Hugetlb can safely use the same
lockless counter as a replacement for res_counter and benefit from it
even though the contention hasn't been seen/reported yet.

> The downsides of fragmenting our configuration- and testspace, our
> user interface, and our code base by far outweigh the benefits of
> offering a dedicated hugetlb controller.

Could you be more specific please? Hugetlb has to be configured and
tested separately whether it would be in a separate controller or not.

Last but not least, even if this turns out to make some sense in
the future please do not mix those things together here. Your
res_counter -> page_counter transition makes a lot of sense for both
controllers. And it is a huge improvement. I do not see any reason
to pull a conceptually nontrivial merging/dependency of two separate
controllers into the picture. If you think it makes some sense then
bring that up later for a separate discussion.

Thanks!
-- 
Michal Hocko
SUSE Labs
