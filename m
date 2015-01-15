Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbbAOWNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:13:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50463 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbbAOWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 19/19] deal with deadlock in d_walk()
Date: Thu, 15 Jan 2015 14:09:55 -0800
Message-Id: <1421359795-11155-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421359795-11155-1-git-send-email-kamal@canonical.com>
References: <1421359795-11155-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit ca5358ef75fc69fee5322a38a340f5739d997c10 upstream.

... by not hitting rename_retry for reasons other than rename having
happened.  In other words, do _not_ restart when finding that
between unlocking the child and locking the parent the former got
into __dentry_kill().  Skip the killed siblings instead...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[ kamal: backport to 3.13-stable: __dentry_kill() change applied to d_kill() ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/dcache.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index a2ca842..6ef3f68 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -437,7 +437,7 @@ static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 	__releases(parent->d_lock)
 	__releases(dentry->d_inode->i_lock)
 {
-	list_del(&dentry->d_child);
+	__list_del_entry(&dentry->d_child);
 	/*
 	 * Inform d_walk() that we are no longer attached to the
 	 * dentry tree
@@ -1125,33 +1125,31 @@ resume:
 	/*
 	 * All done at this level ... ascend and resume the search.
 	 */
+	rcu_read_lock();
+ascend:
 	if (this_parent != parent) {
 		struct dentry *child = this_parent;
 		this_parent = child->d_parent;
 
-		rcu_read_lock();
 		spin_unlock(&child->d_lock);
 		spin_lock(&this_parent->d_lock);
 
-		/*
-		 * might go back up the wrong parent if we have had a rename
-		 * or deletion
-		 */
-		if (this_parent != child->d_parent ||
-			 (child->d_flags & DCACHE_DENTRY_KILLED) ||
-			 need_seqretry(&rename_lock, seq)) {
-			spin_unlock(&this_parent->d_lock);
-			rcu_read_unlock();
+		/* might go back up the wrong parent if we have had a rename. */
+		if (need_seqretry(&rename_lock, seq))
 			goto rename_retry;
+		next = child->d_child.next;
+		while (unlikely(child->d_flags & DCACHE_DENTRY_KILLED)) {
+			if (next == &this_parent->d_subdirs)
+				goto ascend;
+			child = list_entry(next, struct dentry, d_child);
+			next = next->next;
 		}
 		rcu_read_unlock();
-		next = child->d_child.next;
 		goto resume;
 	}
-	if (need_seqretry(&rename_lock, seq)) {
-		spin_unlock(&this_parent->d_lock);
+	if (need_seqretry(&rename_lock, seq))
 		goto rename_retry;
-	}
+	rcu_read_unlock();
 	if (finish)
 		finish(data);
 
@@ -1161,6 +1159,9 @@ out_unlock:
 	return;
 
 rename_retry:
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
+	BUG_ON(seq & 1);
 	if (!retry)
 		return;
 	seq = 1;
-- 
1.9.1

