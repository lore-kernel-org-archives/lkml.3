Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750818Ab3HSNeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 09:34:13 -0400
Received: from fieldses.org ([174.143.236.118]:60470 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab3HSNeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 09:34:12 -0400
Date: Mon, 19 Aug 2013 09:34:06 -0400
From: Bruce Fields <bfields@fieldses.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
        David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4] locks: close potential race between setlease and open
Message-ID: <20130819133406.GG6726@fieldses.org>
References: <1373310444-25862-1-git-send-email-jlayton@redhat.com>
 <1376664572-4635-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376664572-4635-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 10:49:32AM -0400, Jeff Layton wrote:
> v2:
> - fix potential double-free of lease if second check finds conflict
> - add smp_mb's to ensure that other CPUs see i_flock changes
> 
> v3:
> - remove smp_mb calls. Partial ordering is unlikely to help here.
> 
> v4:
> - add back smp_mb calls. While we have implicit barriers in place
>   that enforce this today, it's best to be explicit about it as a
>   defensive coding measure.
> 
> As Al Viro points out, there is an unlikely, but possible race between
> opening a file and setting a lease on it. generic_add_lease is done with
> the i_lock held, but the inode->i_flock check in break_lease is
> lockless. It's possible for another task doing an open to do the entire
> pathwalk and call break_lease between the point where generic_add_lease
> checks for a conflicting open and adds the lease to the list. If this
> occurs, we can end up with a lease set on the file with a conflicting
> open.
> 
> To guard against that, check again for a conflicting open after adding
> the lease to the i_flock list. If the above race occurs, then we can
> simply unwind the lease setting and return -EAGAIN.
> 
> Because we take dentry references and acquire write access on the file
> before calling break_lease, we know that if the i_flock list is empty
> when the open caller goes to check it then the necessary refcounts have
> already been incremented. Thus the additional check for a conflicting
> open will see that there is one and the setlease call will fail.

ACK--thanks for your persistence!

--b.

> 
> Cc: Bruce Fields <bfields@fieldses.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/locks.c         | 75 ++++++++++++++++++++++++++++++++++++++++++++----------
>  include/linux/fs.h |  6 +++++
>  2 files changed, 68 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index b27a300..8dddcb5 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -652,15 +652,18 @@ static void locks_insert_lock(struct file_lock **pos, struct file_lock *fl)
>  	locks_insert_global_locks(fl);
>  }
>  
> -/*
> - * Delete a lock and then free it.
> - * Wake up processes that are blocked waiting for this lock,
> - * notify the FS that the lock has been cleared and
> - * finally free the lock.
> +/**
> + * locks_delete_lock - Delete a lock and then free it.
> + * @thisfl_p: pointer that points to the fl_next field of the previous
> + * 	      inode->i_flock list entry
> + *
> + * Unlink a lock from all lists and free the namespace reference, but don't
> + * free it yet. Wake up processes that are blocked waiting for this lock and
> + * notify the FS that the lock has been cleared.
>   *
>   * Must be called with the i_lock held!
>   */
> -static void locks_delete_lock(struct file_lock **thisfl_p)
> +static void locks_unlink_lock(struct file_lock **thisfl_p)
>  {
>  	struct file_lock *fl = *thisfl_p;
>  
> @@ -675,6 +678,18 @@ static void locks_delete_lock(struct file_lock **thisfl_p)
>  	}
>  
>  	locks_wake_up_blocks(fl);
> +}
> +
> +/*
> + * Unlink a lock from all lists and free it.
> + *
> + * Must be called with i_lock held!
> + */
> +static void locks_delete_lock(struct file_lock **thisfl_p)
> +{
> +	struct file_lock *fl = *thisfl_p;
> +
> +	locks_unlink_lock(thisfl_p);
>  	locks_free_lock(fl);
>  }
>  
> @@ -1455,6 +1470,32 @@ int fcntl_getlease(struct file *filp)
>  	return type;
>  }
>  
> +/**
> + * check_conflicting_open - see if the given dentry points to a file that has
> + * 			    an existing open that would conflict with the
> + * 			    desired lease.
> + * @dentry:	dentry to check
> + * @arg:	type of lease that we're trying to acquire
> + *
> + * Check to see if there's an existing open fd on this file that would
> + * conflict with the lease we're trying to set.
> + */
> +static int
> +check_conflicting_open(const struct dentry *dentry, const long arg)
> +{
> +	int ret = 0;
> +	struct inode *inode = dentry->d_inode;
> +
> +	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
> +		return -EAGAIN;
> +
> +	if ((arg == F_WRLCK) && ((d_count(dentry) > 1) ||
> +	    (atomic_read(&inode->i_count) > 1)))
> +		ret = -EAGAIN;
> +
> +	return ret;
> +}
> +
>  static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
>  {
>  	struct file_lock *fl, **before, **my_before = NULL, *lease;
> @@ -1464,12 +1505,8 @@ static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp
>  
>  	lease = *flp;
>  
> -	error = -EAGAIN;
> -	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
> -		goto out;
> -	if ((arg == F_WRLCK)
> -	    && ((d_count(dentry) > 1)
> -		|| (atomic_read(&inode->i_count) > 1)))
> +	error = check_conflicting_open(dentry, arg);
> +	if (error)
>  		goto out;
>  
>  	/*
> @@ -1514,8 +1551,20 @@ static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp
>  		goto out;
>  
>  	locks_insert_lock(before, lease);
> -	return 0;
>  
> +	/*
> +	 * The check in break_lease() is lockless. It's possible for another
> +	 * open to race in after we did the earlier check for a conflicting
> +	 * open but before the lease was inserted. Check again for a
> +	 * conflicting open and cancel the lease if there is one.
> +	 *
> +	 * We also add a barrier here to ensure that the insertion of the lock
> +	 * precedes these checks.
> +	 */
> +	smp_mb();
> +	error = check_conflicting_open(dentry, arg);
> +	if (error)
> +		locks_unlink_lock(flp);
>  out:
>  	return error;
>  }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 9818747..165bf41 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1955,6 +1955,12 @@ static inline int locks_verify_truncate(struct inode *inode,
>  
>  static inline int break_lease(struct inode *inode, unsigned int mode)
>  {
> +	/*
> +	 * Since this check is lockless, we must ensure that any refcounts
> +	 * taken are done before checking inode->i_flock. Otherwise, we could
> +	 * end up racing with tasks trying to set a new lease on this file.
> +	 */
> +	smp_mb();
>  	if (inode->i_flock)
>  		return __break_lease(inode, mode);
>  	return 0;
> -- 
> 1.8.3.1
> 
