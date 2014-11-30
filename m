Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaK3MUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:20:04 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14388 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaK3MUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:20:01 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/6] UBI: Move fastmap specific functions out of wl.c
Date: Sun, 30 Nov 2014 13:19:43 +0100
Message-Id: <1417349988-9238-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349988-9238-1-git-send-email-richard@nod.at>
References: <1417349988-9238-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fastmap is tightly connected to the WL sub-system, many fastmap-specific
functionslive in wl.c.
To get rid of most #ifdefs in wl.c move this functions into a new file
and include it into wl.c

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap-wl.c | 361 +++++++++++++++++++++++++++
 drivers/mtd/ubi/wl.c         | 563 ++++++++-----------------------------------
 drivers/mtd/ubi/wl.h         |  18 ++
 3 files changed, 476 insertions(+), 466 deletions(-)
 create mode 100644 drivers/mtd/ubi/fastmap-wl.c
 create mode 100644 drivers/mtd/ubi/wl.h

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
new file mode 100644
index 0000000..88a400c
--- /dev/null
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -0,0 +1,361 @@
+/*
+ * Copyright (c) 2012 Linutronix GmbH
+ * Copyright (c) 2014 sigma star gmbh
+ * Author: Richard Weinberger <richard@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ */
+
+/**
+ * update_fastmap_work_fn - calls ubi_update_fastmap from a work queue
+ * @wrk: the work description object
+ */
+static void update_fastmap_work_fn(struct work_struct *wrk)
+{
+	struct ubi_device *ubi = container_of(wrk, struct ubi_device, fm_work);
+	ubi_update_fastmap(ubi);
+	spin_lock(&ubi->wl_lock);
+	ubi->fm_work_scheduled = 0;
+	spin_unlock(&ubi->wl_lock);
+}
+
+/**
+ *  is_fm_block - returns 1 if a PEB is currently used in a fastmap.
+ *  @ubi: UBI device description object
+ *  @pnum: the to be checked PEB
+ */
+static int is_fm_block(struct ubi_device *ubi, int pnum)
+{
+	int i;
+
+	if (!ubi->fm)
+		return 0;
+
+	for (i = 0; i < ubi->fm->used_blocks; i++)
+		if (ubi->fm->e[i]->pnum == pnum)
+			return 1;
+
+	return 0;
+}
+
+/**
+ * find_anchor_wl_entry - find wear-leveling entry to used as anchor PEB.
+ * @root: the RB-tree where to look for
+ */
+static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root)
+{
+	struct rb_node *p;
+	struct ubi_wl_entry *e, *victim = NULL;
+	int max_ec = UBI_MAX_ERASECOUNTER;
+
+	ubi_rb_for_each_entry(p, e, root, u.rb) {
+		if (e->pnum < UBI_FM_MAX_START && e->ec < max_ec) {
+			victim = e;
+			max_ec = e->ec;
+		}
+	}
+
+	return victim;
+}
+
+/**
+ * return_unused_pool_pebs - returns unused PEB to the free tree.
+ * @ubi: UBI device description object
+ * @pool: fastmap pool description object
+ */
+static void return_unused_pool_pebs(struct ubi_device *ubi,
+				    struct ubi_fm_pool *pool)
+{
+	int i;
+	struct ubi_wl_entry *e;
+
+	for (i = pool->used; i < pool->size; i++) {
+		e = ubi->lookuptbl[pool->pebs[i]];
+		wl_tree_add(e, &ubi->free);
+		ubi->free_count++;
+	}
+}
+
+static int anchor_pebs_avalible(struct rb_root *root)
+{
+	struct rb_node *p;
+	struct ubi_wl_entry *e;
+
+	ubi_rb_for_each_entry(p, e, root, u.rb)
+		if (e->pnum < UBI_FM_MAX_START)
+			return 1;
+
+	return 0;
+}
+
+/**
+ * ubi_wl_get_fm_peb - find a physical erase block with a given maximal number.
+ * @ubi: UBI device description object
+ * @anchor: This PEB will be used as anchor PEB by fastmap
+ *
+ * The function returns a physical erase block with a given maximal number
+ * and removes it from the wl subsystem.
+ * Must be called with wl_lock held!
+ */
+struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int anchor)
+{
+	struct ubi_wl_entry *e = NULL;
+
+	if (!ubi->free.rb_node || (ubi->free_count - ubi->beb_rsvd_pebs < 1))
+		goto out;
+
+	if (anchor)
+		e = find_anchor_wl_entry(&ubi->free);
+	else
+		e = find_mean_wl_entry(ubi, &ubi->free);
+
+	if (!e)
+		goto out;
+
+	self_check_in_wl_tree(ubi, e, &ubi->free);
+
+	/* remove it from the free list,
+	 * the wl subsystem does no longer know this erase block */
+	rb_erase(&e->u.rb, &ubi->free);
+	ubi->free_count--;
+out:
+	return e;
+}
+
+/**
+ * ubi_refill_pools - refills all fastmap PEB pools.
+ * @ubi: UBI device description object
+ */
+void ubi_refill_pools(struct ubi_device *ubi)
+{
+	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
+	struct ubi_fm_pool *pool = &ubi->fm_pool;
+	struct ubi_wl_entry *e;
+	int enough;
+
+	spin_lock(&ubi->wl_lock);
+
+	return_unused_pool_pebs(ubi, wl_pool);
+	return_unused_pool_pebs(ubi, pool);
+
+	wl_pool->size = 0;
+	pool->size = 0;
+
+	for (;;) {
+		enough = 0;
+		if (pool->size < pool->max_size) {
+			if (!ubi->free.rb_node)
+				break;
+
+			e = wl_get_wle(ubi);
+			if (!e)
+				break;
+
+			pool->pebs[pool->size] = e->pnum;
+			pool->size++;
+		} else
+			enough++;
+
+		if (wl_pool->size < wl_pool->max_size) {
+			if (!ubi->free.rb_node ||
+			   (ubi->free_count - ubi->beb_rsvd_pebs < 5))
+				break;
+
+			e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
+			self_check_in_wl_tree(ubi, e, &ubi->free);
+			rb_erase(&e->u.rb, &ubi->free);
+			ubi->free_count--;
+
+			wl_pool->pebs[wl_pool->size] = e->pnum;
+			wl_pool->size++;
+		} else
+			enough++;
+
+		if (enough == 2)
+			break;
+	}
+
+	wl_pool->used = 0;
+	pool->used = 0;
+
+	spin_unlock(&ubi->wl_lock);
+}
+
+/**
+ * ubi_wl_get_peb - get a physical eraseblock.
+ * @ubi: UBI device description object
+ *
+ * This function returns a physical eraseblock in case of success and a
+ * negative error code in case of failure.
+ * Returns with ubi->fm_eba_sem held in read mode!
+ */
+int ubi_wl_get_peb(struct ubi_device *ubi)
+{
+	int ret, retried = 0;
+	struct ubi_fm_pool *pool = &ubi->fm_pool;
+	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
+
+again:
+	down_read(&ubi->fm_eba_sem);
+	spin_lock(&ubi->wl_lock);
+
+	/* We check here also for the WL pool because at this point we can
+	 * refill the WL pool synchronous. */
+	if (pool->used == pool->size || wl_pool->used == wl_pool->size) {
+		spin_unlock(&ubi->wl_lock);
+		up_read(&ubi->fm_eba_sem);
+		ret = ubi_update_fastmap(ubi);
+		if (ret) {
+			ubi_msg(ubi, "Unable to write a new fastmap: %i", ret);
+			down_read(&ubi->fm_eba_sem);
+			return -ENOSPC;
+		}
+		down_read(&ubi->fm_eba_sem);
+		spin_lock(&ubi->wl_lock);
+	}
+
+	if (pool->used == pool->size) {
+		spin_unlock(&ubi->wl_lock);
+		if (retried) {
+			ubi_err(ubi, "Unable to get a free PEB from user WL pool");
+			ret = -ENOSPC;
+			goto out;
+		}
+		retried = 1;
+		up_read(&ubi->fm_eba_sem);
+		goto again;
+	}
+
+	ubi_assert(pool->used < pool->size);
+	ret = pool->pebs[pool->used++];
+	prot_queue_add(ubi, ubi->lookuptbl[ret]);
+	spin_unlock(&ubi->wl_lock);
+out:
+	return ret;
+}
+
+/* get_peb_for_wl - returns a PEB to be used internally by the WL sub-system.
+ *
+ * @ubi: UBI device description object
+ */
+static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
+{
+	struct ubi_fm_pool *pool = &ubi->fm_wl_pool;
+	int pnum;
+
+	if (pool->used == pool->size) {
+		/* We cannot update the fastmap here because this
+		 * function is called in atomic context.
+		 * Let's fail here and refill/update it as soon as possible. */
+		if (!ubi->fm_work_scheduled) {
+			ubi->fm_work_scheduled = 1;
+			schedule_work(&ubi->fm_work);
+		}
+		return NULL;
+	} else {
+		pnum = pool->pebs[pool->used++];
+		return ubi->lookuptbl[pnum];
+	}
+}
+
+/**
+ * ubi_ensure_anchor_pebs - schedule wear-leveling to produce an anchor PEB.
+ * @ubi: UBI device description object
+ */
+int ubi_ensure_anchor_pebs(struct ubi_device *ubi)
+{
+	struct ubi_work *wrk;
+
+	spin_lock(&ubi->wl_lock);
+	if (ubi->wl_scheduled) {
+		spin_unlock(&ubi->wl_lock);
+		return 0;
+	}
+	ubi->wl_scheduled = 1;
+	spin_unlock(&ubi->wl_lock);
+
+	wrk = kmalloc(sizeof(struct ubi_work), GFP_NOFS);
+	if (!wrk) {
+		spin_lock(&ubi->wl_lock);
+		ubi->wl_scheduled = 0;
+		spin_unlock(&ubi->wl_lock);
+		return -ENOMEM;
+	}
+
+	wrk->anchor = 1;
+	wrk->func = &wear_leveling_worker;
+	schedule_ubi_work(ubi, wrk);
+	return 0;
+}
+
+/**
+ * ubi_wl_put_fm_peb - returns a PEB used in a fastmap to the wear-leveling
+ * sub-system.
+ * see: ubi_wl_put_peb()
+ *
+ * @ubi: UBI device description object
+ * @fm_e: physical eraseblock to return
+ * @lnum: the last used logical eraseblock number for the PEB
+ * @torture: if this physical eraseblock has to be tortured
+ */
+int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *fm_e,
+		      int lnum, int torture)
+{
+	struct ubi_wl_entry *e;
+	int vol_id, pnum = fm_e->pnum;
+
+	dbg_wl("PEB %d", pnum);
+
+	ubi_assert(pnum >= 0);
+	ubi_assert(pnum < ubi->peb_count);
+
+	spin_lock(&ubi->wl_lock);
+	e = ubi->lookuptbl[pnum];
+
+	/* This can happen if we recovered from a fastmap the very
+	 * first time and writing now a new one. In this case the wl system
+	 * has never seen any PEB used by the original fastmap.
+	 */
+	if (!e) {
+		e = fm_e;
+		ubi_assert(e->ec >= 0);
+		ubi->lookuptbl[pnum] = e;
+	}
+
+	spin_unlock(&ubi->wl_lock);
+
+	vol_id = lnum ? UBI_FM_DATA_VOLUME_ID : UBI_FM_SB_VOLUME_ID;
+	return schedule_erase(ubi, e, vol_id, lnum, torture);
+}
+
+/**
+ * ubi_is_erase_work - checks whether a work is erase work.
+ * @wrk: The work object to be checked
+ */
+int ubi_is_erase_work(struct ubi_work *wrk)
+{
+	return wrk->func == erase_worker;
+}
+
+static void ubi_fastmap_close(struct ubi_device *ubi)
+{
+	int i;
+
+	flush_work(&ubi->fm_work);
+	return_unused_pool_pebs(ubi, &ubi->fm_pool);
+	return_unused_pool_pebs(ubi, &ubi->fm_wl_pool);
+
+	if (ubi->fm) {
+		for (i = 0; i < ubi->fm->used_blocks; i++)
+			kfree(ubi->fm->e[i]);
+	}
+	kfree(ubi->fm);
+}
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index b122bdb..2892039 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -103,6 +103,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include "ubi.h"
+#include "wl.h"
 
 /* Number of physical eraseblocks reserved for wear-leveling purposes */
 #define WL_RESERVED_PEBS 1
