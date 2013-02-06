Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab3BFTt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:49:57 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:65103 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153Ab3BFTtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:51 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/77] idr: remove _idr_rc_to_errno() hack
Date: Wed,  6 Feb 2013 11:39:50 -0800
Message-Id: <1360179649-22465-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr uses -1, IDR_NEED_TO_GROW and IDR_NOMORE_SPACE to communicate
exception conditions internally.  The return value is later translated
to errno values using _idr_rc_to_errno().

This is confusing.  Drop the custom ones and consistently use -EAGAIN
for "tree needs to grow", -ENOMEM for "need more memory" and -ENOSPC
for "ran out of ID space".

Due to the weird memory preloading mechanism, [ra]_get_new*() return
-EAGAIN on memory shortage, so we need to substitute -ENOMEM w/
-EAGAIN on those interface functions.  They'll eventually be cleaned
up and the translations will go away.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/idr.h |  6 ------
 lib/idr.c           | 35 +++++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 7c0700c..92e84f7 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -70,12 +70,6 @@ struct idr {
 }
 #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
-/* Actions to be taken after a call to _idr_sub_alloc */
-#define IDR_NEED_TO_GROW -2
-#define IDR_NOMORE_SPACE -3
-
-#define _idr_rc_to_errno(rc) ((rc) == -1 ? -EAGAIN : -ENOSPC)
-
 /**
  * DOC: idr sync
  * idr synchronization (stolen from radix-tree.h)
diff --git a/lib/idr.c b/lib/idr.c
index 282841b..bde6eec 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -133,6 +133,21 @@ int idr_pre_get(struct idr *idp, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(idr_pre_get);
 
+/**
+ * sub_alloc - try to allocate an id without growing the tree depth
+ * @idp: idr handle
+ * @starting_id: id to start search at
+ * @id: pointer to the allocated handle
+ * @pa: idr_layer[MAX_IDR_LEVEL] used as backtrack buffer
+ *
+ * Allocate an id in range [@starting_id, INT_MAX] from @idp without
+ * growing its depth.  Returns
+ *
+ *  the allocated id >= 0 if successful,
+ *  -EAGAIN if the tree needs to grow for allocation to succeed,
+ *  -ENOSPC if the id space is exhausted,
+ *  -ENOMEM if more idr_layers need to be allocated.
+ */
 static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 {
 	int n, m, sh;
@@ -161,7 +176,7 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 			/* if already at the top layer, we need to grow */
 			if (id >= 1 << (idp->layers * IDR_BITS)) {
 				*starting_id = id;
-				return IDR_NEED_TO_GROW;
+				return -EAGAIN;
 			}
 			p = pa[l];
 			BUG_ON(!p);
@@ -180,7 +195,7 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 			id = ((id >> sh) ^ n ^ m) << sh;
 		}
 		if ((id >= MAX_IDR_BIT) || (id < 0))
-			return IDR_NOMORE_SPACE;
+			return -ENOSPC;
 		if (l == 0)
 			break;
 		/*
@@ -189,7 +204,7 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 		if (!p->ary[m]) {
 			new = get_from_free_list(idp);
 			if (!new)
-				return -1;
+				return -ENOMEM;
 			new->layer = l-1;
 			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
@@ -215,7 +230,7 @@ build_up:
 	layers = idp->layers;
 	if (unlikely(!p)) {
 		if (!(p = get_from_free_list(idp)))
-			return -1;
+			return -ENOMEM;
 		p->layer = 0;
 		layers = 1;
 	}
@@ -246,7 +261,7 @@ build_up:
 				__move_to_free_list(idp, new);
 			}
 			spin_unlock_irqrestore(&idp->lock, flags);
-			return -1;
+			return -ENOMEM;
 		}
 		new->ary[0] = p;
 		new->count = 1;
@@ -258,7 +273,7 @@ build_up:
 	rcu_assign_pointer(idp->top, p);
 	idp->layers = layers;
 	v = sub_alloc(idp, &id, pa);
-	if (v == IDR_NEED_TO_GROW)
+	if (v == -EAGAIN)
 		goto build_up;
 	return(v);
 }
@@ -306,12 +321,8 @@ int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
 	int rv;
 
 	rv = idr_get_new_above_int(idp, ptr, starting_id);
-	/*
-	 * This is a cheap hack until the IDR code can be fixed to
-	 * return proper error values.
-	 */
 	if (rv < 0)
-		return _idr_rc_to_errno(rv);
+		return rv == -ENOMEM ? -EAGAIN : rv;
 	*id = rv;
 	return 0;
 }
@@ -766,7 +777,7 @@ int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 	/* get vacant slot */
 	t = idr_get_empty_slot(&ida->idr, idr_id, pa);
 	if (t < 0)
-		return _idr_rc_to_errno(t);
+		return t == -ENOMEM ? -EAGAIN : t;
 
 	if (t * IDA_BITMAP_BITS >= MAX_IDR_BIT)
 		return -ENOSPC;
-- 
1.8.1

