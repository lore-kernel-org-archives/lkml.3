Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaLAJE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:04:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbaLAJEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:04:54 -0500
Date: Mon, 1 Dec 2014 10:04:50 +0100
From: Jan Kara <jack@suse.cz>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH 1/3] fanotify: only destroy mark when both mask and
 ignored_mask are cleared
Message-ID: <20141201090450.GB16185@quack.suse.cz>
References: <1417304258-16838-1-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417304258-16838-1-git-send-email-LinoSanfilippo@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 30-11-14 00:37:36, Lino Sanfilippo wrote:
> In fanotify_mark_remove_from_mask() a mark is destroyed if only one of both
> bitmasks (mask or ignored_mask) of a mark is cleared. However the other mask
> may still be set and contain information that should not be lost. Thus only
> destroy a mark if both masks are cleared.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>  fs/notify/fanotify/fanotify_user.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index c991616..03a0dd1 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -488,6 +488,8 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
>  					    int *destroy)
>  {
>  	__u32 oldmask;
> +	__u32 new_mask;
> +	__u32 new_ignored;
>  
>  	spin_lock(&fsn_mark->lock);
>  	if (!(flags & FAN_MARK_IGNORED_MASK)) {
> @@ -497,9 +499,11 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
>  		oldmask = fsn_mark->ignored_mask;
>  		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask & ~mask));
>  	}
> +	new_mask = fsn_mark->mask;
> +	new_ignored = fsn_mark->ignored_mask;
>  	spin_unlock(&fsn_mark->lock);
>  
> -	*destroy = !(oldmask & ~mask);
> +	*destroy = !(new_mask | new_ignored);
  There's no need for new variables, is there? You can just set *destroy
under the spinlock...

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
