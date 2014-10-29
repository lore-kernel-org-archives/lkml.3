Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbaJ2Myo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:54:44 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14393 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513AbaJ2MqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:13 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 08/35] UBI: Split __wl_get_peb()
Date: Wed, 29 Oct 2014 13:45:31 +0100
Message-Id: <1414586758-9972-9-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
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
 drivers/mtd/ubi/wl.c | 48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 5f8d2ff..95bb12b 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -502,7 +502,30 @@ out:
  * This function returns a physical eraseblock in case of success and a
  * negative error code in case of failure.
  */
-static int __wl_get_peb(struct ubi_device *ubi)
+static struct ubi_wl_entry *wl_get_wle(struct ubi_device *ubi)
+{
+	struct ubi_wl_entry *e;
+
+	e = find_mean_wl_entry(ubi, &ubi->free);
+	if (!e) {
+		ubi_err("no free eraseblocks");
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
+static int wl_get_peb(struct ubi_device *ubi)
 {
 	int err;
 	struct ubi_wl_entry *e;
@@ -519,29 +542,12 @@ retry:
 		if (err < 0)
 			return err;
 		goto retry;
-	}
 
-	e = find_mean_wl_entry(ubi, &ubi->free);
-	if (!e) {
-		ubi_err("no free eraseblocks");
-		return -ENOSPC;
 	}
 
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
 
@@ -699,7 +705,7 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 	int peb, err;
 
 	spin_lock(&ubi->wl_lock);
-	peb = __wl_get_peb(ubi);
+	peb = wl_get_peb(ubi);
 	spin_unlock(&ubi->wl_lock);
 
 	if (peb < 0)
-- 
1.8.4.5

