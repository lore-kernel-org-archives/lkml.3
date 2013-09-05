Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923Ab3IEJpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:45:31 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:54451 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935551Ab3IEJox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:44:53 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 02/11] vfs: add d_walk()
Date: Thu,  5 Sep 2013 11:44:35 +0200
Message-Id: <1378374284-1484-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This one replaces three instances open coded tree walking (have_submounts,
select_parent, d_genocide) with a common helper.

In addition to slightly reducing the kernel size, this simplifies the
callers and makes them less bug prone.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c | 309 +++++++++++++++++++++++++++++-------------------------------
 1 file changed, 148 insertions(+), 161 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 0c25394..3b12076 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1007,34 +1007,56 @@ static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq
 	return new;
 }
 
+/**
+ * enum d_walk_ret - action to talke during tree walk
+ * @D_WALK_CONTINUE:	contrinue walk
+ * @D_WALK_QUIT:	quit walk
+ * @D_WALK_NORETRY:	quit when retry is needed
+ * @D_WALK_SKIP:	skip this dentry and its children
+ */
+enum d_walk_ret {
+	D_WALK_CONTINUE,
+	D_WALK_QUIT,
+	D_WALK_NORETRY,
+	D_WALK_SKIP,
+};
 
-/*
- * Search for at least 1 mount point in the dentry's subdirs.
- * We descend to the next level whenever the d_subdirs
- * list is non-empty and continue searching.
- */
- 
 /**
- * have_submounts - check for mounts over a dentry
- * @parent: dentry to check.
+ * d_walk - walk the dentry tree
+ * @parent:	start of walk
+ * @data:	data passed to @enter() and @finish()
+ * @enter:	callback when first entering the dentry
+ * @finish:	callback when successfully finished the walk
  *
- * Return true if the parent or its subdirectories contain
- * a mount point
+ * The @enter() and @finish() callbacks are called with d_lock held.
  */
-int have_submounts(struct dentry *parent)
+static void d_walk(struct dentry *parent, void *data,
+		   enum d_walk_ret (*enter)(void *, struct dentry *),
+		   void (*finish)(void *))
 {
 	struct dentry *this_parent;
 	struct list_head *next;
 	unsigned seq;
 	int locked = 0;
+	enum d_walk_ret ret;
+	bool retry = true;
 
 	seq = read_seqbegin(&rename_lock);
 again:
 	this_parent = parent;
-
-	if (d_mountpoint(parent))
-		goto positive;
 	spin_lock(&this_parent->d_lock);
+
+	ret = enter(data, this_parent);
+	switch (ret) {
+	case D_WALK_CONTINUE:
+		break;
+	case D_WALK_QUIT:
+	case D_WALK_SKIP:
+		goto out_unlock;
+	case D_WALK_NORETRY:
+		retry = false;
+		break;
+	}
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -1044,12 +1066,22 @@ resume:
 		next = tmp->next;
 
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
-		/* Have we found a mount point ? */
-		if (d_mountpoint(dentry)) {
+
+		ret = enter(data, dentry);
+		switch (ret) {
+		case D_WALK_CONTINUE:
+			break;
+		case D_WALK_QUIT:
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&this_parent->d_lock);
-			goto positive;
+			goto out_unlock;
+		case D_WALK_NORETRY:
+			retry = false;
+			break;
+		case D_WALK_SKIP:
+			spin_unlock(&dentry->d_lock);
+			continue;
 		}
+
 		if (!list_empty(&dentry->d_subdirs)) {
 			spin_unlock(&this_parent->d_lock);
 			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
@@ -1070,26 +1102,61 @@ resume:
 		next = child->d_u.d_child.next;
 		goto resume;
 	}
-	spin_unlock(&this_parent->d_lock);
-	if (!locked && read_seqretry(&rename_lock, seq))
-		goto rename_retry;
-	if (locked)
-		write_sequnlock(&rename_lock);
-	return 0; /* No mount points found in tree */
-positive:
-	if (!locked && read_seqretry(&rename_lock, seq))
+	if (!locked && read_seqretry(&rename_lock, seq)) {
+		spin_unlock(&this_parent->d_lock);
 		goto rename_retry;
+	}
+	if (finish)
+		finish(data);
+
+out_unlock:
+	spin_unlock(&this_parent->d_lock);
 	if (locked)
 		write_sequnlock(&rename_lock);
-	return 1;
+	return;
 
 rename_retry:
+	if (!retry)
+		return;
 	if (locked)
 		goto again;
 	locked = 1;
 	write_seqlock(&rename_lock);
 	goto again;
 }
