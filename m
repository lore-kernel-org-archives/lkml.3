Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbbA2I74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:59:56 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754553AbbA2I7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:53 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 176/176] deal with deadlock in d_walk()
Date: Wed, 28 Jan 2015 15:30:06 +0100
Message-Id: <a99bf21c924111ca8588fface7e87e142bb38eae.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ca5358ef75fc69fee5322a38a340f5739d997c10 upstream.

... by not hitting rename_retry for reasons other than rename having
happened.  In other words, do _not_ restart when finding that
between unlocking the child and locking the parent the former got
into __dentry_kill().  Skip the killed siblings instead...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/dcache.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 09f7a612ba7f..eb540b00d027 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -488,7 +488,7 @@ static void __dentry_kill(struct dentry *dentry)
 	}
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
-	list_del(&dentry->d_child);
+	__list_del_entry(&dentry->d_child);
 	/*
 	 * Inform d_walk() that we are no longer attached to the
 	 * dentry tree
@@ -1142,33 +1142,31 @@ resume:
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
 
@@ -1178,6 +1176,9 @@ out_unlock:
 	return;
 
 rename_retry:
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
+	BUG_ON(seq & 1);
 	if (!retry)
 		return;
 	seq = 1;
-- 
2.2.2

