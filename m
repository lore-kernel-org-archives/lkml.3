Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaIISkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:40:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:15637 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbaIISkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:40:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,492,1406617200"; 
   d="scan'208";a="570725318"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 6/7] staging/lustre/libcfs: remove upcall cache
Date: Tue, 9 Sep 2014 13:39:07 -0500
Message-ID: <1410287948-13168-7-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
References: <1410287948-13168-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.106]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

The upcall cache is unused so remove include/linux/libcfs/lucache.h
and lustre/libcfs/upcall_cache.c.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../staging/lustre/include/linux/libcfs/lucache.h  |  162 -------
 drivers/staging/lustre/lustre/include/lvfs.h       |    2 -
 drivers/staging/lustre/lustre/libcfs/Makefile      |    2 +-
 .../staging/lustre/lustre/libcfs/upcall_cache.c    |  455 --------------------
 4 files changed, 1 insertion(+), 620 deletions(-)
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/lucache.h
 delete mode 100644 drivers/staging/lustre/lustre/libcfs/upcall_cache.c

diff --git a/drivers/staging/lustre/include/linux/libcfs/lucache.h b/drivers/staging/lustre/include/linux/libcfs/lucache.h
deleted file mode 100644
index 5d6e1b9..0000000
--- a/drivers/staging/lustre/include/linux/libcfs/lucache.h
+++ /dev/null
@@ -1,162 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef _LUCACHE_H
-#define _LUCACHE_H
-
-#include "libcfs.h"
-
-/** \defgroup ucache ucache
- *
- * @{
- */
-
-#define UC_CACHE_NEW	    0x01
-#define UC_CACHE_ACQUIRING      0x02
-#define UC_CACHE_INVALID	0x04
-#define UC_CACHE_EXPIRED	0x08
-
-#define UC_CACHE_IS_NEW(i)	  ((i)->ue_flags & UC_CACHE_NEW)
-#define UC_CACHE_IS_INVALID(i)      ((i)->ue_flags & UC_CACHE_INVALID)
-#define UC_CACHE_IS_ACQUIRING(i)    ((i)->ue_flags & UC_CACHE_ACQUIRING)
-#define UC_CACHE_IS_EXPIRED(i)      ((i)->ue_flags & UC_CACHE_EXPIRED)
-#define UC_CACHE_IS_VALID(i)	((i)->ue_flags == 0)
-
-#define UC_CACHE_SET_NEW(i)	 (i)->ue_flags |= UC_CACHE_NEW
-#define UC_CACHE_SET_INVALID(i)     (i)->ue_flags |= UC_CACHE_INVALID
-#define UC_CACHE_SET_ACQUIRING(i)   (i)->ue_flags |= UC_CACHE_ACQUIRING
-#define UC_CACHE_SET_EXPIRED(i)     (i)->ue_flags |= UC_CACHE_EXPIRED
-#define UC_CACHE_SET_VALID(i)       (i)->ue_flags = 0
-
-#define UC_CACHE_CLEAR_NEW(i)       (i)->ue_flags &= ~UC_CACHE_NEW
-#define UC_CACHE_CLEAR_ACQUIRING(i) (i)->ue_flags &= ~UC_CACHE_ACQUIRING
-#define UC_CACHE_CLEAR_INVALID(i)   (i)->ue_flags &= ~UC_CACHE_INVALID
-#define UC_CACHE_CLEAR_EXPIRED(i)   (i)->ue_flags &= ~UC_CACHE_EXPIRED
-
-struct upcall_cache_entry;
-
-struct md_perm {
-	lnet_nid_t      mp_nid;
-	__u32	   mp_perm;
-};
-
-struct md_identity {
-	struct upcall_cache_entry *mi_uc_entry;
-	uid_t		      mi_uid;
-	gid_t		      mi_gid;
-	struct group_info	*mi_ginfo;
-	int			mi_nperms;
-	struct md_perm	    *mi_perms;
-};
-
-struct upcall_cache_entry {
-	struct list_head	      ue_hash;
-	__u64		   ue_key;
-	atomic_t	    ue_refcount;
-	int		     ue_flags;
-	wait_queue_head_t	     ue_waitq;
-	unsigned long	      ue_acquire_expire;
-	unsigned long	      ue_expire;
-	union {
-		struct md_identity     identity;
-	} u;
-};
-
-#define UC_CACHE_HASH_SIZE	(128)
-#define UC_CACHE_HASH_INDEX(id)   ((id) & (UC_CACHE_HASH_SIZE - 1))
-#define UC_CACHE_UPCALL_MAXPATH   (1024UL)
-
-struct upcall_cache;
-
-struct upcall_cache_ops {
-	void	    (*init_entry)(struct upcall_cache_entry *, void *args);
-	void	    (*free_entry)(struct upcall_cache *,
-				  struct upcall_cache_entry *);
-	int	     (*upcall_compare)(struct upcall_cache *,
-				       struct upcall_cache_entry *,
-					  __u64 key, void *args);
-	int	     (*downcall_compare)(struct upcall_cache *,
-					 struct upcall_cache_entry *,
-					    __u64 key, void *args);
-	int	     (*do_upcall)(struct upcall_cache *,
-				  struct upcall_cache_entry *);
-	int	     (*parse_downcall)(struct upcall_cache *,
-				       struct upcall_cache_entry *, void *);
-};
-
-struct upcall_cache {
-	struct list_head		uc_hashtable[UC_CACHE_HASH_SIZE];
-	spinlock_t		uc_lock;
-	rwlock_t		uc_upcall_rwlock;
-
-	char			uc_name[40];		/* for upcall */
-	char			uc_upcall[UC_CACHE_UPCALL_MAXPATH];
-	int			uc_acquire_expire;	/* seconds */
-	int			uc_entry_expire;	/* seconds */
-	struct upcall_cache_ops	*uc_ops;
-};
-
-struct upcall_cache_entry *upcall_cache_get_entry(struct upcall_cache *cache,
-						  __u64 key, void *args);
-void upcall_cache_put_entry(struct upcall_cache *cache,
-			    struct upcall_cache_entry *entry);
-int upcall_cache_downcall(struct upcall_cache *cache, __u32 err, __u64 key,
-			  void *args);
-void upcall_cache_flush_idle(struct upcall_cache *cache);
-void upcall_cache_flush_all(struct upcall_cache *cache);
-void upcall_cache_flush_one(struct upcall_cache *cache, __u64 key, void *args);
-struct upcall_cache *upcall_cache_init(const char *name, const char *upcall,
-				       struct upcall_cache_ops *ops);
-void upcall_cache_cleanup(struct upcall_cache *cache);
-
-#if 0
-struct upcall_cache_entry *upcall_cache_get_entry(struct upcall_cache *hash,
-						  __u64 key, __u32 primary,
-						  __u32 ngroups, __u32 *groups);
-void upcall_cache_put_entry(struct upcall_cache *hash,
-			    struct upcall_cache_entry *entry);
-int upcall_cache_downcall(struct upcall_cache *hash, __u32 err, __u64 key,
-			  __u32 primary, __u32 ngroups, __u32 *groups);
-void upcall_cache_flush_idle(struct upcall_cache *cache);
-void upcall_cache_flush_all(struct upcall_cache *cache);
-struct upcall_cache *upcall_cache_init(const char *name);
-void upcall_cache_cleanup(struct upcall_cache *hash);
-
-#endif
-
-/** @} ucache */
-
-#endif /* _LUCACHE_H */
diff --git a/drivers/staging/lustre/lustre/include/lvfs.h b/drivers/staging/lustre/lustre/include/lvfs.h
index 83bbce5..a98307ba 100644
--- a/drivers/staging/lustre/lustre/include/lvfs.h
+++ b/drivers/staging/lustre/lustre/include/lvfs.h
@@ -42,6 +42,4 @@
 #include "../../include/linux/libcfs/libcfs.h"
 #include "linux/lvfs.h"
 
