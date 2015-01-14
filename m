Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbbANHy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:54:56 -0500
Received: from mx2.parallels.com ([199.115.105.18]:52204 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbbANHgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:36:17 -0500
Date: Wed, 14 Jan 2015 10:36:08 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] fs: shrinker: always scan at least one object of
 each type
Message-ID: <20150114073608.GC11264@esperanza>
References: <1421058046-2434-1-git-send-email-vdavydov@parallels.com>
 <20150113155639.53e48aad4b0cfe870ccffac4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150113155639.53e48aad4b0cfe870ccffac4@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 03:56:39PM -0800, Andrew Morton wrote:
> On Mon, 12 Jan 2015 13:20:46 +0300 Vladimir Davydov <vdavydov@parallels.com> wrote:
> 
> > In super_cache_scan() we divide the number of objects of particular type
> > by the total number of objects in order to distribute pressure among
> > different types of fs objects (inodes, dentries, fs-private objects).
> > As a result, in some corner cases we can get nr_to_scan=0 even if there
> > are some objects to reclaim, e.g. dentries=1, inodes=1, fs_objects=1,
> > nr_to_scan=1/3=0.
> > 
> > This is unacceptable for per memcg kmem accounting, because this means
> > that some objects may never get reclaimed after memcg death, preventing
> > it from being freed.
> > 
> > This patch therefore assures that super_cache_scan() will scan at least
> > one object of each type if any.
> > 
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -92,13 +92,13 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
> >  	 * prune the dcache first as the icache is pinned by it, then
> >  	 * prune the icache, followed by the filesystem specific caches
> >  	 */
> > -	sc->nr_to_scan = dentries;
> > +	sc->nr_to_scan = dentries + 1;
> >  	freed = prune_dcache_sb(sb, sc);
> > -	sc->nr_to_scan = inodes;
> > +	sc->nr_to_scan = inodes + 1;
> >  	freed += prune_icache_sb(sb, sc);
> >  
> >  	if (fs_objects) {
> > -		sc->nr_to_scan = fs_objects;
> > +		sc->nr_to_scan = fs_objects + 1;
> >  		freed += sb->s_op->free_cached_objects(sb, sc);
> >  	}
> 
> A reader of this code will wonder "why is it adding 1 everywhere". 
> Let's tell them?

Yeah, sounds reasonable. Thank you!

> 
> --- a/fs/super.c~fs-shrinker-always-scan-at-least-one-object-of-each-type-fix
> +++ a/fs/super.c
> @@ -91,6 +91,9 @@ static unsigned long super_cache_scan(st
>  	/*
>  	 * prune the dcache first as the icache is pinned by it, then
>  	 * prune the icache, followed by the filesystem specific caches
> +	 *
> +	 * Ensure that we always scan at least one object - memcg kmem
> +	 * accounting uses this to fully empty the caches.
>  	 */
>  	sc->nr_to_scan = dentries + 1;
>  	freed = prune_dcache_sb(sb, sc);
> _
> 
