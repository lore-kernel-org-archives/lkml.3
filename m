Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaIJTRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:17:37 -0400
Received: from fieldses.org ([174.143.236.118]:39424 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaIJTRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:17:35 -0400
Date: Wed, 10 Sep 2014 15:17:34 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jlayton@primarydata.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 08/12] nfs: convert lock handling to use
 file_lock_context
Message-ID: <20140910191734.GD4210@fieldses.org>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
 <1410359330-27564-9-git-send-email-jlayton@primarydata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410359330-27564-9-git-send-email-jlayton@primarydata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:28:46AM -0400, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@primarydata.com>
> ---
>  fs/nfs/delegation.c | 37 +++++++++++++++++++++----------------
>  fs/nfs/nfs4state.c  | 24 +++++++++++++++---------
>  fs/nfs/pagelist.c   |  3 ++-
>  fs/nfs/write.c      | 39 +++++++++++++++++++++++++++++++++------
>  4 files changed, 71 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
> index 5853f53db732..22c6eed9bb5b 100644
> --- a/fs/nfs/delegation.c
> +++ b/fs/nfs/delegation.c
> @@ -85,25 +85,30 @@ static int nfs_delegation_claim_locks(struct nfs_open_context *ctx, struct nfs4_
>  {
>  	struct inode *inode = state->inode;
>  	struct file_lock *fl;
> +	struct file_lock_context *flctx = inode->i_flctx;
> +	struct list_head *list;
>  	int status = 0;
>  
> -	if (inode->i_flock == NULL)
> -		goto out;
> -
> -	/* Protect inode->i_flock using the i_lock */
> -	spin_lock(&inode->i_lock);
> -	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
> -		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
> -			continue;
> -		if (nfs_file_open_context(fl->fl_file) != ctx)
> -			continue;
> -		spin_unlock(&inode->i_lock);
> -		status = nfs4_lock_delegation_recall(fl, state, stateid);
> -		if (status < 0)
> -			goto out;
> -		spin_lock(&inode->i_lock);
> +	flctx = inode->i_flctx;
> +	if (flctx) {
> +		list = &flctx->flc_posix;
> +		spin_lock(&flctx->flc_lock);
> +restart:
> +		list_for_each_entry(fl, list, fl_list) {
> +			if (nfs_file_open_context(fl->fl_file) != ctx)
> +				continue;
> +			spin_unlock(&flctx->flc_lock);
> +			status = nfs4_lock_delegation_recall(fl, state, stateid);
> +			if (status < 0)
> +				goto out;
> +			spin_lock(&flctx->flc_lock);
> +		}
> +		if (list == &flctx->flc_posix) {
> +			list = &flctx->flc_flock;
> +			goto restart;
> +		}
> +		spin_unlock(&flctx->flc_lock);
>  	}
> -	spin_unlock(&inode->i_lock);
>  out:
>  	return status;
>  }
> diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
> index a043f618cd5a..2899a0f26293 100644
> --- a/fs/nfs/nfs4state.c
> +++ b/fs/nfs/nfs4state.c
> @@ -1377,21 +1377,23 @@ static int nfs4_reclaim_locks(struct nfs4_state *state, const struct nfs4_state_
>  	struct inode *inode = state->inode;
>  	struct nfs_inode *nfsi = NFS_I(inode);
>  	struct file_lock *fl;
> +	struct file_lock_context *flctx = inode->i_flctx;
> +	struct list_head *list;
>  	int status = 0;
>  
> -	if (inode->i_flock == NULL)
> +	if (!flctx)
>  		return 0;
>  
> +	list = &flctx->flc_posix;
> +
>  	/* Guard against delegation returns and new lock/unlock calls */
>  	down_write(&nfsi->rwsem);
> -	/* Protect inode->i_flock using the BKL */
> -	spin_lock(&inode->i_lock);
> -	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
> -		if (!(fl->fl_flags & (FL_POSIX|FL_FLOCK)))
> -			continue;
> +	spin_lock(&flctx->flc_lock);
> +restart:
> +	list_for_each_entry(fl, list, fl_list) {
>  		if (nfs_file_open_context(fl->fl_file)->state != state)
>  			continue;
> -		spin_unlock(&inode->i_lock);
> +		spin_unlock(&flctx->flc_lock);
>  		status = ops->recover_lock(state, fl);
>  		switch (status) {
>  			case 0:
> @@ -1418,9 +1420,13 @@ static int nfs4_reclaim_locks(struct nfs4_state *state, const struct nfs4_state_
>  				/* kill_proc(fl->fl_pid, SIGLOST, 1); */
>  				status = 0;
>  		}
> -		spin_lock(&inode->i_lock);
> +		spin_lock(&flctx->flc_lock);
>  	}
> -	spin_unlock(&inode->i_lock);
> +	if (list == &flctx->flc_posix) {
> +		list = &flctx->flc_flock;
> +		goto restart;
> +	}
> +	spin_unlock(&flctx->flc_lock);
>  out:
>  	up_write(&nfsi->rwsem);
>  	return status;
> diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
> index ba491926df5f..4df8d8755026 100644
> --- a/fs/nfs/pagelist.c
> +++ b/fs/nfs/pagelist.c
> @@ -782,7 +782,8 @@ static bool nfs_can_coalesce_requests(struct nfs_page *prev,
>  	if (prev) {
>  		if (!nfs_match_open_context(req->wb_context, prev->wb_context))
>  			return false;
> -		if (req->wb_context->dentry->d_inode->i_flock != NULL &&
> +		if (req->wb_context->dentry->d_inode->i_flctx != NULL &&
> +		    !list_empty(&req->wb_context->dentry->d_inode->i_flctx->flc_posix) &&
>  		    !nfs_match_lock_context(req->wb_lock_context,
>  					    prev->wb_lock_context))
>  			return false;
> diff --git a/fs/nfs/write.c b/fs/nfs/write.c
> index e3b5cf28bdc5..02b8777f8f2f 100644
> --- a/fs/nfs/write.c
> +++ b/fs/nfs/write.c
> @@ -1128,7 +1128,8 @@ int nfs_flush_incompatible(struct file *file, struct page *page)
>  		do_flush = req->wb_page != page || req->wb_context != ctx;
>  		/* for now, flush if more than 1 request in page_group */
>  		do_flush |= req->wb_this_page != req;
> -		if (l_ctx && ctx->dentry->d_inode->i_flock != NULL) {
> +		if (l_ctx && ctx->dentry->d_inode->i_flctx &&
> +		    !list_empty(&ctx->dentry->d_inode->i_flctx->flc_posix)) {
>  			do_flush |= l_ctx->lockowner.l_owner != current->files
>  				|| l_ctx->lockowner.l_pid != current->tgid;
>  		}
> @@ -1189,6 +1190,12 @@ out:
>  	return PageUptodate(page) != 0;
>  }
>  
> +static bool
> +is_whole_file_wrlock(struct file_lock *fl)
> +{
> +	return fl->fl_start == 0 && fl->fl_end == OFFSET_MAX && fl->fl_type == F_WRLCK;
> +}
> +
>  /* If we know the page is up to date, and we're not using byte range locks (or
>   * if we have the whole file locked for writing), it may be more efficient to
>   * extend the write to cover the entire page in order to avoid fragmentation
> @@ -1199,17 +1206,37 @@ out:
>   */
>  static int nfs_can_extend_write(struct file *file, struct page *page, struct inode *inode)
>  {
> +	int ret;
> +	struct file_lock_context *flctx = inode->i_flctx;
> +	struct file_lock *fl;
> +
>  	if (file->f_flags & O_DSYNC)
>  		return 0;
>  	if (!nfs_write_pageuptodate(page, inode))
>  		return 0;
>  	if (NFS_PROTO(inode)->have_delegation(inode, FMODE_WRITE))
>  		return 1;
> -	if (inode->i_flock == NULL || (inode->i_flock->fl_start == 0 &&
> -			inode->i_flock->fl_end == OFFSET_MAX &&
> -			inode->i_flock->fl_type != F_RDLCK))

Doesn't the existing code already have a bug?  Without the i_lock
inode->i_flock could turn NULL partyway through 

There's a bug in the existing code, isn't there?  Without holding the
i_lock, couldn't inode->i_flock turn NULL partway through this
conditional and cause NULL dereferences?  (Or, more bizarrely, the
checks of those various fields could end up being for different locks.)

> -		return 1;
> -	return 0;
> +	/* no lock context == no locks */
> +	if (!flctx)
> +		return 0;
> +
> +	/* if lists are empty then there are no locks */
> +	if (list_empty(&flctx->flc_posix) && list_empty(&flctx->flc_flock))
> +		return 0;
> +
> +	ret = 0;
> +	/* Check to see if there are whole file write locks */
> +	spin_lock(&flctx->flc_lock);
> +	fl = list_first_entry(&flctx->flc_posix, struct file_lock, fl_list);
> +	if (is_whole_file_wrlock(fl)) {
> +		ret = 1;
> +	} else {
> +		fl = list_first_entry(&flctx->flc_flock, struct file_lock, fl_list);
> +		if (is_whole_file_wrlock(fl))
> +			ret = 1;
> +	}
> +	spin_unlock(&flctx->flc_lock);
> +	return ret;

Kind of pity we're turning 5 lines of code into 20 in the name of
simplification.  Could be slightly pithier:

	ret = is_whole_file_wrlock(fl);
	if (!ret) {
		fl = ...
		ret = is_whole_file_wrlock(fl);
	}

But, whatever, looks OK to me.

--b.

>  }
>  
>  /*
> -- 
> 1.9.3
> 
