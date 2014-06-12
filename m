Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbaFLKCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:02:54 -0400
Received: from mx2.parallels.com ([199.115.105.18]:46975 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885AbaFLKCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:02:51 -0400
Date: Thu, 12 Jun 2014 14:02:32 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Christoph Lameter <cl@gentwo.org>, <akpm@linux-foundation.org>,
        <rientjes@google.com>, <penberg@kernel.org>, <hannes@cmpxchg.org>,
        <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v2 8/8] slab: make dead memcg caches discard free
 slabs immediately
Message-ID: <20140612100231.GA19221@esperanza>
References: <cover.1402060096.git.vdavydov@parallels.com>
 <27a202c6084d6bb19cc3e417793f05104b908ded.1402060096.git.vdavydov@parallels.com>
 <20140610074317.GE19036@js1304-P5Q-DELUXE>
 <20140610100313.GA6293@esperanza>
 <alpine.DEB.2.10.1406100925270.17142@gentwo.org>
 <20140610151830.GA8692@esperanza>
 <20140611212431.GA16589@esperanza>
 <20140612065345.GD19918@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140612065345.GD19918@js1304-P5Q-DELUXE>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 03:53:45PM +0900, Joonsoo Kim wrote:
> On Thu, Jun 12, 2014 at 01:24:34AM +0400, Vladimir Davydov wrote:
> > On Tue, Jun 10, 2014 at 07:18:34PM +0400, Vladimir Davydov wrote:
> > > On Tue, Jun 10, 2014 at 09:26:19AM -0500, Christoph Lameter wrote:
> > > > On Tue, 10 Jun 2014, Vladimir Davydov wrote:
> > > > 
> > > > > Frankly, I incline to shrinking dead SLAB caches periodically from
> > > > > cache_reap too, because it looks neater and less intrusive to me. Also
> > > > > it has zero performance impact, which is nice.
> > > > >
> > > > > However, Christoph proposed to disable per cpu arrays for dead caches,
> > > > > similarly to SLUB, and I decided to give it a try, just to see the end
> > > > > code we'd have with it.
> > > > >
> > > > > I'm still not quite sure which way we should choose though...
> > > > 
> > > > Which one is cleaner?
> > > 
> > > To shrink dead caches aggressively, we only need to modify cache_reap
> > > (see https://lkml.org/lkml/2014/5/30/271).
> > 
> > Hmm, reap_alien, which is called from cache_reap to shrink per node
> > alien object arrays, only processes one node at a time. That means with
> > the patch I gave a link to above it will take up to
> > (REAPTIMEOUT_AC*nr_online_nodes) seconds to destroy a virtually empty
> > dead cache, which may be quite long on large machines. Of course, we can
> > make reap_alien walk over all alien caches of the current node, but that
> > will probably hurt performance...
> 
> Hmm, maybe we have a few of objects on other node, doesn't it?

I think so, but those few objects will prevent the cache from
destruction until they are reaped, which may take long.

> BTW, I have a question about cache_reap(). If there are many kmemcg
> users, we would have a lot of slab caches and just to traverse slab
> cache list could take some times. Is it no problem?

This may be a problem. Since a cache will stay alive while it has at
least one active object, there may be throngs of dead caches on the
list, actually their number won't even be limited by the number of
memcgs. This can slow down cache reaping and result in noticeable memory
pressure. Also, it will delay destruction of dead caches, making the
situation even worse. And we can't even delete dead caches from the
list, because they won't be reaped then...

OTOH, if we disable per cpu arrays for dead caches, we won't have to
reap them and therefore can remove them from the slab_caches list. Then
the number of caches on the list will be bound by the number of memcgs
multiplied by a constant. Although it still may be quite large, this
will be predictable at least - the more kmem-active memcgs you have, the
more memory you need, which sounds reasonable to me.

Regarding the slowdown introduced by disabling of per cpu arrays, I
guess it shouldn't be critical, because, as dead caches are never
allocated from, the number of kfree's left after death is quite limited.

So, everything isn't that straightforward yet...

I think I'll try to simplify the patch that disables per cpu arrays for
dead caches and send implementations of both approaches with their pros
and cons outlined in the next iteration, so that we can compare them
side by side.

Thanks.
