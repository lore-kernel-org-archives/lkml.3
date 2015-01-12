Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbbALTO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:14:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57361 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbbALSFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 019/216] UBI: Fix double free after do_sync_erase()
Date: Mon, 12 Jan 2015 18:02:16 +0000
Message-Id: <1421085933-32536-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit aa5ad3b6eb8feb2399a5d26c8fb0060561bb9534 upstream.

If the erase worker is unable to erase a PEB it will
free the ubi_wl_entry itself.
The failing ubi_wl_entry must not free()'d again after
do_sync_erase() returns.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/ubi/wl.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 0f3425dac910..89d51f94db11 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1211,7 +1211,6 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
 	err = do_sync_erase(ubi, e1, vol_id, lnum, 0);
 	if (err) {
-		kmem_cache_free(ubi_wl_entry_slab, e1);
 		if (e2)
 			kmem_cache_free(ubi_wl_entry_slab, e2);
 		goto out_ro;
@@ -1225,10 +1224,8 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
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
@@ -1264,10 +1261,9 @@ out_not_moved:
 
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
2.1.4

