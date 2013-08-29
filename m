Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3H2LHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:07:50 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:40118 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab3H2LHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:07:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkIAH4qH1J5LJ62/2dsb2JhbABagwe7eYU1gSkXdIIkAQEFJxMcIxAIAxgJJQ8FJQMhE4gAuRAWj14HgxyBAAOXcpFngzIq
Date: Thu, 29 Aug 2013 21:07:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid useless inodes and dentries reclamation
Message-ID: <20130829110741.GA23571@dastard>
References: <1377726732.3625.31.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377726732.3625.31.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 02:52:12PM -0700, Tim Chen wrote:
> This patch detects that when free inodes and dentries are really
> low, their reclamation is skipped so we do not have to contend
> on the global sb_lock uselessly under memory pressure. Otherwise
> we create a log jam trying to acquire the sb_lock in prune_super(),
> with little or no freed memory to show for the effort.
> 
> The profile below shows a multi-threaded large file read exerting
> pressure on memory with page cache usage.  It is dominated
> by the sb_lock contention in the cpu cycles profile.  The patch
> eliminates the sb_lock contention almost entirely for prune_super().
> 
>     43.94%           usemem  [kernel.kallsyms]             [k] _raw_spin_lock
>                      |
>                      --- _raw_spin_lock
>                         |
>                         |--32.44%-- grab_super_passive
>                         |          prune_super
>                         |          shrink_slab
>                         |          do_try_to_free_pages
>                         |          try_to_free_pages
>                         |          __alloc_pages_nodemask
>                         |          alloc_pages_current
>                         |
>                         |--32.18%-- put_super
>                         |          drop_super
>                         |          prune_super
>                         |          shrink_slab
>                         |          do_try_to_free_pages
>                         |          try_to_free_pages
>                         |          __alloc_pages_nodemask
>                         |          alloc_pages_current
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  fs/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 68307c0..70fa26c 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -53,6 +53,7 @@ static char *sb_writers_name[SB_FREEZE_LEVELS] = {
>   * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
>   * take a passive reference to the superblock to avoid this from occurring.
>   */
> +#define SB_CACHE_LOW 5
>  static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
>  {
>  	struct super_block *sb;
> @@ -68,6 +69,13 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
>  	if (sc->nr_to_scan && !(sc->gfp_mask & __GFP_FS))
>  		return -1;
>  
> +	/*
> +	 * Don't prune if we have few cached objects to reclaim to
> +	 * avoid useless sb_lock contention
> +	 */
> +	if ((sb->s_nr_dentry_unused + sb->s_nr_inodes_unused) <= SB_CACHE_LOW)
> +		return -1;

Those counters no longer exist in the current mmotm tree and the
shrinker infrastructure is somewhat different, so this patch isn't
the right way to solve this problem.

Given that superblock LRUs and shrinkers in mmotm are node aware,
there may even be more pressure on the sblock in such a workload.  I
think the right way to deal with this is to give the shrinker itself
a "minimum call count" so that we can avoid even attempting to
shrink caches that does have enough entries in them to be worthwhile
shrinking.

That said, the memcg guys have been saying that even small numbers
of items per cache can be meaningful in terms of memory reclaim
(e.g. when there are lots of memcgs) then such a threshold might
only be appropriate for caches that are not memcg controlled. In
that case, handling it in the shrinker infrastructure itself is a
much better idea than hacking thresholds into individual shrinker
callouts.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
