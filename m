Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaFBEVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 00:21:18 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56605 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaFBEVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 00:21:16 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 2 Jun 2014 13:24:36 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@gentwo.org>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, mhocko@suse.cz, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH -mm 7/8] slub: make dead caches discard free slabs
 immediately
Message-ID: <20140602042435.GA17964@js1304-P5Q-DELUXE>
References: <cover.1401457502.git.vdavydov@parallels.com>
 <5d2fbc894a2c62597e7196bb1ebb8357b15529ab.1401457502.git.vdavydov@parallels.com>
 <alpine.DEB.2.10.1405300955120.11943@gentwo.org>
 <20140531110456.GC25076@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140531110456.GC25076@esperanza>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 03:04:58PM +0400, Vladimir Davydov wrote:
> On Fri, May 30, 2014 at 09:57:10AM -0500, Christoph Lameter wrote:
> > On Fri, 30 May 2014, Vladimir Davydov wrote:
> > 
> > > (3) is a bit more difficult, because slabs are added to per-cpu partial
> > > lists lock-less. Fortunately, we only have to handle the __slab_free
> > > case, because, as there shouldn't be any allocation requests dispatched
> > > to a dead memcg cache, get_partial_node() should never be called. In
> > > __slab_free we use cmpxchg to modify kmem_cache_cpu->partial (see
> > > put_cpu_partial) so that setting ->partial to a special value, which
> > > will make put_cpu_partial bail out, will do the trick.
> > >
> > > Note, this shouldn't affect performance, because keeping empty slabs on
> > > per node lists as well as using per cpu partials are only worthwhile if
> > > the cache is used for allocations, which isn't the case for dead caches.
> > 
> > This all sounds pretty good to me but we still have some pretty extensive
> > modifications that I would rather avoid.
> > 
> > In put_cpu_partial you can simply check that the memcg is dead right? This
> > would avoid all the other modifications I would think and will not require
> > a special value for the per cpu partial pointer.
> 
> That would be racy. The check if memcg is dead and the write to per cpu
> partial ptr wouldn't proceed as one atomic operation. If we set the dead
> flag from another thread between these two operations, put_cpu_partial
> will add a slab to a per cpu partial list *after* the cache was zapped.

Hello, Vladimir.

I think that we can do (3) easily.
If we check memcg_cache_dead() in the end of put_cpu_partial() rather
than in the begin of put_cpu_partial(), we can avoid the race you 
mentioned. If someone do put_cpu_partial() before dead flag is set,
it can be zapped by who set dead flag. And if someone do
put_cpu_partial() after dead flag is set, it can be zapped by who
do put_cpu_partial().

Thanks.
