Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaKFPB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:01:59 -0500
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:42107 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbaKFPBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:01:55 -0500
Date: Thu, 6 Nov 2014 09:01:52 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 8/8] slab: recharge slab pages to the allocating
 memory cgroup
In-Reply-To: <20141106091749.GB4839@esperanza>
Message-ID: <alpine.DEB.2.11.1411060858530.4639@gentwo.org>
References: <cover.1415046910.git.vdavydov@parallels.com> <fe7c55a7ff9bb8a1ddff0256f5404196c10bfd08.1415046910.git.vdavydov@parallels.com> <alpine.DEB.2.11.1411051242410.28485@gentwo.org> <20141106091749.GB4839@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014, Vladimir Davydov wrote:

> I call memcg_kmem_recharge_slab only on alloc path. Free path isn't
> touched. The overhead added is one function call. The function only
> reads and compares two pointers under RCU most of time. This is
> comparable to the overhead introduced by memcg_kmem_get_cache, which is
> called in slab_alloc/slab_alloc_node earlier.

Right maybe remove those too? Things seem to be accumulating in the hot
path which is bad. There is a slow path where these things can be added
and also a page based even slower path for statistics keeping.

The approach in SLUB is to do accounting on a slab page basis. Also memory
policies are applied at page granularity not object granularity.

> Anyways, if you think this is unacceptable, I don't mind dropping the
> whole patch set and thinking more on how to fix this per-memcg caches
> trickery. What do you think?

Maybe its possible to just use slab page accounting instead of object
accounting? Reduces overhead significantly. There may be some fuzz here
with occasional object accounted in the wrong way (which is similar to how
memory policies and other methods work) but it has been done before and
works ok.

