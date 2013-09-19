Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3IVVr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:47:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3IVVrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:47:55 -0400
Date: Thu, 19 Sep 2013 16:22:38 +0200
From: Jan Kara <jack@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Did immutable bvecs accidentally break stable page writes?
Message-ID: <20130919142238.GB20140@quack.suse.cz>
References: <20130919093250.GS22421@suse.de>
 <20130919094030.GT22421@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919094030.GT22421@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 19-09-13 10:40:30, Mel Gorman wrote:
> On Thu, Sep 19, 2013 at 10:32:50AM +0100, Mel Gorman wrote:
> > Commit ffecfd1a (block: optionally snapshot page contents to provide
> > stable pages during write) uses bounce buffers for stable page writes in
> > jbd and ext3. Simplistically, __blk_queue_bounce takes a force parameter
> > that is used when pages must be snapshot.
> > 
> > Commit 6bc454d1 (bounce: Refactor __blk_queue_bounce to not use
> > bi_io_vec) refactored __blk_queue_bounce and now the start of the
> > function looks like this
> > 
> > static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
> > 			       mempool_t *pool, int force)
> > {
> > 	struct bio *bio;
> > 	int rw = bio_data_dir(*bio_orig);
> > 	struct bio_vec *to, *from;
> > 	unsigned i;
> > 
> > 	bio_for_each_segment(from, *bio_orig, i)
> > 		if (page_to_pfn(from->bv_page) > queue_bounce_pfn(q))
> > 			goto bounce;
> > 
> > 	return;
> > bounce:
> > 	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, fs_bio_set);
> > 
> > 	bio_for_each_segment_all(to, bio, i) {
> > 		struct page *page = to->bv_page;
> > 
> > 		if (page_to_pfn(page) <= queue_bounce_pfn(q) && !force)
> > 			continue;
> > 
> > Note that the first bio_for_each_segment is completely ignoring the
> > force parameter and hence snapshotting. This is particularly problematic
> > for ext3 which forces the use of MS_SNAP_STABLE.
> > 
> 
> Which of course is no longer a problem for ext3 after commit 71368511
> ("mm: make snapshotting pages for stable writes a per-bio operation). The
> folly of looking at a commit in isolation! I'm still curious why the force
> parameter is ignored when stable writes are required though.
  This really looks like a bug to me. Since stable pages are currently
required only for drives supporting DIF/DIX noone has likely noticed. But
still we should fix that.

								Honza

PS: As an unrelated note first 8 digits of the commit SHA are not unique
for that commit. Time to switch to longer prefixes? :)
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
