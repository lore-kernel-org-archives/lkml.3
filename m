Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbaCEDw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:52:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49137 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbaCEDwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:52:20 -0500
Date: Wed, 5 Mar 2014 03:52:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 5/5][RFC][CFT] resizable namespace.c hashes
Message-ID: <20140305035219.GE26528@ZenIV.linux.org.uk>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305034751.GW18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* switch allocation to alloc_large_system_hash()
* make sizes overridable by boot parameters (mhash_entries=, mphash_entries=)
* switch mountpoint_hashtable from list_head to hlist_head

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/mount.h     |    2 +-
 fs/namespace.c |   81 ++++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index 61e1c05..46790ae1 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -19,7 +19,7 @@ struct mnt_pcp {
 };
 
 struct mountpoint {
-	struct list_head m_hash;
+	struct hlist_node m_hash;
 	struct dentry *m_dentry;
 	int m_count;
 };
diff --git a/fs/namespace.c b/fs/namespace.c
index 00f12af..6be899f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -23,11 +23,34 @@
 #include <linux/uaccess.h>
 #include <linux/proc_ns.h>
 #include <linux/magic.h>
+#include <linux/bootmem.h>
 #include "pnode.h"
 #include "internal.h"
 
-#define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
-#define HASH_SIZE (1UL << HASH_SHIFT)
+static unsigned int m_hash_mask __read_mostly;
+static unsigned int m_hash_shift __read_mostly;
+static unsigned int mp_hash_mask __read_mostly;
+static unsigned int mp_hash_shift __read_mostly;
+
+static __initdata unsigned long mhash_entries;
+static int __init set_mhash_entries(char *str)
+{
+	if (!str)
+		return 0;
+	mhash_entries = simple_strtoul(str, &str, 0);
+	return 1;
+}
+__setup("mhash_entries=", set_mhash_entries);
+
+static __initdata unsigned long mphash_entries;
+static int __init set_mphash_entries(char *str)
+{
+	if (!str)
+		return 0;
+	mphash_entries = simple_strtoul(str, &str, 0);
+	return 1;
+}
+__setup("mphash_entries=", set_mphash_entries);
 
 static u64 event;
 static DEFINE_IDA(mnt_id_ida);
@@ -37,7 +60,7 @@ static int mnt_id_start = 0;
 static int mnt_group_start = 1;
 
 static struct list_head *mount_hashtable __read_mostly;
-static struct list_head *mountpoint_hashtable __read_mostly;
+static struct hlist_head *mountpoint_hashtable __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
 static DECLARE_RWSEM(namespace_sem);
 
@@ -55,12 +78,19 @@ EXPORT_SYMBOL_GPL(fs_kobj);
  */
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(mount_lock);
 
