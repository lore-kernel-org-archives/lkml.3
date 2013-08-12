Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab3HLNfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:35:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab3HLNe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:34:57 -0400
Date: Mon, 12 Aug 2013 09:34:50 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk,
        bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH 5/9] nfs: use check_submounts_and_drop()
Message-ID: <20130812093450.678d9fd5@tlielax.poochiereds.net>
In-Reply-To: <1375975490-18673-6-git-send-email-miklos@szeredi.hu>
References: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
	<1375975490-18673-6-git-send-email-miklos@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Aug 2013 17:24:46 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Do have_submounts(), shrink_dcache_parent() and d_drop() atomically.
> 
> check_submounts_and_drop() can deal with negative dentries and
> non-directories as well.
> 
> Non-directories can also be mounted on.  And just like directories we don't
> want these to disappear with invalidation.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>  fs/nfs/dir.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index e474ca2b..7468735 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -1135,14 +1135,13 @@ out_zap_parent:
>  	if (inode && S_ISDIR(inode->i_mode)) {
>  		/* Purge readdir caches. */
>  		nfs_zap_caches(inode);
> -		/* If we have submounts, don't unhash ! */
> -		if (have_submounts(dentry))
> -			goto out_valid;
>  		if (dentry->d_flags & DCACHE_DISCONNECTED)
>  			goto out_valid;
> -		shrink_dcache_parent(dentry);
>  	}
> -	d_drop(dentry);
> +	/* If we have submounts, don't unhash ! */
> +	if (check_submounts_and_drop(dentry) != 0)
> +		goto out_valid;
> +
>  	dput(parent);
>  	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is invalid\n",
>  			__func__, dentry->d_parent->d_name.name,

Acked-by: Jeff Layton <jlayton@redhat.com>
