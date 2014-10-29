Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207AbaJ2NAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:00:01 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14387 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729AbaJ2MqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:11 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 02/35] UBI: Fix stale pointers in ubi->lookuptbl
Date: Wed, 29 Oct 2014 13:45:25 +0100
Message-Id: <1414586758-9972-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some error paths the WL sub-system gives up on a PEB
and frees it's ubi_wl_entry struct but does not set
the entry in ubi->lookuptbl to NULL.
Fastmap can stumble over such a stale pointer as it uses
ubi->lookuptbl to find all PEBs.

Fix this by setting the pointers to free'd ubi_wl_entry to NULL.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 6654f191..a12c54b 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1212,9 +1212,12 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
 	err = do_sync_erase(ubi, e1, vol_id, lnum, 0);
 	if (err) {
+		ubi->lookuptbl[e1->pnum] = NULL;
 		kmem_cache_free(ubi_wl_entry_slab, e1);
-		if (e2)
+		if (e2) {
+			ubi->lookuptbl[e2->pnum] = NULL;
 			kmem_cache_free(ubi_wl_entry_slab, e2);
+		}
 		goto out_ro;
 	}
 
@@ -1227,6 +1230,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 		       e2->pnum, vol_id, lnum);
 		err = do_sync_erase(ubi, e2, vol_id, lnum, 0);
 		if (err) {
+			ubi->lookuptbl[e2->pnum] = NULL;
 			kmem_cache_free(ubi_wl_entry_slab, e2);
 			goto out_ro;
 		}
@@ -1266,6 +1270,7 @@ out_not_moved:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	err = do_sync_erase(ubi, e2, vol_id, lnum, torture);
 	if (err) {
+		ubi->lookuptbl[e2->pnum] = NULL;
 		kmem_cache_free(ubi_wl_entry_slab, e2);
 		goto out_ro;
 	}
@@ -1285,6 +1290,8 @@ out_error:
 	spin_unlock(&ubi->wl_lock);
 
 	ubi_free_vid_hdr(ubi, vid_hdr);
+	ubi->lookuptbl[e1->pnum] = NULL;
+	ubi->lookuptbl[e2->pnum] = NULL;
 	kmem_cache_free(ubi_wl_entry_slab, e1);
 	kmem_cache_free(ubi_wl_entry_slab, e2);
 
@@ -1428,6 +1435,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	if (shutdown) {
 		dbg_wl("cancel erasure of PEB %d EC %d", pnum, e->ec);
 		kfree(wl_wrk);
+		ubi->lookuptbl[e->pnum] = NULL;
 		kmem_cache_free(ubi_wl_entry_slab, e);
 		return 0;
 	}
@@ -1474,6 +1482,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		return err;
 	}
 
+	ubi->lookuptbl[e->pnum] = NULL;
 	kmem_cache_free(ubi_wl_entry_slab, e);
 	if (err != -EIO)
 		/*
@@ -1912,6 +1921,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
 		ubi->lookuptbl[e->pnum] = e;
 		if (schedule_erase(ubi, e, aeb->vol_id, aeb->lnum, 0)) {
+			ubi->lookuptbl[e->pnum] = NULL;
 			kmem_cache_free(ubi_wl_entry_slab, e);
 			goto out_free;
 		}
-- 
1.8.4.5

