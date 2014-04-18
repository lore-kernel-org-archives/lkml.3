Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaDRNXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:23:51 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59151 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbaDRNXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:23:44 -0400
Date: Fri, 18 Apr 2014 09:23:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: mhocko@suse.cz, akpm@linux-foundation.org, glommer@gmail.com,
        cl@linux-foundation.org, penberg@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, devel@openvz.org
Subject: Re: [PATCH RFC -mm v2 0/3] kmemcg: simplify work-flow (was
 "memcg-vs-slab cleanup")
Message-ID: <20140418132331.GA26283@cmpxchg.org>
References: <cover.1397804745.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1397804745.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vladimir,

On Fri, Apr 18, 2014 at 12:04:46PM +0400, Vladimir Davydov wrote:
> Hi Michal, Johannes,
> 
> This patch-set is a part of preparations for kmemcg re-parenting. It
> targets at simplifying kmemcg work-flows and synchronization.
> 
> First, it removes async per memcg cache destruction (see patches 1, 2).
> Now caches are only destroyed on memcg offline. That means the caches
> that are not empty on memcg offline will be leaked. However, they are
> already leaked, because memcg_cache_params::nr_pages normally never
> drops to 0 so the destruction work is never scheduled except
> kmem_cache_shrink is called explicitly. In the future I'm planning
> reaping such dead caches on vmpressure or periodically.

I like the synchronous handling on css destruction, but the periodical
reaping part still bothers me.  If there is absolutely 0 use for these
caches remaining, they shouldn't hang around until we encounter memory
pressure or a random time interval.

Would it be feasible to implement cache merging in both slub and slab,
so that upon css destruction the child's cache's remaining slabs could
be moved to the parent's cache?  If the parent doesn't have one, just
reparent the whole cache.

> Second, it substitutes per memcg slab_caches_mutex's with the global
> memcg_slab_mutex, which should be taken during the whole per memcg cache
> creation/destruction path before the slab_mutex (see patch 3). This
> greatly simplifies synchronization among various per memcg cache
> creation/destruction paths.

This sounds reasonable.  I'll go look at the code.
