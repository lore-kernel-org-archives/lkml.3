Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbaD3PuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:50:07 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:56670 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122AbaD3PuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:50:03 -0400
Date: Wed, 30 Apr 2014 17:49:58 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>
References: <CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
 <20140429181610.GJ18016@ZenIV.linux.org.uk>
 <20140429191015.GK18016@ZenIV.linux.org.uk>
 <20140429211851.GA32204@dastard>
 <20140429214842.GL18016@ZenIV.linux.org.uk>
 <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
 <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430040436.GO18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430040436.GO18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 05:04:36AM +0100, Al Viro wrote:
> On Tue, Apr 29, 2014 at 07:56:13PM -0700, Linus Torvalds wrote:
> > On Tue, Apr 29, 2014 at 7:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > OK, aggregate diff follows, more readable splitup (3 commits) attached.
> > > It seems to survive beating here; testing, review and comments are
> > > welcome.
> > 
> > Miklos, did you have some particular load that triggered this, or was
> > it just some reports? It would be really good to get this patch some
> > stress-testing.
> > 
> > I like how the patch removes more lines than it adds, but apart from
> > that it's hard to read the patch (even the split-out ones) and say
> > anything more about it. I think this needs a *lot* of testing.
> 
> FWIW, the first two are really straightforward expanding the function
> into its only callsite.  The last needs more splitup.  Not sure if the
> following is good enough, but it ought to be at least somewhat cleaner.
> Combined change is identical to the original, so it doesn't invalidate
> the testing so far...

Hmm, patches look okay, but I'm wondering if we really need the morgue list and
the waiting.  Why not just skip dentries that are presently being handled by
dentry_kill()?

Thanks,
Miklos
---


From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 29 Apr 2014 23:52:05 -0400
Subject: Don't try to remove from shrink list we don't own

So far it's just been local equivalent transformations.  Now the meat of
that thing: dentry_kill() has two kinds of call sites - ones that had just
dropped the last reference (dput(), killing ancestors in
shrink_dentry_list()) and one where the victim had sat on shrink list with
zero refcount.  We already have a flag telling which kind it is
(unlock_on_failure).  What we want to do is to avoid d_shrink_del() in the
first kind of dentry_kill().  We do, however, want everything except the
actual freeing still done as we would in mainline.  So we need to deal with
two new situations - the first kind of dentry_kill() finding a dentry on
shrink list (result of laziness in dget(); we had it on shrink list with
refcount 1) and the second kind finding a dentry that is currently being
killed by the first kind.  What we do is this:

 - in the first kind of dentry_kill() we don't remove the dentry from the
   shrink list, this makes the shrink list really private to the shrinker
   functions

 - we proceed with the normal killing but only actually free the dentry if
   it's definitely not on the shrink list at this point.  If it's still on
   the shrink list set DCACHE_MAY_FREE and defer the freeing to
   shrink_dentry_list()

 - shrink_dentry_list() will detect if the dentry is killed with
   DCACHE_DENTRY_KILLED.  If DCACHE_MAY_FREE isn't yet set, just take the
   dentry off the shrink list and let the still running dentry_kill()
   finish it off.  If DCACHE_MAY_FREE is set, then free the dentry.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c            |   44 ++++++++++++++++++++++++++++++++++++++++++--
 include/linux/dcache.h |    2 ++
 2 files changed, 44 insertions(+), 2 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -469,6 +469,7 @@ dentry_kill(struct dentry *dentry, int u
 {
 	struct inode *inode;
 	struct dentry *parent;
+	bool can_free = true;
 
 	inode = dentry->d_inode;
 	if (inode && !spin_trylock(&inode->i_lock)) {
@@ -504,8 +505,10 @@ dentry_kill(struct dentry *dentry, int u
 	if (dentry->d_flags & DCACHE_LRU_LIST) {
 		if (!(dentry->d_flags & DCACHE_SHRINK_LIST))
 			d_lru_del(dentry);
-		else
+		else if (!unlock_on_failure)
 			d_shrink_del(dentry);
+		else
+			can_free = false;
 	}
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
@@ -527,7 +530,25 @@ dentry_kill(struct dentry *dentry, int u
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 
-	dentry_free(dentry);
+	if (unlikely(!can_free)) {
+		spin_lock(&dentry->d_lock);
+		/*
+		 * Could have gotten off the shrink list while not holding the
+		 * dcache lock.
+		 *
+		 * If still on the shrink list shrink_dentry_list will take care
+		 * of freeing it for us.  Signal this by setting the
+		 * DCACHE_MAY_FREE flag.
+		 */
+		if (!(dentry->d_flags & DCACHE_SHRINK_LIST))
+			can_free = true;
+		else
+			dentry->d_flags |= DCACHE_MAY_FREE;
+		spin_unlock(&dentry->d_lock);
+	}
+	if (likely(can_free))
+		dentry_free(dentry);
+
 	return parent;
 }
 
@@ -835,6 +856,25 @@ static void shrink_dentry_list(struct li
 		}
 		rcu_read_unlock();
 
+		if (unlikely(dentry->d_flags & DCACHE_DENTRY_KILLED)) {
+			bool free_it;
+			/*
+			 * This dentry has already been killed, but was stuck on
+			 * the shrink list.  It may be undergoing cleanup, in
+			 * which case let dput() finish it off.
+			 *
+			 * If it's already clean, dput() deferred freeing to us.
+			 */
+			free_it = (dentry->d_flags & DCACHE_MAY_FREE) != 0;
+			spin_unlock(&dentry->d_lock);
+
+			if (free_it)
+				dentry_free(dentry);
+
+			rcu_read_lock();
+			continue;
+		}
+
 		parent = dentry_kill(dentry, 0);
 		/*
 		 * If dentry_kill returns NULL, we have nothing more to do.
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -221,6 +221,8 @@ struct dentry_operations {
 #define DCACHE_SYMLINK_TYPE		0x00300000 /* Symlink */
 #define DCACHE_FILE_TYPE		0x00400000 /* Other file type */
 
+#define DCACHE_MAY_FREE			0x00800000
+
 extern seqlock_t rename_lock;
 
 static inline int dname_external(const struct dentry *dentry)
