Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3GHOZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab3GHOZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:25:46 -0400
Date: Mon, 8 Jul 2013 10:25:39 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Bruce Fields <bfields@fieldses.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] locks: close potential race between setlease and open
Message-ID: <20130708102539.69b4f5ca@tlielax.poochiereds.net>
In-Reply-To: <20130708140223.GB29071@fieldses.org>
References: <1373290255-16977-1-git-send-email-jlayton@redhat.com>
	<20130708140223.GB29071@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jul 2013 10:02:23 -0400
Bruce Fields <bfields@fieldses.org> wrote:

> On Mon, Jul 08, 2013 at 09:30:55AM -0400, Jeff Layton wrote:
> > As Al Viro points out, there is an unlikely, but possible race between
> > opening a file and setting a lease on it. generic_add_lease is done with
> > the i_lock held, but the inode->i_flock check in break_lease is
> > lockless. It's possible for another task doing an open to do the entire
> > pathwalk and call break_lease between the point where generic_add_lease
> > checks for a conflicting open and adds the lease to the list. If this
> > occurs, we can end up with a lease set on the file with a conflicting
> > open.
> > 
> > To guard against that, check again for a conflicting open after adding
> > the lease to the i_flock list. If the above race occurs, then we can
> > simply unwind the lease setting and return -EAGAIN.
> 
> Maybe it's an entirely theoretical question at this point, but in the
> absence of any lock or memory barrier on the lease-setter's side I still
> don't understand what guarantees that the opener calling break_lease
> will see the new value of i_flock.
> 
> --b.

Ok, I think I see what you mean. The concern you have is that
break_lease still may not see a populated i_flock list even after
locks_insert_lock is called since it's not being checked with any
locking? So this patch would tighten up the race window w/o eliminating
it...

locks_insert_lock will acquire a percpu spinlock to put it on the
percpu hlist, but I'm not 100% sure that's sufficient as a memory
barrier here.

Would an explicit smp_wmb() after locks_insert_lock paired with a
smp_rmb() early in break_lease be sufficient?

Also, there's a bug in this patch as well, which I've got fixed in
my tree. I'll fix that in the next version. Details below...

> 
> 
> > 
> > Cc: Bruce Fields <bfields@fieldses.org>
> > Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  fs/locks.c | 31 ++++++++++++++++++++++++-------
> >  1 file changed, 24 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/locks.c b/fs/locks.c
> > index b27a300..9f7f647 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -1455,6 +1455,19 @@ int fcntl_getlease(struct file *filp)
> >  	return type;
> >  }
> >  
> > +static int
> > +check_conflicting_open(struct dentry *dentry, long arg)
> > +{
> > +	struct inode *inode = dentry->d_inode;
> > +
> > +	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
> > +		return -EAGAIN;
> > +	if ((arg == F_WRLCK) && ((d_count(dentry) > 1) ||
> > +	    (atomic_read(&inode->i_count) > 1)))
> > +		return -EAGAIN;
> > +	return 0;
> > +}
> > +
> >  static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
> >  {
> >  	struct file_lock *fl, **before, **my_before = NULL, *lease;
> > @@ -1464,12 +1477,8 @@ static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp
> >  
> >  	lease = *flp;
> >  
> > -	error = -EAGAIN;
> > -	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
> > -		goto out;
> > -	if ((arg == F_WRLCK)
> > -	    && ((d_count(dentry) > 1)
> > -		|| (atomic_read(&inode->i_count) > 1)))
> > +	error = check_conflicting_open(dentry, arg);
> > +	if (error)
> >  		goto out;
> >  
> >  	/*
> > @@ -1514,8 +1523,16 @@ static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp
> >  		goto out;
> >  
> >  	locks_insert_lock(before, lease);
> > -	return 0;
> >  
> > +	/*
> > +	 * The check in break_lease() is lockless. It's possible for another
> > +	 * open to race in after we did the earlier check for a conflicting
> > +	 * open but before the lease was inserted. Check again for a
> > +	 * conflicting open and cancel the lease if there is one.
> > +	 */
> > +	error = check_conflicting_open(dentry, arg);
> > +	if (error)
> > +		locks_delete_lock(flp);

		^^^^^
		This isn't safe since the caller will try to free *flp
		on error, so we need to be a bit more careful here and
		only dequeue the lock w/o freeing it.

> >  out:
> >  	return error;
> >  }
> > -- 
> > 1.8.1.4
> > 


-- 
Jeff Layton <jlayton@redhat.com>
