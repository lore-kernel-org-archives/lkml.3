Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3H3BkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 21:40:11 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4095 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab3H3BkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 21:40:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8JAEr3H1J5LJ62/2dsb2JhbABagwc1gw+4S4VEgSIXdIIkAQEEAScTHCMFCwgDGAklDwUlAyETG4dgBblPBBaNCIJWB4QcA5dykWeDMio
Date: Fri, 30 Aug 2013 11:40:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid useless inodes and dentries reclamation
Message-ID: <20130830014005.GT12779@dastard>
References: <1377726732.3625.31.camel@schen9-DESK>
 <20130829110741.GA23571@dastard>
 <1377799676.3625.69.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377799676.3625.69.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 11:07:56AM -0700, Tim Chen wrote:
> 
> > > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > > ---
> > >  fs/super.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/fs/super.c b/fs/super.c
> > > index 68307c0..70fa26c 100644
> > > --- a/fs/super.c
> > > +++ b/fs/super.c
> > > @@ -53,6 +53,7 @@ static char *sb_writers_name[SB_FREEZE_LEVELS] = {
> > >   * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
> > >   * take a passive reference to the superblock to avoid this from occurring.
> > >   */
> > > +#define SB_CACHE_LOW 5
> > >  static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
> > >  {
> > >  	struct super_block *sb;
> > > @@ -68,6 +69,13 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
> > >  	if (sc->nr_to_scan && !(sc->gfp_mask & __GFP_FS))
> > >  		return -1;
> > >  
> > > +	/*
> > > +	 * Don't prune if we have few cached objects to reclaim to
> > > +	 * avoid useless sb_lock contention
> > > +	 */
> > > +	if ((sb->s_nr_dentry_unused + sb->s_nr_inodes_unused) <= SB_CACHE_LOW)
> > > +		return -1;
> > 
> > Those counters no longer exist in the current mmotm tree and the
> > shrinker infrastructure is somewhat different, so this patch isn't
> > the right way to solve this problem.
> 
> These changes in mmotm tree do complicate solutions for this
> scalability issue.
> 
> > 
> > Given that superblock LRUs and shrinkers in mmotm are node aware,
> > there may even be more pressure on the sblock in such a workload.  I
> > think the right way to deal with this is to give the shrinker itself
> > a "minimum call count" so that we can avoid even attempting to
> > shrink caches that does have enough entries in them to be worthwhile
> > shrinking.
> 
> By "minimum call count", do you mean tracking the number of free
> entries per node in the shrinker, and invoking shrinker 
> only when the number of free entries
> exceed "minimum call count"?

The new shrinker infrastructure has a ->count_objects() callout to
specifically return the number of objects in the cache.
shrink_slab_node() can check that return value against the "minimum
call count" and determine whether it needs to call ->scan_objects()
at all.

Actually, the shrinker already behaves like this with the batch_size
variable - the shrinker has to be asking for more items to be
scanned than the batch size. That means the problem is that counting
callouts are causing the problem, not the scanning callouts.

With the new code in the mmotm tree, for counting purposes we
probably don't need to grab a passive superblock reference at all -
the superblock and LRUs are guaranteed to be valid if the shrinker
is currently running, but we don't really care if the superblock is
being shutdown and the values that come back are invalid because the
->scan_objects() callout will fail to grab the superblock to do
anything with the calculated values.

Indeed, I've made no attempt to optimise the code in the mmotm tree
- I've been concerned with correctness. The fact that without any
optimisation it significantly lessens contention in my testing has
been sufficient to move forward with.

> There is some cost in
> list_lru_count_node to get the free entries, as we need
> to acquire the node's lru lock.

Right, but we really don't need the node's lru lock to get the count
- reading the count is racy from an external perspective, anyway, so
we can do lockless counting here.  See this patch I proposed a
while back, for example:

https://lkml.org/lkml/2013/7/31/7

> > That said, the memcg guys have been saying that even small numbers
> > of items per cache can be meaningful in terms of memory reclaim
> > (e.g. when there are lots of memcgs) then such a threshold might
> > only be appropriate for caches that are not memcg controlled. 
> 
> I've done some experiment with the CACHE thresholds.  Even setting
> the threshold at 0 (i.e. there're no free entries) remove almost all 
> the needless contentions.  That should make the memcg guys happy by
> not holding any extra free entries.

Ok, that's good to know, and it further indicates that it is the
->count_objects() callout that is the issue, not the
scanning/freeing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
