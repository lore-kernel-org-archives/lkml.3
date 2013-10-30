Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3J3AJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:09:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab3J3AJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:09:37 -0400
Date: Tue, 29 Oct 2013 20:09:08 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        hch@infradead.org, tj@kernel.org, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 17/23] dm: Refactor for new bio cloning/splitting
Message-ID: <20131030000908.GB2989@redhat.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
 <1383077896-4132-18-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383077896-4132-18-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29 2013 at  4:18pm -0400,
Kent Overstreet <kmo@daterainc.com> wrote:

> We need to convert the dm code to the new bvec_iter primitives which
> respect bi_bvec_done; they also allow us to drastically simplify dm's
> bio splitting code.
> 
> Also kill bio_sector_offset(), dm was the only user and it doesn't make
> much sense anymore.
> 
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: dm-devel@redhat.com
> ---
>  drivers/md/dm-thin.c |   8 ++-
>  drivers/md/dm.c      | 170 ++++++---------------------------------------------
>  fs/bio.c             |  38 ------------
>  include/linux/bio.h  |   1 -
>  4 files changed, 24 insertions(+), 193 deletions(-)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index a654024..1abb4a2 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -611,8 +611,10 @@ static void cell_defer_no_holder(struct thin_c *tc, struct dm_bio_prison_cell *c
>  
>  static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
>  {
> -	if (m->bio)
> +	if (m->bio) {
>  		m->bio->bi_end_io = m->saved_bi_end_io;
> +		atomic_inc(&m->bio->bi_remaining);
> +	}
>  	cell_error(m->tc->pool, m->cell);
>  	list_del(&m->list);
>  	mempool_free(m, m->tc->pool->mapping_pool);
> @@ -626,8 +628,10 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
>  	int r;
>  
>  	bio = m->bio;
> -	if (bio)
> +	if (bio) {
>  		bio->bi_end_io = m->saved_bi_end_io;
> +		atomic_inc(&bio->bi_remaining);
> +	}
>  
>  	if (m->err) {
>  		cell_error(pool, m->cell);

But now that I look closer, the above dm-thin.c hunks belong in:
[PATCH 19/23] block: Generic bio chaining

Seems these changes were mistakenly folded into this 17/23 patch?
