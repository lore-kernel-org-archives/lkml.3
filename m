Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab3IFAza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 20:55:30 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50797 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467Ab3IFAz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 20:55:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AooGAHgnKVJ5LJ62/2dsb2JhbABbgweDR7lYhTWBJRd0giQBAQQBJxMcIxAIAxgJJQ8FJQMhExuHYQW6fRaPSgeDHYEAA5Qbg1mRZ4MyKg
Date: Fri, 6 Sep 2013 10:55:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] Avoid useless inodes and dentries reclamation
Message-ID: <20130906005524.GA23571@dastard>
References: <1377726732.3625.31.camel@schen9-DESK>
 <20130829110741.GA23571@dastard>
 <1377799676.3625.69.camel@schen9-DESK>
 <20130830014005.GT12779@dastard>
 <1377879694.3625.77.camel@schen9-DESK>
 <20130831090006.GZ12779@dastard>
 <1378233507.3625.90.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378233507.3625.90.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 11:38:27AM -0700, Tim Chen wrote:
> On Sat, 2013-08-31 at 19:00 +1000, Dave Chinner wrote:
> > On Fri, Aug 30, 2013 at 09:21:34AM -0700, Tim Chen wrote:
> > >
> > > 
> > > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > > ---
> > > diff --git a/fs/super.c b/fs/super.c
> > > index 73d0952..4df1fab 100644
> > > --- a/fs/super.c
> > > +++ b/fs/super.c
> > > @@ -112,9 +112,6 @@ static unsigned long super_cache_count(struct shrinker *shrink,
> > >  
> > >  	sb = container_of(shrink, struct super_block, s_shrink);
> > >  
> > > -	if (!grab_super_passive(sb))
> > > -		return 0;
> > > -
> > 
> > I think the function needs a comment explaining why we aren't
> > grabbing the sb here, otherwise people are going to read the code
> > and ask why it's different to the scanning callout.
> > 
> > >  	if (sb->s_op && sb->s_op->nr_cached_objects)
> > >  		total_objects = sb->s_op->nr_cached_objects(sb,
> > >  						 sc->nid);
> > 
> 
> Yes, those comments are needed.
> I also need to remove the corresponding
> 	drop_super(sb);
> 
> So probably something like:
> 
> ---
> diff --git a/fs/super.c b/fs/super.c
> index 73d0952..7b5a6e5 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -112,9 +112,14 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>  
>  	sb = container_of(shrink, struct super_block, s_shrink);
>  
> -	if (!grab_super_passive(sb))
> -		return 0;
> -
> +	/*
> +	 * Don't call grab_super_passive as it is a potential 
> +	 * scalability bottleneck. The counts could get updated 
> +	 * between super_cache_count and super_cache_scan anyway.
> +	 * Call to super_cache_count with shrinker_rwsem held
> +	 * ensures the safety of call to list_lru_count_node() and 
> +	 * s_op->nr_cached_objects().
> +	 */

Well, that's not true of s_op->nr_cached_objects() right now. It's
only going to be true if the shrinker deregistration is moved before
->kill_sb()....

> > Let me have a bit more of a think about this - the solution may
> > simply be unregistering the shrinker before we call ->kill_sb() so
> > the shrinker can't get called while we are tearing down the fs.
> > First, though, I need to go back and remind myself of why I put that
> > after ->kill_sb() in the first place.  
> 
> Seems very reasonable as I haven't found a case where the shrinker 
> is touched in ->kill_sb() yet. It looks like unregistering the
> shrinker before ->kill_sb() should be okay.

Having looked at it some more, I have to agree. I think the original
reason for unregistering the shrinker there was to avoid problems
with locking - the shrinker callouts are run holding the
shrinker_rwsem in read mode, and then we lock the sb->s_umount in
read mount. In the unmount case, we currently take the sb->s_umount
lock in write mode (thereby locking out the shrinker) but we drop it
before deregistering the shrinker and so there is no inverted
locking order.

The thing is, grab_super_passive does a try-lock on the sb->s_umount
now, and so if we are in the unmount process, it won't ever block.
That means what used to be a deadlock and races we were avoiding
by using grab_super_passive() is now:

	shrinker			umount

	down_read(shrinker_rwsem)
					down_write(sb->s_umount)
					shrinker_unregister
					  down_write(shrinker_rwsem)
					    <blocks>
	grab_super_passive(sb)
	  down_read_trylock(sb->s_umount)
	    <fails>
	<shrinker aborts>
	....
	<shrinkers finish running>
	up_read(shrinker_rwsem)
					  <unblocks>
					  <removes shrinker>
					  up_write(shrinker_rwsem)
					->kill_sb()
					....

And so it appears to be safe to deregister the shrinker before
->kill_sb().

Can you do this as two patches? The first moves the shrinker
deregistration to before ->kill_sb(), then second is the above patch
that drops the grab-super_passive() calls from the ->count_objects
function?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
