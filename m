Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaGGOZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:25:34 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:47370 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbaGGOZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:25:32 -0400
Date: Mon, 7 Jul 2014 10:25:06 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, mhocko@suse.cz, cl@linux.com, glommer@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/8] memcg: reparent kmem on css offline
Message-ID: <20140707142506.GB1149@cmpxchg.org>
References: <cover.1404733720.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1404733720.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vladimir,

On Mon, Jul 07, 2014 at 04:00:05PM +0400, Vladimir Davydov wrote:
> Hi,
> 
> This patch set introduces re-parenting of kmem charges on memcg css
> offline. The idea lying behind it is very simple - instead of pointing
> from kmem objects (kmem caches, non-slab kmem pages) directly to the
> memcg which they are charged against, we make them point to a proxy
> object, mem_cgroup_kmem_context, which, in turn, points to the memcg
> which it belongs to. As a result on memcg offline, it's enough to only
> re-parent the memcg's mem_cgroup_kmem_context.

The motivation for this was to clear out all references to a memcg by
the time it's offlined, so that the unreachable css can be freed soon.

However, recent cgroup core changes further disconnected the css from
the cgroup object itself, so it's no longer as urgent to free the css.

In addition, Tejun made offlined css iterable and split css_tryget()
and css_tryget_online(), which would allow memcg to pin the css until
the last charge is gone while continuing to iterate and reclaim it on
hierarchical pressure, even after it was offlined.

This would obviate the need for reparenting as a whole, not just kmem
pages, but even remaining page cache.  Michal already obsoleted the
force_empty knob that reparents as a fallback, and whether the cache
pages are in the parent or in a ghost css after cgroup deletion does
not make a real difference from a user point of view, they still get
reclaimed when the parent experiences pressure.

You could then reap dead slab caches as part of the regular per-memcg
slab scanning in reclaim, without having to resort to auxiliary lists,
vmpressure events etc.

I think it would save us a lot of code and complexity.  You want
per-memcg slab scanning *anyway*, all we'd have to change in the
existing code would be to pin the css until the LRUs and kmem caches
are truly empty, and switch mem_cgroup_iter() to css_tryget().

Would this make sense to you?
