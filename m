Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab3JGEWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 00:22:30 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:42124
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751629Ab3JGEW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 00:22:28 -0400
Date: Mon, 7 Oct 2013 04:22:26 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/3] vfs: Add a function to lazily unmount all
 mounts from any dentry.
Message-ID: <20131007042225.GA10284@mail.hallyn.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87a9io1wu1.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9io1wu1.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> Signed-off-by: Eric W. Biederman <ebiederman@twitter.com>
> ---
>  fs/mount.h     |    1 +
>  fs/namespace.c |   24 ++++++++++++++++++++++++
>  2 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/mount.h b/fs/mount.h
> index e4342b8dfab1..7a6a2bb3f290 100644
> --- a/fs/mount.h
> +++ b/fs/mount.h
> @@ -79,6 +79,7 @@ static inline int is_mounted(struct vfsmount *mnt)
>  }
>  
>  extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
> +extern void detach_mounts(struct dentry *dentry);
>  
>  static inline void get_mnt_ns(struct mnt_namespace *ns)
>  {
> diff --git a/fs/namespace.c b/fs/namespace.c
> index d092964fe7f9..8eaee0c14fdb 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1294,6 +1294,30 @@ static int do_umount(struct mount *mnt, int flags)
>  	return retval;
>  }
>  
> +void detach_mounts(struct dentry *dentry)
> +{
> +	struct mount *mnt, *next;
> +	struct mountpoint *mp;
> +
> +	namespace_lock();
> +	if (!d_mountpoint(dentry)) {
> +		namespace_unlock();
> +		return;
> +	}
> +	mp = new_mountpoint(dentry);
> +	if (IS_ERR(mp)) {

	namespace_unlock();

> +		return;
> +	}
> +	br_write_lock(&vfsmount_lock);
> +	list_for_each_entry_safe(mnt, next, &mp->m_list, mnt_mp_list) {
> +		if (!list_empty(&mnt->mnt_list))
> +			umount_tree(mnt, 1);
> +	}
> +	br_write_unlock(&vfsmount_lock);
> +	put_mountpoint(mp);
> +	namespace_unlock();
> +}
> +
>  /* 
>   * Is the caller allowed to modify his namespace?
>   */
> -- 
> 1.7.5.4
