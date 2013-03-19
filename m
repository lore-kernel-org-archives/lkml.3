Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab3CSRS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:18:27 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44774 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369Ab3CSRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:06 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 14/18] lru_cache: introduce lc_get_cumulative()
Date: Tue, 19 Mar 2013 18:16:55 +0100
Message-Id: <1363713419-17803-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

New helper to be able to consolidate more updates
into a single transaction.
Without this, we can only grab a single refcount
on an updated element while preparing a transaction.

lc_get_cumulative - like lc_get; also finds to-be-changed elements
  @lc: the lru cache to operate on
  @enr: the label to look up

  Unlike lc_get this also returns the element for @enr, if it is belonging to
  a pending transaction, so the return values are like for lc_get(),
  plus:

  pointer to an element already on the "to_be_changed" list.
	  In this case, the cache was already marked %LC_DIRTY.

  Caller needs to make sure that the pending transaction is completed,
  before proceeding to actually use this element.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/lru_cache.h |    1 +
 lib/lru_cache.c           |   55 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/include/linux/lru_cache.h b/include/linux/lru_cache.h
index 4019013..4626228 100644
--- a/include/linux/lru_cache.h
+++ b/include/linux/lru_cache.h
@@ -256,6 +256,7 @@ extern void lc_destroy(struct lru_cache *lc);
 extern void lc_set(struct lru_cache *lc, unsigned int enr, int index);
 extern void lc_del(struct lru_cache *lc, struct lc_element *element);
 
+extern struct lc_element *lc_get_cumulative(struct lru_cache *lc, unsigned int enr);
 extern struct lc_element *lc_try_get(struct lru_cache *lc, unsigned int enr);
 extern struct lc_element *lc_find(struct lru_cache *lc, unsigned int enr);
 extern struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr);
diff --git a/lib/lru_cache.c b/lib/lru_cache.c
index d71d894..e8d5003 100644
--- a/lib/lru_cache.c
+++ b/lib/lru_cache.c
@@ -366,7 +366,13 @@ static int lc_unused_element_available(struct lru_cache *lc)
 	return 0;
 }
 
-static struct lc_element *__lc_get(struct lru_cache *lc, unsigned int enr, bool may_change)
+/* used as internal flags to __lc_get */
+enum {
+	LC_GET_MAY_CHANGE = 1,
+	LC_GET_MAY_USE_UNCOMMITTED = 2,
+};
+
+static struct lc_element *__lc_get(struct lru_cache *lc, unsigned int enr, unsigned int flags)
 {
 	struct lc_element *e;
 
@@ -381,22 +387,31 @@ static struct lc_element *__lc_get(struct lru_cache *lc, unsigned int enr, bool
 	 * this enr is currently being pulled in already,
 	 * and will be available once the pending transaction
 	 * has been committed. */
-	if (e && e->lc_new_number == e->lc_number) {
+	if (e) {
+		if (e->lc_new_number != e->lc_number) {
+			/* It has been found above, but on the "to_be_changed"
+			 * list, not yet committed.  Don't pull it in twice,
+			 * wait for the transaction, then try again...
+			 */
+			if (!(flags & LC_GET_MAY_USE_UNCOMMITTED))
+				RETURN(NULL);
+			/* ... unless the caller is aware of the implications,
+			 * probably preparing a cumulative transaction. */
+			++e->refcnt;
+			++lc->hits;
+			RETURN(e);
+		}
+		/* else: lc_new_number == lc_number; a real hit. */
 		++lc->hits;
 		if (e->refcnt++ == 0)
 			lc->used++;
 		list_move(&e->list, &lc->in_use); /* Not evictable... */
 		RETURN(e);
 	}
+	/* e == NULL */
 
 	++lc->misses;
-	if (!may_change)
-		RETURN(NULL);
-
-	/* It has been found above, but on the "to_be_changed" list, not yet
-	 * committed.  Don't pull it in twice, wait for the transaction, then
-	 * try again */
-	if (e)
+	if (!(flags & LC_GET_MAY_CHANGE))
 		RETURN(NULL);
 
 	/* To avoid races with lc_try_lock(), first, mark us dirty
@@ -478,7 +493,27 @@ static struct lc_element *__lc_get(struct lru_cache *lc, unsigned int enr, bool
  */
 struct lc_element *lc_get(struct lru_cache *lc, unsigned int enr)
 {
-	return __lc_get(lc, enr, 1);
+	return __lc_get(lc, enr, LC_GET_MAY_CHANGE);
+}
+
+/**
+ * lc_get_cumulative - like lc_get; also finds to-be-changed elements
+ * @lc: the lru cache to operate on
+ * @enr: the label to look up
+ *
+ * Unlike lc_get this also returns the element for @enr, if it is belonging to
+ * a pending transaction, so the return values are like for lc_get(),
+ * plus:
+ *
+ * pointer to an element already on the "to_be_changed" list.
+ * 	In this case, the cache was already marked %LC_DIRTY.
+ *
+ * Caller needs to make sure that the pending transaction is completed,
+ * before proceeding to actually use this element.
+ */
+struct lc_element *lc_get_cumulative(struct lru_cache *lc, unsigned int enr)
+{
+	return __lc_get(lc, enr, LC_GET_MAY_CHANGE|LC_GET_MAY_USE_UNCOMMITTED);
 }
 
 /**
-- 
1.7.9.5

