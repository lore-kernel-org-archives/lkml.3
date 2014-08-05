Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbaHETwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:52:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50031 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaHETwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:52:42 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Steven Noonan <steven@uplinklabs.net>, NeilBrown <neilb@suse.de>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 1/2] lockref: make lockref count signed
Date: Tue,  5 Aug 2014 12:52:27 -0700
Message-Id: <1407268348-25949-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are numerous places where this is casted to a signed value anyway, for
comparisons checking that the value hasn't been set to the 'dead' value of
-128. This change turns the count value into a signed integer, which is how
it's already being treated anyway. This reduces the chance for developer errors
when making those comparisons.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 fs/dcache.c             | 6 +++---
 include/linux/lockref.h | 2 +-
 lib/lockref.c           | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 06f6585..f7a592e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -479,7 +479,7 @@ static void __dentry_kill(struct dentry *dentry)
 	 * dentry_iput drops the locks, at which point nobody (except
 	 * transient RCU lookups) can reach this dentry.
 	 */
-	BUG_ON((int)dentry->d_lockref.count > 0);
+	BUG_ON(dentry->d_lockref.count > 0);
 	this_cpu_dec(nr_dentry);
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
@@ -532,7 +532,7 @@ static inline struct dentry *lock_parent(struct dentry *dentry)
 	struct dentry *parent = dentry->d_parent;
 	if (IS_ROOT(dentry))
 		return NULL;
-	if (unlikely((int)dentry->d_lockref.count < 0))
+	if (unlikely(dentry->d_lockref.count < 0))
 		return NULL;
 	if (likely(spin_trylock(&parent->d_lock)))
 		return parent;
@@ -848,7 +848,7 @@ static void shrink_dentry_list(struct list_head *list)
 		 * We found an inuse dentry which was not removed from
 		 * the LRU because of laziness during lookup. Do not free it.
 		 */
-		if ((int)dentry->d_lockref.count > 0) {
+		if (dentry->d_lockref.count > 0) {
 			spin_unlock(&dentry->d_lock);
 			if (parent)
 				spin_unlock(&parent->d_lock);
diff --git a/include/linux/lockref.h b/include/linux/lockref.h
index 4bfde0e..8558ff1 100644
--- a/include/linux/lockref.h
+++ b/include/linux/lockref.h
@@ -28,7 +28,7 @@ struct lockref {
 #endif
 		struct {
 			spinlock_t lock;
-			unsigned int count;
+			int count;
 		};
 	};
 };
diff --git a/lib/lockref.c b/lib/lockref.c
index d2233de..e4c4255 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -158,7 +158,7 @@ int lockref_get_not_dead(struct lockref *lockref)
 
 	CMPXCHG_LOOP(
 		new.count++;
-		if ((int)old.count < 0)
+		if (old.count < 0)
 			return 0;
 	,
 		return 1;
@@ -166,7 +166,7 @@ int lockref_get_not_dead(struct lockref *lockref)
 
 	spin_lock(&lockref->lock);
 	retval = 0;
-	if ((int) lockref->count >= 0) {
+	if (lockref->count >= 0) {
 		lockref->count++;
 		retval = 1;
 	}
-- 
2.0.4