@@ -140,45 +141,6 @@ static int self_check_in_wl_tree(const struct ubi_device *ubi,
 static int self_check_in_pq(const struct ubi_device *ubi,
 			    struct ubi_wl_entry *e);
 
-#ifdef CONFIG_MTD_UBI_FASTMAP
-/**
- * update_fastmap_work_fn - calls ubi_update_fastmap from a work queue
- * @wrk: the work description object
- */
-static void update_fastmap_work_fn(struct work_struct *wrk)
-{
-	struct ubi_device *ubi = container_of(wrk, struct ubi_device, fm_work);
-	ubi_update_fastmap(ubi);
-	spin_lock(&ubi->wl_lock);
-	ubi->fm_work_scheduled = 0;
-	spin_unlock(&ubi->wl_lock);
-}
-
-/**
- *  ubi_ubi_is_fm_block - returns 1 if a PEB is currently used in a fastmap.
- *  @ubi: UBI device description object
- *  @pnum: the to be checked PEB
- */
-static int ubi_is_fm_block(struct ubi_device *ubi, int pnum)
-{
-	int i;
-
-	if (!ubi->fm)
-		return 0;
-
-	for (i = 0; i < ubi->fm->used_blocks; i++)
-		if (ubi->fm->e[i]->pnum == pnum)
-			return 1;
-
-	return 0;
-}
-#else
-static int ubi_is_fm_block(struct ubi_device *ubi, int pnum)
-{
-	return 0;
-}
-#endif
-
 /**
  * wl_tree_add - add a wear-leveling entry to a WL RB-tree.
  * @e: the wear-leveling entry to add
@@ -277,33 +239,6 @@ static int do_work(struct ubi_device *ubi)
 }
 
 /**
- * produce_free_peb - produce a free physical eraseblock.
- * @ubi: UBI device description object
- *
- * This function tries to make a free PEB by means of synchronous execution of
- * pending works. This may be needed if, for example the background thread is
- * disabled. Returns zero in case of success and a negative error code in case
- * of failure.
- */
-static int produce_free_peb(struct ubi_device *ubi)
-{
-	int err;
-
-	while (!ubi->free.rb_node && ubi->works_count) {
-		spin_unlock(&ubi->wl_lock);
-
-		dbg_wl("do one work synchronously");
-		err = do_work(ubi);
-
-		spin_lock(&ubi->wl_lock);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-/**
  * in_wl_tree - check if wear-leveling entry is present in a WL RB-tree.
  * @e: the wear-leveling entry to check
  * @root: the root of the tree
@@ -441,79 +376,8 @@ static struct ubi_wl_entry *find_mean_wl_entry(struct ubi_device *ubi,
 	return e;
 }
 
-#ifdef CONFIG_MTD_UBI_FASTMAP
-/**
- * find_anchor_wl_entry - find wear-leveling entry to used as anchor PEB.
- * @root: the RB-tree where to look for
- */
-static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root)
-{
-	struct rb_node *p;
-	struct ubi_wl_entry *e, *victim = NULL;
-	int max_ec = UBI_MAX_ERASECOUNTER;
-
-	ubi_rb_for_each_entry(p, e, root, u.rb) {
-		if (e->pnum < UBI_FM_MAX_START && e->ec < max_ec) {
-			victim = e;
-			max_ec = e->ec;
-		}
-	}
-
-	return victim;
-}
-
-static int anchor_pebs_avalible(struct rb_root *root)
-{
-	struct rb_node *p;
-	struct ubi_wl_entry *e;
-
-	ubi_rb_for_each_entry(p, e, root, u.rb)
-		if (e->pnum < UBI_FM_MAX_START)
-			return 1;
-
-	return 0;
-}
-
-/**
- * ubi_wl_get_fm_peb - find a physical erase block with a given maximal number.
- * @ubi: UBI device description object
- * @anchor: This PEB will be used as anchor PEB by fastmap
- *
- * The function returns a physical erase block with a given maximal number
- * and removes it from the wl subsystem.
- * Must be called with wl_lock held!
- */
-struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int anchor)
-{
-	struct ubi_wl_entry *e = NULL;
-
-	if (!ubi->free.rb_node || (ubi->free_count - ubi->beb_rsvd_pebs < 1)) {
-		ubi_warn(ubi, "Can't get peb for fastmap:anchor=%d, free_cnt=%d, reserved=%d",
-			 anchor, ubi->free_count, ubi->beb_rsvd_pebs);
-		goto out;
-	}
-
-	if (anchor)
-		e = find_anchor_wl_entry(&ubi->free);
-	else
-		e = find_mean_wl_entry(ubi, &ubi->free);
-
-	if (!e)
-		goto out;
-
-	self_check_in_wl_tree(ubi, e, &ubi->free);
-
-	/* remove it from the free list,
-	 * the wl subsystem does no longer know this erase block */
-	rb_erase(&e->u.rb, &ubi->free);
-	ubi->free_count--;
-out:
-	return e;
-}
-#endif
-
 /**
- * wl_get_wle - get a mean wl entry to be used by wl_get_peb() or
+ * wl_get_wle - get a mean wl entry to be used by ubi_wl_get_peb() or
  * refill_wl_user_pool().
  * @ubi: UBI device description object
  *
@@ -544,228 +408,6 @@ static struct ubi_wl_entry *wl_get_wle(struct ubi_device *ubi)
 }
 
 /**
- * wl_get_peb - get a physical eraseblock.
- * @ubi: UBI device description object
- *
- * This function returns a physical eraseblock in case of success and a
- * negative error code in case of failure.
- * It is the low level component of ubi_wl_get_peb() in the non-fastmap
- * case.
- */
-static int wl_get_peb(struct ubi_device *ubi)
-{
-	int err;
-	struct ubi_wl_entry *e;
-
-retry:
-	if (!ubi->free.rb_node) {
-		if (ubi->works_count == 0) {
-			ubi_err(ubi, "no free eraseblocks");
-			ubi_assert(list_empty(&ubi->works));
-			return -ENOSPC;
-		}
-
-		err = produce_free_peb(ubi);
-		if (err < 0)
-			return err;
-		goto retry;
-	}
-
-	e = wl_get_wle(ubi);
-	prot_queue_add(ubi, e);
-
-	return e->pnum;
-}
-
-#ifdef CONFIG_MTD_UBI_FASTMAP
-/**
- * return_unused_pool_pebs - returns unused PEB to the free tree.
- * @ubi: UBI device description object
- * @pool: fastmap pool description object
- */
-static void return_unused_pool_pebs(struct ubi_device *ubi,
-				    struct ubi_fm_pool *pool)
-{
-	int i;
-	struct ubi_wl_entry *e;
-
-	for (i = pool->used; i < pool->size; i++) {
-		e = ubi->lookuptbl[pool->pebs[i]];
-		wl_tree_add(e, &ubi->free);
-		ubi->free_count++;
-	}
-}
-
-/**
- * ubi_refill_pools - refills all fastmap PEB pools.
- * @ubi: UBI device description object
- */
-void ubi_refill_pools(struct ubi_device *ubi)
-{
-	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
-	struct ubi_fm_pool *pool = &ubi->fm_pool;
-	struct ubi_wl_entry *e;
-	int enough;
-
-	spin_lock(&ubi->wl_lock);
-
-	return_unused_pool_pebs(ubi, wl_pool);
-	return_unused_pool_pebs(ubi, pool);
-
-	wl_pool->size = 0;
-	pool->size = 0;
-
-	for (;;) {
-		enough = 0;
-		if (pool->size < pool->max_size) {
-			if (!ubi->free.rb_node ||
-			   (ubi->free_count - ubi->beb_rsvd_pebs < 5))
-				break;
-
-			e = wl_get_wle(ubi);
-			if (!e)
-				break;
-
-			pool->pebs[pool->size] = e->pnum;
-			pool->size++;
-		} else
-			enough++;
-
-		if (wl_pool->size < wl_pool->max_size) {
-			if (!ubi->free.rb_node ||
-			   (ubi->free_count - ubi->beb_rsvd_pebs < 5))
-				break;
-
-			e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
-			self_check_in_wl_tree(ubi, e, &ubi->free);
-			rb_erase(&e->u.rb, &ubi->free);
-			ubi->free_count--;
-
-			wl_pool->pebs[wl_pool->size] = e->pnum;
-			wl_pool->size++;
-		} else
-			enough++;
-
-		if (enough == 2)
-			break;
-	}
-
-	wl_pool->used = 0;
-	pool->used = 0;
-
-	spin_unlock(&ubi->wl_lock);
-}
-
-/* ubi_wl_get_peb - works exaclty like __wl_get_peb but keeps track of
- * the fastmap pool.
- * Returns with ubi->fm_eba_sem held in read mode!
- */
-int ubi_wl_get_peb(struct ubi_device *ubi)
-{
-	int ret, retried = 0;
-	struct ubi_fm_pool *pool = &ubi->fm_pool;
-	struct ubi_fm_pool *wl_pool = &ubi->fm_wl_pool;
-
-again:
-	down_read(&ubi->fm_eba_sem);
-	spin_lock(&ubi->wl_lock);
-	/* We check here also for the WL pool because at this point we can
-	 * refill the WL pool synchronous. */
-	if (pool->used == pool->size || wl_pool->used == wl_pool->size) {
-		spin_unlock(&ubi->wl_lock);
-		up_read(&ubi->fm_eba_sem);
-		ret = ubi_update_fastmap(ubi);
-		if (ret) {
-			ubi_msg(ubi, "Unable to write a new fastmap: %i", ret);
-			down_read(&ubi->fm_eba_sem);
-			return -ENOSPC;
-		}
-		down_read(&ubi->fm_eba_sem);
-		spin_lock(&ubi->wl_lock);
-	}
-
-	if (pool->used == pool->size) {
-		spin_unlock(&ubi->wl_lock);
-		if (retried) {
-			ubi_err(ubi, "Unable to get a free PEB from user WL pool");
-			ret = -ENOSPC;
-			goto out;
-		}
-		retried = 1;
-		up_read(&ubi->fm_eba_sem);
-		goto again;
-	}
-
-	ubi_assert(pool->used < pool->size);
-	ret = pool->pebs[pool->used++];
-	prot_queue_add(ubi, ubi->lookuptbl[ret]);
-	spin_unlock(&ubi->wl_lock);
-out:
-	return ret;
-}
-
-/* get_peb_for_wl - returns a PEB to be used internally by the WL sub-system.
- *
- * @ubi: UBI device description object
- */
-static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
-{
-	struct ubi_fm_pool *pool = &ubi->fm_wl_pool;
-	int pnum;
-
-	if (pool->used == pool->size) {
-		/* We cannot update the fastmap here because this
-		 * function is called in atomic context.
-		 * Let's fail here and refill/update it as soon as possible. */
-		if (!ubi->fm_work_scheduled) {
-			ubi->fm_work_scheduled = 1;
-			schedule_work(&ubi->fm_work);
-		}
-		return NULL;
-	} else {
-		pnum = pool->pebs[pool->used++];
-		return ubi->lookuptbl[pnum];
-	}
-}
-#else
-static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
-{
-	struct ubi_wl_entry *e;
-
-	e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
-	self_check_in_wl_tree(ubi, e, &ubi->free);
-	ubi->free_count--;
-	ubi_assert(ubi->free_count >= 0);
-	rb_erase(&e->u.rb, &ubi->free);
-
-	return e;
-}
-
-int ubi_wl_get_peb(struct ubi_device *ubi)
-{
-	int peb, err;
-
-	spin_lock(&ubi->wl_lock);
-	peb = wl_get_peb(ubi);
-	spin_unlock(&ubi->wl_lock);
-	down_read(&ubi->fm_eba_sem);
-
-	if (peb < 0)
-		return peb;
-
-	err = ubi_self_check_all_ff(ubi, peb, ubi->vid_hdr_aloffset,
-				    ubi->peb_size - ubi->vid_hdr_aloffset);
-	if (err) {
-		ubi_err(ubi, "new PEB %d does not contain all 0xFF bytes",
-			peb);
-		return err;
-	}
-
-	return peb;
-}
-#endif
-
-/**
  * prot_queue_del - remove a physical eraseblock from the protection queue.
  * @ubi: UBI device description object
  * @pnum: the physical eraseblock to remove
@@ -931,17 +573,6 @@ static void schedule_ubi_work(struct ubi_device *ubi, struct ubi_work *wrk)
 static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 			int shutdown);
 
-#ifdef CONFIG_MTD_UBI_FASTMAP
-/**
- * ubi_is_erase_work - checks whether a work is erase work.
- * @wrk: The work object to be checked
- */
-int ubi_is_erase_work(struct ubi_work *wrk)
-{
-	return wrk->func == erase_worker;
-}
-#endif
-
 /**
  * schedule_erase - schedule an erase work.
  * @ubi: UBI device description object
@@ -959,7 +590,7 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 	struct ubi_work *wl_wrk;
 
 	ubi_assert(e);
-	ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+	ubi_assert(!is_fm_block(ubi, e->pnum));
 
 	dbg_wl("schedule erasure of PEB %d, EC %d, torture %d",
 	       e->pnum, e->ec, torture);
@@ -1006,48 +637,6 @@ static int do_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 	return erase_worker(ubi, wl_wrk, 0);
 }
 
-#ifdef CONFIG_MTD_UBI_FASTMAP
-/**
- * ubi_wl_put_fm_peb - returns a PEB used in a fastmap to the wear-leveling
- * sub-system.
- * see: ubi_wl_put_peb()
- *
- * @ubi: UBI device description object
- * @fm_e: physical eraseblock to return
- * @lnum: the last used logical eraseblock number for the PEB
- * @torture: if this physical eraseblock has to be tortured
- */
-int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *fm_e,
-		      int lnum, int torture)
-{
-	struct ubi_wl_entry *e;
-	int vol_id, pnum = fm_e->pnum;
-
-	dbg_wl("PEB %d", pnum);
-
-	ubi_assert(pnum >= 0);
-	ubi_assert(pnum < ubi->peb_count);
-
-	spin_lock(&ubi->wl_lock);
-	e = ubi->lookuptbl[pnum];
-
-	/* This can happen if we recovered from a fastmap the very
-	 * first time and writing now a new one. In this case the wl system
-	 * has never seen any PEB used by the original fastmap.
-	 */
-	if (!e) {
-		e = fm_e;
-		ubi_assert(e->ec >= 0);
-		ubi->lookuptbl[pnum] = e;
-	}
-
-	spin_unlock(&ubi->wl_lock);
-
-	vol_id = lnum ? UBI_FM_DATA_VOLUME_ID : UBI_FM_SB_VOLUME_ID;
-	return schedule_erase(ubi, e, vol_id, lnum, torture);
-}
-#endif
-
 /**
  * wear_leveling_worker - wear-leveling worker function.
  * @ubi: UBI device description object
@@ -1430,38 +1019,6 @@ out_unlock:
 	return err;
 }
 
-#ifdef CONFIG_MTD_UBI_FASTMAP
-/**
- * ubi_ensure_anchor_pebs - schedule wear-leveling to produce an anchor PEB.
- * @ubi: UBI device description object
- */
-int ubi_ensure_anchor_pebs(struct ubi_device *ubi)
-{
-	struct ubi_work *wrk;
-
-	spin_lock(&ubi->wl_lock);
-	if (ubi->wl_scheduled) {
-		spin_unlock(&ubi->wl_lock);
-		return 0;
-	}
-	ubi->wl_scheduled = 1;
-	spin_unlock(&ubi->wl_lock);
-
-	wrk = kmalloc(sizeof(struct ubi_work), GFP_NOFS);
-	if (!wrk) {
-		spin_lock(&ubi->wl_lock);
-		ubi->wl_scheduled = 0;
-		spin_unlock(&ubi->wl_lock);
-		return -ENOMEM;
-	}
-
-	wrk->anchor = 1;
-	wrk->func = &wear_leveling_worker;
-	schedule_ubi_work(ubi, wrk);
-	return 0;
-}
-#endif
-
 /**
  * erase_worker - physical eraseblock erase worker function.
  * @ubi: UBI device description object
@@ -1493,7 +1050,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	dbg_wl("erase PEB %d EC %d LEB %d:%d",
 	       pnum, e->ec, wl_wrk->vol_id, wl_wrk->lnum);
 
-	ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+	ubi_assert(!is_fm_block(ubi, e->pnum));
 
 	err = sync_erase(ubi, e, wl_wrk->torture);
 	if (!err) {
@@ -1977,7 +1534,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 		e->pnum = aeb->pnum;
 		e->ec = aeb->ec;
-		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+		ubi_assert(!is_fm_block(ubi, e->pnum));
 		ubi->lookuptbl[e->pnum] = e;
 		if (schedule_erase(ubi, e, aeb->vol_id, aeb->lnum, 0)) {
 			wl_entry_destroy(ubi, e);
@@ -1998,7 +1555,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		e->pnum = aeb->pnum;
 		e->ec = aeb->ec;
 		ubi_assert(e->ec >= 0);
-		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
+		ubi_assert(!is_fm_block(ubi, e->pnum));
 
 		wl_tree_add(e, &ubi->free);
 		ubi->free_count++;
@@ -2098,23 +1655,6 @@ static void protection_queue_destroy(struct ubi_device *ubi)
 	}
 }
 
-static void ubi_fastmap_close(struct ubi_device *ubi)
-{
-#ifdef CONFIG_MTD_UBI_FASTMAP
-	int i;
-
-	flush_work(&ubi->fm_work);
-	return_unused_pool_pebs(ubi, &ubi->fm_pool);
-	return_unused_pool_pebs(ubi, &ubi->fm_wl_pool);
-
-	if (ubi->fm) {
-		for (i = 0; i < ubi->fm->used_blocks; i++)
-			kfree(ubi->fm->e[i]);
-	}
-	kfree(ubi->fm);
-#endif
-}
-
 /**
  * ubi_wl_close - close the wear-leveling sub-system.
  * @ubi: UBI device description object
@@ -2227,3 +1767,94 @@ static int self_check_in_pq(const struct ubi_device *ubi,
 	dump_stack();
 	return -EINVAL;
 }
+#ifndef CONFIG_MTD_UBI_FASTMAP
+static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
+{
+	struct ubi_wl_entry *e;
+
+	e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
+	self_check_in_wl_tree(ubi, e, &ubi->free);
+	ubi->free_count--;
+	ubi_assert(ubi->free_count >= 0);
+	rb_erase(&e->u.rb, &ubi->free);
+
+	return e;
+}
+
+/**
+ * produce_free_peb - produce a free physical eraseblock.
+ * @ubi: UBI device description object
+ *
+ * This function tries to make a free PEB by means of synchronous execution of
+ * pending works. This may be needed if, for example the background thread is
+ * disabled. Returns zero in case of success and a negative error code in case
+ * of failure.
+ */
+static int produce_free_peb(struct ubi_device *ubi)
+{
+	int err;
+
+	while (!ubi->free.rb_node && ubi->works_count) {
+		spin_unlock(&ubi->wl_lock);
+
+		dbg_wl("do one work synchronously");
+		err = do_work(ubi);
+
+		spin_lock(&ubi->wl_lock);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/**
+ * ubi_wl_get_peb - get a physical eraseblock.
+ * @ubi: UBI device description object
+ *
+ * This function returns a physical eraseblock in case of success and a
+ * negative error code in case of failure.
+ * Returns with ubi->fm_eba_sem held in read mode!
+ */
+int ubi_wl_get_peb(struct ubi_device *ubi)
+{
+	int err;
+	struct ubi_wl_entry *e;
+
+retry:
+	down_read(&ubi->fm_eba_sem);
+	spin_lock(&ubi->wl_lock);
+	if (!ubi->free.rb_node) {
+		if (ubi->works_count == 0) {
+			ubi_err(ubi, "no free eraseblocks");
+			ubi_assert(list_empty(&ubi->works));
+			spin_unlock(&ubi->wl_lock);
+			return -ENOSPC;
+		}
+
+		err = produce_free_peb(ubi);
+		if (err < 0) {
+			spin_unlock(&ubi->wl_lock);
+			return err;
+		}
+		spin_unlock(&ubi->wl_lock);
+		up_read(&ubi->fm_eba_sem);
+		goto retry;
+
+	}
+	e = wl_get_wle(ubi);
+	prot_queue_add(ubi, e);
+	spin_unlock(&ubi->wl_lock);
+
+	err = ubi_self_check_all_ff(ubi, e->pnum, ubi->vid_hdr_aloffset,
+				    ubi->peb_size - ubi->vid_hdr_aloffset);
+	if (err) {
+		ubi_err(ubi, "new PEB %d does not contain all 0xFF bytes", e->pnum);
+		return err;
+	}
+
+	return e->pnum;
+}
+#else
+#include "fastmap-wl.c"
+#endif
diff --git a/drivers/mtd/ubi/wl.h b/drivers/mtd/ubi/wl.h
new file mode 100644
index 0000000..db86814
--- /dev/null
+++ b/drivers/mtd/ubi/wl.h
@@ -0,0 +1,18 @@
+#ifndef UBI_WL_H
+#define UBI_WL_H
+#ifdef CONFIG_MTD_UBI_FASTMAP
+static int is_fm_block(struct ubi_device *ubi, int pnum);
+static int anchor_pebs_avalible(struct rb_root *root);
+static void update_fastmap_work_fn(struct work_struct *wrk);
+static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root);
+static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi);
+static void ubi_fastmap_close(struct ubi_device *ubi);
+#else /* !CONFIG_MTD_UBI_FASTMAP */
+static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi);
+static inline int is_fm_block(struct ubi_device *ubi, int pnum)
+{
+	return 0;
+}
+static inline void ubi_fastmap_close(struct ubi_device *ubi) { }
+#endif /* CONFIG_MTD_UBI_FASTMAP */
+#endif /* UBI_WL_H */
-- 
1.8.4.5

