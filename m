Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3HLN14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:27:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190Ab3HLN1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:27:50 -0400
Date: Mon, 12 Aug 2013 09:27:41 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk,
        bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/9] vfs: check submounts and drop atomically
Message-ID: <20130812092741.7a8da502@tlielax.poochiereds.net>
In-Reply-To: <1375975490-18673-2-git-send-email-miklos@szeredi.hu>
References: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
	<1375975490-18673-2-git-send-email-miklos@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Aug 2013 17:24:42 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> We check submounts before doing d_drop() on a non-empty directory dentry in
> NFS (have_submounts()), but we do not exclude a racing mount.
> 
>  Process A: have_submounts() -> returns false
>  Process B: mount() -> success
>  Process A: d_drop()
> 
> This patch prepares the ground for the fix by doing the following
> operations all under the same rename lock:
> 
>   have_submounts()
>   shrink_dcache_parent()
>   d_drop()
> 
> This is actually an optimization since have_submounts() and
> shrink_dcache_parent() both traverse the same dentry tree separately.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: David Howells <dhowells@redhat.com>
> CC: Steven Whitehouse <swhiteho@redhat.com>
> CC: Trond Myklebust <Trond.Myklebust@netapp.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/dcache.c            | 157 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dcache.h |   1 +
>  2 files changed, 158 insertions(+)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 87bdb53..020004d 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1224,6 +1224,163 @@ void shrink_dcache_parent(struct dentry * parent)
>  }
>  EXPORT_SYMBOL(shrink_dcache_parent);
>  
> +static int __check_submounts_and_drop(struct dentry *parent,
> +					     struct list_head *dispose)
> +{
> +	struct dentry *this_parent;
> +	struct list_head *next;
> +	unsigned seq;
> +	int found = 0;
> +	int locked = 0;
> +
> +	seq = read_seqbegin(&rename_lock);
> +again:
> +	this_parent = parent;
> +	spin_lock(&this_parent->d_lock);
> +repeat:
> +	next = this_parent->d_subdirs.next;
> +resume:
> +	while (next != &this_parent->d_subdirs) {
> +		struct list_head *tmp = next;
> +		struct dentry *dentry;
> +
> +		dentry = list_entry(tmp, struct dentry, d_u.d_child);
> +		next = tmp->next;
> +
> +		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
> +		if (d_mountpoint(dentry)) {
> +			spin_unlock(&dentry->d_lock);
> +			found = -EBUSY;
> +			goto out;
> +		}
> +
> +		/*
> +		 * move only zero ref count dentries to the dispose list.
> +		 *
> +		 * Those which are presently on the shrink list, being processed
> +		 * by shrink_dentry_list(), shouldn't be moved.  Otherwise the
> +		 * loop in shrink_dcache_parent() might not make any progress
> +		 * and loop forever.
> +		 */
> +		if (dentry->d_count) {
> +			dentry_lru_del(dentry);
> +		} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
> +			dentry_lru_move_list(dentry, dispose);
> +			dentry->d_flags |= DCACHE_SHRINK_LIST;
> +			found++;
> +		}
> +		/*
> +		 * We can return to the caller if we have found some (this
> +		 * ensures forward progress). We'll be coming back to find
> +		 * the rest.
> +		 */
> +		if (found && need_resched()) {
> +			spin_unlock(&dentry->d_lock);
> +			goto out;
> +		}
> +
> +		/*
> +		 * Descend a level if the d_subdirs list is non-empty.
> +		 */
> +		if (!list_empty(&dentry->d_subdirs)) {
> +			spin_unlock(&this_parent->d_lock);
> +			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
> +			this_parent = dentry;
> +			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
> +			goto repeat;
> +		}
> +
> +		spin_unlock(&dentry->d_lock);
> +	}
> +	/*
> +	 * All done at this level ... ascend and resume the search.
> +	 */
> +	if (this_parent != parent) {
> +		struct dentry *child = this_parent;
> +		this_parent = try_to_ascend(this_parent, locked, seq);
> +		if (!this_parent)
> +			goto rename_retry;
> +		next = child->d_u.d_child.next;
> +		goto resume;
> +	}
> +	if (!locked && read_seqretry(&rename_lock, seq)) {
> +		spin_unlock(&this_parent->d_lock);
> +		goto rename_retry;
> +	}
> +	if (d_mountpoint(this_parent))
> +		found = -EBUSY;
> +	if (!found)
> +		__d_drop(this_parent);
> +out:
> +	spin_unlock(&this_parent->d_lock);
> +
> +	if (locked)
> +		write_sequnlock(&rename_lock);
> +	return found;
> +
> +rename_retry:
> +	if (found)
> +		return found;
> +	if (locked)
> +		goto again;
> +	locked = 1;
> +	write_seqlock(&rename_lock);
> +	goto again;
> +}
> +
> +/**
> + * check_submounts_and_drop - prune dcache, check for submounts and drop
> + *
> + * All done as a single atomic operation relative to has_unlinked_ancestor().
> + * Returns 0 if successfully unhashed @parent.  If there were submounts then
> + * return -EBUSY.
> + *
> + * @dentry: dentry to prune and drop
> + */
> +int check_submounts_and_drop(struct dentry *dentry)
> +{
> +	int ret = 0;
> +
> +	/* Negative dentries can be dropped without further checks */
> +	if (!dentry->d_inode) {
> +		d_drop(dentry);
> +		goto out;
> +	}
> +
> +	spin_lock(&dentry->d_lock);
> +	if (d_unhashed(dentry))
> +		goto out_unlock;
> +	if (list_empty(&dentry->d_subdirs)) {
> +		if (d_mountpoint(dentry)) {
> +			ret = -EBUSY;
> +			goto out_unlock;
> +		}
> +		__d_drop(dentry);
> +		goto out_unlock;
> +	}
> +	spin_unlock(&dentry->d_lock);
> +
> +	for (;;) {
> +		LIST_HEAD(dispose);
> +		ret = __check_submounts_and_drop(dentry, &dispose);
> +		if (!list_empty(&dispose))
> +			shrink_dentry_list(&dispose);
> +
> +		if (ret <= 0)
> +			break;
> +
> +		cond_resched();
> +	}
> +
> +out:
> +	return ret;
> +
> +out_unlock:
> +	spin_unlock(&dentry->d_lock);
> +	goto out;
> +}
> +EXPORT_SYMBOL(check_submounts_and_drop);
> +
>  /**
>   * __d_alloc	-	allocate a dcache entry
>   * @sb: filesystem it will belong to
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index b90337c..41b21ca 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -251,6 +251,7 @@ extern void d_prune_aliases(struct inode *);
>  
>  /* test whether we have any submounts in a subdir tree */
>  extern int have_submounts(struct dentry *);
> +extern int check_submounts_and_drop(struct dentry *);
>  
>  /*
>   * This adds the entry to the hash queues.

Nice work...

Looks reasonable overall. The only (extremely minor) nit I have is that
it might be nice to replace some of the direct struct list_head
accesses with helper macros.

Acked-by: Jeff Layton <jlayton@redhat.com>
