Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3GYJfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:35:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab3GYJfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:35:37 -0400
Date: Thu, 25 Jul 2013 11:35:31 +0200
From: Jan Kara <jack@suse.cz>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v2] lib: Make radix_tree_node_alloc() work correctly
 within interrupt
Message-ID: <20130725093531.GA9388@quack.suse.cz>
References: <1374617060-25805-1-git-send-email-jack@suse.cz>
 <51EEFFAD.701@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EEFFAD.701@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-07-13 15:11:57, Randy Dunlap wrote:
> On 07/23/13 15:04, Jan Kara wrote:
> s/sence/sense/ please.
  Thanks. I keep getting this wrong... I've updated the patch locally but I
won't resend it just for this spellcheck fix (yet).

								Honza

> > diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> > index e796429..7811ed3 100644
> > --- a/lib/radix-tree.c
> > +++ b/lib/radix-tree.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/string.h>
> >  #include <linux/bitops.h>
> >  #include <linux/rcupdate.h>
> > +#include <linux/hardirq.h>		/* in_interrupt() */
> >  
> >  
> >  #ifdef __KERNEL__
> > @@ -207,7 +208,12 @@ radix_tree_node_alloc(struct radix_tree_root *root)
> >  	struct radix_tree_node *ret = NULL;
> >  	gfp_t gfp_mask = root_gfp_mask(root);
> >  
> > -	if (!(gfp_mask & __GFP_WAIT)) {
> > +	/*
> > +	 * Preload code isn't irq safe and it doesn't make sence to use
> 
> 	                                                   sense
> 
> > +	 * preloading in the interrupt anyway as all the allocations have to
> > +	 * be atomic. So just do normal allocation when in interrupt.
> > +	 */
> > +	if (!(gfp_mask & __GFP_WAIT) && !in_interrupt()) {
> >  		struct radix_tree_preload *rtp;
> >  
> >  		/*
> > @@ -264,7 +270,7 @@ radix_tree_node_free(struct radix_tree_node *node)
> >   * To make use of this facility, the radix tree must be initialised without
> >   * __GFP_WAIT being passed to INIT_RADIX_TREE().
> >   */
> > -int radix_tree_preload(gfp_t gfp_mask)
> > +static int __radix_tree_preload(gfp_t gfp_mask)
> >  {
> >  	struct radix_tree_preload *rtp;
> >  	struct radix_tree_node *node;
> > @@ -288,9 +294,40 @@ int radix_tree_preload(gfp_t gfp_mask)
> >  out:
> >  	return ret;
> >  }
> > +
> > +/*
> > + * Load up this CPU's radix_tree_node buffer with sufficient objects to
> > + * ensure that the addition of a single element in the tree cannot fail.  On
> > + * success, return zero, with preemption disabled.  On error, return -ENOMEM
> > + * with preemption not disabled.
> > + *
> > + * To make use of this facility, the radix tree must be initialised without
> > + * __GFP_WAIT being passed to INIT_RADIX_TREE().
> > + */
> > +int radix_tree_preload(gfp_t gfp_mask)
> > +{
> > +	/* Warn on non-sensical use... */
> > +	WARN_ON_ONCE(!(gfp_mask & __GFP_WAIT));
> > +	return __radix_tree_preload(gfp_mask);
> > +}
> >  EXPORT_SYMBOL(radix_tree_preload);
> >  
> >  /*
> > + * The same as above function, except we don't guarantee preloading happens.
> > + * We do it, if we decide it helps. On success, return zero with preemption
> > + * disabled. On error, return -ENOMEM with preemption not disabled.
> > + */
> > +int radix_tree_maybe_preload(gfp_t gfp_mask)
> > +{
> > +	if (gfp_mask & __GFP_WAIT)
> > +		return __radix_tree_preload(gfp_mask);
> > +	/* Preloading doesn't help anything with this gfp mask, skip it */
> > +	preempt_disable();
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(radix_tree_maybe_preload);
> > +
> > +/*
> >   *	Return the maximum key which can be store into a
> 
> 	                                    stored
> 
> >   *	radix tree with height HEIGHT.
> >   */
> 
> -- 
> ~Randy
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
