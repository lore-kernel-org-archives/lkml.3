Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3JVTI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:08:27 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:55664
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753537Ab3JVTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:08:26 -0400
Date: Tue, 22 Oct 2013 19:08:25 +0000
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
Subject: Re: [REVIEW][PATCH 3/4] vfs: Add a function to lazily unmount all
 mounts from any dentry. v3
Message-ID: <20131022190825.GC10600@mail.hallyn.com>
References: <CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
 <20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
 <87li23trll.fsf@tw-ebiederman.twitter.com>
 <CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
 <87vc15mjuw.fsf@xmission.com>
 <CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
 <87iox38fkv.fsf@xmission.com>
 <87d2nb8dxy.fsf@xmission.com>
 <87iowyxpci.fsf_-_@xmission.com>
 <871u3mxp8s.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u3mxp8s.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> v2: Always drop the lock when exiting early.
> v3: Make detach_mounts robust about freeing several
>     mounts on the same mountpoint at one time, and remove
>     the unneeded mnt_list list test.
> 
> Signed-off-by: Eric W. Biederman <ebiederman@twitter.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

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
> index e4fe22c23e00..78f7c5c9e673 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1295,6 +1295,30 @@ static int do_umount(struct mount *mnt, int flags)
>  	return retval;
>  }
>  
> +void detach_mounts(struct dentry *dentry)
> +{
> +	struct mountpoint *mp;
> +	struct mount *mnt;
> +
> +	namespace_lock();
> +	if (!d_mountpoint(dentry))
> +		goto out_unlock;
> +
> +	mp = new_mountpoint(dentry);
> +	if (IS_ERR(mp))
> +		goto out_unlock;
> +
> +	br_write_lock(&vfsmount_lock);
> +	while (!list_empty(&mp->m_list)) {
> +		mnt = list_first_entry(&mp->m_list, struct mount, mnt_mp_list);
> +		umount_tree(mnt, 1);
> +	}
> +	br_write_unlock(&vfsmount_lock);
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
