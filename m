Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab3DDIC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:02:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46896 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369Ab3DDICw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:02:52 -0400
Date: Thu, 4 Apr 2013 09:02:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: linux-next: manual merge of the akpm tree with the vfs tree
Message-ID: <20130404080248.GN21522@ZenIV.linux.org.uk>
References: <20130404172648.27834d12cbb68338f4b89482@canb.auug.org.au>
 <20130403235634.6bc72c39.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130403235634.6bc72c39.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 11:56:34PM -0700, Andrew Morton wrote:
> On Thu, 4 Apr 2013 17:26:48 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Andrew,
> > 
> > Today's linux-next merge of the akpm tree got a conflict in
> > fs/proc/generic.c between several commits from the vfs tree and commit
> > "procfs: improve scaling in proc" from the akpm tree.
> > 
> > I just dropped the akpm tree patch (and the following
> > "procfs-improve-scaling-in-proc-v5") as the conflicts are a bit complex.
> 
> Well perhaps the vfs tree should start paying some attention to the
> rest of the world, particularly after -rc5.

I'm sorry, but... not in this case.  There are seriously nasty races around
remove_proc_entry()/proc_reg_release() and the whole area needs a rewrite.
Tentative fix is in vfs.git#experimental; I hadn't pushed it into #for-next
yet, but Nathan's patches are definitely going to buggered by any realistic
solution.  For now I'm going for the dumbest variant possible; ->pde_users
will eventually become atomic_t, but it'll be modified by
atomic_inc_unless_negative(), not atomic_inc() and ->proc_fops won't be
zeroed at all.  But before we do that, I want to get that sucker tested and
stabilized - the whole thing is sufficiently convoluted for those races to
stay unnoticed for a long time in the first place.

I am aware of those patches; it's just that they'll need to be redone - the
code being optimized is broken and needs to be fixed.  Longer term, I want
to lift the whole thing into VFS proper; it *can* be done with minimal
overhead and it'll get us a large part of revoke(2) if done right.  Basically,
what I want is a pair of new types - struct revoke and struct revokable.
	* struct file gets a pointer to struct revoke; set in ->open() by
file_revokable(file, revokable) and never changed afterwards.  No locking
is needed to check it.
	* struct revoke contains a pointer back to struct file (never changed)
+ pointer to struct revokable (RCU-protected, zeroed on revoke) + mutex/count
(serializes __fput() vs. revoke() deciding who's going to call ->release() and
who'll be waiting; see pdeo->mutex and pdep->count in #experimental) + cyclic
list anchored in struct revokable (list_del_init() after ->release() had been
done, under revoke->mutex and revokable->lock).
	* struct revokable contains an anchor for aforementioned cyclic
list + spinlock + atomic_t in_use (a-la pde->pde_users) + pointer to
completion + one method (->kick(); see below).  Freed via RCU.
	* start_using(file) is an inlined helper, returning true if
file->f_revoke is NULL; if it's not NULL, we do rcu_read_lock() and look
at file->f_revoke->revokable.  If it's NULL - rcu_read_unlock() and return
false (file had been revoked).  If it's not, atomic_inc_unless_negative()
of revokable->in_use.  Then rcu_read_unlock() and return - true if
->in_use used to be non-negative (file not revoked, revoke will wait) and
false if it was negative (file in process of being revoked).
	* stop_using(file) - inlined helper, does nothing if file->f_revoke
is NULL, otherwise decrements revokable->in_use and if it's reached
BIAS (large negative), complete(revokable->completion).
	* all normal method calls (everything except ->release()) are
turned into
	if (likely(start_using(file)) {
		res = method call
		stop_using(file);
	} else {
		res = <appropriate for method>;
	}
Overhead for non-revokable files is trivial - we just check one field in
struct file and if it's in the same cacheline as ->f_op, we are not going
to see any real delays.
	* new helper - release_revoke(); similar to close_pdeo() in
vfs.git#experimenatal.  __fput() checks ->f_revoke and, if that sucker's
non-NULL, does rcu_read_lock(), checks ->revokable, grabs ->lock on it
and does release_revoke().  If ->f_revoke is NULL, call ->release() as
we do now.  Note that unlike struct pde_opener, these guys would be
created with ->count equal to 1 - IOW, file->f_revoke would contribute to it.
	* do_revoke(revokable) starts with setting ->completion and adding
BIAS to ->in_use; if it non-zero prior to that, call ->kick(revokable) and
wait for completion.  ->kick() should essentially wake up those who are
sleeping in ->read() or ->write() and make them return, be it with EAGAIN
or short read/write.  Empty for procfs, for something like TTY it should
imitate hangup.  That's where driver-specific logics in revoke(2) would
live.  Once do_revoke() has finished waiting, we know that nobody is in
method calls (except possibly ->release()) and nobody will manage to enter
them from now on.  We grab ->lock, pick the first struct revoke from the
list, do release_revoke() to it and keep doing that to these guys until
none is left.

procfs would have struct revokable embedded into proc_dir_entry, with
freeing of those guys RCUd.  It would have file_revokable() done in
proc_reg_open() (that would do allocation of struct revoke, adding it
to the cyclic list, etc.) and set ->f_op to ->proc_fops; no wrappers
needed anymore.  All file_operations instances fed to proc_create()
et.al. would lose ->owner - it's already not needed for those, actually.
remove_proc_entry()/remove_proc_subtree() would call do_revoke() on
everything we are removing.

Getting from there to working revoke(2) is probably not too hard; the
interesting part is what should we associate struct revokable with and
what should revoke(2) in progress do to new attempts to open the damn
device.  Hell knows - not sure what's the right semantics here.
