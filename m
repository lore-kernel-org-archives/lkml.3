Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab3JRIkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 04:40:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab3JRIjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 04:39:43 -0400
Date: Fri, 18 Oct 2013 10:39:40 +0200
From: Jan Kara <jack@suse.cz>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Check for NULL return values from allocating
 functions
Message-ID: <20131018083940.GA18733@quack.suse.cz>
References: <1382021374-8285-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382021374-8285-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 17-10-13 07:49:34, Laura Abbott wrote:
> A security audit revealed that several functions were not checking
> return value of allocation functions. These allocations may return
> NULL which may lead to NULL pointer dereferences and crashes or
> security concerns. Fix this by properly checking the return value
> and handling the error appropriately.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>  fs/buffer.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 4d74335..b53f863 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1561,6 +1561,9 @@ void create_empty_buffers(struct page *page,
>  	struct buffer_head *bh, *head, *tail;
>  
>  	head = alloc_page_buffers(page, blocksize, 1);
> +	if (head == NULL)
> +		return;
> +
  This cannot happen. alloc_page_buffers() is called with retry == 1 and
thus it will loop until it gets the memory it wants.

>  	bh = head;
>  	do {
>  		bh->b_state |= b_state;
> @@ -3008,16 +3011,18 @@ int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
>  	BUG_ON(buffer_unwritten(bh));
>  
>  	/*
> -	 * Only clear out a write error when rewriting
> -	 */
> -	if (test_set_buffer_req(bh) && (rw & WRITE))
> -		clear_buffer_write_io_error(bh);
> -
> -	/*
>  	 * from here on down, it's all bio -- do the initial mapping,
>  	 * submit_bio -> generic_make_request may further map this bio around
>  	 */
>  	bio = bio_alloc(GFP_NOIO, 1);
> +	if (bio == NULL)
> +		return -ENOMEM;
  And the same is true here. If the gfp mask has __GFP_WAIT set (and
GFP_NOIO does have that), mempool_alloc() loops until it gets the memory.
So I agree we might be missing some details in documentation but the code
is correct.

								Honza

> +
> +	/*
> +	 * Only clear out a write error when rewriting
> +	 */
> +	if (test_set_buffer_req(bh) && (rw & WRITE))
> +		clear_buffer_write_io_error(bh);
>  
>  	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
>  	bio->bi_bdev = bh->b_bdev;
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