-static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
+static inline struct list_head *m_hash(struct vfsmount *mnt, struct dentry *dentry)
 {
 	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
 	tmp += ((unsigned long)dentry / L1_CACHE_BYTES);
-	tmp = tmp + (tmp >> HASH_SHIFT);
-	return tmp & (HASH_SIZE - 1);
+	tmp = tmp + (tmp >> m_hash_shift);
+	return &mount_hashtable[tmp & m_hash_mask];
+}
+
+static inline struct hlist_head *mp_hash(struct dentry *dentry)
+{
+	unsigned long tmp = ((unsigned long)dentry / L1_CACHE_BYTES);
+	tmp = tmp + (tmp >> mp_hash_shift);
+	return &mountpoint_hashtable[tmp & mp_hash_mask];
 }
 
 /*
@@ -575,7 +605,7 @@ bool legitimize_mnt(struct vfsmount *bastard, unsigned seq)
  */
 struct mount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry)
 {
-	struct list_head *head = mount_hashtable + hash(mnt, dentry);
+	struct list_head *head = m_hash(mnt, dentry);
 	struct mount *p;
 
 	list_for_each_entry_rcu(p, head, mnt_hash)
@@ -590,7 +620,7 @@ struct mount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry)
  */
 struct mount *__lookup_mnt_last(struct vfsmount *mnt, struct dentry *dentry)
 {
-	struct list_head *head = mount_hashtable + hash(mnt, dentry);
+	struct list_head *head = m_hash(mnt, dentry);
 	struct mount *p;
 
 	list_for_each_entry_reverse(p, head, mnt_hash)
@@ -633,11 +663,11 @@ struct vfsmount *lookup_mnt(struct path *path)
 
 static struct mountpoint *new_mountpoint(struct dentry *dentry)
 {
-	struct list_head *chain = mountpoint_hashtable + hash(NULL, dentry);
+	struct hlist_head *chain = mp_hash(dentry);
 	struct mountpoint *mp;
 	int ret;
 
-	list_for_each_entry(mp, chain, m_hash) {
+	hlist_for_each_entry(mp, chain, m_hash) {
 		if (mp->m_dentry == dentry) {
 			/* might be worth a WARN_ON() */
 			if (d_unlinked(dentry))
@@ -659,7 +689,7 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
 
 	mp->m_dentry = dentry;
 	mp->m_count = 1;
-	list_add(&mp->m_hash, chain);
+	hlist_add_head(&mp->m_hash, chain);
 	return mp;
 }
 
@@ -670,7 +700,7 @@ static void put_mountpoint(struct mountpoint *mp)
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags &= ~DCACHE_MOUNTED;
 		spin_unlock(&dentry->d_lock);
-		list_del(&mp->m_hash);
+		hlist_del(&mp->m_hash);
 		kfree(mp);
 	}
 }
@@ -739,8 +769,7 @@ static void attach_mnt(struct mount *mnt,
 			struct mountpoint *mp)
 {
 	mnt_set_mountpoint(parent, mp, mnt);
-	list_add_tail(&mnt->mnt_hash, mount_hashtable +
-			hash(&parent->mnt, mp->m_dentry));
+	list_add_tail(&mnt->mnt_hash, m_hash(&parent->mnt, mp->m_dentry));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
 }
 
@@ -762,8 +791,8 @@ static void commit_tree(struct mount *mnt)
 
 	list_splice(&head, n->list.prev);
 
-	list_add_tail(&mnt->mnt_hash, mount_hashtable +
-				hash(&parent->mnt, mnt->mnt_mountpoint));
+	list_add_tail(&mnt->mnt_hash,
+				m_hash(&parent->mnt, mnt->mnt_mountpoint));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
 	touch_mnt_namespace(n);
 }
@@ -2794,18 +2823,24 @@ void __init mnt_init(void)
 	mnt_cache = kmem_cache_create("mnt_cache", sizeof(struct mount),
 			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 
-	mount_hashtable = (struct list_head *)__get_free_page(GFP_ATOMIC);
-	mountpoint_hashtable = (struct list_head *)__get_free_page(GFP_ATOMIC);
+	mount_hashtable = alloc_large_system_hash("Mount-cache",
+				sizeof(struct list_head),
+				mhash_entries, 19,
+				0,
+				&m_hash_shift, &m_hash_mask, 0, 0);
+	mountpoint_hashtable = alloc_large_system_hash("Mountpoint-cache",
+				sizeof(struct hlist_head),
+				mphash_entries, 19,
+				0,
+				&mp_hash_shift, &mp_hash_mask, 0, 0);
 
 	if (!mount_hashtable || !mountpoint_hashtable)
 		panic("Failed to allocate mount hash table\n");
 
-	printk(KERN_INFO "Mount-cache hash table entries: %lu\n", HASH_SIZE);
-
-	for (u = 0; u < HASH_SIZE; u++)
+	for (u = 0; u <= m_hash_mask; u++)
 		INIT_LIST_HEAD(&mount_hashtable[u]);
-	for (u = 0; u < HASH_SIZE; u++)
-		INIT_LIST_HEAD(&mountpoint_hashtable[u]);
+	for (u = 0; u <= mp_hash_mask; u++)
+		INIT_HLIST_HEAD(&mountpoint_hashtable[u]);
 
 	kernfs_init();
 
-- 
1.7.10.4

