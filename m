Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3J3AUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:20:05 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56681 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3J3AUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:20:03 -0400
Date: Tue, 29 Oct 2013 17:19:59 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        hch@infradead.org, tj@kernel.org, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 17/23] dm: Refactor for new bio cloning/splitting
Message-ID: <20131030001959.GB27129@kmo>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
 <1383077896-4132-18-git-send-email-kmo@daterainc.com>
 <20131030000908.GB2989@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030000908.GB2989@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 08:09:08PM -0400, Mike Snitzer wrote:
> On Tue, Oct 29 2013 at  4:18pm -0400,
> Kent Overstreet <kmo@daterainc.com> wrote:
> 
> > We need to convert the dm code to the new bvec_iter primitives which
> > respect bi_bvec_done; they also allow us to drastically simplify dm's
> > bio splitting code.
> > 
> > Also kill bio_sector_offset(), dm was the only user and it doesn't make
> > much sense anymore.
> > 
> > Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Alasdair Kergon <agk@redhat.com>
> > Cc: dm-devel@redhat.com
> > ---
> >  drivers/md/dm-thin.c |   8 ++-
> >  drivers/md/dm.c      | 170 ++++++---------------------------------------------
> >  fs/bio.c             |  38 ------------
> >  include/linux/bio.h  |   1 -
> >  4 files changed, 24 insertions(+), 193 deletions(-)
> > 
> > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > index a654024..1abb4a2 100644
> > --- a/drivers/md/dm-thin.c
> > +++ b/drivers/md/dm-thin.c
> > @@ -611,8 +611,10 @@ static void cell_defer_no_holder(struct thin_c *tc, struct dm_bio_prison_cell *c
> >  
> >  static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
> >  {
> > -	if (m->bio)
> > +	if (m->bio) {
> >  		m->bio->bi_end_io = m->saved_bi_end_io;
> > +		atomic_inc(&m->bio->bi_remaining);
> > +	}
> >  	cell_error(m->tc->pool, m->cell);
> >  	list_del(&m->list);
> >  	mempool_free(m, m->tc->pool->mapping_pool);
> > @@ -626,8 +628,10 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
> >  	int r;
> >  
> >  	bio = m->bio;
> > -	if (bio)
> > +	if (bio) {
> >  		bio->bi_end_io = m->saved_bi_end_io;
> > +		atomic_inc(&bio->bi_remaining);
> > +	}
> >  
> >  	if (m->err) {
> >  		cell_error(pool, m->cell);
> 
> But now that I look closer, the above dm-thin.c hunks belong in:
> [PATCH 19/23] block: Generic bio chaining
> 
> Seems these changes were mistakenly folded into this 17/23 patch?

...Whoops, fixed. Here's the new versions if you want to take a look:

http://evilpiepirate.org/git/linux-bcache.git/log/?h=for-jens
http://evilpiepirate.org/git/linux-bcache.git/commit/?h=for-jens&id=74f0f2084f88bb38403ca80bb98976f8219f9262
