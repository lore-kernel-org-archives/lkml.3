Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162674Ab3DET4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 15:56:15 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36396 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162636Ab3DET4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:56:13 -0400
Date: Fri, 5 Apr 2013 12:56:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC] revoke(2) and generic handling of things like
 remove_proc_entry()
Message-ID: <20130405195609.GA8745@kroah.com>
References: <20130405042932.GB4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405042932.GB4068@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 05:29:32AM +0100, Al Viro wrote:
> After some digging in procfs logics for revoking further file IO after
> remove_proc_entry() (and figuring out what to do for debugfs - it also
> needs something similar), I think I've got something that has potential
> to become a working revoke(2) with very low overhead.  It will require
> some preparations and there are several interesting questions regarding
> the semantics, but it looks like there's a decent chance of making it
> work:
> 	* procfs and debugfs - definitely can use it
> 	* sysfs - probably can switch to that from its home-grown mechanism

I agree.

> 	* tty hangup handling - might be possible to switch to that
> mechanism.

That would be very good.  Especially as isn't this "traditionally" the
only thing that revoke(2) would work on?

> 	* ALSA analog of hangup - ditto.
> 	* revoke(2) - would be nice; might be doable, depending on the
> degree of generality we want.

All character devices would be great to have from my end, as well as the
sysfs/procfs/debugfs/libfs items above.

> Below is an outline of implementation; discussion of the fun spots of
> semantics is in the very end.
> 
> Two new objects are introduced -
> 
> struct revokable {		// freeing of whatever contains it is RCU'd
> 	atomic_t in_use;		// number of threads in methods,
> 					// negative => going away

Which methods do you mean here?

> 	spinlock_t lock;
> 	hlist_head list;		// protected by ->lock, goes through
> 					// struct revoke->node.
> 	struct completion *c;
> 	void (*kick)(struct revokable *); // discussion in the end; NULL
> 					// for procfs and friends.
> };
> 
> struct revoke {			// per-file, lives until __fput()
> 	struct file *file;		// never changes
> 	struct revokable *revokable;	// RCU protected
> 	struct hlist_node list;		// protected by ->revokable->lock
> 	bool closing;			// ditto
> 	struct completion *c;		// ditto
> };
> 
> struct file gets a new field - struct revoke *f_revoke (next to ->f_op, never
> changes after open, usually NULL).

This looks reasonable.

> New helpers:
> 	int make_revokable(file, revokable) - to be used during ->open();
> it'll allocate file->f_revoke and associate it with revokable.  Should be
> the last thing done by ->open() (see below for discussion - that's
> one of the most inconvenient areas of this API)
> 	inline bool start_using(file) - called before file method calls
> except for ->release(); if it returns false, don't make a call, the
> file has been revoked.  Attempt to revoke will make sure no new
> users can appear (i.e. that start_using() will fail from now on) and
> wait until all of them are done.  What to do on start_using() failure
> is up to the caller - depends on the method (e.g. POLLERR is probably
> the right one for ->poll(), -EIO - for ->write(), 0 might be right for
> ->read(), etc.)

The vfs core would call start_using(), or would filesystems / drivers
need to do this?

> 	inline void stop_using(file) - called after the method call.

Which method?  The one that called start_using() first?  Makes sense.

