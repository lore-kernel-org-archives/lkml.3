Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbaIIOvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:51:18 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:48605 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010AbaIIOvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:51:14 -0400
Date: Tue, 9 Sep 2014 10:50:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave@sr71.net>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
Message-ID: <20140909145044.GA16027@cmpxchg.org>
References: <54061505.8020500@sr71.net>
 <5406262F.4050705@intel.com>
 <54062F32.5070504@sr71.net>
 <20140904142721.GB14548@dhcp22.suse.cz>
 <5408CB2E.3080101@sr71.net>
 <20140905123517.GA21208@cmpxchg.org>
 <540DCF99.2070900@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540DCF99.2070900@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 08:47:37AM -0700, Dave Hansen wrote:
> On 09/05/2014 05:35 AM, Johannes Weiner wrote:
> > On Thu, Sep 04, 2014 at 01:27:26PM -0700, Dave Hansen wrote:
> >> On 09/04/2014 07:27 AM, Michal Hocko wrote:
> >>> Ouch. free_pages_and_swap_cache completely kills the uncharge batching
> >>> because it reduces it to PAGEVEC_SIZE batches.
> >>>
> >>> I think we really do not need PAGEVEC_SIZE batching anymore. We are
> >>> already batching on tlb_gather layer. That one is limited so I think
> >>> the below should be safe but I have to think about this some more. There
> >>> is a risk of prolonged lru_lock wait times but the number of pages is
> >>> limited to 10k and the heavy work is done outside of the lock. If this
> >>> is really a problem then we can tear LRU part and the actual
> >>> freeing/uncharging into a separate functions in this path.
> >>>
> >>> Could you test with this half baked patch, please? I didn't get to test
> >>> it myself unfortunately.
> >>
> >> 3.16 settled out at about 11.5M faults/sec before the regression.  This
> >> patch gets it back up to about 10.5M, which is good.  The top spinlock
> >> contention in the kernel is still from the resource counter code via
> >> mem_cgroup_commit_charge(), though.
> > 
> > Thanks for testing, that looks a lot better.
> > 
> > But commit doesn't touch resource counters - did you mean try_charge()
> > or uncharge() by any chance?
> 
> I don't have the perf output that I was looking at when I said this, but
> here's the path that I think I was referring to.  The inlining makes
> this non-obvious, but this memcg_check_events() calls
> mem_cgroup_update_tree() which is contending on mctz->lock.
> 
> So, you were right, it's not the resource counters code, it's a lock in
> 'struct mem_cgroup_tree_per_zone'.  But, the contention isn't _that_
> high (2% of CPU) in this case.  But, that is 2% that we didn't see before.
> 
> >      1.87%     1.87%  [kernel]               [k] _raw_spin_lock_irqsave       
> >                                |
> >                                --- _raw_spin_lock_irqsave
> >                                   |          
> >                                   |--107.09%-- memcg_check_events
> >                                   |          |          
> >                                   |          |--79.98%-- mem_cgroup_commit_charge
> >                                   |          |          |          
> >                                   |          |          |--99.81%-- do_cow_fault
> >                                   |          |          |          handle_mm_fault
> >                                   |          |          |          __do_page_fault
> >                                   |          |          |          do_page_fault
> >                                   |          |          |          page_fault
> >                                   |          |          |          testcase
> >                                   |          |           --0.19%-- [...]

The mctz->lock is only taken when there is, or has been, soft limit
excess.  However, the soft limit defaults to infinity, so unless you
set it explicitly on the root level, I can't see how this could be
mctz->lock contention.

It's more plausible that this is the res_counter lock for testing soft
limit excess - for me, both these locks get inlined into check_events,
could you please double check you got the right lock?

As the limit defaults to infinity, and really doesn't mean anything on
the root level it's idiotic to test it, we can easily eliminate that.
With the patch below, I don't have that trace show up in the profile
anymore.  Could you please give it a try?

You also said that this cost hasn't been there before, but I do see
that trace in both v3.16 and v3.17-rc3 with roughly the same impact
(although my machines show less contention than yours).  Could you
please double check that this is in fact a regression independent of
05b843012335 ("mm: memcontrol: use root_mem_cgroup res_counter")?

Thanks!

---
>From 465c5caa0628d640c2493e9d849dc9a1f0b373a4 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Tue, 9 Sep 2014 09:25:20 -0400
Subject: [patch] mm: memcontrol: do not track soft limit excess on the root
 level

Dave encounters res_counter lock contention from memcg_check_events()
when running a multi-threaded page fault benchmark in the root group.

This lock is taken to maintain the tree of soft limit excessors, which
is used by global reclaim to prioritize excess groups.  But that makes
no sense on the root level - parent to all other groups, and so all
this overhead is unnecessary.  Skip it.

[ The soft limit really shouldn't even be settable on the root level,
  but it's been like that forever, so don't risk breaking dopy user
  space over this now. ]

Reported-by: Dave Hansen <dave@sr71.net>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 085dc6d2f876..b4de17e4f267 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1013,10 +1013,11 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
-		bool do_softlimit;
+		bool do_softlimit = false;
 		bool do_numainfo __maybe_unused;
 
-		do_softlimit = mem_cgroup_event_ratelimit(memcg,
+		if (!mem_cgroup_is_root(memcg))
+			do_softlimit = mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_SOFTLIMIT);
 #if MAX_NUMNODES > 1
 		do_numainfo = mem_cgroup_event_ratelimit(memcg,
-- 
2.0.4

