Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab3HMMJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:09:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757830Ab3HMMJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:09:19 -0400
Message-ID: <520A2114.1040203@redhat.com>
Date: Tue, 13 Aug 2013 08:05:40 -0400
From: Brian Foster <bfoster@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maxim Patlasov <MPatlasov@parallels.com>
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, devel@openvz.org, xemul@parallels.com
Subject: Re: [PATCH 2/2] fuse: wait for writeback in fuse_file_fallocate()
References: <20130812163739.10366.64896.stgit@maximpc.sw.ru> <20130812163935.10366.88320.stgit@maximpc.sw.ru>
In-Reply-To: <20130812163935.10366.88320.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 12:39 PM, Maxim Patlasov wrote:
> The patch fixes a race between mmap-ed write and fallocate(PUNCH_HOLE):
> 
> 1) An user makes a page dirty via mmap-ed write.
> 2) The user performs fallocate(2) with mode == PUNCH_HOLE|KEEP_SIZE
>    and <offset, size> covering the page.
> 3) Before truncate_pagecache_range call from fuse_file_fallocate,
>    the page goes to write-back. The page is fully processed by fuse_writepage
>    (including end_page_writeback on the page), but fuse_flush_writepages did
>    nothing because fi->writectr < 0.
> 4) truncate_pagecache_range is called and fuse_file_fallocate is finishing
>    by calling fuse_release_nowrite. The latter triggers processing queued
>    write-back request which will write stale date to the hole soon.
> 
> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
> ---

Hi Maxim,

Nice catch and description, one minor concern...

>  fs/fuse/file.c |   53 ++++++++++++++++++++++++++++++++++++++++++++---------
>  1 files changed, 44 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index d1715b3..2b18c4b 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -344,6 +344,31 @@ static bool fuse_page_is_writeback(struct inode *inode, pgoff_t index)
>  	return found;
>  }
>  
> +static bool fuse_range_is_writeback(struct inode *inode, pgoff_t idx_from,
> +				    pgoff_t idx_to)
> +{
> +	struct fuse_conn *fc = get_fuse_conn(inode);
> +	struct fuse_inode *fi = get_fuse_inode(inode);
> +	struct fuse_req *req;
> +	bool found = false;
> +
> +	spin_lock(&fc->lock);
> +	list_for_each_entry(req, &fi->writepages, writepages_entry) {
> +		pgoff_t curr_index;
> +
> +		BUG_ON(req->inode != inode);
> +		curr_index = req->misc.write.in.offset >> PAGE_CACHE_SHIFT;
> +		if (!(idx_from >= curr_index + req->num_pages ||
> +		      idx_to < curr_index)) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	spin_unlock(&fc->lock);
> +
> +	return found;
> +}
> +
>  /*
>   * Wait for page writeback to be completed.
>   *
> @@ -358,6 +383,19 @@ static int fuse_wait_on_page_writeback(struct inode *inode, pgoff_t index)
>  	return 0;
>  }
>  
> +static void fuse_wait_on_writeback(struct inode *inode, pgoff_t start,
> +				   size_t bytes)
> +{
> +	struct fuse_inode *fi = get_fuse_inode(inode);
> +	pgoff_t idx_from, idx_to;
> +
> +	idx_from = start >> PAGE_CACHE_SHIFT;
> +	idx_to = (start + bytes - 1) >> PAGE_CACHE_SHIFT;
> +
> +	wait_event(fi->page_waitq,
> +		   !fuse_range_is_writeback(inode, idx_from, idx_to));
> +}
> +
>  static int fuse_flush(struct file *file, fl_owner_t id)
>  {
>  	struct inode *inode = file_inode(file);
> @@ -2478,8 +2516,11 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
>  
>  	if (lock_inode) {
>  		mutex_lock(&inode->i_mutex);
> -		if (mode & FALLOC_FL_PUNCH_HOLE)
> -			fuse_set_nowrite(inode);
> +		if (mode & FALLOC_FL_PUNCH_HOLE) {
> +			truncate_pagecache_range(inode, offset,
> +						 offset + length - 1);
> +			fuse_wait_on_writeback(inode, offset, length);
> +		}

If this happens to be the first attempt on an fs that doesn't support
fallocate, we'll return -EOPNOTSUPP after having already punched out the
data in the pagecache. What about replacing the nowrite logic with a
flush (and still followed by your new writeback wait logic) rather than
moving the pagecache truncate?

Brian

>  	}
>  
>  	req = fuse_get_req_nopages(fc);
> @@ -2508,17 +2549,11 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
>  	if (!(mode & FALLOC_FL_KEEP_SIZE))
>  		fuse_write_update_size(inode, offset + length);
>  
> -	if (mode & FALLOC_FL_PUNCH_HOLE)
> -		truncate_pagecache_range(inode, offset, offset + length - 1);
> -
>  	fuse_invalidate_attr(inode);
>  
>  out:
> -	if (lock_inode) {
> -		if (mode & FALLOC_FL_PUNCH_HOLE)
> -			fuse_release_nowrite(inode);
> +	if (lock_inode)
>  		mutex_unlock(&inode->i_mutex);
> -	}
>  
>  	return err;
>  }
> 

