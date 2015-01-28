Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbbA2DFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:05:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46999 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbbA2Cha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 028/139] UBI: Fix double free after do_sync_erase()
Date: Wed, 28 Jan 2015 14:19:31 -0800
Message-Id: <1422483682-15393-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit aa5ad3b6eb8feb2399a5d26c8fb0060561bb9534 upstream.

If the erase worker is unable to erase a PEB it will
free the ubi_wl_entry itself.
The failing ubi_wl_entry must not free()'d again after
do_sync_erase() returns.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mtd/ubi/wl.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 02317c1..68b924e 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1205,7 +1205,6 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
 	err = do_sync_erase(ubi, e1, vol_id, lnum, 0);
 	if (err) {
-		kmem_cache_free(ubi_wl_entry_slab, e1);
 		if (e2)
 			kmem_cache_free(ubi_wl_entry_slab, e2);
 		goto out_ro;
@@ -1219,10 +1218,8 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 		dbg_wl("PEB %d (LEB %d:%d) was put meanwhile, erase",
 		       e2->pnum, vol_id, lnum);
 		err = do_sync_erase(ubi, e2, vol_id, lnum, 0);
-		if (err) {
-			kmem_cache_free(ubi_wl_entry_slab, e2);
+		if (err)
 			goto out_ro;
-		}
 	}
 
 	dbg_wl("done");
@@ -1258,10 +1255,9 @@ out_not_moved:
 
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	err = do_sync_erase(ubi, e2, vol_id, lnum, torture);
-	if (err) {
-		kmem_cache_free(ubi_wl_entry_slab, e2);
+	if (err)
 		goto out_ro;
-	}
+
 	mutex_unlock(&ubi->move_mutex);
 	return 0;
 
-- 
1.9.1

