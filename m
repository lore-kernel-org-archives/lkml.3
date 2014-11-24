Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaKXNUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:20:51 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14390 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaKXNUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:20:49 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/6] UBI: Split __wl_get_peb()
Date: Mon, 24 Nov 2014 14:20:35 +0100
Message-Id: <1416835236-25185-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1416835236-25185-1-git-send-email-richard@nod.at>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it two functions, wl_get_wle() and wl_get_peb().
wl_get_peb() works exactly like __wl_get_peb() but wl_get_wle()
does not call produce_free_peb().
While refilling the fastmap user pool we cannot release ubi->wl_lock
as produce_free_peb() does.
Hence the fastmap logic uses now wl_get_wle().

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 61 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 23 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 7730b97..f028b68 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -499,13 +499,46 @@ out:
 #endif
 
 /**
- * __wl_get_peb - get a physical eraseblock.
+ * wl_get_wle - get a mean wl entry to be used by wl_get_peb() or
+ * refill_wl_user_pool().
+ * @ubi: UBI device description object
+ *
+ * This function returns a a wear leveling entry in case of success and
+ * NULL in case of failure.
+ */
+static struct ubi_wl_entry *wl_get_wle(struct ubi_device *ubi)
+{
+	struct ubi_wl_entry *e;
+
+	e = find_mean_wl_entry(ubi, &ubi->free);
+	if (!e) {
+		ubi_err(ubi, "no free eraseblocks");
+		return NULL;
+	}
+
+	self_check_in_wl_tree(ubi, e, &ubi->free);
+
+	/*
+	 * Move the physical eraseblock to the protection queue where it will
+	 * be protected from being moved for some time.
+	 */
+	rb_erase(&e->u.rb, &ubi->free);
+	ubi->free_count--;
+	dbg_wl("PEB %d EC %d", e->pnum, e->ec);
+
+	return e;
+}
+
+/**
+ * wl_get_peb - get a physical eraseblock.
  * @ubi: UBI device description object
  *
  * This function returns a physical eraseblock in case of success and a
  * negative error code in case of failure.
+ * It is the low level component of ubi_wl_get_peb() in the non-fastmap
+ * case.
  */
-static int __wl_get_peb(struct ubi_device *ubi)
+static int wl_get_peb(struct ubi_device *ubi)
 {
 	int err;
 	struct ubi_wl_entry *e;
@@ -524,27 +557,9 @@ retry:
 		goto retry;
 	}
 
-	e = find_mean_wl_entry(ubi, &ubi->free);
-	if (!e) {
-		ubi_err(ubi, "no free eraseblocks");
-		return -ENOSPC;
-	}
-
-	self_check_in_wl_tree(ubi, e, &ubi->free);
-
-	/*
-	 * Move the physical eraseblock to the protection queue where it will
-	 * be protected from being moved for some time.
-	 */
-	rb_erase(&e->u.rb, &ubi->free);
-	ubi->free_count--;
-	dbg_wl("PEB %d EC %d", e->pnum, e->ec);
-#ifndef CONFIG_MTD_UBI_FASTMAP
-	/* We have to enqueue e only if fastmap is disabled,
-	 * is fastmap enabled prot_queue_add() will be called by
-	 * ubi_wl_get_peb() after removing e from the pool. */
+	e = wl_get_wle(ubi);
 	prot_queue_add(ubi, e);
-#endif
+
 	return e->pnum;
 }
 
@@ -704,7 +719,7 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 	int peb, err;
 
 	spin_lock(&ubi->wl_lock);
-	peb = __wl_get_peb(ubi);
+	peb = wl_get_peb(ubi);
 	spin_unlock(&ubi->wl_lock);
 
 	if (peb < 0)
-- 
1.8.4.5

