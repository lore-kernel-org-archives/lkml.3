Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935750Ab3DIN17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:27:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427Ab3DIN15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:27:57 -0400
Date: Tue, 9 Apr 2013 15:27:56 +0200
From: Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH v3 09/18] reiserfs: use ->invalidatepage() length
 argument
Message-ID: <20130409132756.GE13672@quack.suse.cz>
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
 <1365498867-27782-10-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365498867-27782-10-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-04-13 11:14:18, Lukas Czerner wrote:
> ->invalidatepage() aop now accepts range to invalidate so we can make
> use of it in reiserfs_invalidatepage()
  Hum, reiserfs is probably never going to support punch hole. So shouldn't
we rather WARN and return without doing anything if stop !=
PAGE_CACHE_SIZE?

								Honza
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: reiserfs-devel@vger.kernel.org
> ---
>  fs/reiserfs/inode.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
> index 808e02e..e963164 100644
> --- a/fs/reiserfs/inode.c
> +++ b/fs/reiserfs/inode.c
> @@ -2975,11 +2975,13 @@ static void reiserfs_invalidatepage(struct page *page, unsigned int offset,
>  	struct buffer_head *head, *bh, *next;
>  	struct inode *inode = page->mapping->host;
>  	unsigned int curr_off = 0;
> +	unsigned int stop = offset + length;
> +	int partial_page = (offset || length < PAGE_CACHE_SIZE);
>  	int ret = 1;
>  
>  	BUG_ON(!PageLocked(page));
>  
> -	if (offset == 0)
> +	if (!partial_page)
>  		ClearPageChecked(page);
>  
>  	if (!page_has_buffers(page))
> @@ -2991,6 +2993,9 @@ static void reiserfs_invalidatepage(struct page *page, unsigned int offset,
>  		unsigned int next_off = curr_off + bh->b_size;
>  		next = bh->b_this_page;
>  
> +		if (next_off > stop)
> +			goto out;
> +
>  		/*
>  		 * is this block fully invalidated?
>  		 */
> @@ -3009,7 +3014,7 @@ static void reiserfs_invalidatepage(struct page *page, unsigned int offset,
>  	 * The get_block cached value has been unconditionally invalidated,
>  	 * so real IO is not possible anymore.
>  	 */
> -	if (!offset && ret) {
> +	if (!partial_page && ret) {
>  		ret = try_to_release_page(page, 0);
>  		/* maybe should BUG_ON(!ret); - neilb */
>  	}
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
