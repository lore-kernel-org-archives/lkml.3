Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaI2NQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:16:21 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40981 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaI2NQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:16:18 -0400
Date: Mon, 29 Sep 2014 06:16:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140929131613.GL5015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140924185521.GC7996@ZenIV.linux.org.uk>
 <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
 <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
 <20140926164442.GA26897@ZenIV.linux.org.uk>
 <20140927044555.GS7996@ZenIV.linux.org.uk>
 <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
 <20140927183139.GT7996@ZenIV.linux.org.uk>
 <20140927191657.GU7996@ZenIV.linux.org.uk>
 <20140928074747.GZ7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928074747.GZ7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092913-0928-0000-0000-0000053B6BDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 08:47:47AM +0100, Al Viro wrote:
> On Sat, Sep 27, 2014 at 08:16:57PM +0100, Al Viro wrote:
> > On Sat, Sep 27, 2014 at 07:31:39PM +0100, Al Viro wrote:
> > 
> > > We can get the long name cases right, and I agree that it'll make the
> > > things nicer, but it might take a couple of days to get right.  The thing
> > > I'm concerned about is not screwing DCACHE_RCUACCESS up.
> > 
> > FWIW, I suspect that the right approach is to put refcount + rcu_head in
> > front of external name and do the following:
> > 	* __d_free() checks if we have an external name, gets its containing
> > structure and does if (atomic_dec_and_test(&name->count)) kfree(name);
> > 	* switch_names() in non-exchange case (I'd probably call it copy_name,
> > not move_names, but anyway) sets DCACHE_RCUACCESS on target (source has
> > already gotten it from __d_rehash()), increments refcount on target's name
> > if external and, if the source old name is external, decrements its refcount
> > and calls kfree_rcu() if it has hit zero.
> > 
> > AFAICS, it guarantees that we'll schedule an RCU callback on name's rch_head
> > at most once, that we won't free it while RCU callback on it is scheduled
> > and we won't free it until a grace period has expired since the last time
> > it had been referenced by observable dentries.  Do you see any holes in that?
> 
> Bugger...  I see one, actually.  Look: d1 and d2 come to share name at some
> point.  name has refcount 2.  d1 gets dropped.  OK, we get RCU-delayed
> __d_free().  refcount is still 2.  Now somebody starts looking through the
> hash chain.  And somebody else renames d2.  __d_move() decrements refcount of
> name to 1.  No kfree_rcu().  OK, _now_ __d_free() on d1 happens; it was
> RCU-delayed, but that won't wait for rcu_read_lock() done after we'd
> done call_rcu().  So __d_free() is called, name refcount reaches 0 and the
> name is freed.  Just as the hash lookup has gotten around to looking at what
> used to be the name of d2.  Oops...

The "textbook" approach is to avoid starting the grace period until
the after the final reference count is dropped (and of course after
the name has been made inaccessible to all readers).  Not sure what
the best way to adapt the current code to this approach (if it is
in fact feasible to begin with), but one approach would be something
like this:

static void __d_free(struct rcu_head *head)
{
	struct dentry *dentry = container_of(head, struct dentry, d_u.d_rcu);

	WARN_ON(!hlist_unhashed(&dentry->d_alias));
	if (dname_external(dentry) && atomic_dec_return(&dentry->refcnt))
		call_rcu(&dentry->rh, __d_free_name_rcu);
	kmem_cache_free(dentry_cache, dentry); 
}

Of course, this means that the link side has to do something like
atomic_add_unless(&&dentry->refcnt, 1, 0), and create a new name
if the old one is on its way out.  If that is too painful, another
approach is to increment the count for the grace period and decrement
it at the end of the grace period, and to skip the free if non-zero
after that decrement.  And this means adding an rcu_head to the
qstr structure, which might not help memory footprint.

> The root cause, of course, is that we delay decrementing the refcount on
> dentry_free() path...  One variant is to rip freeing these suckers out of
> __d_free() and have dentry_free() do atomic_dec_and_test + kfree_rcu.
> That works (and we don't need to set DCACHE_RCUACCESS in copy_name();
> the interesting part of never-hashed case is for short names anyway), but
> the cost is twice the number of rcu callbacks on freeing long-name dentries.
> Is that really painful enough to care?  If not, something like the following
> would do; if it is... well, we could probably do make free_dentry() mark
> dentry->d_flags for __d_free() with "free the external name hanging off
> this one" in case if refcount decrement has ended up with zero.  Doable,
> but more complicated (and somewhat messy, since ->d_lock is not held
> at that point; OTOH, we could play with ->d_name instead of ->d_flags...).
> Anyway, the delta below might suffice.  Comments?

Odd guesses below...

