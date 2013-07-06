Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3GFFIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 01:08:51 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40385 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3GFFIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 01:08:45 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: tj@kernel.org, sfr@canb.auug.org.au, andi@firstfloor.org, oleg@redhat.com,
        mingo@redhat.com, nab@linux-iscsi.org, axboe@kernel.dk,
        Kent Overstreet <koverstreet@google.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 06/10] idr: Rename idr_get_next() -> idr_find_next()
Date: Fri,  5 Jul 2013 22:08:17 -0700
Message-Id: <1373087301-23730-7-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
References: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

get() implies taking a ref or sometimes an allocation, which this
function definitely does not do - rename it to something more sensible.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 drivers/block/drbd/drbd_main.c | 2 +-
 drivers/block/drbd/drbd_nl.c   | 2 +-
 drivers/mtd/mtdcore.c          | 2 +-
 include/linux/idr.h            | 4 ++--
 lib/idr.c                      | 6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a5dca6a..b84e4b2 100644
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
index 9e3f441..8fa7eb1 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2837,7 +2837,7 @@ int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 	if (tconn) {
 next_tconn:
-		mdev = idr_get_next(&tconn->volumes, &volume);
+		mdev = idr_find_next(&tconn->volumes, &volume);
 		if (!mdev) {
 			/* No more volumes to dump on this tconn.
 			 * Advance tconn iterator. */
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index c400c57..eaa1fcc 100644
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
 
diff --git a/lib/idr.c b/lib/idr.c
index f7ba96b..254e0dc 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -1594,7 +1594,7 @@ int idr_for_each(struct idr *idp,
 EXPORT_SYMBOL(idr_for_each);
 
 /**
- * idr_get_next - lookup next object of id to given id.
+ * idr_find_next - lookup next object of id to given id.
  * @idp: idr handle
  * @nextidp:  pointer to lookup key
  *
@@ -1605,7 +1605,7 @@ EXPORT_SYMBOL(idr_for_each);
  * This function can be called under rcu_read_lock(), given that the leaf
  * pointers lifetimes are correctly managed.
  */
-void *idr_get_next(struct idr *idp, int *nextidp)
+void *idr_find_next(struct idr *idp, int *nextidp)
 {
 	struct idr_layer *p, *pa[MAX_IDR_LEVEL + 1];
 	struct idr_layer **paa = &pa[0];
@@ -1646,7 +1646,7 @@ void *idr_get_next(struct idr *idp, int *nextidp)
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(idr_get_next);
+EXPORT_SYMBOL(idr_find_next);
 
 
 /**
-- 
1.8.3.2

