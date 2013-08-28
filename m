Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3H1Gfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:35:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54979 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab3H1Gfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:35:37 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-21-521d9a37fcdf
Date: Wed, 28 Aug 2013 15:36:06 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/16] slab: overloading the RCU head over the LRU for
 RCU free
Message-ID: <20130828063605.GD6795@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1377161065-30552-8-git-send-email-iamjoonsoo.kim@lge.com>
 <20130827160604.5ca4161c@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827160604.5ca4161c@lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 27, 2013 at 04:06:04PM -0600, Jonathan Corbet wrote:
> On Thu, 22 Aug 2013 17:44:16 +0900
> Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > With build-time size checking, we can overload the RCU head over the LRU
> > of struct page to free pages of a slab in rcu context. This really help to
> > implement to overload the struct slab over the struct page and this
> > eventually reduce memory usage and cache footprint of the SLAB.
> 
> So I'm taking a look at this, trying to figure out what's actually in
> struct page while this stuff is going on without my head exploding.  A
> couple of questions come to mind.
> 
> >  static void kmem_rcu_free(struct rcu_head *head)
> >  {
> > -	struct slab_rcu *slab_rcu = (struct slab_rcu *)head;
> > -	struct kmem_cache *cachep = slab_rcu->page->slab_cache;
> > +	struct kmem_cache *cachep;
> > +	struct page *page;
> >  
> > -	kmem_freepages(cachep, slab_rcu->page);
> > +	page = container_of((struct list_head *)head, struct page, lru);
> > +	cachep = page->slab_cache;
> > +
> > +	kmem_freepages(cachep, page);
> >  }
> 
> Is there a reason why you don't add the rcu_head structure as another field
> in that union alongside lru rather than playing casting games here?  This
> stuff is hard enough to follow as it is without adding that into the mix.

One reason is that the SLUB is already playing this games :)
And the struct page shouldn't be enlarged unintentionally when the size of
the rcu_head is changed.

> 
> The other question I had is: this field also overlays slab_page.  I guess
> that, by the time RCU comes into play, there will be no further use of
> slab_page?  It might be nice to document that somewhere if it's the case.

Ah..... I did a mistake in previous patch (06/16). We should leave an object
on slab_page until rcu finish the work since rcu_head is overloaded over it.

If I remove that patch, this patch has a problem you mentioned. But I think
that a fix is simple. Moving the slab_page to another union field in the
struct slab prio to this patch solves the problem you mentioned.

Thanks for pointing that!

