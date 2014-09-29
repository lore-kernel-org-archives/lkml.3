Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaI2PEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:04:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52650 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbaI2PEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:04:49 -0400
Date: Mon, 29 Sep 2014 16:04:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140929150445.GE7996@ZenIV.linux.org.uk>
References: <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
 <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
 <20140926164442.GA26897@ZenIV.linux.org.uk>
 <20140927044555.GS7996@ZenIV.linux.org.uk>
 <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
 <20140927183139.GT7996@ZenIV.linux.org.uk>
 <20140927191657.GU7996@ZenIV.linux.org.uk>
 <20140928074747.GZ7996@ZenIV.linux.org.uk>
 <20140929131613.GL5015@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929131613.GL5015@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 06:16:13AM -0700, Paul E. McKenney wrote:

> The "textbook" approach is to avoid starting the grace period until
> the after the final reference count is dropped (and of course after
> the name has been made inaccessible to all readers).  Not sure what
> the best way to adapt the current code to this approach (if it is
> in fact feasible to begin with), but one approach would be something
> like this:

> static void __d_free(struct rcu_head *head)
> {
> 	struct dentry *dentry = container_of(head, struct dentry, d_u.d_rcu);
> 
> 	WARN_ON(!hlist_unhashed(&dentry->d_alias));
> 	if (dname_external(dentry) && atomic_dec_return(&dentry->refcnt))
> 		call_rcu(&dentry->rh, __d_free_name_rcu);
> 	kmem_cache_free(dentry_cache, dentry); 
> }
> 
> Of course, this means that the link side has to do something like
> atomic_add_unless(&&dentry->refcnt, 1, 0), and create a new name
> if the old one is on its way out.  If that is too painful, another

What do you mean, "link"?  Rename, perhaps?

> approach is to increment the count for the grace period and decrement
> it at the end of the grace period, and to skip the free if non-zero
> after that decrement.  And this means adding an rcu_head to the
> qstr structure, which might not help memory footprint.

> Presumably the write_seqcount_begin() prevents confusion from ephemeral
> names...

We hold rename_lock, so __d_move() is serialized.  *And* both arguments
are pinned, so they couldn't have reached free_dentry() yet.

> > +static void copy_name(struct dentry *dentry, struct dentry *target)
> > +{
> > +	struct ext_name *old_name = ext_name(dentry);
> > +	if (unlikely(dname_external(target))) {
> > +		atomic_inc(&ext_name(target)->count);
> 
> I might be missing something, but I believe that the above needs to
> be atomic_add_unless().

It would better not; both dentry and target are pinned.

> Might also need to be in an RCU read-side critical section, but I am not
> so sure about that.  If it is not in an RCU read-side critical section,
> I don't see how the kfree_rcu() knows how long to wait before freeing
> the name.

It is a *writer*, not reader.  Readers of ->d_name are either under
rcu_read_lock(), or have hard exclusion wrt that __d_move() one way or another
and hold a reference to dentry, preventing dentry_free().  We really
need to care only about the ones under rcu_read_lock(), so kfree_rcu()
will do.  Non-RCU readers are relying on something like "I'm holding
a reference to dentry and ->i_mutex on the parent directory or
->s_vfs_rename_mutex on the entire filesystem".  Or "I'm holding that
reference and I know that on this filesystem nothing could lead to
d_move() and friends".

Anyway, see followup to that patch; it's equivalent to this one, but instead
of separately delayed freeing of dentry and ext name it makes __d_free()
free just the dentry itself and __d_free_ext() freeing both.  With
free_dentry() choosing which one to call_rcu().

FWIW, the thing I had been worrying about turned out to be a red herring (for
the same reason why RCU list removals don't need barriers - call_rcu() acts
as a barrier, so that reader managing to see the old pointer after
rcu_read_lock() will be seen by call_rcu() from writer, making the callback
delayed until that reader does rcu_read_unlock(); AFAICS, that's guaranteed
by smp_mb() in __call_rcu()).  However, the readers are, indeed, in trouble.
Already.  There's a data dependency - we want to make sure that the string
we observe via ->d_name.name is NUL-terminated.  We have dentry allocation
doing this
        dname[name->len] = 0;

        /* Make sure we always see the terminating NUL character */
        smp_wmb();
        dentry->d_name.name = dname;
and dentry_cmp() (one of the RCU readers) has
        cs = ACCESS_ONCE(dentry->d_name.name);
        smp_read_barrier_depends();
before looking at the string itself.  However, another such reader
(prepend_name()) doesn't - it just does ACCESS_ONCE() and assumes that
store of terminating NUL will be seen.  AFAICS, not guaranteed on Alpha,
so we need the same smp_read_barrier_depends() there.

Another thing: dentry_free() is called only when all non-RCU readers can't
see the dentry.  So that's where we need to decrement the refcount of ext
name, AFAICS.  Same in copy_name() (from __d_move()) where we lose the
reference to old name.  Again, non-RCU readers are not a problem - they
have exclusion wrt __d_move().  For them it's atomic.

Refcount is equal to the number of dentries visible to non-RCU readers with
->d_name.name pointing to that external name.  Freeing isn't scheduled until
that reaches 0 and is done via kfree_rcu() (or, in the later version of patch,
kfree_rcu() on one path and call_rcu() on another)...
