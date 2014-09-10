Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaIJRtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:49:10 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:47642 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaIJRtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:49:08 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Wed, 10 Sep 2014 13:49:05 -0400
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 03/12] locks: have locks_release_file use
 flock_lock_file to release generic flock locks
Message-ID: <20140910134905.0f10d25b@tlielax.poochiereds.net>
In-Reply-To: <20140910173843.GA4210@fieldses.org>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
	<1410359330-27564-4-git-send-email-jlayton@primarydata.com>
	<20140910173843.GA4210@fieldses.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014 13:38:43 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Wed, Sep 10, 2014 at 10:28:41AM -0400, Jeff Layton wrote:
> > Signed-off-by: Jeff Layton <jlayton@primarydata.com>
> 
> ACK to going ahead and applying this now if you want.
> 

Thanks. Right now, I'm planning to hold off until v3.19 in case the
design changes.

> Took me a moment to understand why the i_flock test got moved--OK, so
> the locks_remove_*'s are doing that themselves instead, got it.
> 
> --b.
> 

Yes. The tricky part here is that I'm trying to migrate each lock
"flavor" to file_lock_context one at a time. So we have some interim
stages where we'll need to check i_flock for some types and i_flctx for
others. I may be able to re-consolidate those checks once the i_flock
list is gone however. This patchset doesn't do that yet.


> > ---
> >  fs/locks.c | 49 +++++++++++++++++++++++++++++++------------------
> >  1 file changed, 31 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/locks.c b/fs/locks.c
> > index af55bd35be5f..5e8b865814a2 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -2393,6 +2393,30 @@ void locks_remove_posix(struct file *filp, fl_owner_t owner)
> >  
> >  EXPORT_SYMBOL(locks_remove_posix);
> >  
> > +static void
> > +locks_remove_flock(struct file *filp)
> > +{
> > +	struct file_lock fl = {
> > +		.fl_owner = filp,
> > +		.fl_pid = current->tgid,
> > +		.fl_file = filp,
> > +		.fl_flags = FL_FLOCK,
> > +		.fl_type = F_UNLCK,
> > +		.fl_end = OFFSET_MAX,
> > +	};
> > +
> > +	if (!file_inode(filp)->i_flock)
> > +		return;
> > +
> > +	if (filp->f_op->flock)
> > +		filp->f_op->flock(filp, F_SETLKW, &fl);
> > +	else
> > +		flock_lock_file(filp, &fl);
> > +
> > +	if (fl.fl_ops && fl.fl_ops->fl_release_private)
> > +		fl.fl_ops->fl_release_private(&fl);
> > +}
> > +
> >  /*
> >   * This function is called on the last close of an open file.
> >   */
> > @@ -2403,24 +2427,14 @@ void locks_remove_file(struct file *filp)
> >  	struct file_lock **before;
> >  	LIST_HEAD(dispose);
> >  
> > -	if (!inode->i_flock)
> > -		return;
> > -
> > +	/* remove any OFD locks */
> >  	locks_remove_posix(filp, filp);
> >  
> > -	if (filp->f_op->flock) {
> > -		struct file_lock fl = {
> > -			.fl_owner = filp,
> > -			.fl_pid = current->tgid,
> > -			.fl_file = filp,
> > -			.fl_flags = FL_FLOCK,
> > -			.fl_type = F_UNLCK,
> > -			.fl_end = OFFSET_MAX,
> > -		};
> > -		filp->f_op->flock(filp, F_SETLKW, &fl);
> > -		if (fl.fl_ops && fl.fl_ops->fl_release_private)
> > -			fl.fl_ops->fl_release_private(&fl);
> > -	}
> > +	/* remove flock locks */
> > +	locks_remove_flock(filp);
> > +
> > +	if (!inode->i_flock)
> > +		return;
> 
> 
> 
> >  
> >  	spin_lock(&inode->i_lock);
> >  	before = &inode->i_flock;
> > @@ -2440,8 +2454,7 @@ void locks_remove_file(struct file *filp)
> >  			 * some info about it and then just remove it from
> >  			 * the list.
> >  			 */
> > -			WARN(!IS_FLOCK(fl),
> > -				"leftover lock: dev=%u:%u ino=%lu type=%hhd flags=0x%x start=%lld end=%lld\n",
> > +			WARN(1, "leftover lock: dev=%u:%u ino=%lu type=%hhd flags=0x%x start=%lld end=%lld\n",
> >  				MAJOR(inode->i_sb->s_dev),
> >  				MINOR(inode->i_sb->s_dev), inode->i_ino,
> >  				fl->fl_type, fl->fl_flags,
> > -- 
> > 1.9.3
> > 


-- 
Jeff Layton <jlayton@primarydata.com>
