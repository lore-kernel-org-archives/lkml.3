Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab3IYVuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:50:07 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:58641 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3IYVuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:50:04 -0400
Date: Wed, 25 Sep 2013 14:49:10 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Zach Brown <zab@redhat.com>
Cc: hch@infradead.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] block: Introduce bio_for_each_page()
Message-ID: <20130925214910.GA8993@kmo-pixel>
References: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
 <1380140564-9030-2-git-send-email-kmo@daterainc.com>
 <20130925211702.GH30372@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925211702.GH30372@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 02:17:02PM -0700, Zach Brown wrote:
> >  void zero_fill_bio(struct bio *bio)
> >  {
> > -	unsigned long flags;
> >  	struct bio_vec bv;
> >  	struct bvec_iter iter;
> >  
> > -	bio_for_each_segment(bv, bio, iter) {
> > +#if defined(CONFIG_HIGHMEM) || defined(ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
> > +	bio_for_each_page(bv, bio, iter) {
> > +		unsigned long flags;
> >  		char *data = bvec_kmap_irq(&bv, &flags);
> >  		memset(data, 0, bv.bv_len);
> >  		flush_dcache_page(bv.bv_page);
> >  		bvec_kunmap_irq(data, &flags);
> >  	}
> > +#else
> > +	bio_for_each_segment(bv, bio, iter)
> > +		memset(page_address(bv.bv_page) + bv.bv_offset,
> > +		       0, bv.bv_len);
> > +#endif
> 
> This looks pretty sketchy.  I'd expect this to be doable with one loop
> and that bvec_kmap_irq() and flush_dcache_page() would fall back to
> page_address() and nops when they're not needed.
> 
> Where did this come from?

It's just that if we need the kmap or the flush_dcache_page we have to
process the bio one 4k page at a time - if not, we can process 64k (or
whatever) bvecs all at once. That doesn't just save us memcpy calls, we
can also avoid all the machinery in bio_for_each_page() for chunking up
large bvecs into single page bvecs.

I can definitely think of better ways to do this, but I figured I'd wait
and see if other code ends up wanting to switch between
bio_for_each_page() and bio_for_each_segment() and why.
