Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3LJVXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:23:01 -0500
Received: from fieldses.org ([174.143.236.118]:34671 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3LJVW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:22:59 -0500
Date: Tue, 10 Dec 2013 16:22:53 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [PATCH v3 1/6] locks: consolidate common code in the
 flock_to_posix_lock routines
Message-ID: <20131210212253.GC20831@fieldses.org>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
 <1386703055-22308-2-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386703055-22308-2-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 02:17:30PM -0500, Jeff Layton wrote:
> Currently, there's a lot of copy and paste between the two.  Add some
> functions to do the initialization of the file_lock from values
> passed in, and turn the flock/flock64 variants of those functions into
> wrappers around them.
> 
> Unfortunately it's harder to consolidate the fl_start/fl_end
> calculations due to the differently sized types involved so I've left
> them separate for now.

I'd think you could assign everything to the flock64 type and do the
common work there or something.

But I'm confused about what the current code is actually trying to do:
if I'm chasing down the definitions right, these quantities are all
signed, and when start is defined as an off_t it can overflow in the
SEEK_CUR and SEEK_END cases.  And

	if (fl->fl_end < fl->fl_start)
		return -EOVERFLOW

is counting on overlow wrapping around, which I thought wasn't
guaranteed in the case of signed arithmetic?

--b.


> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/locks.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 6084f5a..a5848ed 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -344,6 +344,19 @@ static int assign_type(struct file_lock *fl, long type)
>  	return 0;
>  }
>  
> +static int
> +flock_to_posix_lock_common(struct file_lock *fl, struct file *filp, short type)
> +{
> +	fl->fl_owner = current->files;
> +	fl->fl_pid = current->tgid;
> +	fl->fl_file = filp;
> +	fl->fl_flags = FL_POSIX;
> +	fl->fl_ops = NULL;
> +	fl->fl_lmops = NULL;
> +
> +	return assign_type(fl, type);
> +}
> +
>  /* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
>   * style lock.
>   */
> @@ -386,14 +399,7 @@ static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
>  	if (fl->fl_end < fl->fl_start)
>  		return -EOVERFLOW;
>  	
> -	fl->fl_owner = current->files;
> -	fl->fl_pid = current->tgid;
> -	fl->fl_file = filp;
> -	fl->fl_flags = FL_POSIX;
> -	fl->fl_ops = NULL;
> -	fl->fl_lmops = NULL;
> -
> -	return assign_type(fl, l->l_type);
> +	return flock_to_posix_lock_common(fl, filp, l->l_type);
>  }
>  
>  #if BITS_PER_LONG == 32
> @@ -431,15 +437,8 @@ static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
>  	fl->fl_start = start;	/* we record the absolute position */
>  	if (fl->fl_end < fl->fl_start)
>  		return -EOVERFLOW;
> -	
> -	fl->fl_owner = current->files;
> -	fl->fl_pid = current->tgid;
> -	fl->fl_file = filp;
> -	fl->fl_flags = FL_POSIX;
> -	fl->fl_ops = NULL;
> -	fl->fl_lmops = NULL;
>  
> -	return assign_type(fl, l->l_type);
> +	return flock_to_posix_lock_common(fl, filp, l->l_type);
>  }
>  #endif
>  
> -- 
> 1.8.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