+
+/*
+ * Search for at least 1 mount point in the dentry's subdirs.
+ * We descend to the next level whenever the d_subdirs
+ * list is non-empty and continue searching.
+ */
+
+/**
+ * have_submounts - check for mounts over a dentry
+ * @parent: dentry to check.
+ *
+ * Return true if the parent or its subdirectories contain
+ * a mount point
+ */
+
+static enum d_walk_ret check_mount(void *data, struct dentry *dentry)
+{
+	int *ret = data;
+	if (d_mountpoint(dentry)) {
+		*ret = 1;
+		return D_WALK_QUIT;
+	}
+	return D_WALK_CONTINUE;
+}
+
+int have_submounts(struct dentry *parent)
+{
+	int ret = 0;
+
+	d_walk(parent, &ret, check_mount, NULL);
+
+	return ret;
+}
 EXPORT_SYMBOL(have_submounts);
 
 /*
@@ -1106,93 +1173,46 @@ EXPORT_SYMBOL(have_submounts);
  * drop the lock and return early due to latency
  * constraints.
  */
-static int select_parent(struct dentry *parent, struct list_head *dispose)
-{
-	struct dentry *this_parent;
-	struct list_head *next;
-	unsigned seq;
-	int found = 0;
-	int locked = 0;
 
-	seq = read_seqbegin(&rename_lock);
-again:
-	this_parent = parent;
-	spin_lock(&this_parent->d_lock);
-repeat:
-	next = this_parent->d_subdirs.next;
-resume:
-	while (next != &this_parent->d_subdirs) {
-		struct list_head *tmp = next;
-		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
-		next = tmp->next;
-
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+struct select_data {
+	struct dentry *start;
+	struct list_head dispose;
+	int found;
+};
 
-		/*
-		 * move only zero ref count dentries to the dispose list.
-		 *
-		 * Those which are presently on the shrink list, being processed
-		 * by shrink_dentry_list(), shouldn't be moved.  Otherwise the
-		 * loop in shrink_dcache_parent() might not make any progress
-		 * and loop forever.
-		 */
-		if (dentry->d_lockref.count) {
-			dentry_lru_del(dentry);
-		} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
-			dentry_lru_move_list(dentry, dispose);
-			dentry->d_flags |= DCACHE_SHRINK_LIST;
-			found++;
-		}
-		/*
-		 * We can return to the caller if we have found some (this
-		 * ensures forward progress). We'll be coming back to find
-		 * the rest.
-		 */
-		if (found && need_resched()) {
-			spin_unlock(&dentry->d_lock);
-			goto out;
-		}
+static enum d_walk_ret select_collect(void *_data, struct dentry *dentry)
+{
+	struct select_data *data = _data;
+	enum d_walk_ret ret = D_WALK_CONTINUE;
 
-		/*
-		 * Descend a level if the d_subdirs list is non-empty.
-		 */
-		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
-			this_parent = dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
-			goto repeat;
-		}
+	if (data->start == dentry)
+		goto out;
 
-		spin_unlock(&dentry->d_lock);
-	}
 	/*
-	 * All done at this level ... ascend and resume the search.
+	 * move only zero ref count dentries to the dispose list.
+	 *
+	 * Those which are presently on the shrink list, being processed
+	 * by shrink_dentry_list(), shouldn't be moved.  Otherwise the
+	 * loop in shrink_dcache_parent() might not make any progress
+	 * and loop forever.
 	 */
