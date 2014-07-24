Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934687AbaGXWSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:18:31 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35769 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbaGXWSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:18:30 -0400
Date: Thu, 24 Jul 2014 15:18:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch 1/2] mm, slub: fix false-positive lockdep warning in
 free_partial()
In-Reply-To: <20140724122143.GI1725@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1407241517440.19906@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407221550500.9885@chino.kir.corp.google.com> <alpine.DEB.2.02.1407221556330.9885@chino.kir.corp.google.com> <20140724122143.GI1725@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Johannes Weiner wrote:

> > diff --git a/mm/slub.c b/mm/slub.c
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3195,12 +3195,13 @@ static void list_slab_objects(struct kmem_cache *s, struct page *page,
> >  /*
> >   * Attempt to free all partial slabs on a node.
> >   * This is called from kmem_cache_close(). We must be the last thread
> > - * using the cache and therefore we do not need to lock anymore.
> > + * using the cache, but we still have to lock for lockdep's sake.
> >   */
> >  static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
> >  {
> >  	struct page *page, *h;
> >  
> > +	spin_lock_irq(&n->list_lock);
> >  	list_for_each_entry_safe(page, h, &n->partial, lru) {
> >  		if (!page->inuse) {
> >  			__remove_partial(n, page);
> 
> This already uses __remove_partial(), which does not have the lockdep
> assertion.  You even acked the patch that made this change, why add
> the spinlock now?
> 

Yup, thanks.  This was sitting in Pekka's slab/next branch but isn't 
actually needed after commit 1e4dd9461fab ("slub: do not assert not 
having lock in removing freed partial").  Good catch!
