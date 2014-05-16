Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbaEPNGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:06:44 -0400
Received: from mx2.parallels.com ([199.115.105.18]:54352 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328AbaEPNGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:06:41 -0400
Date: Fri, 16 May 2014 17:06:30 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH RFC 1/3] slub: keep full slabs on list for per memcg
 caches
Message-ID: <20140516130629.GE32113@esperanza>
References: <cover.1399982635.git.vdavydov@parallels.com>
 <bc70b480221f7765926c8b4d63c55fb42e85baaf.1399982635.git.vdavydov@parallels.com>
 <alpine.DEB.2.10.1405141114040.16512@gentwo.org>
 <20140515063441.GA32113@esperanza>
 <alpine.DEB.2.10.1405151011210.24665@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405151011210.24665@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:15:10AM -0500, Christoph Lameter wrote:
> On Thu, 15 May 2014, Vladimir Davydov wrote:
> 
> > > That will significantly impact the fastpaths for alloc and free.
> > >
> > > Also a pretty significant change the logic of the fastpaths since they
> > > were not designed to handle the full lists. In debug mode all operations
> > > were only performed by the slow paths and only the slow paths so far
> > > supported tracking full slabs.
> >
> > That's the minimal price we have to pay for slab re-parenting, because
> > w/o it we won't be able to look up for all slabs of a particular per
> > memcg cache. The question is, can it be tolerated or I'd better try some
> > other way?
> 
> AFACIT these modifications all together will have a significant impact on
> performance.
> 
> You could avoid the refcounting on free relying on the atomic nature of
> cmpxchg operations. If you zap the per cpu slab then the fast path will be
> forced to fall back to the slowpaths where you could do what you need to
> do.

Hmm, looking at __slab_free once again, I tend to agree that we could
rely on cmpxchg to do re-parenting: we could freeze all slabs of the
cache being re-parented forcing every on-going kfree to do only a
cmpxchg w/o touching any lists and taking any locks, and then unfreeze
all the frozen slabs to the target cache. No need in the ugly "slow
mode" I introduced in this patch set would be necessary then.

But w/o ref-counting how can we make sure that all kfrees to the cache
we are going to re-parent have been completed so that it can be safely
destroyed? An example:

  CPU0:                                 CPU1:
  -----                                 -----
  kfree(obj):
    page = virt_to_head_page(obj)
    s = page->slab_cache
    slab_free(s, page, obj):
      <<< gets preempted here

                                        reparent_slab_cache:
                                          for each slab page
                                            [...]
                                            page->slab_cache = target_cache;

                                          kmem_cache_destroy(old_cache)

      <<< continues execution
      c = s->cpu_slab /* s points to the previous owner cache,
                         so we use-after-free here */

If kfree were not preemptable, we could make reparent_slab_cache wait
for all cpus to schedule() before destroying the cache to avoid this,
but since it is, we need ref-counting...

Thanks.

> There is no tracking of full slabs without adding much more logic to the
> fastpath. You could force any operation that affects tne full list into
> the slow path. But that also would have an impact.