> 	void release_revoke(revoke) - __fput() calls that instead of calling
> ->release() if file->f_revoke is non-NULL.
> 	void revoke_it(revokable) - revoke all files associated with this
> revokable; ->release() will be called on each of those files and no method
> calls will be issued after it returns.  No references to revokable will
> outlive the grace period.
> 
> static inline bool start_using(struct file *f)
> {
> 	struct revoke *revoke = f->f_revoke;
> 	if (likely(!revoke))
> 		return true;	/* non-revokable file */
> 	return __start_using(revoke);
> }
> 
> static inline void stop_using(struct file *f)
> {
> 	struct revoke *revoke = f->f_revoke;
> 	if (unlikely(revoke))
> 		__stop_using(revoke);
> 	}
> }
> 
> bool __start_using(struct revoke *revoke)
> {
> 	struct revokable *r;
> 	rcu_read_lock();
> 	r = rcu_dereference(revoke->revokable);
> 	if (unlikely(!r)) {
> 		rcu_read_unlock();
> 		return false;	/* revoked */
> 	}
> 	if (likely(atomic_inc_unless_negative(&r->in_use))) {
> 		rcu_read_unlock();
> 		return true;	/* we are using it now */
> 	}
> 	rcu_read_unlock();
> 	return false;		/* it's being revoked right now */
> }
> 
> #define BIAS <large negative constant>
> 
> void __stop_using(struct revoke *revoke)
> {
> 	struct revokable *r;
> 	r = rcu_dereference_protected(revoke->revokable, 1);
> 	BUG_ON(!r);
> 	if (atomic_dec_return(&r->in_use) == BIAS)
> 		complete(r->c);
> }
> 
> /* called with r->lock held by caller, unlocks it */
> static void __release_revoke(struct revokable *r, struct revoke *revoke)
> {
> 	if (revoke->closing) {
> 		DECLARE_COMPLETION_ONSTACK(c);
> 		revoke->c = &c;
> 		spin_unlock(&r->lock);
> 		wait_for_completion(&c);
> 	} else {
> 		struct file *file;
> 		revoke->closing = 1;
> 		spin_unlock(&r->lock);
> 		file = revoke->file;
> 		if (file->f_op->release)
> 			file->f_op->release(file_inode(file), file);
> 		spin_lock(&r->lock);
> 		hlist_del_init(&revoke->list);
> 		rcu_assign_pointer(revoke->revokable, NULL);
> 		rcu_read_lock();	/* prevent freeing of r */
> 		if (revoke->c)
> 			complete(revoke->c);
> 		spin_unlock(&r->lock);
> 		rcu_read_unlock();
> 	}
> }
> 
> void release_revoke(struct revoke *revoke)
> {
> 	struct revokable *r;
> 	rcu_read_lock();
> 	r = rcu_dereference(revoke->revokable);
> 	if (!r) {
> 		/* already closed by revokation */
> 		rcu_read_unlock();
> 		return;
> 	}
> 	spin_lock(&r->lock);
> 	if (unlikely(hlist_unhashed(&revoke->node))) {
> 		/* just been revoked */
> 		spin_unlock(&r->lock);
> 		rcu_read_unlock();
> 		return;
> 	}
> 	/*
> 	 * OK, revoke_it() couldn't have been finished yet
> 	 * it'll have to get r->lock before it's through, so
> 	 * we can drop rcu_read_lock
> 	 */
> 	rcu_read_unlock();
> 	__release_revoke(r, revoke);
> 	kfree(revoke);
> }
> 
> void revoke_it(struct revokable *r)
> {
> 	DECLARE_COMPLETION_ONSTACK(c);
> 	r->c = &c;
> 	if (atomic_add_return(BIAS, &r->in_use) != BIAS) {
> 		if (r->kick)
> 			r->kick(r);
> 		wait_for_completion(c);
> 	}
> 	while (1) {
> 		struct hlist_node *p;
> 		spin_lock(&r->lock);
> 		p = r->list.first;
> 		if (!p)
> 			break;
> 		__release_revoke(r, hlist_entry(p, struct revoke, list));
> 	}
> 	spin_unlock(&r->lock);
> }
> 
> int make_revokable(struct file *f, struct revokable *r)
> {
> 	struct revoke *revoke = kzalloc(sizeof(struct revoke), GFP_KERNEL);
> 	if (!revoke)
> 		return -ENOMEM;
> 	if (!atomic_inc_unless_negative(&r->in_use)) {
> 		kfree(revoke);
> 		return -ENOENT;
> 	}
> 	revoke->file = f;
> 	f->f_revoke = revoke;
> 	spin_lock(&r->lock);
> 	hlist_add_head(&revoke->list, &r->list);
> 	spin_unlock(&r->lock);
> 	__stop_using(revoke);
> 	return 0;
> }
> 
> procfs would have struct revokable embedded into proc_dir_entry, with
> freeing of those guys RCUd.  It would set ->f_op to ->proc_fops and
> call make_revokable(file, &pde->revokable) in proc_reg_open(); no wrappers
> for other methods needed anymore.  All file_operations instances fed to
> proc_create() et.al. would lose ->owner - it's already not needed for those,
> actually.  remove_proc_entry()/remove_proc_subtree() would call revoke_it()
> on everything we are removing.

