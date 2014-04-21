Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaDUMTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:19:00 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59353 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaDUMSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:18:53 -0400
Date: Mon, 21 Apr 2014 08:18:40 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Glauber Costa <glommer@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>, devel@openvz.org
Subject: Re: [RFC] how should we deal with dead memcgs' kmem caches?
Message-ID: <20140421121840.GA11622@cmpxchg.org>
References: <5353A3E3.4020302@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5353A3E3.4020302@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 02:39:31PM +0400, Vladimir Davydov wrote:
> * Way #2 - reap caches periodically or on vmpressure *
> 
> We can remove the async work scheduling from kmem_cache_free completely,
> and instead walk over all dead kmem caches either periodically or on
> vmpressure to shrink and destroy those of them that become empty.
> 
> That is what I had in mind when submitting the patch set titled "kmemcg:
> simplify work-flow":
> 	https://lkml.org/lkml/2014/4/18/42
> 
> Pros: easy to implement
> Cons: instead of being destroyed asap, dead caches will hang around
> until some point in time or, even worse, memory pressure condition.

This would continue to pin css after cgroup destruction indefinitely,
or at least for an arbitrary amount of time.  To reduce the waste from
such pinning, we currently have to tear down other parts of the memcg
optimistically from css_offline(), which is called before the last
reference disappears and out of hierarchy order, making the teardown
unnecessarily complicated and error prone.

So I think "easy to implement" is misleading.  What we really care
about is "easy to maintain", and this basically excludes any async
schemes.

As far as synchronous cache teardown goes, I think everything that
introduces object accounting into the slab hotpaths will also be a
tough sell.

Personally, I would prefer the cache merging, where remaining child
slab pages are moved to the parent's cache on cgroup destruction.
