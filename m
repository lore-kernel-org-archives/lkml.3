Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaFKVYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:24:55 -0400
Received: from mx2.parallels.com ([199.115.105.18]:41183 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaFKVYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:24:54 -0400
Date: Thu, 12 Jun 2014 01:24:34 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@gentwo.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, <akpm@linux-foundation.org>,
        <rientjes@google.com>, <penberg@kernel.org>, <hannes@cmpxchg.org>,
        <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v2 8/8] slab: make dead memcg caches discard free
 slabs immediately
Message-ID: <20140611212431.GA16589@esperanza>
References: <cover.1402060096.git.vdavydov@parallels.com>
 <27a202c6084d6bb19cc3e417793f05104b908ded.1402060096.git.vdavydov@parallels.com>
 <20140610074317.GE19036@js1304-P5Q-DELUXE>
 <20140610100313.GA6293@esperanza>
 <alpine.DEB.2.10.1406100925270.17142@gentwo.org>
 <20140610151830.GA8692@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140610151830.GA8692@esperanza>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 07:18:34PM +0400, Vladimir Davydov wrote:
> On Tue, Jun 10, 2014 at 09:26:19AM -0500, Christoph Lameter wrote:
> > On Tue, 10 Jun 2014, Vladimir Davydov wrote:
> > 
> > > Frankly, I incline to shrinking dead SLAB caches periodically from
> > > cache_reap too, because it looks neater and less intrusive to me. Also
> > > it has zero performance impact, which is nice.
> > >
> > > However, Christoph proposed to disable per cpu arrays for dead caches,
> > > similarly to SLUB, and I decided to give it a try, just to see the end
> > > code we'd have with it.
> > >
> > > I'm still not quite sure which way we should choose though...
> > 
> > Which one is cleaner?
> 
> To shrink dead caches aggressively, we only need to modify cache_reap
> (see https://lkml.org/lkml/2014/5/30/271).

Hmm, reap_alien, which is called from cache_reap to shrink per node
alien object arrays, only processes one node at a time. That means with
the patch I gave a link to above it will take up to
(REAPTIMEOUT_AC*nr_online_nodes) seconds to destroy a virtually empty
dead cache, which may be quite long on large machines. Of course, we can
make reap_alien walk over all alien caches of the current node, but that
will probably hurt performance...

> 
> To zap object arrays for dead caches (this is what this patch does), we
> have to:
>  - set array_cache->limit to 0 for each per cpu, shared, and alien array
>    caches on kmem_cache_shrink;
>  - make cpu/node hotplug paths init new array cache sizes to 0;
>  - make free paths (__cache_free, cache_free_alien) handle zero array
>    cache size properly, because currently they doesn't.
> 
> So IMO the first one (reaping dead caches periodically) requires less
> modifications and therefore is cleaner.
