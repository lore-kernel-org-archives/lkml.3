Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaCMUV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:21:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbaCMUVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:21:54 -0400
Date: Thu, 13 Mar 2014 21:21:52 +0100
From: Jan Kara <jack@suse.cz>
To: Roman Pen <r.peniaev@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
Message-ID: <20140313202152.GC504@quack.suse.cz>
References: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 16-02-14 11:54:28, Roman Pen wrote:
> In case of wbc->sync_mode == WB_SYNC_ALL we need to do data integrity write,
> thus mark request as WRITE_SYNC.
  The patch looks good to me and also makes generic mpage code more in sync
with what e.g. XFS or ext4 do in their writepage functions. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> Signed-off-by: Roman Pen <r.peniaev@gmail.com>
> CC: Alexander Viro <viro@zeniv.linux.org.uk>
> CC: linux-fsdevel@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> ---
>  fs/mpage.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/mpage.c b/fs/mpage.c
> index 4979ffa..4e0af5a 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -462,6 +462,7 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
>  	struct buffer_head map_bh;
>  	loff_t i_size = i_size_read(inode);
>  	int ret = 0;
> +	int wr = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
>  
>  	if (page_has_buffers(page)) {
>  		struct buffer_head *head = page_buffers(page);
> @@ -570,7 +571,7 @@ page_is_mapped:
>  	 * This page will go to BIO.  Do we need to send this BIO off first?
>  	 */
>  	if (bio && mpd->last_block_in_bio != blocks[0] - 1)
> -		bio = mpage_bio_submit(WRITE, bio);
> +		bio = mpage_bio_submit(wr, bio);
>  
>  alloc_new:
>  	if (bio == NULL) {
> @@ -587,7 +588,7 @@ alloc_new:
>  	 */
>  	length = first_unmapped << blkbits;
>  	if (bio_add_page(bio, page, length, 0) < length) {
> -		bio = mpage_bio_submit(WRITE, bio);
> +		bio = mpage_bio_submit(wr, bio);
>  		goto alloc_new;
>  	}
>  
> @@ -620,7 +621,7 @@ alloc_new:
>  	set_page_writeback(page);
>  	unlock_page(page);
>  	if (boundary || (first_unmapped != blocks_per_page)) {
> -		bio = mpage_bio_submit(WRITE, bio);
> +		bio = mpage_bio_submit(wr, bio);
>  		if (boundary_block) {
>  			write_boundary_block(boundary_bdev,
>  					boundary_block, 1 << blkbits);
> @@ -632,7 +633,7 @@ alloc_new:
>  
>  confused:
>  	if (bio)
> -		bio = mpage_bio_submit(WRITE, bio);
> +		bio = mpage_bio_submit(wr, bio);
>  
>  	if (mpd->use_writepage) {
>  		ret = mapping->a_ops->writepage(page, wbc);
> @@ -688,8 +689,11 @@ mpage_writepages(struct address_space *mapping,
>  		};
>  
>  		ret = write_cache_pages(mapping, wbc, __mpage_writepage, &mpd);
> -		if (mpd.bio)
> -			mpage_bio_submit(WRITE, mpd.bio);
> +		if (mpd.bio) {
> +			int wr = (wbc->sync_mode == WB_SYNC_ALL ?
> +				  WRITE_SYNC : WRITE);
> +			mpage_bio_submit(wr, mpd.bio);
> +		}
>  	}
>  	blk_finish_plug(&plug);
>  	return ret;
> @@ -706,8 +710,11 @@ int mpage_writepage(struct page *page, get_block_t get_block,
>  		.use_writepage = 0,
>  	};
>  	int ret = __mpage_writepage(page, wbc, &mpd);
> -	if (mpd.bio)
> -		mpage_bio_submit(WRITE, mpd.bio);
> +	if (mpd.bio) {
> +		int wr = (wbc->sync_mode == WB_SYNC_ALL ?
> +			  WRITE_SYNC : WRITE);
> +		mpage_bio_submit(wr, mpd.bio);
> +	}
>  	return ret;
>  }
>  EXPORT_SYMBOL(mpage_writepage);
> -- 
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
