Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaBKPby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:31:54 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36729 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaBKPbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:31:52 -0500
Date: Tue, 11 Feb 2014 16:32:55 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 07/13] vfs: lock_two_nondirectories: allow directory args
Message-ID: <20140211153255.GA8204@tucsk.piliscsaba.szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <1391791751-2533-8-git-send-email-miklos@szeredi.hu>
 <20140207211644.GB8801@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207211644.GB8801@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 04:16:44PM -0500, J. Bruce Fields wrote:
> 
> Nit: I find the conditionals here a little complicated.
> 
> Would something like this be clearer? (Untested):
> 
> 	if (inode1 > inode2)
> 		swap(inode1, inode2);
> 
> 	if (inode1 && !S_ISDIR(inode1->i_mode))
> 		mutex_lock(&inode1->i_mutex);
> 
> 	if (inode2 && !S_ISDIR(inode2->i_mode) && inode2 != inode1)
> 		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_NONDIR2);

Yes, much better.  And it becomes nicely symmetric with the unlock function.

Thanks,
Miklos


> 
> --b.
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 4bcdad3..94e41c8 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -944,24 +944,23 @@ EXPORT_SYMBOL(unlock_new_inode);
>  
>  /**
>   * lock_two_nondirectories - take two i_mutexes on non-directory objects
> + *
> + * Lock any non-NULL argument that is not a directory.
> + * Zero, one or two objects may be locked by this function.
> + *
>   * @inode1: first inode to lock
>   * @inode2: second inode to lock
>   */
>  void lock_two_nondirectories(struct inode *inode1, struct inode *inode2)
>  {
> -	WARN_ON_ONCE(S_ISDIR(inode1->i_mode));
> -	if (inode1 == inode2 || !inode2) {
> -		mutex_lock(&inode1->i_mutex);
> -		return;
> -	}
> -	WARN_ON_ONCE(S_ISDIR(inode2->i_mode));
> -	if (inode1 < inode2) {
> +	if (inode1 > inode2)
> +		swap(inode1, inode2);
> +
> +	if (inode1 && !S_ISDIR(inode1->i_mode))
>  		mutex_lock(&inode1->i_mutex);
> +
> +	if (inode2 && !S_ISDIR(inode2->i_mode) && inode2 != inode1)
>  		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_NONDIR2);
> -	} else {
> -		mutex_lock(&inode2->i_mutex);
> -		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_NONDIR2);
> -	}
>  }
>  EXPORT_SYMBOL(lock_two_nondirectories);
>  
> @@ -972,8 +971,9 @@ EXPORT_SYMBOL(lock_two_nondirectories);
>   */
>  void unlock_two_nondirectories(struct inode *inode1, struct inode *inode2)
>  {
> -	mutex_unlock(&inode1->i_mutex);
> -	if (inode2 && inode2 != inode1)
> +	if (inode1 && !S_ISDIR(inode1->i_mode))
> +		mutex_unlock(&inode1->i_mutex);
> +	if (inode2 && !S_ISDIR(inode2->i_mode) && inode2 != inode1)
>  		mutex_unlock(&inode2->i_mutex);
>  }
>  EXPORT_SYMBOL(unlock_two_nondirectories);
