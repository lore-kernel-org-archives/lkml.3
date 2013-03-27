Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3C0NTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:19:55 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:40767 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3C0NSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:18:18 -0400
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: [PATCH v1 1/6] idr: introduce idr_alloc_cyclic
Date: Wed, 27 Mar 2013 09:18:03 -0400
Message-Id: <1364390288-30968-2-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
References: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thus spake Tejun Heo:

    Ooh, BTW, the cyclic allocation is broken.  It's prone to -ENOSPC
    after the first wraparound.  There are several cyclic users in the
    kernel and I think it probably would be best to implement cyclic
    support in idr.

This patch does that by adding new idr_alloc_cyclic function that such
users in the kernel can use. With this, there's no need for a caller to
keep track of the last value used as that's now tracked internally.
This should prevent the ENOSPC problems that can hit when the "last
allocated" counter exceeds INT_MAX.

Later patches will convert existing cyclic users to the new interface.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/idr.h | 10 +++++++++-
 lib/idr.c           | 47 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 2640c7e..01752b1 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -42,6 +42,7 @@ struct idr {
 	struct idr_layer	*id_free;
 	int			layers;	/* only valid w/o concurrent changes */
 	int			id_free_cnt;
+	int			cur;	/* current pos for cyclic allocation */
 	spinlock_t		lock;
 };
 
@@ -75,6 +76,7 @@ struct idr {
 void *idr_find_slowpath(struct idr *idp, int id);
 void idr_preload(gfp_t gfp_mask);
 int idr_alloc(struct idr *idp, void *ptr, int start, int end, gfp_t gfp_mask);
+int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask);
 int idr_for_each(struct idr *idp,
 		 int (*fn)(int id, void *p, void *data), void *data);
 void *idr_get_next(struct idr *idp, int *nextid);
@@ -82,7 +84,13 @@ void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
 void idr_free(struct idr *idp, int id);
 void idr_destroy(struct idr *idp);
-void idr_init(struct idr *idp);
+void idr_init_cyclic(struct idr *idp, int start);
+
+static inline void
+idr_init(struct idr *idp)
+{
+	idr_init_cyclic(idp, 0);
+}
 
 /**
  * idr_preload_end - end preload section started with idr_preload()
diff --git a/lib/idr.c b/lib/idr.c
index 322e281..992f53f 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -495,6 +495,44 @@ int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL_GPL(idr_alloc);
 
+/**
+ * idr_alloc_cyclic - allocate new idr entry in a cyclical fashion
+ * @idr: the (initialized) idr
+ * @ptr: pointer to be associated with the new id
+ * @start: the minimum id (inclusive)
+ * @end: the maximum id (exclusive, <= 0 for max)
+ * @cur: ptr to current position in the range (typically, last allocated + 1)
+ * @gfp_mask: memory allocation flags
+ *
+ * Essentially the same as idr_alloc, but prefers to allocate progressively
+ * higher ids if it can. If the "cur" counter wraps, then it will start again
+ * at the "start" end of the range and allocate one that has already been used.
+ *
+ * Note that people using cyclic allocation to avoid premature reuse of an
+ * already-used ID may be in for a nasty surprise after idr->cur wraps. The
+ * IDR code is designed to avoid unnecessary allocations. If there is space
+ * in an existing layer that holds high IDs then it will return one of those
+ * instead of allocating a new layer at the bottom of the range.
+ */
+int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end,
+			gfp_t gfp_mask)
+{
+	int id;
+	int cur = idr->cur;
+
+	if (unlikely(start > cur))
+		cur = start;
+
+	id = idr_alloc(idr, ptr, cur, end, gfp_mask);
+	if (id == -ENOSPC)
+		id = idr_alloc(idr, ptr, start, end, gfp_mask);
+
+	if (likely(id >= 0))
+		idr->cur = id + 1;
+	return id;
+}
+EXPORT_SYMBOL(idr_alloc_cyclic);
+
 static void idr_remove_warning(int id)
 {
 	printk(KERN_WARNING
@@ -831,19 +869,20 @@ void __init idr_init_cache(void)
 }
 
 /**
- * idr_init - initialize idr handle
+ * idr_init_cyclic - initialize idr handle
  * @idp:	idr handle
+ * @start:	starting id value for cyclic users
  *
  * This function is use to set up the handle (@idp) that you will pass
  * to the rest of the functions.
  */
-void idr_init(struct idr *idp)
+void idr_init_cyclic(struct idr *idp, int start)
 {
 	memset(idp, 0, sizeof(struct idr));
 	spin_lock_init(&idp->lock);
+	idp->cur = start;
 }
-EXPORT_SYMBOL(idr_init);
-
+EXPORT_SYMBOL(idr_init_cyclic);
 
 /**
  * DOC: IDA description
-- 
1.7.11.7

