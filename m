Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaE1DUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 23:20:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52269 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaE1DT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 23:19:59 -0400
Date: Wed, 28 May 2014 04:19:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140528031955.GW18016@ZenIV.linux.org.uk>
References: <20140526135746.GM18016@ZenIV.linux.org.uk>
 <20140526142948.GA1685@lahna.fi.intel.com>
 <20140526152703.GN18016@ZenIV.linux.org.uk>
 <CA+55aFyz1oQQ+uz9DPSEmYBBby1VKTRFz81mTt3mVSLN+tMK+A@mail.gmail.com>
 <20140526182644.GP18016@ZenIV.linux.org.uk>
 <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
 <20140527014054.GR18016@ZenIV.linux.org.uk>
 <20140527031415.GS18016@ZenIV.linux.org.uk>
 <20140527040026.GT18016@ZenIV.linux.org.uk>
 <20140527070409.GA1801@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527070409.GA1801@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:04:09AM +0300, Mika Westerberg wrote:
> On Tue, May 27, 2014 at 05:00:26AM +0100, Al Viro wrote:
> > On Tue, May 27, 2014 at 04:14:15AM +0100, Al Viro wrote:
> > 
> > > As the matter of fact, let's try this instead - retry the same sucker
> > > immediately in case if trylocks fail.  Comments?
> > 
> > Better yet, let's take "move back to shrink list" into dentry_kill()
> > itself.  Then we get consistent locking rules for dentry_kill() and
> > instead of unlock_on_failure we simply pass it NULL or the shrink
> > list to put the sucker back.  Mika, could you test this one and see
> > if it fixes that livelock?  The difference in behaviour is that in
> > case of trylock failure we hit that sucker again without letting
> > it ride all the way around the list, same as we do for other dentry_kill()
> > callers.
> 
> I tried this patch and unfortunately it still results the same sort of
> livelock. I've attached the dmesg.
> 
> I also tried the serialization patch from Linus and it seemed to fix the
> problem. After several rounds of USB memory stick plug/unplug I haven't
> seen a single "soft lockup" warning in dmesg.
> 
> I'm able to reproduce the problem pretty easily, so if you have
> something else to try I'm more than happy to give it a try.

Could you try this and post the resulting log?  I'd really like to understand
what's going on there - are we really hitting trylock failures there and what
dentries are involved.

diff --git a/fs/dcache.c b/fs/dcache.c
index 42ae01e..75f56a6 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -38,6 +38,7 @@
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
+#include <linux/magic.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -448,7 +449,7 @@ EXPORT_SYMBOL(d_drop);
  * Returns dentry requiring refcount drop, or NULL if we're done.
  */
 static struct dentry *
-dentry_kill(struct dentry *dentry, int unlock_on_failure)
+dentry_kill(struct dentry *dentry, struct list_head *shrink_list)
 	__releases(dentry->d_lock)
 {
 	struct inode *inode;
@@ -464,10 +465,10 @@ dentry_kill(struct dentry *dentry, int unlock_on_failure)
 	inode = dentry->d_inode;
 	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
-		if (unlock_on_failure) {
-			spin_unlock(&dentry->d_lock);
-			cpu_relax();
-		}
+		if (shrink_list)
+			d_shrink_add(dentry, shrink_list);
+		spin_unlock(&dentry->d_lock);
+		cpu_relax();
 		return dentry; /* try again with same dentry */
 	}
 	if (!IS_ROOT(dentry))
@@ -542,6 +543,14 @@ out:
  * on the compiler to always get this right (gcc generally doesn't).
  * Real recursion would eat up our stack space.
  */
+static inline void dump(const char *s, struct dentry *dentry)
+{
+	if (unlikely(dentry->d_sb->s_magic == SYSFS_MAGIC)) {
+		printk(KERN_ERR "%s[%pd4]; CPU %d PID %d [%s]\n",
+			s, dentry, smp_processor_id(),
+			task_pid_nr(current), current->comm);
+	}
+}
 
 /*
  * dput - release a dentry
@@ -579,7 +588,9 @@ repeat:
 	return;
 
 kill_it:
-	dentry = dentry_kill(dentry, 1);
+	if (dentry->d_inode)
+		dump("dput", dentry);
+	dentry = dentry_kill(dentry, NULL);
 	if (dentry)
 		goto repeat;
 }
@@ -798,6 +809,7 @@ static void shrink_dentry_list(struct list_head *list)
 
 	while (!list_empty(list)) {
 		dentry = list_entry(list->prev, struct dentry, d_lru);
+again:
 		spin_lock(&dentry->d_lock);
 		/*
 		 * The dispose list is isolated and dentries are not accounted
@@ -815,22 +827,19 @@ static void shrink_dentry_list(struct list_head *list)
 			continue;
 		}
 
-		parent = dentry_kill(dentry, 0);
+		dump("shrink", dentry);
+		parent = dentry_kill(dentry, list);
 		/*
 		 * If dentry_kill returns NULL, we have nothing more to do.
 		 */
 		if (!parent)
 			continue;
 
+		 /* if trylocks have failed; just do it again */
 		if (unlikely(parent == dentry)) {
-			/*
-			 * trylocks have failed and d_lock has been held the
-			 * whole time, so it could not have been added to any
-			 * other lists. Just add it back to the shrink list.
-			 */
-			d_shrink_add(dentry, list);
-			spin_unlock(&dentry->d_lock);
-			continue;
+			if (dentry->d_sb->s_magic == SYSFS_MAGIC)
+				printk(KERN_ERR "A");
+			goto again;
 		}
 		/*
 		 * We need to prune ancestors too. This is necessary to prevent
@@ -839,8 +848,10 @@ static void shrink_dentry_list(struct list_head *list)
 		 * fragmentation.
 		 */
 		dentry = parent;
-		while (dentry && !lockref_put_or_lock(&dentry->d_lockref))
-			dentry = dentry_kill(dentry, 1);
+		while (dentry && !lockref_put_or_lock(&dentry->d_lockref)) {
+			dump("shrink-dput", dentry);
+			dentry = dentry_kill(dentry, NULL);
+		}
 	}
 }
 
@@ -1223,6 +1234,7 @@ out:
  */
 void shrink_dcache_parent(struct dentry *parent)
 {
+	dump("shrink_dcache_parent", parent);
 	for (;;) {
 		struct select_data data;
 
@@ -1331,6 +1343,8 @@ int check_submounts_and_drop(struct dentry *dentry)
 		goto out;
 	}
 
+	dump("check_submounts_and_drop", dentry);
+
 	for (;;) {
 		struct select_data data;
 
