Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbaDGTfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:35:01 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:48143 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754695AbaDGTe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:34:58 -0400
Date: Mon, 7 Apr 2014 14:34:56 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Sasha Levin <sasha.levin@oracle.com>
cc: Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: slub: gpf in deactivate_slab
In-Reply-To: <53401F56.5090507@oracle.com>
Message-ID: <alpine.DEB.2.10.1404071429530.4447@nuc>
References: <53208A87.2040907@oracle.com> <5331A6C3.2000303@oracle.com> <20140325165247.GA7519@dhcp22.suse.cz> <alpine.DEB.2.10.1403251205140.24534@nuc> <5331B9C8.7080106@oracle.com> <alpine.DEB.2.10.1403251308590.26471@nuc> <53321CB6.5050706@oracle.com>
 <alpine.DEB.2.10.1403261042360.2057@nuc> <53401F56.5090507@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Apr 2014, Sasha Levin wrote:

> [ 1035.193166] Call Trace:
> [ 1035.193166] ? init_object (mm/slub.c:679)
> [ 1035.193166] setup_object.isra.34 (mm/slub.c:1071 mm/slub.c:1399)
> [ 1035.193166] new_slab (mm/slub.c:286 mm/slub.c:1439)
> [ 1035.193166] __slab_alloc (mm/slub.c:2203 mm/slub.c:2363)
> [ 1035.193166] ? kmem_cache_alloc (mm/slub.c:2469 mm/slub.c:2480 mm/slub.c:2485)


Ok so the story here is that slub decided it needed a new slab and
requested memory from the page allocator.

setup_object() tries to write to the page which fails.

Could the page allocator have delivered a reference to a page struct that
creates an invalid address?

The code that fails is:

 page = allocate_slab(s,
                flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
        if (!page)
                goto out;

--- So we got a page from teh page allocator

        order = compound_order(page);
        inc_slabs_node(s, page_to_nid(page), page->objects);
        memcg_bind_pages(s, order);
        page->slab_cache = s;
        __SetPageSlab(page);

-- Writing to the page struct works.

        if (page->pfmemalloc)
                SetPageSlabPfmemalloc(page);

        start = page_address(page);

        if (unlikely(s->flags & SLAB_POISON))
                memset(start, POISON_INUSE, PAGE_SIZE << order);


--- This should have triggered since we write to the page but maybe this
	slab has a ctor set and therefore no poisining is possible.

        last = start;
        for_each_object(p, s, start, page->objects) {
                setup_object(s, page, last);

*** This is where the write access to the page fails.

                set_freepointer(s, last, p);
                last = p;
        }
        setup_object(s, page, last);

