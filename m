Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3HaJAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 05:00:17 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:63937 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753607Ab3HaJAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 05:00:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwGAH6vIVJ5LJ62/2dsb2JhbABagweDRLhohUSBHRd0giQBAQQBJxMcIwULCAMYCSUPBSUDIRMbh2EFug4Wj2kHhB0Dl3SRZ4MyKg
Date: Sat, 31 Aug 2013 19:00:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid useless inodes and dentries reclamation
Message-ID: <20130831090006.GZ12779@dastard>
References: <1377726732.3625.31.camel@schen9-DESK>
 <20130829110741.GA23571@dastard>
 <1377799676.3625.69.camel@schen9-DESK>
 <20130830014005.GT12779@dastard>
 <1377879694.3625.77.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377879694.3625.77.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 09:21:34AM -0700, Tim Chen wrote:
> On Fri, 2013-08-30 at 11:40 +1000, Dave Chinner wrote:
> 
> > 
> > The new shrinker infrastructure has a ->count_objects() callout to
> > specifically return the number of objects in the cache.
> > shrink_slab_node() can check that return value against the "minimum
> > call count" and determine whether it needs to call ->scan_objects()
> > at all.
> > 
> > Actually, the shrinker already behaves like this with the batch_size
> > variable - the shrinker has to be asking for more items to be
> > scanned than the batch size. That means the problem is that counting
> > callouts are causing the problem, not the scanning callouts.
> > 
> > With the new code in the mmotm tree, for counting purposes we
> > probably don't need to grab a passive superblock reference at all -
> > the superblock and LRUs are guaranteed to be valid if the shrinker
> > is currently running, but we don't really care if the superblock is
> > being shutdown and the values that come back are invalid because the
> > ->scan_objects() callout will fail to grab the superblock to do
> > anything with the calculated values.
> 
> If that's the case, then we should remove grab_super_passive
> from the super_cache_count code.  That should remove the bottleneck
> in reclamation.
> 
> Thanks for your detailed explanation.
> 
> Tim
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
> diff --git a/fs/super.c b/fs/super.c
> index 73d0952..4df1fab 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -112,9 +112,6 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>  
>  	sb = container_of(shrink, struct super_block, s_shrink);
>  
> -	if (!grab_super_passive(sb))
> -		return 0;
> -

I think the function needs a comment explaining why we aren't
grabbing the sb here, otherwise people are going to read the code
and ask why it's different to the scanning callout.

>  	if (sb->s_op && sb->s_op->nr_cached_objects)
>  		total_objects = sb->s_op->nr_cached_objects(sb,
>  						 sc->nid);

But seeing this triggered further thought on my part. Being called
during unmount means that ->nr_cached_objects implementations need
to be robust against unmount tearing down private filesystem
structures.  Right now, grab_super_passive() protects us from that
because it won't be able to get the sb->s_umount lock while
generic_shutdown_super() is doing it's work.

IOWs, the superblock based shrinker operations are safe because the
structures don't get torn down until after the shrinker is
unregistered. That's not true for the structures that
->nr_cached_objects() use: ->put_super() tears them down before the
shrinker is unregistered and only grab_super_passive() protects us
from thay.

Let me have a bit more of a think about this - the solution may
simply be unregistering the shrinker before we call ->kill_sb() so
the shrinker can't get called while we are tearing down the fs.
First, though, I need to go back and remind myself of why I put that
after ->kill_sb() in the first place.  If we unregister the shrinker
before ->kill_sb is called, then we can probably get rid of
grab_super_passive() in both shrinker callouts because they will no
longer need to handle running concurrently with ->kill_sb()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
