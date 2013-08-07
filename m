Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab3HGRqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:46:47 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48854 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3HGRqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:46:43 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] idr: Rename idr_get_next() -> idr_find_next()
Date: Wed,  7 Aug 2013 10:46:15 -0700
Message-Id: <1375897579-8202-6-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get() implies taking a ref or sometimes an allocation, which this
function definitely does not do - rename it to something more sensible.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 2 +-
 drivers/block/drbd/drbd_nl.c   | 2 +-
 drivers/mtd/mtdcore.c          | 2 +-
 include/linux/idr.h            | 4 ++--
 kernel/cgroup.c                | 2 +-
 lib/idr.c                      | 6 +++---
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 55635ed..73f4765 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -500,7 +500,7 @@ int conn_lowest_minor(struct drbd_tconn *tconn)
 	int vnr = 0, m;
 
 	rcu_read_lock();
-	mdev = idr_get_next(&tconn->volumes, &vnr);
+	mdev = idr_find_next(&tconn->volumes, &vnr);
 	m = mdev ? mdev_to_minor(mdev) : -1;
 	rcu_read_unlock();
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 8cc1e64..936da36 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2938,7 +2938,7 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	if (tconn) {
 next_tconn:
-		mdev = idr_get_next(&tconn->volumes, &volume);
+		mdev = idr_find_next(&tconn->volumes, &volume);
 		if (!mdev) {
 			/* No more volumes to dump on this tconn.
 			 * Advance tconn iterator. */
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 048c823..8d64363 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -91,7 +91,7 @@ EXPORT_SYMBOL_GPL(mtd_table_mutex);
 
 struct mtd_info *__mtd_next_device(int i)
 {
-	return idr_get_next(&mtd_idr, &i);
+	return idr_find_next(&mtd_idr, &i);
 }
 EXPORT_SYMBOL_GPL(__mtd_next_device);
 
diff --git a/include/linux/idr.h b/include/linux/idr.h
index b26f8b1..6395da1 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -211,7 +211,7 @@ int idr_alloc(struct idr *idp, void *ptr, int start, int end, gfp_t gfp_mask);
 int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask);
 int idr_for_each(struct idr *idp,
 		 int (*fn)(int id, void *p, void *data), void *data);
-void *idr_get_next(struct idr *idp, int *nextid);
+void *idr_find_next(struct idr *idp, int *nextid);
 void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
 void idr_free(struct idr *idp, int id);
@@ -262,7 +262,7 @@ static inline void *idr_find(struct idr *idr, int id)
  * is convenient for a "not found" value.
  */
 #define idr_for_each_entry(idp, entry, id)			\
-	for (id = 0; ((entry) = idr_get_next(idp, &(id))) != NULL; ++id)
+	for (id = 0; ((entry) = idr_find_next(idp, &(id))) != NULL; ++id)
 
 void __init idr_init_cache(void);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bac5312..7b397f8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1868,7 +1868,7 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 
 	mutex_lock(&cgroup_mutex);
 
-	root = idr_get_next(&cgroup_hierarchy_idr, &hierarchy_id);
+	root = idr_find_next(&cgroup_hierarchy_idr, &hierarchy_id);
 
 	if (root) {
 		cgrp = task_cgroup_from_root(task, root);
diff --git a/lib/idr.c b/lib/idr.c
index 3f68665..1d67cdd 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -1596,7 +1596,7 @@ int idr_for_each(struct idr *idp,
 EXPORT_SYMBOL(idr_for_each);
 
 /**
- * idr_get_next - lookup next object of id to given id.
+ * idr_find_next - lookup next object of id to given id.
  * @idp: idr handle
  * @nextidp:  pointer to lookup key
  *
@@ -1607,7 +1607,7 @@ EXPORT_SYMBOL(idr_for_each);
  * This function can be called under rcu_read_lock(), given that the leaf
  * pointers lifetimes are correctly managed.
  */
-void *idr_get_next(struct idr *idp, int *nextidp)
+void *idr_find_next(struct idr *idp, int *nextidp)
 {
 	struct idr_layer *p, *pa[MAX_IDR_LEVEL + 1];
 	struct idr_layer **paa = &pa[0];
@@ -1648,7 +1648,7 @@ void *idr_get_next(struct idr *idp, int *nextidp)
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(idr_get_next);
+EXPORT_SYMBOL(idr_find_next);
 
 
 /**
-- 
1.8.4.rc1

