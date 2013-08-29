Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3H2SIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:08:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:32092 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3H2SIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:08:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,984,1367996400"; 
   d="scan'208";a="370557300"
Subject: Re: [PATCH] Avoid useless inodes and dentries reclamation
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20130829110741.GA23571@dastard>
References: <1377726732.3625.31.camel@schen9-DESK>
	 <20130829110741.GA23571@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Aug 2013 11:07:56 -0700
Message-ID: <1377799676.3625.69.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > ---
> >  fs/super.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/super.c b/fs/super.c
> > index 68307c0..70fa26c 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -53,6 +53,7 @@ static char *sb_writers_name[SB_FREEZE_LEVELS] = {
> >   * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
> >   * take a passive reference to the superblock to avoid this from occurring.
> >   */
> > +#define SB_CACHE_LOW 5
> >  static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
> >  {
> >  	struct super_block *sb;
> > @@ -68,6 +69,13 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
> >  	if (sc->nr_to_scan && !(sc->gfp_mask & __GFP_FS))
> >  		return -1;
> >  
> > +	/*
> > +	 * Don't prune if we have few cached objects to reclaim to
> > +	 * avoid useless sb_lock contention
> > +	 */
> > +	if ((sb->s_nr_dentry_unused + sb->s_nr_inodes_unused) <= SB_CACHE_LOW)
> > +		return -1;
> 
> Those counters no longer exist in the current mmotm tree and the
> shrinker infrastructure is somewhat different, so this patch isn't
> the right way to solve this problem.

These changes in mmotm tree do complicate solutions for this
scalability issue.

> 
> Given that superblock LRUs and shrinkers in mmotm are node aware,
> there may even be more pressure on the sblock in such a workload.  I
> think the right way to deal with this is to give the shrinker itself
> a "minimum call count" so that we can avoid even attempting to
> shrink caches that does have enough entries in them to be worthwhile
> shrinking.

By "minimum call count", do you mean tracking the number of free
entries per node in the shrinker, and invoking shrinker 
only when the number of free entries
exceed "minimum call count"?  There is some cost in
list_lru_count_node to get the free entries, as we need
to acquire the node's lru lock.  Alternatively, we can
set a special flag/node by list_add or list_del when count goes
above/below a threshold and invoke shrinker based on this flag.

Or do you mean that if we do not reap any memory in a shrink
operation, we do a certain number of backoffs of shrink operation
till the "minimum call count" is reached?


> 
> That said, the memcg guys have been saying that even small numbers
> of items per cache can be meaningful in terms of memory reclaim
> (e.g. when there are lots of memcgs) then such a threshold might
> only be appropriate for caches that are not memcg controlled. 

I've done some experiment with the CACHE thresholds.  Even setting
the threshold at 0 (i.e. there're no free entries) remove almost all 
the needless contentions.  That should make the memcg guys happy by
not holding any extra free entries.

> In
> that case, handling it in the shrinker infrastructure itself is a
> much better idea than hacking thresholds into individual shrinker
> callouts.

Currently the problem is mostly with the sb shrinker due to the
sb_lock.  If we can have a general solution, that will be even
better.

Thanks.

Tim

