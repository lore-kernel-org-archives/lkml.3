Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3JCGTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:19:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41566 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3JCGTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:19:47 -0400
Date: Thu, 03 Oct 2013 07:19:46 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 14/17] uninline destroy_super(), consolidate alloc_super()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcGI-0008DA-DB@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/super.c |  206 +++++++++++++++++++++++++-----------------------------------
 1 files changed, 86 insertions(+), 120 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 0225c20..efa6e48 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -129,33 +129,27 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 	return total_objects;
 }
 
-static int init_sb_writers(struct super_block *s, struct file_system_type *type)
-{
-	int err;
-	int i;
-
-	for (i = 0; i < SB_FREEZE_LEVELS; i++) {
-		err = percpu_counter_init(&s->s_writers.counter[i], 0);
-		if (err < 0)
-			goto err_out;
-		lockdep_init_map(&s->s_writers.lock_map[i], sb_writers_name[i],
-				 &type->s_writers_key[i], 0);
-	}
-	init_waitqueue_head(&s->s_writers.wait);
-	init_waitqueue_head(&s->s_writers.wait_unfrozen);
-	return 0;
-err_out:
-	while (--i >= 0)
-		percpu_counter_destroy(&s->s_writers.counter[i]);
-	return err;
-}
-
-static void destroy_sb_writers(struct super_block *s)
+/**
+ *	destroy_super	-	frees a superblock
+ *	@s: superblock to free
+ *
+ *	Frees a superblock.
+ */
+static void destroy_super(struct super_block *s)
 {
 	int i;
-
+	list_lru_destroy(&s->s_dentry_lru);
+	list_lru_destroy(&s->s_inode_lru);
+#ifdef CONFIG_SMP
+	free_percpu(s->s_files);
+#endif
 	for (i = 0; i < SB_FREEZE_LEVELS; i++)
 		percpu_counter_destroy(&s->s_writers.counter[i]);
+	security_sb_free(s);
+	WARN_ON(!list_empty(&s->s_mounts));
+	kfree(s->s_subtype);
+	kfree(s->s_options);
+	kfree(s);
 }
 
 /**
@@ -170,111 +164,83 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 {
 	struct super_block *s = kzalloc(sizeof(struct super_block),  GFP_USER);
 	static const struct super_operations default_op;
+	int i;
+
+	if (!s)
+		return NULL;
 
-	if (s) {
-		if (security_sb_alloc(s))
-			goto out_free_sb;
+	if (security_sb_alloc(s))
+		goto fail;
 
 #ifdef CONFIG_SMP
-		s->s_files = alloc_percpu(struct list_head);
-		if (!s->s_files)
-			goto err_out;
-		else {
-			int i;
-
-			for_each_possible_cpu(i)
-				INIT_LIST_HEAD(per_cpu_ptr(s->s_files, i));
-		}
+	s->s_files = alloc_percpu(struct list_head);
+	if (!s->s_files)
+		goto fail;
+	for_each_possible_cpu(i)
+		INIT_LIST_HEAD(per_cpu_ptr(s->s_files, i));
 #else
-		INIT_LIST_HEAD(&s->s_files);
+	INIT_LIST_HEAD(&s->s_files);
 #endif
-		if (init_sb_writers(s, type))
-			goto err_out;
-		s->s_flags = flags;
-		s->s_bdi = &default_backing_dev_info;
-		INIT_HLIST_NODE(&s->s_instances);
-		INIT_HLIST_BL_HEAD(&s->s_anon);
-		INIT_LIST_HEAD(&s->s_inodes);
-
-		if (list_lru_init(&s->s_dentry_lru))
-			goto err_out;
-		if (list_lru_init(&s->s_inode_lru))
-			goto err_out_dentry_lru;
-
-		INIT_LIST_HEAD(&s->s_mounts);
-		init_rwsem(&s->s_umount);
-		lockdep_set_class(&s->s_umount, &type->s_umount_key);
-		/*
-		 * sget() can have s_umount recursion.
-		 *
-		 * When it cannot find a suitable sb, it allocates a new
-		 * one (this one), and tries again to find a suitable old
-		 * one.
-		 *
-		 * In case that succeeds, it will acquire the s_umount
-		 * lock of the old one. Since these are clearly distrinct
-		 * locks, and this object isn't exposed yet, there's no
-		 * risk of deadlocks.
-		 *
-		 * Annotate this by putting this lock in a different
-		 * subclass.
-		 */
-		down_write_nested(&s->s_umount, SINGLE_DEPTH_NESTING);
-		s->s_count = 1;
-		atomic_set(&s->s_active, 1);
-		mutex_init(&s->s_vfs_rename_mutex);
-		lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
-		mutex_init(&s->s_dquot.dqio_mutex);
-		mutex_init(&s->s_dquot.dqonoff_mutex);
-		init_rwsem(&s->s_dquot.dqptr_sem);
-		s->s_maxbytes = MAX_NON_LFS;
-		s->s_op = &default_op;
-		s->s_time_gran = 1000000000;
-		s->cleancache_poolid = -1;
-
-		s->s_shrink.seeks = DEFAULT_SEEKS;
-		s->s_shrink.scan_objects = super_cache_scan;
-		s->s_shrink.count_objects = super_cache_count;
-		s->s_shrink.batch = 1024;
-		s->s_shrink.flags = SHRINKER_NUMA_AWARE;
+	for (i = 0; i < SB_FREEZE_LEVELS; i++) {
+		if (percpu_counter_init(&s->s_writers.counter[i], 0) < 0)
+			goto fail;
+		lockdep_init_map(&s->s_writers.lock_map[i], sb_writers_name[i],
+				 &type->s_writers_key[i], 0);
 	}
