Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3LLKn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 05:43:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3LLKnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 05:43:24 -0500
Date: Thu, 12 Dec 2013 05:43:08 -0500
From: Jeff Layton <jlayton@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [PATCH v3 1/6] locks: consolidate common code in the
 flock_to_posix_lock routines
Message-ID: <20131212054308.76aa0d37@tlielax.poochiereds.net>
In-Reply-To: <20131211225724.GB3483@fieldses.org>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
	<1386703055-22308-2-git-send-email-jlayton@redhat.com>
	<20131210212253.GC20831@fieldses.org>
	<20131210232204.GD20831@fieldses.org>
	<20131211061856.615c39ba@tlielax.poochiereds.net>
	<20131211143724.GA29300@fieldses.org>
	<20131211151931.GC29300@fieldses.org>
	<20131211140741.292028e8@tlielax.poochiereds.net>
	<20131211225616.GA3483@fieldses.org>
	<20131211225724.GB3483@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 17:57:24 -0500
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Wed, Dec 11, 2013 at 05:56:16PM -0500, J. Bruce Fields wrote:
> > On Wed, Dec 11, 2013 at 02:07:41PM -0500, Jeff Layton wrote:
> > > On Wed, 11 Dec 2013 10:19:31 -0500
> > > "J. Bruce Fields" <bfields@fieldses.org> wrote:
> > ...
> > > > +	if (l->l_len > 0)
> > > > +		fl->fl_end = fl->fl_start + l->l_len - 1;
> > > > +	else if (l->l_len < 0) {
> > > > +		fl->fl_end = start - 1;
> > > 
> > > Erm... I think this is not quite right...
> > > 
> > > "start" is uninitialized here. I think this should be:
> > > 
> > >     fl->fl_end = fl->fl_start - 1
> > > 
> > > With that too, we can get rid of the local "start" variable. I think
> > > this may explain why I'm tripping over the BUG() in locks_remove_file.
> > 
> > Yep.
> > 
> > One other bug: I think l_start < 0 is actually fine in the
> > SEEK_CUR/SEEK_END cases.
> > 
> > With that fixed and another comment (though I don't know how much it
> > helps), it looks like the below.
> 
> Alternatively, maybe we could simplify?  (On top of the previous):
> 
> commit d4bf5cb021a3ac1ec07530ebda904e262cc89d11
> Author: J. Bruce Fields <bfields@redhat.com>
> Date:   Wed Dec 11 17:42:32 2013 -0500
> 
>     locks: simplify overflow checking
>     
>     Or maybe we don't actually care about indicating overflow in the 32-bit
>     case: sure we could fail if e.g. f_pos+start or f_pos+start+len would
>     exceed 32-bits, but do we really need to?
>     
>     Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 39f2ca9..efbf577 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -344,8 +344,8 @@ static int assign_type(struct file_lock *fl, long type)
>  	return 0;
>  }
>  
> -static int flock_to_posix_lock_common(struct file *filp, struct file_lock *fl,
> -					struct flock64 *l, loff_t offset_max)
> +static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
> +				 struct flock64 *l)
>  {
>  	switch (l->l_whence) {
>  	case SEEK_SET:
> @@ -360,12 +360,12 @@ static int flock_to_posix_lock_common(struct file *filp, struct file_lock *fl,
>  	default:
>  		return -EINVAL;
>  	}
> -	if (l->l_start > offset_max - fl->fl_start)
> +	if (l->l_start > OFFSET_MAX - fl->fl_start)
>  		return -EOVERFLOW;
>  	fl->fl_start += l->l_start;
>  	if (fl->fl_start < 0)
>  		return -EINVAL;
> -	if (l->l_len > offset_max - fl->fl_start)
> +	if (l->l_len > OFFSET_MAX - fl->fl_start)
>  		return -EOVERFLOW;
>  	if (fl->fl_start + l->l_len < 0)
>  		return -EINVAL;
> @@ -403,22 +403,9 @@ static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
>  		.l_len = l->l_len,
>  	};
>  
> -	/*
> -	 * The use of OFFT_OFFSET_MAX here ensures we return -EOVERFLOW
> -	 * if the start or end of the lock could not be represented as
> -	 * an off_t, following SUSv3.
> -	 */
> -	return flock_to_posix_lock_common(filp, fl, &ll, OFFT_OFFSET_MAX);
> +	return flock64_to_posix_lock(filp, fl, &ll);
>  }
>  
> -#if BITS_PER_LONG == 32
> -static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
> -				 struct flock64 *l)
> -{
> -	return flock_to_posix_lock_common(filp, fl, l, OFFSET_MAX);
> -}
> -#endif
> -
>  /* default lease lock manager operations */
>  static void lease_break_callback(struct file_lock *fl)
>  {

Makes sense to me -- be liberal in what you accept and all that...

It might be problematic for 32-bit apps that then later try to do
F_GETLK against such a lock, I doubt that'll be any worse than the
current situation. I'll toss this one onto the pile...

Thanks!
-- 
Jeff Layton <jlayton@redhat.com>
