Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaBRRP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:15:56 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54096 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbaBRRPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:15:53 -0500
Date: Tue, 18 Feb 2014 18:17:08 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 05/11] vfs: Add a function to lazily unmount all mounts
 from any dentry.
Message-ID: <20140218171708.GD4026@tucsk.piliscsaba.szeredi.hu>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87ob28kqks.fsf_-_@xmission.com>
 <87txc0jbvt.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txc0jbvt.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 01:37:26PM -0800, Eric W. Biederman wrote:
> 
> v2: Always drop the lock when exiting early.
> v3: Make detach_mounts robust about freeing several
>     mounts on the same mountpoint at one time, and remove
>     the unneeded mnt_list list test.
> v4: Document the purpose of detach_mounts and why new_mountpoint is
>     safe to call.
> 
> Signed-off-by: Eric W. Biederman <ebiederman@twitter.com>
> ---
>  fs/mount.h     |    2 ++
>  fs/namespace.c |   39 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/mount.h b/fs/mount.h
> index 50a72d46e7a6..2b470f34e665 100644
> --- a/fs/mount.h
> +++ b/fs/mount.h
> @@ -84,6 +84,8 @@ extern struct mount *__lookup_mnt_last(struct vfsmount *, struct dentry *);
>  
>  extern bool legitimize_mnt(struct vfsmount *, unsigned);
>  
> +extern void detach_mounts(struct dentry *dentry);
> +
>  static inline void get_mnt_ns(struct mnt_namespace *ns)
>  {
>  	atomic_inc(&ns->count);
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 33db9e95bd5c..7abbf722ce18 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1359,6 +1359,45 @@ static int do_umount(struct mount *mnt, int flags)
>  	return retval;
>  }
>  
> +/*
> + * detach_mounts - lazily unmount all mounts on the specified dentry
> + *
> + * During unlink, rmdir, and d_drop it is possible to loose the path
> + * to an existing mountpoint, and wind up leaking the mount.
> + * detach_mounts allows lazily unmounting those mounts instead of
> + * leaking them.
> + * 
> + * The caller may hold dentry->d_inode->i_mutex.
> + */
> +void detach_mounts(struct dentry *dentry)
> +{
> +	struct mountpoint *mp;
> +	struct mount *mnt;
> +
> +	namespace_lock();
> +	if (!d_mountpoint(dentry))
> +		goto out_unlock;
> +
> +	/* 
> +	 * The namespace lock and d_mountpoint being set guarantees
> +	 * that new_mountpoint will just be a lookup of the existing
> +	 * mountpoint structure.
> +	 */
> +	mp = new_mountpoint(dentry);

Howabout a get_mountpoint(dentry) helper, that returns NULL if it turns out to
be not a mountpoint?  And, as an added bonus, you can drop the comment above as
well.

> +	if (IS_ERR(mp))
> +		goto out_unlock;
> +
> +	lock_mount_hash();
> +	while (!list_empty(&mp->m_list)) {
> +		mnt = list_first_entry(&mp->m_list, struct mount, mnt_mp_list);
> +		umount_tree(mnt, 1);
> +	}
> +	unlock_mount_hash();
> +	put_mountpoint(mp);
> +out_unlock:
> +	namespace_unlock();
> +}
> +
>  /* 
>   * Is the caller allowed to modify his namespace?
>   */
> -- 
> 1.7.5.4
> 
