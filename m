Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaE2DLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:11:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54697 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaE2DLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:11:53 -0400
Date: Thu, 29 May 2014 04:11:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140529031149.GE18016@ZenIV.linux.org.uk>
References: <20140527014054.GR18016@ZenIV.linux.org.uk>
 <20140527031415.GS18016@ZenIV.linux.org.uk>
 <20140527040026.GT18016@ZenIV.linux.org.uk>
 <20140527070409.GA1801@lahna.fi.intel.com>
 <20140528031955.GW18016@ZenIV.linux.org.uk>
 <20140528073751.GB1757@lahna.fi.intel.com>
 <20140528115701.GY18016@ZenIV.linux.org.uk>
 <20140528131136.GA1643@lahna.fi.intel.com>
 <20140528141937.GZ18016@ZenIV.linux.org.uk>
 <20140528183954.GA18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528183954.GA18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 07:39:54PM +0100, Al Viro wrote:

> OK, the warnings about averting your eyes very much apply; the thing below
> definitely needs more massage before it becomes acceptable (and no, it's
> not a single commit; I'm not that insane), but it changes behaviour in the
> way described above.  Could you check if the livelock persists with it?
> No trace-generating code in there, so the logs should be compact enough...

Here's an updated patch, hopefully slightly less vomit-inducing.  Should
give the same behaviour as the previous one...  Again, it's a cumulative
diff - I'm still massaging the splitup here.

BTW, there's an interesting potential gotcha for ->d_delete() instances -
it *is* possible to have it called several times (returning true every
time it's called) for the same dentry.  Suppose dput() is called and
races with d_find_alias().  We get the following sequence:
CPU1:	dput sees d_count about to reach 0
CPU1:	dput grabs ->d_lock
CPU1:	dput calls ->d_delete() and gets told that it shouldn't survive
CPU2:	d_find_alias() grabs ->i_lock
CPU1:	dput calls dentry_kill()
CPU1:	dentry_kill() tries to grab ->i_lock and fails
CPU2:	d_find_alias() calls __d_find_alias()
CPU1:	dentry_kill() drops ->d_lock and returns the same dentry
CPU2:	__d_find_alias() finds our dentry, grabs ->d_lock and bumps ->d_count
CPU1:	dput() finds ->d_count greater than 1, decrements it and returns
CPU2:   eventually calls dput(), leading to another call of ->d_delete().
Moral: don't assume that ->d_delete() returning 1 means that dentry won't
survive; it's not a good place to destroy any data structures, etc.
Fortunately, we have only 11 instances in the tree and only one has code
making that assumption, the code in question being ifdefed out (lustre ;-/)
Out-of-tree folks might easily step into that trap, so it's probably worth
documenting - the comment in ll_ddelete() seems to indicate that its authors
had only noticed the problem with locking environment, not that it is the
wrong place for such code in the first place...

diff --git a/fs/dcache.c b/fs/dcache.c
index 42ae01e..6c2a92e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -441,42 +441,12 @@ void d_drop(struct dentry *dentry)
 }
 EXPORT_SYMBOL(d_drop);
 
-/*
- * Finish off a dentry we've decided to kill.
- * dentry->d_lock must be held, returns with it unlocked.
- * If ref is non-zero, then decrement the refcount too.
- * Returns dentry requiring refcount drop, or NULL if we're done.
- */
-static struct dentry *
-dentry_kill(struct dentry *dentry, int unlock_on_failure)
-	__releases(dentry->d_lock)
+static void __dentry_kill(struct dentry *dentry)
 {
-	struct inode *inode;
 	struct dentry *parent = NULL;
 	bool can_free = true;
-
-	if (unlikely(dentry->d_flags & DCACHE_DENTRY_KILLED)) {
-		can_free = dentry->d_flags & DCACHE_MAY_FREE;
-		spin_unlock(&dentry->d_lock);
-		goto out;
-	}
-
-	inode = dentry->d_inode;
-	if (inode && !spin_trylock(&inode->i_lock)) {
-relock:
-		if (unlock_on_failure) {
-			spin_unlock(&dentry->d_lock);
-			cpu_relax();
-		}
-		return dentry; /* try again with same dentry */
-	}
 	if (!IS_ROOT(dentry))
 		parent = dentry->d_parent;
-	if (parent && !spin_trylock(&parent->d_lock)) {
-		if (inode)
-			spin_unlock(&inode->i_lock);
-		goto relock;
-	}
 
 	/*
 	 * The dentry is now unrecoverably dead to the world.
@@ -520,10 +490,41 @@ relock:
 		can_free = false;
 	}
 	spin_unlock(&dentry->d_lock);
-out:
 	if (likely(can_free))
 		dentry_free(dentry);
+}
+
+/*
+ * Finish off a dentry we've decided to kill.
+ * dentry->d_lock must be held, returns with it unlocked.
+ * If ref is non-zero, then decrement the refcount too.
+ * Returns dentry requiring refcount drop, or NULL if we're done.
+ */
+static struct dentry *dentry_kill(struct dentry *dentry)
+	__releases(dentry->d_lock)
+{
+	struct inode *inode = dentry->d_inode;
+	struct dentry *parent = NULL;
+
+	if (inode && unlikely(!spin_trylock(&inode->i_lock)))
+		goto failed;
+
+	if (!IS_ROOT(dentry)) {
+		parent = dentry->d_parent;
+		if (unlikely(!spin_trylock(&parent->d_lock))) {
+			if (inode)
+				spin_unlock(&inode->i_lock);
+			goto failed;
+		}
+	}
+
+	__dentry_kill(dentry);
 	return parent;
+
+failed:
+	spin_unlock(&dentry->d_lock);
+	cpu_relax();
+	return dentry; /* try again with same dentry */
 }
 
 /* 
@@ -579,7 +580,7 @@ repeat:
 	return;
 
 kill_it:
-	dentry = dentry_kill(dentry, 1);
+	dentry = dentry_kill(dentry);
 	if (dentry)
 		goto repeat;
 }
@@ -797,8 +798,26 @@ static void shrink_dentry_list(struct list_head *list)
 	struct dentry *dentry, *parent;
 
 	while (!list_empty(list)) {
+		struct inode *inode;
 		dentry = list_entry(list->prev, struct dentry, d_lru);
+
+		parent = NULL;
 		spin_lock(&dentry->d_lock);
+		if (!IS_ROOT(dentry)) {
+			parent = dentry->d_parent;
+			if (unlikely(!spin_trylock(&parent->d_lock))) {
+				spin_unlock(&dentry->d_lock);
+				parent = NULL;
+				read_seqlock_excl(&rename_lock);
+				if (!IS_ROOT(dentry)) {
+					parent = dentry->d_parent;
+					spin_lock(&parent->d_lock);
+				}
+				read_sequnlock_excl(&rename_lock);
+				spin_lock(&dentry->d_lock);
+			}
+		}
+
 		/*
 		 * The dispose list is isolated and dentries are not accounted
 		 * to the LRU here, so we can simply remove it from the list
@@ -812,26 +831,32 @@ static void shrink_dentry_list(struct list_head *list)
 		 */
 		if ((int)dentry->d_lockref.count > 0) {
 			spin_unlock(&dentry->d_lock);
+			if (parent)
+				spin_unlock(&parent->d_lock);
 			continue;
 		}
 
-		parent = dentry_kill(dentry, 0);
-		/*
-		 * If dentry_kill returns NULL, we have nothing more to do.
-		 */
-		if (!parent)
+		if (unlikely(dentry->d_flags & DCACHE_DENTRY_KILLED)) {
+			bool can_free = dentry->d_flags & DCACHE_MAY_FREE;
+			spin_unlock(&dentry->d_lock);
+			if (parent)
+				spin_unlock(&parent->d_lock);
+			if (can_free)
+				dentry_free(dentry);
 			continue;
+		}
 
-		if (unlikely(parent == dentry)) {
-			/*
-			 * trylocks have failed and d_lock has been held the
-			 * whole time, so it could not have been added to any
-			 * other lists. Just add it back to the shrink list.
-			 */
+		inode = dentry->d_inode;
+		if (inode && unlikely(!spin_trylock(&inode->i_lock))) {
 			d_shrink_add(dentry, list);
 			spin_unlock(&dentry->d_lock);
+			if (parent)
+				spin_unlock(&parent->d_lock);
 			continue;
 		}
+
+		__dentry_kill(dentry);
+
 		/*
 		 * We need to prune ancestors too. This is necessary to prevent
 		 * quadratic behavior of shrink_dcache_parent(), but is also
@@ -840,7 +865,7 @@ static void shrink_dentry_list(struct list_head *list)
 		 */
 		dentry = parent;
 		while (dentry && !lockref_put_or_lock(&dentry->d_lockref))
-			dentry = dentry_kill(dentry, 1);
+			dentry = dentry_kill(dentry);
 	}
 }
 
