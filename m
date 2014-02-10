Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaBJQYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:24:08 -0500
Received: from kanga.kvack.org ([205.233.56.17]:55935 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbaBJQYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:24:05 -0500
Date: Mon, 10 Feb 2014 11:24:02 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Rakesh Pandit <rakesh@tuxera.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: add aio_migratepage_helper to get rid of duplicate code
Message-ID: <20140210162402.GB26657@kvack.org>
References: <20140210115255.GA3399@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210115255.GA3399@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 01:52:56PM +0200, Rakesh Pandit wrote:

You're missing a commit message here providing justification for the changes 
submitted.  Why is this change a good thing?  Did it fix any bugs?

		-ben

> Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
> ---
>  fs/aio.c | 55 +++++++++++++++++++++++--------------------------------
>  1 file changed, 23 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index d3d55dc..20d690a 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -278,32 +278,46 @@ static int aio_set_page_dirty(struct page *page)
>  }
>  
>  #if IS_ENABLED(CONFIG_MIGRATION)
> -static int aio_migratepage(struct address_space *mapping, struct page *new,
> -			struct page *old, enum migrate_mode mode)
> +static int aio_migratepage_helper(struct address_space *mapping,
> +			struct page *new, struct page *old, bool move)
>  {
>  	struct kioctx *ctx;
>  	unsigned long flags;
> -	int rc;
> -
> -	rc = 0;
> +	int rc = 0;
>  
> -	/* Make sure the old page hasn't already been changed */
> +	/* We can potentially race against kioctx teardown here.  Use the
> +	 * address_space's private data lock to protect the mapping's
> +	 * private_data.
> +	 */
>  	spin_lock(&mapping->private_lock);
>  	ctx = mapping->private_data;
>  	if (ctx) {
>  		pgoff_t idx;
>  		spin_lock_irqsave(&ctx->completion_lock, flags);
> +		if (move)
> +			migrate_page_copy(new, old);
>  		idx = old->index;
>  		if (idx < (pgoff_t)ctx->nr_pages) {
>  			if (ctx->ring_pages[idx] != old)
>  				rc = -EAGAIN;
> +			else if (move)
> +				ctx->ring_pages[idx] = new;
>  		} else
>  			rc = -EINVAL;
>  		spin_unlock_irqrestore(&ctx->completion_lock, flags);
>  	} else
> -		rc = -EINVAL;
> +		rc = move ? -EBUSY : -EINVAL;
>  	spin_unlock(&mapping->private_lock);
> +	return rc;
> +}
>  
> +static int aio_migratepage(struct address_space *mapping, struct page *new,
> +			struct page *old, enum migrate_mode mode)
> +{
> +	int rc = 0;
> +
> +	/* Make sure the old page hasn't already been changed */
> +	rc = aio_migratepage_helper(mapping, new, old, false);
>  	if (rc != 0)
>  		return rc;
>  
> @@ -317,31 +331,8 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
>  		return rc;
>  	}
>  
> -	/* We can potentially race against kioctx teardown here.  Use the
> -	 * address_space's private data lock to protect the mapping's
> -	 * private_data.
> -	 */
> -	spin_lock(&mapping->private_lock);
> -	ctx = mapping->private_data;
> -	if (ctx) {
> -		pgoff_t idx;
> -		spin_lock_irqsave(&ctx->completion_lock, flags);
> -		migrate_page_copy(new, old);
> -		idx = old->index;
> -		if (idx < (pgoff_t)ctx->nr_pages) {
> -			/* And only do the move if things haven't changed */
> -			if (ctx->ring_pages[idx] == old)
> -				ctx->ring_pages[idx] = new;
> -			else
> -				rc = -EAGAIN;
> -		} else
> -			rc = -EINVAL;
> -		spin_unlock_irqrestore(&ctx->completion_lock, flags);
> -	} else
> -		rc = -EBUSY;
> -	spin_unlock(&mapping->private_lock);
> -
> -	if (rc == MIGRATEPAGE_SUCCESS)
> +	rc = aio_migratepage_helper(mapping, new, old, true);
> +	if (rc == 0)
>  		put_page(old);
>  	else
>  		put_page(new);
> -- 
> 1.8.3.1

-- 
"Thought is the essence of where you are now."
