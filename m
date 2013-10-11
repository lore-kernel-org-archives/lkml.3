Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3JKWL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:11:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab3JKWL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:11:27 -0400
Date: Fri, 11 Oct 2013 15:11:33 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 16/22] dm: Refactor for new bio cloning/splitting
Message-ID: <20131011221133.GK28572@kmo>
References: <1375912471-5106-17-git-send-email-kmo@daterainc.com>
 <20130928045909.GA19745@redhat.com>
 <20131003031738.GA27418@kmo-pixel>
 <20131003032320.GA15322@redhat.com>
 <20131003214525.GA12183@kmo-pixel>
 <20131003225009.GA24173@redhat.com>
 <20131004170732.GA30728@redhat.com>
 <20131007001410.GA14264@redhat.com>
 <20131011041314.GB28572@kmo>
 <20131011211641.GA19775@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011211641.GA19775@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 05:16:42PM -0400, Mike Snitzer wrote:
> On Fri, Oct 11 2013 at 12:13am -0400,
> Kent Overstreet <kmo@daterainc.com> wrote:
> 
> > On Sun, Oct 06, 2013 at 08:14:10PM -0400, Mike Snitzer wrote:
> > > 
> > > Please fold this fix into your for-jens branch, thanks.  (Could be that
> > > by the time Jens takes your immutable biovec changes we'll need to
> > > rebase but at least it won't slip through the cracks).
> > 
> > Thanks! I knew that bio chaining patch was going to cause a few issues
> > like this, but it seems to useful to pass up. Anything else come up/any
> > comments?
> 
> I'm wondering if there might be a cleaner way to hide the quirky nature
> of the bio chaining with saved/restored bi_end_io.  Joe Thornber
> implemented utility wrappers local to dm-cache, see:
> http://people.redhat.com/msnitzer/patches/upstream/dm-cache-for-v3.13/dm-cache-utils-for-hooking-bios.patch
> 
> would be natural to elevate something like this to the block layer and
> then bury the quirk of needing to bump bi_remaining when the bi_end_io
> is restored in unhook_bio().

Hmm, that might not be a bad idea. I suppose there are a decent number
of places scattered around (like the bio integrity code) that are simple
enough that there's no point in cloning the bio, they just want to hook
into into the completion...

If I get time I may grep around and see what sort of consolidation
that'd enable.

> Aside from that idea, your immutable biovec changes look sane to me.  I
> like how much was able to be removed from DM core.  I don't see any
> remaining problems that stand out.  Feel free to add the following to
> your DM patches in the series:
> 
>  Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Great, thanks!

> However, I did collect various style nits in the DM code during my
> review.   I'd like to see these changes applied:

I'll fold them in :)

> 
> Author: Mike Snitzer <snitzer@redhat.com>
> Date:   Fri Sep 27 18:14:38 2013 -0400
> 
>     dm: style nits and comment for immutable biovec changes
> ---
>  drivers/md/dm-cache-target.c |   16 ++++++++++------
>  drivers/md/dm-crypt.c        |    8 ++------
>  drivers/md/dm-io.c           |    3 +--
>  drivers/md/dm-snap.c         |    8 ++++----
>  drivers/md/dm-thin.c         |    3 +--
>  drivers/md/dm-verity.c       |    3 +--
>  drivers/md/dm.c              |    6 ++----
>  include/linux/dm-io.h        |    2 +-
>  8 files changed, 22 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index a9acec6..1ccbfff 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -571,13 +571,13 @@ static void remap_to_cache(struct cache *cache, struct bio *bio,
>  
>  	bio->bi_bdev = cache->cache_dev->bdev;
>  	if (!block_size_is_power_of_two(cache))
> -		bio->bi_iter.bi_sector = (from_cblock(cblock) *
> -					  cache->sectors_per_block) +
> -				sector_div(bi_sector, cache->sectors_per_block);
> +		bio->bi_iter.bi_sector =
> +			(from_cblock(cblock) * cache->sectors_per_block) +
> +			sector_div(bi_sector, cache->sectors_per_block);
>  	else
> -		bio->bi_iter.bi_sector = (from_cblock(cblock) <<
> -					  cache->sectors_per_block_shift) |
> -				(bi_sector & (cache->sectors_per_block - 1));
> +		bio->bi_iter.bi_sector =
> +			(from_cblock(cblock) << cache->sectors_per_block_shift) |
> +			(bi_sector & (cache->sectors_per_block - 1));
>  }
>  
>  static void check_if_tick_bio_needed(struct cache *cache, struct bio *bio)
> @@ -666,6 +666,10 @@ static void writethrough_endio(struct bio *bio, int err)
>  	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
>  	bio->bi_end_io = pb->saved_bi_end_io;
>  
> +	/*
> +	 * Must bump bi_remaining to allow bio to complete with
> +	 * restored bi_end_io.
> +	 */
>  	atomic_inc(&bio->bi_remaining);
>  
>  	if (err) {
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index e0b902f..4db7e48 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -648,12 +648,10 @@ static void crypt_convert_init(struct crypt_config *cc,
>  {
>  	ctx->bio_in = bio_in;
>  	ctx->bio_out = bio_out;
> -
>  	if (bio_in)
>  		ctx->iter_in = bio_in->bi_iter;
>  	if (bio_out)
>  		ctx->iter_out = bio_out->bi_iter;
> -
>  	ctx->cc_sector = sector + cc->iv_offset;
>  	init_completion(&ctx->restart);
>  }
> @@ -752,8 +750,7 @@ static int crypt_convert(struct crypt_config *cc,
>  
>  	atomic_set(&ctx->cc_pending, 1);
>  
> -	while (ctx->iter_in.bi_size &&
> -	       ctx->iter_out.bi_size) {
> +	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
>  
>  		crypt_alloc_req(cc, ctx);
>  
> @@ -1676,8 +1673,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  		return DM_MAPIO_REMAPPED;
>  	}
>  
> -	io = crypt_io_alloc(cc, bio,
> -			    dm_target_offset(ti, bio->bi_iter.bi_sector));
> +	io = crypt_io_alloc(cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
>  
>  	if (bio_data_dir(io->base_bio) == READ) {
>  		if (kcryptd_io_read(io, GFP_NOWAIT))
> diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
> index 9cc1f3a..b2b8a10 100644
> --- a/drivers/md/dm-io.c
> +++ b/drivers/md/dm-io.c
> @@ -307,8 +307,7 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
>  					  dm_sector_div_up(remaining, (PAGE_SIZE >> SECTOR_SHIFT)));
>  
>  		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
> -		bio->bi_iter.bi_sector = where->sector +
> -			(where->count - remaining);
> +		bio->bi_iter.bi_sector = where->sector + (where->count - remaining);
>  		bio->bi_bdev = where->bdev;
>  		bio->bi_end_io = endio;
>  		store_io_and_region_in_bio(bio, io, region);
> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> index 2e55bda..b7a5053 100644
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -1563,10 +1563,10 @@ static void remap_exception(struct dm_snapshot *s, struct dm_exception *e,
>  {
>  	bio->bi_bdev = s->cow->bdev;
>  	bio->bi_iter.bi_sector = chunk_to_sector(s->store,
> -					 dm_chunk_number(e->new_chunk) +
> -					 (chunk - e->old_chunk)) +
> -					 (bio->bi_iter.bi_sector &
> -					  s->store->chunk_mask);
> +						 dm_chunk_number(e->new_chunk) +
> +						 (chunk - e->old_chunk)) +
> +		                                 (bio->bi_iter.bi_sector &
> +						  s->store->chunk_mask);
>  }
>  
>  static int snapshot_map(struct dm_target *ti, struct bio *bio)
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 6742927..a654024 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -1255,8 +1255,7 @@ static void process_bio_read_only(struct thin_c *tc, struct bio *bio)
>  	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
>  	switch (r) {
>  	case 0:
> -		if (lookup_result.shared &&
> -		    (rw == WRITE) && bio->bi_iter.bi_size)
> +		if (lookup_result.shared && (rw == WRITE) && bio->bi_iter.bi_size)
>  			bio_io_error(bio);
>  		else {
>  			inc_all_io_entry(tc->pool, bio);
> diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
> index 64d829a..ac35e95 100644
> --- a/drivers/md/dm-verity.c
> +++ b/drivers/md/dm-verity.c
> @@ -496,8 +496,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
>  	io->v = v;
>  	io->orig_bi_end_io = bio->bi_end_io;
>  	io->orig_bi_private = bio->bi_private;
> -	io->block = bio->bi_iter.bi_sector >>
> -		(v->data_dev_block_bits - SECTOR_SHIFT);
> +	io->block = bio->bi_iter.bi_sector >> (v->data_dev_block_bits - SECTOR_SHIFT);
>  	io->n_blocks = bio->bi_iter.bi_size >> v->data_dev_block_bits;
>  
>  	bio->bi_end_io = verity_end_io;
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index a396137..5846801 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -539,8 +539,7 @@ static void start_io_acct(struct dm_io *io)
>  		atomic_inc_return(&md->pending[rw]));
>  
>  	if (unlikely(dm_stats_used(&md->stats)))
> -		dm_stats_account_io(&md->stats, bio->bi_rw,
> -				    bio->bi_iter.bi_sector,
> +		dm_stats_account_io(&md->stats, bio->bi_rw, bio->bi_iter.bi_sector,
>  				    bio_sectors(bio), false, 0, &io->stats_aux);
>  }
>  
> @@ -558,8 +557,7 @@ static void end_io_acct(struct dm_io *io)
>  	part_stat_unlock();
>  
>  	if (unlikely(dm_stats_used(&md->stats)))
> -		dm_stats_account_io(&md->stats, bio->bi_rw,
> -				    bio->bi_iter.bi_sector,
> +		dm_stats_account_io(&md->stats, bio->bi_rw, bio->bi_iter.bi_sector,
>  				    bio_sectors(bio), true, duration, &io->stats_aux);
>  
>  	/*
> diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
> index 6cf1f62..a68cbe5 100644
> --- a/include/linux/dm-io.h
> +++ b/include/linux/dm-io.h
> @@ -29,7 +29,7 @@ typedef void (*io_notify_fn)(unsigned long error, void *context);
>  
>  enum dm_io_mem_type {
>  	DM_IO_PAGE_LIST,/* Page list */
> -	DM_IO_BIO,
> +	DM_IO_BIO,	/* Bio vector */
>  	DM_IO_VMA,	/* Virtual memory area */
>  	DM_IO_KMEM,	/* Kernel memory */
>  };
