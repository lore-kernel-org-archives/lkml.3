Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3IYWsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:48:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab3IYWsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:48:20 -0400
Date: Wed, 25 Sep 2013 15:47:55 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: hch@infradead.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] block: Introduce bio_for_each_page()
Message-ID: <20130925224755.GJ30372@lenny.home.zabbo.net>
References: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
 <1380140564-9030-2-git-send-email-kmo@daterainc.com>
 <20130925211702.GH30372@lenny.home.zabbo.net>
 <20130925214910.GA8993@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925214910.GA8993@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 02:49:10PM -0700, Kent Overstreet wrote:
> On Wed, Sep 25, 2013 at 02:17:02PM -0700, Zach Brown wrote:
> > >  void zero_fill_bio(struct bio *bio)
> > >  {
> > > -	unsigned long flags;
> > >  	struct bio_vec bv;
> > >  	struct bvec_iter iter;
> > >  
> > > -	bio_for_each_segment(bv, bio, iter) {
> > > +#if defined(CONFIG_HIGHMEM) || defined(ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
> > > +	bio_for_each_page(bv, bio, iter) {
> > > +		unsigned long flags;
> > >  		char *data = bvec_kmap_irq(&bv, &flags);
> > >  		memset(data, 0, bv.bv_len);
> > >  		flush_dcache_page(bv.bv_page);
> > >  		bvec_kunmap_irq(data, &flags);
> > >  	}
> > > +#else
> > > +	bio_for_each_segment(bv, bio, iter)
> > > +		memset(page_address(bv.bv_page) + bv.bv_offset,
> > > +		       0, bv.bv_len);
> > > +#endif
> > 
> > This looks pretty sketchy.  I'd expect this to be doable with one loop
> > and that bvec_kmap_irq() and flush_dcache_page() would fall back to
> > page_address() and nops when they're not needed.
> > 
> > Where did this come from?
> 
> It's just that if we need the kmap or the flush_dcache_page we have to
> process the bio one 4k page at a time - if not, we can process 64k (or
> whatever) bvecs all at once. That doesn't just save us memcpy calls, we
> can also avoid all the machinery in bio_for_each_page() for chunking up
> large bvecs into single page bvecs.

Understood.  A comment would probably be wise as that ifdefery is going
to raise all the eyebrows.

- z
