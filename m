Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbbAMX4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:56:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbAMX4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:56:40 -0500
Date: Tue, 13 Jan 2015 15:56:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] fs: shrinker: always scan at least one object of
 each type
Message-Id: <20150113155639.53e48aad4b0cfe870ccffac4@linux-foundation.org>
In-Reply-To: <1421058046-2434-1-git-send-email-vdavydov@parallels.com>
References: <1421058046-2434-1-git-send-email-vdavydov@parallels.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015 13:20:46 +0300 Vladimir Davydov <vdavydov@parallels.com> wrote:

> In super_cache_scan() we divide the number of objects of particular type
> by the total number of objects in order to distribute pressure among
> different types of fs objects (inodes, dentries, fs-private objects).
> As a result, in some corner cases we can get nr_to_scan=0 even if there
> are some objects to reclaim, e.g. dentries=1, inodes=1, fs_objects=1,
> nr_to_scan=1/3=0.
> 
> This is unacceptable for per memcg kmem accounting, because this means
> that some objects may never get reclaimed after memcg death, preventing
> it from being freed.
> 
> This patch therefore assures that super_cache_scan() will scan at least
> one object of each type if any.
> 
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -92,13 +92,13 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>  	 * prune the dcache first as the icache is pinned by it, then
>  	 * prune the icache, followed by the filesystem specific caches
>  	 */
> -	sc->nr_to_scan = dentries;
> +	sc->nr_to_scan = dentries + 1;
>  	freed = prune_dcache_sb(sb, sc);
> -	sc->nr_to_scan = inodes;
> +	sc->nr_to_scan = inodes + 1;
>  	freed += prune_icache_sb(sb, sc);
>  
>  	if (fs_objects) {
> -		sc->nr_to_scan = fs_objects;
> +		sc->nr_to_scan = fs_objects + 1;
>  		freed += sb->s_op->free_cached_objects(sb, sc);
>  	}

A reader of this code will wonder "why is it adding 1 everywhere". 
Let's tell them?

--- a/fs/super.c~fs-shrinker-always-scan-at-least-one-object-of-each-type-fix
+++ a/fs/super.c
@@ -91,6 +91,9 @@ static unsigned long super_cache_scan(st
 	/*
 	 * prune the dcache first as the icache is pinned by it, then
 	 * prune the icache, followed by the filesystem specific caches
+	 *
+	 * Ensure that we always scan at least one object - memcg kmem
+	 * accounting uses this to fully empty the caches.
 	 */
 	sc->nr_to_scan = dentries + 1;
 	freed = prune_dcache_sb(sb, sc);
_

