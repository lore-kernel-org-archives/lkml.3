Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbaDVNks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:40:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124AbaDVNkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:40:47 -0400
Date: Tue, 22 Apr 2014 15:40:44 +0200
From: Jan Kara <jack@suse.cz>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Eric Paris <eparis@redhat.com>, Jan Kara <jack@suse.cz>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fanotify: check permissions when creating file
 descriptor
Message-ID: <20140422134044.GE366@quack.suse.cz>
References: <1397940833-6386-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397940833-6386-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 19-04-14 22:53:53, Heinrich Schuchardt wrote:
> When monitoring a directory or a mount with the fanotify API
> the call to fanotify_init checks,
>  * the process has cap_sys_admin capability
> 
> The call to fanotify_mark checks,
>  * the process has read authorization for directory or mount
> 
> A directory or mount may contain files for which the process
> has no read or write authorization.
> Yet when reading from the fanotify file descriptor, structures
> fanotify_event_metadata are returned, which contain a file
> descriptor for these files, and will allow to read or write.
> 
> The patch adds an authorization check for read and write
> permission. In case of missing permission, reading from the
> fanotify file descriptor returns EACCES.
  OK, am I right you are concerned about a situation where fanotify group
descriptor is passed to an unpriviledged process which handles all the
incoming events? I'm asking because the permission checking can be
relatively expensive (think of acls) so we better do it for a reason.
I'd prefer to hear from Eric what the original intention regarding
permissions was...

								Honza
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  fs/notify/fanotify/fanotify_user.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 4e565c8..5d22a20 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -62,6 +62,8 @@ static int create_fd(struct fsnotify_group *group,
>  {
>  	int client_fd;
>  	struct file *new_file;
> +	int mask;
> +	int ret;
>  
>  	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
>  
> @@ -75,11 +77,19 @@ static int create_fd(struct fsnotify_group *group,
>  	 */
>  	/* it's possible this event was an overflow event.  in that case dentry and mnt
>  	 * are NULL;  That's fine, just don't call dentry open */
> -	if (event->path.dentry && event->path.mnt)
> -		new_file = dentry_open(&event->path,
> -				       group->fanotify_data.f_flags | FMODE_NONOTIFY,
> -				       current_cred());
> -	else
> +	if (event->path.dentry && event->path.mnt) {
> +		/* check permissions before granting access to file */
> +		mask = MAY_READ;
> +		if (group->fanotify_data.f_flags & (O_RDWR | O_WRONLY))
> +			mask |= MAY_WRITE;
> +		ret = inode_permission(event->path.dentry->d_inode, mask);
> +		if (ret)
> +			new_file = ERR_PTR(ret);
> +		else
> +			new_file = dentry_open(&event->path,
> +					       group->fanotify_data.f_flags | FMODE_NONOTIFY,
> +					       current_cred());
> +	} else
>  		new_file = ERR_PTR(-EOVERFLOW);
>  	if (IS_ERR(new_file)) {
>  		/*
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
