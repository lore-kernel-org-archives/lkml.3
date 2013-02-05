Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab3BECik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 21:38:40 -0500
Received: from a194-210.smtp-out.amazonses.com ([199.255.194.210]:62942 "EHLO
	a194-210.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525Ab3BECii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 21:38:38 -0500
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2013 21:38:37 EST
Date: Tue, 5 Feb 2013 02:29:03 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Stephen Warren <swarren@wwwdotorg.org>
cc: James Hogan <james.hogan@imgtec.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Subject: Re: next-20130204 - bisected slab problem to "slab: Common constants
 for kmalloc boundaries"
In-Reply-To: <51100E79.9080101@wwwdotorg.org>
Message-ID: <0000013ca82f61e2-592bc561-c5ae-4193-8007-bef820f2734d-000000@email.amazonses.com>
References: <510FE051.7080107@imgtec.com> <51100E79.9080101@wwwdotorg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, Stephen Warren wrote:

> Here, if defined(ARCH_DMA_MINALIGN), then KMALLOC_MIN_SIZE isn't
> relative-to/derived-from KMALLOC_SHIFT_LOW, so the two may become
> inconsistent.

Right. And kmalloc_index() will therefore return KMALLOC_SHIFT_LOW which
will dereference a NULL pointer since only the later cache pointers are
populated. KMALLOC_SHIFT_LOW needs to be set correctly.

> > diff --git a/mm/slub.c b/mm/slub.c
> > index ba2ca53..d0f72ee 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2775,7 +2775,7 @@ init_kmem_cache_node(struct kmem_cache_node *n)
> >  static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
> >  {
> >  	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
> > -			SLUB_PAGE_SHIFT * sizeof(struct kmem_cache_cpu));
> > +			KMALLOC_SHIFT_HIGH * sizeof(struct kmem_cache_cpu));
>
> Should that also be (KMALLOC_SHIFT_HIGH + 1)?

That is already a pretty fuzzy test. The nr of kmem_cache_cpu allocated is
lower than KMALLOC_SHIFT_HIGH since several index positions will not be
occupied.
