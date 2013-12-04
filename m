Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab3LDPRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:17:11 -0500
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:49487 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932254Ab3LDPRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:17:09 -0500
Date: Wed, 4 Dec 2013 15:17:08 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Casteyde <casteyde.christian@free.fr>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [patch 2/2] fs: buffer: move allocation failure loop into the
 allocator
In-Reply-To: <20131203180717.94c013d1.akpm@linux-foundation.org>
Message-ID: <00000142be2f1de0-764bb035-adbc-4367-b2b4-bf05498510a6-000000@email.amazonses.com>
References: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org> <1381265890-11333-2-git-send-email-hannes@cmpxchg.org> <20131203165910.54d6b4724a1f3e329af52ac6@linux-foundation.org> <20131204015218.GA19709@lge.com>
 <20131203180717.94c013d1.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Andrew Morton wrote:

> >  	page = alloc_slab_page(alloc_gfp, node, oo);
> >  	if (unlikely(!page)) {
> >  		oo = s->min;
>
> What is the value of s->min?  Please tell me it's zero.

It usually is.

> > @@ -1349,7 +1350,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> >  		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
> >  		int pages = 1 << oo_order(oo);
> >
> > -		kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
> > +		kmemcheck_alloc_shadow(page, oo_order(oo), alloc_gfp, node);
>
> That seems reasonable, assuming kmemcheck can handle the allocation
> failure.
>
>
> Still I dislike this practice of using unnecessarily large allocations.
> What does it gain us?  Slightly improved object packing density.
> Anything else?

The fastpath for slub works only within the bounds of a single slab page.
Therefore a larger frame increases the number of allocation possible from
the fastpath without having to use the slowpath and also reduces the
management overhead in the partial lists.

There is a kernel parameter that can be used to control the maximum order

	slub_max_order

The default is PAGE_ALLOC_COSTLY_ORDER. See also
Documentation/vm/slub.txt.

Booting with slub_max_order=1 will force order 0/1 pages.

