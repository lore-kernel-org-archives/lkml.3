Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaHETww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:52:52 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:54801 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbaHETwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:52:49 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Steven Noonan <steven@uplinklabs.net>, NeilBrown <neilb@suse.de>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 2/2] lockref: replace lockref_get_not_zero with lockref_get_active
Date: Tue,  5 Aug 2014 12:52:28 -0700
Message-Id: <1407268348-25949-2-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407268348-25949-1-git-send-email-steven@uplinklabs.net>
References: <1407268348-25949-1-git-send-email-steven@uplinklabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new lockref_get_active ensures the count is nonzero and that the lockref is
not dead (i.e, count > 0). Simply comparing to zero was risky for the only
caller of this function (dget_parent), as it wasn't holding the lockref->lock.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 fs/dcache.c             |  2 +-
 include/linux/lockref.h |  2 +-
 lib/lockref.c           | 13 +++++++------
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f7a592e..66ee98e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -699,7 +699,7 @@ struct dentry *dget_parent(struct dentry *dentry)
 	 */
 	rcu_read_lock();
 	ret = ACCESS_ONCE(dentry->d_parent);
-	gotref = lockref_get_not_zero(&ret->d_lockref);
+	gotref = lockref_get_active(&ret->d_lockref);
 	rcu_read_unlock();
 	if (likely(gotref)) {
 		if (likely(ret == ACCESS_ONCE(dentry->d_parent)))
diff --git a/include/linux/lockref.h b/include/linux/lockref.h
index 8558ff1..1a9827e 100644
--- a/include/linux/lockref.h
+++ b/include/linux/lockref.h
@@ -34,7 +34,7 @@ struct lockref {
 };
 
 extern void lockref_get(struct lockref *);
-extern int lockref_get_not_zero(struct lockref *);
+extern int lockref_get_active(struct lockref *);
 extern int lockref_get_or_lock(struct lockref *);
 extern int lockref_put_or_lock(struct lockref *);
 
diff --git a/lib/lockref.c b/lib/lockref.c
index e4c4255..318bef6 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -60,17 +60,18 @@ void lockref_get(struct lockref *lockref)
 EXPORT_SYMBOL(lockref_get);
 
 /**
- * lockref_get_not_zero - Increments count unless the count is 0
+ * lockref_get_active - Increments count unless the count is 0 or ref is dead
  * @lockref: pointer to lockref structure
- * Return: 1 if count updated successfully or 0 if count was zero
+ * Return: 1 if count updated successfully or 0 if count was zero or lockref
+ * was dead
  */
-int lockref_get_not_zero(struct lockref *lockref)
+int lockref_get_active(struct lockref *lockref)
 {
 	int retval;
 
 	CMPXCHG_LOOP(
 		new.count++;
-		if (!old.count)
+		if (old.count < 1)
 			return 0;
 	,
 		return 1;
@@ -78,14 +79,14 @@ int lockref_get_not_zero(struct lockref *lockref)
 
 	spin_lock(&lockref->lock);
 	retval = 0;
-	if (lockref->count) {
+	if (lockref->count >= 1) {
 		lockref->count++;
 		retval = 1;
 	}
 	spin_unlock(&lockref->lock);
 	return retval;
 }
-EXPORT_SYMBOL(lockref_get_not_zero);
+EXPORT_SYMBOL(lockref_get_active);
 
 /**
  * lockref_get_or_lock - Increments count unless the count is 0
-- 
2.0.4

