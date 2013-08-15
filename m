Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760420Ab3HOUaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:30:55 -0400
Received: from fieldses.org ([174.143.236.118]:45393 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760251Ab3HOUay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:30:54 -0400
Date: Thu, 15 Aug 2013 16:30:49 -0400
From: Bruce Fields <bfields@fieldses.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v3] locks: close potential race between setlease and open
Message-ID: <20130815203048.GU17781@fieldses.org>
References: <1373310444-25862-1-git-send-email-jlayton@redhat.com>
 <1376482310-7348-1-git-send-email-jlayton@redhat.com>
 <20130815193203.GT17781@fieldses.org>
 <20130815154325.281a042c@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815154325.281a042c@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 03:43:25PM -0400, Jeff Layton wrote:
> On Thu, 15 Aug 2013 15:32:03 -0400
> Bruce Fields <bfields@fieldses.org> wrote:
> 
> > On Wed, Aug 14, 2013 at 08:11:50AM -0400, Jeff Layton wrote:
> > > v2:
> > > - fix potential double-free of lease if second check finds conflict
> > > - add smp_mb's to ensure that other CPUs see i_flock changes
> > > 
> > > v3:
> > > - remove smp_mb calls. Partial ordering is unlikely to help here.
> > 
> > Forgive me here, I still don't understand.  So to simplify massively,
> > the situation looks like:
> > 
> > 	setlease		open
> > 	------------		------
> > 
> > 	atomic_read		atomic_inc
> > 	write i_flock		read i_flock
> > 	atomic_read
> > 
> > And we want to be sure that either the setlease caller sees the result
> > of the atomic_inc, or the opener sees the result of the write to
> > i_flock.
> > 
> > As an example, suppose the above steps happen in the order:
> > 
> > 	atomic_read
> > 	write i_flock
> > 	atomic_read
> > 				atomic_inc
> > 				read i_flock
> > 
> > How do we know that the read of i_flock at the last step reflects the
> > latest value of i_flock?  For example, couldn't the write still be stuck
> > in first CPU's cache?
> > 
> > --b.
> > 
> 
> AIUI, all Linux architectures are cache-coherent. So if you do a
> write to a memory location on one CPU then other CPUs will see it
> after that event.
> 
> The thing that you have to be careful about of course is ordering, as
> the CPU and compiler are allowed to reorder operations in the name of
> efficiency. I don't think ordering is a concern here since, as you
> point out, the refcounting operations are atomic or done under spinlock.
> 
> Now, all that said...I'm pretty clueless when it comes to this sort of
> thing, so if I'm wrong then please do tell me so.

Yeah, well, I'm beyond clueless--what's the difference between
cache-coherent and ordered?  Whether we say a write's still in one CPU
cache or say the write was ordered after later operations--the upshot
sounds the same.

And I'm unclear what effect the atomic operations have.  And the
spinlock can't matter as it's only taken before and after all the
operations on the left hand side?

Oh wait, I guess there is another spinlock--the lglock taken when we
modify i_flock.  Hm.

I'll go bury my nose in memory-barriers.txt and assume this is just my
confusion....

--b.

