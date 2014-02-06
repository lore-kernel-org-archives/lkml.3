Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaBFBGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:06:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:61771 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753529AbaBFBGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:06:34 -0500
Date: Wed, 5 Feb 2014 20:06:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] slub: Do not assert not having lock in removing freed
 partial
Message-ID: <20140205200632.021dc613@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1402051644520.5159@chino.kir.corp.google.com>
References: <20140205192404.550da7dc@gandalf.local.home>
	<alpine.DEB.2.02.1402051644520.5159@chino.kir.corp.google.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014 16:46:43 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:


> > +/*
> > + * The difference between remove_partial and remove_freed_partial
> > + * is that remove_freed_partial happens only on a a freed slab
> 
> Duplicate "a" there.

oops.

> 
> > + * that should not have anyone accessing it, and thus does not
> > + * require the n->list_lock.
> > + */
> > +static inline void remove_freed_partial(struct kmem_cache_node *n,
> > +					struct page *page)
> > +{
> > +	__remove_partial(n, page);
> >  }
> >  
> >  /*
> > @@ -3195,7 +3212,7 @@ static void free_partial(struct kmem_cac
> >  
> >  	list_for_each_entry_safe(page, h, &n->partial, lru) {
> >  		if (!page->inuse) {
> > -			remove_partial(n, page);
> > +			remove_freed_partial(n, page);
> >  			discard_slab(s, page);
> >  		} else {
> >  			list_slab_objects(s, page,
> 
> We'll want to do something similiar for the add_partial() called from
> early_kmem_cache_node_alloc(), right?  It had the added n->list_lock for 
> the same reason and is done during early init where nobody else can be 
> referencing a kmem_cache_node.
> 
> It would probably be better to define these in terms of "partial slabs 
> that cannot have anyone else accessing it" rather than "freed slabs".

Perhaps then we just use the __remove_partial() and __add_partial()
that does not do the checks. That's common practice to use a "__" to
denote that it's special and usually doesn't require locking.

-- Steve
