Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508Ab3ICSi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:38:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:64137 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760449Ab3ICSi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:38:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1015,1367996400"; 
   d="scan'208";a="372886581"
Subject: Re: [PATCH] Avoid useless inodes and dentries reclamation
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
In-Reply-To: <20130831090006.GZ12779@dastard>
References: <1377726732.3625.31.camel@schen9-DESK>
	 <20130829110741.GA23571@dastard> <1377799676.3625.69.camel@schen9-DESK>
	 <20130830014005.GT12779@dastard> <1377879694.3625.77.camel@schen9-DESK>
	 <20130831090006.GZ12779@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Sep 2013 11:38:27 -0700
Message-ID: <1378233507.3625.90.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-31 at 19:00 +1000, Dave Chinner wrote:
> On Fri, Aug 30, 2013 at 09:21:34AM -0700, Tim Chen wrote:
> >
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > ---
> > diff --git a/fs/super.c b/fs/super.c
> > index 73d0952..4df1fab 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -112,9 +112,6 @@ static unsigned long super_cache_count(struct shrinker *shrink,
> >  
> >  	sb = container_of(shrink, struct super_block, s_shrink);
> >  
> > -	if (!grab_super_passive(sb))
> > -		return 0;
> > -
> 
> I think the function needs a comment explaining why we aren't
> grabbing the sb here, otherwise people are going to read the code
> and ask why it's different to the scanning callout.
> 
> >  	if (sb->s_op && sb->s_op->nr_cached_objects)
> >  		total_objects = sb->s_op->nr_cached_objects(sb,
> >  						 sc->nid);
> 

Yes, those comments are needed.
I also need to remove the corresponding
	drop_super(sb);

So probably something like:

---
diff --git a/fs/super.c b/fs/super.c
index 73d0952..7b5a6e5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -112,9 +112,14 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 
 	sb = container_of(shrink, struct super_block, s_shrink);
 
-	if (!grab_super_passive(sb))
-		return 0;
-
+	/*
+	 * Don't call grab_super_passive as it is a potential 
+	 * scalability bottleneck. The counts could get updated 
+	 * between super_cache_count and super_cache_scan anyway.
+	 * Call to super_cache_count with shrinker_rwsem held
+	 * ensures the safety of call to list_lru_count_node() and 
+	 * s_op->nr_cached_objects().
+	 */
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb,
 						 sc->nid);
@@ -125,7 +130,6 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 						 sc->nid);
 
 	total_objects = vfs_pressure_ratio(total_objects);
-	drop_super(sb);
 	return total_objects;
 }
 


> But seeing this triggered further thought on my part. Being called
> during unmount means that ->nr_cached_objects implementations need
> to be robust against unmount tearing down private filesystem
> structures.  Right now, grab_super_passive() protects us from that
> because it won't be able to get the sb->s_umount lock while
> generic_shutdown_super() is doing it's work.
> 
> IOWs, the superblock based shrinker operations are safe because the
> structures don't get torn down until after the shrinker is
> unregistered. That's not true for the structures that
> ->nr_cached_objects() use: ->put_super() tears them down before the
> shrinker is unregistered and only grab_super_passive() protects us
> from thay.
> 
> Let me have a bit more of a think about this - the solution may
> simply be unregistering the shrinker before we call ->kill_sb() so
> the shrinker can't get called while we are tearing down the fs.
> First, though, I need to go back and remind myself of why I put that
> after ->kill_sb() in the first place.  

Seems very reasonable as I haven't found a case where the shrinker 
is touched in ->kill_sb() yet. It looks like unregistering the
shrinker before ->kill_sb() should be okay.

> If we unregister the shrinker
> before ->kill_sb is called, then we can probably get rid of
> grab_super_passive() in both shrinker callouts because they will no
> longer need to handle running concurrently with ->kill_sb()....
> 

Thanks.

Tim

