Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaHEVyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:54:47 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:64529 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaHEVyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:54:44 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Steven Noonan <steven@uplinklabs.net>, NeilBrown <neilb@suse.de>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 1/2 v2] lockref: make lockref count signed
Date: Tue,  5 Aug 2014 14:54:31 -0700
Message-Id: <1407275671-27095-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <CAKbGBLgh+qHu3zC=qD1CYRFbmdkci6GE-0MZ=wS3EqeQuh8YbQ@mail.gmail.com>
References: <CAKbGBLgh+qHu3zC=qD1CYRFbmdkci6GE-0MZ=wS3EqeQuh8YbQ@mail.gmail.com>
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

v2: d_count() function was unsigned and there was another cast inside autofs4.
Fixed those as well.

 fs/autofs4/root.c       | 2 +-
 fs/dcache.c             | 6 +++---
 include/linux/dcache.h  | 2 +-
 include/linux/lockref.h | 2 +-
 lib/lockref.c           | 4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index cc87c1a..c4583c8 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -179,7 +179,7 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 		spin_lock(&active->d_lock);
 
 		/* Already gone? */
-		if ((int) d_count(active) <= 0)
+		if (d_count(active) <= 0)
 			goto next;
 
 		qstr = &active->d_name;
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
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 3c7ec32..7531470 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -320,7 +320,7 @@ extern struct dentry *__d_lookup(const struct dentry *, const struct qstr *);
 extern struct dentry *__d_lookup_rcu(const struct dentry *parent,
 				const struct qstr *name, unsigned *seq);
 
-static inline unsigned d_count(const struct dentry *dentry)
+static inline int d_count(const struct dentry *dentry)
 {
 	return dentry->d_lockref.count;
 }
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

