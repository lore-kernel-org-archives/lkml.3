Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab3LJBi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:38:58 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:43210 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787Ab3LJBi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:38:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEIAPlvplJ5LHyk/2dsb2JhbABZgwe0UYVQgSYXdIIlAQEEAScTHCMQCAMOCgklDwUlAyETh3wFwGIXFo56B4QzA5gTikyHSIFrgVIo
Date: Tue, 10 Dec 2013 12:38:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: dchinner@redhat.com, hannes@cmpxchg.org, mhocko@suse.cz,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org,
        glommer@openvz.org, glommer@gmail.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v13 09/16] fs: consolidate {nr,free}_cached_objects args
 in shrink_control
Message-ID: <20131210013841.GY31386@dastard>
References: <cover.1386571280.git.vdavydov@parallels.com>
 <43660b83b58531ccf4d45f626283484441441943.1386571280.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43660b83b58531ccf4d45f626283484441441943.1386571280.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 12:05:50PM +0400, Vladimir Davydov wrote:
> We are going to make the FS shrinker memcg-aware. To achieve that, we
> will have to pass the memcg to scan to the nr_cached_objects and
> free_cached_objects VFS methods, which currently take only the NUMA node
> to scan. Since the shrink_control structure already holds the node, and
> the memcg to scan will be added to it as we introduce memcg-aware
> vmscan, let us consolidate the methods' arguments in this structure to
> keep things clean.
> 
> Thanks to David Chinner for the tip.

Ok, you dealt with this as a separate patch...

> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: Glauber Costa <glommer@openvz.org>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/super.c         |    8 +++-----
>  fs/xfs/xfs_super.c |    6 +++---
>  include/linux/fs.h |    6 ++++--
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index a039dba..8f9a81b 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -76,7 +76,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>  		return SHRINK_STOP;
>  
>  	if (sb->s_op->nr_cached_objects)
> -		fs_objects = sb->s_op->nr_cached_objects(sb, sc->nid);
> +		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	inodes = list_lru_count(&sb->s_inode_lru, sc);
>  	dentries = list_lru_count(&sb->s_dentry_lru, sc);
> @@ -96,8 +96,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>  	if (fs_objects) {
>  		fs_objects = mult_frac(sc->nr_to_scan, fs_objects,
>  								total_objects);
> -		freed += sb->s_op->free_cached_objects(sb, fs_objects,
> -						       sc->nid);
> +		freed += sb->s_op->free_cached_objects(sb, sc, fs_objects);
>  	}

Again, pass the number to scan in sc->nr_to_scan, please.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