debugfs could do the same, that sounds sane.

> Ugly spots and questions re semantics:
> 
> 1) ->open() instance calling make_revokable() would bloody better touch
> nothing after make_revokable() succeeds, since at that point struct file
> is visible to revoke_it() and ->release() may be called by it.

Reasonable constraint.

> 2) thou shalt not call revoke_it() from any methods of any file affected
> by it.  Deadlock for obvious reasons.  Do it asynchronously if you really
> need it.

Reasonable.

> 3) that ->kick() thing: for something like procfs it's a non-issue, but
> for anything like hangup/snd_card_disconnect/sys_revoke we'll need to
> supply that method.  It should terminate any indefinite waits for IO of
> the stuff sitting in ->read()/->write()/etc.

The tty layer should be able to handle this.

> 4) nasty semantics issue - mmap() vs. revoke (of any sort, including
> remove_proc_entry(), etc.).  Suppose a revokable file had been mmapped;
> now it's going away.  What should we do to its VMAs?  Right now sysfs
> and procfs get away with that, but only because there's only one thing
> that has ->mmap() there - /proc/bus/pci and sysfs equivalents.  I've
> no idea how does pci_mmap_page_range() interact with PCI hotplug (and
> I'm not at all sure that whatever it does isn't racy wrt device removal),

The page range should just start returning 0xff all over the place, the
BIOS should have kept the mapping around, as it can't really assign it
anywhere else, so all _should_ be fine here.

> but I suspect that it strongly depends on lack of ->fault() for those
> VMAs, which makes killing all PTEs pointing to pages in question enough.
> How generic do we want to make it?  Anybody wanting to add more files
> that could be mmapped in procfs/sysfs/debugfs deserves to be hurt, but
> if we start playing with revoke(2), restriction might become inconvenient.
> I'm not sure what kind of behaviour do we want there - *BSD at least
> used to have revoke(2) only for character devices that had no mmap()...

I think that's a reasonable constraint, although tearing down the VMAs
might be possible if we just invalidate the file handle "forcefully"
(i.e. manually tear them down and then further accesses should through a
SIGSEV fail, or am I missing something more basic here?)

> 5) another fun semantics question - what should revoke(2) do to open(2)
> happening before it completes?  In terms of implementation above, should
> we put a new struct revokable in place before we'd finished revoke_it()
> on the old one?

If we can do so race-free, yes, that makes sense.

> 6) how do we get from revoke(2) to call of revoke_it() on the right object?
> Note that revoke(2) is done by pathname; we might want an ...at() variant,
> but all we'll have to play with will be inode, not an opened file.

Can we make revoke(2) require a valid file handle?  Is there a POSIX
spec for revoke(2) that we have to follow here, or given that we haven't
had one yet, are we free to define whatever we want without people
getting that upset?

> We probably ought to put it into file_operations and use
> ->i_fop->revoke() to get there (with cdev_revoke() looking for
> relevant struct cdev, etc.).  Not sure; we'll probably need to play
> with different variants once the generic part of infrastructure is
> there.

Yeah, that's going to be tricky, but for cdevs we should be ok, I hope.

> 7) we need to reduce the number of places where we do ->f_op->something();
> it's not too horrible, but it's definitely more than I like.  ->read() and
> ->write() are the main offenders in that respect and many of those are in
> really ugly parts of tree...
> 
> 8) if we convert vhangup(2) to that mechanism, serial consoles are going to
> be a thing to watch out for.  Extra ->release() and...

I don't know if we can convert vhangup to revoke, but internally, it
might be close to the same thing, that will take some testing.

Anyway, I'm all for this, I've wanted a revoke() for a long time, and
have tried half-heartedly a number of times in the past, failing
everytime.  As this looks to solve a number of other issues we are
currently having elsewhere in some filesystems, that makes it even
better.

thanks,

greg k-h