> 
> Thanks,
> 
> > > 
> > > As Al Viro points out, there is an unlikely, but possible race between
> > > opening a file and setting a lease on it. generic_add_lease is done with
> > > the i_lock held, but the inode->i_flock check in break_lease is
> > > lockless. It's possible for another task doing an open to do the entire
> > > pathwalk and call break_lease between the point where generic_add_lease
> > > checks for a conflicting open and adds the lease to the list. If this
> > > occurs, we can end up with a lease set on the file with a conflicting
> > > open.
> > > 
> > > To guard against that, check again for a conflicting open after adding
> > > the lease to the i_flock list. If the above race occurs, then we can
> > > simply unwind the lease setting and return -EAGAIN.
> > > 
> > > Because we take dentry references and acquire write access on the file
> > > before calling break_lease, we know that if the i_flock list is empty
> > > when the open caller goes to check it then the necessary refcounts have
> > > already been incremented. Thus the additional check for a conflicting
> > > open will see that there is one and the setlease call will fail.
> > > 
> > > Cc: Bruce Fields <bfields@fieldses.org>
> > > Cc: David Howells <dhowells@redhat.com>
> > > Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> > > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > > ---
> > >  fs/locks.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++------------
> > >  1 file changed, 58 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/fs/locks.c b/fs/locks.c
> > > index b27a300..a99adec 100644
> > > --- a/fs/locks.c
> > > +++ b/fs/locks.c
> > > @@ -652,15 +652,18 @@ static void locks_insert_lock(struct file_lock **pos, struct file_lock *fl)
> > >  	locks_insert_global_locks(fl);
> > >  }
> > >  
> > > -/*
> > > - * Delete a lock and then free it.
> > > - * Wake up processes that are blocked waiting for this lock,
> > > - * notify the FS that the lock has been cleared and
> > > - * finally free the lock.
> > > +/**
> > > + * locks_delete_lock - Delete a lock and then free it.
> > > + * @thisfl_p: pointer that points to the fl_next field of the previous
> > > + * 	      inode->i_flock list entry
> > > + *
> > > + * Unlink a lock from all lists and free the namespace reference, but don't
> > > + * free it yet. Wake up processes that are blocked waiting for this lock and
> > > + * notify the FS that the lock has been cleared.
> > >   *
> > >   * Must be called with the i_lock held!
> > >   */
> > > -static void locks_delete_lock(struct file_lock **thisfl_p)
> > > +static void locks_unlink_lock(struct file_lock **thisfl_p)
> > >  {
> > >  	struct file_lock *fl = *thisfl_p;
> > >  
> > > @@ -675,6 +678,18 @@ static void locks_delete_lock(struct file_lock **thisfl_p)
> > >  	}
> > >  
> > >  	locks_wake_up_blocks(fl);
> > > +}
> > > +
> > > +/*
> > > + * Unlink a lock from all lists and free it.
> > > + *
> > > + * Must be called with i_lock held!
> > > + */
> > > +static void locks_delete_lock(struct file_lock **thisfl_p)
> > > +{
> > > +	struct file_lock *fl = *thisfl_p;
> > > +
> > > +	locks_unlink_lock(thisfl_p);
> > >  	locks_free_lock(fl);
> > >  }
> > >  
> > > @@ -1455,6 +1470,32 @@ int fcntl_getlease(struct file *filp)
> > >  	return type;
> > >  }
> > >  
> > > +/**
> > > + * check_conflicting_open - see if the given dentry points to a file that has
> > > + * 	an existing open that would conflict with the desired lease.
> > > + *
> > > + * @dentry:	dentry to check
> > > + * @arg:	type of lease that we're trying to acquire
> > > + *
> > > + * Check to see if there's an existing open fd on this file that would
> > > + * conflict with the lease we're trying to set.
> > > + */
> > > +static int
> > > +check_conflicting_open(const struct dentry *dentry, const long arg)
> > > +{
> > > +	int ret = 0;
> > > +	struct inode *inode = dentry->d_inode;
> > > +
> > > +	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
> > > +		return -EAGAIN;
> > > +
> > > +	if ((arg == F_WRLCK) && ((d_count(dentry) > 1) ||
> > > +	    (atomic_read(&inode->i_count) > 1)))
> > > +		ret = -EAGAIN;
> > > +
> > > +	return ret;
> > > +}
> > > +
> > >  static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
> > >  {
> > >  	struct file_lock *fl, **before, **my_before = NULL, *lease;
> > > @@ -1464,12 +1505,8 @@ static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp
> > >  
> > >  	lease = *flp;
> > >  
> > > -	error = -EAGAIN;
> > > -	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
> > > -		goto out;
> > > -	if ((arg == F_WRLCK)
> > > -	    && ((d_count(dentry) > 1)
> > > -		|| (atomic_read(&inode->i_count) > 1)))
> > > +	error = check_conflicting_open(dentry, arg);
> > > +	if (error)
> > >  		goto out;
> > >  
> > >  	/*
> > > @@ -1514,8 +1551,16 @@ static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp
> > >  		goto out;
> > >  
> > >  	locks_insert_lock(before, lease);
> > > -	return 0;
> > >  
> > > +	/*
> > > +	 * The check in break_lease() is lockless. It's possible for another
> > > +	 * open to race in after we did the earlier check for a conflicting
> > > +	 * open but before the lease was inserted. Check again for a
> > > +	 * conflicting open and cancel the lease if there is one.
> > > +	 */
> > > +	error = check_conflicting_open(dentry, arg);
> > > +	if (error)
> > > +		locks_unlink_lock(flp);
> > >  out:
> > >  	return error;
> > >  }
> > > -- 
> > > 1.8.3.1
> > > 
> 
> 
> -- 
> Jeff Layton <jlayton@redhat.com>
