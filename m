Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3JEPw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:52:29 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:35523
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016Ab3JEPw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:52:27 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Oct 2013 11:52:27 EDT
Date: Sat, 5 Oct 2013 15:44:45 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but
 the current mount namespace
Message-ID: <20131005154445.GA2137@mail.hallyn.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87a9ioo37a.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9ioo37a.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> Programs have been known to test for empty directories by attempting
> to remove them.  To keep from violating the principle of least
> surprise don't let directories the caller can see with someting
> mounted on them be deleted.
> 
> With a little luck this may prevent commands stupid commands
> like rm -rf from eating your system.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Thanks.  I've not had a chance to look at the implementation details
(hope to do so this weekend) but ack to the change itself being
needed.  AFAIK this was the last uncomfortable piece about unprivileged
CLONE_NEWUSER.

> ---
>  fs/namei.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index b18b017c946b..b9cae480ac27 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3547,6 +3547,20 @@ void dentry_unhash(struct dentry *dentry)
>  	spin_unlock(&dentry->d_lock);
>  }
>  
> +static bool covered(struct vfsmount *mnt, struct dentry *dentry)
> +{
> +	/* test to see if a dentry is covered with a mount in
> +	 * the current mount namespace.
> +	 */
> +	bool is_covered;
> +
> +	rcu_read_lock();
> +	is_covered = d_mountpoint(dentry) && __lookup_mnt(mnt, dentry, 1);
> +	rcu_read_unlock();
> +
> +	return is_covered;
> +}
> +
>  int vfs_rmdir(struct inode *dir, struct dentry *dentry)
>  {
>  	int error = may_delete(dir, dentry, 1);
> @@ -3619,6 +3633,9 @@ retry:
>  		error = -ENOENT;
>  		goto exit3;
>  	}
> +	error = -EBUSY;
> +	if (covered(nd.path.mnt, dentry))
> +		goto exit3;
>  	error = security_path_rmdir(&nd.path, dentry);
>  	if (error)
>  		goto exit3;
> @@ -4155,6 +4172,10 @@ retry:
>  	error = -ENOTEMPTY;
>  	if (new_dentry == trap)
>  		goto exit5;
> +	error = -EBUSY;
> +	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode) &&
> +	    covered(newnd.path.mnt, new_dentry))
> +		goto exit5;
>  
>  	error = security_path_rename(&oldnd.path, old_dentry,
>  				     &newnd.path, new_dentry);
> -- 
> 1.7.5.4
