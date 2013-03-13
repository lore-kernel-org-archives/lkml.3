Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab3CMTpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:45:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27102 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3CMTpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:45:41 -0400
Date: Wed, 13 Mar 2013 12:44:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuge <shugelinux@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, Kevin <kevin@allwinneretch.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] bounce:fix bug, avoid to flush dcache on slab page from
 jbd2.
Message-ID: <20130313194429.GE5313@blackbox.djwong.org>
References: <5139DB90.5090302@gmail.com>
 <20130312153221.0d26fe5599d4885e51bb0c7c@linux-foundation.org>
 <20130313011020.GA5313@blackbox.djwong.org>
 <20130313085021.GA29730@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130313085021.GA29730@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 09:50:21AM +0100, Jan Kara wrote:
> On Tue 12-03-13 18:10:20, Darrick J. Wong wrote:
> > On Tue, Mar 12, 2013 at 03:32:21PM -0700, Andrew Morton wrote:
> > > On Fri, 08 Mar 2013 20:37:36 +0800 Shuge <shugelinux@gmail.com> wrote:
> > > 
> > > > The bounce accept slab pages from jbd2, and flush dcache on them.
> > > > When enabling VM_DEBUG, it will tigger VM_BUG_ON in page_mapping().
> > > > So, check PageSlab to avoid it in __blk_queue_bounce().
> > > > 
> > > > Bug URL: http://lkml.org/lkml/2013/3/7/56
> > > > 
> > > > ...
> > > >
> > > > --- a/mm/bounce.c
> > > > +++ b/mm/bounce.c
> > > > @@ -214,7 +214,8 @@ static void __blk_queue_bounce(struct request_queue 
> > > > *q, struct bio **bio_orig,
> > > >   		if (rw == WRITE) {
> > > >   			char *vto, *vfrom;
> > > >   -			flush_dcache_page(from->bv_page);
> > > > +			if (unlikely(!PageSlab(from->bv_page)))
> > > > +				flush_dcache_page(from->bv_page);
> > > >   			vto = page_address(to->bv_page) + to->bv_offset;
> > > >   			vfrom = kmap(from->bv_page) + from->bv_offset;
> > > >   			memcpy(vto, vfrom, to->bv_len);
> > > 
> > > I guess this is triggered by Catalin's f1a0c4aa0937975b ("arm64: Cache
> > > maintenance routines"), which added a page_mapping() call to arm64's
> > > arch/arm64/mm/flush.c:flush_dcache_page().
> > > 
> > > What's happening is that jbd2 is using kmalloc() to allocate buffer_head
> > > data.  That gets submitted down the BIO layer and __blk_queue_bounce()
> > > calls flush_dcache_page() which in the arm64 case calls page_mapping()
> > > and page_mapping() does VM_BUG_ON(PageSlab) and splat.
> > > 
> > > The unusual thing about all of this is that the payload for some disk
> > > IO is coming from kmalloc, rather than being a user page.  It's oddball
> > > but we've done this for ages and should continue to support it.
> > > 
> > > 
> > > Now, the page from kmalloc() cannot be in highmem, so why did the
> > > bounce code decide to bounce it?
> > > 
> > > __blk_queue_bounce() does
> > > 
> > > 		/*
> > > 		 * is destination page below bounce pfn?
> > > 		 */
> > > 		if (page_to_pfn(page) <= queue_bounce_pfn(q) && !force)
> > > 			continue;
> > > 
> > > and `force' comes from must_snapshot_stable_pages().  But
> > > must_snapshot_stable_pages() must have returned false, because if it
> > > had returned true then it would have been must_snapshot_stable_pages()
> > > which went BUG, because must_snapshot_stable_pages() calls page_mapping().
> > > 
> > > So my tentative diagosis is that arm64 is fishy.  A page which was
> > > allocated via jbd2_alloc(GFP_NOFS)->kmem_cache_alloc() ended up being
> > > above arm64's queue_bounce_pfn().  Can you please do a bit of
> > > investigation to work out if this is what is happening?  Find out why
> > > __blk_queue_bounce() decided to bounce a page which shouldn't have been
> > > bounced?
> > 
> > That sure is strange.  I didn't see any obvious reasons why we'd end up with a
> > kmalloc above queue_bounce_pfn().  But then I don't have any arm64s either.
> > 
> > > This is all terribly fragile :( afaict if someone sets
> > > bdi_cap_stable_pages_required() against that jbd2 queue, we're going to
> > > hit that BUG_ON() again, via must_snapshot_stable_pages()'s
> > > page_mapping() call.  (Darrick, this means you ;))
> > 
> > Wheeee.  You're right, we shouldn't be calling page_mapping on slab pages.
> > We can keep walking the bio segments to find a non-slab page that can tell us
> > MS_SNAP_STABLE is set, since we probably won't need the bounce buffer anyway.
> > 
> > How does something like this look?  (+ the patch above)
>   Umm, this won't quite work. We can have a bio which has just PageSlab
> page attached and so you won't be able to get to the superblock. Heh, isn't
> the whole page_mapping() thing in must_snapshot_stable_pages() wrong? When we
> do direct IO, these pages come directly from userspace and hell knows where
> they come from. Definitely their page_mapping() doesn't give us anything
> useful... Sorry for not realizing this earlier when reviewing the patch.
> 
> ... remembering why we need to get to sb and why ext3 needs this ... So
> maybe a better solution would be to have a bio flag meaning that pages need
> bouncing? And we would set it from filesystems that need it - in case of
> ext3 only writeback of data from kjournald actually needs to bounce the
> pages. Thoughts?

What about dirty pages that don't result in journal transactions?  I think
ext3_sync_file() eventually calls ext3_ordered_writepage, which then calls
__block_write_full_page, which in turn calls submit_bh().

--D
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
