Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbaCZSrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:47:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886AbaCZSrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:47:35 -0400
Date: Wed, 26 Mar 2014 19:47:31 +0100
From: Jan Kara <jack@suse.cz>
To: xypron.glpk@gmx.de
Cc: eparis@redhat.com, jack@suse.cz, tvrtko.ursulin@onelan.co.uk,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] Avoid having to provide a fake/invalid fd and path
Message-ID: <20140326184731.GA18118@quack.suse.cz>
References: <1395847805-6714-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395847805-6714-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 26-03-14 16:30:05, xypron.glpk@gmx.de wrote:
> From: Heinrich Schuchardt <xypron.glpk@gmx.de>
> 
> https://lkml.org/lkml/2011/1/12/112
> holds a patch by Tvrtko Ursulin
> 
>   Avoid having to provide a fake/invalid fd and path when flushing marks
> 
>   Currently for a group to flush marks it has set it needs to
>   provide a fake or invalid (but resolvable) file descriptor
>   and path when calling fanotify_mark. This patch pulls the
>   flush handling a bit up so file descriptor and path are
>   completely ignored when flushing.
> 
> Eric wrote it was applied.
> https://lkml.org/lkml/2011/1/19/321
> 
> Unfortunately it is still not in the main stream code and the problem remains.
> 
> I reworked the patch to be applicable again (the signature of fanotify_mark
> has changed since Tvrtko's work).
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
  The patch looks good to me. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

  Andrew, can you please add the patch to the fanotify patches you already
carry? Thanks!

								Honza

> ---
>  fs/notify/fanotify/fanotify_user.c |   17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 287a22c..05bb38a 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -856,6 +856,15 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
>  	    group->priority == FS_PRIO_0)
>  		goto fput_and_out;
>  
> +	if (flags & FAN_MARK_FLUSH) {
> +		ret = 0;
> +		if (flags & FAN_MARK_MOUNT)
> +			fsnotify_clear_vfsmount_marks_by_group(group);
> +		else
> +			fsnotify_clear_inode_marks_by_group(group);
> +		goto fput_and_out;
> +	}
> +
>  	ret = fanotify_find_path(dfd, pathname, &path, flags);
>  	if (ret)
>  		goto fput_and_out;
> @@ -867,7 +876,7 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
>  		mnt = path.mnt;
>  
>  	/* create/update an inode mark */
> -	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE | FAN_MARK_FLUSH)) {
> +	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE)) {
>  	case FAN_MARK_ADD:
>  		if (flags & FAN_MARK_MOUNT)
>  			ret = fanotify_add_vfsmount_mark(group, mnt, mask, flags);
> @@ -880,12 +889,6 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
>  		else
>  			ret = fanotify_remove_inode_mark(group, inode, mask, flags);
>  		break;
> -	case FAN_MARK_FLUSH:
> -		if (flags & FAN_MARK_MOUNT)
> -			fsnotify_clear_vfsmount_marks_by_group(group);
> -		else
> -			fsnotify_clear_inode_marks_by_group(group);
> -		break;
>  	default:
>  		ret = -EINVAL;
>  	}
> -- 
> 1.7.10.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
