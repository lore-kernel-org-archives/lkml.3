Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaLNUlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:41:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaLNUbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:31:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.18 16/19] deal with deadlock in d_walk()
Date: Sun, 14 Dec 2014 12:21:27 -0800
Message-Id: <20141214201824.005939845@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201823.543296369@linuxfoundation.org>
References: <20141214201823.543296369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit ca5358ef75fc69fee5322a38a340f5739d997c10 upstream.

... by not hitting rename_retry for reasons other than rename having
happened.  In other words, do _not_ restart when finding that
between unlocking the child and locking the parent the former got
into __dentry_kill().  Skip the killed siblings instead...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -495,7 +495,7 @@ static void __dentry_kill(struct dentry
 	}
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
-	list_del(&dentry->d_child);
+	__list_del_entry(&dentry->d_child);
 	/*
 	 * Inform d_walk() that we are no longer attached to the
 	 * dentry tree
@@ -1082,33 +1082,31 @@ resume:
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
 
@@ -1118,6 +1116,9 @@ out_unlock:
 	return;
 
 rename_retry:
+	spin_unlock(&this_parent->d_lock);
+	rcu_read_unlock();
+	BUG_ON(seq & 1);
 	if (!retry)
 		return;
 	seq = 1;


