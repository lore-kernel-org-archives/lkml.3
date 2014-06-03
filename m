Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaFCJGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:06:34 -0400
Received: from mx2.parallels.com ([199.115.105.18]:46656 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaFCJGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:06:33 -0400
Date: Tue, 3 Jun 2014 13:06:26 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@gentwo.org>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm 5/8] slab: remove kmem_cache_shrink retval
Message-ID: <20140603090623.GC6013@esperanza>
References: <cover.1401457502.git.vdavydov@parallels.com>
 <d2bbd28ae0f0c1807f9fe72d0443eccb739b8aa6.1401457502.git.vdavydov@parallels.com>
 <alpine.DEB.2.10.1405300947170.11943@gentwo.org>
 <20140531102740.GB25076@esperanza>
 <alpine.DEB.2.10.1406021014140.2987@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406021014140.2987@gentwo.org>
X-Originating-IP: [109.195.248.178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:16:03AM -0500, Christoph Lameter wrote:
> On Sat, 31 May 2014, Vladimir Davydov wrote:
> 
> > > Well slub returns an error code if it fails
> >
> > ... to sort slabs by the nubmer of objects in use, which is not even
> > implied by the function declaration. Why can *shrinking*, which is what
> > kmem_cache_shrink must do at first place, ever fail?
> 
> Because there is a memory allocation failure. Or there may be other
> processes going on that prevent shrinking. F.e. We may want to merge a
> patchset that does defragmentation of slabs at some point.

Fair enough.

Still, I really want to evict all empty slabs from cache on memcg
offline for sure. Handling failures there means introducing a worker
that will retry shrinking, but that seems to me as an unnecessary
complication, because there's nothing that can prevent us from shrinking
empty slabs from the cache, even if we merge slab defragmentation, isn't
it?

May be, it's worth introducing a special function, say kmem_cache_zap(),
that will only evict empty slabs from the cache, plus disable empty
slabs caching? This function would be called only from memcg offline for
dead memcg caches.

Thanks.
