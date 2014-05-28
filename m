Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaE1Sj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:39:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53621 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaE1Sj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:39:58 -0400
Date: Wed, 28 May 2014 19:39:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140528183954.GA18016@ZenIV.linux.org.uk>
References: <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
 <20140527014054.GR18016@ZenIV.linux.org.uk>
 <20140527031415.GS18016@ZenIV.linux.org.uk>
 <20140527040026.GT18016@ZenIV.linux.org.uk>
 <20140527070409.GA1801@lahna.fi.intel.com>
 <20140528031955.GW18016@ZenIV.linux.org.uk>
 <20140528073751.GB1757@lahna.fi.intel.com>
 <20140528115701.GY18016@ZenIV.linux.org.uk>
 <20140528131136.GA1643@lahna.fi.intel.com>
 <20140528141937.GZ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528141937.GZ18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 03:19:37PM +0100, Al Viro wrote:

> OK, it's not ->i_lock, it's ->d_lock on parent being grabbed after that on
> child, while d_walk() keeps taking them in opposite order.  Hmm...
> 
> In principle we could do the following:
> 	* split dentry_kill() into the part that is taking locks and
> the rest of it.
> 	* in case of trylock failure have shrink_dentry_list() do
> read_seqlock_excl(&rename_lock) (which will stabilize ->d_parent) and
> take ->d_lock in the right order, drop rename_lock and call __dentry_kill().
> 
> AFAICS, that would kill the livelock for good.  We still have ->i_lock
> trylock failures to deal with, but those are less of a problem - d_walk()
> won't step on ->i_lock at all.  I'm going to grab a couple of hours of sleep
> and try to put together something along those lines...

OK, the warnings about averting your eyes very much apply; the thing below
definitely needs more massage before it becomes acceptable (and no, it's
not a single commit; I'm not that insane), but it changes behaviour in the
way described above.  Could you check if the livelock persists with it?
No trace-generating code in there, so the logs should be compact enough...

diff --git a/fs/dcache.c b/fs/dcache.c
index 42ae01e..ed0cc62 100644
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
@@ -520,10 +490,44 @@ relock:
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
+static struct dentry *
+dentry_kill(struct dentry *dentry, int unlock_on_failure)
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
+	if (unlock_on_failure) {
+		spin_unlock(&dentry->d_lock);
+		cpu_relax();
+	}
+	return dentry; /* try again with same dentry */
 }
 
 /* 
@@ -797,6 +801,7 @@ static void shrink_dentry_list(struct list_head *list)
 	struct dentry *dentry, *parent;
 
 	while (!list_empty(list)) {
+		struct inode *inode;
 		dentry = list_entry(list->prev, struct dentry, d_lru);
 		spin_lock(&dentry->d_lock);
 		/*
@@ -815,23 +820,52 @@ static void shrink_dentry_list(struct list_head *list)
 			continue;
 		}
 
-		parent = dentry_kill(dentry, 0);
-		/*
-		 * If dentry_kill returns NULL, we have nothing more to do.
-		 */
-		if (!parent)
+
+		if (unlikely(dentry->d_flags & DCACHE_DENTRY_KILLED)) {
+			bool can_free = dentry->d_flags & DCACHE_MAY_FREE;
+			spin_unlock(&dentry->d_lock);
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
 			continue;
 		}
+
+		if (IS_ROOT(dentry)) {
+			__dentry_kill(dentry);
+			continue;
+		}
+
+		parent = dentry->d_parent;
+		if (unlikely(!spin_trylock(&parent->d_lock))) {
+			if (inode)
+				spin_unlock(&inode->i_lock);
+			d_shrink_add(dentry, list);
+			spin_unlock(&dentry->d_lock);
+			read_seqlock_excl(&rename_lock);
+			parent = NULL;
+			if (!IS_ROOT(dentry)) {
+				parent = dentry->d_parent;
+				spin_lock(&parent->d_lock);
+			}
+			spin_lock(&dentry->d_lock);
+			read_sequnlock_excl(&rename_lock);
+			inode = dentry->d_inode;
+			if (inode && unlikely(!spin_trylock(&inode->i_lock))) {
+				if (parent)
+					spin_unlock(&parent->d_lock);
+				spin_unlock(&dentry->d_lock);
+				continue;
+			}
+			d_shrink_del(dentry);
+		}
+
+		__dentry_kill(dentry);
 		/*
 		 * We need to prune ancestors too. This is necessary to prevent
 		 * quadratic behavior of shrink_dcache_parent(), but is also
