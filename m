Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaDYNsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:48:01 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24246 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaDYNr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:47:58 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] dcookies: use generic hashtable implementation
Date: Fri, 25 Apr 2014 09:47:48 -0400
Message-Id: <1398433668-16201-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch dcookies to use the kernel's generic hashtable implementation
instead of a custom one. Less code, more readable and same result.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/dcookies.c |   97 ++++++++++-----------------------------------------------
 1 file changed, 16 insertions(+), 81 deletions(-)

diff --git a/fs/dcookies.c b/fs/dcookies.c
index ac44a69..65014b5 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -26,6 +26,7 @@
 #include <linux/mutex.h>
 #include <linux/path.h>
 #include <linux/compat.h>
+#include <linux/hashtable.h>
 #include <asm/uaccess.h>
 
 /* The dcookies are allocated from a kmem_cache and
@@ -34,14 +35,13 @@
  */
 struct dcookie_struct {
 	struct path path;
-	struct list_head hash_list;
+	struct hlist_node hash_list;
 };
 
 static LIST_HEAD(dcookie_users);
 static DEFINE_MUTEX(dcookie_mutex);
 static struct kmem_cache *dcookie_cache __read_mostly;
-static struct list_head *dcookie_hashtable __read_mostly;
-static size_t hash_size __read_mostly;
+static __read_mostly DEFINE_HASHTABLE(dcookie_hashtable, 10);
 
 static inline int is_live(void)
 {
@@ -55,38 +55,21 @@ static inline unsigned long dcookie_value(struct dcookie_struct * dcs)
 	return (unsigned long)dcs->path.dentry;
 }
 
-
-static size_t dcookie_hash(unsigned long dcookie)
-{
-	return (dcookie >> L1_CACHE_SHIFT) & (hash_size - 1);
-}
-
-
 static struct dcookie_struct * find_dcookie(unsigned long dcookie)
 {
-	struct dcookie_struct *found = NULL;
-	struct dcookie_struct * dcs;
-	struct list_head * pos;
-	struct list_head * list;
+	struct dcookie_struct *dcs;
 
-	list = dcookie_hashtable + dcookie_hash(dcookie);
+	hash_for_each_possible(dcookie_hashtable, dcs, hash_list, dcookie)
+		if (dcookie_value(dcs) == dcookie)
+			return dcs;
 
-	list_for_each(pos, list) {
-		dcs = list_entry(pos, struct dcookie_struct, hash_list);
-		if (dcookie_value(dcs) == dcookie) {
-			found = dcs;
-			break;
-		}
-	}
-
-	return found;
+	return NULL;
 }
 
 
 static void hash_dcookie(struct dcookie_struct * dcs)
 {
-	struct list_head * list = dcookie_hashtable + dcookie_hash(dcookie_value(dcs));
-	list_add(&dcs->hash_list, list);
+	hash_add(dcookie_hashtable, &dcs->hash_list, dcookie_value(dcs));
 }
 
 
@@ -216,55 +199,14 @@ COMPAT_SYSCALL_DEFINE4(lookup_dcookie, u32, w0, u32, w1, char __user *, buf, com
 
 static int dcookie_init(void)
 {
-	struct list_head * d;
-	unsigned int i, hash_bits;
-	int err = -ENOMEM;
-
 	dcookie_cache = kmem_cache_create("dcookie_cache",
 		sizeof(struct dcookie_struct),
 		0, 0, NULL);
 
 	if (!dcookie_cache)
-		goto out;
-
-	dcookie_hashtable = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!dcookie_hashtable)
-		goto out_kmem;
+		return -ENOMEM;
 
-	err = 0;
-
-	/*
-	 * Find the power-of-two list-heads that can fit into the allocation..
-	 * We don't guarantee that "sizeof(struct list_head)" is necessarily
-	 * a power-of-two.
-	 */
-	hash_size = PAGE_SIZE / sizeof(struct list_head);
-	hash_bits = 0;
-	do {
-		hash_bits++;
-	} while ((hash_size >> hash_bits) != 0);
-	hash_bits--;
-
-	/*
-	 * Re-calculate the actual number of entries and the mask
-	 * from the number of bits we can fit.
-	 */
-	hash_size = 1UL << hash_bits;
-
-	/* And initialize the newly allocated array */
-	d = dcookie_hashtable;
-	i = hash_size;
-	do {
-		INIT_LIST_HEAD(d);
-		d++;
-		i--;
-	} while (i);
-
-out:
-	return err;
-out_kmem:
-	kmem_cache_destroy(dcookie_cache);
-	goto out;
+	return 0;
 }
 
 
@@ -283,22 +225,15 @@ static void free_dcookie(struct dcookie_struct * dcs)
 
 static void dcookie_exit(void)
 {
-	struct list_head * list;
-	struct list_head * pos;
-	struct list_head * pos2;
-	struct dcookie_struct * dcs;
+	struct hlist_node *pos;
+	struct dcookie_struct *dcs;
 	size_t i;
 
-	for (i = 0; i < hash_size; ++i) {
-		list = dcookie_hashtable + i;
-		list_for_each_safe(pos, pos2, list) {
-			dcs = list_entry(pos, struct dcookie_struct, hash_list);
-			list_del(&dcs->hash_list);
-			free_dcookie(dcs);
-		}
+	hash_for_each_safe(dcookie_hashtable, i, pos, dcs, hash_list) {
+		hash_del(&dcs->hash_list);
+		free_dcookie(dcs);
 	}
 
-	kfree(dcookie_hashtable);
 	kmem_cache_destroy(dcookie_cache);
 }
 
-- 
1.7.10.4

