Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaLAKGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:06:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbaLAKFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:05:54 -0500
Date: Mon, 1 Dec 2014 11:05:47 +0100
From: Jan Kara <jack@suse.cz>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH 3/3] fanotify: fix inconsistent behaviour regarding flag
 FAN_ONDIR
Message-ID: <20141201100547.GD16185@quack.suse.cz>
References: <1417304258-16838-1-git-send-email-LinoSanfilippo@gmx.de>
 <1417304258-16838-3-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417304258-16838-3-git-send-email-LinoSanfilippo@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 30-11-14 00:37:38, Lino Sanfilippo wrote:
> Before flag FAN_ONDIR was implicitly set in a marks ignored mask. This led to
> some inconsistent behaviour:
> 
> 1. It was not possible to remove the flag from the ignored mask, once it was set
> (implicitly) with a call like
> 
> fanotify_mark(fd, FAN_MARK_ADD, FAN_OPEN, AT_FDCWD, "dir");
> 
> This was since the needed flag FAN_MARK_ONDIR was only honored when setting a
> marks mask, but not when removing it. Now FAN_ONDIR is only set when explicitly
> passed in the masks parameter. It now is also possible to remove it again:
> 
> fanotify_mark(fd, FAN_MARK_ADD, FAN_OPEN | FAN_ONDIR , AT_FDCWD, "dir");
> fanotify_mark(fd, FAN_MARK_REMOVE, FAN_ONDIR , AT_FDCWD, "dir");
> 
> 2. Subsequent calls to fanotify_mark for a mark that had FAN_ONDIR already set
> in its mask removed the flag, if it was not specified in the mask parameter
> again. Thus
> 
> fanotify_mark(fd, FAN_MARK_ADD, FAN_OPEN | FAN_ONDIR , AT_FDCWD, "dir");
> fanotify_mark(fd, FAN_MARK_ADD, FAN_CLOSE, AT_FDCWD, "dir");
> 
> set FAN_ONDIR in the first call on the marks mask but also on the ignored
> mask in the second call. So the first request for DIR events was overwritten.
> Since the flag is now not set implicitly any longer this cant happen any more.
  Ugh, I have to say I don't understand the changelog. From the code I
think I understood that instead of always adding FAN_ONDIR to ignore mask
you require FAN_ONDIR to be set in the normal mask. That makes sense to me
but please make the changelog more comprehensible. Also please add a
testcase to LTP fanotify() coverage for FAN_ONDIR behavior so that we can
easily see how userspace visible behavior changed / didn't change. Thanks!

								Honza
 

> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>  fs/notify/fanotify/fanotify.c      |  2 +-
>  fs/notify/fanotify/fanotify_user.c | 24 ++++++++++++++++--------
>  2 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
> index 30d3add..51ceb81 100644
> --- a/fs/notify/fanotify/fanotify.c
> +++ b/fs/notify/fanotify/fanotify.c
> @@ -140,7 +140,7 @@ static bool fanotify_should_send_event(struct fsnotify_mark *inode_mark,
>  	}
>  
>  	if (S_ISDIR(path->dentry->d_inode->i_mode) &&
> -	    (marks_ignored_mask & FS_ISDIR))
> +	    !(marks_mask & FS_ISDIR & ~marks_ignored_mask))
>  		return false;
>  
>  	if (event_mask & marks_mask & ~marks_ignored_mask)
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 3afd8bb..e62463e 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -493,10 +493,17 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
>  
>  	spin_lock(&fsn_mark->lock);
>  	if (!(flags & FAN_MARK_IGNORED_MASK)) {
> +		__u32 tmask = fsn_mark->mask & ~mask;
> +		if (flags & FAN_MARK_ONDIR)
> +			tmask &= ~FAN_ONDIR;
> +
>  		oldmask = fsn_mark->mask;
> -		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask & ~mask));
> +		fsnotify_set_mark_mask_locked(fsn_mark, tmask);
>  	} else {
>  		__u32 tmask = fsn_mark->ignored_mask & ~mask;
> +		if (flags & FAN_MARK_ONDIR)
> +			tmask &= ~FAN_ONDIR;
> +
>  		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
>  	}
>  	new_mask = fsn_mark->mask;
> @@ -573,20 +580,21 @@ static __u32 fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
>  
>  	spin_lock(&fsn_mark->lock);
>  	if (!(flags & FAN_MARK_IGNORED_MASK)) {
> +		__u32 tmask = fsn_mark->mask | mask;
> +		if (flags & FAN_MARK_ONDIR)
> +			tmask |= FAN_ONDIR;
> +
>  		oldmask = fsn_mark->mask;
> -		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask | mask));
> +		fsnotify_set_mark_mask_locked(fsn_mark, tmask);
>  	} else {
>  		__u32 tmask = fsn_mark->ignored_mask | mask;
> +		if (flags & FAN_MARK_ONDIR)
> +			tmask |= FAN_ONDIR;
> +
>  		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
>  		if (flags & FAN_MARK_IGNORED_SURV_MODIFY)
>  			fsn_mark->flags |= FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY;
>  	}
> -
> -	if (!(flags & FAN_MARK_ONDIR)) {
> -		__u32 tmask = fsn_mark->ignored_mask | FAN_ONDIR;
> -		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
> -	}
> -
>  	spin_unlock(&fsn_mark->lock);
>  
>  	return mask & ~oldmask;
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
