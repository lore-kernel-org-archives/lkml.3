Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3JVTEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:04:11 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:55623
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751684Ab3JVTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:04:09 -0400
Date: Tue, 22 Oct 2013 19:04:06 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthias Schniedermeyer <ms@citd.de>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [REVIEW][PATCH 1/4] vfs: Don't allow overwriting mounts in the
 current mount namespace
Message-ID: <20131022190406.GA10600@mail.hallyn.com>
References: <CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
 <20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
 <87li23trll.fsf@tw-ebiederman.twitter.com>
 <CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
 <87vc15mjuw.fsf@xmission.com>
 <CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
 <87iox38fkv.fsf@xmission.com>
 <87d2nb8dxy.fsf@xmission.com>
 <87iowyxpci.fsf_-_@xmission.com>
 <87d2n6xpan.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2n6xpan.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> In preparation for allowing mountpoints to be renamed and unlinked
> in remote filesystems and in other mount namespaces test if on a dentry
> there is a mount in the local mount namespace before allowing it to
> be renamed or unlinked.
> 
> The primary motivation here are old versions of fusermount unmount
> which is not safe if the a path can be renamed or unlinked while it is
> verifying the mount is safe to unmount.  More recent versions are simpler
> and safer by simply using UMOUNT_NOFOLLOW when unmounting a mount
> in a directory owned by an arbitrary user.
> 
> Miklos Szeredi <miklos@szeredi.hu> reports this is approach is good
> enough to remove concerns about new kernels mixed with old versions
> of fusermount.
> 
> A secondary motivation for restrictions here is that it removing empty
> directories that have non-empty mount points on them appears to
> violate the rule that rmdir can not remove empty directories.  As
> Linus Torvalds pointed out this is useful for programs (like git) that
> test if a directory is empty with rmdir.
> 
> Therefore this patch arranges to enforce the existing mount point
> semantics for local mount namespace.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  fs/namei.c |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 645268f23eb6..df7bd6e9c7b6 100644
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
> @@ -3622,6 +3636,9 @@ retry:
>  		error = -ENOENT;
>  		goto exit3;
>  	}
> +	error = -EBUSY;
> +	if (covered(nd.path.mnt, dentry))
> +		goto exit3;
>  	error = security_path_rmdir(&nd.path, dentry);
>  	if (error)
>  		goto exit3;
> @@ -3716,6 +3733,9 @@ retry:
>  		inode = dentry->d_inode;
>  		if (!inode)
>  			goto slashes;
> +		error = -EBUSY;
> +		if (covered(nd.path.mnt, dentry))
> +			goto exit2;
>  		ihold(inode);
>  		error = security_path_unlink(&nd.path, dentry);
>  		if (error)
> @@ -4164,6 +4184,11 @@ retry:
>  	error = -ENOTEMPTY;
>  	if (new_dentry == trap)
>  		goto exit5;
> +	error = -EBUSY;
> +	if (covered(oldnd.path.mnt, old_dentry))
> +		goto exit5;
> +	if (covered(newnd.path.mnt, new_dentry))
> +		goto exit5;
>  
>  	error = security_path_rename(&oldnd.path, old_dentry,
>  				     &newnd.path, new_dentry);
> -- 
> 1.7.5.4
