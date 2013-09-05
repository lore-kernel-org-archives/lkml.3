Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935786Ab3IELS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:18:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60166 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935623Ab3IELS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:18:57 -0400
Date: Thu, 5 Sep 2013 12:18:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, David Howells <dhowells@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 04/11] vfs: check unlinked ancestors before mount
Message-ID: <20130905111852.GP13318@ZenIV.linux.org.uk>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
 <1378374284-1484-5-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378374284-1484-5-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 11:44:37AM +0200, Miklos Szeredi wrote:
> +static bool __has_unlinked_ancestor(struct dentry *dentry)
> +{
> +	struct dentry *this;
> +
> +	for (this = dentry; !IS_ROOT(this); this = this->d_parent) {
> +		int is_unhashed;
> +
> +		/* Need exclusion wrt. check_submounts_and_drop() */
> +		spin_lock(&this->d_lock);
> +		is_unhashed = d_unhashed(this);
> +		spin_unlock(&this->d_lock);
> +
> +		if (is_unhashed)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +/*
> + * Called by mount code to check if the mountpoint is reachable (e.g. NFS can
> + * unhash a directory dentry and then the complete subtree can become
> + * unreachable).
> + */
> +bool has_unlinked_ancestor(struct dentry *dentry)
> +{
> +	bool found;
> +
> +	/* Need exclusion wrt. check_submounts_and_drop() */
> +	write_seqlock(&rename_lock);
> +	found = __has_unlinked_ancestor(dentry);
> +	write_sequnlock(&rename_lock);
> +
> +	return found;
> +}
> +
>  /*
>   * Search the dentry child list of the specified parent,
>   * and move any unused dentries to the end of the unused
> diff --git a/fs/internal.h b/fs/internal.h
> index 7c5f01c..d232355 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -126,6 +126,7 @@ extern int invalidate_inodes(struct super_block *, bool);
>   * dcache.c
>   */
>  extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
> +extern bool has_unlinked_ancestor(struct dentry *dentry);
>  
>  /*
>   * read_write.c
> diff --git a/fs/namespace.c b/fs/namespace.c
> index a45ba4f..91b1c39 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -634,6 +634,15 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
>  	}
>  	dentry->d_flags |= DCACHE_MOUNTED;
>  	spin_unlock(&dentry->d_lock);
> +
> +	if (has_unlinked_ancestor(dentry)) {
> +		spin_lock(&dentry->d_lock);
> +		dentry->d_flags &= ~DCACHE_MOUNTED;
> +		spin_unlock(&dentry->d_lock);
> +		kfree(mp);
> +		return ERR_PTR(-ENOENT);
> +	}

Something's really odd with locking here.  You are take d_lock, do one
check, set flag, drop d_lock, grab rename_lock, do another check (taking
and dropping d_lock in process), and, in case that check fails, grab
d_lock again to clear the flag.

At the very least it's a massive overkill.  Just grab rename_lock, then
d_lock, then do the damn check and set the flag only on success.  Moreover,
with rename_lock held, do you need d_lock on ancestors to mess with in
has_unlinked_ancestor()?
