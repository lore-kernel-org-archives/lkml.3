Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaBRRjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:39:41 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53022 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaBRRji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:39:38 -0500
Date: Tue, 18 Feb 2014 18:40:53 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 08/11] vfs: Merge check_submounts_and_drop and
 d_invalidate
Message-ID: <20140218174053.GE4026@tucsk.piliscsaba.szeredi.hu>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87ob28kqks.fsf_-_@xmission.com>
 <87eh34jbsl.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh34jbsl.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 01:39:22PM -0800, Eric W. Biederman wrote:
> 
> Now that d_invalidate is the only caller of check_submounts_and_drop,
> expand check_submounts_and_drop inline in d_invalidate.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/dcache.c            |   55 +++++++++++++++++++----------------------------
>  include/linux/dcache.h |    1 -
>  2 files changed, 22 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 27585b1dd6f1..5b41205cbf33 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -608,32 +608,6 @@ kill_it:
>  }
>  EXPORT_SYMBOL(dput);
>  
> -/**
> - * d_invalidate - invalidate a dentry
> - * @dentry: dentry to invalidate
> - *
> - * Try to invalidate the dentry if it turns out to be
> - * possible. If there are reasons not to delete it
> - * return -EBUSY. On success return 0.
> - *
> - * no dcache lock.
> - */
> - 
> -int d_invalidate(struct dentry * dentry)
> -{
> -	/*
> -	 * If it's already been dropped, return OK.
> -	 */
> -	spin_lock(&dentry->d_lock);
> -	if (d_unhashed(dentry)) {
> -		spin_unlock(&dentry->d_lock);
> -		return 0;
> -	}
> -	spin_unlock(&dentry->d_lock);
> -
> -	return check_submounts_and_drop(dentry);
> -}
> -EXPORT_SYMBOL(d_invalidate);
>  
>  /* This must be called with d_lock held */
>  static inline void __dget_dlock(struct dentry *dentry)
> @@ -1175,7 +1149,7 @@ EXPORT_SYMBOL(have_submounts);
>   * reachable (e.g. NFS can unhash a directory dentry and then the complete
>   * subtree can become unreachable).
>   *
> - * Only one of check_submounts_and_drop() and d_set_mounted() must succeed.  For
> + * Only one of d_invalidate() and d_set_mounted() must succeed.  For
>   * this reason take rename_lock and d_lock on dentry and ancestors.
>   */
>  int d_set_mounted(struct dentry *dentry)
> @@ -1184,7 +1158,7 @@ int d_set_mounted(struct dentry *dentry)
>  	int ret = -ENOENT;
>  	write_seqlock(&rename_lock);
>  	for (p = dentry->d_parent; !IS_ROOT(p); p = p->d_parent) {
> -		/* Need exclusion wrt. check_submounts_and_drop() */
> +		/* Need exclusion wrt. d_invalidate() */
>  		spin_lock(&p->d_lock);
>  		if (unlikely(d_unhashed(p))) {
>  			spin_unlock(&p->d_lock);
> @@ -1400,18 +1374,33 @@ static void check_and_drop(void *_data)
>  }
>  
>  /**
> - * check_submounts_and_drop - detach submounts, prune dcache, and drop
> + * d_invalidate - detach submounts, prune dcache, and drop
> + * @dentry: dentry to invalidate (aka detach, prune and drop)
> + *
> + * Try to invalidate the dentry if it turns out to be
> + * possible. If there are reasons not to delete it
> + * return -EBUSY. On success return 0.
> + *
> + * no dcache lock.
>   *
>   * The final d_drop is done as an atomic operation relative to
>   * rename_lock ensuring there are no races with d_set_mounted.  This
>   * ensures there are no unhashed dentries on the path to a mountpoint.
> - *
> - * @dentry: dentry to detach, prune and drop
>   */
> -int check_submounts_and_drop(struct dentry *dentry)
> +int d_invalidate(struct dentry *dentry)
>  {
>  	int ret = 0;
>  
> +	/*
> +	 * If it's already been dropped, return OK.
> +	 */
> +	spin_lock(&dentry->d_lock);
> +	if (d_unhashed(dentry)) {
> +		spin_unlock(&dentry->d_lock);
> +		return 0;
> +	}
> +	spin_unlock(&dentry->d_lock);
> +
>  	/* Negative dentries can be dropped without further checks */
>  	if (!dentry->d_inode) {
>  		d_drop(dentry);


You can optimize this by including the negative check within the above d_locked
region and calling __d_drop() instead.

> @@ -1445,7 +1434,7 @@ int check_submounts_and_drop(struct dentry *dentry)
>  out:
>  	return ret;
>  }
> -EXPORT_SYMBOL(check_submounts_and_drop);
> +EXPORT_SYMBOL(d_invalidate);
>  
>  /**
>   * __d_alloc	-	allocate a dcache entry
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index bf72e9ac6de0..ae77222c3e86 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -265,7 +265,6 @@ extern void d_prune_aliases(struct inode *);
>  
>  /* test whether we have any submounts in a subdir tree */
>  extern int have_submounts(struct dentry *);
> -extern int check_submounts_and_drop(struct dentry *);
>  
>  /*
>   * This adds the entry to the hash queues.
> -- 
> 1.7.5.4
> 