> diff --git a/fs/dcache.c b/fs/dcache.c
> index cb25a1a..b52f4ee 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -235,18 +235,34 @@ static inline int dentry_cmp(const struct dentry *dentry, const unsigned char *c
>  	return dentry_string_cmp(cs, ct, tcount);
>  }
> 
> +struct ext_name {
> +	union {
> +		atomic_t count;
> +		struct rcu_head head;
> +	};
> +	unsigned char name[];
> +};
> +
> +static inline struct ext_name *ext_name(struct dentry *dentry)
> +{
> +	if (likely(!dname_external(dentry)))
> +		return NULL;
> +	return container_of(dentry->d_name.name, struct ext_name, name[0]);
> +}
> +
>  static void __d_free(struct rcu_head *head)
>  {
>  	struct dentry *dentry = container_of(head, struct dentry, d_u.d_rcu);
> 
>  	WARN_ON(!hlist_unhashed(&dentry->d_alias));
> -	if (dname_external(dentry))
> -		kfree(dentry->d_name.name);
>  	kmem_cache_free(dentry_cache, dentry); 
>  }
> 
>  static void dentry_free(struct dentry *dentry)
>  {
> +	struct ext_name *p = ext_name(dentry);
> +	if (unlikely(p) && likely(atomic_dec_and_test(&p->count)))
> +		kfree_rcu(p, head);
>  	/* if dentry was never visible to RCU, immediate free is OK */
>  	if (!(dentry->d_flags & DCACHE_RCUACCESS))
>  		__d_free(&dentry->d_u.d_rcu);
> @@ -1438,11 +1454,14 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
>  	 */
>  	dentry->d_iname[DNAME_INLINE_LEN-1] = 0;
>  	if (name->len > DNAME_INLINE_LEN-1) {
> -		dname = kmalloc(name->len + 1, GFP_KERNEL);
> -		if (!dname) {
> +		size_t size = offsetof(struct ext_name, name) + name->len + 1;
> +		struct ext_name *p = kmalloc(size, GFP_KERNEL);
> +		if (!p) {
>  			kmem_cache_free(dentry_cache, dentry); 
>  			return NULL;
>  		}
> +		atomic_set(&p->count, 1);
> +		dname = p->name;
>  	} else  {
>  		dname = dentry->d_iname;
>  	}	
> @@ -2372,11 +2391,10 @@ void dentry_update_name_case(struct dentry *dentry, struct qstr *name)
>  }
>  EXPORT_SYMBOL(dentry_update_name_case);
> 
> -static void switch_names(struct dentry *dentry, struct dentry *target,
> -			 bool exchange)
> +static void swap_names(struct dentry *dentry, struct dentry *target)
>  {
> -	if (dname_external(target)) {
> -		if (dname_external(dentry)) {
> +	if (unlikely(dname_external(target))) {
> +		if (unlikely(dname_external(dentry))) {
>  			/*
>  			 * Both external: swap the pointers
>  			 */
> @@ -2392,7 +2410,7 @@ static void switch_names(struct dentry *dentry, struct dentry *target,
>  			target->d_name.name = target->d_iname;
>  		}
>  	} else {
> -		if (dname_external(dentry)) {
> +		if (unlikely(dname_external(dentry))) {
>  			/*
>  			 * dentry:external, target:internal.  Give dentry's
>  			 * storage to target and make dentry internal
> @@ -2407,12 +2425,6 @@ static void switch_names(struct dentry *dentry, struct dentry *target,
>  			 */
>  			unsigned int i;
>  			BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
> -			if (!exchange) {
> -				memcpy(dentry->d_iname, target->d_name.name,
> -						target->d_name.len + 1);
> -				dentry->d_name.hash_len = target->d_name.hash_len;
> -				return;
> -			}
>  			for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
>  				swap(((long *) &dentry->d_iname)[i],
>  				     ((long *) &target->d_iname)[i]);

Presumably the write_seqcount_begin() prevents confusion from ephemeral
names...

> @@ -2422,6 +2434,22 @@ static void switch_names(struct dentry *dentry, struct dentry *target,
>  	swap(dentry->d_name.hash_len, target->d_name.hash_len);
>  }
> 
> +static void copy_name(struct dentry *dentry, struct dentry *target)
> +{
> +	struct ext_name *old_name = ext_name(dentry);
> +	if (unlikely(dname_external(target))) {
> +		atomic_inc(&ext_name(target)->count);

I might be missing something, but I believe that the above needs to
be atomic_add_unless().

Might also need to be in an RCU read-side critical section, but I am not
so sure about that.  If it is not in an RCU read-side critical section,
I don't see how the kfree_rcu() knows how long to wait before freeing
the name.

> +		dentry->d_name = target->d_name;
> +	} else {
> +		memcpy(dentry->d_iname, target->d_name.name,
> +				target->d_name.len + 1);
> +		dentry->d_name.name = dentry->d_iname;
> +		dentry->d_name.hash_len = target->d_name.hash_len;
> +	}
> +	if (unlikely(old_name) && likely(atomic_dec_and_test(&old_name->count)))
> +		kfree_rcu(old_name, head);
> +}
> +
>  static void dentry_lock_for_move(struct dentry *dentry, struct dentry *target)
>  {
>  	/*
> @@ -2518,7 +2546,10 @@ static void __d_move(struct dentry *dentry, struct dentry *target,
>  	}
> 
>  	/* Switch the names.. */
> -	switch_names(dentry, target, exchange);
> +	if (exchange)
> +		swap_names(dentry, target);
> +	else
> +		copy_name(dentry, target);
> 
>  	/* ... and switch them in the tree */
>  	if (IS_ROOT(dentry)) {
> 

