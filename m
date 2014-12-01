Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaLAJLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:11:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbaLAJLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:11:54 -0500
Date: Mon, 1 Dec 2014 10:11:49 +0100
From: Jan Kara <jack@suse.cz>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH 2/3] fanotify: dont recalculate a marks mask if only the
 ignored mask changed
Message-ID: <20141201091149.GC16185@quack.suse.cz>
References: <1417304258-16838-1-git-send-email-LinoSanfilippo@gmx.de>
 <1417304258-16838-2-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417304258-16838-2-git-send-email-LinoSanfilippo@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 30-11-14 00:37:37, Lino Sanfilippo wrote:
> If removing bits from a marks ignored mask, the concerning inodes/vfsmounts
> mask is not affected. So dont recalculate it.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/notify/fanotify/fanotify_user.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 03a0dd1..3afd8bb 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -487,7 +487,7 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
>  					    unsigned int flags,
>  					    int *destroy)
>  {
> -	__u32 oldmask;
> +	__u32 oldmask = 0;
>  	__u32 new_mask;
>  	__u32 new_ignored;
>  
> @@ -496,8 +496,8 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
>  		oldmask = fsn_mark->mask;
>  		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask & ~mask));
>  	} else {
> -		oldmask = fsn_mark->ignored_mask;
> -		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask & ~mask));
> +		__u32 tmask = fsn_mark->ignored_mask & ~mask;
> +		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
>  	}
>  	new_mask = fsn_mark->mask;
>  	new_ignored = fsn_mark->ignored_mask;
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
