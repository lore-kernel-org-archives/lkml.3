Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaJBKfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:35:33 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:49119 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJBKfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:35:31 -0400
Date: Thu, 2 Oct 2014 05:35:26 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mikhail Efremov <sem@altlinux.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames
 unconditionally.
Message-ID: <20141002053526.2c31afdd@as>
In-Reply-To: <20141001001615.GT7996@ZenIV.linux.org.uk>
References: <20140924201813.GI7996@ZenIV.linux.org.uk>
	<20140925044601.GL7996@ZenIV.linux.org.uk>
	<20140926164442.GA26897@ZenIV.linux.org.uk>
	<20140927044555.GS7996@ZenIV.linux.org.uk>
	<CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
	<20140927183139.GT7996@ZenIV.linux.org.uk>
	<20140927191657.GU7996@ZenIV.linux.org.uk>
	<20140928074747.GZ7996@ZenIV.linux.org.uk>
	<20140928180556.GA7996@ZenIV.linux.org.uk>
	<20140929184218.GN5015@linux.vnet.ibm.com>
	<20141001001615.GT7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014 01:16:15 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

Can we get the below added somewhere in Documentation/filesystems/ ? I
don't see anything there that covers all this.

> 
> Huh?  copy_name() does copy a _reference_, not the name itself.  All the
> copying involved is source->d_name.name = target->d_name.name.  And those
> are simply unsigned char *.
> 
> write_seqcount_begin() is irrelevant here.  Look: all callers of
> __d_move(x, y) are holding references both to x and y.  Contributing to
> the refcount of dentries themselves, that is, not the names.
> 
> That gives exclusion between __d_move() and free_dentry() - the latter cannot
> be called until dentry refcount reaches zero.  RCU is completely irrelevant
> here.  In fact, no call chain leads to __d_move() under rcu_read_lock().
> You must hold the target dentry hard, or it could simply be freed right
> under you.
> 
> And __d_move() is taking ->d_lock on all dentries involved (in
> addition to rename_lock serializing it system-wide).
> 
> What could possibly lead to refcount zero being observed on target of
> __d_move()?  The history of any dentry is this:
> 	* it is created by __d_alloc().  Nobody can see it until __d_alloc()
> returns.  Dentry refcount (not to be confused with refcount of external
> name) is 1.
> 	* it passes through some (usually - zero) __d_move() calls.
> Some - as the first argument, some - as the second one.  All those
> calls are serialized by global seqlock - callers must hold rename_lock.
> And all of them are done by somebody who is holding a counting reference
> to dentries in question.
> 	* counting references to dentry might be taken and dropped;
> eventually refcount reaches zero (under ->d_lock) and no further
> counting references can be taken after that.  See __dentry_kill() - the
> first thing it does is poisoning the refcount, so that any future
> attempt to increment it would fail.  __dentry_kill() (still under ->d_lock
> of dentry, ->d_lock of its parent and ->i_lock of its inode) removes
> dentry from the tree, from hash and from the alias list of inode;
> Then it drops the locks.  At that point the only search structure dentry
> might be found in is shrink list; if it's not on such list, free_dentry()
> is called immediately, otherwise it's marked so that the code processing
> the shrink list in question would, as soon as it gets to that sucker,
> remove it from the shrink list and call the same free_dentry().  And that's
> the only thing done to such dentry by somebody finding it via a shrink list.
> 	* once free_dentry() has been reached, dentry can can be only seen
> by RCU lookups, and after the grace period ends it gets physically freed.
> 
> free_dentry() isn't allowed to overlap __d_move(); to have that happen is
> a serious dentry refcounting bug.  No __d_move() is allowed _after_
> free_dentry() has been entered, either.  Again, it would take a refcounting
> bug for dentries to have that happen - basically, double dput() somewhere.
> If that happens, all bets are off, of course - if dentry gets unexpectedly
> freed under somebody who has grabbed a reference to it and has not dropped
> it yet, we are fucked.
> 
> Nothing outside of __d_move() is allowed to change ->d_name.name.  RCU-critical
> code is allowed to fetch and dereference it, and such code relies upon
> 	a) freeing of name seen by somebody who'd done rcu_read_lock() being
> delayed until after the matching rcu_read_unlock()
> 	b) store of terminating NUL done by __d_alloc() (and never overwritten
> afterwards) being seen by RCU-critical code that has found the pointer to
> that name in dentry->d_name.name
> 
> All other code accessing ->d_name.name is required to hold one of the locks
> that are held by __d_move() and its callers.  Grabbing any of those leads
> to smp_mb() on alpha, which serves as data dependency barrier there, so
> we don't need explicit barrier there as we do in RCU-critical places - guarding
> NUL will be seen.
