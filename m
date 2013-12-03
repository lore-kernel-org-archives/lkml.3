Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3LCJAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:00:52 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7021 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010Ab3LCJAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:00:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhEHAKqcnVJ5LHyk/2dsb2JhbABagweDMbBzhDWBGYEYF3SCJQEBBScTHCMQCAMOCgklDwUlAyETiADBFxcWjmgHgyCBEwOYE4pMh0iDPSg
Date: Tue, 3 Dec 2013 20:00:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: hannes@cmpxchg.org, mhocko@suse.cz, dchinner@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org,
        glommer@openvz.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v12 05/18] fs: do not use destroy_super() in
 alloc_super() fail path
Message-ID: <20131203090041.GB8803@dastard>
References: <cover.1385974612.git.vdavydov@parallels.com>
 <af90b79aebe9cd9f6e1d35513f2618f4e9888e9b.1385974612.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af90b79aebe9cd9f6e1d35513f2618f4e9888e9b.1385974612.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 03:19:40PM +0400, Vladimir Davydov wrote:
> Using destroy_super() in alloc_super() fail path is bad, because:
> 
> * It will trigger WARN_ON(!list_empty(&s->s_mounts)) since s_mounts is
>   initialized after several 'goto fail's.

So let's fix that.

> * It will call kfree_rcu() to free the super block although kfree() is
>   obviously enough there.
> * The list_lru structure was initially implemented without the ability
>   to destroy an uninitialized object in mind.
> 
> I'm going to replace the conventional list_lru with per-memcg lru to
> implement per-memcg slab reclaim. This new structure will fail
> destruction of objects that haven't been properly initialized so let's
> inline appropriate snippets from destroy_super() to alloc_super() fail
> path instead of using the whole function there.

You're basically undoing the change made in commit 7eb5e88 ("uninline
destroy_super(), consolidate alloc_super()") which was done less
than a month ago. :/

The code as it stands works just fine - the list-lru structures in
the superblock are actually initialised (to zeros) - and so calling
list_lru_destroy() on it works just fine in that state as the
pointers that are freed are NULL. Yes, unexpected, but perfectly
valid code.

I haven't looked at the internals of the list_lru changes you've
made yet, but it surprises me that we can't handle this case
internally to list_lru_destroy().

Al, your call on inlining destroy_super() in alloc_super() again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