-	if (this_parent != parent) {
-		struct dentry *child = this_parent;
-		this_parent = try_to_ascend(this_parent, locked, seq);
-		if (!this_parent)
-			goto rename_retry;
-		next = child->d_u.d_child.next;
-		goto resume;
+	if (dentry->d_lockref.count) {
+		dentry_lru_del(dentry);
+	} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
+		dentry_lru_move_list(dentry, &data->dispose);
+		dentry->d_flags |= DCACHE_SHRINK_LIST;
+		data->found++;
+		ret = D_WALK_NORETRY;
 	}
+	/*
+	 * We can return to the caller if we have found some (this
+	 * ensures forward progress). We'll be coming back to find
+	 * the rest.
+	 */
+	if (data->found && need_resched())
+		ret = D_WALK_QUIT;
 out:
-	spin_unlock(&this_parent->d_lock);
-	if (!locked && read_seqretry(&rename_lock, seq))
-		goto rename_retry;
-	if (locked)
-		write_sequnlock(&rename_lock);
-	return found;
-
-rename_retry:
-	if (found)
-		return found;
-	if (locked)
-		goto again;
-	locked = 1;
-	write_seqlock(&rename_lock);
-	goto again;
+	return ret;
 }
 
 /**
@@ -1201,13 +1221,20 @@ rename_retry:
  *
  * Prune the dcache to remove unused children of the parent dentry.
  */
-void shrink_dcache_parent(struct dentry * parent)
+void shrink_dcache_parent(struct dentry *parent)
 {
-	LIST_HEAD(dispose);
-	int found;
+	for (;;) {
+		struct select_data data;
 
-	while ((found = select_parent(parent, &dispose)) != 0) {
-		shrink_dentry_list(&dispose);
+		INIT_LIST_HEAD(&data.dispose);
+		data.start = parent;
+		data.found = 0;
+
+		d_walk(parent, &data, select_collect, NULL);
+		if (!data.found)
+			break;
+
+		shrink_dentry_list(&data.dispose);
 		cond_resched();
 	}
 }
@@ -2904,64 +2931,24 @@ int is_subdir(struct dentry *new_dentry, struct dentry *old_dentry)
 	return result;
 }
 
-void d_genocide(struct dentry *root)
+static enum d_walk_ret d_genocide_kill(void *data, struct dentry *dentry)
 {
-	struct dentry *this_parent;
-	struct list_head *next;
-	unsigned seq;
-	int locked = 0;
+	struct dentry *root = data;
+	if (dentry != root) {
+		if (d_unhashed(dentry) || !dentry->d_inode)
+			return D_WALK_SKIP;
 
-	seq = read_seqbegin(&rename_lock);
-again:
-	this_parent = root;
-	spin_lock(&this_parent->d_lock);
-repeat:
-	next = this_parent->d_subdirs.next;
-resume:
-	while (next != &this_parent->d_subdirs) {
-		struct list_head *tmp = next;
-		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
-		next = tmp->next;
-
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
-		if (d_unhashed(dentry) || !dentry->d_inode) {
-			spin_unlock(&dentry->d_lock);
-			continue;
-		}
 		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
 			dentry->d_flags |= DCACHE_GENOCIDE;
 			dentry->d_lockref.count--;
 		}
-		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
-			this_parent = dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
-			goto repeat;
-		}
-		spin_unlock(&dentry->d_lock);
 	}
-	if (this_parent != root) {
-		struct dentry *child = this_parent;
-		this_parent = try_to_ascend(this_parent, locked, seq);
-		if (!this_parent)
-			goto rename_retry;
-		next = child->d_u.d_child.next;
-		goto resume;
-	}
-	spin_unlock(&this_parent->d_lock);
-	if (!locked && read_seqretry(&rename_lock, seq))
-		goto rename_retry;
-	if (locked)
-		write_sequnlock(&rename_lock);
-	return;
+	return D_WALK_CONTINUE;
+}
 
-rename_retry:
-	if (locked)
-		goto again;
-	locked = 1;
-	write_seqlock(&rename_lock);
-	goto again;
+void d_genocide(struct dentry *parent)
+{
+	d_walk(parent, parent, d_genocide_kill, NULL);
 }
 
 void d_tmpfile(struct dentry *dentry, struct inode *inode)
-- 
1.8.1.4