-#include "../../include/linux/libcfs/lucache.h"
-
 #endif
diff --git a/drivers/staging/lustre/lustre/libcfs/Makefile b/drivers/staging/lustre/lustre/libcfs/Makefile
index aeeaab7..fcecbd2 100644
--- a/drivers/staging/lustre/lustre/libcfs/Makefile
+++ b/drivers/staging/lustre/lustre/libcfs/Makefile
@@ -12,7 +12,7 @@ libcfs-linux-objs := $(addprefix linux/,$(libcfs-linux-objs))
 
 libcfs-all-objs := debug.o fail.o nidstrings.o module.o tracefile.o \
 		   libcfs_string.o hash.o kernel_user_comm.o \
-		   prng.o workitem.o upcall_cache.o libcfs_cpu.o \
+		   prng.o workitem.o libcfs_cpu.o \
 		   libcfs_mem.o libcfs_lock.o
 
 libcfs-objs := $(libcfs-linux-objs) $(libcfs-all-objs)
diff --git a/drivers/staging/lustre/lustre/libcfs/upcall_cache.c b/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
deleted file mode 100644
index f5e08caa..0000000
--- a/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
+++ /dev/null
@@ -1,455 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * libcfs/libcfs/upcall_cache.c
- *
- * Supplementary groups cache.
- */
-#define DEBUG_SUBSYSTEM S_SEC
-
-#include "../../include/linux/libcfs/lucache.h"
-
-static struct upcall_cache_entry *alloc_entry(struct upcall_cache *cache,
-					      __u64 key, void *args)
-{
-	struct upcall_cache_entry *entry;
-
-	LIBCFS_ALLOC(entry, sizeof(*entry));
-	if (!entry)
-		return NULL;
-
-	UC_CACHE_SET_NEW(entry);
-	INIT_LIST_HEAD(&entry->ue_hash);
-	entry->ue_key = key;
-	atomic_set(&entry->ue_refcount, 0);
-	init_waitqueue_head(&entry->ue_waitq);
-	if (cache->uc_ops->init_entry)
-		cache->uc_ops->init_entry(entry, args);
-	return entry;
-}
-
-/* protected by cache lock */
-static void free_entry(struct upcall_cache *cache,
-		       struct upcall_cache_entry *entry)
-{
-	if (cache->uc_ops->free_entry)
-		cache->uc_ops->free_entry(cache, entry);
-
-	list_del(&entry->ue_hash);
-	CDEBUG(D_OTHER, "destroy cache entry %p for key %llu\n",
-	       entry, entry->ue_key);
-	LIBCFS_FREE(entry, sizeof(*entry));
-}
-
-static inline int upcall_compare(struct upcall_cache *cache,
-				 struct upcall_cache_entry *entry,
-				 __u64 key, void *args)
-{
-	if (entry->ue_key != key)
-		return -1;
-
-	if (cache->uc_ops->upcall_compare)
-		return cache->uc_ops->upcall_compare(cache, entry, key, args);
-
-	return 0;
-}
-
-static inline int downcall_compare(struct upcall_cache *cache,
-				   struct upcall_cache_entry *entry,
-				   __u64 key, void *args)
-{
-	if (entry->ue_key != key)
-		return -1;
-
-	if (cache->uc_ops->downcall_compare)
-		return cache->uc_ops->downcall_compare(cache, entry, key, args);
-
-	return 0;
-}
-
-static inline void get_entry(struct upcall_cache_entry *entry)
-{
-	atomic_inc(&entry->ue_refcount);
-}
-
-static inline void put_entry(struct upcall_cache *cache,
-			     struct upcall_cache_entry *entry)
-{
-	if (atomic_dec_and_test(&entry->ue_refcount) &&
-	    (UC_CACHE_IS_INVALID(entry) || UC_CACHE_IS_EXPIRED(entry))) {
-		free_entry(cache, entry);
-	}
-}
-
-static int check_unlink_entry(struct upcall_cache *cache,
-			      struct upcall_cache_entry *entry)
-{
-	if (UC_CACHE_IS_VALID(entry) &&
-	    time_before(cfs_time_current(), entry->ue_expire))
-		return 0;
-
-	if (UC_CACHE_IS_ACQUIRING(entry)) {
-		if (entry->ue_acquire_expire == 0 ||
-		    time_before(cfs_time_current(), entry->ue_acquire_expire))
-			return 0;
-
-		UC_CACHE_SET_EXPIRED(entry);
-		wake_up_all(&entry->ue_waitq);
-	} else if (!UC_CACHE_IS_INVALID(entry)) {
-		UC_CACHE_SET_EXPIRED(entry);
-	}
-
-	list_del_init(&entry->ue_hash);
-	if (!atomic_read(&entry->ue_refcount))
-		free_entry(cache, entry);
-	return 1;
-}
-
-static inline int refresh_entry(struct upcall_cache *cache,
-			 struct upcall_cache_entry *entry)
-{
-	LASSERT(cache->uc_ops->do_upcall);
-	return cache->uc_ops->do_upcall(cache, entry);
-}
-
-struct upcall_cache_entry *upcall_cache_get_entry(struct upcall_cache *cache,
-						  __u64 key, void *args)
-{
-	struct upcall_cache_entry *entry = NULL, *new = NULL, *next;
-	struct list_head *head;
-	wait_queue_t wait;
-	int rc, found;
-
-	LASSERT(cache);
-
-	head = &cache->uc_hashtable[UC_CACHE_HASH_INDEX(key)];
-find_again:
-	found = 0;
-	spin_lock(&cache->uc_lock);
-	list_for_each_entry_safe(entry, next, head, ue_hash) {
-		/* check invalid & expired items */
-		if (check_unlink_entry(cache, entry))
-			continue;
-		if (upcall_compare(cache, entry, key, args) == 0) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (!found) {
-		if (!new) {
-			spin_unlock(&cache->uc_lock);
-			new = alloc_entry(cache, key, args);
-			if (!new) {
-				CERROR("fail to alloc entry\n");
-				return ERR_PTR(-ENOMEM);
-			}
-			goto find_again;
-		} else {
-			list_add(&new->ue_hash, head);
-			entry = new;
-		}
-	} else {
-		if (new) {
-			free_entry(cache, new);
-			new = NULL;
-		}
-		list_move(&entry->ue_hash, head);
-	}
-	get_entry(entry);
-
-	/* acquire for new one */
-	if (UC_CACHE_IS_NEW(entry)) {
-		UC_CACHE_SET_ACQUIRING(entry);
-		UC_CACHE_CLEAR_NEW(entry);
-		spin_unlock(&cache->uc_lock);
-		rc = refresh_entry(cache, entry);
-		spin_lock(&cache->uc_lock);
-		entry->ue_acquire_expire =
-			cfs_time_shift(cache->uc_acquire_expire);
-		if (rc < 0) {
-			UC_CACHE_CLEAR_ACQUIRING(entry);
-			UC_CACHE_SET_INVALID(entry);
-			wake_up_all(&entry->ue_waitq);
-			if (unlikely(rc == -EREMCHG)) {
-				put_entry(cache, entry);
-				entry = ERR_PTR(rc);
-				goto out;
-			}
-		}
-	}
-	/* someone (and only one) is doing upcall upon this item,
-	 * wait it to complete */
-	if (UC_CACHE_IS_ACQUIRING(entry)) {
-		long expiry = (entry == new) ?
-			      cfs_time_seconds(cache->uc_acquire_expire) :
-			      MAX_SCHEDULE_TIMEOUT;
-		long left;
-
-		init_waitqueue_entry(&wait, current);
-		add_wait_queue(&entry->ue_waitq, &wait);
-		set_current_state(TASK_INTERRUPTIBLE);
-		spin_unlock(&cache->uc_lock);
-
-		left = schedule_timeout(expiry);
-
-		spin_lock(&cache->uc_lock);
-		remove_wait_queue(&entry->ue_waitq, &wait);
-		if (UC_CACHE_IS_ACQUIRING(entry)) {
-			/* we're interrupted or upcall failed in the middle */
-			rc = left > 0 ? -EINTR : -ETIMEDOUT;
-			CERROR("acquire for key %llu: error %d\n",
-			       entry->ue_key, rc);
-			put_entry(cache, entry);
-			entry = ERR_PTR(rc);
-			goto out;
-		}
-	}
-
-	/* invalid means error, don't need to try again */
-	if (UC_CACHE_IS_INVALID(entry)) {
-		put_entry(cache, entry);
-		entry = ERR_PTR(-EIDRM);
-		goto out;
-	}
-
-	/* check expired
-	 * We can't refresh the existing one because some
-	 * memory might be shared by multiple processes.
-	 */
-	if (check_unlink_entry(cache, entry)) {
-		/* if expired, try again. but if this entry is
-		 * created by me but too quickly turn to expired
-		 * without any error, should at least give a
-		 * chance to use it once.
-		 */
-		if (entry != new) {
-			put_entry(cache, entry);
-			spin_unlock(&cache->uc_lock);
-			new = NULL;
-			goto find_again;
-		}
-	}
-
-	/* Now we know it's good */
-out:
-	spin_unlock(&cache->uc_lock);
-	return entry;
-}
-EXPORT_SYMBOL(upcall_cache_get_entry);
-
-void upcall_cache_put_entry(struct upcall_cache *cache,
-			    struct upcall_cache_entry *entry)
-{
-	if (!entry) {
-		return;
-	}
-
-	LASSERT(atomic_read(&entry->ue_refcount) > 0);
-	spin_lock(&cache->uc_lock);
-	put_entry(cache, entry);
-	spin_unlock(&cache->uc_lock);
-}
-EXPORT_SYMBOL(upcall_cache_put_entry);
-
-int upcall_cache_downcall(struct upcall_cache *cache, __u32 err, __u64 key,
-			  void *args)
-{
-	struct upcall_cache_entry *entry = NULL;
-	struct list_head *head;
-	int found = 0, rc = 0;
-
-	LASSERT(cache);
-
-	head = &cache->uc_hashtable[UC_CACHE_HASH_INDEX(key)];
-
-	spin_lock(&cache->uc_lock);
-	list_for_each_entry(entry, head, ue_hash) {
-		if (downcall_compare(cache, entry, key, args) == 0) {
-			found = 1;
-			get_entry(entry);
-			break;
-		}
-	}
-
-	if (!found) {
-		CDEBUG(D_OTHER, "%s: upcall for key %llu not expected\n",
-		       cache->uc_name, key);
-		/* haven't found, it's possible */
-		spin_unlock(&cache->uc_lock);
-		return -EINVAL;
-	}
-
-	if (err) {
-		CDEBUG(D_OTHER, "%s: upcall for key %llu returned %d\n",
-		       cache->uc_name, entry->ue_key, err);
-		rc = -EINVAL;
-		goto out;
-	}
-
-	if (!UC_CACHE_IS_ACQUIRING(entry)) {
-		CDEBUG(D_RPCTRACE, "%s: found uptodate entry %p (key %llu)\n",
-		       cache->uc_name, entry, entry->ue_key);
-		rc = 0;
-		goto out;
-	}
-
-	if (UC_CACHE_IS_INVALID(entry) || UC_CACHE_IS_EXPIRED(entry)) {
-		CERROR("%s: found a stale entry %p (key %llu) in ioctl\n",
-		       cache->uc_name, entry, entry->ue_key);
-		rc = -EINVAL;
-		goto out;
-	}
-
-	spin_unlock(&cache->uc_lock);
-	if (cache->uc_ops->parse_downcall)
-		rc = cache->uc_ops->parse_downcall(cache, entry, args);
-	spin_lock(&cache->uc_lock);
-	if (rc)
-		goto out;
-
-	entry->ue_expire = cfs_time_shift(cache->uc_entry_expire);
-	UC_CACHE_SET_VALID(entry);
-	CDEBUG(D_OTHER, "%s: created upcall cache entry %p for key %llu\n",
-	       cache->uc_name, entry, entry->ue_key);
-out:
-	if (rc) {
-		UC_CACHE_SET_INVALID(entry);
-		list_del_init(&entry->ue_hash);
-	}
-	UC_CACHE_CLEAR_ACQUIRING(entry);
-	spin_unlock(&cache->uc_lock);
-	wake_up_all(&entry->ue_waitq);
-	put_entry(cache, entry);
-
-	return rc;
-}
-EXPORT_SYMBOL(upcall_cache_downcall);
-
-static void cache_flush(struct upcall_cache *cache, int force)
-{
-	struct upcall_cache_entry *entry, *next;
-	int i;
-
-	spin_lock(&cache->uc_lock);
-	for (i = 0; i < UC_CACHE_HASH_SIZE; i++) {
-		list_for_each_entry_safe(entry, next,
-					 &cache->uc_hashtable[i], ue_hash) {
-			if (!force && atomic_read(&entry->ue_refcount)) {
-				UC_CACHE_SET_EXPIRED(entry);
-				continue;
-			}
-			LASSERT(!atomic_read(&entry->ue_refcount));
-			free_entry(cache, entry);
-		}
-	}
-	spin_unlock(&cache->uc_lock);
-}
-
-void upcall_cache_flush_idle(struct upcall_cache *cache)
-{
-	cache_flush(cache, 0);
-}
-EXPORT_SYMBOL(upcall_cache_flush_idle);
-
-void upcall_cache_flush_all(struct upcall_cache *cache)
-{
-	cache_flush(cache, 1);
-}
-EXPORT_SYMBOL(upcall_cache_flush_all);
-
-void upcall_cache_flush_one(struct upcall_cache *cache, __u64 key, void *args)
-{
-	struct list_head *head;
-	struct upcall_cache_entry *entry;
-	int found = 0;
-
-	head = &cache->uc_hashtable[UC_CACHE_HASH_INDEX(key)];
-
-	spin_lock(&cache->uc_lock);
-	list_for_each_entry(entry, head, ue_hash) {
-		if (upcall_compare(cache, entry, key, args) == 0) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (found) {
-		CWARN("%s: flush entry %p: key %llu, ref %d, fl %x, cur %lu, ex %ld/%ld\n",
-		      cache->uc_name, entry, entry->ue_key,
-		      atomic_read(&entry->ue_refcount), entry->ue_flags,
-		      get_seconds(), entry->ue_acquire_expire,
-		      entry->ue_expire);
-		UC_CACHE_SET_EXPIRED(entry);
-		if (!atomic_read(&entry->ue_refcount))
-			free_entry(cache, entry);
-	}
-	spin_unlock(&cache->uc_lock);
-}
-EXPORT_SYMBOL(upcall_cache_flush_one);
-
-struct upcall_cache *upcall_cache_init(const char *name, const char *upcall,
-				       struct upcall_cache_ops *ops)
-{
-	struct upcall_cache *cache;
-	int i;
-
-	LIBCFS_ALLOC(cache, sizeof(*cache));
-	if (!cache)
-		return ERR_PTR(-ENOMEM);
-
-	spin_lock_init(&cache->uc_lock);
-	rwlock_init(&cache->uc_upcall_rwlock);
-	for (i = 0; i < UC_CACHE_HASH_SIZE; i++)
-		INIT_LIST_HEAD(&cache->uc_hashtable[i]);
-	strncpy(cache->uc_name, name, sizeof(cache->uc_name) - 1);
-	/* upcall pathname proc tunable */
-	strncpy(cache->uc_upcall, upcall, sizeof(cache->uc_upcall) - 1);
-	cache->uc_entry_expire = 20 * 60;
-	cache->uc_acquire_expire = 30;
-	cache->uc_ops = ops;
-
-	return cache;
-}
-EXPORT_SYMBOL(upcall_cache_init);
-
-void upcall_cache_cleanup(struct upcall_cache *cache)
-{
-	if (!cache)
-		return;
-	upcall_cache_flush_all(cache);
-	LIBCFS_FREE(cache, sizeof(*cache));
-}
-EXPORT_SYMBOL(upcall_cache_cleanup);
-- 
1.7.9.5

