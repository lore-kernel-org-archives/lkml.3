Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3LQNbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:31:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3LQNbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:31:37 -0500
Date: Tue, 17 Dec 2013 08:31:25 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [PATCH v3 6/6] locks: add new "private" lock type that is owned
 by the filp
Message-ID: <20131217083125.4ce0382b@tlielax.poochiereds.net>
In-Reply-To: <1386703055-22308-7-git-send-email-jlayton@redhat.com>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
	<1386703055-22308-7-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 14:17:35 -0500
Jeff Layton <jlayton@redhat.com> wrote:

> Due to some unfortunate history, POSIX locks have very strange and
> unhelpful semantics. The thing that usually catches people by surprise
> is that they are dropped whenever the process closes any file descriptor
> associated with the inode.
> 
> This is extremely problematic for people developing file servers that
> need to implement byte-range locks. Developers often need a "lock
> management" facility to ensure that file descriptors are not closed
> until all of the locks associated with the inode are finished.
> 
> Additionally, "classic" POSIX locks are owned by the process. Locks
> taken between threads within the same process won't conflict with one
> another, which renders classic POSIX locks useless for synchronization
> between threads.
> 
> This patchset adds a new type of lock that attempts to address these
> issues. These locks work just like classic POSIX read/write locks, but
> have semantics that are more like BSD locks with respect to inheritance
> and behavior on close.
> 
> This is implemented primarily by changing how fl_owner field is set for
> these locks. Instead of having them owned by the files_struct of the
> process, they are instead owned by the filp on which they were acquired.
> Thus, they are inherited across fork() and are only released when the
> last reference to a filp is put.
> 
> These new semantics prevent them from being merged with classic POSIX
> locks, even if they are acquired by the same process. These locks will
> also conflict with classic POSIX locks even if they are acquired by
> the same process or on the same file descriptor.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/locks.c                       | 32 ++++++++++++++++++++++++++++++--
>  include/uapi/asm-generic/fcntl.h | 16 ++++++++++++++++
>  2 files changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 5372ddd..98a503d 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -367,7 +367,34 @@ flock_to_posix_lock_common(struct file_lock *fl, struct file *filp, short type)
>  		break;
>  	}
>  
> -	return assign_type(fl, type);
> +	/*
> +	 * FL_FILE_PVT locks are "owned" by the filp upon which they were
> +	 * acquired, regardless of what task is dealing with them. Set the
> +	 * fl_owner appropriately and flag them as private.
> +	 */
> +	switch(type) {
> +	case F_RDLCKP:
> +		fl->fl_owner = (fl_owner_t)fl->fl_file;
> +		fl->fl_type = F_RDLCK;
> +		fl->fl_flags |= FL_FILE_PVT;
> +		break;
> +	case F_WRLCKP:
> +		fl->fl_owner = (fl_owner_t)fl->fl_file;
> +		fl->fl_type = F_WRLCK;
> +		fl->fl_flags |= FL_FILE_PVT;
> +		break;
> +	case F_UNLCKP:
> +		fl->fl_owner = (fl_owner_t)fl->fl_file;
> +		fl->fl_type = F_UNLCK;
> +		fl->fl_flags |= FL_FILE_PVT;
> +		break;
> +	default:
> +		/* Any other POSIX lock is owned by the file_struct */
> +		fl->fl_owner = current->files;
> +		return assign_type(fl, type);
> +	}
> +
> +	return 0;
>  }
>  
>  /* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
> @@ -2259,7 +2286,8 @@ void locks_remove_file(struct file *filp)
>  
>  	while ((fl = *before) != NULL) {
>  		if (fl->fl_file == filp) {
> -			if (IS_FLOCK(fl)) {
> +			if (IS_FLOCK(fl) ||
> +			    (IS_POSIX(fl) && IS_FILE_PVT(fl))) {
>  				locks_delete_lock(before);
>  				continue;
>  			}
> diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
> index 95e46c8..ed09fc5 100644
> --- a/include/uapi/asm-generic/fcntl.h
> +++ b/include/uapi/asm-generic/fcntl.h
> @@ -151,6 +151,22 @@ struct f_owner_ex {
>  #define F_UNLCK		2
>  #endif
>  
> +/*
> + * fd "private" POSIX locks.
> + *
> + * Usually POSIX locks held by a process are released on *any* close and are
> + * not inherited across a fork().
> + *
> + * These lock types will conflict with normal POSIX locks, but are "owned"
> + * by the opened file, not the process. This means that they are inherited
> + * across fork() like BSD (flock) locks, and they are only released
> + * automatically when the last reference to the the open file against which
> + * they were acquired is put.
> + */
> +#define F_RDLCKP	5
> +#define F_WRLCKP	6
> +#define F_UNLCKP	7
> +
>  /* for old implementation of bsd flock () */
>  #ifndef F_EXLCK
>  #define F_EXLCK		4	/* or 3 */


So, I think the above semantics are pretty clear, but now that I've had
a go at sitting down to document this stuff for the POSIX spec and
manpages, it's clear how convoluted the text in there is becoming.

That makes me wonder...would we be better off with a new set of cmd
values here instead of new l_type values? IOW, we could add new:

F_GETLKP
F_SETLKP
F_SETLKPW

...and then just reuse the same F_RDLCK/F_WRLCK/F_UNLCK values? With
that too, we could create a new equivalent to struct flock that has
fixed length types instead of dealing with the off_t mess.

I think doing that would make it a little easier to document, at the
expense of being a little trickier to code up for all of the different
arches. What would be the most intuitive interface from the standpoint
of a userland developer?

-- 
Jeff Layton <jlayton@redhat.com>
