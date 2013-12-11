Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab3LKOhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:37:32 -0500
Received: from fieldses.org ([174.143.236.118]:52095 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3LKOha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:37:30 -0500
Date: Wed, 11 Dec 2013 09:37:24 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [PATCH v3 1/6] locks: consolidate common code in the
 flock_to_posix_lock routines
Message-ID: <20131211143724.GA29300@fieldses.org>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
 <1386703055-22308-2-git-send-email-jlayton@redhat.com>
 <20131210212253.GC20831@fieldses.org>
 <20131210232204.GD20831@fieldses.org>
 <20131211061856.615c39ba@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211061856.615c39ba@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 06:18:56AM -0500, Jeff Layton wrote:
> On Tue, 10 Dec 2013 18:22:04 -0500
> "J. Bruce Fields" <bfields@fieldses.org> wrote:
> 
> > On Tue, Dec 10, 2013 at 04:22:53PM -0500, bfields wrote:
> > > On Tue, Dec 10, 2013 at 02:17:30PM -0500, Jeff Layton wrote:
> > > > Currently, there's a lot of copy and paste between the two.  Add some
> > > > functions to do the initialization of the file_lock from values
> > > > passed in, and turn the flock/flock64 variants of those functions into
> > > > wrappers around them.
> > > > 
> > > > Unfortunately it's harder to consolidate the fl_start/fl_end
> > > > calculations due to the differently sized types involved so I've left
> > > > them separate for now.
> > > 
> > > I'd think you could assign everything to the flock64 type and do the
> > > common work there or something.
> > > 
> > > But I'm confused about what the current code is actually trying to do:
> > > if I'm chasing down the definitions right, these quantities are all
> > > signed, and when start is defined as an off_t it can overflow in the
> > > SEEK_CUR and SEEK_END cases.  And
> > > 
> > > 	if (fl->fl_end < fl->fl_start)
> > > 		return -EOVERFLOW
> > > 
> > > is counting on overlow wrapping around, which I thought wasn't
> > > guaranteed in the case of signed arithmetic?
> > 
> > E.g. the following (untested) removes the duplication and should return
> > -EOVERFLOW in the cases we currently do a random conversion from 64- to
> > 32-bit and back.  Susv3 says:
> > 
> > 	[EOVERFLOW]
> > 	The cmd argument is F_GETLK, F_SETLK, or F_SETLKW and the
> > 	smallest or, if l_len is non-zero, the largest offset of any
> > 	byte in the requested segment cannot be represented correctly in
> > 	an object of type off_t.
> > 
> > so that's what I tried to do.
> > 
> > --b.
> > 
> > diff --git a/fs/locks.c b/fs/locks.c
> > index 92a0f0a..47832f5 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -344,48 +344,41 @@ static int assign_type(struct file_lock *fl, long type)
> >  	return 0;
> >  }
> >  
> > -/* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
> > - * style lock.
> > - */
> > -static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
> > -			       struct flock *l)
> > +static int flock_to_posix_lock_common(struct file *filp, struct file_lock *fl,
> > +					struct flock64 *l, loff_t offset_max)
> >  {
> > -	off_t start, end;
> > +	loff_t start;
> >  
> >  	switch (l->l_whence) {
> >  	case SEEK_SET:
> > -		start = 0;
> > -		break;
> > +		fl->fl_start = 0;
> >  	case SEEK_CUR:
> > -		start = filp->f_pos;
> > -		break;
> > +		fl->fl_start = filp->f_pos;
> >  	case SEEK_END:
> > -		start = i_size_read(file_inode(filp));
> > -		break;
> > +		fl->fl_start = i_size_read(file_inode(filp));
> >  	default:
> >  		return -EINVAL;
> >  	}
> > +	if (l->l_start < 0)
> > +		return -EINVAL;
> > +	if (l->l_start > offset_max - fl->fl_start)
> > +		return -EOVERFLOW;
> > +	fl->fl_start += l->l_start;
> > +	if (l->l_len > offset_max - fl->fl_start)
> > +		return -EOVERFLOW;
> > +	if (fl->fl_start + l->l_len < 0)
> > +		return -EINVAL;
> >  
> >  	/* POSIX-1996 leaves the case l->l_len < 0 undefined;
> >  	   POSIX-2001 defines it. */
> > -	start += l->l_start;
> > -	if (start < 0)
> > -		return -EINVAL;
> > -	fl->fl_end = OFFSET_MAX;
> > -	if (l->l_len > 0) {
> > -		end = start + l->l_len - 1;
> > -		fl->fl_end = end;
> > -	} else if (l->l_len < 0) {
> > -		end = start - 1;
> > -		fl->fl_end = end;
> > -		start += l->l_len;
> > -		if (start < 0)
> > -			return -EINVAL;
> > -	}
> > -	fl->fl_start = start;	/* we record the absolute position */
> > -	if (fl->fl_end < fl->fl_start)
> > -		return -EOVERFLOW;
> > -	
> > +	if (l->l_len > 0)
> > +		fl->fl_end = fl->fl_start + l->l_len - 1;
> > +	else if (l->l_len < 0) {
> > +		fl->fl_end = start - 1;
> > +		fl->fl_start += l->l_len;
> > +	} else
> > +		fl->fl_end = OFFSET_MAX;
> > +
> >  	fl->fl_owner = current->files;
> >  	fl->fl_pid = current->tgid;
> >  	fl->fl_file = filp;
> > @@ -396,50 +389,27 @@ static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
> >  	return assign_type(fl, l->l_type);
> >  }
> >  
> > +/* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
> > + * style lock.
> > + */
> > +static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
> > +			       struct flock *l)
> > +{
> > +	struct flock64 ll = {
> > +		.l_type = l->l_type,
> > +		.l_whence = l->l_whence,
> > +		.l_start = l->l_start,
> > +		.l_len = l->l_len,
> > +	};
> > +	
> > +	return flock_to_posix_lock_common(filp, fl, &ll, OFFT_OFFSET_MAX);
> > +}
> > +
> >  #if BITS_PER_LONG == 32
> >  static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
> >  				 struct flock64 *l)
> >  {
> > -	loff_t start;
> > -
> > -	switch (l->l_whence) {
> > -	case SEEK_SET:
> > -		start = 0;
> > -		break;
> > -	case SEEK_CUR:
> > -		start = filp->f_pos;
> > -		break;
> > -	case SEEK_END:
> > -		start = i_size_read(file_inode(filp));
> > -		break;
> > -	default:
> > -		return -EINVAL;
> > -	}
> > -
> > -	start += l->l_start;
> > -	if (start < 0)
> > -		return -EINVAL;
> > -	fl->fl_end = OFFSET_MAX;
> > -	if (l->l_len > 0) {
> > -		fl->fl_end = start + l->l_len - 1;
> > -	} else if (l->l_len < 0) {
> > -		fl->fl_end = start - 1;
> > -		start += l->l_len;
> > -		if (start < 0)
> > -			return -EINVAL;
> > -	}
> > -	fl->fl_start = start;	/* we record the absolute position */
> > -	if (fl->fl_end < fl->fl_start)
> > -		return -EOVERFLOW;
> > -	
> > -	fl->fl_owner = current->files;
> > -	fl->fl_pid = current->tgid;
> > -	fl->fl_file = filp;
> > -	fl->fl_flags = FL_POSIX;
> > -	fl->fl_ops = NULL;
> > -	fl->fl_lmops = NULL;
> > -
> > -	return assign_type(fl, l->l_type);
> > +	return flock_to_posix_lock_common(filp, fl, l, OFFSET_MAX);
> >  }
> >  #endif
> >  
> > diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
> > index 95e46c8..36025f7 100644
> > --- a/include/uapi/asm-generic/fcntl.h
> > +++ b/include/uapi/asm-generic/fcntl.h
> > @@ -186,8 +186,6 @@ struct flock {
> >  };
> >  #endif
> >  
> > -#ifndef CONFIG_64BIT
> > -
> >  #ifndef HAVE_ARCH_STRUCT_FLOCK64
> >  #ifndef __ARCH_FLOCK64_PAD
> >  #define __ARCH_FLOCK64_PAD
> > @@ -202,6 +200,5 @@ struct flock64 {
> >  	__ARCH_FLOCK64_PAD
> >  };
> >  #endif
> > -#endif /* !CONFIG_64BIT */
> >  
> >  #endif /* _ASM_GENERIC_FCNTL_H */
> 
> Nice. I had started to consolidate them, but then figured out that
> there are so many edge cases and I didn't have a good way to test them
> all.
> 
> As far as I can tell though, this looks correct. I'll plan to drop my
> patch and base the rest of the set on top of yours.

Well, it'd be weird if I didn't screw up something somewhere.  If we've
both looked at it and not found anything then maybe it's OK.  But I'll
see if I can do some basic tests for the edge cases.

--b.
