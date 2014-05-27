Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaE0BlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:41:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49470 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaE0Bk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:40:58 -0400
Date: Tue, 27 May 2014 02:40:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140527014054.GR18016@ZenIV.linux.org.uk>
References: <20140526093741.GA1765@lahna.fi.intel.com>
 <20140526135746.GM18016@ZenIV.linux.org.uk>
 <20140526142948.GA1685@lahna.fi.intel.com>
 <20140526152703.GN18016@ZenIV.linux.org.uk>
 <CA+55aFyz1oQQ+uz9DPSEmYBBby1VKTRFz81mTt3mVSLN+tMK+A@mail.gmail.com>
 <20140526182644.GP18016@ZenIV.linux.org.uk>
 <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 01:24:52PM -0700, Linus Torvalds wrote:
> Two things.
> 
> (1) The facts.
> 
> Just check the callchains on every single CPU in Mika's original email.

Point.

> (2) The code.
> 
> Yes, the whole looping over the dentry tree happens in other places
> too, but shrink_dcache_parents() is already called under s_umount

But that one's not true.  shrink_dcache_parent() is called from all kinds
of places, and it isn't guaranteed to be serialized at all.
For example, d_invalidate() will do it, and I wouldn't be surprised
to see it called in environment where we see shitloads of ->d_revalidate()
hitting dentries that ought to be invalidated.  In fact, unless we have
something mounted under sysfs, those calls of check_submounts_and_drop()
will be followed by d_invalidate().

> > I really, really wonder WTF is causing that - we have spent 20-odd
> > seconds spinning while dentries in there were being evicted by
> > something.  That - on sysfs, where dentry_kill() should be non-blocking
> > and very fast.  Something very fishy is going on and I'd really like
> > to understand the use pattern we are seeing there.
> 
> I think it literally is just a livelock. Just look at the NMI
> backtraces for each stuck CPU: most of them are waiting for the dentry
> lock in d_walk(). They have probably all a few dentries on their own
> list. One of the CPU is actually _in_ shrink_dentry_list().
> 
> Now, the way our ticket spinlocks work, they are actually fair: which
> means that I can easily imagine us getting into a pattern, where if
> you have the right insane starting conditions, each CPU will basically
> get their own dentry list.
> 
> That said, the only way I can see that nobody ever makes any progress
> is if somebody as the inode locked, and then dentry_kill() turns into
> a no-op. Otherwise one of those threads should always kill one or more
> dentries, afaik. We do have that "trylock on i_lock, then trylock on
> parent->d_lock", and if either of those fails, drop and re-try loop. I
> wonder if we can get into a situation where lots of people hold each
> others dentries locks sufficiently that dentry_kill() just ends up
> failing and looping..

Umm...  Let me see if I understood you correctly - you think that it's
shrink_dentry_list() cycling through a bunch of dentries, failing trylocks
on all of them due to d_walk() from other threads that keeps hitting ->d_lock
on parents (->i_lock is less likely, AFAICS).  Then we move the sucker
to the end of shrink list and try the next one, ad infinitum.  And those
d_walk() callers keep looping since they keep finding those dentries and
nothing else...  Right?

It looks plausible, but I doubt that serializing check_submounts_and_drop()
will suffice - shrink_dcache_parent() is just as unpleasant and it *is*
triggered in the same situations.  Moreover, the lack of loop in memory
shrinkers doesn't help - we might get shrink_dentry_list() from one of
those and loops that keep calling d_walk() from check_submounts_and_drop()
or shrink_dcache_parent()...

> Anyway, I'd like Mika to test the stupid "let's serialize the dentry
> shrinking in check_submounts_and_drop()" to see if his problem goes
> away. I agree that it's not the _proper_ fix, but we're damn late in
> the rc series..

That we are...  FWIW, if the nastiness matches the description above,
the right place to do something probably would be when those two
suckers get positive return value from d_walk() along with an empty
shrink list.  I wonder if we should do down_read() in shrink_dentry_list()
and down_write();up_write() in that case in shrink_dcache_parent() and
check_submounts_and_drop().  How about the following?

diff --git a/fs/dcache.c b/fs/dcache.c
index 42ae01e..72f2c95 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -795,7 +795,14 @@ EXPORT_SYMBOL(d_prune_aliases);
 static void shrink_dentry_list(struct list_head *list)
 {
 	struct dentry *dentry, *parent;
+	static DECLARE_RWSEM(shrink_sem);
 
+	if (unlikely(list_empty(list))) {
+		down_write(&shrink_sem);
+		up_write(&shrink_sem);
+		return;
+	}
+	down_read(&shrink_sem);
 	while (!list_empty(list)) {
 		dentry = list_entry(list->prev, struct dentry, d_lru);
 		spin_lock(&dentry->d_lock);
@@ -842,6 +849,7 @@ static void shrink_dentry_list(struct list_head *list)
 		while (dentry && !lockref_put_or_lock(&dentry->d_lockref))
 			dentry = dentry_kill(dentry, 1);
 	}
+	up_read(&shrink_sem);
 }
 
 static enum lru_status
@@ -923,7 +931,8 @@ long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan,
 
 	freed = list_lru_walk_node(&sb->s_dentry_lru, nid, dentry_lru_isolate,
 				       &dispose, &nr_to_scan);
-	shrink_dentry_list(&dispose);
+	if (!list_empty(&dispose))
+		shrink_dentry_list(&dispose);
 	return freed;
 }
 
@@ -966,7 +975,8 @@ void shrink_dcache_sb(struct super_block *sb)
 			dentry_lru_isolate_shrink, &dispose, UINT_MAX);
 
 		this_cpu_sub(nr_dentry_unused, freed);
-		shrink_dentry_list(&dispose);
+		if (!list_empty(&dispose))
+			shrink_dentry_list(&dispose);
 	} while (freed > 0);
 }
 EXPORT_SYMBOL(shrink_dcache_sb);
@@ -1341,8 +1351,7 @@ int check_submounts_and_drop(struct dentry *dentry)
 		d_walk(dentry, &data, check_and_collect, check_and_drop);
 		ret = data.found;
 
-		if (!list_empty(&data.dispose))
-			shrink_dentry_list(&data.dispose);
+		shrink_dentry_list(&data.dispose);
 
 		if (ret <= 0)
 			break;
