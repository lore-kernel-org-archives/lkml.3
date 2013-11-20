Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3KTUBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:01:00 -0500
Received: from fieldses.org ([174.143.236.118]:54343 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab3KTUA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:00:58 -0500
Date: Wed, 20 Nov 2013 15:00:56 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [RFC PATCH v2 4/5] locks: show private lock types in /proc/locks
Message-ID: <20131120200056.GB7387@fieldses.org>
References: <1384965906-27327-1-git-send-email-jlayton@redhat.com>
 <1384965906-27327-5-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384965906-27327-5-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:45:05AM -0500, Jeff Layton wrote:
> Show "private" locks in /proc/locks with a 'P' suffix. This does mean
> that we need to widen the column by one character.
> 
> Also, tighten up the check in locks_remove_filp() to ensure that only
> IS_FILP_PVT locks are removed there.

So that part belongs in the previous patch?

--b.

> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/locks.c         | 15 +++++++++++----
>  include/linux/fs.h |  1 +
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 3b278a6..d5fb853 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -135,6 +135,7 @@
>  #define IS_POSIX(fl)	(fl->fl_flags & FL_POSIX)
>  #define IS_FLOCK(fl)	(fl->fl_flags & FL_FLOCK)
>  #define IS_LEASE(fl)	(fl->fl_flags & (FL_LEASE|FL_DELEG))
> +#define IS_FILP_PVT(fl)	(fl->fl_flags & FL_FILP_PRIVATE)
>  
>  static bool lease_breaking(struct file_lock *fl)
>  {
> @@ -357,14 +358,17 @@ static int posix_assign_type(struct file_lock *fl, long type)
>  	case F_RDLCKP:
>  		type = F_RDLCK;
>  		fl->fl_owner = (fl_owner_t)fl->fl_file;
> +		fl->fl_flags |= FL_FILP_PRIVATE;
>  		break;
>  	case F_WRLCKP:
>  		type = F_WRLCK;
>  		fl->fl_owner = (fl_owner_t)fl->fl_file;
> +		fl->fl_flags |= FL_FILP_PRIVATE;
>  		break;
>  	case F_UNLCKP:
>  		type = F_UNLCK;
>  		fl->fl_owner = (fl_owner_t)fl->fl_file;
> +		fl->fl_flags |= FL_FILP_PRIVATE;
>  		break;
>  	}
>  
> @@ -2245,7 +2249,8 @@ void locks_remove_filp(struct file *filp)
>  
>  	while ((fl = *before) != NULL) {
>  		if (fl->fl_file == filp) {
> -			if (IS_FLOCK(fl) || IS_POSIX(fl)) {
> +			if (IS_FLOCK(fl) ||
> +			    (IS_POSIX(fl) && IS_FILP_PVT(fl))) {
>  				locks_delete_lock(before);
>  				continue;
>  			}
> @@ -2345,13 +2350,15 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
>  		seq_printf(f, "UNKNOWN UNKNOWN  ");
>  	}
>  	if (fl->fl_type & LOCK_MAND) {
> -		seq_printf(f, "%s ",
> +		seq_printf(f, "%s  ",
>  			       (fl->fl_type & LOCK_READ)
>  			       ? (fl->fl_type & LOCK_WRITE) ? "RW   " : "READ "
>  			       : (fl->fl_type & LOCK_WRITE) ? "WRITE" : "NONE ");
> +	} else if (IS_FILP_PVT(fl)) {
> +		seq_printf(f, "%s ", fl->fl_type == F_WRLCK ?  "WRITEP" : "READP ");
>  	} else {
> -		seq_printf(f, "%s ",
> -			       (lease_breaking(fl))
> +		seq_printf(f, "%s  ",
> +			       lease_breaking(fl)
>  			       ? (fl->fl_type == F_UNLCK) ? "UNLCK" : "READ "
>  			       : (fl->fl_type == F_WRLCK) ? "WRITE" : "READ ");
>  	}
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2d890ce..9890bac 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -888,6 +888,7 @@ static inline int file_check_writeable(struct file *filp)
>  #define FL_SLEEP	128	/* A blocking lock */
>  #define FL_DOWNGRADE_PENDING	256 /* Lease is being downgraded */
>  #define FL_UNLOCK_PENDING	512 /* Lease is being broken */
> +#define FL_FILP_PRIVATE	1024	/* lock is private to the filp */
>  
>  /*
>   * Special return value from posix_lock_file() and vfs_lock_file() for
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
