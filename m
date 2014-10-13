Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaJMG34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:29:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36576 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaJMG3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:29:51 -0400
Date: Mon, 13 Oct 2014 07:29:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] dealing with proc_ns_follow_link() and "namespace" dentries
Message-ID: <20141013062945.GX7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	proc_ns_follow_link() is unique among the ->follow_link() instances
in several respects, some of them violating general asserts expected by
all kinds of VFS code.

	First of all, it can lead to <vfsmount,dentry> pairs with dentry
being completely unrelated to vfsmount.  Suppose we bind such a symlink over
something else.  ->follow_link() is called with nd->path set to directory
we'd found the symlink in - after all, that's what the normal symlinks are
interpreted against.  The same symlink present in two different directories
can resolve to different places.  In this case we generate a dentry/inode in
procfs and combine that dentry with vfsmount of parent.  Which might be
completely unrelated to procfs.

	The thing is, procfs isn't a good match for those inodes either.
For one thing, they really don't give a damn which procfs instance are
they in - if anything, they should be associated with ns.  For another,
using procfs icache for looking them up (by really strange inumbers)
solves the problem only partially.  d_instantiate_unique(), used there in
attempt to keep dentries from breeding, does not do what you seem to expect
it to do.  Namely, it *never* picks an existing alias.  Why?  Because it
looks for aliases with the same ->d_parent (and name) as the dentry we'd
given it.  And that dentry comes from d_alloc_pseudo(), i.e. it has
itself for ->d_parent.  *All* aliases for those inodes happen that way.
IOW, none of them have the same ->d_parent, and d_instantiate_unique()
here is simply a fancy way to spin through all existing aliases and call
d_instantiate() on our new one.  Quick experiment:
main()
{
	int i;
	for (i = 0; i < 100000; i++) {
		open("/proc/self/ns/mnt", 0);
		if (!(i % 1000))
			system("grep dentry /proc/slabinfo");
}
run with ulimit -n 100000 and watch it create a new dentry per open().
Profile of that (sans system(3)) is also rather interesting -
each d_instantiate_unique() is O(N), so we spend a quadratic time in
that sucker for no good reason whatsoever.

If nothing else, d = d_find_any_alias(inode); if (d) {dput(dentry);return d;}
d_set_d_op(dentry, ...); d_instantiate(dentry, inode); return dentry; would be
a much better strategy - *this* would almost always find an alias when one is
to be found.  We might occasionally get more than one (when several processes
race), but that beats the hell out of easily getting millions of them...

But more fundamentally, this stuff has no business being in procfs.  The
*only* reason why we are putting them there (and get those inodes and
dentries duplicated for different procfs instances) is this in
do_loopback():
        if (!check_mnt(parent) || !check_mnt(old))
                goto out2;
You want to be able to bind those suckers by mount --bind.  Which is an
odd API design (and it gives you another headache from hell with mnt_ns_loop())
but it's too late to change, sadly ;-/  So you want ->follow_link() to
yield dentries matching some vfsmount in our namespace.  The things would be
much simpler if we didn't try that.

Look: do_loopback() is *already* aware of those suckers.  Has to be, due to
aforementioned mnt_ns_loop().  So we might as well weaken the constraints on
old - check_mnt(old) || proc_ns_inode(old_path.dentry->d_inode) would do.
The thing is, we calculate that proc_ns_inode() anyway.

Now, suppose we'd done that.  In principle, it allows some things that are
not allowed right now - you could open such file and pass it (via SCM_RIGHTS)
to a process in another namespace.  With the current tree you can't bind
that bugger via /proc/self/fd/<n> - it will have alien vfsmount.  After such
change it will become allowed.  Is there any problem with that?  I don't see
any (after all, recepient might have held it open and anyone who could
get to that sucker via /proc/<pid>/fd/<n> could've simply stopped the recepient
and made it pass the damn thing to them - being able to ptrace is enough
for that).  Am I missing anything?

*IF* we can get away with such change, everything becomes much easier.  We
can add a filesystem just for those guys - one for the entire system.  And
kern_mount() it.  Don't bother with register_filesystem() - no point showing
it in the /proc/filesystems, etc.  No need to abuse procfs inodes either.
Or procfs icache, for that matter.  All we need is a small standard piece
embedded into each {mnt,net,pid,user,...}ns.

Namely, let's stash a pointer to such dentry (if any) into that standard piece.
Not a counting reference, of course, and used in a very limited way.
	* have ->d_prune() for those guys replace the stashed pointer with NULL.
	* on the "get dentry for ns" side,
	again:
		rcu_read_lock()
		d = atomic_long_read(stashed pointer)
		if (!d)
			goto slow;
		if (!lockref_get_not_dead(&d->d_lockref))
			goto slow;
		rcu_read_unlock();
		return d;
	slow:
		rcu_read_unlock();
		allocate new inode
		allocate new dentry
		d_instantiate()
		d = atomic_long_cmpxchg(stashed pointer, NULL, new dentry);
		if (d) {
			dput(new dentry);
			cpu_relax();	// might not be needed
			goto again;
		}
		return new dentry;
I'd suggest having ->i_private point to that standard piece and storing
ns_ops and proc_inum in there.

That way we get rid of weird <vfsmount, dentry> pairs, untangle that crap from
procfs, get rid of polluting icache with the stuff that has no reason to be
there and get rid of pointless aliases.  Oh, and we get a decent chance to
kill d_instantiate_unique(), which is also nice.  Or at least fold it into
d_add_unique(), if we can't kill that sucker as well.  And if we manage to
kill it outright, we get rid of __d_instantiate_unique() for free - in my
local queue d_materialise_unique() had been subsumed by d_splice_alias(),
getting rid of the other caller of __d_instantiate_unique().  We have *WAY*
too many primitives in that area, and trimming that forest is definitely
a good thing.

Besides, that would allow to make struct nameidata completely opaque for
everything except fs/namei.c (by making nd_set_link() and nd_get_link()
exported instead of inlines).  The only obstacle to that is that damn
->follow_link() instance with its fondling of nd->path.mnt.  Would be nice
to get rid of that source of headache as well...

	It's obviously a project for the next cycle and it'll require
some cooperation between vfs and userns trees, but not too much of it -
all we really need is a never-changed commit embedding that structure into
all ...ns and passing _that_ to proc_{alloc,free}_inum() replacements
Merged both into vfs.git #for-next and usern one.  We can do that right
after -rc1.  Incidentally, it might make sense to move refcount into that
common piece as well, but that's independent from the stuff above.

	Comments?
