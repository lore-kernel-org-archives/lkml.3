Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3GDEnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:43:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47298 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab3GDEnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:43:51 -0400
Date: Thu, 4 Jul 2013 05:43:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v3 25/25] selinux: Change how dentry's d_lock field is
 accessed
Message-ID: <20130704044339.GN4165@ZenIV.linux.org.uk>
References: <1372882937-23274-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372882937-23274-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 04:22:17PM -0400, Waiman Long wrote:
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index ff42773..c83a201 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -1187,28 +1187,28 @@ static void sel_remove_entries(struct dentry *de)
>  {
>  	struct list_head *node;
>  
> -	spin_lock(&de->d_lock);
> +	d_lock(de);
>  	node = de->d_subdirs.next;
>  	while (node != &de->d_subdirs) {
>  		struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
>  
> -		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
> +		d_lock_nested(d, DENTRY_D_LOCK_NESTED);
>  		list_del_init(node);
>  
>  		if (d->d_inode) {
>  			dget_dlock(d);
> -			spin_unlock(&de->d_lock);
> -			spin_unlock(&d->d_lock);
> +			d_unlock(de);
> +			d_unlock(d);
>  			d_delete(d);
>  			simple_unlink(de->d_inode, d);
>  			dput(d);
> -			spin_lock(&de->d_lock);
> +			d_lock(de);
>  		} else
> -			spin_unlock(&d->d_lock);
> +			d_unlock(d);
>  		node = de->d_subdirs.next;
>  	}
>  
> -	spin_unlock(&de->d_lock);
> +	d_unlock(de);

BTW, all that bunch (this and similar simple_unlink() callers) is seriously
asking for a common helper somewhere in libfs.c; I'd started experimenting
in that direction several times, but got sidetracked.  The real question
here is what do we do with the stuff mounted on those.

Linus, do you have any suggestions re semantics of mounts on such mountpoints?
I see two variants - disslove all mounts on those when the kernel decides to
kill such a volatile mountpoint (the same goes for e.g. /proc/42/fd getting
invalidated, etc.) or ban mounting on them in the first place (i.e. set
DCACHE_CANT_MOUNT when these dentries are created)...  Preferences, alternative
suggestions?

