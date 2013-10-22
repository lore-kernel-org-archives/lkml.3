Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3JVTGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:06:31 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:55650
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753883Ab3JVTG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:06:29 -0400
Date: Tue, 22 Oct 2013 19:06:28 +0000
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
Subject: Re: [REVIEW][PATCH 2/4] vfs: Keep a list of mounts on a mount point
Message-ID: <20131022190628.GB10600@mail.hallyn.com>
References: <CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
 <20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
 <87li23trll.fsf@tw-ebiederman.twitter.com>
 <CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
 <87vc15mjuw.fsf@xmission.com>
 <CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
 <87iox38fkv.fsf@xmission.com>
 <87d2nb8dxy.fsf@xmission.com>
 <87iowyxpci.fsf_-_@xmission.com>
 <877gdexp9s.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gdexp9s.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> To spot any possible problems call BUG if a mountpoint
> is put when it's list of mounts is not empty.
> 
> Signed-off-by: Eric W. Biederman <ebiederman@twitter.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  fs/mount.h     |    2 ++
>  fs/namespace.c |    6 ++++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/mount.h b/fs/mount.h
> index 64a858143ff9..e4342b8dfab1 100644
> --- a/fs/mount.h
> +++ b/fs/mount.h
> @@ -21,6 +21,7 @@ struct mnt_pcp {
>  struct mountpoint {
>  	struct list_head m_hash;
>  	struct dentry *m_dentry;
> +	struct list_head m_list;
>  	int m_count;
>  };
>  
> @@ -47,6 +48,7 @@ struct mount {
>  	struct mount *mnt_master;	/* slave is on master->mnt_slave_list */
>  	struct mnt_namespace *mnt_ns;	/* containing namespace */
>  	struct mountpoint *mnt_mp;	/* where is it mounted */
> +	struct list_head mnt_mp_list;	/* list mounts with the same mountpoint */
>  #ifdef CONFIG_FSNOTIFY
>  	struct hlist_head mnt_fsnotify_marks;
>  	__u32 mnt_fsnotify_mask;
> diff --git a/fs/namespace.c b/fs/namespace.c
> index da5c49483430..e4fe22c23e00 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -197,6 +197,7 @@ static struct mount *alloc_vfsmnt(const char *name)
>  		INIT_LIST_HEAD(&mnt->mnt_share);
>  		INIT_LIST_HEAD(&mnt->mnt_slave_list);
>  		INIT_LIST_HEAD(&mnt->mnt_slave);
> +		INIT_LIST_HEAD(&mnt->mnt_mp_list);
>  #ifdef CONFIG_FSNOTIFY
>  		INIT_HLIST_HEAD(&mnt->mnt_fsnotify_marks);
>  #endif
> @@ -636,6 +637,7 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
>  	mp->m_dentry = dentry;
>  	mp->m_count = 1;
>  	list_add(&mp->m_hash, chain);
> +	INIT_LIST_HEAD(&mp->m_list);
>  	return mp;
>  }
>  
> @@ -643,6 +645,7 @@ static void put_mountpoint(struct mountpoint *mp)
>  {
>  	if (!--mp->m_count) {
>  		struct dentry *dentry = mp->m_dentry;
> +		BUG_ON(!list_empty(&mp->m_list));
>  		spin_lock(&dentry->d_lock);
>  		dentry->d_flags &= ~DCACHE_MOUNTED;
>  		spin_unlock(&dentry->d_lock);
> @@ -689,6 +692,7 @@ static void detach_mnt(struct mount *mnt, struct path *old_path)
>  	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
>  	list_del_init(&mnt->mnt_child);
>  	list_del_init(&mnt->mnt_hash);
> +	list_del_init(&mnt->mnt_mp_list);
>  	put_mountpoint(mnt->mnt_mp);
>  	mnt->mnt_mp = NULL;
>  }
> @@ -705,6 +709,7 @@ void mnt_set_mountpoint(struct mount *mnt,
>  	child_mnt->mnt_mountpoint = dget(mp->m_dentry);
>  	child_mnt->mnt_parent = mnt;
>  	child_mnt->mnt_mp = mp;
> +	list_add_tail(&child_mnt->mnt_mp_list, &mp->m_list);
>  }
>  
>  /*
> @@ -1191,6 +1196,7 @@ void umount_tree(struct mount *mnt, int propagate)
>  		list_del_init(&p->mnt_child);
>  		if (mnt_has_parent(p)) {
>  			p->mnt_parent->mnt_ghosts++;
> +			list_del_init(&p->mnt_mp_list);
>  			put_mountpoint(p->mnt_mp);
>  			p->mnt_mp = NULL;
>  		}
> -- 
> 1.7.5.4
