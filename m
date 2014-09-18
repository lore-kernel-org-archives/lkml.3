Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbaIRKAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 06:00:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756588AbaIRKAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:00:16 -0400
Date: Thu, 18 Sep 2014 12:00:11 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Vagin <avagin@parallels.com>
Cc: Jan Kara <jack@suse.cz>, Heinrich Schuchardt <xypron.debian@gmx.de>,
        Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s
Message-ID: <20140918100011.GA30826@quack.suse.cz>
References: <1410177716-3965-1-git-send-email-avagin@openvz.org>
 <20140909012712.GV7996@ZenIV.linux.org.uk>
 <20140909085439.GB25034@quack.suse.cz>
 <20140910094318.GA19472@paralelels.com>
 <54146D8D.9090708@gmx.de>
 <20140916211211.GG1205@quack.suse.cz>
 <20140917210122.GA31893@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917210122.GA31893@paralelels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 18-09-14 01:01:22, Andrew Vagin wrote:
> From c7a79bccca1aac70f5e50fb145942b932eca79ba Mon Sep 17 00:00:00 2001
> From: Andrey Vagin <avagin@openvz.org>
> Date: Sat, 6 Sep 2014 08:35:24 +0400
> Subject: [PATCH] fs: don't remove inotify watchers from alive inode-s (v2)
> 
> Currently watchers are removed in dentry_iput(), if n_link is zero.  But
> other detries can be linked with this inode.
> 
> For example if we create two hard links, open the first one and set an
> inotify watcher on one of them.  Then if we remove the opened file and
> then another file, the inotify watcher will be removed. But we will have
> the alive file descriptor, which allows us to generate more events.
> 
> And here is another behaviour, if files are removed in another order.
> The watcher will not be removed and we will keep getting inotify events
> for that inode.
> 
> This patch removes difference of behaviours for these cases. Watchers
> are removed, only if nlink is zero and i_dentry list is empty. The
> resulting behaviour is the same with what has been described in the
> second case.
> 
> Look at a following example:
> 
> 	fd = inotify_init1(IN_NONBLOCK);
> 	deleted = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0666);
> 	link(path, path_link);
> 
> 	wd_deleted = inotify_add_watch(fd, path_link, IN_ALL_EVENTS);
> 
> 	unlink(path);
> 	unlink(path_link);
> 
> 	printf(" --- unlink path, path_link\n");
> 	read_evetns(fd);
> 
> 	close(deleted);
> 	printf(" --- close\n");
> 	read_evetns(fd);
> 	printf(" --- end\n");
> 
> We expect to get the same set of events for this case and for the
> case, when files are deleted in another order. But now we get the
> different set of events.
> 
> Without this patch:
> The first case, when "path" is deleted before "path_link"
>  --- unlink path, path_link
> 4	(IN_ATTRIB)
> 400	(IN_DELETE_SELF)
> 8000	(IN_IGNORED)
>  --- close
>  --- end
> 
> and for the case, when "path_link" is deleted before "path"
>  --- unlink path_link, path
> 4	(IN_ATTRIB)
>  --- close
> 8	(IN_CLOSE_WRITE)
> 400	(IN_DELETE_SELF)
> 8000	(IN_IGNORED)
>  --- end
> 
> With this patch we have the same output for both cases:
>  --- unlink
> 4	(IN_ATTRIB)
>  --- close
> 8	(IN_CLOSE_WRITE)
> 400	(IN_DELETE_SELF)
> 8000	(IN_IGNORED)
>  --- end
> PASS
> 
> v2: generate IN_DELETE_SELF when the last link to the file is removed
  The patch looks good to me and the description in changelog is good so
feel free to add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> Cc: Jan Kara <jack@suse.cz>
> Cc: Heinrich Schuchardt <xypron.debian@gmx.de>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: John McCutchan <john@johnmccutchan.com>
> Cc: Robert Love <rlove@rlove.org>
> Cc: Eric Paris <eparis@parisplace.org>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  fs/dcache.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 7a5b514..3a0e3bc 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -278,12 +278,15 @@ static void dentry_iput(struct dentry * dentry)
>  	__releases(dentry->d_inode->i_lock)
>  {
>  	struct inode *inode = dentry->d_inode;
> +	bool last_dentry;
> +
>  	if (inode) {
>  		dentry->d_inode = NULL;
>  		hlist_del_init(&dentry->d_alias);
> +		last_dentry = hlist_empty(&inode->i_dentry);
>  		spin_unlock(&dentry->d_lock);
>  		spin_unlock(&inode->i_lock);
> -		if (!inode->i_nlink)
> +		if (!inode->i_nlink && last_dentry)
>  			fsnotify_inoderemove(inode);
>  		if (dentry->d_op && dentry->d_op->d_iput)
>  			dentry->d_op->d_iput(dentry, inode);
> @@ -303,13 +306,16 @@ static void dentry_unlink_inode(struct dentry * dentry)
>  	__releases(dentry->d_inode->i_lock)
>  {
>  	struct inode *inode = dentry->d_inode;
> +	bool last_dentry;
> +
>  	__d_clear_type(dentry);
>  	dentry->d_inode = NULL;
>  	hlist_del_init(&dentry->d_alias);
>  	dentry_rcuwalk_barrier(dentry);
> +	last_dentry = hlist_empty(&inode->i_dentry);
>  	spin_unlock(&dentry->d_lock);
>  	spin_unlock(&inode->i_lock);
> -	if (!inode->i_nlink)
> +	if (!inode->i_nlink && last_dentry)
>  		fsnotify_inoderemove(inode);
>  	if (dentry->d_op && dentry->d_op->d_iput)
>  		dentry->d_op->d_iput(dentry, inode);
> -- 
> 1.9.3
> 

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
