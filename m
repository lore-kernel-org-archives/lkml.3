Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbaGAHqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:46:20 -0400
Received: from mx2.parallels.com ([199.115.105.18]:57049 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaGAHqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:46:18 -0400
Date: Tue, 1 Jul 2014 11:46:02 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@gentwo.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, <akpm@linux-foundation.org>,
        <rientjes@google.com>, <penberg@kernel.org>, <hannes@cmpxchg.org>,
        <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v3 8/8] slab: do not keep free objects/slabs on dead
 memcg caches
Message-ID: <20140701074602.GC7365@esperanza>
References: <cover.1402602126.git.vdavydov@parallels.com>
 <a985aec824cd35df381692fca83f7a8debc80305.1402602126.git.vdavydov@parallels.com>
 <20140624073840.GC4836@js1304-P5Q-DELUXE>
 <20140625134545.GB22340@esperanza>
 <20140627060534.GC9511@js1304-P5Q-DELUXE>
 <alpine.DEB.2.11.1406301048070.19422@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406301048070.19422@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 10:49:03AM -0500, Christoph Lameter wrote:
> On Fri, 27 Jun 2014, Joonsoo Kim wrote:
> 
> > Christoph,
> > Is it tolerable result for large scale system? Or do we need to find
> > another solution?
> 
> 
> The overhead is pretty intense but then this is a rare event I guess?

Yes, provided cgroups are created/destroyed rarely.

> It seems that it is much easier on the code and much faster to do the
> periodic reaping. Why not simply go with that?

A bad thing about the periodic reaping is that the time it may take
isn't predictable, because the number of dead caches is, in fact, only
limited by the amount of RAM.

We can have hundreds, if not thousands, copies of dcaches/icaches left
from cgroups destroyed some time ago. The dead caches will hang around
until memory pressure evicts all the objects they host, which may take
quite long on systems with a lot of memory.

With periodic reaping, we will have to iterate over all dead caches
trying to drain per cpu/node arrays each time, which might therefore
result in slowing down the whole system unexpectedly.

I'm not quite sure if such slowdowns are really a threat though.
Actually, cache_reap will only do something (take locks, drain
arrays/lists) only if there are free objects on the cache. Otherwise it
will, in fact, only check cpu_cache->avail, alien->avail, shared->avail,
and node->free_list, which shouldn't take much time, should it?

Thanks.
