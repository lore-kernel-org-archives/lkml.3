Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaBRX7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:59:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaBRX7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:59:46 -0500
Date: Tue, 18 Feb 2014 15:59:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Pen <r.peniaev@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
Message-Id: <20140218155945.ee2e22e07fa3b4f242b16a7f@linux-foundation.org>
In-Reply-To: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
References: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Feb 2014 11:54:28 +0900 Roman Pen <r.peniaev@gmail.com> wrote:

> In case of wbc->sync_mode == WB_SYNC_ALL we need to do data integrity write,
> thus mark request as WRITE_SYNC.

gargh, the documentation for this stuff is useless.

What do REQ_SYNC and REQ_NOIDLE actually *do*?

For mpage writes, REQ_NOIDLE appears to be incorrect - we very much
expect that there will be more writes and that they will be contiguous
with this one.  But we won't be waiting on this write before submitting
more writes, so perhaps REQ_NOIDLE is at least harmless.

I dunno about REQ_SYNC - it requires delving into the bowels of CFQ
and we shouldn't need to do that.

Jens.  Help.  How is a poor kernel reader supposed to work this out?

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

