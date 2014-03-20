Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaCTDsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:48:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41938 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaCTDsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:48:32 -0400
Date: Thu, 20 Mar 2014 03:48:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Max Kellermann <mk@cm4all.com>
Cc: max@duempel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fs/namespace: don't clobber mnt_hash.next while
 umounting [v2]
Message-ID: <20140320034829.GW18016@ZenIV.linux.org.uk>
References: <20140319213754.GA25719@rabbit.intern.cm-ag>
 <20140319213945.25858.14175.stgit@rabbit.intern.cm-ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319213945.25858.14175.stgit@rabbit.intern.cm-ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 10:39:45PM +0100, Max Kellermann wrote:
> mount.mnt_hash is RCU-protected.  However, list_move() breaks RCU
> protection: when one thread walks the linked list while another calls
> list_move(), it may "redirect" the first thread into the new list,
> making it loop endlessly in __lookup_mnt(), because the list head is
> never found.

> The right way to delete items from a RCU-protected list is
> list_del_rcu().  Before the item is inserted into another list
> (completing the list_move), synchronize_rcu() must be called.

> The fix is to avoid reusing "mnt_hash".  This patch adds a new
> list_head attribute dedicated for umounting.  This avoids clobbering
> mnt_hash.next, allowing all rcu_locked threads to continue walk the
> list until namespace_unlock() is called.

NAK.  Nice catch, the bug is real, but the fix is wrong.  For one thing,
you have missed detach_mnt()/attach_mnt(), so you are not covering
all places where the sucker might be removed from the list.  For another,
I don't believe that this is the right approach.

The *only* thing we care about is not getting stuck in __lookup_mnt().  If
it misses an entry because something in front of it just got moved around,
etc., we are fine.  We'll notice that mount_lock mismatch and that'll be
it.

IOW, there are two problems here:
	(1) we can, indeed, get caught into an infinite loop.
	(2) __follow_mount_rcu() and follow_mount_rcu() ought to recheck
nd->m_seq and bugger off with ECHILD in case of mismatch (the latter probably
ought to be folded into follow_dotdot_rcu()).  legitimize_mnt() will fail
in the end of lookup *and* we are risking an incorrect hard error if we fail
to cross a mountpoint and continue under it.

I would prefer to deal with (1) by turning mnt_hash into hlist; the problem
with that is __lookup_mnt_last().  That sucker is only called under
mount_lock, so RCU issues do not play there, but it's there and it
complicates things.  There might be a way to get rid of that thing for
good, but that's more invasive than what I'd be happy with for backports.

Let's just have __lookup_mnt() recheck mount_lock if it goes for too long -
e.g. every 256 iterations (and if the hash chain is that long, the price
of extra smp_rmb() + fetching seqcount won't matter anyway).  And have the
fs/namei.c callers check nd->m_seq properly (lookup_mnt() already does).
I've looked into taking the check into __lookup_mnt() itself, but it
leads to clumsier calling conventions and worse code in callers.

How about the following (completely untested yet):

diff --git a/fs/mount.h b/fs/mount.h
index 46790ae1..905d1bc 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -77,7 +77,7 @@ static inline int is_mounted(struct vfsmount *mnt)
 	return !IS_ERR_OR_NULL(real_mount(mnt)->mnt_ns);
 }
 
-extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *);
+extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *, unsigned seq);
 extern struct mount *__lookup_mnt_last(struct vfsmount *, struct dentry *);
 
 extern bool legitimize_mnt(struct vfsmount *, unsigned);
diff --git a/fs/namei.c b/fs/namei.c
index d6e32a1..458572b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1115,7 +1115,7 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 		if (!d_mountpoint(path->dentry))
 			break;
 
-		mounted = __lookup_mnt(path->mnt, path->dentry);
+		mounted = __lookup_mnt(path->mnt, path->dentry, nd->m_seq);
 		if (!mounted)
 			break;
 		path->mnt = &mounted->mnt;
@@ -1129,20 +1129,7 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 		 */
 		*inode = path->dentry->d_inode;
 	}
-	return true;
-}
-
-static void follow_mount_rcu(struct nameidata *nd)
-{
-	while (d_mountpoint(nd->path.dentry)) {
-		struct mount *mounted;
-		mounted = __lookup_mnt(nd->path.mnt, nd->path.dentry);
-		if (!mounted)
-			break;
-		nd->path.mnt = &mounted->mnt;
-		nd->path.dentry = mounted->mnt.mnt_root;
-		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
-	}
+	return read_seqretry(&mount_lock, nd->m_seq);
 }
 
 static int follow_dotdot_rcu(struct nameidata *nd)
@@ -1170,7 +1157,17 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 			break;
 		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
 	}
-	follow_mount_rcu(nd);
+	while (d_mountpoint(nd->path.dentry)) {
+		struct mount *mounted;
+		mounted = __lookup_mnt(nd->path.mnt, nd->path.dentry, nd->m_seq);
+		if (!mounted)
+			break;
+		nd->path.mnt = &mounted->mnt;
+		nd->path.dentry = mounted->mnt.mnt_root;
+		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
+		if (!read_seqretry(&mount_lock, nd->m_seq))
+			goto failed;
+	}
 	nd->inode = nd->path.dentry->d_inode;
 	return 0;
 
diff --git a/fs/namespace.c b/fs/namespace.c
index 203475b..72c20b0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -599,16 +599,23 @@ bool legitimize_mnt(struct vfsmount *bastard, unsigned seq)
 
 /*
  * find the first mount at @dentry on vfsmount @mnt.
- * call under rcu_read_lock()
+ * call under rcu_read_lock().  seq is normally *not* checked - that's
+ * for the caller to deal with; here we are just breaking infinite loops.
+ * If we get hash chains longer than 256 elements, the price of extra
+ * smp_rmb() won't matter.
  */
-struct mount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry)
+struct mount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry, unsigned seq)
 {
 	struct list_head *head = m_hash(mnt, dentry);
 	struct mount *p;
+	unsigned char n = 0;
 
-	list_for_each_entry_rcu(p, head, mnt_hash)
+	list_for_each_entry_rcu(p, head, mnt_hash) {
+		if (unlikely(!--n) && !read_seqretry(&mount_lock, seq))
+			break;
 		if (&p->mnt_parent->mnt == mnt && p->mnt_mountpoint == dentry)
 			return p;
+	}
 	return NULL;
 }
 
@@ -652,7 +659,7 @@ struct vfsmount *lookup_mnt(struct path *path)
 	rcu_read_lock();
 	do {
 		seq = read_seqbegin(&mount_lock);
-		child_mnt = __lookup_mnt(path->mnt, path->dentry);
+		child_mnt = __lookup_mnt(path->mnt, path->dentry, seq);
 		m = child_mnt ? &child_mnt->mnt : NULL;
 	} while (!legitimize_mnt(m, seq));
 	rcu_read_unlock();
