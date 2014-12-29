Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaL2BQa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:16:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Al Viro" <viro@zeniv.linux.org.uk>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.439721348@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 14/27] deal with deadlock in d_walk()
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit ca5358ef75fc69fee5322a38a340f5739d997c10 upstream.

... by not hitting rename_retry for reasons other than rename having
happened.  In other words, do _not_ restart when finding that
between unlocking the child and locking the parent the former got
into __dentry_kill().  Skip the killed siblings instead...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[bwh: Backported to 3.2:
 - As we only have try_to_ascend() and not d_walk(), apply this
   change to all callers of try_to_ascend()
 - Adjust context to make __dentry_kill() apply to d_kill()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/dcache.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -306,9 +306,9 @@ static struct dentry *d_kill(struct dent
 	__releases(parent->d_lock)
 	__releases(dentry->d_inode->i_lock)
 {
-	list_del(&dentry->d_child);
+	__list_del_entry(&dentry->d_child);
 	/*
-	 * Inform try_to_ascend() that we are no longer attached to the
+	 * Inform ascending readers that we are no longer attached to the
 	 * dentry tree
 	 */
 	dentry->d_flags |= DCACHE_DENTRY_KILLED;
@@ -949,34 +949,6 @@ void shrink_dcache_for_umount(struct sup
 	}
 }
 
-/*
- * This tries to ascend one level of parenthood, but
- * we can race with renaming, so we need to re-check
- * the parenthood after dropping the lock and check
- * that the sequence number still matches.
- */
-static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq)
-{
-	struct dentry *new = old->d_parent;
-
-	rcu_read_lock();
-	spin_unlock(&old->d_lock);
-	spin_lock(&new->d_lock);
-
-	/*
-	 * might go back up the wrong parent if we have had a rename
-	 * or deletion
-	 */
-	if (new != old->d_parent ||
-		 (old->d_flags & DCACHE_DENTRY_KILLED) ||
-		 (!locked && read_seqretry(&rename_lock, seq))) {
-		spin_unlock(&new->d_lock);
-		new = NULL;
-	}
-	rcu_read_unlock();
-	return new;
-}
-
 
 /*
  * Search for at least 1 mount point in the dentry's subdirs.
@@ -1032,17 +1004,32 @@ resume:
 	/*
 	 * All done at this level ... ascend and resume the search.
 	 */
+	rcu_read_lock();
+ascend:
 	if (this_parent != parent) {
 		struct dentry *child = this_parent;
-		this_parent = try_to_ascend(this_parent, locked, seq);
-		if (!this_parent)
+		this_parent = child->d_parent;
+
+		spin_unlock(&child->d_lock);
+		spin_lock(&this_parent->d_lock);
+
+		/* might go back up the wrong parent if we have had a rename */
+		if (!locked && read_seqretry(&rename_lock, seq))
 			goto rename_retry;
 		next = child->d_child.next;
+		while (unlikely(child->d_flags & DCACHE_DENTRY_KILLED)) {
+			if (next == &this_parent->d_subdirs)
+				goto ascend;
+			child = list_entry(next, struct dentry, d_child);
+			next = next->next;
+		}
+		rcu_read_unlock();
 		goto resume;
 	}
-	spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (locked)
 		write_sequnlock(&rename_lock);
 	return 0; /* No mount points found in tree */
@@ -1054,6 +1041,8 @@ positive:
 	return 1;
 
 rename_retry:
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (locked)
 		goto again;
 	locked = 1;
@@ -1139,23 +1128,40 @@ resume:
 	/*
 	 * All done at this level ... ascend and resume the search.
 	 */
+	rcu_read_lock();
+ascend:
 	if (this_parent != parent) {
 		struct dentry *child = this_parent;
-		this_parent = try_to_ascend(this_parent, locked, seq);
-		if (!this_parent)
+		this_parent = child->d_parent;
+
+		spin_unlock(&child->d_lock);
+		spin_lock(&this_parent->d_lock);
+
+		/* might go back up the wrong parent if we have had a rename */
+		if (!locked && read_seqretry(&rename_lock, seq))
 			goto rename_retry;
 		next = child->d_child.next;
+		while (unlikely(child->d_flags & DCACHE_DENTRY_KILLED)) {
+			if (next == &this_parent->d_subdirs)
+				goto ascend;
+			child = list_entry(next, struct dentry, d_child);
+			next = next->next;
+		}
+		rcu_read_unlock();
 		goto resume;
 	}
 out:
-	spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (locked)
 		write_sequnlock(&rename_lock);
 	return found;
 
 rename_retry:
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (found)
 		return found;
 	if (locked)
@@ -2914,26 +2920,43 @@ resume:
 		}
 		spin_unlock(&dentry->d_lock);
 	}
+	rcu_read_lock();
+ascend:
 	if (this_parent != root) {
 		struct dentry *child = this_parent;
 		if (!(this_parent->d_flags & DCACHE_GENOCIDE)) {
 			this_parent->d_flags |= DCACHE_GENOCIDE;
 			this_parent->d_count--;
 		}
-		this_parent = try_to_ascend(this_parent, locked, seq);
-		if (!this_parent)
+		this_parent = child->d_parent;
+
+		spin_unlock(&child->d_lock);
+		spin_lock(&this_parent->d_lock);
+
+		/* might go back up the wrong parent if we have had a rename */
+		if (!locked && read_seqretry(&rename_lock, seq))
 			goto rename_retry;
 		next = child->d_child.next;
+		while (unlikely(child->d_flags & DCACHE_DENTRY_KILLED)) {
+			if (next == &this_parent->d_subdirs)
+				goto ascend;
+			child = list_entry(next, struct dentry, d_child);
+			next = next->next;
+		}
+		rcu_read_unlock();
 		goto resume;
 	}
-	spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (locked)
 		write_sequnlock(&rename_lock);
 	return;
 
 rename_retry:
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
 	if (locked)
 		goto again;
 	locked = 1;