-out:
+	init_waitqueue_head(&s->s_writers.wait);
+	init_waitqueue_head(&s->s_writers.wait_unfrozen);
+	s->s_flags = flags;
+	s->s_bdi = &default_backing_dev_info;
+	INIT_HLIST_NODE(&s->s_instances);
+	INIT_HLIST_BL_HEAD(&s->s_anon);
+	INIT_LIST_HEAD(&s->s_inodes);
+
+	if (list_lru_init(&s->s_dentry_lru))
+		goto fail;
+	if (list_lru_init(&s->s_inode_lru))
+		goto fail;
+
+	INIT_LIST_HEAD(&s->s_mounts);
+	init_rwsem(&s->s_umount);
+	lockdep_set_class(&s->s_umount, &type->s_umount_key);
+	/*
+	 * sget() can have s_umount recursion.
+	 *
+	 * When it cannot find a suitable sb, it allocates a new
+	 * one (this one), and tries again to find a suitable old
+	 * one.
+	 *
+	 * In case that succeeds, it will acquire the s_umount
+	 * lock of the old one. Since these are clearly distrinct
+	 * locks, and this object isn't exposed yet, there's no
+	 * risk of deadlocks.
+	 *
+	 * Annotate this by putting this lock in a different
+	 * subclass.
+	 */
+	down_write_nested(&s->s_umount, SINGLE_DEPTH_NESTING);
+	s->s_count = 1;
+	atomic_set(&s->s_active, 1);
+	mutex_init(&s->s_vfs_rename_mutex);
+	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
+	mutex_init(&s->s_dquot.dqio_mutex);
+	mutex_init(&s->s_dquot.dqonoff_mutex);
+	init_rwsem(&s->s_dquot.dqptr_sem);
+	s->s_maxbytes = MAX_NON_LFS;
+	s->s_op = &default_op;
+	s->s_time_gran = 1000000000;
+	s->cleancache_poolid = -1;
+
+	s->s_shrink.seeks = DEFAULT_SEEKS;
+	s->s_shrink.scan_objects = super_cache_scan;
+	s->s_shrink.count_objects = super_cache_count;
+	s->s_shrink.batch = 1024;
+	s->s_shrink.flags = SHRINKER_NUMA_AWARE;
 	return s;
 
-err_out_dentry_lru:
-	list_lru_destroy(&s->s_dentry_lru);
-err_out:
-	security_sb_free(s);
-#ifdef CONFIG_SMP
-	if (s->s_files)
-		free_percpu(s->s_files);
-#endif
-	destroy_sb_writers(s);
-out_free_sb:
-	kfree(s);
-	s = NULL;
-	goto out;
-}
-
-/**
- *	destroy_super	-	frees a superblock
- *	@s: superblock to free
- *
- *	Frees a superblock.
- */
-static inline void destroy_super(struct super_block *s)
-{
-	list_lru_destroy(&s->s_dentry_lru);
-	list_lru_destroy(&s->s_inode_lru);
-#ifdef CONFIG_SMP
-	free_percpu(s->s_files);
-#endif
-	destroy_sb_writers(s);
-	security_sb_free(s);
-	WARN_ON(!list_empty(&s->s_mounts));
-	kfree(s->s_subtype);
-	kfree(s->s_options);
-	kfree(s);
+fail:
+	destroy_super(s);
+	return NULL;
 }
 
 /* Superblock refcounting  */
-- 
1.7.2.5


