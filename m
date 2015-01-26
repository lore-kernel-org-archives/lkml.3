Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbbAZUQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:16:16 -0500
Received: from mx2.parallels.com ([199.115.105.18]:33201 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbAZUQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:16:12 -0500
Date: Mon, 26 Jan 2015 23:16:02 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/3] slab: zap kmem_cache_shrink return value
Message-ID: <20150126201602.GA3317@esperanza>
References: <cover.1422275084.git.vdavydov@parallels.com>
 <b89d28384f8ec7865c3fefc2f025955d55798b78.1422275084.git.vdavydov@parallels.com>
 <alpine.DEB.2.11.1501260949150.15849@gentwo.org>
 <20150126170418.GC28978@esperanza>
 <alpine.DEB.2.11.1501261226250.16638@gentwo.org>
 <20150126194838.GB2660@esperanza>
 <alpine.DEB.2.11.1501261353480.16786@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501261353480.16786@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 01:55:14PM -0600, Christoph Lameter wrote:
> On Mon, 26 Jan 2015, Vladimir Davydov wrote:
> 
> > Hmm, why? The return value has existed since this function was
> > introduced, but nobody seems to have ever used it outside the slab core.
> > Besides, this check is racy, so IMO we shouldn't encourage users of the
> > API to rely on it. That said, I believe we should drop the return value
> > for now. If anybody ever needs it, we can reintroduce it.
> 
> The check is only racy if you have concurrent users. It is not racy if a
> subsystem shuts down access to the slabs and then checks if everything is
> clean before closing the cache.
>
> Slab creation and destruction are not serialized. It is the responsibility
> of the subsystem to make sure that there are no concurrent users and that
> there are no objects remaining before destroying a slab.

Right, but I just don't see why a subsystem using a kmem_cache would
need to check whether there are any objects left in the cache. I mean,
it should somehow keep track of the objects it's allocated anyway, e.g.
by linking them in a list. That means it must already have a way to
check if it is safe to destroy its cache or not.

Suppose we leave the return value as is. A subsystem, right before going
to destroy a cache, calls kmem_cache_shrink, which returns 1 (slab is
not empty). What is it supposed to do then?

Thanks,
Vladimir
